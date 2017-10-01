//
// KKAudioEngineHTTPOperation.h
//
// Copyright (c) 2014 KKBOX Taiwan Co., Ltd. All Rights Reserved.
//

#import "KKAudioEngineOperation.h"

/*! The operation for playing HTTP streams. */
@interface KKAudioEngineHTTPOperation : KKAudioEngineOperation

- (nonnull instancetype)initWithURL:(nonnull NSURL *)inURL suggestedFileType:(AudioFileTypeID)inTypeID;

@property (readonly, nonatomic, nonnull) NSURL *URL;
@end
