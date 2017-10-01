//
// KKAudioGraph.m
//
// Copyright (c) 2014 KKBOX Taiwan Co., Ltd. All Rights Reserved.
//

#import "KKAudioGraph.h"
#import "KKAudioOutputNode.h"
#import "KKAudioEQEffectNode.h"
#import "KKAudioMixerNode.h"
#import "KKAudioFormat.h"
#import "KKMacros.h"

static OSStatus KKPlayerAURenderCallback(void *userData, AudioUnitRenderActionFlags *ioActionFlags, const AudioTimeStamp *inTimeStamp, UInt32 inBusNumber, UInt32 inNumberFrames, AudioBufferList *ioData);
static OSStatus KKPlayerCrossfadeAURenderCallback(void *userData, AudioUnitRenderActionFlags *ioActionFlags, const AudioTimeStamp *inTimeStamp, UInt32 inBusNumber, UInt32 inNumberFrames, AudioBufferList *ioData);
static void KKAudioUnitPropertyListenerProc(void *inRefCon, AudioUnit ci, AudioUnitPropertyID inID, AudioUnitScope inScope, AudioUnitElement inElement);

@interface KKAudioGraph ()
{
	AUGraph audioGraph;
	CGFloat volume;
	CGFloat normalizationGain;
	BOOL usingNormalization;
}
- (void)_zapAudioGraph;
- (void)_updateProperties;

@property (assign, nonatomic, getter=isPlaying) BOOL playing;
@property (strong, nonatomic) KKAudioOutputNode *outputNode;
@property (strong, nonatomic) KKAudioEQEffectNode *EQEffectNode;
@property (strong, nonatomic) KKAudioMixerNode *mixerNode;
@end

@implementation KKAudioGraph

- (void)dealloc
{
	[self _zapAudioGraph];
}

- (void)connectNode:(KKAudioNode *)from bus:(UInt32)fromBus toNode:(KKAudioNode *)to bus:(UInt32)toBus
{
	__unused OSStatus status = noErr;
	status = AUGraphConnectNodeInput(audioGraph, [from node], fromBus, [to node], toBus);
	NSAssert(noErr == status, @"We need to connect the nodes %d %% %@", (int)status, from, to);
}

- (void)connectNodes:(NSArray *)nodes
{
	for (NSInteger i = 0 ; i < [nodes count] - 1; i++) {
		[self connectNode:nodes[i] bus:0 toNode:nodes[i+1] bus:0];
	}
}

