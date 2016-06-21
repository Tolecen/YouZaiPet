//
//  WelcomeViewController.m
//  TalkingPet
//
//  Created by wangxr on 14/11/20.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "WelcomeViewController.h"
#import <AVFoundation/AVFoundation.h>
typedef CGFloat (^EasingFunction)(CGFloat, CGFloat, CGFloat, CGFloat);
@interface GuideView :UIView
{
    UIImageView * textureV;
    UIImageView * titleV;
    UIImageView * contentV;
    UIImageView * imageV;
}
@property (nonatomic,assign)int page;
-(void)showAllElement;
-(void)hideElement;
@end
static EasingFunction easeOutElastic = ^CGFloat(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    CGFloat amplitude = 8;
    CGFloat period = 0.6;
    CGFloat s = 0;
    if (t == 0) {
        return b;
    }
    else if ((t /= d) == 1) {
        return b + c;
    }
    
    if (!period) {
        period = d * .3;
    }
    
    if (amplitude < abs(c)) {
        amplitude = c;
        s = period / 4;
    }
    else {
        s = period / (2 * M_PI) * sin(c / amplitude);
    }
    
    return (amplitude * pow(2, -10 * t) * sin((t * d - s) * (2 * M_PI) / period) + c + b);
};
@implementation GuideView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, -frame.size.width, frame.size.width, frame.size.width)];
        imageV.contentMode = UIViewContentModeCenter;
        [self addSubview:imageV];
        textureV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        textureV.contentMode = UIViewContentModeScaleAspectFill;
        textureV.image = [UIImage imageNamed:@"guide_texture"];
        [self addSubview:textureV];
        titleV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, frame.size.width, 200)];
        titleV.contentMode = UIViewContentModeTopLeft;
        [self addSubview:titleV];
        contentV = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height - 100, frame.size.width, 100)];
        contentV.contentMode = UIViewContentModeTop;
        [self addSubview:contentV];
    }
    return self;
}
-(void)setPage:(int)page
{
    _page = page;
    switch (page) {
        case 0:{
            self.backgroundColor = [UIColor colorWithRed:24/255.0 green:180/255.0 blue:237/255.0 alpha:1];
        }break;
        case 1:{
             self.backgroundColor = [UIColor colorWithRed:255/255.0 green:69/255.0 blue:207/255.0 alpha:1];
        }break;
        case 2:{
             self.backgroundColor = [UIColor colorWithRed:254/255.0 green:191/255.0 blue:86/255.0 alpha:1];
        }break;
        case 3:{
             self.backgroundColor = [UIColor colorWithRed:146/255.0 green:216/255.0 blue:96/255.0 alpha:1];
        }break;
        case 4:{
             self.backgroundColor = [UIColor colorWithRed:159/255.0 green:162/255.0 blue:241/255.0 alpha:1];
        }break;
        default:
            break;
    }
    titleV.image = [UIImage imageNamed:[NSString stringWithFormat:@"guide_title_%d",self.page+1]];
    contentV.image = [UIImage imageNamed:[NSString stringWithFormat:@"guide_con_%d",self.page+1]];
    imageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"guide_img_%d",self.page+1]];
}
-(void)showAllElement
{
    if ([UIDevice currentDevice].systemVersion.floatValue < 7.0){
        [UIView animateWithDuration:0.3 animations:^{
            imageV.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        } completion:^(BOOL finished) {
            
        }];
    }
//    [UIView animateWithDuration:0.3
//                          delay:0
//         usingSpringWithDamping:0.45
//          initialSpringVelocity:7.5
//                        options:UIViewAnimationOptionCurveEaseIn
//                     animations:^{
//                         imageV.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
//
//                     }
//                     completion:^(BOOL finished){
//                         
//                     }];
    else{
        CGPoint position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        position.y = CGRectGetMidY(self.bounds);
        
        [self animateLayer:imageV.layer
               withKeyPath:@"position.y"
                        to:position.y];
    }
}
- (void)animateLayer:(CALayer *)layer
         withKeyPath:(NSString *)keyPath
                  to:(CGFloat)endValue {
    CGFloat startValue = [[layer valueForKeyPath:keyPath] floatValue];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = 0.5;
    
    CGFloat steps = 100;
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:steps];
    CGFloat delta = endValue - startValue;
    EasingFunction function = easeOutElastic;
    
    for (CGFloat t = 0; t < steps; t++) {
        [values addObject:@(function(animation.duration * (t / steps), startValue, delta, animation.duration))];
    }
    
    animation.values = values;
    [layer addAnimation:animation forKey:nil];
}


