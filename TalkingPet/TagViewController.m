//
//  TagViewController.m
//  TalkingPet
//
//  Created by wangxr on 15/2/7.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "TagViewController.h"
#import "CreateTagViewController.h"
#import "CreatTagview.h"
#import "TagCell.h"

@interface TagCollectionHeaderView : UICollectionReusableView
@property (nonatomic,copy) void(^stretch)();
@property (nonatomic,retain)UILabel * titleLable;
@property (nonatomic,retain)UIButton * stretchB;//功能需求 已经移除
@end
@implementation TagCollectionHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
        [self addSubview:_titleLable];
        _titleLable.backgroundColor = [UIColor clearColor];
        _titleLable.textColor = [UIColor colorWithWhite:120/255.0 alpha:1];
        self.stretchB = [UIButton buttonWithType:UIButtonTypeCustom];
        
        //下面的Btn 没有使用 后期减少资源 可以更改
        [_stretchB setBackgroundImage:[UIImage imageNamed:@"moreTag"] forState:UIControlStateNormal];
        _stretchB.frame = CGRectMake(frame.size.width-55, 9, 48.4, 23.5);
        [_stretchB addTarget:self action:@selector(stretchAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_stretchB];
    }
    return self;
}
- (void)stretchAction
{
    if (_stretch) {
        _stretch();
    }
}
@end

@interface TagViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong)CreatTagview *cView;//创建标签的View 用block 回调传递创建的标签
@property (nonatomic,retain)NSMutableArray * hotTagArray;//热门标签
@property (nonatomic,retain)NSMutableArray * myTagArray;//自己的标签
@property (nonatomic,retain)NSArray * tagSectionArray;//所有分类标签
@property (nonatomic,strong)NSMutableArray * activityArray;//活动标签
@property (nonatomic,assign)CGSize size;//记录cell的大小
@property (nonatomic,strong)UICollectionView * faceCollectionV;//


