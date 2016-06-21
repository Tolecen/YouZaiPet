//

//  TalkingTableViewCellDelegate.h
//  TalkingPet
//
//  Created by wangxr on 14-7-20.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TalkingBrowse;
@class TalkComment;
@protocol TalkingTableViewCellDelegate <NSObject>
@optional
- (void)forwardWithTalkingBrowse: (TalkingBrowse *)talkingBrowse;
- (void)commentWithTalkingBrowse: (TalkingBrowse *)talkingBrowse;
- (void)zanWithTalkingBrowse: (TalkingBrowse *)talkingBrowse;
- (void)shareWithTalkingBrowse: (TalkingBrowse *)talkingBrowse;
- (void)attentionPetWithTalkingBrowse: (TalkingBrowse *)talkingBrowse;
- (void)petProfileWhoPublishTalkingBrowse: (TalkingBrowse *)talkingBrowse;
- (void)petProfileWhoForwardTalkingBrowse: (TalkingBrowse *)talkingBrowse;
- (void)locationWithTalkingBrowse: (TalkingBrowse *)talkingBrowse;
- (void)storyClickedTalkingBrowse: (TalkingBrowse *)talkingBrowse;
-(void)contentImageVClicked:(UITableViewCell *)cell CellType:(int)cellType;
-(void)commentPlayAudioBtnClicked:(TalkComment *)talkingCommentN Cell:(id)cell;
-(void)commentPublisherBtnClicked:(TalkComment *)talkingCommentN;
-(void)deleteCommentBtnClicked:(TalkComment *)talkingCommentN CellIndex:(NSInteger)cellIndex;
-(void)commentAimUserNameClicked:(TalkComment *)talkingCommentN Link:(NSTextCheckingResult*)linkInfo;
-(void)commentPublisherNameClicked:(TalkComment *)talkingCommentN;
-(void)tagBtnClickedWithTagId:(NSDictionary *)tagId;
-(void)attentionBtnClicked:(UITableViewCell *)cell;
-(void)avatarClickedId:(NSString *)petId;
-(void)addZanToZanArray:(NSDictionary *)petDict cellIndex:(int)cellIndex;

@end
