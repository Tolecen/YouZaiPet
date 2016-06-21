//
//  PetalkView.m
//  TalkingPet
//
//  Created by wangxr on 15/5/14.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "PetalkView.h"
#import "EGOImageView.h"
#import "TFileManager.h"

@interface PetalkView ()
{
    UIImageView * typeImageView;
}
@property (nonatomic,retain)PlayAnimationImg * animation;
@property (nonatomic,retain)EGOImageView * imageView;
@property (nonatomic,retain)UIImageView * mouthView;
@end
@implementation PetalkView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.imageView = [[EGOImageView alloc] init];
        [self addSubview:_imageView];
        self.mouthView = [[UIImageView alloc] init];
        [self addSubview:_mouthView];
        typeImageView = [[UIImageView alloc] init];
        [self addSubview:typeImageView];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.imageView = [[EGOImageView alloc] init];
        [self addSubview:_imageView];
        self.mouthView = [[UIImageView alloc] init];
        [self addSubview:_mouthView];
        typeImageView = [[UIImageView alloc] init];
        [self addSubview:typeImageView];
        _imageView.frame = frame;
        typeImageView.frame = CGRectMake(0, 0, frame.size.width/5, frame.size.height/5);
    }
    return self;
}
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _imageView.frame = frame;
    typeImageView.frame = CGRectMake(0, 0, frame.size.width/5, frame.size.height/5);
}
- (void)setAnimation:(PlayAnimationImg *)animation
{
    if ([animation isEqual:_animation]) {
        return;
    }
    _animation = animation;
    
    _mouthView.transform = CGAffineTransformIdentity;
    _mouthView.image = nil;
    _mouthView.animationImages = nil;
    
    if (!animation) {
        return;
    }
    NSString * zapName = [NSString stringWithFormat:@"%@.zip",_animation.fileName];
    void(^success)(NSString * zipfileName) = ^(NSString *zipfileName) {
        if ([[zipfileName stringByTrimmingCharactersInSet:[NSMutableCharacterSet characterSetWithCharactersInString:@".zip"]] isEqualToString:_animation.fileName]) {
            float width = self.frame.size.width;
            float height = self.frame.size.height;
            [_mouthView setFrame:CGRectMake(0, 0, animation.width*width, animation.height*height)];
            _mouthView.center = CGPointMake(animation.centerX*width, animation.centerY*height);
            _mouthView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, animation.rotationZ);
            _mouthView.image = [TFileManager getFristImageWithID:animation.fileName];
        }
    };
    if ([TFileManager ifExsitFolder:animation.fileName]) {
        success(zapName);
    }else
    {
        [NetServer downloadZipFileWithUrl:animation.fileUrlStr ZipName:zapName Success:success failure:nil];
    }
    
}
- (void)play
{
    _mouthView.animationImages = [TFileManager getAllImagesWithID:_animation.fileName];
    _mouthView.animationDuration = _mouthView.animationImages.count *0.15;
}
- (void)stop
{
    
}
@end
@implementation PetalkView(TalkingBrowse)
- (void)layoutSubviewsWithTalking:(TalkingBrowse *)talking
{
    NSString * urlStr = [NSString stringWithFormat:@"%@?imageView2/2/w/200",talking.imgUrl];
    _imageView.imageURL = [NSURL URLWithString:urlStr];
    if ([talking.theModel intValue]==1) {//纯图
        typeImageView.image = [UIImage imageNamed:@"browser_typePic"];
    }else{//说说
        typeImageView.image = [UIImage imageNamed:@"browser_typeShuoshuo"];
    }
//    self.animation = talking.playAnimationImg;
}
@end