- (instancetype)init
{
	self = [super init];
	if (self) {

		__unused OSStatus status = noErr;

		// 1. Create the audio graph.
		status = NewAUGraph(&audioGraph);
		NSAssert(noErr == status, @"We need to create a new audio graph. %d", (int)status);
		status = AUGraphOpen(audioGraph);
		NSAssert(noErr == status, @"We need to open the audio graph. %d", (int)status);

		// 2. Create and connect nodes.
		self.outputNode = [[KKAudioOutputNode alloc] initWithAudioGraph:audioGraph];
		self.EQEffectNode = [[KKAudioEQEffectNode alloc] initWithAudioGraph:audioGraph];
		self.mixerNode = [[KKAudioMixerNode alloc] initWithAudioGraph:audioGraph];

		[self connectNodes:@[self.mixerNode, self.EQEffectNode, self.outputNode]];

		// 3. Set the mixer node.
		AudioStreamBasicDescription destFormat = KKSignedIntLinearPCMStreamDescription();
#ifdef KARAOKE
		self.mixerNode.busCount = 3;
#else
		self.mixerNode.busCount = 2;
#endif

		[self.mixerNode setInputAndOutputFormat:destFormat];
		[self.EQEffectNode setInputAndOutputFormat:destFormat];
		[self.outputNode setInputFormat:destFormat];

#ifdef KARAOKE
		UInt32 enable = 1;
		status = AudioUnitSetProperty(self.outputNode.audioUnit, kAudioOutputUnitProperty_EnableIO, kAudioUnitScope_Output, 0, &enable, sizeof(UInt32));
		NSAssert(noErr == status, @"%d", (int)status);
		status = AudioUnitSetProperty(self.outputNode.audioUnit, kAudioOutputUnitProperty_EnableIO, kAudioUnitScope_Input, 1, &enable, sizeof(UInt32));
		NSAssert(noErr == status, @"%d", (int)status);
		status = AudioUnitSetProperty(self.outputNode.audioUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Output, 1, &destFormat, sizeof(destFormat));
		NSAssert(noErr == status, @"%d", (int)status);
		[self connectNode:self.outputNode bus:1 toNode:self.mixerNode bus:2];
#endif

		// 4. Register callback to know if output unit of the audio graph is running.
		status = AudioUnitAddPropertyListener(self.outputNode.audioUnit, kAudioOutputUnitProperty_IsRunning, KKAudioUnitPropertyListenerProc, (__bridge void *)(self));
		NSAssert(noErr == status, @"We need to set the property listener to the output nodein order to know if we are playing or not. %d", (int)status);

		// 5. Register render callback.
		AURenderCallbackStruct callbackStruct;
		callbackStruct.inputProcRefCon = (__bridge void *)(self);

		callbackStruct.inputProc = KKPlayerCrossfadeAURenderCallback;
		status = AUGraphSetNodeInputCallback(audioGraph, self.mixerNode.node, 1, &callbackStruct);
		NSAssert(noErr == status, @"%d", (int)status);

		callbackStruct.inputProc = KKPlayerAURenderCallback;
		status = AUGraphSetNodeInputCallback(audioGraph, self.mixerNode.node, 0, &callbackStruct);
		NSAssert(noErr == status, @"%d", (int)status);

		// 6. Initialize the audio graph.
		self.volume = 1.0;
		AudioUnitInitialize(self.outputNode.audioUnit);
		status = AUGraphInitialize(audioGraph);
		NSAssert(noErr == status, @"We need to initialized the audio graph. %d", (int)status);
#if DEBUG
		CAShow(audioGraph);
#endif
		AudioOutputUnitStop(self.outputNode.audioUnit);
	}
	return self;
}

- (void)_zapAudioGraph
{
	Boolean isRunning = false;
	AUGraphIsRunning(audioGraph, &isRunning);
	if (isRunning) {
		AudioOutputUnitStop(self.outputNode.audioUnit);
		AUGraphStop(audioGraph);
		DisposeAUGraph(audioGraph);
	}
	AUGraphUninitialize(audioGraph);
	AUGraphClose(audioGraph);
	DisposeAUGraph(audioGraph);
}

- (BOOL)_outputNodePlaying
{
	UInt32 property = 0;
	UInt32 propertySize = sizeof(property);
	AudioUnitGetProperty(self.outputNode.audioUnit, kAudioOutputUnitProperty_IsRunning, kAudioUnitScope_Global, 0, &property, &propertySize);
	return property != 0;
}

- (void)_updateProperties
{
	BOOL outputNodePlaying = [self _outputNodePlaying];

	if (!self.playing && outputNodePlaying) {
		self.playing = YES;
		[self.delegate audioGraphDidStartPlaying:self];
	}
	else if (self.playing && !outputNodePlaying) {
		self.playing = NO;
		[self.delegate audioGraphDidStopPlaying:self];
	}
	else if (!self.playing && !outputNodePlaying){
		[self.delegate audioGraphDidStopPlaying:self];
	}
}

#pragma mark -

- (void)play
{
	if (self.playing) {
		return;
	}
	[self.delegate audioGraphWillStartPlaying:self];
	__unused OSStatus error = AUGraphStart(audioGraph);
	NSAssert(noErr == error, @"AuGraphStop, error: %ld", (signed long)error);
	// Note: When interrupts happen, iOS stops not only our audio
	// graph but also the output node. So, we need to start our output
	// node to make it able to resume playing.
	error = AudioOutputUnitStart(self.outputNode.audioUnit);
	NSAssert(noErr == error, @"AudioOutputUnitStart, error: %ld", (signed long)error);
}

