//
//  Accessory.h
//  TalkingPet
//
//  Created by wangxr on 15/1/31.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Accessory  : NSObject//装饰品实体
@property (nonatomic,retain)NSString * fileName;
@property (nonatomic,retain)NSString * fileType;
@property (nonatomic,retain)NSString * type;
@property (nonatomic,retain)NSString * accID;
@property (nonatomic,retain)NSString * url;
@property (nonatomic,retain)NSURL * thumbnail;
@property (nonatomic,assign)BOOL exsit;
@property (nonatomic,assign)BOOL loading;
@end
@interface Section  : NSObject//装饰品分组实体
@property (nonatomic,retain)NSString * name;
@property (nonatomic,retain)NSString * type;
@property (nonatomic,assign)BOOL stretch;
@property (nonatomic,retain)NSArray * decorations;
@end