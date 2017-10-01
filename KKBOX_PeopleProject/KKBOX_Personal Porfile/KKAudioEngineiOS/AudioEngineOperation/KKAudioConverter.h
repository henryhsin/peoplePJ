//
// KKAudioConverter.h
//
// Copyright (c) 2014 KKBOX Taiwan Co., Ltd. All Rights Reserved.
//

@import Foundation;
@import AudioToolbox;
#import "KKAudioStreamBuffer.h"

@interface KKAudioConverter : NSObject

- (nonnull instancetype)initWithSourceFormat:(nonnull AudioStreamBasicDescription *)sourceFormat;
- (void)reset;
- (OSStatus)convertDataFromBuffer:(nonnull KKAudioStreamBuffer *)buffer numberOfFrames:(UInt32)inNumberOfFrames ioData:(nonnull AudioBufferList *)inIoData convertedFrameCount:(nonnull UInt32 *)convertedFrameCount;

@property (readonly, nonatomic) AudioStreamBasicDescription audioStreamDescription;
@property (readonly, nonatomic) double packetsPerSecond;
@end

