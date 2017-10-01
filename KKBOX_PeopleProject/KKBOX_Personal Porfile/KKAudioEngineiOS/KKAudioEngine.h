//
// KKAudioEngine.h
//
// Copyright (c) 2014 KKBOX Taiwan Co., Ltd. All Rights Reserved.
//

@import Foundation;
@import AudioToolbox;
@import MediaPlayer;
#import "KKAudioGraph.h"
#import "KKAudioEngineOperation.h"

@class KKAudioEngine;

@protocol KKAudioEngineDelegate <NSObject>
- (void)audioEngineWillStartPlaying:(nonnull KKAudioEngine *)audioEngine;
- (void)audioEngineDidStartPlaying:(nonnull KKAudioEngine *)audioEngine;
- (void)audioEngineDidPausePlaying:(nonnull KKAudioEngine *)audioEngine;
- (void)audioEngineDidStall:(nonnull KKAudioEngine *)audioEngine;
- (void)audioEngineDidEndCurrentPlayback:(nonnull KKAudioEngine *)audioEngine;
- (void)audioEngineDidEndPlaying:(nonnull KKAudioEngine *)audioEngine;

- (void)audioEngineDidHaveEnoughDataToStartPlaying:(nonnull KKAudioEngine *)audioEngine;
- (void)audioEngineDidHaveEnoughDataToResumePlaying:(nonnull KKAudioEngine *)audioEngine;

- (void)audioEngineDidComplateLoading:(nonnull KKAudioEngine *)audioEngine;
- (void)audioEngine:(nonnull KKAudioEngine *)audioEngine didFailLoadingWithError:(nonnull NSError *)error;
- (void)audioEngine:(nonnull KKAudioEngine *)audioEngine didFailLoadingNextAudioWithError:(nonnull NSError *)error contextInfo:(nullable id)contextInfo;

- (void)audioEngine:(nonnull KKAudioEngine *)audioEngine updateCurrentPlaybackTime:(NSTimeInterval)currentTime loadedDuration:(NSTimeInterval)loadedDuration;

@optional
- (void)audioEngine:(nonnull KKAudioEngine *)audioEngine didFindID3tags:(nonnull NSDictionary *)inID3Tags inOperation:(nonnull KKAudioEngineOperation *)operation;
- (void)audioEngine:(nonnull KKAudioEngine *)audioEngine didStartPlayingOperation:(nonnull KKAudioEngineOperation *)operation;
- (void)audioEngine:(nonnull KKAudioEngine *)audioEngine didEndPlayingOperation:(nonnull KKAudioEngineOperation *)operation;
- (void)audioEngineDidBeginInterrupt:(nonnull KKAudioEngine *)audioEngine;
- (void)audioEngineDidEndInterrupt:(nonnull KKAudioEngine *)audioEngine;
- (void)audioEngine:(nonnull KKAudioEngine *)audioEngine didChangeAudioRouteFrom:(nonnull AVAudioSessionRouteDescription *)previousRoute reason:(AVAudioSessionRouteChangeReason)reason;
@end

