//
//  PlaySettingViewController.m
//  TalkingPet
//
//  Created by Tolecen on 14/11/17.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "PlaySettingViewController.h"

@interface PlaySettingViewController ()

@end

@implementation PlaySettingViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"播放设置";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButtonWithTarget:@selector(backBtnDo)];
    UIView * uu = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height)];
    [uu setBackgroundColor:[UIColor whiteColor]];
    [uu setAlpha:0.8];
    [self.view addSubview:uu];
    
    NSString * playMode = [[NSUserDefaults standardUserDefaults] objectForKey:@"playmodeofaudio"];
    if (!playMode) {
        [[NSUserDefaults standardUserDefaults] setObject:@"always" forKey:@"playmodeofaudio"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    NSString * playMode2 = [[NSUserDefaults standardUserDefaults] objectForKey:@"playmodeofaudio"];
    if ([playMode2 isEqualToString:@"always"]) {
        self.playMode = PlayAlways;
    }
    else if ([playMode2 isEqualToString:@"never"]){
        self.playMode = PlayNever;
    }
    else
        self.playMode = PlayOnlyInWIFI;
    
    
    self.settingTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, 45*3) style:UITableViewStylePlain];
    _settingTableView.delegate = self;
    _settingTableView.dataSource = self;
    _settingTableView.scrollEnabled = NO;
//    _settingTableView.backgroundView = uu;
    _settingTableView.backgroundColor = [UIColor whiteColor];
    _settingTableView.rowHeight = 45;
    _settingTableView.contentInset = UIEdgeInsetsMake(0, 0, 59, 0);
    _settingTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_settingTableView];
    
    [self buildViewWithSkintype];
    
    
}
- (void)buildViewWithSkintype
{
    [super buildViewWithSkintype];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"playsettingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier ];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (indexPath.row==0) {
        cell.textLabel.text = @"仅在WIFI下自动播放";
        if (self.playMode==PlayOnlyInWIFI) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else if (indexPath.row==1){
        cell.textLabel.text = @"始终自动播放";
        if (self.playMode==PlayAlways) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else{
        cell.textLabel.text = @"禁止自动播放";
        if (self.playMode==PlayNever) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        self.playMode = PlayOnlyInWIFI;
        [[NSUserDefaults standardUserDefaults] setObject:@"onlywifi" forKey:@"playmodeofaudio"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if ([SystemServer sharedSystemServer].systemNetStatus==SystemNetStatusReachableViaWiFi) {
            [SystemServer sharedSystemServer].autoPlay = YES;
        }
        else
            [SystemServer sharedSystemServer].autoPlay = NO;
    }
    else if (indexPath.row==1){
        self.playMode = PlayAlways;
        [[NSUserDefaults standardUserDefaults] setObject:@"always" forKey:@"playmodeofaudio"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [SystemServer sharedSystemServer].autoPlay = YES;
    }
    else
    {
        self.playMode = PlayNever;
        [[NSUserDefaults standardUserDefaults] setObject:@"never" forKey:@"playmodeofaudio"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [SystemServer sharedSystemServer].autoPlay = NO;
    }
    [self.settingTableView reloadData];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
