//
// KKAudioNode+FactoryPresets.m
//
// Copyright (c) 2015 KKBOX Taiwan Co., Ltd. All Rights Reserved.
//

#import "KKAudioNode+FactoryPresets.h"
#import <objc/runtime.h>

@implementation KKAudioNode (FactoryPresets)

- (void)selectPreset:(NSInteger)value
{
	AUPreset *aPreset = (AUPreset*)CFArrayGetValueAtIndex(self.factoryPresets, value);
	OSStatus status = AudioUnitSetProperty(self.audioUnit, kAudioUnitProperty_PresentPreset, kAudioUnitScope_Global, 0, aPreset, sizeof(AUPreset));
	assert(noErr == status);
}

- (CFArrayRef)factoryPresets
{
	CFArrayRef array = (__bridge CFArrayRef)objc_getAssociatedObject(self, "Presets");
	if (!array) {
		__unused OSStatus status = noErr;
		UInt32 size = sizeof(array);
		status = AudioUnitGetProperty(self.audioUnit, kAudioUnitProperty_FactoryPresets, kAudioUnitScope_Global, 0, &array, &size);
		objc_setAssociatedObject(self, "Presets", (__bridge id)(array), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	return array;
}

@end
