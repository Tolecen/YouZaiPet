//
//  TishiNewView.m
//  TalkingPet
//
//  Created by Tolecen on 15/7/25.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "TishiNewView.h"

@implementation TishiNewView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.6;
    }
    return self;
}
-(void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
    if ([self respondsToSelector:@selector(dismissHandle)]) {
        self.dismissHandle();
    }
    
}
@end
