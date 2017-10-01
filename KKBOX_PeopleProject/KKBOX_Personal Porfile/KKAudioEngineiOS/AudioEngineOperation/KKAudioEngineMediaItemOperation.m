//
// KKAudioEngineMediaItemOperation.m
//
// Copyright (c) 2014 KKBOX Taiwan Co., Ltd. All Rights Reserved.
//

@import AVFoundation;
#import "KKAudioEngineMediaItemOperation.h"
#import "KKAudioEngineOperation+Privates.h"
#import "KKAudioFormat.h"

@interface KKAudioEngineMediaItemOperation ()
{
	NSTimeInterval crossfadeDuration;
}
@property (strong, nonatomic) NSURL *URL;
@property (strong, nonatomic) AVAudioFile *audioFile;
@property (strong, nonatomic) AVAudioPCMBuffer *audioBuffer;
@property (assign, nonatomic) NSTimeInterval internalCrossfadeDuration;
@property (assign, nonatomic) BOOL crossfadeEverCalled;
@end

@implementation KKAudioEngineMediaItemOperation

- (nonnull instancetype)initWithMediaItem:(MPMediaItem *)item
{
	NSParameterAssert(item);
	self = [super init];
	if (self) {
		self.URL = item.assetURL;
		self.audioFile = [[AVAudioFile alloc] initForReading:self.URL commonFormat:AVAudioPCMFormatInt16 interleaved:YES error:nil];
		self.audioBuffer = [[AVAudioPCMBuffer alloc] initWithPCMFormat:self.audioFile.processingFormat frameCapacity:4096];
		self.parser = nil;
		self.converter = nil;
		self.buffer = nil;
	}
	return self;
}

- (void)main
{
	@autoreleasepool {
		dispatch_sync(dispatch_get_main_queue(), ^{
			[self.delegate audioEngineOperationDidHaveEnoughDataToStartPlaying:self];
			[self.delegate audioEngineOperationDidCompleteLoading:self];
		});

		[self wait];

		dispatch_sync(dispatch_get_main_queue(), ^{
			[self.delegate audioEngineOperationDidEnd:self];
		});
	}
}

- (BOOL)detectIfReadingBufferEnds
{
	if (self.audioFile.length <= self.audioFile.framePosition) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.delegate audioEngineOperationDidEndReadingBuffer:self];
		});
		return YES;
	}
	else if (self.crossfadeDuration > 0) {
		if (self.crossfadeEverCalled) {
			return NO;
		}
		double sampleRate = self.audioFile.processingFormat.sampleRate;
		if (self.audioFile.length < self.internalCrossfadeDuration * sampleRate) {
			return NO;
		}
		if (self.audioFile.length - self.audioFile.framePosition > self.internalCrossfadeDuration * sampleRate) {
			return NO;
		}
		if (![self.delegate audioEngineOperationShouldBeginCrossfade:self]) {
			return NO;
		}
		self.crossfadeEverCalled = YES;
		[self.delegate audioEngineOperationDidRequestBeginCrossfade:self];
		return NO;
	}
	return NO;
}

- (OSStatus)readNumberOfFrames:(UInt32)inNumberOfFrames intoIoData:(nonnull AudioBufferList *)inIoData forBusNumber:(UInt32)inBusNumber
{
	if ([self detectIfReadingBufferEnds]) {
		return -1;
	}

	NSError *error = nil;
	[self.audioFile readIntoBuffer:self.audioBuffer frameCount:inNumberOfFrames error:&error];
	inIoData->mBuffers[0].mNumberChannels = self.audioBuffer.audioBufferList->mBuffers[0].mNumberChannels;
	inIoData->mBuffers[0].mDataByteSize = self.audioBuffer.audioBufferList->mBuffers[0].mDataByteSize;
	inIoData->mBuffers[0].mData = self.audioBuffer.audioBufferList->mBuffers[0].mData;

	if (self.audioFile.length <= self.audioFile.framePosition) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.delegate audioEngineOperationDidEndReadingBuffer:self];
		});
		return -1;
	}
	return noErr;
}

- (NSTimeInterval)currentTime
{
	AVAudioFramePosition framePosition = self.audioFile.framePosition;
	double sampleRate = self.audioFile.processingFormat.sampleRate;
	if (sampleRate == 0) {
		return 0;
	}
	return framePosition / sampleRate;
}

- (void)setCurrentTime:(NSTimeInterval)currentTime
{
	double sampleRate = self.audioFile.processingFormat.sampleRate;
	self.audioFile.framePosition = currentTime * sampleRate;
}

- (NSTimeInterval)expectedDuration
{
	double sampleRate = self.audioFile.processingFormat.sampleRate;
	return self.audioFile.length /sampleRate;
}

- (NSTimeInterval)loadedDuration
{
	double sampleRate = self.audioFile.processingFormat.sampleRate;
	return self.audioFile.length /sampleRate;
}

- (BOOL)loaded
{
	return YES;
}

- (BOOL)stalled
{
	return NO;
}

- (BOOL)hasEnoughDataToPlay
{
	return YES;
}

- (NSTimeInterval)crossfadeDuration
{
	return crossfadeDuration;
}

- (void)setCrossfadeDuration:(NSTimeInterval)inCrossfadeDuration
{
	crossfadeDuration = inCrossfadeDuration;
	self.internalCrossfadeDuration = (self.loaded && self.loadedDuration - self.currentTime < crossfadeDuration) ? 0 : crossfadeDuration;
}


@end

