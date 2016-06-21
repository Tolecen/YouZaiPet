//
//  MoreTagViewController.m
//  TalkingPet
//
//  Created by wangxr on 15/2/9.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "MoreTagViewController.h"
#import "TagCell.h"
@interface MoreTagViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation MoreTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBackButtonWithTarget:@selector(back)];
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
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UICollectionView
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Tag * tag = _tagArray[indexPath.row];
    if (_delegate&&[_delegate respondsToSelector:@selector(selectedTag:)]) {
        [self dismissViewControllerAnimated:YES completion:^{
            [_delegate selectedTag:tag];
        }];
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _tagArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SectionCellIdentifier = @"CollectionViewCell";
    TagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SectionCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    Tag * tag = _tagArray[indexPath.row];
    cell.titleLable.text = tag.tagName;
    return cell;
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
