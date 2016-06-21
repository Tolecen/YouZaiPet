//
//  PublishStoryViewController.m
//  TalkingPet
//
//  Created by wangxr on 15/7/13.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "PublishStoryViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PreviewStoryViewController.h"
#import "StoryCell.h"
#import "TagViewController.h"
#import "PublishServer.h"
#import "SVProgressHUD.h"

@interface PublishStoryViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,SelectTagDelegate>
{
    UIScrollView * scView;
    UIImageView * coverView;
    UILabel * tagL;
    
    UIImageView *sinaWeiboImageV;
    UILabel * sinaL;
    UIImageView * wechatImageV;
    UILabel * wechatL;
}
@end
@implementation PublishStoryViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"设置故事封面";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setBackButtonWithTarget:@selector(goBack)];
    [self setRightButtonWithName:@"发布" BackgroundImg:nil Target:@selector(publishSrory)];
    self.view.backgroundColor = [UIColor colorWithWhite:50/255.0 alpha:1];
    
    scView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, (self.view.frame.size.width-20)*4/7)];
    [self.view addSubview:scView];
    scView.backgroundColor = [UIColor clearColor];
    coverView = [[UIImageView alloc] initWithFrame:scView.bounds];
    [scView addSubview:coverView];
    id source = [_imgArr firstObject];
    if ([source isKindOfClass:[UIImage class]]) {
        coverView.image =source;
        coverView.frame = CGRectMake(0, 0, scView.frame.size.width, scView.frame.size.width*coverView.image.size.height/coverView.image.size.width);
        scView.contentSize = coverView.frame.size;
    }
    if ([source isKindOfClass:[ALAsset class]]) {
        coverView.image =[UIImage imageWithCGImage:[[(ALAsset*)source defaultRepresentation] fullScreenImage]];
        coverView.frame = CGRectMake(0, 0, scView.frame.size.width, scView.frame.size.width*coverView.image.size.height/coverView.image.size.width);
        scView.contentSize = coverView.frame.size;
    }
    
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc]init];
    float whith = (self.view.frame.size.width-51)/4;
    layout.itemSize = CGSizeMake(whith,whith);
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    UICollectionView*selectCoverView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(scView.frame), self.view.frame.size.width, self.view.frame.size.height-CGRectGetMaxY(scView.frame)-navigationBarHeight) collectionViewLayout:layout];
    selectCoverView.backgroundColor = [UIColor clearColor];
    selectCoverView.contentInset = UIEdgeInsetsMake(10, 10, 100, 10);
    selectCoverView.alwaysBounceVertical = YES;
    selectCoverView.delegate = self;
    selectCoverView.dataSource = self;
    [self.view addSubview:selectCoverView];
    selectCoverView.showsHorizontalScrollIndicator = NO;
    [selectCoverView registerClass:[StoryCell class] forCellWithReuseIdentifier:@"storyCell"];
    
    UIButton*tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tagBtn setFrame:CGRectMake(10, self.view.frame.size.height-80-navigationBarHeight ,116 , 28.5)];
    [tagBtn setImage:[UIImage imageNamed:@"story_addTag"] forState:UIControlStateNormal];
    [self.view  addSubview:tagBtn];
    tagL = [[UILabel alloc] initWithFrame:CGRectMake(5, 8, 100, 12.5)];
    tagL.backgroundColor = [UIColor clearColor];
    tagL.textAlignment = NSTextAlignmentCenter;
    tagL.text = @"添加故事标签";
    tagL.font = [UIFont systemFontOfSize:12];
    tagL.textColor = [UIColor whiteColor];
    [tagBtn addSubview:tagL];
    [tagBtn addTarget:self action:@selector(selectTag) forControlEvents:UIControlEventTouchUpInside];
    if (_story.tag) {
        tagL.text =_story.tag.tagName;
    }
    
    UIButton * previewB = [UIButton buttonWithType:UIButtonTypeCustom];
    previewB.frame = CGRectMake(self.view.frame.size.width-56, self.view.frame.size.height-85-navigationBarHeight, 46, 61.5);
    [previewB setImage:[UIImage imageNamed:@"previewStory"] forState:UIControlStateNormal];
    [previewB addTarget:self action:@selector(previewStory) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:previewB];
    
    UIView*shareBGV = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-40-navigationBarHeight, self.view.frame.size.width, 40)];
    [shareBGV setBackgroundColor:[UIColor colorWithWhite:61/255.0 alpha:1]];
    [self.view addSubview:shareBGV];
    
    UILabel * gb = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 90, 20)];
    [gb setBackgroundColor:[UIColor clearColor]];
    [gb setText:@"内容同步到:"];
    [gb setTextColor:[UIColor whiteColor]];
    [gb setFont:[UIFont systemFontOfSize:14]];
    [shareBGV addSubview:gb];
    
    SystemServer * sys = [SystemServer sharedSystemServer];
    
    UIButton * sinaWeiboBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sinaWeiboBtn setFrame:CGRectMake(100, 0, 90, 40)];
    [sinaWeiboBtn setBackgroundColor:[UIColor clearColor]];
    [shareBGV addSubview:sinaWeiboBtn];
    sinaWeiboImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 7.5, 25, 25)];
    [sinaWeiboBtn addSubview:sinaWeiboImageV];
    [sinaWeiboBtn addTarget:self action:@selector(autoSinaWeibo:) forControlEvents:UIControlEventTouchUpInside];
    sinaL = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 60, 20)];
    [sinaL setBackgroundColor:[UIColor clearColor]];
    [sinaL setText:@"新浪微博"];
    sinaL.font = [UIFont systemFontOfSize:14];
    [sinaWeiboBtn addSubview:sinaL];
    if (sys.autoSinaWeiBo) {
        [sinaWeiboImageV setImage:[UIImage imageNamed:@"Sinamicro-blog_cli"]];
        [sinaL setTextColor:[UIColor whiteColor]];
    }else
    {
        [sinaWeiboImageV setImage:[UIImage imageNamed:@"Sinamicro-blog"]];
        [sinaL setTextColor:[UIColor grayColor]];
    }
    
    UIButton * weichatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [weichatBtn setFrame:CGRectMake(200, 0, 110, 40)];
    [weichatBtn setBackgroundColor:[UIColor clearColor]];
    [shareBGV addSubview:weichatBtn];
    wechatImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 7.5, 25, 25)];
    [weichatBtn addSubview:wechatImageV];
    [weichatBtn addTarget:self action:@selector(autoWeiChat:) forControlEvents:UIControlEventTouchUpInside];
    wechatL = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 80, 20)];
    [wechatL setBackgroundColor:[UIColor clearColor]];
    [wechatL setText:@"微信朋友圈"];
    wechatL.font = [UIFont systemFontOfSize:14];
    [weichatBtn addSubview:wechatL];
    if (sys.autoFriendCircle) {
        [wechatImageV setImage:[UIImage imageNamed:@"pengyouquan-cli"]];
        [wechatL setTextColor:[UIColor whiteColor]];
    }else
    {
        [wechatImageV setImage:[UIImage imageNamed:@"pengyouquan"]];
        [wechatL setTextColor:[UIColor grayColor]];
    }
}
- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(UIImage*)cutCover
{
    UIImage * img = coverView.image;
    CGRect rect = CGRectMake(0, scView.contentOffset.y*img.size.height/scView.contentSize.height, img.size.width, img.size.width*scView.frame.size.height/scView.frame.size.width);
    CGImageRef imageRef = CGImageCreateWithImageInRect(img.CGImage, rect);
    return [UIImage imageWithCGImage:imageRef];
}
-(void)publishSrory
{
    if (!_story.tag) {
        [SVProgressHUD showErrorWithStatus:@"请选择一个标签"];
        return;
    }
    _story.cover = [self cutCover];
    [PublishServer publishStory:_story];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)previewStory
{
    _story.cover = [self cutCover];
    PreviewStoryViewController * vc = [[PreviewStoryViewController alloc] init];
    [vc loadPreviewStoryViewWithStory:_story];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)selectTag
{
    TagViewController * tagVC = [[TagViewController alloc]init];
    tagVC.delegate = self;
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:tagVC];
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)selectedTag:(Tag*)tag
{
    if (tag) {
        self.story.tag = tag;
        tagL.text = tag.tagName;
    }
}
#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imgArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SectionCellIdentifier = @"storyCell";
    id source = _imgArr[indexPath.row];
    StoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SectionCellIdentifier forIndexPath:indexPath];
    if ([source isKindOfClass:[UIImage class]]) {
        [cell layoutWithImage:source text:nil lineFeed:NO haveAudio:NO];
    }
    if ([source isKindOfClass:[ALAsset class]]) {
        [cell layoutWithImage:[UIImage imageWithCGImage:((ALAsset*)source).thumbnail] text:nil lineFeed:NO haveAudio:NO];
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
     id source = _imgArr[indexPath.row];
    if ([source isKindOfClass:[UIImage class]]) {
        coverView.image =source;
        coverView.frame = CGRectMake(0, 0, scView.frame.size.width, scView.frame.size.width*coverView.image.size.height/coverView.image.size.width);
        scView.contentSize = coverView.frame.size;
    }
    if ([source isKindOfClass:[ALAsset class]]) {
        coverView.image =[UIImage imageWithCGImage:[[(ALAsset*)source defaultRepresentation] fullScreenImage]];
        coverView.frame = CGRectMake(0, 0, scView.frame.size.width, scView.frame.size.width*coverView.image.size.height/coverView.image.size.width);
        scView.contentSize = coverView.frame.size;
    }
}
#pragma mark -
- (void)autoSinaWeibo:(UIButton*)button
{
    SystemServer * sys = [SystemServer sharedSystemServer];
    sys.autoSinaWeiBo = !sys.autoSinaWeiBo;
    [DatabaseServe setAutoShareSinaWeiBo:sys.autoSinaWeiBo];
    if (sys.autoSinaWeiBo) {
        [ShareServe authSineWithSucceed:^(BOOL state) {
            if (state) {
                [sinaWeiboImageV setImage:[UIImage imageNamed:@"Sinamicro-blog_cli"]];
                [sinaL setTextColor:[UIColor whiteColor]];
            }
        }];
    }else
    {
        [sinaWeiboImageV setImage:[UIImage imageNamed:@"Sinamicro-blog"]];
        [sinaL setTextColor:[UIColor grayColor]];
    }
}
- (void)autoWeiChat:(UIButton *)button
{
    SystemServer * sys = [SystemServer sharedSystemServer];
    sys.autoFriendCircle = !sys.autoFriendCircle;
    [DatabaseServe setAutoShareFriendCircle:sys.autoFriendCircle];
    if (sys.autoFriendCircle) {
        [wechatImageV setImage:[UIImage imageNamed:@"pengyouquan-cli"]];
        [wechatL setTextColor:[UIColor whiteColor]];
    }else
    {
        [wechatImageV setImage:[UIImage imageNamed:@"pengyouquan"]];
        [wechatL setTextColor:[UIColor grayColor]];
    }
}
@end
