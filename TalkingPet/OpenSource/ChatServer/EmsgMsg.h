//
//  EmsgMsg.h
//  sockettest
//
//  Created by cyt on 14/11/19.
//  Copyright (c) 2014年 cyt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Define.h"
@interface EmsgMsg : NSObject
{
    MsgType  type;
    NSString *contenttype;
    NSString *content;
    NSString *contentlength;
    NSString *fromjid;
    double timeSp;
    NSString *gid;
}
@property(nonatomic,assign) MsgType type;
@property(nonatomic,retain) NSString *contenttype;
@property(nonatomic,retain) NSString *content;
@property(nonatomic,retain) NSString *contentlength;
@property(nonatomic,retain) NSString *fromjid;
@property(nonatomic,assign) double timeSp;
@property(nonatomic,retain) NSString *gid;
@end
