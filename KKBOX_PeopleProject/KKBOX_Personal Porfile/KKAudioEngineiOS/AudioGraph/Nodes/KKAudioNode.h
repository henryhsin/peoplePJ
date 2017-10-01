//
// KKAudioNode.h
//
// Copyright (c) 2014 KKBOX Taiwan Co., Ltd. All Rights Reserved.
//

@import Foundation;
@import AudioToolbox;

@interface KKAudioNode : NSObject

- (instancetype)initWithAudioGraph:(AUGraph)audioGraph;
- (void)setInputAndOutputFormat:(AudioStreamBasicDescription)destFormat;
- (void)setInputFormat:(AudioStreamBasicDescription)destFormat;
- (void)setOutputFormat:(AudioStreamBasicDescription)destFormat;

@property (readonly, nonatomic) AUNode node;
@property (readonly, nonatomic) AudioUnit audioUnit;
@end

@interface KKAudioNode ()
@property (readonly, nonatomic) AudioComponentDescription unitDescription;
@end