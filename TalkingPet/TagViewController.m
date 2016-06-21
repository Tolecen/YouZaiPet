//
//  TagViewController.m
//  TalkingPet
//
//  Created by wangxr on 15/2/7.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "TagViewController.h"
#import "CreateTagViewController.h"
#import "TagCell.h"

@interface TagCollectionHeaderView : UICollectionReusableView
@property (nonatomic,copy) void(^stretch)();
@property (nonatomic,retain)UILabel * titleLable;
@property (nonatomic,retain)UIButton * stretchB;
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
@property (nonatomic,retain)NSMutableArray * hotTagArray;
@property (nonatomic,retain)NSArray * myTagArray;
@property (nonatomic,retain)NSArray * tagSectionArray;
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
        self.myTagArray = [DatabaseServe getNewTagArrayWithSize:100];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBackButtonWithTarget:@selector(back)];
    [self setRightButtonWithName:@"自定义" BackgroundImg:nil Target:@selector(userDefinedTag)];
    
    UIImageView * imageV= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-navigationBarHeight)];
    imageV.image = [UIImage imageNamed:@"tagBackGround"];
    [self.view addSubview:imageV];
    
    UICollectionViewFlowLayout* faceLayout = [[UICollectionViewFlowLayout alloc]init];
    faceLayout.itemSize = CGSizeMake((self.view.frame.size.width-21)/2,40);
    faceLayout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);
    faceLayout.minimumInteritemSpacing = 1;
    faceLayout.minimumLineSpacing = 1;
    faceLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    UICollectionView * faceCollectionV = [[UICollectionView alloc] initWithFrame:imageV.frame collectionViewLayout:faceLayout];
    faceCollectionV.delegate = self;
    faceCollectionV.dataSource = self;
    faceCollectionV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:faceCollectionV];
    faceCollectionV.showsHorizontalScrollIndicator = NO;
    [faceCollectionV registerClass:[TagCell class] forCellWithReuseIdentifier:@"CollectionViewCell"];
    [faceCollectionV registerClass:[TagCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
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
    CreateTagViewController * createVC = [[CreateTagViewController alloc] init];
    createVC.delegate = self.delegate;
    [self.navigationController pushViewController:createVC animated:NO];
}
#pragma mark - UICollectionView
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        Tag * tag = _hotTagArray[indexPath.row];
        if (_delegate&&[_delegate respondsToSelector:@selector(selectedTag:)]) {
            [self dismissViewControllerAnimated:YES completion:^{
                [_delegate selectedTag:tag];
            }];
        }
    }
    if (indexPath.section==1) {
        Tag * tag = _myTagArray[indexPath.row];
        if (_delegate&&[_delegate respondsToSelector:@selector(selectedTag:)]) {
            [self dismissViewControllerAnimated:YES completion:^{
                [_delegate selectedTag:tag];
            }];
        }
    }
    if (indexPath.section==2) {
        MoreTagViewController * moreVC = [[MoreTagViewController alloc] init];
        NSDictionary * sectionDic = _tagSectionArray[indexPath.row];
        moreVC.title = sectionDic[@"name"];
        moreVC.delegate = self.delegate;
        moreVC.tagArray = ({
            NSMutableArray * array = [NSMutableArray array];
            for (NSDictionary * dic in sectionDic[@"tags"]) {
                Tag * tag = [Tag new];
                tag.tagID = dic[@"id"];
                tag.tagName = dic[@"name"];
                [array addObject:tag];
            }
            array;
        });
        [self.navigationController pushViewController:moreVC animated:YES];
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 1 && !_myTagArray.count) {
        return CGSizeMake(self.view.frame.size.width, 0);
    }
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
            return _hotTagArray.count>6?6:_hotTagArray.count;
        }break;
        case 1:{
            return _myTagArray.count>4?4:_myTagArray.count;
        }break;
        case 2:{
            return _tagSectionArray.count;
        }break;
        default:{
            return 0;
        }break;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SectionCellIdentifier = @"CollectionViewCell";
    TagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SectionCellIdentifier forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.backgroundColor = [UIColor whiteColor];
        Tag * tag = _hotTagArray[indexPath.row];
        cell.titleLable.text = tag.tagName;
    }else if (indexPath.section == 1) {
        cell.backgroundColor = [UIColor whiteColor];
        Tag * tag = _myTagArray[indexPath.row];
        cell.titleLable.text = tag.tagName;
    }else if (indexPath.section == 2) {
        cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
        NSDictionary * dic = _tagSectionArray[indexPath.row];
        cell.titleLable.text = dic[@"name"];
    }
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    static NSString *sdentifier = @"header";
    TagCollectionHeaderView * header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:sdentifier forIndexPath:indexPath];
    header.stretchB.hidden = NO;
    switch (indexPath.section) {
        case 0:{
            header.titleLable.text = @"热门标签";
            header.stretch = ^{
                MoreTagViewController * moreVC = [[MoreTagViewController alloc] init];
                moreVC.delegate = self.delegate;
                moreVC.tagArray = _hotTagArray;
                moreVC.title = @"热门标签";
                [self.navigationController pushViewController:moreVC animated:YES];
            };
        }break;
        case 1:{
            header.titleLable.text = @"个人标签";
            header.stretch = ^{
                MoreTagViewController * moreVC = [[MoreTagViewController alloc] init];
                moreVC.delegate = self.delegate;
                moreVC.tagArray = _myTagArray;
                moreVC.title = @"个人标签";
                [self.navigationController pushViewController:moreVC animated:YES];
            };
        }break;
        case 2:{
            header.titleLable.text = @"标签分类";
            header.stretchB.hidden = YES;
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
