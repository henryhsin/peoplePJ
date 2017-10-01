//
// KKAudioEngine+Effects.h
//
// Copyright (c) 2014 KKBOX Taiwan Co., Ltd. All Rights Reserved.
//

#import "KKAudioEngine.h"

@interface KKAudioEngine (Effects)
@property (readonly, nonatomic) CFArrayRef iPodEQPresetsArray;
- (void)selectEQPreset:(NSInteger)value;

@property (readonly, nonatomic) CFArrayRef reverbEffectPresetsArray;
- (void)selectReverbEffectPreset:(NSInteger)value;

@end
