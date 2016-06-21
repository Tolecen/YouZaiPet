//
//  MoreAccessoryViewController.m
//  TalkingPet
//
//  Created by wangxr on 15/2/3.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "MoreAccessoryViewController.h"
#import "AccessoryCell.h"
#import "Accessory.h"
#import "TFileManager.h"
@interface CollectionReusableHeaderView : UICollectionReusableView
@property (nonatomic,copy) void(^stretch)();
@property (nonatomic,retain)UILabel * titleLable;
@property (nonatomic,retain)UIButton * stretchB;
@end
@implementation CollectionReusableHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
        [self addSubview:_titleLable];
        _titleLable.backgroundColor = [UIColor clearColor];
        _titleLable.textColor = [UIColor whiteColor];
        self.stretchB = [UIButton buttonWithType:UIButtonTypeCustom];
        _stretchB.frame = CGRectMake(frame.size.width-40, 5, 30, 30);
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
@interface CollectionReusableFooterVuew : UICollectionReusableView
{
    UIView * lineView;
}
@end
@implementation CollectionReusableFooterVuew
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithWhite:148/255.0 alpha:1];
        lineView.frame = CGRectMake(20, 0, frame.size.width-40, frame.size.height);
        [self addSubview:lineView];
    }
    return self;
}
@end
@interface MoreAccessoryViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    int itemNo;
}
@property (nonatomic,copy)void(^action) (Accessory * acc);
@property (nonatomic,retain)NSMutableArray * sectionArr;
@end