- (void)pause
{
	if (!self.playing) {
		return;
	}
	__unused OSStatus error = AUGraphStop(audioGraph);
	NSAssert(noErr == error, @"AuGraphStop, error: %ld", (signed long)error);
	error = AudioOutputUnitStop(self.outputNode.audioUnit);
	NSAssert(noErr == error, @"AudioOutputUnitStart, error: %ld", (signed long)error);
}

#pragma mark -
#pragma mark Properties

- (void)updateVolumeLevel
{
	Float32 currentVolume = self.volume;
	if (self.usingNormalization) {
		Float32 fNorv = pow(10.0, self.normalizationGain/20.0);
		currentVolume = currentVolume * fNorv;
		if (currentVolume > 1.0) {
			currentVolume = 1.0;
		}
#if DEBUG
		NSLog(@"%s, NORV:%.2fdB, DeviceVolume:%.2f, CurrentVolume:%.2f", __PRETTY_FUNCTION__, self.normalizationGain, self.volume, currentVolume);
#endif
	}

	__unused OSStatus status = 0;
	status = AudioUnitSetParameter(self.mixerNode.audioUnit, kMultiChannelMixerParam_Volume, kAudioUnitScope_Output, 0, currentVolume, 0);
	NSAssert(noErr == status, @"AudioUnitSetParameter");
}


- (void)setVolume:(Float32)inVolume
{
	volume = inVolume;
	[self updateVolumeLevel];
}

- (Float32)volume
{
	return volume;
}

- (void)setNormalizationGain:(Float32)inNormalizationGain
{
	normalizationGain = inNormalizationGain;
	[self updateVolumeLevel];
}

- (Float32)normalizationGain
{
	return normalizationGain;
}

- (void)setUsingNormalization:(BOOL)inUsingNormalization
{
	usingNormalization = inUsingNormalization;
	[self updateVolumeLevel];
}

- (BOOL)isUsingNormalization
{
	return usingNormalization;
}

@end

@implementation KKAudioGraph (Mixer)

- (void)setVolume:(CGFloat)inVolume forBus:(UInt32)busNumber
{
	[self.mixerNode setVolume:inVolume forBus:busNumber];
}

- (void)setOutputPan:(CGFloat)pan
{
	[self.mixerNode setOutputPan:pan];
}

- (void)setPan:(CGFloat)pan forBus:(UInt32)busNumber
{
	[self.mixerNode setPan:pan forBus:busNumber];
}

@end


OSStatus KKPlayerAURenderCallback(void *userData, AudioUnitRenderActionFlags *ioActionFlags, const AudioTimeStamp *inTimeStamp, UInt32 inBusNumber, UInt32 inNumberFrames, AudioBufferList *ioData)
{
	KKAudioGraph *self = (__bridge KKAudioGraph *)userData;
	OSStatus status = [self.delegate audioGraph:self requestNumberOfFrames:inNumberFrames ioData:ioData busNumber:inBusNumber];
	if (!self.delegate || status != noErr) {
		ioData->mNumberBuffers = 0;
		*ioActionFlags |= kAudioUnitRenderAction_OutputIsSilence;
	}
	return status;
}

static OSStatus KKPlayerCrossfadeAURenderCallback(void *userData, AudioUnitRenderActionFlags *ioActionFlags, const AudioTimeStamp *inTimeStamp, UInt32 inBusNumber, UInt32 inNumberFrames, AudioBufferList *ioData)
{
	KKAudioGraph *self = (__bridge KKAudioGraph *)userData;
	OSStatus status = [self.delegate audioGraph:self requestNumberOfFramesForCrossfade:inNumberFrames ioData:ioData busNumber:inBusNumber];
	if (!self.delegate || status != noErr) {
		ioData->mNumberBuffers = 0;
		*ioActionFlags |= kAudioUnitRenderAction_OutputIsSilence;
	}
	return status;
}

void KKAudioUnitPropertyListenerProc(void *inRefCon, AudioUnit ci, AudioUnitPropertyID inID, AudioUnitScope inScope, AudioUnitElement inElement)
{
	KKAudioGraph *self = (__bridge KKAudioGraph *)inRefCon;
	[self _updateProperties];
}

