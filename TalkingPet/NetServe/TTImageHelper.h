//
//  TTImageHelper.h
//  TalkingPet
//
//  Created by Tolecen on 14-8-8.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImage+Resize.h"
@interface TTImageHelper : NSObject
+(UIImage*)compressImageDownToPhoneScreenSize:(UIImage*)theImage targetSizeX:(CGFloat) sizeX targetSizeY:(CGFloat) sizeY;
+(UIImage*)cutImage:(UIImage*)theImage targetSizeX:(CGFloat) sizeX targetSizeY:(CGFloat) sizeY;
+(UIImage *)blurImage:(UIImage *)image;
@end
