//
// KKAudioNode.m
//
// Copyright (c) 2014 KKBOX Taiwan Co., Ltd. All Rights Reserved.
//

#import "KKAudioNode.h"

@interface KKAudioNode ()
{
	AUNode node;
	AudioUnit audioUnit;
}
- (void)makeAudioUnitWithAudioGraph:(AUGraph)audioGraph;
@end

@implementation KKAudioNode


- (void)dealloc
{
	AudioComponentInstanceDispose(audioUnit);
}

- (instancetype)initWithAudioGraph:(AUGraph)audioGraph
{
	self = [super init];
	if (self) {
		__unused OSStatus status = noErr;
		AudioComponentDescription unitDescription = [self unitDescription];
		status = AUGraphAddNode(audioGraph, &unitDescription, &node);
		NSAssert(noErr == status, @"We need to create the node. %@, %d", NSStringFromClass([self class]), (int)status);
		[self makeAudioUnitWithAudioGraph:audioGraph];
	}
	return self;
}

- (void)makeAudioUnitWithAudioGraph:(AUGraph)audioGraph
{
	__unused OSStatus status = noErr;
	AudioComponentDescription unitDescription = [self unitDescription];
	status = AUGraphNodeInfo(audioGraph, node, &unitDescription, &audioUnit);
	NSAssert(noErr == status, @"We need to get the audio unit of the node. %@, %d",  NSStringFromClass([self class]), (int)status);

	// If the screen of an iOS device is locked, the audio API
	// will ask for more frames per slice (FPS) in order to save
	// energy. According to Apple's documentation, we need to set
	// kAudioUnitProperty_MaximumFramesPerSlice to 4096 to all
	// nodes in the current audio unit graph.

	// See
	// - http://developer.apple.com/library/ios/#documentation/Audio/Conceptual/AudioSessionProgrammingGuide/Cookbook/Cookbook.html
	// - http://developer.apple.com/library/ios/#qa/qa1606/_index.html
	__unused UInt32 maxFPS = 4096;
	status = AudioUnitSetProperty(self.audioUnit, kAudioUnitProperty_MaximumFramesPerSlice, kAudioUnitScope_Global, 0,&maxFPS, sizeof(maxFPS));
	NSAssert(noErr == status, @"We need to set the maximum FPS(Frame Per Slice) to the EQ effect node. %d", (int)status);
}

- (AudioComponentDescription)unitDescription
{
	// Subclasses should override it.
	AudioComponentDescription unitDescription;
	bzero(&unitDescription, sizeof(AudioComponentDescription));
	return unitDescription;
}

- (void)setInputAndOutputFormat:(AudioStreamBasicDescription)destFormat
{
	[self setInputFormat:destFormat];
	[self setOutputFormat:destFormat];
}

- (void)setInputFormat:(AudioStreamBasicDescription)destFormat
{
	__unused OSStatus status = noErr;
	status = AudioUnitSetProperty(self.audioUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input, 0, &destFormat, sizeof(destFormat));
	NSAssert(noErr == status, @"We need to set input format of the mixer effect node. %d", (int)status);
}

- (void)setOutputFormat:(AudioStreamBasicDescription)destFormat
{
	__unused OSStatus status = noErr;
	status = AudioUnitSetProperty(self.audioUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Output, 0, &destFormat, sizeof(destFormat));
	NSAssert(noErr == status, @"We need to set input format of the mixer effect node. %d", (int)status);
}

@synthesize node;
@synthesize audioUnit;
@end
