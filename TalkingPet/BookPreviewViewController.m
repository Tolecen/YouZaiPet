//
//  BookPreviewViewController.m
//  TalkingPet
//
//  Created by Tolecen on 15/5/12.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "BookPreviewViewController.h"
#import "DiaryPageViewController.h"
#import "DiaryLayouter.h"
#import "TalkingBrowse.h"

@interface BookPreviewViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>
{
//    UIButton * changeB;
    UIImageView * leftBook;
    UIImageView * rightBook;
    UISlider * slider;
    UILabel * originL;
    
    NSInteger totalPage;
    
    int totalPetalk;
    
    int loadPage;
    BOOL loading;
    
    UIImageView * wenanV;
}
//@property (nonatomic,retain)UIPageViewController * pageViewController;
@property (nonatomic,retain)UIPageViewController * doublePageViewController;
@property (nonatomic,retain)NSMutableArray * sourceArr;
@end

@implementation BookPreviewViewController
- (void)dealloc
{
    
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.canScrollBack = NO;
        totalPetalk = [[UserServe sharedUserServe].currentPet.issue intValue];
        totalPage = [DiaryLayouter totalPage:totalPetalk];
        self.sourceArr = [NSMutableArray array];
        loading = NO;
        loadPage = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bg.image = [UIImage imageNamed:@"muwenbg"];
    [self.view addSubview:bg];
    
    UIView * clearV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width)];
    clearV.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    clearV.transform = CGAffineTransformMakeRotation(M_PI_2);
    clearV.backgroundColor = [UIColor clearColor];
    [self.view addSubview: clearV];
    
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(10.0, 10.0, 65, 32);
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [clearV addSubview:backButton];
    
    UIImage * image = [UIImage imageNamed:@"previewBook_made"];
    UIButton * finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    finishButton.frame = CGRectMake(self.view.frame.size.height-80, 10.0, image.size.width*28/image.size.height, 28);
    [finishButton setImage:image forState:UIControlStateNormal];
    [finishButton addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
    [clearV addSubview:finishButton];
    
    NSDictionary *options =@{UIPageViewControllerOptionSpineLocationKey:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMid]};
    self.doublePageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    
    NSArray *viewControllers = @[({
        DiaryPageViewController * vc = [self getDiaryPageViewController:_doublePageViewController];
        vc.index = -1;
        vc;
    }),({
        DiaryPageViewController * vc = [self getDiaryPageViewController:_doublePageViewController];
        vc.index = 0;
        vc;
    })];
    [self.doublePageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
    self.doublePageViewController.delegate = self;
    self.doublePageViewController.dataSource = self;
    [self addChildViewController:_doublePageViewController];
    [clearV addSubview:_doublePageViewController.view];
    [_doublePageViewController didMoveToParentViewController:self];
    _doublePageViewController.view.frame = CGRectMake(0, 0, (self.view.frame.size.width-90)*900/1262*2, self.view.frame.size.width-90);
    _doublePageViewController.view.center = CGPointMake(self.view.frame.size.height/2, self.view.frame.size.width/2);
    wenanV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"previewBook_ Introduction"]];
    wenanV.contentMode = UIViewContentModeCenter;
    wenanV.center = CGPointMake(CGRectGetMidX(_doublePageViewController.view.frame)-wenanV.frame.size.width/2-20, CGRectGetMidY(_doublePageViewController.view.frame));
    [clearV addSubview:wenanV];
    [clearV insertSubview:wenanV belowSubview:_doublePageViewController.view];
    
    leftBook = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_doublePageViewController.view.frame)-_doublePageViewController.view.frame.size.height*26/560, CGRectGetMinY(_doublePageViewController.view.frame), _doublePageViewController.view.frame.size.height*26/560, _doublePageViewController.view.frame.size.height)];
    leftBook.image = [UIImage imageNamed:@"leftBook"];
    [clearV addSubview:leftBook];
    leftBook.hidden = YES;
    
    rightBook = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_doublePageViewController.view.frame), CGRectGetMinY(_doublePageViewController.view.frame), _doublePageViewController.view.frame.size.height*26/560, _doublePageViewController.view.frame.size.height)];
    rightBook.image = [UIImage imageNamed:@"rightBook"];
    [clearV addSubview:rightBook];
    
    slider = [[UISlider alloc] initWithFrame:CGRectMake(CGRectGetMinX(_doublePageViewController.view.frame), CGRectGetMaxY(_doublePageViewController.view.frame)+10, _doublePageViewController.view.frame.size.width, 10)];
    [slider setThumbImage:[UIImage imageNamed:@"huakuaier"] forState:UIControlStateNormal];
    [slider setMinimumTrackImage:[UIImage imageNamed:@"jindutiao"] forState:UIControlStateNormal];
    [slider setMaximumTrackImage:[UIImage imageNamed:@"jindutiao"] forState:UIControlStateNormal];
    slider.value = 0;
    [clearV addSubview:slider];
    [slider addTarget:self action:@selector(sliderTouchUp:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    [slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    originL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(slider.frame)+10, CGRectGetMinY(slider.frame), 100, 20)];
    originL.textColor = [UIColor whiteColor];
    originL.text = [NSString stringWithFormat:@"0/%.0f",ceilf(totalPage/2.0)];
    [clearV addSubview:originL];
    
    [self getMyPetalk];
}
-(void)getMyPetalk
{
    if (loading) {
        return;
    }
    loading = YES;
    NSMutableDictionary * hotDic = [NetServer commonDict];
    [hotDic setObject:@"petalk" forKey:@"command"];
    [hotDic setObject:@"list4Book" forKey:@"options"];
    [hotDic setObject:@"10" forKey:@"pageSize"];
    [hotDic setObject:[NSString stringWithFormat:@"%d",loadPage] forKey:@"pageIndex"];
    [NetServer requestWithParameters:hotDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *array = [[responseObject objectForKey:@"value"] objectForKey:@"list"];
        if (totalPetalk != [[[responseObject objectForKey:@"value"] objectForKey:@"totalElements"] intValue]) {
            totalPetalk = [[[responseObject objectForKey:@"value"] objectForKey:@"totalElements"] intValue];
            totalPage = [DiaryLayouter totalPage:totalPetalk];
        }
        if (array.count>0) {
            for (int i = 0; i<array.count; i++) {
                TalkingBrowse * talking = [[TalkingBrowse alloc] initWithHostInfo:[array objectAtIndex:i]];
                [_sourceArr addObject:talking];
            }
            loadPage++;
            loading = NO;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        loading = NO;
    }];
}
-(void)backAction
{
    if (_back) {
        self.navigationController.navigationBarHidden = NO;
        [UIApplication sharedApplication].statusBarHidden = NO;
        _back();
    }
}
-(void)finishAction
{
    if (_finish) {
        self.navigationController.navigationBarHidden = NO;
        [UIApplication sharedApplication].statusBarHidden = NO;
        _finish(totalPetalk);
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)sliderValueChange:(UISlider*)mSlider
{
    NSInteger index = ceilf(mSlider.value*totalPage);
    NSInteger b = 0;
    if (index%2) {
        b = index+1;
    }else
    {
        b = index;
    }
    originL.text = [NSString stringWithFormat:@"%.0f/%.0f",ceilf(b/2.0),ceilf(totalPage/2.0)];
}
-(void)sliderTouchUp:(UISlider*)mSlider
{
    NSInteger index = ceilf(mSlider.value*totalPage);
    NSInteger a = -1,b = 0;
    if (index%2) {
        a = index;
        b = index+1;
    }else
    {
        a = index-1;
        b = index;
    }
    NSArray * arr = @[({
        DiaryPageViewController * vc = [self getDiaryPageViewController:_doublePageViewController];
        vc.index = a;
        vc;}),
      ({
          DiaryPageViewController * vc = [self getDiaryPageViewController:_doublePageViewController];
          vc.index = b;
          vc;})];
    __weak UIView * weakLeft = leftBook;
    __weak UIView * weakRight = rightBook;
    [_doublePageViewController setViewControllers: arr direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
        if (b<=2) {
            weakLeft.hidden = YES;
        }else
        {
            weakLeft.hidden = NO;
        }
        if (b>=totalPage-1) {
            weakRight.hidden = YES;
        }else
        {
            weakRight.hidden = NO;
        }
    }];
}
-(DiaryPageViewController*)getDiaryPageViewController:(UIPageViewController*)pageViewController
{
    DiaryPageViewController * vc = [[DiaryPageViewController alloc] init];
    vc.view.frame = CGRectMake(0, 0, pageViewController.view.frame.size.width/2, pageViewController.view.frame.size.height);
    __weak BookPreviewViewController * weakSelf = self;
    __block int blockTotalPetalk = totalPetalk;
    DiaryLayouter * layouter = [[DiaryLayouter alloc] initWithTotalPage:totalPage LayoutBlock:^TalkingBrowse *(NSInteger index) {
        if (weakSelf.sourceArr.count!= blockTotalPetalk && index >= (int)(weakSelf.sourceArr.count-5)) {
            [weakSelf getMyPetalk];
        }
        if (index<weakSelf.sourceArr.count) {
            return weakSelf.sourceArr[index];
        }
        return nil;
    }];
    layouter.haveBlankPage = ^BOOL(){
        return [DiaryLayouter haveBlankPage:blockTotalPetalk];
    };
    vc.layouter = layouter;
    return vc;
}
#pragma mark -
#pragma mark - UIPageViewController
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger page = ((DiaryPageViewController*)viewController).index-1;
    if (page<-1) {
        return nil;
    }
    DiaryPageViewController * vc = [self getDiaryPageViewController:pageViewController];
    vc.index = page;
    return vc;
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger page = ((DiaryPageViewController*)viewController).index+1;
    if (page>totalPage+1) {
        return nil;
    }
    DiaryPageViewController * vc = [self getDiaryPageViewController:pageViewController];
    vc.index = page;
    return vc;
}
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (finished && completed) {
        DiaryPageViewController * viewController = [pageViewController.viewControllers lastObject];
        slider.value = viewController.index*1.0/totalPage;
        originL.text = [NSString stringWithFormat:@"%.0f/%.0f",ceilf(viewController.index/2.0),ceilf(totalPage/2.0)];
        if (viewController.index<=1)
        {
            wenanV.hidden = NO;
        }else
        {
            wenanV.hidden = YES;
        }
        if (viewController.index<=2) {
            leftBook.hidden = YES;
        }else
        {
            leftBook.hidden = NO;
        }
        if (viewController.index>=totalPage-1) {
            rightBook.hidden = YES;
        }else
        {
            rightBook.hidden = NO;
        }
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
