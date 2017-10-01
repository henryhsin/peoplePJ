//
// KKAudioEngine.m
//
// Copyright (c) 2014 KKBOX Taiwan Co., Ltd. All Rights Reserved.
//

#import "KKAudioEngine.h"
#import "KKAudioEngineHTTPOperation.h"
#import "KKAudioEngineFileOperation.h"
#import "KKAudioEngineMediaItemOperation.h"

@interface KKAudioEngine ()
{
	NSTimeInterval crossfadeDuration;
	BOOL crossfadeWithPanning;
}
@property (strong, nonatomic) KKAudioGraph *audioGraph;
@property (strong, nonatomic) NSOperationQueue *operationQueue;
@property (strong, nonatomic) KKAudioEngineOperation *previousOperation;
@property (strong, nonatomic) KKAudioEngineOperation *currentOperation;
@property (strong, nonatomic) KKAudioEngineOperation *nextOperation;
@property (assign, nonatomic) BOOL usingVocalRemoval;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) BOOL userDesiresPlayback;
@end

@interface KKAudioEngine (Timer)
- (void)beginTimer;

- (void)endTimer;
@end

@interface KKAudioEngine (KKAudioEngineOperationDelegate) <KKAudioEngineOperationDelegate>
@end

@interface KKAudioEngine (KKAudioGraphDelegate) <KKAudioGraphDelegate>
@end

@interface KKAudioEngine (PreviousOperation)
- (void)resetPreviousOperation;
@end

@interface KKAudioEngine (AudioSession)
- (void)handleInterrupt:(NSNotification *)n;

- (void)handleAudioRouteChange:(NSNotification *)n;

- (void)handleMediaServerReset:(NSNotification *)n;
@end

@implementation KKAudioEngine

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[self.currentOperation cancel];
	self.currentOperation = nil;
	[self.nextOperation cancel];
	self.nextOperation = nil;
	[self.operationQueue cancelAllOperations];
}

- (instancetype)init
{
	self = [super init];
	if (self) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInterrupt:) name:AVAudioSessionInterruptionNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAudioRouteChange:) name:AVAudioSessionRouteChangeNotification object:nil];
		// https://developer.apple.com/library/ios/qa/qa1749/_index.html
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMediaServerReset:) name:AVAudioSessionMediaServicesWereResetNotification object:nil];

		/* On iOS 8, it is very possible that our applications are
		opened in background by push notification or Apple Watch
		apps. If we call AUGraphInitialize() before setting proper audio
		session category and set audio session to active, we will get
		an error and cannot do playback then.

		So, we need to set audio session to active here, since
		initializing KKAudioGraph calls AUGraphInitialize().*/

#ifdef KARAOKE
		[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
		[[AVAudioSession sharedInstance] setPreferredIOBufferDuration:0.005 error:nil];
#else
		[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
#endif
		[[AVAudioSession sharedInstance] setActive:YES error:nil];
		self.audioGraph = [[KKAudioGraph alloc] init];
		self.audioGraph.delegate = self;
		self.operationQueue = [[NSOperationQueue alloc] init];
	}
	return self;
}

- (void)_loadCurrentOperation:(KKAudioEngineOperation *)op
{
	[self resetPreviousOperation];
	self.userDesiresPlayback = YES;

	[self.currentOperation cancel];
	self.currentOperation = nil;
	[self.nextOperation cancel];
	self.nextOperation = nil;
	[self.operationQueue cancelAllOperations];

	self.currentOperation = op;
	self.currentOperation.delegate = self;
	self.currentOperation.crossfadeDuration = self.crossfadeDuration;
	[self.operationQueue addOperation:self.currentOperation];
}

- (void)_loadNextOperation:(KKAudioEngineOperation *)op
{
	[self.nextOperation cancel];
	self.nextOperation = nil;

	self.nextOperation = op;
	self.nextOperation.crossfadeDuration = self.crossfadeDuration;
	[self.operationQueue addOperation:self.nextOperation];
}

- (void)loadAudioWithURL:(NSURL *)inURL suggestedFileType:(AudioFileTypeID)inTypeID contextInfo:(id)contextInfo
{
	Class cls = [inURL isFileURL] ? [KKAudioEngineFileOperation class] : [KKAudioEngineHTTPOperation class];
	KKAudioEngineOperation *op = [(KKAudioEngineFileOperation *) [cls alloc] initWithURL:inURL suggestedFileType:inTypeID];
	op.contextInfo = contextInfo;
	[self _loadCurrentOperation:op];
}

