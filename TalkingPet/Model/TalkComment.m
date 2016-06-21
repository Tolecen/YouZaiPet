//
//  TalkComment.m
//  TalkingPet
//
//  Created by Tolecen on 14-8-9.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "TalkComment.h"
#import "TalkingBrowse.h"
#import "NSAttributedString+Attributes.h"
#import "OHASBasicHTMLParser.h"

@implementation TalkComment
- (id)initWithHostInfo:(NSDictionary*)info
{
    self = [super init];
    if (self) {
        self.petID = [info objectForKey:@"petId"];
        self.commentId = [info objectForKey:@"id"];
        self.petAvatarURL = [info objectForKey:@"petHeadPortrait"];
        self.petNickname = [info objectForKey:@"petNickName"];
        self.commentType = [info objectForKey:@"type"];
        if (![info objectForKey:@"commentAudioUrl"]||[[info objectForKey:@"commentAudioUrl"] isEqualToString:@""]) {
            self.contentType = @"TEXT";
            self.content = [info objectForKey:@"comment"]?[info objectForKey:@"comment"]:@"暂时没有评论";
        }
        else
        {
            self.contentType = @"AUDIO";
            self.audioUrl = [info objectForKey:@"commentAudioUrl"];
            self.audioDuration = [info objectForKey:@"commentAudioSecond"];
            self.content = @"语音评论";
        }
        
        self.aimPetNickname = [info objectForKey:@"aimPetNickName"];
        
        if ([[info allKeys] containsObject:@"petalkId"]) {
            self.talkId = [info objectForKey:@"petalkId"];
        }
        if ([[info allKeys] containsObject:@"thumbUrl"]) {
            self.talkThumbnail = [info objectForKey:@"thumbUrl"];
        }
        if ([[info allKeys] containsObject:@"decorations"]) {
            self.talking = [[TalkingBrowse alloc] initWithHostInfo:info];
        }
        
        self.commentTime = [NSString stringWithFormat:@"%.0f",(double)([[info objectForKey:@"createTime"] longLongValue]/1000)];
        if ([info objectForKey:@"relayTime"]) {
            self.usercenterCommentTime = [NSString stringWithFormat:@"%.0f",(double)([[info objectForKey:@"relayTime"] longLongValue]/1000)];
        }
        
        self.aimPetID = [info objectForKey:@"aimPetId"];
        if (!self.aimPetID||[self.aimPetID isEqualToString:@""]) {
            self.haveAimPet = NO;
        }
        else
            self.haveAimPet = YES;
        
        if (self.haveAimPet) {
            if ([self.contentType isEqualToString:@"AUDIO"]) {
                self.content = [NSString stringWithFormat:@"回复@%@:",self.aimPetNickname];
            }
            else
            {
                self.content = [NSString stringWithFormat:@"回复@%@:%@",self.aimPetNickname,self.content];
            }
            
        }
        else
            self.content = self.content;
        
        
//        self.contentStr = [OHASBasicHTMLParser attributedStringByProcessingMarkupInString:self.content];
//        OHParagraphStyle* paragraphStyle = [OHParagraphStyle defaultParagraphStyle];
//        paragraphStyle.textAlignment = kCTJustifiedTextAlignment;
//        paragraphStyle.lineBreakMode = kCTLineBreakByWordWrapping;
//        paragraphStyle.firstLineHeadIndent = 0.f; // indentation for first line
//        paragraphStyle.lineSpacing = 5.f; // increase space between lines by 3 points
//        [self.contentStr setParagraphStyle:paragraphStyle];
//        [self.contentStr setFont:[UIFont systemFontOfSize:14]];
//        [self.contentStr setTextAlignment:kCTTextAlignmentLeft lineBreakMode:kCTLineBreakByWordWrapping];
//        [self.contentStr setTextColor:[UIColor colorWithWhite:120/255.0f alpha:1]];
        

        
    }
    return self;
}
- (id)initWithHuDongCommentInfo:(NSDictionary*)info
{
    self = [super init];
    if (self) {
        self.petID = [info objectForKey:@"petId"];
        self.commentId = [info objectForKey:@"id"];
        self.petAvatarURL = [info objectForKey:@"petAvatar"]?[info objectForKey:@"petAvatar"]:@"";
        self.petNickname = [info objectForKey:@"petNickName"];
        self.commentType = @"C";

        self.contentType = @"TEXT";
        self.content = [info objectForKey:@"comment"]?[info objectForKey:@"comment"]:@"暂时没有评论";
       
        self.aimPetNickname = [info objectForKey:@"atPetNickName"];
        

        
        self.commentTime = [NSString stringWithFormat:@"%.0f",(double)([[info objectForKey:@"createTime"] longLongValue]/1000)];

        
        self.aimPetID = [info objectForKey:@"atPetId"];
        if (!self.aimPetID||[self.aimPetID isEqualToString:@""]||[self.aimPetID isEqualToString:@" "]) {
            self.haveAimPet = NO;
        }
        else
            self.haveAimPet = YES;
        
        if (self.haveAimPet) {
            if ([self.contentType isEqualToString:@"AUDIO"]) {
                self.content = [NSString stringWithFormat:@"回复@%@:",self.aimPetNickname];
            }
            else
            {
                self.content = [NSString stringWithFormat:@"回复@%@:%@",self.aimPetNickname,self.content];
            }
            
        }
        else
            self.content = self.content;
        
        
//        self.contentStr = [OHASBasicHTMLParser attributedStringByProcessingMarkupInString:self.content];
//        OHParagraphStyle* paragraphStyle = [OHParagraphStyle defaultParagraphStyle];
//        paragraphStyle.textAlignment = kCTJustifiedTextAlignment;
//        paragraphStyle.lineBreakMode = kCTLineBreakByWordWrapping;
//        paragraphStyle.firstLineHeadIndent = 0.f; // indentation for first line
//        paragraphStyle.lineSpacing = 5.f; // increase space between lines by 3 points
//        [self.contentStr setParagraphStyle:paragraphStyle];
//        [self.contentStr setFont:[UIFont systemFontOfSize:14]];
//        [self.contentStr setTextAlignment:kCTTextAlignmentLeft lineBreakMode:kCTLineBreakByWordWrapping];
//        [self.contentStr setTextColor:[UIColor colorWithWhite:120/255.0f alpha:1]];
        
        
        
    }
    return self;
}
@end
