//
//  SelectImageViewController.m
//  TalkingPet
//
//  Created by wangxr on 14-9-16.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "SelectImageViewController.h"
#import "EGOImageView.h"
#import "DecorateViewController.h"
#import "iCarousel.h"
#import "TTImageHelper.h"

@interface SelectImageViewController ()<iCarouselDelegate,iCarouselDataSource>
@property (nonatomic,retain)iCarousel * flowView;
@property (nonatomic,retain)UIPageControl * page;
@property (nonatomic,retain)UIImageView * backImageView;
@end

@implementation SelectImageViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView * headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    headView.backgroundColor = [UIColor colorWithWhite:90/255.0 alpha:1];
    [self.view addSubview:headView];

    UIButton * BackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    BackButton.frame = CGRectMake(10, 6, 65, 32);
    [BackButton setBackgroundImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [BackButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:BackButton];
    
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(self.view.frame.size.width-100, 6, 85, 32);
    [rightButton setTitle:@"下一步" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [rightButton addTarget:self action:@selector(goToSoundTouch) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:rightButton];

    self.backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-44)];
    dispatch_queue_t queue = dispatch_queue_create("Blur queue", NULL);
    dispatch_async(queue, ^ {
        UIImage * image = [TTImageHelper blurImage:_imageArr[0]];
        dispatch_async(dispatch_get_main_queue(), ^{
            _backImageView.image = image;
        });
    });
    [self.view addSubview:_backImageView];
    
    self.flowView = [[iCarousel alloc] initWithFrame:CGRectMake(0, 100, 320, 320)];
    _flowView.delegate = self;
    _flowView.dataSource = self;
    _flowView.type = iCarouselTypeRotary;
    [self.view addSubview:_flowView];
    
    self.page = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 450, 320, 20)];
    _page.currentPage = 0;
    _page.numberOfPages = 5;
    [self.view addSubview:_page];
    self.view.clipsToBounds = YES;
    
    [self buildViewWithSkintype];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)goToSoundTouch
{
    DecorateViewController * decorateVC = [[DecorateViewController alloc] init];
    self.talkingPublish.originalImg = _imageArr[_flowView.currentItemIndex];
    decorateVC.talkingPublish = _talkingPublish ;
    [self.navigationController pushViewController:decorateVC animated:YES];
}
- (void)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - UICollectionView
- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
    _page.currentPage = carousel.currentItemIndex;
    dispatch_queue_t queue = dispatch_queue_create("Blur queue", NULL);
    dispatch_async(queue, ^ {
        UIImage * image = [TTImageHelper blurImage:_imageArr[carousel.currentItemIndex]];
        dispatch_async(dispatch_get_main_queue(), ^{
            _backImageView.image = image;
        });
    });
}
- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return _imageArr.count;
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
{
    UIView *view = [[UIImageView alloc] initWithImage:_imageArr[index]];
    view.frame = CGRectMake(0, 0, 290, 290);
    view.layer.borderWidth = 2;
    view.layer.borderColor = [UIColor whiteColor].CGColor;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(5, 5);
    view.layer.shadowOpacity = 0.8;
    return view;
}

- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
    return 0;
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    return _imageArr.count;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return 400;
}
- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    return YES;
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