- (void)loadNextAudioWithURL:(NSURL *)inURL suggestedFileType:(AudioFileTypeID)inTypeID contextInfo:(id)contextInfo
{
	Class cls = [inURL isFileURL] ? [KKAudioEngineFileOperation class] : [KKAudioEngineHTTPOperation class];
	KKAudioEngineOperation *op = [(KKAudioEngineFileOperation *) [cls alloc] initWithURL:inURL suggestedFileType:inTypeID];
	op.contextInfo = contextInfo;
	[self _loadNextOperation:op];
}

- (void)loadMediaItem:(nonnull MPMediaItem *)mediaItem contextInfo:(id)contextInfo
{
	if (!mediaItem.assetURL) {
		return;
	}
	KKAudioEngineMediaItemOperation *op = [[KKAudioEngineMediaItemOperation alloc] initWithMediaItem:mediaItem];
	op.contextInfo = contextInfo;
	[self _loadCurrentOperation:op];
}

- (void)loadNextMediaItem:(nonnull MPMediaItem *)mediaItem contextInfo:(nullable id)contextInfo
{
	if (!mediaItem.assetURL) {
		return;
	}
	KKAudioEngineMediaItemOperation *op = [[KKAudioEngineMediaItemOperation alloc] initWithMediaItem:mediaItem];
	op.contextInfo = contextInfo;
	[self _loadNextOperation:op];
}

- (void)play
{
	if (!self.currentOperation) {
		self.userDesiresPlayback = NO;
		return;
	}
	self.userDesiresPlayback = YES;
	[self resetPreviousOperation];
#ifdef KARAOKE
	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
	[[AVAudioSession sharedInstance] setPreferredIOBufferDuration:0.005 error:nil];
#else
	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
#endif
	[[AVAudioSession sharedInstance] setActive:YES error:nil];
	[self.audioGraph play];
}

- (void)pause
{
	if (!self.currentOperation) {
		self.userDesiresPlayback = NO;
		return;
	}
	self.userDesiresPlayback = NO;
	[self resetPreviousOperation];
	[self.audioGraph pause];
	[[AVAudioSession sharedInstance] setActive:NO error:nil];
}

- (void)stop
{
	if (!self.currentOperation) {
		self.userDesiresPlayback = NO;
		return;
	}
	self.userDesiresPlayback = NO;
	[self resetPreviousOperation];
	[self.audioGraph pause];
	[self.currentOperation cancel];
	self.currentOperation = nil;
	[self.nextOperation cancel];
	self.nextOperation = nil;
	[[AVAudioSession sharedInstance] setActive:NO error:nil];
}

- (void)cancelNextOperation
{
	if (self.nextOperation) {
		[self.nextOperation cancel];
		self.nextOperation = nil;
	}
}

#pragma mark -

- (id)currentContextInfo
{
	return self.currentOperation.contextInfo;
}

- (CGFloat)volume
{
	return self.audioGraph.volume;
}

- (void)setVolume:(CGFloat)volume
{
	[self.audioGraph setVolume:volume];
}

- (BOOL)isUsingNormalization
{
	return self.audioGraph.usingNormalization;
}

- (void)setUsingNormalization:(BOOL)usingNormalization
{
	self.audioGraph.usingNormalization = usingNormalization;
}

@end

@implementation KKAudioEngine (CurrentAudioProperties)

- (BOOL)hasCurrentOperation
{
	return self.currentOperation != nil;
}

- (BOOL)isCurrentSongTrackFullyLoaded
{
	return self.currentOperation != nil && !self.currentOperation.isContinuousStream && self.currentOperation.loaded;
}

- (BOOL)isPlaying
{
	return self.audioGraph.playing;
}

- (BOOL)isPlayingContinuousStream
{
	return self.currentOperation ? self.currentOperation.isContinuousStream : NO;
}

- (NSTimeInterval)currentTime
{
	return self.currentOperation ? self.currentOperation.currentTime : 0;
}

- (void)setCurrentTime:(NSTimeInterval)currentTime
{
	[self resetPreviousOperation];
	BOOL playing = self.audioGraph.playing;
	if (playing) {
		[self.audioGraph pause];
	}
	self.currentOperation.currentTime = currentTime;
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		if (playing) {
			[self.audioGraph play];
		}
	});
}

