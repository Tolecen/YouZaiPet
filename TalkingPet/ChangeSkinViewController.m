//
//  ChangeSkinViewController.m
//  TalkingPet
//
//  Created by wangxr on 14-9-24.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "ChangeSkinViewController.h"
@class SkinCell;
@protocol SkinCellDelegate<NSObject>
- (void)skinCell:(SkinCell*)cell userOnceSkinWithIndex:(NSInteger)index;
@end
@interface SkinCell : UITableViewCell
@property(nonatomic,assign) id<SkinCellDelegate>delegate;
@property(nonatomic,assign) NSInteger index;
@property(nonatomic,retain) UIImageView * imageV;
@property(nonatomic,retain) UILabel * label;
@property(nonatomic,retain) UIButton * button;
@end
@implementation SkinCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 25, 25)];
        [self.contentView addSubview:_imageV];
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 100, 25)];
        _label.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_label];
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(230, 10, 70, 25);
        _button.titleLabel.font = [UIFont systemFontOfSize:16];
        [_button addTarget:self action:@selector(userOnceSkin) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_button];
    }
    return self;
}
-(void)userOnceSkin
{
    if (self.delegate && [_delegate respondsToSelector:@selector(skinCell:userOnceSkinWithIndex:)]) {
        [_delegate skinCell:self userOnceSkinWithIndex:_index];
    }
}
@end

@interface ChangeSkinViewController ()<UITableViewDelegate,UITableViewDataSource,SkinCellDelegate>
{
    UIImageView * previewView;
}
@property (nonatomic,strong) UITableView * selectTableView;
@end

@implementation ChangeSkinViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"个性化皮肤";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setBackButtonWithTarget:@selector(backBtnDo)];
    // Do any additional setup after loading the view.
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(5, 5, self.view.frame.size.width - 10, self.view.frame.size.height - 10 - navigationBarHeight)];
    view.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
    [self.view addSubview:view];
    
    self.selectTableView = [[UITableView alloc]initWithFrame:CGRectMake(5, 5, self.view.frame.size.width - 10, self.view.frame.size.height - 10 - navigationBarHeight)];
    _selectTableView.delegate = self;
    _selectTableView.dataSource = self;
    _selectTableView.backgroundColor = [UIColor clearColor];
    _selectTableView.rowHeight = 45;
    _selectTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _selectTableView.contentInset = UIEdgeInsetsMake(0, 0, 59, 0);
    _selectTableView.showsVerticalScrollIndicator = NO;
    _selectTableView.scrollEnabled = NO;
    [self.view addSubview:_selectTableView];
    
    previewView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 150, 280, 230)];
    [self.view addSubview:previewView];
    switch ([SystemServer sharedSystemServer].skinType) {
        case 0:{
            previewView.image = [UIImage imageNamed:@"preview_blue"];
        }break;
        case 2:
        {
            previewView.image = [UIImage imageNamed:@"preview_purple"];
        }
            break;
        case 1:{
            previewView.image = [UIImage imageNamed:@"preview_pink"];
        }break;
        default:
            break;
    }
    [self buildViewWithSkintype];
}
- (void)buildViewWithSkintype
{
    [super buildViewWithSkintype];
    [_selectTableView reloadData];
}
- (void)backBtnDo
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    SkinCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier ];
    if (cell == nil) {
        cell = [[SkinCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.delegate = self;
        cell.index = indexPath.row;
    }
    switch (indexPath.row) {
        case 0:{
            cell.imageV.image = [UIImage imageNamed:@"point_blue"];
            cell.label.text = @"高冷蓝";
            if ([SystemServer sharedSystemServer].skinType == 0) {
                [cell.button setTitle:@"使用中" forState:UIControlStateNormal];
                [cell.button setBackgroundImage:nil forState:UIControlStateNormal];
                [cell.button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            }else
            {
                [cell.button setTitle:@"使用" forState:UIControlStateNormal];
                [cell.button setBackgroundImage:[UIImage imageNamed:@"useBlueSkin"] forState:UIControlStateNormal];
                [cell.button setTitleColor:[UIColor colorWithRed:60/255.0 green:198/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
            }
        }break;
        case 1:{
            cell.imageV.image = [UIImage imageNamed:@"point_pink"];
            cell.label.text = @"樱桃粉";
            if ([SystemServer sharedSystemServer].skinType == 1) {
                [cell.button setTitle:@"使用中" forState:UIControlStateNormal];
                [cell.button setBackgroundImage:nil forState:UIControlStateNormal];
                [cell.button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            }else
            {
                [cell.button setTitle:@"使用" forState:UIControlStateNormal];
                [cell.button setBackgroundImage:[UIImage imageNamed:@"usePinkSkin"] forState:UIControlStateNormal];
                [cell.button setTitleColor:[UIColor colorWithRed:247/255.0 green:98/255.0 blue:192/255.0 alpha:1] forState:UIControlStateNormal];
            }
        }break;
        case 2:{
            cell.imageV.image = [UIImage imageNamed:@"point_purple"];
            cell.label.text = @"尊贵紫";
            if ([SystemServer sharedSystemServer].skinType == 2) {
                [cell.button setTitle:@"使用中" forState:UIControlStateNormal];
                [cell.button setBackgroundImage:nil forState:UIControlStateNormal];
                [cell.button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            }else
            {
                [cell.button setTitle:@"使用" forState:UIControlStateNormal];
                [cell.button setBackgroundImage:[UIImage imageNamed:@"usePurpleSkin"] forState:UIControlStateNormal];
                [cell.button setTitleColor:[UIColor colorWithRed:130/255.0 green:135/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
            }
        }break;
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        previewView.image = [UIImage imageNamed:@"preview_blue"];
    }if (indexPath.row == 1) {
        previewView.image = [UIImage imageNamed:@"preview_pink"];
    }
    if (indexPath.row == 2) {
        previewView.image = [UIImage imageNamed:@"preview_purple"];
    }
    
}
- (void)skinCell:(SkinCell*)cell userOnceSkinWithIndex:(NSInteger)index
{
    if ([SystemServer sharedSystemServer].skinType != index) {
        [SystemServer sharedSystemServer].skinType = index;
        [DatabaseServe setSkinType:[SystemServer sharedSystemServer].skinType];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"WXRchangeSkin" object:self userInfo:nil];

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
