//
//  PackageInfo.h
//  TalkingPet
//
//  Created by Tolecen on 14/12/9.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PackageInfo : NSObject
@property (nonatomic,strong) NSString * packageTitle;
@property (nonatomic,strong) NSString * packageInfo;
@property (nonatomic,strong) NSString * status;
@property (nonatomic,assign) BOOL canPreview;
@property (nonatomic,assign) BOOL canGet;
@property (nonatomic,assign) BOOL haveGot;
@property (nonatomic,assign) BOOL haveExpirdate;
@property (nonatomic,strong) NSString * packageId;
@property (nonatomic,strong) NSString * packageIconUrlStr;

- (id)initWithHostInfo:(NSDictionary*)info;
@end