- (NSTimeInterval)expectedDuration
{
	return self.currentOperation ? self.currentOperation.expectedDuration : 0;
}

- (NSTimeInterval)loadedDuration
{
	return self.currentOperation ? self.currentOperation.loadedDuration : 0;
}

- (CGFloat)loadedPercentage
{
	return (CGFloat) (self.currentOperation ? self.currentOperation.loadedPercentage : 0);
}

- (NSDictionary *)ID3Tags
{
	return self.currentOperation.ID3Tags;
}

- (NSTimeInterval)crossfadeDuration
{
	return crossfadeDuration;
}

- (void)setCrossfadeDuration:(NSTimeInterval)incrossfadeDuration
{
	[self resetPreviousOperation];
	crossfadeDuration = incrossfadeDuration;
	self.currentOperation.crossfadeDuration = self.crossfadeDuration;
	self.nextOperation.crossfadeDuration = self.crossfadeDuration;
}

- (BOOL)crossfadeWithPanning
{
	return crossfadeWithPanning;
}

- (void)setCrossfadeWithPanning:(BOOL)inCrossfadeWithPanning
{
	crossfadeWithPanning = inCrossfadeWithPanning;
}

- (void)endCurrentOperation
{
	[self.currentOperation cancel];
	self.currentOperation = nil;

	if (self.nextOperation) {
		self.currentOperation = self.nextOperation;
		self.currentOperation.delegate = self;
		self.nextOperation = nil;
		if (self.currentOperation.hasEnoughDataToPlay) {
			self.currentOperation.stalled = NO;
			[self.audioGraph play];
		}
		else {
			self.currentOperation.stalled = YES;
		}
		[self.delegate audioEngineDidEndCurrentPlayback:self];
	}
	else {
		[self.delegate audioEngineDidEndCurrentPlayback:self];
		[self.delegate audioEngineDidEndPlaying:self];
	}
}

@end


@implementation KKAudioEngine (NextAudioProperties)

- (BOOL)hasNextOperation
{
	return self.nextOperation != nil;
}

- (id)nextContextInfo
{
	return self.nextOperation.contextInfo;
}

@end

@implementation KKAudioEngine (KKAudioEngineOperationDelegate)

- (void)audioEngineOperationDidHaveEnoughDataToStartPlaying:(KKAudioEngineOperation *)operation
{
	if (operation != self.currentOperation) {
		return;
	}
	[self.delegate audioEngineDidHaveEnoughDataToStartPlaying:self];
	[self.audioGraph play];
	if ([self.delegate respondsToSelector:@selector(audioEngine:didStartPlayingOperation:)]) {
		[self.delegate audioEngine:self didStartPlayingOperation:self.currentOperation];
	}
}

- (void)audioEngineOperationDidHaveEnoughDataToResumePlaying:(KKAudioEngineOperation *)operation
{
	if (operation != self.currentOperation) {
		return;
	}
	[self.audioGraph play];
	[self.delegate audioEngineDidHaveEnoughDataToResumePlaying:self];
}

- (void)audioEngineOperationDidCompleteLoading:(KKAudioEngineOperation *)operation
{
	if (operation != self.currentOperation) {
		return;
	}
	[self.delegate audioEngineDidComplateLoading:self];
}

- (void)audioEngineOperationDidEndReadingBuffer:(KKAudioEngineOperation *)operation
{
	if (operation == self.previousOperation) {
		self.previousOperation = nil;
		return;
	}

	if (operation != self.currentOperation) {
		return;
	}

	if (operation.loaded) {
		[self endCurrentOperation];
	}
	else {
		[self.audioGraph pause];
		self.currentOperation.stalled = YES;
		[self.delegate audioEngineDidStall:self];
	}
}

- (void)audioEngineOperation:(KKAudioEngineOperation *)operation didFailLoadingWithError:(NSError *)error
{
	if (operation == self.nextOperation) {
		[self.delegate audioEngine:self didFailLoadingNextAudioWithError:error contextInfo:self.nextOperation.contextInfo];
		self.nextOperation = nil;
		return;
	}

	[self.audioGraph pause];
	[self.delegate audioEngine:self didFailLoadingWithError:error];
}

