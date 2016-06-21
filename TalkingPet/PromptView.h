//
//  PromptView.h
//  TalkingPet
//
//  Created by Tolecen on 15/2/11.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PromptView : UIView
{
    int theDirection;
    CGRect originRect;
}
@property (nonatomic,strong)UIImageView * promptView;
@property (nonatomic,assign)BOOL autoHide;
-(id)initWithPoint:(CGPoint)arrowPoint image:(UIImage *)image arrowDirection:(int)direction;
-(void)show;
-(void)dismiss;

@end
