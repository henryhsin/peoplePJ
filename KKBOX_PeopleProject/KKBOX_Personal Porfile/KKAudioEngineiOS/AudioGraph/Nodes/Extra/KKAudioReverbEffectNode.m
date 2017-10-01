//
// KKAudioReverbEffectNode.m
//
// Copyright (c) 2014 KKBOX Taiwan Co., Ltd. All Rights Reserved.
//

#import "KKAudioReverbEffectNode.h"

@implementation KKAudioReverbEffectNode

- (AudioComponentDescription)unitDescription
{
	AudioComponentDescription reverbEffectUnitDescription;
	bzero(&reverbEffectUnitDescription, sizeof(AudioComponentDescription));
	reverbEffectUnitDescription.componentType = kAudioUnitType_Effect;
	reverbEffectUnitDescription.componentSubType = kAudioUnitSubType_Reverb2;
	reverbEffectUnitDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
	reverbEffectUnitDescription.componentFlags = 0;
	reverbEffectUnitDescription.componentFlagsMask = 0;
	return reverbEffectUnitDescription;
}

@end
