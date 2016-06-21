//
//  EndtInteractionViewController.m
//  TalkingPet
//
//  Created by wangxr on 15/3/30.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "EndtInteractionViewController.h"
#import "PublishServer.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ImageAssetsViewController.h"
#import "RootViewController.h"
#import "NSString+CutSpacing.h"

@interface QitaCell : UICollectionViewCell
@property (nonatomic,retain)UIImageView * imageView;
@property (nonatomic,retain)UIButton * deleteB;
@property (nonatomic,copy)void(^deleteAction)();
@end
@implementation QitaCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.contentView addSubview:_imageView];
        self.deleteB = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteB.frame = CGRectMake(frame.size.width-32, 0, 32, 32);
        [_deleteB setBackgroundImage:[UIImage imageNamed:@"banner_button_close"] forState:UIControlStateNormal];
        [_deleteB addTarget:self action:@selector(deleteImage) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_deleteB];
    }
    return self;
}
-(void)deleteImage
{
    if (_deleteAction) {
        _deleteAction();
    }
}
@end
@interface EndtInteractionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITextViewDelegate,KeyboardViewDelegate>
{
    UICollectionView * faceCollectionV;
    UITextView * textView;
    UILabel * placeholderL;
}
@end

@implementation EndtInteractionViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"编辑互动";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBackButtonWithTarget:@selector(goBack)];
    [self setRightButtonWithName:@"发布" BackgroundImg:nil Target:@selector(publisInteraction)];
    
    float whith = (self.view.frame.size.width-51)/4;
    textView = [[UITextView alloc] initWithFrame:CGRectMake(8, 8, self.view.frame.size.width-16, self.view.frame.size.height-400-whith)];
    textView.delegate = self;
    [self.view addSubview:textView];
    placeholderL = [[UILabel alloc] initWithFrame:CGRectMake(12, 15, self.view.frame.size.width-20, 20)];
    placeholderL.text = @"请输入互动内容……";
    placeholderL.textColor = [UIColor colorWithWhite:0.7 alpha:1];
    [self.view addSubview:placeholderL];
    
    textView.font = [UIFont systemFontOfSize:15];
    UICollectionViewFlowLayout* faceLayout = [[UICollectionViewFlowLayout alloc]init];
    faceLayout.itemSize = CGSizeMake(whith,whith);
    faceLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    faceLayout.minimumInteritemSpacing = 5;
    faceLayout.minimumLineSpacing = 5;
    faceLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    faceCollectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-350-whith, self.view.frame.size.width,whith) collectionViewLayout:faceLayout];
    faceCollectionV.dataSource = self;
    faceCollectionV.delegate = self;
    faceCollectionV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:faceCollectionV];
    faceCollectionV.showsHorizontalScrollIndicator = NO;
    [faceCollectionV registerClass:[QitaCell class] forCellWithReuseIdentifier:@"AccessoryCell"];
    
    k = [[KeyboardBarView alloc] initWithFrame:CGRectZero textView:textView baseView:self.view];
    k.delegate = self;
    [self.view addSubview:k];
}
-(void)dealloc
{
    [k removeFromSuperview];
}
-(void)emojiEntered
{
    placeholderL.hidden = YES;
}
-(void)heightChanged:(float)height
{
    float whith = (self.view.frame.size.width-51)/4;
    [faceCollectionV setFrame:CGRectMake(0, height-whith-5, faceCollectionV.frame.size.width, faceCollectionV.frame.size.height)];
}
- (void)viewDidAppear:(BOOL)animated
{
    [textView becomeFirstResponder];
}
-(void)publisInteraction
{
    NSString * publishStr = [textView.text CutSpacing];
    if (publishStr.length<=0) {
        [SVProgressHUD showErrorWithStatus:@"请输入互动内容"];
        return;
    }
    if (publishStr.length>2000) {
        [SVProgressHUD showErrorWithStatus:@"互动内容不得超过2000字"];
        return;
    }
    [textView resignFirstResponder];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        InteractionPublisher * publisher = [[InteractionPublisher alloc] init];
        for (int i = 0; i<_selectedArray.count; i++) {
            id asset = _selectedArray[i];
            UIImage * image;
            if ([asset isKindOfClass:[ALAsset class]]) {
                image = [UIImage imageWithCGImage:[[(ALAsset*)asset defaultRepresentation] fullScreenImage]];
            }
            if ([asset isKindOfClass:[UIImage class]]) {
                image = asset;
            }
            NSData * imgData = UIImageJPEGRepresentation(image , 0.8);
            NSString * path = [NSString stringWithFormat:@"/%@_%dimg.jpg",publisher.publishID,i];
            [publisher.pathArray insertObject:path atIndex:i];
            [publisher.URLArray insertObject:[NSNull null] atIndex:i];
            if ([imgData writeToFile:[subdirectoryw stringByAppendingString:path] atomically:YES]) {
                NSLog(@"write failed img success");
            }
            else
            {
                NSLog(@"write failed img failed");
            }
        }
        publisher.text = publishStr;
        publisher.interactionID = _topicId;
        dispatch_sync(dispatch_get_main_queue(), ^{
            [PublishServer publishInteractionWithPublisher:publisher];
        });
    });
    [self goBack];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setSelectedArray:(NSMutableArray *)selectedArray
{
    if (![_selectedArray isEqual:selectedArray]) {
        _selectedArray = selectedArray;
    }
    [faceCollectionV reloadData];
}
- (void)goBack
{
    [textView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        return NO;
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)theTextView
{
    if (!placeholderL.hidden&&theTextView.text.length>0) {
        placeholderL.hidden = YES;
    }
    if (placeholderL.hidden&&theTextView.text.length<=0) {
        placeholderL.hidden = NO;
    }
}
#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _selectedArray.count<3?_selectedArray.count+1:_selectedArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SectionCellIdentifier = @"AccessoryCell";
    QitaCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SectionCellIdentifier forIndexPath:indexPath];
    if (indexPath.row == _selectedArray.count) {
        cell.imageView.image = [UIImage imageNamed:@"button_add photo"];
        cell.deleteB.hidden = YES;
    }else
    {
        id asset = _selectedArray[indexPath.row];
        if ([asset isKindOfClass:[ALAsset class]]) {
            cell.imageView.image = [UIImage imageWithCGImage:((ALAsset*)asset).thumbnail];
        }
        if ([asset isKindOfClass:[UIImage class]]) {
            cell.imageView.image = (UIImage*)asset;
        }
        __block EndtInteractionViewController * blockSelf = self;
        __block UICollectionView * blockView = collectionView;
        cell.deleteAction = ^(){
            [blockSelf.selectedArray removeObject:asset];
            [blockView reloadData];
        };
        cell.deleteB.hidden = NO;
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _selectedArray.count) {
        __block EndtInteractionViewController *blockSelf = self;
        ImageAssetsViewController * imageAssetsVC = [[ImageAssetsViewController alloc] init];
        [imageAssetsVC setSelectedArray:_selectedArray];
        imageAssetsVC.finish = ^(NSMutableArray*assetArray,NSMutableArray *appends){
            blockSelf.selectedArray = assetArray;
        };
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:imageAssetsVC];
        [self presentViewController:nav animated:YES completion:nil];
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
