//
//  DecorateViewController.m
//  TalkingPet
//
//  Created by wangxr on 15/2/2.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "DecorateViewController.h"
#import "SVProgressHUD.h"
#import "SoundTouchViewController.h"
#import "FinalPublishPageViewController.h"
#import "AccessoryCell.h"
#import "AccessoryView.h"
#import "TextAccessoryView.h"
#import "MoreAccessoryViewController.h"
#import "SlightEditBar.h"
#import "TFileManager.h"
#import "SlightEditBar.h"
#import "ImageFilter.h"

@interface MoreCell : UICollectionViewCell
@property (nonatomic,retain)UIImageView*imageView;
@end
@implementation MoreCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 63, 63)];
        [self.contentView addSubview:_imageView];
    }
    return self;
}
@end
@interface Filter  : Accessory//滤镜实体
@property (nonatomic,retain)NSString * imageName;
@property (nonatomic,assign)IImageFilter * filter;
@end
@implementation Filter

@end

vector<IImageFilter*> vectorFilter = LoadFilterVector();
@interface DecorateViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,AccessoryViewDelegate,SlightEditBarDelegate>
{
    UIImageView * imageV;
    AccessoryView * currentEditAccessoryView;
}
@property (nonatomic,retain)NSMutableArray * sectionButtonArray;
@property (nonatomic,retain)NSArray * normalA;
@property (nonatomic,retain)NSArray * highlightedA;

@property (nonatomic,retain)NSString * currentType;
@property (nonatomic,retain)NSArray * currentHotList;
@property (nonatomic,retain)UICollectionView * faceCollectionV;

@property (nonatomic,retain)NSMutableArray * staticAccessoryArr;
@property (nonatomic,retain)AccessoryView * mouthAccessoryView;
@property (nonatomic,retain)UIImageView * photoFrameIV;

@property (nonatomic,retain)SlightEditBar * slightEditView;
@end

