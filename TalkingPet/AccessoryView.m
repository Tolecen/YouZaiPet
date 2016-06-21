//
//  AccessoryView.m
//  TalkingPet
//
//  Created by wangxr on 14-7-21.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "AccessoryView.h"
#import "TFileManager.h"

typedef enum WXREditStateType{
    WXREditStateTypePan = 1,
    WXREditStateTypeRotate,
    WXREditStateTypeScaleTop,
    WXREditStateTypeScaleBottom,
    WXREditStateTypeScaleLeft,
    WXREditStateTypeScaleRight,
    WXREditStateTypeNone,
    WXREditStateTypeDelete
}WXREditStateType;
@interface AccessoryView ()
{
    UIImageView * deleteView;
    UIImageView * rangdView;
}
@property (nonatomic,retain)UIImageView * borderView;
@property (nonatomic,retain)UIImageView * imageView;
@property (nonatomic,assign)CGSize originalSize ;
@end
@implementation AccessoryView
{
    WXREditStateType editState;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (id)initWithFrame:(CGRect)frame WXRAccessoryType:(WXRAccessoryType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _accessoryType = type;
        _radianY = 0;
        _radianX = 0;
        _radianZ = 0;
        
        self.backgroundColor = [UIColor clearColor];
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, frame.size.width-30, frame.size.height-30)];
        [self addSubview:_imageView];
        self.borderView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _borderView.image = [[UIImage imageNamed:@"border"] resizableImageWithCapInsets:UIEdgeInsetsMake(50, 50, 50, 50) resizingMode:UIImageResizingModeStretch];
        _borderView.hidden = YES;
        [self addSubview:_borderView];
        if (type == WXRAccessoryTypeAnyway) {
            deleteView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
            deleteView.image = [UIImage imageNamed:@"delete"];
            [_borderView addSubview:deleteView];
        }
        rangdView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-25, frame.size.height-25, 25, 25)];
        rangdView.image = [UIImage imageNamed:@"rangd"];
        [_borderView addSubview:rangdView];
        self.originalSize = frame.size;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editOneAccessoryView:) name:@"WXREditOneAccessoryView" object:nil];
    }
    return self;
}
- (void)setFrame:(CGRect)frame
{
    if (frame.size.width>self.superview.frame.size.height*15/16||frame.size.height>self.superview.frame.size.height*15/16||frame.size.height<50||frame.size.width<50) {
        return;
    }
    if (frame.origin.x<=-frame.size.width/2||frame.origin.x+frame.size.width>self.superview.frame.size.width+frame.size.width/2||frame.origin.y<=-frame.size.height/2||frame.origin.y+frame.size.height>self.superview.frame.size.height+frame.size.height/2) {
        return;
    }
    [super setFrame:frame];
    _imageView.frame = CGRectMake(15, 15, frame.size.width-30, frame.size.height-30);
    self.originalSize = frame.size;
    _borderView.frame = self.bounds;
    deleteView.frame = CGRectMake(0, 0, 25, 25);
    rangdView.frame = CGRectMake(frame.size.width-25, frame.size.height-25, 25, 25);
}
- (void)editOneAccessoryView:(NSNotification*)notification
{
    if (notification.object!=self) {
        if (_delegate&&[_delegate respondsToSelector:@selector(endEditAccessory:)]) {
            [_delegate endEditAccessory:self];
        }
    }else
    {
        if (_delegate&&[_delegate respondsToSelector:@selector(beginEditAccessory:)]) {
            [_delegate beginEditAccessory:self];

        }
    }
}
- (void)hiddenEditRect
{
    _borderView.hidden = YES;
}
- (void)showEditRect
{
    _borderView.hidden = NO;
}
- (void)playAnimation
{
    if (![_imageView isAnimating]) {
        [_imageView startAnimating];
    }
}
- (void)stopAnimation
{
    if ([_imageView isAnimating]) {
        [_imageView stopAnimating];
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WXREditOneAccessoryView" object:self userInfo:nil];
    [self.superview bringSubviewToFront:self];
    if (_imageView.isAnimating) {
        [_imageView stopAnimating];
    }
    editState = WXREditStateTypePan;
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPoint = [touch locationInView:self];
    
    CGFloat x = currentTouchPoint.x,y = currentTouchPoint.y;
    if (0<y&&y<25) {
        //上
        editState = WXREditStateTypeScaleTop;
    }
    if (self.originalSize.height-25<y&&y<self.originalSize.height) {
        //下
        editState = WXREditStateTypeScaleBottom;
    }
    if (0<x&&x<25) {
        //左
        editState = WXREditStateTypeScaleLeft;
    }
    if (self.originalSize.width-25<x&&x<self.originalSize.width) {
        //右
        editState = WXREditStateTypeScaleRight;
    }
    if (0<x&&x<25&&0<y&&y<25) {
        //左上
        if (self.accessoryType == WXRAccessoryTypeAnyway)
        {
            editState = WXREditStateTypeDelete;
        }else{
            editState = WXREditStateTypePan;
        }
    }
    if (self.originalSize.width-25<x&&x<self.originalSize.width&&0<y&&y<25) {
        //右上
        editState = WXREditStateTypePan;
    }
    if (0<x&&x<25&&self.originalSize.height-25<y&&y<self.originalSize.height) {
        //左下
        editState = WXREditStateTypePan;
    }
    if (self.originalSize.width-25<x&&x<self.originalSize.width&&self.originalSize.height-25<y&&y<self.originalSize.height) {
        //右下
        editState = WXREditStateTypeRotate;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (_delegate&&[_delegate respondsToSelector:@selector(editingAccessory:)]) {
        
        [_delegate editingAccessory:self];
    }
    switch (editState) {
        case WXREditStateTypePan:{
            CGPoint currentTouchPoint = [touch locationInView:self.superview];
            CGPoint previousTouchPoint = [touch previousLocationInView:self.superview];
            CGPoint translation = CGPointMake(currentTouchPoint.x-previousTouchPoint.x, currentTouchPoint.y-previousTouchPoint.y);
//            self.center = CGPointMake(self.center.x + translation.x, self.center.y + translation.y);
            CGAffineTransform transform = self.transform;
            self.transform = CGAffineTransformIdentity;
            self.frame = CGRectOffset(self.frame, translation.x, translation.y);
            self.transform = transform;
        }break;
        case WXREditStateTypeRotate:{
            CGPoint currentTouchPoint = [touch locationInView:self];
            CGPoint previousTouchPoint = [touch previousLocationInView:self];
            CGPoint center = CGPointMake(CGRectGetMidX([self bounds]), CGRectGetMidY([self bounds]));
            CGFloat angleInRadians = atan2f(currentTouchPoint.y - center.y, currentTouchPoint.x - center.x) - atan2f(previousTouchPoint.y - center.y, previousTouchPoint.x - center.x);
            CGFloat angleInScale = sqrt(pow((currentTouchPoint.x-center.x),2)+pow((currentTouchPoint.y-center.y), 2))/sqrt(pow((previousTouchPoint.x-center.x),2)+pow((previousTouchPoint.y-center.y), 2));
            self.transform = CGAffineTransformRotate(self.transform, angleInRadians);

            CGAffineTransform transform = self.transform;
            self.transform = CGAffineTransformIdentity;
            self.frame = CGRectInset(self.frame, self.frame.size.width*(1-angleInScale)/2, self.frame.size.height*(1-angleInScale)/2);
            self.transform = transform;
        }break;
        case WXREditStateTypeScaleTop:{
            CGPoint currentTouchPoint = [touch locationInView:self];
            CGPoint previousTouchPoint = [touch previousLocationInView:self];
            CGFloat scaleY = currentTouchPoint.y - previousTouchPoint.y;

            CGAffineTransform transform = self.transform;
            self.transform = CGAffineTransformIdentity;
            self.frame = CGRectInset(self.frame, 0, scaleY);
            self.transform = transform;
        }break;
        case WXREditStateTypeScaleBottom:{
            CGPoint currentTouchPoint = [touch locationInView:self];
            CGPoint previousTouchPoint = [touch previousLocationInView:self];
            CGFloat scaleY = previousTouchPoint.y - currentTouchPoint.y;

            CGAffineTransform transform = self.transform;
            self.transform = CGAffineTransformIdentity;
            self.frame = CGRectInset(self.frame, 0, scaleY);
            self.transform = transform;
        }break;
        case WXREditStateTypeScaleLeft:{
            CGPoint currentTouchPoint = [touch locationInView:self];
            CGPoint previousTouchPoint = [touch previousLocationInView:self];
            CGFloat scaleX = currentTouchPoint.x - previousTouchPoint.x;

            CGAffineTransform transform = self.transform;
            self.transform = CGAffineTransformIdentity;
            self.frame = CGRectInset(self.frame, scaleX, 0);
            self.transform = transform;
        }break;
        case WXREditStateTypeScaleRight:{
            CGPoint currentTouchPoint = [touch locationInView:self];
            CGPoint previousTouchPoint = [touch previousLocationInView:self];
            CGFloat scaleX = previousTouchPoint.x - currentTouchPoint.x;

            CGAffineTransform transform = self.transform;
            self.transform = CGAffineTransformIdentity;
            self.frame = CGRectInset(self.frame, scaleX, 0);
            self.transform = transform;
        }break;
        default:
            break;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (editState == WXREditStateTypeDelete) {
        [self cancelEdit];
        return;
    }
    _radianZ = -atan2f(self.transform.c,self.transform.d);
    _radianY = 0;
    _radianX = 0;
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    _radianZ = -atan2f(self.transform.c,self.transform.d);
    _radianY = 0;
    _radianX = 0;
}
- (CGFloat)getImageViewWidth
{
    return _imageView.frame.size.width;
}
- (CGFloat)getImageViewHeight
{
    return _imageView.frame.size.height;
}
- (UIImage*)getAccessoryStaticImage
{
    return _imageView.image;
}
- (void)setAccessory:(Accessory *)accessory
{
    _accessory = accessory;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WXREditOneAccessoryView" object:self userInfo:nil];
    if (self.accessoryType == WXRAccessoryTypeMustHave) {
        self.imageView.image = [TFileManager getFristImageWithID:accessory.fileName];
        NSArray * arr = [TFileManager getAllImagesWithID:accessory.fileName];
        self.imageView.animationImages = arr;
        self.imageView.animationDuration = arr.count *0.15;
    }else
    {
        self.imageView.image = [TFileManager getImageWithID:accessory.fileName];
    }
}
- (void)restoreToSize:(CGSize)size
{
    self.transform = CGAffineTransformIdentity;
    self.frame = CGRectMake(CGRectGetMidX([self.superview bounds])-size.width/2,  CGRectGetMidY([self.superview bounds])-size.height/2, size.width, size.height);
    _radianZ = 0;
    _radianY = 0;
    _radianX = 0;
}
- (void)enlarged
{
    CGAffineTransform transform = self.transform;
    self.transform = CGAffineTransformIdentity;
    self.frame = CGRectInset(self.frame, -1, -1);
    self.transform = transform;
}
- (void)reduced
{
    CGAffineTransform transform = self.transform;
    self.transform = CGAffineTransformIdentity;
    self.frame = CGRectInset(self.frame, 1, 1);
    self.transform = transform;
}
- (void)rotateLeft
{
     self.transform = CGAffineTransformRotate(self.transform, -0.02);
}
- (void)rotateRight
{
     self.transform = CGAffineTransformRotate(self.transform, 0.02);
}
- (void)transform3DRotateXwithRadian:(CGFloat)radian
{
    if ((_radianX<=-M_PI/6&&radian<0)||(_radianX>=M_PI/6&&radian>0)) {
        return;
    }
    CATransform3D tf = self.layer.transform;
    if (tf.m34 != 1.0 / -500) {
        tf.m34 = 1.0 / -500;
    }
    tf = CATransform3DRotate(tf, radian, 1.0f, 0.0f, 0.0f);
    self.layer.transform = tf;
    _radianX += radian;
}
- (void)transform3DRotateYwithRadian:(CGFloat)radian
{
    if ((_radianY<=-M_PI/6&&radian<0)||(_radianY>=M_PI/6&&radian>0)) {
        return;
    }
    CATransform3D tf = self.layer.transform;
    if (tf.m34 != 1.0 / -500) {
        tf.m34 = 1.0 / -500;
    }
    tf = CATransform3DRotate(tf, radian, 0.0f, 1.0f, 0.0f);
    self.layer.transform = tf;
    _radianY += radian;
}
-(void)cancelEdit
{
    [self removeFromSuperview];
    if (self.accessoryType == WXRAccessoryTypeAnyway&&_delegate&&[_delegate respondsToSelector:@selector(removeAccessoryViewFromSuperView:)]) {
        [_delegate removeAccessoryViewFromSuperView:self];
    }
}
@end
