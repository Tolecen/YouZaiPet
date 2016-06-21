//
//  AnimationImg.h
//  TalkingPet
//
//  Created by Tolecen on 14-7-11.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct animationImg{
    NSInteger tagID;
    CGFloat width;
    CGFloat height;
    CGFloat centerX;
    CGFloat centerY;
    CGFloat rotationX;
    CGFloat rotationY;
    CGFloat rotationZ;
}AnimationImg;
NS_INLINE AnimationImg animationImgMake(NSInteger tagID,CGFloat width,CGFloat height,CGFloat centerX,CGFloat centerY,CGFloat rotationX,CGFloat rotationY,CGFloat rotationZ){
    AnimationImg animation = {tagID,width,height,centerX,centerY,rotationX,rotationY,rotationZ};
    return animation;
}
NS_INLINE NSString * stringWithAnimationImg(AnimationImg animationImg){
    return [NSString stringWithFormat:@"{%ld,%f,%f,%f,%f,%f,%f,%f}",(long)animationImg.tagID,animationImg.width,animationImg.height,animationImg.centerX,animationImg.centerY,animationImg.rotationX,animationImg.rotationY,animationImg.rotationZ];
}
NS_INLINE AnimationImg animationImgWithString(NSString * string){
    string = [string substringWithRange:NSMakeRange(1,string.length-2)];
    NSArray * arr = [string componentsSeparatedByString:@","];
    if (arr.count == 8) {
        return animationImgMake([arr[0] integerValue],[arr[1] floatValue],[arr[2] floatValue],[arr[3] floatValue],[arr[4] floatValue],[arr[5] floatValue],[arr[6] floatValue],[arr[7] floatValue]);
    }
    return animationImgMake(0,0,0,0,0,0,0,0);
}