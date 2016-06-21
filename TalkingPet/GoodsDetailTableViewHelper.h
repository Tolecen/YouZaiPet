//
//  GoodsDetailTableViewHelper.h
//  TalkingPet
//
//  Created by Tolecen on 15/6/12.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EGOImageButton.h"
@protocol GoodsDetailTableViewHelperDelegate <NSObject>
@optional
-(void)resetContentSize;

@end
@interface GoodsDetailTableViewHelper : NSObject<GoodsDetailTableViewHelperDelegate,EGOImageButtonDelegate>
@property (nonatomic,assign) id <GoodsDetailTableViewHelperDelegate>delegate;
@property (nonatomic,strong) UIScrollView * bgScrollV;
-(id)initWithTableview:(UIView *)theTable PicArray:(NSArray *)array;
-(void)loadContent;
@end
