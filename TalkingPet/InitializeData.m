//
//  InitializeData.m
//  TalkingPet
//
//  Created by wangxr on 14/10/21.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "InitializeData.h"
#import "TFileManager.h"


@implementation InitializeData
+(void)intialzeAccessoryDataSource
{
    [TFileManager copyFileFromBundleToDocuments:@[@"10008.zip",@"10009.zip",@"10010.zip",@"10035.zip",@"10057.zip",@"10060.zip",@"10061.zip",@"10065.zip",@"10070.zip",@"10071.zip",@"10072.zip",@"10073.zip",@"10074.zip",@"10075.zip"]];
    [TFileManager copyFileFromBundleToDocuments:@[@"21006.png",@"21010.png",@"21011.png",@"21012.png",@"21013.png",@"22006.png",@"22007.png",@"22019.png",@"22023.png",@"22028.png",@"31014.png",@"31019.png",@"31023.png",@"31024.png",@"31025.png",@"31026.png",@"32012.png",@"32013.png",@"90006.png",@"90007.png",@"90015.png",@"90016.png",@"90017.png",@"90019.png",@"90023.png",@"90024.png",@"90033.png",@"90040.png",@"90054.png",@"90056.png",@"90058.png",@"90059.png",@"90062.png",@"90063.png",@"90079.png",@"90132.png",@"90133.png",@"90138.png",@"90139.png",@"90140.png",@"90141.png",@"90142.png",@"90159.png",@"90160.png",@"90161.png",@"90162.png",@"90163.png",@"90164.png",@"90165.png",@"90166.png",@"90167.png",@"90168.png",@"90169.png",@"90170.png",@"90171.png",@"90172.png",@"90173.png",@"90174.png",@"91079.png",@"91080.png",@"91097.png",@"91098.png",@"91099.png",@"91101.png",@"91105.png",@"91106.png",@"91107.png",@"91108.png",@"91109.png",@"91110.png",@"91111.png",@"91112.png",@"91113.png",@"91114.png",@"91115.png",@"91116.png",@"91118.png",@"91119.png",@"91120.png",@"91121.png",@"91122.png",@"91123.png",@"91124.png",@"91125.png",@"91126.png",@"91128.png"]];
}
+(void)intialzeAccessoryTree
{
    NSString *path =[[NSString alloc]initWithString:[[NSBundle mainBundle]pathForResource:@"BaseTreeData"ofType:@"json"]];
    NSData* data = [[NSData alloc]initWithContentsOfFile:path];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSMutableDictionary * newDic = [NSMutableDictionary dictionary];
    NSArray * arr = [dic objectForKey:@"value"][@"children"];
    for (NSDictionary * dic in arr) {
        [newDic setObject:dic[@"children"] forKey:dic[@"type"]];
    }
    [[NSUserDefaults standardUserDefaults] setObject:newDic forKey:@"WXRPublishAccessoryTree2"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
