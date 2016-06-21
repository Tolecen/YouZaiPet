//
//  ShouHuoInfoTableViewCell.h
//  TalkingPet
//
//  Created by Tolecen on 15/4/8.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"
@protocol ShouHuoCellDelegate <NSObject>

@optional
-(void)heightChanged:(CGFloat)height text:(NSString *)text cellIndex:(int)cellIndex;
@end
@interface ShouHuoInfoTableViewCell : UITableViewCell<UITextViewDelegate>
@property (nonatomic,strong) UILabel * titleL;
@property (strong,nonatomic) UITextView *textView;
@property (strong,nonatomic) UILabel * placeHolderL;
@property (strong,nonatomic) NSString * placeholderStr;
@property (nonatomic,assign) id<ShouHuoCellDelegate>delegate;
@property (nonatomic,assign) int cellIndex;
@end
