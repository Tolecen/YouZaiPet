//
//  EmsgMsg.m
//  sockettest
//
//  Created by cyt on 14/11/19.
//  Copyright (c) 2014年 cyt. All rights reserved.
//

#import "EmsgMsg.h"

@implementation EmsgMsg
@synthesize type,contenttype,content,contentlength,fromjid,timeSp,gid;
-(void)dealloc
{
    [super dealloc];
    [content release];
    [contenttype release];
    [contentlength release];
    [fromjid release];
    [gid release];
}
@end
