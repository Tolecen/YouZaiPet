//
//  SquareNewViewController.h
//  TalkingPet
//
//  Created by Tolecen on 15/7/1.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
#import "SquareIteam.h"
@interface SquareNewViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,retain)UIScrollView * scrollView;
@property (nonatomic,strong)UIView * prefirstV;
@property (nonatomic,strong)UIView * firstV;
@property (nonatomic,strong)EGOImageView * topicImageV;
@property (nonatomic,strong)UILabel * topicTitleL;
@property (nonatomic,strong)UILabel * topicDiscussNumL;
@property (nonatomic,strong)UIView * secondV;

@property (nonatomic,strong)UIView * thirdV;
@property (nonatomic,strong)UIView * thirdV_part1;
@property (nonatomic,strong)UIView * thirdV_part2;
@property (nonatomic,strong)UITableView * forthTV;
@property (nonatomic,strong)UICollectionView * textCollection;
@property (nonatomic,retain)UIView * textView;

@property (nonatomic,strong)NSArray * tuijianArray;
@property (nonatomic,strong)NSArray * hotTagArray;
@property (nonatomic,strong)NSArray * hot3Array;
@property (nonatomic,strong)NSArray * haoliArray;

- (void)beginRefreshing;
@end
