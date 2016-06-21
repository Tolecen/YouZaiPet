//
//  PromptView.m
//  TalkingPet
//
//  Created by Tolecen on 15/2/11.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "PromptView.h"

@implementation PromptView
-(id)initWithPoint:(CGPoint)arrowPoint image:(UIImage *)image arrowDirection:(int)direction
{
    //direction 上左下右 1 2 3 4;
    if (self = [super init]) {
        self.autoHide = YES;
        CGSize iSize = image.size;
        if (direction==3) {
            [self setFrame:CGRectMake(arrowPoint.x-iSize.width/4, arrowPoint.y-iSize.height/2, iSize.width/2, iSize.height/2)];
        }
        else if (direction==2){
            [self setFrame:CGRectMake(arrowPoint.x, arrowPoint.y-iSize.height/4, iSize.width/2, iSize.height/2)];
        }
        else if (direction==1){
            [self setFrame:CGRectMake(arrowPoint.x-iSize.width/4, arrowPoint.y, iSize.width/2, iSize.height/2)];
        }
        
        theDirection = direction;
        originRect = self.frame;
        self.promptView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self.promptView setImage:image];
        [self addSubview:self.promptView];
        self.alpha = 0;
        
    }
    return self;
}
-(void)show
{
    __weak UIView * weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.alpha = 1;
    } completion:^(BOOL finished) {
        [weakSelf performSelector:@selector(first) withObject:nil afterDelay:1];
    }];
    
}
-(void)first
{
    __weak id weakSelf = self;
    if (theDirection==3) {
        [UIView animateWithDuration:0.3 animations:^{
            [weakSelf setFrame:CGRectMake(originRect.origin.x, originRect.origin.y+10, originRect.size.width, originRect.size.height)];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.4 animations:^{
                [weakSelf setFrame:CGRectMake(originRect.origin.x, originRect.origin.y, originRect.size.width, originRect.size.height)];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.3 animations:^{
                    [weakSelf setFrame:CGRectMake(originRect.origin.x, originRect.origin.y+10, originRect.size.width, originRect.size.height)];
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.4 animations:^{
                        [weakSelf setFrame:CGRectMake(originRect.origin.x, originRect.origin.y, originRect.size.width, originRect.size.height)];
                    } completion:^(BOOL finished) {
                        [weakSelf performSelector:@selector(second) withObject:nil afterDelay:1];
                    }];
                }];
            }];
        }];
    }
    else if (theDirection==2){
        [UIView animateWithDuration:0.3 animations:^{
            [weakSelf setFrame:CGRectMake(originRect.origin.x-10, originRect.origin.y, originRect.size.width, originRect.size.height)];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.4 animations:^{
                [weakSelf setFrame:CGRectMake(originRect.origin.x, originRect.origin.y, originRect.size.width, originRect.size.height)];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.3 animations:^{
                    [weakSelf setFrame:CGRectMake(originRect.origin.x-10, originRect.origin.y, originRect.size.width, originRect.size.height)];
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.4 animations:^{
                        [weakSelf setFrame:CGRectMake(originRect.origin.x, originRect.origin.y, originRect.size.width, originRect.size.height)];
                    } completion:^(BOOL finished) {
                        [weakSelf performSelector:@selector(second) withObject:nil afterDelay:1];
                    }];
                }];
            }];
        }];
    }
    else if (theDirection==1){
        [UIView animateWithDuration:0.3 animations:^{
            [weakSelf setFrame:CGRectMake(originRect.origin.x, originRect.origin.y-10, originRect.size.width, originRect.size.height)];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.4 animations:^{
                [weakSelf setFrame:CGRectMake(originRect.origin.x, originRect.origin.y, originRect.size.width, originRect.size.height)];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.3 animations:^{
                    [weakSelf setFrame:CGRectMake(originRect.origin.x, originRect.origin.y-10, originRect.size.width, originRect.size.height)];
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.4 animations:^{
                        [weakSelf setFrame:CGRectMake(originRect.origin.x, originRect.origin.y, originRect.size.width, originRect.size.height)];
                    } completion:^(BOOL finished) {
                        [weakSelf performSelector:@selector(second) withObject:nil afterDelay:1];
                    }];
                }];
            }];
        }];
    }
}
-(void)second
{
    __weak id weakSelf = self;
    if (theDirection==3) {
        [UIView animateWithDuration:0.3 animations:^{
            [weakSelf setFrame:CGRectMake(originRect.origin.x, originRect.origin.y+10, originRect.size.width, originRect.size.height)];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.4 animations:^{
                [weakSelf setFrame:CGRectMake(originRect.origin.x, originRect.origin.y, originRect.size.width, originRect.size.height)];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.3 animations:^{
                    [weakSelf setFrame:CGRectMake(originRect.origin.x, originRect.origin.y+10, originRect.size.width, originRect.size.height)];
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.4 animations:^{
                        [weakSelf setFrame:CGRectMake(originRect.origin.x, originRect.origin.y, originRect.size.width, originRect.size.height)];
                    } completion:^(BOOL finished) {
                        [weakSelf performSelector:@selector(hideIt) withObject:nil afterDelay:1];
                    }];
                }];
            }];
        }];
    }
    else if (theDirection==2){
        [UIView animateWithDuration:0.3 animations:^{
            [weakSelf setFrame:CGRectMake(originRect.origin.x-10, originRect.origin.y, originRect.size.width, originRect.size.height)];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.4 animations:^{
                [weakSelf setFrame:CGRectMake(originRect.origin.x, originRect.origin.y, originRect.size.width, originRect.size.height)];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.3 animations:^{
                    [weakSelf setFrame:CGRectMake(originRect.origin.x-10, originRect.origin.y, originRect.size.width, originRect.size.height)];
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.4 animations:^{
                        [weakSelf setFrame:CGRectMake(originRect.origin.x, originRect.origin.y, originRect.size.width, originRect.size.height)];
                    } completion:^(BOOL finished) {
                        [weakSelf performSelector:@selector(hideIt) withObject:nil afterDelay:1];
                    }];
                }];
            }];
        }];
    }
    else if (theDirection==1){
        [UIView animateWithDuration:0.3 animations:^{
            [weakSelf setFrame:CGRectMake(originRect.origin.x, originRect.origin.y-10, originRect.size.width, originRect.size.height)];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.4 animations:^{
                [weakSelf setFrame:CGRectMake(originRect.origin.x, originRect.origin.y, originRect.size.width, originRect.size.height)];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.3 animations:^{
                    [weakSelf setFrame:CGRectMake(originRect.origin.x, originRect.origin.y-10, originRect.size.width, originRect.size.height)];
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.4 animations:^{
                        [weakSelf setFrame:CGRectMake(originRect.origin.x, originRect.origin.y, originRect.size.width, originRect.size.height)];
                    } completion:^(BOOL finished) {
                        [weakSelf performSelector:@selector(hideIt) withObject:nil afterDelay:1];
                    }];
                }];
            }];
        }];
    }
}

-(void)hideIt
{
    if (self.autoHide) {
        __weak UIView * weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.alpha = 0;
        } completion:^(BOOL finished) {
            [weakSelf removeFromSuperview];
        }];
    }

}
-(void)dismiss
{
    __weak UIView * weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