@end
@implementation TagViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.canScrollBack = NO;
        self.title = @"选择标签";
        self.hotTagArray = [NSMutableArray array];
        NSArray * arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"WXRPublishHotTagArray"];
        for (NSDictionary * dic in arr) {
            Tag * tag = [Tag new];
            tag.tagID = dic[@"id"];
            tag.tagName = dic[@"name"];
            [_hotTagArray addObject:tag];
        }
        self.tagSectionArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"WXRPublishTagSectionArray"];
        
        NSDictionary * sectionDic = [_tagSectionArray firstObject];
        self.activityArray = [NSMutableArray array];
        for (NSDictionary * dic in sectionDic[@"tags"]) {
            Tag * tag = [Tag new];
            tag.tagID = dic[@"id"];
            tag.tagName = dic[@"name"];
            [self.activityArray addObject:tag];
        }
    }
    self.myTagArray = [NSMutableArray array];
    [self.myTagArray addObject:[self.hotTagArray firstObject]];
    
    
    
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBackButtonWithTarget:@selector(back)];
    [self setRightButtonWithName:@"完成" BackgroundImg:nil Target:@selector(userDefinedTag)];
    
    UIImageView * imageV= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-navigationBarHeight)];
    imageV.image = [UIImage imageNamed:@"tagBackGround"];
    [self.view addSubview:imageV];
    
    self.cView=[[CreatTagview alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    
    __weak TagViewController *weakself=self;
    self.cView.cblock=^(Tag *tag)
    {
        //后台没有做判断的，上传相同的标签，竟然返回不同的标签ID
        [weakself.myTagArray removeObject:tag];
        [weakself.myTagArray addObject:tag];
        [weakself.faceCollectionV reloadData];
        
    };
    
    
    
    [self.view addSubview:self.cView];
    
    
    UICollectionViewFlowLayout* faceLayout = [[UICollectionViewFlowLayout alloc]init];
    //    faceLayout.itemSize = CGSizeMake((self.view.frame.size.width-21)/2,40);
    faceLayout.sectionInset = UIEdgeInsetsMake(1, 5, 1, 5);
    faceLayout.minimumInteritemSpacing = 1;
    faceLayout.minimumLineSpacing = 5;
    faceLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    
    CGRect faceframe=CGRectMake(imageV.frame.origin.x, imageV.frame.origin.y+40, imageV.frame.size.width, imageV.frame.size.height-40);
    _faceCollectionV = [[UICollectionView alloc] initWithFrame:faceframe collectionViewLayout:faceLayout];
    _faceCollectionV.delegate = self;
    _faceCollectionV.dataSource = self;
    _faceCollectionV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_faceCollectionV];
    _faceCollectionV.showsHorizontalScrollIndicator = NO;
    
    [_faceCollectionV registerClass:[TagCell class] forCellWithReuseIdentifier:@"CollectionViewCell1"];
    
    
    [_faceCollectionV registerClass:[TagCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (_delegate&&[_delegate respondsToSelector:@selector(selectedTag:)]) {
            [_delegate selectedTag:nil];
        }
    }];
}
- (void)userDefinedTag
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (_delegate&&[_delegate respondsToSelector:@selector(selectedTag:)]) {
            [_delegate selectedTag:[_myTagArray firstObject]];
        }
    }];
}
#pragma mark - UICollectionView
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        Tag * tag = _myTagArray[indexPath.row];
        [_myTagArray removeObject:tag];
        [self.faceCollectionV reloadData];
    }
    if (indexPath.section==1) {
        Tag * tag = _hotTagArray[indexPath.row];
        [_myTagArray removeObject:tag];
        [_myTagArray addObject:tag];
        [self.faceCollectionV reloadData];
        
        
    }
    if (indexPath.section==2) {
        
        Tag * tag = _activityArray[indexPath.row];
        [_myTagArray removeObject:tag];
        [_myTagArray addObject:tag];
        [self.faceCollectionV reloadData];
        
        
        
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    //    if (section == 1 && !_myTagArray.count) {
    //        return CGSizeMake(self.view.frame.size.width, 0);
    //    }
    return CGSizeMake(self.view.frame.size.width, 40);
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (section) {
        case 0:{
            return _myTagArray.count;
        }break;
        case 1:{
            return _hotTagArray.count;
        }break;
        case 2:{
            return _activityArray.count;
        }break;
        default:{
            return 0;
        }break;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *SectionCellIdentifier = @"CollectionViewCell1";
    TagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SectionCellIdentifier forIndexPath:indexPath];
    
    
    for (UIView *view in [cell.contentView subviews])
    {
        [view removeFromSuperview];
    }
    
    
    
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    [cell.contentView addSubview:titleLable];
    titleLable.layer.masksToBounds=YES;
    titleLable.layer.cornerRadius=10;
    titleLable.layer.borderWidth=1;
    titleLable.layer.borderColor=CommonGreenColor.CGColor;
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.backgroundColor = [UIColor clearColor];
    titleLable.textColor = CommonGreenColor;
    titleLable.font = [UIFont systemFontOfSize:15];
    
    if (indexPath.section == 0) {
        cell.backgroundColor = [UIColor whiteColor];
        Tag * tag = _myTagArray[indexPath.row];
        titleLable.text = tag.tagName;
        titleLable.backgroundColor=CommonGreenColor;
        titleLable.textColor=[UIColor whiteColor];
    }else if (indexPath.section == 1) {
        cell.backgroundColor = [UIColor whiteColor];
        Tag * tag = _hotTagArray[indexPath.row];
        titleLable.text = tag.tagName;
    }else if (indexPath.section == 2) {
        cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
        Tag * tag = _activityArray[indexPath.row];
        titleLable.text = tag.tagName;
    }
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0)
    {
        _size = [[_myTagArray[indexPath.row] tagName] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
        return CGSizeMake(_size.width+1,25);
    }
    else if (indexPath.section ==1)
    {
        _size = [[_hotTagArray[indexPath.row] tagName] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
        return CGSizeMake(_size.width,25);
    }
    else
    {
        _size = [[_activityArray[indexPath.row] tagName] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
        return CGSizeMake(_size.width,25);
    }
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    static NSString *sdentifier = @"header";
    TagCollectionHeaderView * header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:sdentifier forIndexPath:indexPath];
    header.stretchB.hidden = YES;
    switch (indexPath.section) {
        case 0:{
            header.titleLable.text = @"个人标签";
        }break;
        case 1:{
            header.titleLable.text = @"热门标签";
        }break;
        case 2:{
            header.titleLable.text = @"活动标签";
        }break;
        default:
            break;
    }
    return header;
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
