//
//  TextAccessoryView.m
//  textAccessory
//
//  Created by wangxr on 14/10/24.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "TextAccessoryView.h"
@interface TextAccessoryView ()<UITextViewDelegate>
{
    UITextView * wordPad;
}
@property (nonatomic,retain)UILabel * label;//400*240
@end
@implementation TextAccessoryView
- (void)dealloc
{
    
}
- (id)initWithFrame:(CGRect)frame WXRAccessoryType:(WXRAccessoryType)type
{
    self = [super initWithFrame:frame WXRAccessoryType:type];
    if (self) {
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (frame.size.width-30)*2/3, (frame.size.height-30)*2/5)];
        _label.center = CGPointMake(CGRectGetMidX([self bounds]), CGRectGetMidY([self bounds]));
        _label.text = @"点击输入文字";
        _label.numberOfLines = 0;
        _label.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.backgroundColor = [UIColor clearColor];
        [self addSubview:_label];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(starEditWordPad)];
        [_label addGestureRecognizer:tap];
        _label.userInteractionEnabled = YES;
        _label.font = [UIFont fontWithName:@"DFPWaWaW5" size:20];
        _label.adjustsFontSizeToFitWidth=YES;
        _label.minimumScaleFactor = 0.5;
    }
    return self;
}
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _label.frame = CGRectMake(0, 0, (frame.size.width-30)*2/3, (frame.size.height-30)*2/5);
    _label.center = CGPointMake(CGRectGetMidX([self bounds]), CGRectGetMidY([self bounds]));
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self endEditWordPad];
}
- (void)hiddenEditRect
{
    [super hiddenEditRect];
    [self endEditWordPad];
}
//- (CGFloat)getImageViewWidth
//{
//    return self.frame.size.width;
//}
//- (CGFloat)getImageViewHeight
//{
//    return self.frame.size.height;
//}
- (UIImage*)getAccessoryStaticImage
{
    CGSize size = CGSizeMake([self getImageViewWidth]*2, [self getImageViewHeight]*2);
    UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    imageV.image = [super getAccessoryStaticImage];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (size.width-30)*2/3, (size.height-30)*2/5)];
    label.center = CGPointMake(CGRectGetMidX([imageV bounds]), CGRectGetMidY([imageV bounds]));
    label.text = _label.text;
    label.textColor = _label.textColor;
    label.font =  [UIFont fontWithName:@"DFPWaWaW5" size:40];
    label.adjustsFontSizeToFitWidth=YES;
    [imageV addSubview:label];
    label.textAlignment = NSTextAlignmentCenter;
     label.numberOfLines = 0;
    label.backgroundColor = [UIColor clearColor];
    UIGraphicsBeginImageContext(size);
    [imageV.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (void)starEditWordPad
{
    if (!wordPad) {
        wordPad = [[UITextView alloc] initWithFrame:_label.frame];
        if (![_label.text isEqualToString:@"点击输入文字"]) {
            wordPad.text = _label.text;
        }
        wordPad.textColor = _label.textColor;
        wordPad.returnKeyType = UIReturnKeyDone;
        wordPad.delegate = self;
        _label.text = @"";
        wordPad.textAlignment = NSTextAlignmentCenter;
        wordPad.backgroundColor = [UIColor clearColor];
        wordPad.font = _label.font;
        [self addSubview:wordPad];
        [wordPad becomeFirstResponder];
    }
}
- (void)endEditWordPad
{
    if (wordPad) {
        _label.text = wordPad.text;
        [wordPad resignFirstResponder];
        [wordPad removeFromSuperview];
        wordPad = nil;
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self endEditWordPad];
        return NO;
    }
    return YES;
}
@end