// func audioEngineWillStartPlaying(audioEngine: KKAudioEngine!)
// func audioEngineDidStartPlaying(audioEngine: KKAudioEngine!)
// func audioEngineDidPausePlaying(audioEngine: KKAudioEngine!)
// func audioEngineDidStall(audioEngine: KKAudioEngine!)
// func audioEngineDidEndCurrentPlayback(audioEngine: KKAudioEngine!)
// func audioEngineDidEndPlaying(audioEngine: KKAudioEngine!)
// func audioEngineDidHaveEnoughDataToStartPlaying(audioEngine: KKAudioEngine!)
// func audioEngineDidHaveEnoughDataToResumePlaying(audioEngine: KKAudioEngine!)
// func audioEngineDidComplateLoading(audioEngine: KKAudioEngine!)
// func audioEngine(audioEngine: KKAudioEngine!, didFailLoadingWithError error: NSError!)
// func audioEngine(audioEngine: KKAudioEngine!, didFailLoadingNextAudioWithError error: NSError!, contextInfo: AnyObject!)
// func audioEngine(audioEngine: KKAudioEngine!, updateCurrentPlaybackTime currentTime: NSTimeInterval, loadedDuration: NSTimeInterval)
// func audioEngine(audioEngine: KKAudioEngine!, didFindID3tags inID3Tags: [NSObject : AnyObject]!, inOperation operation: KKAudioEngineOperation!)
// func audioEngine(audioEngine: KKAudioEngine!, didStartPlayingOperation operation: KKAudioEngineOperation!)
// func audioEngine(audioEngine: KKAudioEngine!, didEndPlayingOperation operation: KKAudioEngineOperation!)
// func audioEngineDidBeginInterrupt(audioEngine: KKAudioEngine!)
// func audioEngineDidEndInterrupt(audioEngine: KKAudioEngine!)
// func audioEngine(audioEngine: KKAudioEngine!, didChangeAudioRouteFrom previousRoute: AVAudioSessionRouteDescription!, reason: AVAudioSessionRouteChangeReason)


#pragma mark -

@interface KKAudioEngine : NSObject

#pragma mark Loading resources

- (void)loadAudioWithURL:(nonnull NSURL *)inURL suggestedFileType:(AudioFileTypeID)inTypeID contextInfo:(nullable id)contextInfo;
- (void)loadNextAudioWithURL:(nonnull NSURL *)inURL suggestedFileType:(AudioFileTypeID)inTypeID contextInfo:(nullable id)contextInfo;

- (void)loadMediaItem:(nonnull MPMediaItem *)mediaItem contextInfo:(nullable id)contextInfo;
- (void)loadNextMediaItem:(nonnull MPMediaItem *)mediaItem contextInfo:(nullable id)contextInfo;

#pragma mark Playback controls

- (void)play;
- (void)pause;
- (void)stop;
- (void)cancelNextOperation;

#pragma mark Basic properties

/*! The delegate object. */
@property (weak, nonatomic) id <KKAudioEngineDelegate> delegate;
/*! Volume of the player. 0.0 to 1.0 */
@property (assign, nonatomic) CGFloat volume;
@property (assign, nonatomic, getter=isUsingNormalization) BOOL usingNormalization;
@end

@interface KKAudioEngine (CurrentAudioProperties)
#pragma mark Properties for current audio resource
@property (readonly, nonatomic) BOOL hasCurrentOperation;
@property (readonly, nonatomic, getter=isCurrentSongTrackFullyLoaded) BOOL currentSongTrackFullyLoaded;
@property (readonly, nonatomic, nullable) id currentContextInfo;
@property (readonly, nonatomic, getter=isPlaying) BOOL playing;
@property (readonly, nonatomic, getter=isPlayingContinuousStream) BOOL playingContinuousStream;
@property (assign, nonatomic) NSTimeInterval currentTime;
@property (readonly, nonatomic) NSTimeInterval expectedDuration;
@property (readonly, nonatomic) NSTimeInterval loadedDuration;
@property (readonly, nonatomic) CGFloat loadedPercentage;
@property (readonly, nonatomic, nullable) NSDictionary *ID3Tags;
@property (assign, nonatomic) NSTimeInterval crossfadeDuration;
@property (assign, nonatomic) BOOL crossfadeWithPanning;
@property (assign, nonatomic) BOOL usingVocalRemoval;
@end

@interface KKAudioEngine (NextAudioProperties)
#pragma mark Properties for next audio resource
@property (readonly, nonatomic) BOOL hasNextOperation;
@property (readonly, nonatomic, nullable) id nextContextInfo;
@end

@interface KKAudioEngine (AudioGraph)
@property (readonly, nonatomic, nonnull) KKAudioGraph * audioGraph;
@end
