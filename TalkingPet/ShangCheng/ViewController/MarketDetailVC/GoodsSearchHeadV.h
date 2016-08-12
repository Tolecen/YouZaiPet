//
//  GoodsSearchHeadV.h
//  TalkingPet
//
//  Created by cc on 16/8/11.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void(^btnClickBlock)(NSInteger index);

@interface GoodsSearchHeadV : UICollectionReusableView

/**
 *  未选中时的文字颜色,默认黑色
 */
@property (nonatomic,strong) UIColor *titleNomalColor;

/**
 *  选中时的文字颜色,默认红色
 */
@property (nonatomic,strong) UIColor *titleSelectColor;

/**
 *  字体大小，默认15
 */
@property (nonatomic,strong) UIFont  *titleFont;

/**
 *  默认选中的index=1，即第一个
 */
@property (nonatomic,assign) NSInteger defaultIndex;

/**
 *  点击后的block
 */
@property (nonatomic,copy)btnClickBlock block;

@property (nonatomic,copy)NSArray *titleArr;



@end
