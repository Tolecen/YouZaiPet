//
//  BaseViewController.m
//  TalkingPet
//
//  Created by wangxr on 14-7-7.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "BaseViewController.h"
#import "SystemServer.h"
#import "RootViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
- (BOOL)shouldAutorotate
{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.canScrollBack = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buildViewWithSkintype) name:@"WXRchangeSkin" object:nil];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [RootViewController sharedRootViewController].currentViewController = self;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }
    else
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
    }
    if (self.hideNaviBg) {
        [self removeNaviBg];
    }

//    if (naviBgHidden) {
//        if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
//            [self.navigationController.navigationBar setBackgroundImage:newImage forBarMetrics:0];
//            
//        }
//    }

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    naviBgHidden = NO;
    // Do any additional setup after loading the view.
    navigationBarHeight = 44;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0){
        navigationBarHeight = 64;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
/*使用图片*/
//    UIImage *image = [UIImage imageSkinName:@"navigation"];
//    CGRect rectFrame=CGRectMake(0, 0 ,self.view.frame.size.width,navigationBarHeight);
//    UIGraphicsBeginImageContext(rectFrame.size);
//    [image drawInRect:rectFrame];
//    newImage=UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();

/*使用颜色*/
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0 ,self.view.frame.size.width,navigationBarHeight)];
    view.backgroundColor = CommonGreenColor;
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIGraphicsBeginImageContext(view.bounds.size);
    [image drawInRect:view.bounds];
    newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    
    if (self.hideNaviBg) {
        if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0){
            navigationBarHeight = 64;
            self.edgesForExtendedLayout = UIRectEdgeTop;
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    else{
        if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0){
            navigationBarHeight = 64;
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.automaticallyAdjustsScrollViewInsets = YES;
        }
        if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
            [self.navigationController.navigationBar setBackgroundImage:newImage forBarMetrics:0];
        }
    }
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{UITextAttributeTextColor : [UIColor whiteColor],
          UITextAttributeFont:[UIFont boldSystemFontOfSize:20]
                                                                      }];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        if(_canScrollBack && self.navigationController.viewControllers.count > 1)
        {
            self.navigationController.interactivePopGestureRecognizer.delegate = self;
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }else
        {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
    }
    
}
- (void)buildViewWithSkintype
{

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)removeNaviBg
{
    if ([UIDevice currentDevice].systemVersion.floatValue < 7.0){
        return;
    }
    naviBgHidden = YES;
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
        NSArray *list=self.navigationController.navigationBar.subviews;
        for (id obj in list) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView=(UIImageView *)obj;
                [UIView animateWithDuration:0.2 animations:^{
                    imageView.alpha=0;
                }];
                
            }
        }
        
    }
}

-(void)showNaviBg
{
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        [self.navigationController.navigationBar setBackgroundImage:newImage forBarMetrics:0];
        NSArray *list=self.navigationController.navigationBar.subviews;
        id obj = [list firstObject];
//        for (id obj in list) {

            if (obj&&[obj isKindOfClass:[UIImageView class]]) {
                
                UIImageView *imageView=(UIImageView *)obj;
                imageView.alpha=1;
            }
//        }
        
        
    }
}

- (void)setBackButtonWithTarget:(SEL)selector
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:({
        UIButton * BackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        BackButton.frame = CGRectMake(0.0, 0.0, 65, 32);
        [BackButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
        [BackButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
        if ([[UIDevice currentDevice].systemVersion integerValue]>=7) {
            BackButton.imageEdgeInsets = UIEdgeInsetsMake(0, -12, 0, 12);
        }
        BackButton;
    })];
}

- (void)setShadowBackButtonWithTarget:(SEL)selector
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:({
        UIButton * BackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        BackButton.frame = CGRectMake(0.0, 0.0, 65, 32);
        [BackButton setImage:[UIImage imageNamed:@"backButton_shadow"] forState:UIControlStateNormal];
        [BackButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
        if ([[UIDevice currentDevice].systemVersion integerValue]>=7) {
            BackButton.imageEdgeInsets = UIEdgeInsetsMake(0, -12, 0, 12);
        }
        BackButton;
    })];
}

- (void)setAnotherBackButtonWithTarget:(SEL)selector
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:({
        UIButton * BackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        BackButton.frame = CGRectMake(0.0, 0.0, 65, 32);
        [BackButton setImage:[UIImage imageNamed:@"backButtonanother"] forState:UIControlStateNormal];
        if ([[UIDevice currentDevice].systemVersion integerValue]>=7) {
            BackButton.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 15);
        }
        [BackButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
        BackButton;
    })];
}

-(void)setRightButtonWithName:(NSString *)theName BackgroundImg:(NSString *)imgName Target:(SEL)selector
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:({
        UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if (imgName) {
            UIImage * image = [UIImage imageNamed:imgName];
            [rightButton setImage:image forState:UIControlStateNormal];
            rightButton.frame = CGRectMake(0.0, 0.0, image.size.width*28/image.size.height, 28);
            if ([[UIDevice currentDevice].systemVersion integerValue]>=7) {
                rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 12, 0, -12);
            }
        }
        if (theName) {
            [rightButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
            [rightButton setTitle:theName forState:UIControlStateNormal];
            CGSize size = [theName sizeWithFont:rightButton.titleLabel.font constrainedToSize:CGSizeMake(300,20) lineBreakMode:NSLineBreakByWordWrapping];
            rightButton.frame = CGRectMake(0.0, 0.0, size.width, 32);
            
            [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        
        [rightButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
        rightButton;
    })];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