- (void)audioEngineOperation:(KKAudioEngineOperation *)operation didFindID3tags:(NSDictionary *)inID3Tags
{
	if ([self.delegate respondsToSelector:@selector(audioEngine:didFindID3tags:inOperation:)]) {
		[self.delegate audioEngine:self didFindID3tags:inID3Tags inOperation:operation];
	}

	if (inID3Tags[@"NORV"]) {
		double gain = [inID3Tags[@"NORV"] doubleValue];
		[self.audioGraph setNormalizationGain:gain];
	}
}

- (void)audioEngineOperationDidEnd:(KKAudioEngineOperation *)operation
{
	if (operation == self.previousOperation) {
		self.previousOperation = nil;
	}
	if (operation == self.currentOperation) {
		self.currentOperation = nil;
	}
	if (operation == self.nextOperation) {
		self.nextOperation = nil;
	}
}

- (BOOL)audioEngineOperationShouldBeginCrossfade:(KKAudioEngineOperation *)operation
{
	if (operation == self.currentOperation) {
		return self.nextOperation != nil && !self.nextOperation.isContinuousStream && self.nextOperation.hasEnoughDataToPlay;
	}
	return NO;
}

- (void)audioEngineOperationDidRequestBeginCrossfade:(KKAudioEngineOperation *)operation
{
	self.previousOperation = self.currentOperation;
	self.currentOperation = nil;
	dispatch_async(dispatch_get_main_queue(), ^{
		[self endCurrentOperation];
	});
	[self.audioGraph setVolume:0.0 forBus:0];
	[self.audioGraph setVolume:1.0 forBus:1];
}

@end


@implementation KKAudioEngine (KKAudioGraphDelegate)

static void VocalRemoval(void *bytes, UInt32 size) {
	// Always assuming that we have 2 channels, and 2 bytes/channel
	size_t sampleCount = size / 4;

	for (size_t i = 0; i < sampleCount * 4; i += 4) {
		short *sp = (short *) (bytes + i);
		short left = *sp;
		short right = *(sp + 1);
		short new = (left - right);
		*sp = new;
		*(sp + 1) = new;
	}
}

- (OSStatus)audioGraph:(KKAudioGraph *)audioGraph requestNumberOfFrames:(UInt32)inNumberOfFrames ioData:(AudioBufferList *)inIoData busNumber:(UInt32)inBusNumber
{
	if (self.currentOperation == self.previousOperation) {
		return -1;
	}
	if (!self.currentOperation) {
		return -1;
	}
	OSStatus status = [self.currentOperation readNumberOfFrames:inNumberOfFrames intoIoData:inIoData forBusNumber:inBusNumber];
	if (self.usingVocalRemoval) {
		VocalRemoval(inIoData->mBuffers[0].mData, inIoData->mBuffers[0].mDataByteSize);
	}
	return status;
}

- (OSStatus)audioGraph:(KKAudioGraph *)audioGraph requestNumberOfFramesForCrossfade:(UInt32)inNumberOfFrames ioData:(AudioBufferList *)inIoData busNumber:(UInt32)inBusNumber
{
	if (!self.previousOperation) {
		return -1;
	}
	OSStatus status = [self.previousOperation readNumberOfFrames:inNumberOfFrames intoIoData:inIoData forBusNumber:inBusNumber];
	if (self.usingVocalRemoval) {
		VocalRemoval(inIoData->mBuffers[0].mData, inIoData->mBuffers[0].mDataByteSize);
	}
	if (self.currentOperation.crossfadeDuration) {
		CGFloat currentVolume = (CGFloat) (self.currentOperation.currentTime / self.currentOperation.crossfadeDuration);
		CGFloat previousVolume = (CGFloat) (1.0 - currentVolume);
		[self.audioGraph setVolume:(CGFloat) (currentVolume / 2.0 + 0.5) forBus:0];
		[self.audioGraph setVolume:(CGFloat) (previousVolume / 2.0 + 0.5) forBus:1];
		if (self.crossfadeWithPanning) {
			[self.audioGraph setPan:-1 + currentVolume forBus:0];
			[self.audioGraph setPan:currentVolume forBus:1];
		}
	}
	return status;
}

- (void)audioGraphWillStartPlaying:(KKAudioGraph *)audioGraph
{
	[[AVAudioSession sharedInstance] setActive:YES error:nil];
	[self.delegate audioEngineWillStartPlaying:self];
}

