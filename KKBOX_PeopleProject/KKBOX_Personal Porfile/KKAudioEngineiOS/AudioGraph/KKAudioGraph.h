//
// KKAudioGraph.h
//
// Copyright (c) 2014 KKBOX Taiwan Co., Ltd. All Rights Reserved.
//

@import Foundation;
@import AudioToolbox;
@import AVFoundation;

@class KKAudioGraph;

@protocol KKAudioGraphDelegate <NSObject>
- (OSStatus)audioGraph:(nonnull KKAudioGraph *)audioGraph requestNumberOfFrames:(UInt32)inNumberOfFrames ioData:(nonnull AudioBufferList  *)inIoData busNumber:(UInt32)inBusNumber;
- (OSStatus)audioGraph:(nonnull KKAudioGraph *)audioGraph requestNumberOfFramesForCrossfade:(UInt32)inNumberOfFrames ioData:(nonnull AudioBufferList  *)inIoData busNumber:(UInt32)inBusNumber;
- (void)audioGraphWillStartPlaying:(nonnull KKAudioGraph *)audioGraph;
- (void)audioGraphDidStartPlaying:(nonnull KKAudioGraph *)audioGraph;
- (void)audioGraphDidStopPlaying:(nonnull KKAudioGraph *)audioGraph;
@end

@interface KKAudioGraph : NSObject

- (void)play;
- (void)pause;

@property (weak, nonatomic, nullable) id <KKAudioGraphDelegate> delegate;
@property (assign, nonatomic) Float32 volume;
@property (assign, nonatomic) Float32 normalizationGain;
@property (assign, nonatomic, getter=isUsingNormalization) BOOL usingNormalization;
@property (readonly, nonatomic, getter=isPlaying) BOOL playing;
@end

@interface KKAudioGraph (Mixer)
- (void)setVolume:(CGFloat)volume forBus:(UInt32)busNumber;
- (void)setOutputPan:(CGFloat)pan;
- (void)setPan:(CGFloat)pan forBus:(UInt32)busNumber;
@end

