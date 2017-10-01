//
// KKAudioPCMFormatConverterNode.m
//
// Copyright (c) 2014 KKBOX Taiwan Co., Ltd. All Rights Reserved.
//

#import "KKAudioPCMFormatConverterNode.h"

@implementation KKAudioPCMFormatConverterNode

- (AudioComponentDescription)unitDescription
{
	AudioComponentDescription converterUnitDescription;
	bzero(&converterUnitDescription, sizeof(AudioComponentDescription));
	converterUnitDescription.componentType = kAudioUnitType_FormatConverter;
	converterUnitDescription.componentSubType = kAudioUnitSubType_AUConverter;
	converterUnitDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
	converterUnitDescription.componentFlags = 0;
	converterUnitDescription.componentFlagsMask = 0;
	return converterUnitDescription;
}

@end
