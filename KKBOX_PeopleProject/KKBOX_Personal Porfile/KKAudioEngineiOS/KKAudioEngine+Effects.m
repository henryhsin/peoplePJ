//
// KKAudioEngine+Effects.m
//
// Copyright (c) 2014 KKBOX Taiwan Co., Ltd. All Rights Reserved.
//

#import "KKAudioEngine+Effects.h"
#import "KKAudioNode+FactoryPresets.h"
#import "KKAudioEQEffectNode.h"
#import "KKAudioReverbEffectNode.h"
#import <objc/runtime.h>

@interface KKAudioGraph (Privates)
@property (strong, nonatomic) KKAudioEQEffectNode *EQEffectNode;
@property (strong, nonatomic) KKAudioReverbEffectNode *reverbEffectNode;
@end

@implementation KKAudioEngine (Effects)

- (CFArrayRef)iPodEQPresetsArray
{
	return self.audioGraph.EQEffectNode.factoryPresets;
}

- (void)selectEQPreset:(NSInteger)value
{
	[self.audioGraph.EQEffectNode selectPreset:value];
}

- (CFArrayRef)reverbEffectPresetsArray
{
	return self.audioGraph.reverbEffectNode.factoryPresets;
}

- (void)selectReverbEffectPreset:(NSInteger)value
{
	[self.audioGraph.reverbEffectNode selectPreset:value];
}

@end
