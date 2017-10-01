//
// KKAudioEngineFileOperation.h
//
// Copyright (c) 2014 KKBOX Taiwan Co., Ltd. All Rights Reserved.
//

#import "KKAudioEngineOperation.h"

/*! The operation for playing local files. */
@interface KKAudioEngineFileOperation : KKAudioEngineOperation

- (nonnull instancetype)initWithURL:(nonnull NSURL *)inURL suggestedFileType:(AudioFileTypeID)inTypeID;

@end
