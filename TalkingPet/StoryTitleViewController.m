//
//  StoryTitleViewController.m
//  TalkingPet
//
//  Created by wangxr on 15/7/7.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "StoryTitleViewController.h"
#import "ImageAssetsViewController.h"
#import "AddStoryViewController.h"
#import "StoryPublish.h"
#import "SVProgressHUD.h"
#import "PromptView.h"
#import "Common.h"
@interface StoryTitleViewController ()<UITextViewDelegate>
{
    UILabel * placeholderL;
    UITextView * titleView;
    PromptView * p;
}
@property (nonatomic,retain)StoryPublish * story;
@end
@implementation StoryTitleViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"故事标题";
        self.story = [[StoryPublish alloc] init];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setBackButtonWithTarget:@selector(back)];
    [self setRightButtonWithName:@"下一步" BackgroundImg:nil Target:@selector(selectImage)];
    self.view.backgroundColor = [UIColor colorWithWhite:238/255.0 alpha:1];
    UIImageView * bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height-70-navigationBarHeight)];
    [self.view addSubview:bg];
    bg.image = [UIImage imageNamed:@"story_preview_bg"];
    UIImageView * defaultCover = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, self.view.frame.size.width-20)];
    [bg addSubview:defaultCover];
    defaultCover.image = [UIImage imageNamed:@"story_preview_defaultCover"];
    titleView = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, self.view.frame.size.width-10, 60)];
    titleView.backgroundColor = [UIColor whiteColor];
    titleView.layer.borderWidth = 1;
    titleView.delegate = self;
    titleView.returnKeyType = UIReturnKeyDone;
    titleView.layer.borderColor = [UIColor colorWithWhite:200/255.0 alpha:1].CGColor;
    [self.view addSubview: titleView];
    
    placeholderL = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 100, 20)];
    placeholderL.textColor = [UIColor colorWithWhite:160/255.0 alpha:1];
    placeholderL.text = @"输入标题";
    [titleView addSubview:placeholderL];
    
    titleView.font = placeholderL.font;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (![Common ifHaveGuided:@"storyname"]) {
        [self addNameTishi];
    }
    
}
-(void)addNameTishi
{
    p = [[PromptView alloc] initWithPoint:CGPointMake(140, titleView.frame.size.height) image:[UIImage imageNamed:@"story_name"] arrowDirection:1];
    p.autoHide = NO;
    [self.view addSubview:p];
    [p show];
    [Common setGuided:@"storyname"];
}
-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)selectImage
{
    if (titleView.text.length<2) {
        [SVProgressHUD showErrorWithStatus:@"请输入至少2个字标题"];
        return;
    }
    if (titleView.text.length>50) {
        [SVProgressHUD showErrorWithStatus:@"标题最多50字请酌情删减"];
        return;
    }
    __block UINavigationController * bNav = self.navigationController;
    __block StoryPublish * bolckS = _story;
    ImageAssetsViewController * imageAssetsVC = [[ImageAssetsViewController alloc] init];
    imageAssetsVC.maxCount = 20;
    imageAssetsVC.finish = ^(NSMutableArray*assetArray,NSMutableArray *appends){
        bolckS.title = titleView.text;
        bolckS.tag = _tag;
        AddStoryViewController * vc = [[AddStoryViewController alloc]init];
        vc.story = bolckS;
        vc.imageArr = [[NSMutableArray alloc]initWithArray:assetArray];
        [bNav pushViewController:vc animated:NO];
    };
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:imageAssetsVC];
    [self presentViewController:nav animated:YES completion:nil];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [titleView resignFirstResponder];
}
#pragma mark - UITextView
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [p dismiss];
    placeholderL.hidden = YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (!textView.text.length) {
        placeholderL.hidden = NO;
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
@end