@implementation MoreAccessoryViewController
- (instancetype)initWithSelectAction:(void (^)(Accessory * acc))action
{
    self = [super init];
    if (self) {
        self.action = action;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    itemNo = 4;
    if (self.view.frame.size.width>400) {
        itemNo = 5;
    }
    self.view.backgroundColor = [UIColor colorWithWhite:110/255.0 alpha:1];
    UIView * headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    headView.backgroundColor = [UIColor colorWithWhite:110/255.0 alpha:1];
    [self.view addSubview:headView];
    
    UIButton * BackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    BackButton.frame = CGRectMake(10, 6, 65, 32);
    [BackButton setBackgroundImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [BackButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:BackButton];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 32)];
    label.center = CGPointMake(CGRectGetMidX(headView.frame), CGRectGetMidY(headView.frame));
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:20];
    [headView addSubview:label];
    if ([self.accessoryType isEqualToString:@"mouth"]) {
        label.text = @"嘴型";
    }
    if ([self.accessoryType isEqualToString:@"costume"]) {
        label.text = @"装饰";
    }
    if ([self.accessoryType isEqualToString:@"dialog"]) {
        label.text = @"文字";
    }
    if ([self.accessoryType isEqualToString:@"rahmen"]) {
        label.text = @"相框";
    }
    
    NSArray * arr = [[[NSUserDefaults standardUserDefaults]objectForKey:@"WXRPublishAccessoryTree2"] objectForKey:_accessoryType];
    self.sectionArr = [NSMutableArray array];
    for (NSDictionary* dic in arr) {
        if (!((NSArray*)dic[@"decorations"]).count) {
            continue;
        }
        Section * se = [Section new];
        se.name = dic[@"name"];
        se.type = dic[@"type"];
        se.stretch = NO;
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
            
        }
        se.decorations =accary;
        [_sectionArr addObject:se];
    }
    
    UICollectionViewFlowLayout* faceLayout = [[UICollectionViewFlowLayout alloc]init];
    faceLayout.itemSize = CGSizeMake(70,90);
    faceLayout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);
    faceLayout.minimumInteritemSpacing = 5;
    faceLayout.minimumLineSpacing = 5;
    faceLayout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 40);
    faceLayout.footerReferenceSize = CGSizeMake(self.view.frame.size.width, 1);
    faceLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    UICollectionView * faceCollectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0,44, self.view.frame.size.width,self.view.frame.size.height-44) collectionViewLayout:faceLayout];
    faceCollectionV.delegate = self;
    faceCollectionV.dataSource = self;
    faceCollectionV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:faceCollectionV];
    faceCollectionV.showsHorizontalScrollIndicator = NO;
    [faceCollectionV registerClass:[AccessoryCell class] forCellWithReuseIdentifier:@"AccessoryCell"];
    [faceCollectionV registerClass:[CollectionReusableHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [faceCollectionV registerClass:[CollectionReusableFooterVuew class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
}
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UICollectionView
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    Section* se = _sectionArr[indexPath.section];
    if (!((Accessory * )se.decorations[indexPath.row]).exsit) {
        Accessory * acc = se.decorations[indexPath.row];
        __weak id blockSelf = self;
        if (!acc.loading) {
            NSString * fileName = [NSString stringWithFormat:@"%@.%@",acc.fileName,acc.fileType];
            acc.loading = YES;
            AccessoryCell * cell = (AccessoryCell *)[collectionView cellForItemAtIndexPath:indexPath];
            [cell.activity startAnimating];
            if ([acc.fileType isEqualToString:@"zip"]) {
                [NetServer downloadZipFileWithUrl:acc.url ZipName:fileName Success:^(NSString *zipfileName) {
                    acc.exsit = YES;
                    acc.loading = NO;
                    if (blockSelf) {
                        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
                    }
                } failure:^(NSError *error) {
                    acc.loading = NO;
                    if (blockSelf) {
                        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
                    }
                }];
            }
            if ([acc.fileType isEqualToString:@"png"]) {
                [NetServer downloadImageFileWithUrl:acc.url imageName:fileName Success:^(NSString *imagefileName) {
                    acc.exsit = YES;
                    acc.loading = NO;
                    if (blockSelf) {
                        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
                    }
                } failure:^(NSError *error) {
                    acc.loading = NO;
                    if (blockSelf) {
                        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
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
    if (_action) {
        Accessory * acc = ((Section*)_sectionArr[indexPath.section]).decorations[indexPath.row];
        _action(acc);
    }
    [self back];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _sectionArr.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    Section* se = _sectionArr[section];
    if (se.stretch||se.decorations.count<itemNo) {
        return se.decorations.count;
    }else
    {
        return itemNo;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SectionCellIdentifier = @"AccessoryCell";
    AccessoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SectionCellIdentifier forIndexPath:indexPath];
    Accessory* acc = ((Section*)_sectionArr[indexPath.section]).decorations[indexPath.row];
    cell.imageV.imageURL = acc.thumbnail;
    if (acc.loading) {
        [cell.activity startAnimating];
    }else
    {
        if (acc.exsit) {
            cell.stateIV.image = [UIImage imageNamed:@"use"];
        }else
        {
            cell.stateIV.image = [UIImage imageNamed:@"downLoad"];
        }
        [cell.activity stopAnimating];
    }
    if ([acc.type isEqualToString:@"rahmen"]&&[acc.fileName isEqualToString:@"rahmenNone"]) {
        cell.imageV.image = [UIImage imageNamed:@"rahmenNone"];
    }
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        static NSString *sdentifier1 = @"header";
        Section* se = _sectionArr[indexPath.section];
        CollectionReusableHeaderView * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sdentifier1 forIndexPath:indexPath];
        header.titleLable.text = se.name;
        if (se.stretch) {
            [header.stretchB setBackgroundImage:[UIImage imageNamed:@"stretch"] forState:UIControlStateNormal];
        }else
        {
            [header.stretchB setBackgroundImage:[UIImage imageNamed:@"put_away"] forState:UIControlStateNormal];
        }
        header.stretch = ^{
            se.stretch = !se.stretch;
            [collectionView reloadSections:[[NSIndexSet alloc]initWithIndex:indexPath.section]];
        };
        return header;
    }else
    {
        static NSString *sdentifier2 = @"footer";
        CollectionReusableFooterVuew * footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:sdentifier2 forIndexPath:indexPath];
        return footer;
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
