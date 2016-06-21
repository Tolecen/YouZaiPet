//
//  ImageAssetsViewController.m
//  TalkingPet
//
//  Created by wangxr on 15/3/26.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "ImageAssetsViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "NSMutableArray+Asset.h"
#import "PublishServer.h"
#import "SVProgressHUD.h"
@interface AssetsCell : UICollectionViewCell
@property (nonatomic,retain)UIImageView * imageView;
@property (nonatomic,retain)UIImageView * stateView;
@end
@implementation AssetsCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.contentView addSubview:_imageView];
        self.stateView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-36, 4, 32, 32)];
        [self.contentView addSubview:_stateView];
    }
    return self;
}
@end
@interface ImageAssetsViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    ALAssetsLibrary * assetsLibrary;
    ALAssetsGroup * currentGroup;
    UIButton * titleBtn;
    UIImageView * titleImg;
    UITableView * blackView;
    UICollectionView * imageCollectionView;
}
@property (nonatomic, retain) NSMutableArray *groupArray;
@property (nonatomic, retain) NSMutableArray *assetsArray;
@property (nonatomic, retain) NSMutableArray *selectedAssets;
@property (nonatomic, retain) NSMutableArray *appends;
@end

@implementation ImageAssetsViewController
-(void)setSelectedArray:(NSMutableArray*)array
{
    [_selectedAssets addObjectsFromArray:array];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!assetsLibrary) {
        [SVProgressHUD showWithStatus:@"正在努力地加载照片"];
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!assetsLibrary) {
        __block NSMutableArray * blockGroupArray = _groupArray;
        __block NSMutableArray * blockAssetsArray = _assetsArray;
        void (^assetsGroupsSavedPhotosEnumerationBlock)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *assetsGroup, BOOL *stop) {
            [assetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
            if(assetsGroup) {
                [blockGroupArray insertObject:assetsGroup atIndex:0];
                currentGroup = assetsGroup;
                [titleBtn setTitle:[currentGroup valueForProperty:ALAssetsGroupPropertyName] forState:UIControlStateNormal];
                CGSize size = [titleBtn.titleLabel.text sizeWithFont:titleBtn.titleLabel.font constrainedToSize:CGSizeMake(150, 32) lineBreakMode:NSLineBreakByWordWrapping];
                titleBtn.frame = CGRectMake(0, 0, size.width, 32);
                titleImg.frame = CGRectMake(titleBtn.frame.size.width, 1, 30, 30);
                [currentGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                    if(result) {
                        [blockAssetsArray insertObject:result atIndex:0];
                    }
                    if (index == assetsGroup.numberOfAssets-1) {
                        [SVProgressHUD dismiss];
                        [imageCollectionView reloadData];
                    }
                }];
            }else{
                [SVProgressHUD dismiss];
            }
        };
        void (^assetsGroupsEnumerationBlock)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *assetsGroup, BOOL *stop) {
            [assetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
            if(assetsGroup&&assetsGroup.numberOfAssets>0) {
                [blockGroupArray addObject:assetsGroup];
                if (!currentGroup.numberOfAssets) {
                    currentGroup = assetsGroup;
                    [currentGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                        if(result) {
                            [blockAssetsArray insertObject:result atIndex:0];
                        }
                        if (index == assetsGroup.numberOfAssets-1) {
                            [imageCollectionView reloadData];
                        }
                    }];
                }
            }
        };
        
        void (^assetsGroupsFailureBlock)(NSError *) = ^(NSError *error) {
            [SVProgressHUD dismiss];
            NSLog(@"Error: %@", [error localizedDescription]);
        };
        assetsLibrary = [PublishServer sharedPublishServer].assetsLibrary;
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:assetsGroupsSavedPhotosEnumerationBlock failureBlock:assetsGroupsFailureBlock];
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
    }
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.groupArray = [NSMutableArray array];
        self.assetsArray = [NSMutableArray array];
        self.selectedAssets = [NSMutableArray array];
        self.appends = [NSMutableArray array];
        self.maxCount = 3;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = ({
        titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        titleBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [titleBtn setTitle:[currentGroup valueForProperty:ALAssetsGroupPropertyName] forState:UIControlStateNormal];
        titleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        CGSize size = [titleBtn.titleLabel.text sizeWithFont:titleBtn.titleLabel.font constrainedToSize:CGSizeMake(100, 32) lineBreakMode:NSLineBreakByWordWrapping];
        titleBtn.frame = CGRectMake(0, 0, size.width, 32);
        titleImg = [[UIImageView alloc]initWithFrame:CGRectMake(titleBtn.frame.size.width-30, 1, 30, 30)];
        titleImg.image = [UIImage imageNamed:@"put_away"];
        [titleBtn addSubview:titleImg];
        [titleBtn addTarget:self action:@selector(selectorImageGroup) forControlEvents:UIControlEventTouchUpInside];
        titleBtn;
    });
    [self setBackButtonWithTarget:@selector(goBack)];
    [self setRightButtonWithName:@"下一步" BackgroundImg:nil Target:@selector(selectedImage)];
    
    float whith = (self.view.frame.size.width-11)/3;
    
    UICollectionViewFlowLayout* faceLayout = [[UICollectionViewFlowLayout alloc]init];
    faceLayout.itemSize = CGSizeMake(whith,whith);
    faceLayout.minimumInteritemSpacing = 5;
    faceLayout.minimumLineSpacing = 5;
    faceLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    imageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width,self.view.frame.size.height-navigationBarHeight) collectionViewLayout:faceLayout];
    imageCollectionView.delegate = self;
    imageCollectionView.dataSource = self;
    imageCollectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:imageCollectionView];
    imageCollectionView.showsHorizontalScrollIndicator = NO;
    [imageCollectionView registerClass:[AssetsCell class] forCellWithReuseIdentifier:@"AccessoryCell"];
    
    blackView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
    blackView.delegate = self;
    blackView.dataSource = self;
    blackView.rowHeight = 80;
    blackView.separatorStyle = UITableViewCellSeparatorStyleNone;
    blackView.backgroundColor = [UIColor whiteColor];
    UIView * back = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-navigationBarHeight)];
    back.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    back.hidden = YES;
    [back addSubview:blackView];
    [self.view addSubview:back];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)selectorImageGroup
{
    blackView.superview.hidden = !blackView.superview.hidden;
    if (blackView.superview.hidden) {
        titleImg.image = [UIImage imageNamed:@"put_away"];
    }else{
        titleImg.image = [UIImage imageNamed:@"stretch"];
        [blackView reloadData];
    }
}
- (void)goBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)selectedImage
{
    if (!_selectedAssets.count) {
        [SVProgressHUD showErrorWithStatus:@"请选择图片"];
        return;
    }
    [self dismissViewControllerAnimated:NO completion:^{
        if (_finish) {
            _finish(_selectedAssets,_appends);
        }
    }];
}
- (void)dealloc
{
    
}
#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _groupArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ALAssetsGroup * group = _groupArray[indexPath.row];
    static NSString *cellIdentifier = @"groupCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    if ([group isEqual:currentGroup]) {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@(%d)",[group valueForProperty:ALAssetsGroupPropertyName],group.numberOfAssets];
    cell.imageView.image = [UIImage imageWithCGImage:group.posterImage];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [self selectorImageGroup];
    ALAssetsGroup * group = _groupArray[indexPath.row];
    if (![currentGroup isEqual:group]) {
        currentGroup = _groupArray[indexPath.row];
        [titleBtn setTitle:[currentGroup valueForProperty:ALAssetsGroupPropertyName] forState:UIControlStateNormal];
        CGSize size = [titleBtn.titleLabel.text sizeWithFont:titleBtn.titleLabel.font constrainedToSize:CGSizeMake(150, 32) lineBreakMode:NSLineBreakByWordWrapping];
        titleBtn.frame = CGRectMake(titleBtn.frame.origin.x, 0, size.width, 32);
//        titleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -size.width/2, 0, size.width/2);
//        titleBtn.imageEdgeInsets = UIEdgeInsetsMake(0, size.width, 0, -size.width);
        titleImg.frame = CGRectMake(titleBtn.frame.size.width, 1, 30, 30);
        [_assetsArray removeAllObjects];
        __block NSMutableArray * blockAssetsArray = _assetsArray;
        [currentGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if(result) {
                [blockAssetsArray insertObject:result atIndex:0];
            }
            if (index == currentGroup.numberOfAssets-1) {
                [imageCollectionView reloadData];
            }
        }];
    }
}
#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    if (_assetsArray.count) {
        return _assetsArray.count+1;