@implementation DecorateViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.staticAccessoryArr = [NSMutableArray array];
        
        self.sectionButtonArray = [NSMutableArray array];
        if ([SystemServer sharedSystemServer].publishstatu == PublishStatuPetalk) {
            self.highlightedA = @[@"mouth",@"costume",@"dialog",@"rahmen",@"filter"];
            self.normalA = @[@"mouth_normal",@"costume_normal",@"dialog_normal",@"rahmen_normal",@"filter_normal"];
        }else
        {
            self.highlightedA = @[@"costume",@"dialog",@"rahmen",@"filter"];
            self.normalA = @[@"costume_normal",@"dialog_normal",@"rahmen_normal",@"filter_normal"];
        }
        [self buildCurrentHotListWithType:[_highlightedA firstObject]];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithWhite:110/255.0 alpha:1];
    [self setHeaderView];
    
    NSData * data = UIImageJPEGRepresentation(_talkingPublish.originalImg, 1);
    _talkingPublish.originalImg = [UIImage imageWithData:data];
    
    imageV = [[UIImageView alloc] init];
    if (self.view.frame.size.height-self.view.frame.size.width-160>0) {
        imageV.frame = CGRectMake(0, 88, self.view.frame.size.width, self.view.frame.size.width);
    }else
    {
        imageV.frame = CGRectMake(0, 44, self.view.frame.size.width-50, self.view.frame.size.width-50);
    }
    imageV.center = CGPointMake(self.view.center.x, imageV .center.y);
    imageV.image = _talkingPublish.originalImg;
    imageV.userInteractionEnabled = YES;
    imageV.clipsToBounds = YES;
    [self.view addSubview:imageV];
    
    self.photoFrameIV = [[UIImageView alloc] initWithFrame:imageV.frame];
    _photoFrameIV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_photoFrameIV];
    
    UICollectionViewFlowLayout* faceLayout = [[UICollectionViewFlowLayout alloc]init];
    faceLayout.itemSize = CGSizeMake(70,70);
    faceLayout.minimumInteritemSpacing = 5;
    faceLayout.minimumLineSpacing = 5;
    faceLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.faceCollectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-120, self.view.frame.size.width,70) collectionViewLayout:faceLayout];
    _faceCollectionV.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _faceCollectionV.delegate = self;if (self.view.frame.size.width>320) {
        _faceCollectionV.frame = CGRectOffset(_faceCollectionV.frame, 0, -10);
    }
    _faceCollectionV.dataSource = self;
    _faceCollectionV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_faceCollectionV];
    _faceCollectionV.showsHorizontalScrollIndicator = NO;
    [_faceCollectionV registerClass:[AccessoryCell class] forCellWithReuseIdentifier:@"AccessoryCell"];
    [_faceCollectionV registerClass:[MoreCell class] forCellWithReuseIdentifier:@"MoreCell"];
    self.slightEditView = [[SlightEditBar alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageV.frame), self.view.frame.size.width, 40) delegate:self];
    [self.view addSubview:_slightEditView];
    [self.view insertSubview:self.slightEditView belowSubview:imageV];
    
    if ([SystemServer sharedSystemServer].publishstatu == PublishStatuPetalk) {
        self.mouthAccessoryView = [[AccessoryView alloc] initWithFrame:CGRectMake(0, 0, 120, 120) WXRAccessoryType:WXRAccessoryTypeMustHave];
        _mouthAccessoryView.center = CGPointMake(CGRectGetMidX([imageV bounds]), CGRectGetMidY([imageV bounds]));
        _mouthAccessoryView.delegate = self;
        [imageV addSubview:_mouthAccessoryView];
        _mouthAccessoryView.accessory = [_currentHotList firstObject];
        currentEditAccessoryView = _mouthAccessoryView;
        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"EditBarPrompt"]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"EditBarPrompt"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            PromptView * p = [[PromptView alloc] initWithPoint:CGPointMake(self.slightEditView.center.x, CGRectGetMaxY(self.slightEditView.frame)+10) image:[UIImage imageNamed:@"weitiao_prompt"] arrowDirection:1];
            [self.view addSubview:p];
            [p show];
        }
    }else
    {
        _slightEditView.alpha = 0;
        _slightEditView.frame = CGRectMake(0, CGRectGetMaxY(imageV.frame)-40, self.view.frame.size.width, 40);
    }
    
    UIView * downView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-49, self.view.frame.size.width, 49)];
    downView.backgroundColor = [UIColor colorWithWhite:66/255.0 alpha:1];
    [self.view addSubview:downView];
    
    for (int i = 0; i <_normalA.count; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10+(self.view.frame.size.width-62.5)*i/(_normalA.count-1), 0, 42.5, 42.6);
        [_sectionButtonArray insertObject:button atIndex:i];
        [button addTarget:self action:@selector(changeCurrentSection:) forControlEvents:UIControlEventTouchUpInside];
        [downView addSubview:button];
        if (i) {
            [button setBackgroundImage:[UIImage imageNamed:_normalA[i]] forState:UIControlStateNormal];
        }else
        {
            [button setBackgroundImage:[UIImage imageNamed:_highlightedA[i]] forState:UIControlStateNormal];
        }
    }
    
}
- (void)setHeaderView
{
    UIView * headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    headView.backgroundColor = [UIColor colorWithWhite:110/255.0 alpha:1];
    [self.view addSubview:headView];
    
    UIButton * BackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    BackButton.frame = CGRectMake(10, 6, 65, 32);
    [BackButton setBackgroundImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [BackButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:BackButton];
    
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(self.view.frame.size.width-90, 6, 85, 32);
    [rightButton setTitle:@"下一步" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [rightButton addTarget:self action:@selector(goToSoundTouch) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:rightButton];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 32)];
    label.center = CGPointMake(CGRectGetMidX(headView.frame), CGRectGetMidY(headView.frame));
    label.backgroundColor = [UIColor clearColor];
    label.text = @"编辑";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:20];
    [headView addSubview:label];
}
- (void)changeCurrentSection:(UIButton *)btn
{
    for (int i = 0; i <_normalA.count; i++){
        UIButton * button = _sectionButtonArray[i];
        if ([button isEqual:btn]) {
            [button setBackgroundImage:[UIImage imageNamed:_highlightedA[i]] forState:UIControlStateNormal];
            [self reloadFaceCollectionViewWithSectionType:_highlightedA[i]];
        }else
        {
            [button setBackgroundImage:[UIImage imageNamed:_normalA[i]] forState:UIControlStateNormal];
        }
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if ([touch.view isEqual:imageV]) {
        [imageV bringSubviewToFront:_mouthAccessoryView];
        [_mouthAccessoryView playAnimation];
        [currentEditAccessoryView hiddenEditRect];
        [self hiddenSlightEditBar];
    }
}
- (void)goToSoundTouch
{
    CGFloat width = [_mouthAccessoryView getImageViewWidth]/imageV.frame.size.width;
    CGFloat height = [_mouthAccessoryView getImageViewHeight]/imageV.frame.size.height;
    CGFloat rotationZ = _mouthAccessoryView.radianZ;
    CGFloat rotationY = _mouthAccessoryView.radianY;
    CGFloat rotationX = _mouthAccessoryView.radianX;
    CGFloat centerX = _mouthAccessoryView.center.x/imageV.frame.size.width;
    CGFloat centerY = _mouthAccessoryView.center.y/imageV.frame.size.height;
    self.talkingPublish.mouthAccessory = _mouthAccessoryView.accessory;
    self.talkingPublish.animationImg = animationImgMake([_mouthAccessoryView.accessory.accID integerValue], width, height, centerX, centerY, rotationX, rotationY, rotationZ) ;
    self.talkingPublish.publishImg = [self getPublishImage];
    self.talkingPublish.thumImg = [self getThumImage];
    if ([SystemServer sharedSystemServer].publishstatu == PublishStatuPetalk) {
        SoundTouchViewController * soundVC = [[SoundTouchViewController alloc] init];
        soundVC.talkingPublish = _talkingPublish ;
        [self.navigationController pushViewController:soundVC animated:YES];
       
    }
    if ([SystemServer sharedSystemServer].publishstatu == PublishStatuPicture) {
        FinalPublishPageViewController * PublishVC = [[FinalPublishPageViewController alloc] init];
        PublishVC.talkingPublish = self.talkingPublish;
        [self.navigationController pushViewController:PublishVC animated:YES];
    }
   
}
- (void)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)reloadFaceCollectionViewWithSectionType:(NSString *)type
{
    [self buildCurrentHotListWithType:type];
    [_faceCollectionV reloadData];
}
- (void)buildCurrentHotListWithType:(NSString *)type
{
    self.currentType = type;
    if ([_currentType isEqualToString:@"filter"]) {
        NSMutableArray * accary= [NSMutableArray array];
        for (int i = 0; i < vectorFilter.size(); i++) {
            Filter * filter = [Filter new];
            filter.type = @"filter";
            filter.loading = NO;
            filter.exsit = YES;
            filter.imageName = [NSString stringWithFormat:@"filter%d",i+1];
            filter.filter = vectorFilter[i];
            [accary addObject:filter];
        }
        self.currentHotList =accary;
        return;
    }
    self.currentHotList = [DatabaseServe getNewAccessorysWithType:type size:15];
    if (!_currentHotList.count) {
        NSArray * arr = [[[NSUserDefaults standardUserDefaults]objectForKey:@"WXRPublishAccessoryTree2"] objectForKey:type];
        for (NSDictionary* dic in arr) {
            if (!((NSArray*)dic[@"decorations"]).count) {
                continue;
            }
            NSMutableArray * accary= [NSMutableArray array];
            for (NSDictionary *childDic in dic[@"decorations"]) {
                Accessory * acc = [Accessory new];
                acc.fileName = childDic[@"fileName"];
                acc.fileType = childDic[@"fileType"];
                acc.type = childDic[@"type"];
                acc.accID = childDic[@"id"];
                acc.thumbnail = [NSURL URLWithString:childDic[@"thumbnail"]];
                acc.url = childDic[@"url"];
                acc.loading = NO;
                [accary addObject:acc];
                if ([acc.fileType isEqualToString:@"zip"]) {
                    acc.exsit = [TFileManager ifExsitFolder:acc.fileName];
                }
                if ([acc.fileType isEqualToString:@"png"]) {
                    acc.exsit = [TFileManager ifExsitFile:[NSString stringWithFormat:@"%@.%@",acc.fileName,acc.fileType]];
                }
                [DatabaseServe saveAccessory:acc];
            }
            self.currentHotList = accary;
            break;
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - AccessoryView
- (void)removeAccessoryViewFromSuperView:(AccessoryView*)view
{
    [self.staticAccessoryArr removeObject:view];
    [self hiddenSlightEditBar];
}
- (void)beginEditAccessory:(AccessoryView*)view
{
    if (![view isEqual:_mouthAccessoryView]&&![[_staticAccessoryArr lastObject] isEqual:view]) {
        [_staticAccessoryArr removeObject:view];
        [_staticAccessoryArr addObject:view];
    }
    currentEditAccessoryView = view;
    [view showEditRect];
    [self showSlightEditBar];
}
- (void)editingAccessory:(AccessoryView*)view
{
    
}
- (void)endEditAccessory:(AccessoryView*)view
{
    if ([currentEditAccessoryView isEqual:view]) {
        currentEditAccessoryView = nil;
    }
    [view hiddenEditRect];
}
#pragma mark - SlightEditBar
- (void)showSlightEditBar
{
    if (!_slightEditView.alpha) {
        [UIView animateWithDuration:0.2 animations:^{
            _slightEditView.alpha = 1;
            _slightEditView.frame = CGRectMake(0, CGRectGetMaxY(imageV.frame), self.view.frame.size.width, 40);
        } completion:^(BOOL finished) {
            if (![[NSUserDefaults standardUserDefaults] objectForKey:@"EditBarPrompt"]) {
                [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"EditBarPrompt"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                PromptView * p = [[PromptView alloc] initWithPoint:CGPointMake(self.slightEditView.center.x, CGRectGetMaxY(self.slightEditView.frame)+10) image:[UIImage imageNamed:@"weitiao_prompt"] arrowDirection:1];
                [self.view addSubview:p];
                [p show];
            }
        }];

    }
}
- (void)hiddenSlightEditBar
{
    if (_slightEditView.alpha==1) {
        [UIView animateWithDuration:0.2 animations:^{
            _slightEditView.alpha = 0;
            _slightEditView.frame = CGRectMake(0, CGRectGetMaxY(imageV.frame)-40, self.view.frame.size.width, 40);
        }];
    }
}
-(void)slightEditBarEnlargedAction:(SlightEditBar*)bar
{
    [currentEditAccessoryView enlarged];
}
-(void)slightEditBarReducedAction:(SlightEditBar*)bar
{
    [currentEditAccessoryView reduced];
}
-(void)slightEditBarRotateLeftAction:(SlightEditBar*)bar
{
    [currentEditAccessoryView rotateLeft];
}
-(void)slightEditBarRotateRightAction:(SlightEditBar*)bar
{
    [currentEditAccessoryView rotateRight];
}
-(void)slightEditBarResetAction:(SlightEditBar*)bar
{
    [currentEditAccessoryView restoreToSize:CGSizeMake(120, 120)];
}
#pragma mark - UICollectionView
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section!=2) {
        return YES;
    }
    if (!((Accessory * )_currentHotList[indexPath.row]).exsit) {
        Accessory * acc = _currentHotList[indexPath.row];
        if (!acc.loading) {
            NSString * fileName = [NSString stringWithFormat:@"%@.%@",acc.fileName,acc.fileType];
            acc.loading = YES;
            AccessoryCell * cell = (AccessoryCell *)[collectionView cellForItemAtIndexPath:indexPath];
            [cell.activity startAnimating];
            __weak id blockSelf = self;
            if ([acc.fileType isEqualToString:@"zip"]) {
                [NetServer downloadZipFileWithUrl:acc.url ZipName:fileName Success:^(NSString *zipfileName) {
                    acc.exsit = YES;
                    acc.loading = NO;
                    if (blockSelf&&[acc.type isEqualToString:_currentType]) {
                        [_faceCollectionV reloadItemsAtIndexPaths:@[indexPath]];
                    }
                } failure:^(NSError *error) {
                    acc.loading = NO;
                    if (blockSelf&&[acc.type isEqualToString:_currentType]) {
                        [_faceCollectionV reloadItemsAtIndexPaths:@[indexPath]];
                    }
                }];
            }
            if ([acc.fileType isEqualToString:@"png"]) {
                [NetServer downloadImageFileWithUrl:acc.url imageName:fileName Success:^(NSString *imagefileName) {
                    acc.exsit = YES;
                    acc.loading = NO;
                    if (blockSelf&&[acc.type isEqualToString:_currentType]) {
                        [_faceCollectionV reloadItemsAtIndexPaths:@[indexPath]];
                    }
                } failure:^(NSError *error) {
                    acc.loading = NO;
                    if (blockSelf&&[acc.type isEqualToString:_currentType]) {
                        [_faceCollectionV reloadItemsAtIndexPaths:@[indexPath]];
                    }
                }];
            }
        }
        return NO;
    }
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        MoreAccessoryViewController * moreVC = [[MoreAccessoryViewController alloc] initWithSelectAction:^(Accessory *acc) {
            [self editImagewithAccessory:acc];
        }];
        moreVC.accessoryType = self.currentType;
        [self presentViewController:moreVC animated:YES completion:nil];
        
    }else if (indexPath.section == 1){
        if ([_currentType isEqualToString:@"filter"]) {
            imageV.image = _talkingPublish.originalImg;
        }else if ([_currentType isEqualToString:@"rahmen"]){
            _photoFrameIV.image = nil;
        }
    }else
    {
        Accessory * acc = [_currentHotList objectAtIndex:indexPath.row];
        [self editImagewithAccessory:acc];
    }
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (section) {
        case 0:{
            if ([_currentType isEqualToString:@"filter"]) {
                return 0;
            }
            return 1;
        }break;
        case 1:{
            if ([_currentType isEqualToString:@"rahmen"]||[_currentType isEqualToString:@"filter"]) {
                return 1;
            }else
            {
                return 0;
            }
        }break;
        default:{
            return  _currentHotList.count;
        }break;
    }
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *SectionCellIdentifier = @"MoreCell";
        MoreCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SectionCellIdentifier forIndexPath:indexPath];
        cell.imageView.image = [UIImage imageNamed:@"moreAccessory"];
        return cell;
    }else if(indexPath.section == 1){
        static NSString *SectionCellIdentifier = @"MoreCell";
        MoreCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SectionCellIdentifier forIndexPath:indexPath];
        cell.imageView.image = [UIImage imageNamed:@"rahmenNone"];
        return cell;
    }else
    {
        static NSString *SectionCellIdentifier = @"AccessoryCell";
        AccessoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SectionCellIdentifier forIndexPath:indexPath];
        Accessory* acc = _currentHotList[indexPath.row];
        cell.imageV.imageURL = acc.thumbnail;
        if (acc.loading) {
            [cell.activity startAnimating];
        }else
        {
            [cell.activity stopAnimating];
        }
        if ([acc.type isEqualToString:@"rahmen"]&&[acc.fileName isEqualToString:@"rahmenNone"]) {
            cell.imageV.image = [UIImage imageNamed:@"rahmenNone"];
        }
        if ([acc.type isEqualToString:@"filter"]) {
            Filter * filter = _currentHotList[indexPath.row];
            cell.imageV.image = [UIImage imageNamed:filter.imageName];
        }
        return cell;
    }
}
- (void)editImagewithAccessory:(Accessory*)acc
{
    [DatabaseServe saveAccessory:acc];
    if ([acc.type isEqualToString:@"mouth"]) {
        _mouthAccessoryView.accessory = acc;
        _mouthAccessoryView.delegate = self;
        [imageV bringSubviewToFront:_mouthAccessoryView];
    }
    if ([acc.type isEqualToString:@"costume"]) {
        int offsetX = arc4random()%((int)imageV.frame.size.width-120)-((int)imageV.frame.size.width-120)/2;
        int offsetY = arc4random()%((int)imageV.frame.size.height-120)-((int)imageV.frame.size.width-120)/2;
        AccessoryView*accessoryView = [[AccessoryView alloc] initWithFrame:CGRectMake(0, 0, 120, 120) WXRAccessoryType:WXRAccessoryTypeAnyway];
        accessoryView.accessoryType = WXRAccessoryTypeAnyway;
        accessoryView.delegate = self;
        accessoryView.center = CGPointMake(CGRectGetMidX([imageV bounds])+offsetX, CGRectGetMidY([imageV bounds])+offsetY);
        accessoryView.accessory = acc;
        [imageV addSubview:accessoryView];
    }
    if ([acc.type isEqualToString:@"dialog"]) {
        int offsetX = arc4random()%((int)imageV.frame.size.width-120)-((int)imageV.frame.size.width-120)/2;
        int offsetY = arc4random()%((int)imageV.frame.size.height-120)-((int)imageV.frame.size.width-120)/2;
        TextAccessoryView*accessoryView = [[TextAccessoryView alloc] initWithFrame:CGRectMake(0, 0, 120, 120) WXRAccessoryType:WXRAccessoryTypeAnyway];
        accessoryView.accessoryType = WXRAccessoryTypeAnyway;
        accessoryView.delegate = self;
        accessoryView.center = CGPointMake(CGRectGetMidX([imageV bounds])+offsetX, CGRectGetMidY([imageV bounds])+offsetY);
        accessoryView.accessory = acc;
        [imageV addSubview:accessoryView];
    }
    if ([acc.type isEqualToString:@"rahmen"]) {
        _photoFrameIV.image = [TFileManager getImageWithID:acc.fileName];
    }
    if ([acc.type isEqualToString:@"filter"]) {
        IImageFilter *filter = ((Filter*)acc).filter;
        if (!filter) {
            imageV.image = _talkingPublish.originalImg;
            return ;
        }
        [SVProgressHUD showWithStatus:@"正在转换"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            Image image = Image::Image(_talkingPublish.originalImg.CGImage);
            image = filter->process(image);
            UIImage *finalImage = [UIImage imageWithCGImage:image.destImage];
            image.Destroy();
            dispatch_async(dispatch_get_main_queue(), ^{
                imageV.image = finalImage;
                [SVProgressHUD dismiss];
            });
        });
    }
}
#pragma mark -
- (UIImage*)getPublishImage
{
    UIImageView * view = [[UIImageView alloc] initWithFrame:{CGPointZero,_talkingPublish.originalImg.size}];
    view.image = imageV.image;
    for (AccessoryView * accessoryView in _staticAccessoryArr) {
        UIImageView * imgV = [[UIImageView alloc] initWithFrame:CGRectZero];
        imgV.image = [accessoryView getAccessoryStaticImage];
        CGFloat width = [accessoryView getImageViewWidth]/imageV.frame.size.width;
        CGFloat height = [accessoryView getImageViewHeight]/imageV.frame.size.height;
        CGFloat rotationZ = accessoryView.radianZ;
        CGFloat centerX = accessoryView.center.x/imageV.frame.size.height;
        CGFloat centerY = accessoryView.center.y/imageV.frame.size.height;
        imgV.frame = CGRectMake(0, 0, width*view.frame.size.width, height*view.frame.size.height);
        imgV.center = CGPointMake(centerX*view.frame.size.width, centerY*view.frame.size.height);
        imgV.transform = CGAffineTransformRotate(imgV.transform, rotationZ);
        [view addSubview:imgV];
    }
    UIImageView * imgV = [[UIImageView alloc] initWithFrame:view.bounds];
    imgV.image = _photoFrameIV.image;
    [view addSubview:imgV];
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (UIImage*)getThumImage
{
    UIImageView * view = [[UIImageView alloc] initWithFrame:{CGPointZero,{300,300}}];
    view.image = _talkingPublish.publishImg;
    UIImageView * imgV = [[UIImageView alloc] initWithFrame:CGRectZero];
    imgV.image = [_mouthAccessoryView getAccessoryStaticImage];
    CGFloat width = [_mouthAccessoryView getImageViewWidth]/imageV.frame.size.width;
    CGFloat height = [_mouthAccessoryView getImageViewHeight]/imageV.frame.size.height;
    CGFloat rotationZ = _mouthAccessoryView.radianZ;
    CGFloat centerX = _mouthAccessoryView.center.x/imageV.frame.size.width;
    CGFloat centerY = _mouthAccessoryView.center.y/imageV.frame.size.height;
    imgV.frame = CGRectMake(0, 0, width*view.frame.size.width, height*view.frame.size.height);
    imgV.center = CGPointMake(centerX*view.frame.size.width, centerY*view.frame.size.height);
    imgV.transform = CGAffineTransformRotate(imgV.transform, rotationZ);
    [view addSubview:imgV];
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
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
