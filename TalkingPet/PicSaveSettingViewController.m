//
//  PicSaveSettingViewController.m
//  TalkingPet
//
//  Created by Tolecen on 15/3/3.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "PicSaveSettingViewController.h"

@interface PicSaveSettingViewController ()

@end

@implementation PicSaveSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButtonWithTarget:@selector(backBtnDo)];
    
    self.settingTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 200) style:UITableViewStyleGrouped];
    _settingTableView.delegate = self;
    _settingTableView.dataSource = self;
    //    _settingTableView.backgroundView = uu;
    _settingTableView.backgroundColor = [UIColor whiteColor];
    _settingTableView.rowHeight = 45;
//    _settingTableView.contentInset = UIEdgeInsetsMake(-30, 0, 0, 0);
    _settingTableView.showsVerticalScrollIndicator = NO;
    _settingTableView.scrollEnabled = NO;
    [self.view addSubview:_settingTableView];
    // Do any additional setup after loading the view.
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0f;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"settingCell";
    SwitchBtnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (cell == nil) {
        cell = [[SwitchBtnTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.delegate = self;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.nameL.text = indexPath.row==0?@"发送完成自动保存图片":@"发送完成自动保存原图";
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.theIndex = (int)indexPath.row;
    if (indexPath.row==0) {
        if ([DatabaseServe savePublishImg]) {
            cell.switchBtn.on = YES;
        }
        else
        {
            cell.switchBtn.on = NO;
        }
    }
    else {
        if ([DatabaseServe saveOriginalImg]) {
            cell.switchBtn.on = YES;
        }
        else
        {
            cell.switchBtn.on = NO;
        }
    }
    
    return cell;
}
-(void)switchBtnClickedIndex:(int)index btnOn:(BOOL)isOn
{
    if (index==0) {
        [DatabaseServe setSavePublishImg:isOn];
    }
    else
    {
        [DatabaseServe setSaveOriginalImg:isOn];
    }
}
- (void)backBtnDo
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
