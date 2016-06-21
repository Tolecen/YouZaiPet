//
//  PlayAnimationImg.h
//  TalkingPet
//
//  Created by Tolecen on 14-8-9.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayAnimationImg : NSObject
@property (nonatomic,strong) NSString * fileName;
@property (nonatomic,strong) NSString * fileType;
@property (nonatomic,strong) NSString * fileUrlStr;
@property (assign,nonatomic) CGFloat width;
@property (assign,nonatomic) CGFloat height;
@property (assign,nonatomic) CGFloat centerX;
@property (assign,nonatomic) CGFloat centerY;
@property (assign,nonatomic) CGFloat rotationX;
@property (assign,nonatomic) CGFloat rotationY;
@property (assign,nonatomic) CGFloat rotationZ;
@end
