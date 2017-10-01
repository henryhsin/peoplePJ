//
// KKAudioEngineMediaItemOperation.h
//
// Copyright (c) 2014 KKBOX Taiwan Co., Ltd. All Rights Reserved.
//

@import MediaPlayer;
#import "KKAudioEngineOperation.h"

/*! The operation for playing songs in iPod library. */
@interface KKAudioEngineMediaItemOperation : KKAudioEngineOperation

- (nonnull instancetype)initWithMediaItem:(nonnull MPMediaItem *)item;

@end
