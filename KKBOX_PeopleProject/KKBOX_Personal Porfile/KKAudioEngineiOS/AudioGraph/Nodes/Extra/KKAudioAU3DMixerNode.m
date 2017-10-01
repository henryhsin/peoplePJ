//
// KKAudioAU3DMixerNode.m
//
// Copyright (c) 2014 KKBOX Taiwan Co., Ltd. All Rights Reserved.
//

#import "KKAudioAU3DMixerNode.h"

@implementation KKAudioAU3DMixerNode

- (AudioComponentDescription)unitDescription
{
	AudioComponentDescription mixerUnitDescription;
	bzero(&mixerUnitDescription, sizeof(AudioComponentDescription));
	mixerUnitDescription.componentType = kAudioUnitType_Mixer;
	mixerUnitDescription.componentSubType = kAudioUnitSubType_AU3DMixerEmbedded;
	mixerUnitDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
	mixerUnitDescription.componentFlags = 0;
	mixerUnitDescription.componentFlagsMask = 0;
	return mixerUnitDescription;
}

@end
