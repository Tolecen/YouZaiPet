//
//  PackageInfo.m
//  TalkingPet
//
//  Created by Tolecen on 14/12/9.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "PackageInfo.h"

@implementation PackageInfo
- (id)initWithHostInfo:(NSDictionary*)info
{
    self = [super init];
    if (self) {
        self.packageTitle = [info objectForKey:@"name"];
        self.packageInfo = [info objectForKey:@"description"];
        self.packageId = [info objectForKey:@"code"];
        self.packageIconUrlStr = [info objectForKey:@"icon"];
        NSString * stated = [info objectForKey:@"state"];
        if ([stated isEqualToString:@"0"]||[stated isEqualToString:@"5"]) {
            self.haveExpirdate = YES;
        }
        else if ([stated isEqualToString:@"3"]){
            self.canGet = YES;
        }
        else if ([stated isEqualToString:@"4"]){
            self.haveGot = YES;
        }
        
        NSString * preV = [info objectForKey:@"preview"];
        if ([preV isEqualToString:@"true"]) {
            self.canPreview = YES;
        }
        
    }
    return self;
}
@end
