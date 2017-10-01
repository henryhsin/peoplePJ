//
// KKAudioNode+FactoryPresets.h
//
// Copyright (c) 2015 KKBOX Taiwan Co., Ltd. All Rights Reserved.
//

#import "KKAudioNode.h"

@interface KKAudioNode (FactoryPresets)
- (void)selectPreset:(NSInteger)value;
@property (readonly) CFArrayRef factoryPresets;
@end
