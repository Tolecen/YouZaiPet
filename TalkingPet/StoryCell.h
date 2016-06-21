//
//  StoryCell.h
//  TalkingPet
//
//  Created by wangxr on 15/7/10.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoryCell : UICollectionViewCell
-(void)layoutWithTitle:(NSString*)title time:(NSString*)time cover:(UIImage*)cover;
-(void)layoutWithImage:(UIImage *)image text:(NSString*)text  lineFeed:(BOOL)feed haveAudio:(BOOL)avdio;
-(void)layoutWithText:(NSString*)text;
-(void)layoutWithAddress:(NSString*)address lineFeed:(BOOL)feed time:(NSString*)time;
-(void)layoutBackCover;
@end
