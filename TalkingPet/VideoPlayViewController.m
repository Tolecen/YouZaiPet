//
//  VideoPlayViewController.m
//  TalkingPet
//
//  Created by Tolecen on 14-9-4.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "VideoPlayViewController.h"

@interface VideoPlayViewController ()

@end

@implementation VideoPlayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.haveCloseBtn = NO;
        aa = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (OpenMode==1) {
        self.view.backgroundColor = [UIColor clearColor];
        CGRect frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height);
        self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.delegate = self;
        self.scrollView.showsHorizontalScrollIndicator = YES;

        self.scrollView.contentSize = CGSizeMake(320 * 5, [UIScreen mainScreen].bounds.size.height);
        
        
        self.scrollView.scrollEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.backgroundColor = [UIColor clearColor];
        //用来调整 首页面位置
        CGRect rect = CGRectMake(0, 0,
                                 self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        [self.scrollView scrollRectToVisible:rect animated:YES];
        [self.view addSubview:self.scrollView];
        
        for (int i = 0; i<5; i++) {
            UIImageView* image1 = [[UIImageView alloc] initWithFrame:CGRectMake(0+320*i, 0, 320, [UIScreen mainScreen].bounds.size.height)];
            image1.image = [UIImage imageNamed:[NSString stringWithFormat:@"startup%d.jpg",i+1]];
            [self.scrollView addSubview:image1];
        }
        
        if (self.haveCloseBtn) {
            [self addCloseBtn];
        }
        
        m_Emojipc=[[UIPageControl alloc]initWithFrame:CGRectMake(20, 120, 280, 20)];
        //设置背景颜色
        m_Emojipc.backgroundColor=[UIColor clearColor];
        //设置pc页数（此时不会同步跟随显示）
        m_Emojipc.numberOfPages=5;
        //设置当前页,为第一张，索引为零
        m_Emojipc.currentPage=0;
        //添加事件处理，btn点击
        //	[m_Emojipc addTarget:self action:@selector(pagePressed:) forControlEvents:UIControlEventTouchUpInside];
        //将pc添加到视图上
        [self.view addSubview:m_Emojipc];

    }
    else{
    
        self.view.backgroundColor = [UIColor blackColor];
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ss.mp4" ofType:nil];
        NSURL *sourceMovieURL = [NSURL fileURLWithPath:filePath];
        
        movieAsset	= [AVURLAsset URLAssetWithURL:sourceMovieURL options:nil];
        playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
        player = [AVPlayer playerWithPlayerItem:playerItem];
        playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
        playerLayer.frame = CGRectMake(0, 0, 320, (320*1136)/640);
    //    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        
        [self.view.layer addSublayer:playerLayer];
        [player play];
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [btn setBackgroundColor:[UIColor colorWithRed:0 green:0.6 blue:0.933 alpha:1]];
        [btn setBackgroundImage:[UIImage imageNamed:@"enterShuoShuo"] forState:UIControlStateNormal];
        btn.layer.cornerRadius = 8;
        btn.layer.masksToBounds = YES;
    //    [btn setTitle:@"进入宠物说" forState:UIControlStateNormal];
        [self.view addSubview:btn];
        [btn setFrame:CGRectMake(78, self.view.frame.size.height-80, 164, 40)];
        [btn addTarget:self action:@selector(cancelPlay) forControlEvents:UIControlEventTouchUpInside];
        
        Float64 UU = CMTimeGetSeconds([movieAsset duration]);
        NSLog(@"jjjj:%f",UU);
        
        [self performSelector:@selector(dofinish:) withObject:nil afterDelay:(UU+2)];
    }
    
}
-(void)addCloseBtn
{
    BOOL IOS7 = NO;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        IOS7 = YES;
    }
    else IOS7 = NO;
    UIButton *buttonLogin = [[UIButton alloc] initWithFrame:CGRectMake(10, IOS7?20:10, 40, 40)];
//    [buttonLogin setTitle:@"关闭" forState:UIControlStateNormal];
//    buttonLogin.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [buttonLogin setBackgroundImage:[UIImage imageNamed:@"backToCamera"] forState:UIControlStateNormal];
    [buttonLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonLogin addTarget:self action:@selector(closeYinDao) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonLogin];
//    [buttonLogin release];
}
-(void)closeYinDao
{
    [SystemServer sharedSystemServer].canPlayAudio = YES;
    if (_delegate&& [_delegate respondsToSelector:@selector(playDone)]) {
        [_delegate playDone];
    }
    [[NSUserDefaults standardUserDefaults] setObject:@"first" forKey:[NSString stringWithFormat:@"firstIn%@",CurrentVersion]];
    [[NSUserDefaults standardUserDefaults] synchronize];
//    [UIView animateWithDuration:1.5 animations:^{
//        [self.view setAlpha:0];
//    } completion:^(BOOL finished) {
        [self removeMyselfYinDao];
//    }];
}
-(void)removeMyselfYinDao
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}
-(void)cancelPlay
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dofinish:) object:nil];
    [SystemServer sharedSystemServer].canPlayAudio = YES;
    [[NSUserDefaults standardUserDefaults] setObject:@"first" forKey:[NSString stringWithFormat:@"firstIn%@",CurrentVersion]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [UIView animateWithDuration:1 animations:^{
        [self.view setAlpha:0];
    } completion:^(BOOL finished) {
        [self removeMyself];
    }];
}
-(void)dofinish:(NSString *)noti
{
    NSLog(@"done");
    [SystemServer sharedSystemServer].canPlayAudio = YES;
    [[NSUserDefaults standardUserDefaults] setObject:@"first" forKey:[NSString stringWithFormat:@"firstIn%@",CurrentVersion]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [UIView animateWithDuration:1 animations:^{
        [self.view setAlpha:0];
    } completion:^(BOOL finished) {
        [self removeMyself];
    }];
}
-(void)removeMyself
{
    if (_delegate&& [_delegate respondsToSelector:@selector(playDone)]) {
        [_delegate playDone];
    }
    [player replaceCurrentItemWithPlayerItem:nil];
    [playerLayer removeFromSuperlayer];
    player = nil;
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offsetofScrollView = scrollView.contentOffset;
    NSLog(@"qqqq%f",offsetofScrollView.x);
    float a=offsetofScrollView.x;
    int page=floor((a-320/2)/320)+1;
    m_Emojipc.currentPage=page;
    if(offsetofScrollView.x >= 1340&&aa==0&&!self.haveCloseBtn) {
        NSLog(@"sssss");
        aa = 1;
        [self closeYinDao];
    }
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
