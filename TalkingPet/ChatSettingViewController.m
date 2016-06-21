//
//  ChatSettingViewController.m
//  TalkingPet
//
//  Created by Tolecen on 15/1/20.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "ChatSettingViewController.h"
#import "SVProgressHUD.h"
@interface ChatSettingViewController ()

@end

@implementation ChatSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.whoCanTalkToMe = @"anyone";
    [self setBackButtonWithTarget:@selector(backBtnDo)];
    self.chatSetting = [DatabaseServe getChatSettingForCurrentPet];
//    UIView * uu = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
//    [uu setBackgroundColor:[UIColor whiteColor]];
//    [uu setAlpha:0.8];
//    [self.view addSubview:uu];
    [self.view setBackgroundColor:[UIColor colorWithWhite:240/255.0f alpha:1]];
    
    self.sectionHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    self.sectionHeader.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    UILabel * g = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 20)];
    [g setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]];
    [g setText:@"   谁可以给我发消息"];
    [g setFont:[UIFont systemFontOfSize:14]];
    [self.sectionHeader addSubview:g];
    
//    UIView * lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, <#CGFloat height#>)]
    
    
    self.settingTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, 45*3+40) style:UITableViewStylePlain];
    _settingTableView.delegate = self;
    _settingTableView.dataSource = self;
    _settingTableView.scrollEnabled = NO;
//        _settingTableView.backgroundView = nil;
    _settingTableView.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
    _settingTableView.rowHeight = 45;
    _settingTableView.contentInset = UIEdgeInsetsMake(0, 0, 59, 0);
    _settingTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_settingTableView];
    
    [self buildViewWithSkintype];

    [self getChatSetting];
    // Do any additional setup after loading the view.
}
-(void)getChatSetting
{
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"setting" forKey:@"command"];
    [mDict setObject:@"PSL" forKey:@"options"];
    [mDict setObject:[UserServe sharedUserServe].currentPet.petID forKey:@"petId"];
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.chatSetting = [[[responseObject objectForKey:@"value"] objectForKey:@"mesg"] intValue];
        [DatabaseServe setChatSettingForPetId:[UserServe sharedUserServe].currentPet.petID setting:self.chatSetting];
        [self.settingTableView reloadData];
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
    }];
}
- (void)buildViewWithSkintype
{
    [super buildViewWithSkintype];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 2;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.sectionHeader;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }
    return 40.0f;
}
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (section==0) {
//        return nil;
//    }
//    else
//        return @"权限管理";
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    else
        return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"playsettingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier ];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    if (indexPath.row==0&&indexPath.section==1) {
        cell.textLabel.text = @"所有人";
        if (self.chatSetting==0) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else if (indexPath.row==1&&indexPath.section==1){
        cell.textLabel.text = @"仅我关注的人";
        if (self.chatSetting==1) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else if (indexPath.row==0&&indexPath.section==0){
        cell.textLabel.text = @"黑名单管理";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0&&indexPath.section==0) {
        UserListViewController * attentionV = [[UserListViewController alloc] init];
        attentionV.listType = UserListBlackList;
        attentionV.petID = [UserServe sharedUserServe].currentPet.petID;
        [self.navigationController pushViewController:attentionV animated:YES];
    }
    if (indexPath.row==0&&indexPath.section==1) {
        [self setChatToNetSetting:0];
    }
    if (indexPath.row==1&&indexPath.section==1) {
        [self setChatToNetSetting:1];
    }
}
-(void)setChatToNetSetting:(int)chatSetting
{
    [SVProgressHUD showWithStatus:@"设置中..."];
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"setting" forKey:@"command"];
    [mDict setObject:@"PSM" forKey:@"options"];
    [mDict setObject:@"mesg" forKey:@"key"];
    [mDict setObject:[NSString stringWithFormat:@"%d",chatSetting] forKey:@"val"];
    [mDict setObject:[UserServe sharedUserServe].currentPet.petID forKey:@"petId"];
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        self.chatSetting = chatSetting;
        [DatabaseServe setChatSettingForPetId:[UserServe sharedUserServe].currentPet.petID setting:self.chatSetting];
        [self.settingTableView reloadData];
    }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [SVProgressHUD dismiss];
     }];
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
