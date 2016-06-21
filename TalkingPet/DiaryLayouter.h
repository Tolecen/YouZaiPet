//
//  DiaryLayouter.h
//  TalkingPet
//
//  Created by wangxr on 15/6/2.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TalkingBrowse;

@interface DiaryLayouter : NSObject
@property (nonatomic,copy)BOOL(^haveBlankPage)();
+(NSInteger)totalPage:(int)petalkCount;
+(BOOL)haveBlankPage:(int)petalkCount;
-(id)initWithTotalPage:(NSInteger)totalPage LayoutBlock:(TalkingBrowse* (^)(NSInteger index))block;
-(void)setLayouterView:(UIView*)view;
-(void)layoutDiaryViewWithIndex:(NSInteger)index;
@end
