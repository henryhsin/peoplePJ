//
// KKAudioMatrixMixerNode.m
//
// Copyright (c) 2014 KKBOX Taiwan Co., Ltd. All Rights Reserved.
//

#import "KKAudioMatrixMixerNode.h"

@implementation KKAudioMatrixMixerNode

- (AudioComponentDescription)unitDescription
{
	AudioComponentDescription mixerUnitDescription;
	bzero(&mixerUnitDescription, sizeof(AudioComponentDescription));
	mixerUnitDescription.componentType = kAudioUnitType_Mixer;
	mixerUnitDescription.componentSubType = kAudioUnitSubType_MatrixMixer;
	mixerUnitDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
	mixerUnitDescription.componentFlags = 0;
	mixerUnitDescription.componentFlagsMask = 0;
	return mixerUnitDescription;
}

@end