- (void)audioGraphDidStartPlaying:(KKAudioGraph *)audioGraph
{
	dispatch_async(dispatch_get_main_queue(), ^{
		[self beginTimer];
		[self.delegate audioEngineDidStartPlaying:self];
		self.currentOperation.stalled = NO;
	});
}

- (void)audioGraphDidStopPlaying:(KKAudioGraph *)audioGraph
{
	dispatch_async(dispatch_get_main_queue(), ^{
		[self endTimer];
		[self.delegate audioEngineDidPausePlaying:self];
	});
}

@end

@implementation KKAudioEngine (PreviousOperation)

- (void)resetPreviousOperation
{
	self.previousOperation = nil;
	[self.audioGraph setVolume:1.0 forBus:0];
	[self.audioGraph setVolume:0.0 forBus:1];
	[self.audioGraph setPan:0 forBus:0];
	[self.audioGraph setPan:0 forBus:1];
}

@end

@implementation KKAudioEngine (Timer)

- (void)_updatePlaybackTime:(NSTimer *)inTimer
{
	[self.delegate audioEngine:self updateCurrentPlaybackTime:self.currentTime loadedDuration:self.loadedDuration];
}

- (void)beginTimer
{
	[self.timer invalidate];
	self.timer = nil;
	self.timer = [NSTimer timerWithTimeInterval:1.0 / 60.0 target:self selector:@selector(_updatePlaybackTime:) userInfo:nil repeats:YES];
	[[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
	[[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)endTimer
{
	[self.timer invalidate];
	self.timer = nil;
}

@end

@implementation KKAudioEngine (AudioSession)

- (void)handleMediaServerReset:(NSNotification *)n
{
	// https://developer.apple.com/library/ios/qa/qa1749/_index.html
	// ...Re-initializing generally requires disposing all of an
	// application's now orphaned audio objects (for example
	// AudioQueue, AURemoteIO, AudioConverter and so on since none of
	// them will function as expected), and re-creating them as if the
	// application was starting up for the first time. Any errors
	// returned during disposing can safely be ignored.

	[[AVAudioSession sharedInstance] setActive:YES error:nil];
	self.audioGraph = [[KKAudioGraph alloc] init];
	self.audioGraph.delegate = self;
	self.currentOperation = nil;
	self.nextOperation = nil;
	self.previousOperation = nil;
	[self.delegate audioEngineDidEndPlaying:self];
}

- (void)handleInterrupt:(NSNotification *)n
{
	if (!self.currentOperation) {
		return;
	}

	BOOL type = [n.userInfo[AVAudioSessionInterruptionTypeKey] boolValue];
	// AVAudioSessionInterruptionTypeBegan
	if (type == AVAudioSessionInterruptionTypeBegan) {
		// Note: on iOS 8, our audio graph would be stopped before the
		// notification for interruption is being fired. Thus, we use
		// another flag "userDesiresPlayback" to determine if we
		// should resume playback after interruption ends or not.
		if (self.playing) {
			[self pause];
		}
		if ([self.delegate respondsToSelector:@selector(audioEngineDidBeginInterrupt:)]) {
			[self.delegate audioEngineDidBeginInterrupt:self];
		}
		return;
	}

	// AVAudioSessionInterruptionTypeEnded
	BOOL shouldResume = [n.userInfo[AVAudioSessionInterruptionOptionKey] boolValue];
	if (shouldResume && self.userDesiresPlayback) {
		[self play];
	}
	if ([self.delegate respondsToSelector:@selector(audioEngineDidEndInterrupt:)]) {
		[self.delegate audioEngineDidEndInterrupt:self];
	}
}

- (void)handleAudioRouteChange:(NSNotification *)n
{
	if (!self.currentOperation) {
		return;
	}

	// Note: the notification is fired in background thread.
	dispatch_sync(dispatch_get_main_queue(), ^{
		if ([self.delegate respondsToSelector:@selector(audioEngine:didChangeAudioRouteFrom:reason:)]) {
			AVAudioSessionRouteChangeReason reason = (AVAudioSessionRouteChangeReason) [n.userInfo[AVAudioSessionRouteChangeReasonKey] unsignedIntegerValue];
			AVAudioSessionRouteDescription *route = n.userInfo[AVAudioSessionRouteChangePreviousRouteKey];
			[self.delegate audioEngine:self didChangeAudioRouteFrom:route reason:reason];
		}
	});
}

@end
