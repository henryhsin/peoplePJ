//
// KKAudioEngineOperation.h
//
// Copyright (c) 2014 KKBOX Taiwan Co., Ltd. All Rights Reserved.
//

@import Foundation;
@import AudioToolbox;

@class KKAudioEngineOperation;

@protocol KKAudioEngineOperationDelegate <NSObject>
- (void)audioEngineOperationDidHaveEnoughDataToStartPlaying:(nonnull KKAudioEngineOperation *)operation;
- (void)audioEngineOperationDidHaveEnoughDataToResumePlaying:(nonnull KKAudioEngineOperation *)operation;
- (void)audioEngineOperationDidCompleteLoading:(nonnull KKAudioEngineOperation *)operation;
- (void)audioEngineOperationDidEndReadingBuffer:(nonnull KKAudioEngineOperation *)operation;
- (void)audioEngineOperation:(nonnull KKAudioEngineOperation *)operation didFailLoadingWithError:(nonnull NSError *)error;
- (void)audioEngineOperation:(nonnull KKAudioEngineOperation *)operation didFindID3tags:(nonnull NSDictionary *)inID3Tags;
- (void)audioEngineOperationDidEnd:(nonnull KKAudioEngineOperation *)operation;

// in background thread
- (BOOL)audioEngineOperationShouldBeginCrossfade:(nonnull KKAudioEngineOperation *)operation;
// in background thread
- (void)audioEngineOperationDidRequestBeginCrossfade:(nonnull KKAudioEngineOperation *)operation;
@end

@interface KKAudioEngineOperation : NSOperation

- (nonnull instancetype)initWithSuggestedFileType:(AudioFileTypeID)inTypeID;

/*!
 An interface to let the audio graph's render callback function to
 read conveted Linear PCM data from the opearion.

 @param inNumberOfFrames How many frames does audio graph's render
 callback function require.
 @param inIoData the aduio buffer lists which stored converted Linear
 PCM data.
 @param inBusNumber the bus numer. The render callback function may be
 bound on a mixer node. Since a mixer node accepts inputs from
 multiple buses, we can use the parameter to identify which bus is
 requesting audio data.
 */
- (OSStatus)readNumberOfFrames:(UInt32)inNumberOfFrames intoIoData:(nonnull AudioBufferList *)inIoData forBusNumber:(UInt32)inBusNumber;

@property (weak, nonatomic, nullable) id <KKAudioEngineOperationDelegate> delegate;
@property (strong, nonatomic ,nullable) id contextInfo;

/*! The current playback time of the operation. Change the property to
 do random seek. */
@property (assign, nonatomic) NSTimeInterval currentTime;
/*! How long does the desired audio stream should be. The property
 should be set outside of the operation, such as set by using
 external metadata. */
@property (assign, nonatomic) NSTimeInterval expectedDuration;
/*! How much playable packets are loaded. */
@property (readonly, nonatomic) NSTimeInterval loadedDuration;
/*! If the audio stream is continuous or not. A continuous audio
stream might be an Internet radio station.*/
@property (readonly, nonatomic) BOOL isContinuousStream;
/*! The current loading progress. */
@property (readonly, nonatomic) double loadedPercentage;
/*! If the audio stream is fully loading or not. */
@property (readonly, nonatomic) BOOL loaded;
/*! If the audio stream is stalled. It means the stream is not fully
loaded and we do not have enough packets to play since the speed of
the current connection is too slow, therefore we need to wait for the
connections to bring more packets. */
@property (assign, nonatomic) BOOL stalled;
/*! ID3 tags contained in current audio stream. */
@property (readonly, nonatomic, nullable) NSDictionary *ID3Tags;

/*! If we have enough packets to start playing. */
@property (readonly, nonatomic) BOOL hasEnoughDataToPlay;

@property (assign, nonatomic) NSTimeInterval crossfadeDuration;
@end

@interface KKAudioEngineOperation ()
@property (readonly, nonatomic) double packetsPerSecond;
@end