-(void)hideElement
{
//    [layer addAnimation:animation forKey:nil];
    [imageV.layer removeAllAnimations];
    imageV.frame = CGRectMake(0, -self.frame.size.width, self.frame.size.width, self.frame.size.width);
}
@end
@interface WelcomeViewController ()<UIScrollViewDelegate>
{
    UIScrollView * scrollView;
    int currentPage;
    UIImageView * pageV;
    UIButton * beginBtn;
}
@property (nonatomic,retain)NSMutableArray * pageViewArray;
@end
@implementation WelcomeViewController
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    GuideView * guideV = _pageViewArray[currentPage];
    [guideV showAllElement];

}
- (void)viewDidLoad
{
    [SystemServer sharedSystemServer].autoPlay = NO;
    self.navigationController.navigationBarHidden = YES;
    
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width*5, self.view.frame.size.height);
    scrollView.delegate = self;
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    [self.view addSubview:scrollView];
    
    self.pageViewArray = [NSMutableArray array];
    currentPage = 0;
    for (int i = 0; i<5; i++) {
        GuideView * guideV = [[GuideView alloc] initWithFrame:CGRectMake(i*self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        guideV.page = i;
        [_pageViewArray addObject:guideV];
        [scrollView addSubview:guideV];
    }
    pageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 50)];
    [self.view addSubview:pageV];
    pageV.contentMode = UIViewContentModeCenter;
    pageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"guide_page_%d",currentPage+1]];
    
    if (self.needCloseBn) {
        [self addCloseBtn];
    }
    else
    {
        beginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [beginBtn setImage:[UIImage imageNamed:@"beginChongwushuo"] forState:UIControlStateNormal];
        [beginBtn setFrame:CGRectMake(self.view.center.x-(193/2), self.view.frame.size.height, 193, 65)];
        [self.view addSubview:beginBtn];
        [beginBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
    }
}
-(void)showBeginBtn
{
    [UIView animateWithDuration:0.3
                          delay:0.3
                        options:UIViewAnimationOptionLayoutSubviews animations:^{
                            [beginBtn setFrame:CGRectMake(self.view.center.x-(193/2), self.view.frame.size.height/2+80+10, 193, 65)];
                        } completion:nil];
}
-(void)hideBeginBtn
{
//    [UIView animateWithDuration:0.3 animations:^{
        [beginBtn setFrame:CGRectMake(self.view.center.x-(193/2), self.view.frame.size.height, 193, 65)];
//    }];

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)tScrollView
{
    int page = ceilf(tScrollView.contentOffset.x/self.view.bounds.size.width);
    if (page == currentPage) {
        return;
    }
    if (page == 4) {
        [self showBeginBtn];
    }else if (currentPage == 4)
    {
        [self hideBeginBtn];
    }
    GuideView * guideV = _pageViewArray[currentPage];
    [guideV hideElement];
    currentPage = page;
    guideV = _pageViewArray[currentPage];
    [guideV showAllElement];
    pageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"guide_page_%d",currentPage+1]];
}
-(void)addCloseBtn
{
    BOOL IOS7 = NO;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        IOS7 = YES;
    }
    else IOS7 = NO;
    UIButton *buttonLogin = [[UIButton alloc] initWithFrame:CGRectMake(3, IOS7?20:10, 40, 40)];
    //    [buttonLogin setTitle:@"关闭" forState:UIControlStateNormal];
    //    buttonLogin.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [buttonLogin setBackgroundImage:[UIImage imageNamed:@"backToCamera"] forState:UIControlStateNormal];
    [buttonLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonLogin addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonLogin];
    //    [buttonLogin release];
}

- (void)back
{
    self.navigationController.navigationBarHidden = NO;
    [[NSUserDefaults standardUserDefaults] setObject:@"first" forKey:[NSString stringWithFormat:@"firstIn%@",CurrentVersion]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [UIView animateWithDuration:1 animations:^{
        [self.view setAlpha:0];
    } completion:^(BOOL finished) {
        if (!self.needCloseBn) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MainPrompt" object:nil userInfo:nil];
        }
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}
@end
