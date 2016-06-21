//
//  MCardViewController.m
//  TalkingPet
//
//  Created by Tolecen on 15/6/4.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "MCardViewController.h"

@interface MCardViewController ()

@end

@implementation MCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
    self.title = @"M卡管理";
    [self setBackButtonWithTarget:@selector(backBtnDo:)];
    
    [self getmcard];
    // Do any additional setup after loading the view.
}

-(void)getmcard
{
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"card" forKey:@"command"];
    [mDict setObject:@"profile" forKey:@"options"];
//    [mDict setObject:self.packageInfo.packageId forKey:@"code"];
//    [mDict setObject:[UserServe sharedUserServe].currentPet.petID?[UserServe sharedUserServe].currentPet.petID:@"no" forKey:@"petId"];
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        

 
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    }];
}

-(void)backBtnDo:(UIButton *)sender
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
