//
//  UIScrollView+UIScrollviewTouchEvent.m
//  TalkingPet
//
//  Created by Tolecen on 14-7-29.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "UIScrollView+UIScrollviewTouchEvent.h"

@implementation UIScrollView (UIScrollviewTouchEvent)
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesBegan:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesMoved:touches withEvent:event];
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesEnded:touches withEvent:event];
    [super touchesEnded:touches withEvent:event];
}
@end