//    }
//    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SectionCellIdentifier = @"AccessoryCell";
    AssetsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SectionCellIdentifier forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"AssetsPhotoBtn"];
        cell.stateView.hidden = YES;
    }else
    {
        id asset = _assetsArray[indexPath.row-1];
        cell.stateView.hidden = NO;
        if ([asset isKindOfClass:[ALAsset class]]) {
            cell.imageView.image = [UIImage imageWithCGImage:((ALAsset*)asset).thumbnail];
        }
        if ([asset isKindOfClass:[UIImage class]]) {
            cell.imageView.image = (UIImage*)asset;
        }
        if ([_selectedAssets containsAsset:asset]) {
            cell.stateView.image = [UIImage imageNamed:@"photo_button_select _selected"];
        }else
        {
            cell.stateView.image = [UIImage imageNamed:@"photo_button_select _default"];
        }
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:^{
            
        }];
    }else
    {
        id asset = _assetsArray[indexPath.row-1];
        if ([_selectedAssets containsAsset:asset]) {
            [_selectedAssets removeAsset:asset];
            [_appends removeAsset:asset];
             AssetsCell *cell = (AssetsCell *)[collectionView cellForItemAtIndexPath:indexPath];
            cell.stateView.image = [UIImage imageNamed:@"photo_button_select _default"];
        }else if(_selectedAssets.count<_maxCount)
        {
            [_selectedAssets addObject:asset];
            [_appends addObject:asset];
            AssetsCell *cell = (AssetsCell *)[collectionView cellForItemAtIndexPath:indexPath];
            cell.stateView.image = [UIImage imageNamed:@"photo_button_select _selected"];
        }else
        {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"最多选择%d张照片",_maxCount]];
        }
        [self setRightButtonWithName:_selectedAssets.count?[NSString stringWithFormat:@"下一步(%d)",_selectedAssets.count]:@"下一步" BackgroundImg:nil Target:@selector(selectedImage)];
    }
}
#pragma mark - UIImagePickerController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    __block ImageAssetsViewController * blockSelf = self;
    [picker dismissViewControllerAnimated:NO completion:^{
        UIImage * image = info[UIImagePickerControllerOriginalImage];
        [blockSelf.selectedAssets addObject:image];
        [blockSelf.appends addObject:image];
        [blockSelf selectedImage];
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
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
