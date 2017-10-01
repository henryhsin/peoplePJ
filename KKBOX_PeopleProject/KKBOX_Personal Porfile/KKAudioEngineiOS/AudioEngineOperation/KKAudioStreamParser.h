//
// KKAudioStreamParser.h
//
// Copyright (c) 2014 KKBOX Taiwan Co., Ltd. All Rights Reserved.
//

@import Foundation;
@import AudioToolbox;

@class KKAudioStreamParser;

@protocol KKAudioStreamParserDelegate <NSObject>
- (void)audioStreamParser:(nonnull KKAudioStreamParser *)inParser didObtainPacketData:(nonnull const void *)inData count:(size_t)inPacketCount descriptions:(nonnull AudioStreamPacketDescription *)inPacketDescriptions;
- (void)audioStreamParser:(nonnull KKAudioStreamParser *)inParser didObtainStreamDescription:(nonnull AudioStreamBasicDescription *)inDescription;
@optional
- (void)audioStreamParser:(nonnull KKAudioStreamParser *)inParser didObtainID3Tags:(nonnull NSDictionary *)inID3Tags;
@end

@interface KKAudioStreamParser : NSObject

- (nonnull instancetype)initWithSuggestedFileType:(AudioFileTypeID)inTypeID;
- (BOOL)feedByteData:(nonnull const void *)inByteData length:(size_t)inLength;

@property (weak, nonatomic, nullable) id <KKAudioStreamParserDelegate> delegate;
@property (readonly, nonatomic) NSUInteger totalParsedBytes;
@end
