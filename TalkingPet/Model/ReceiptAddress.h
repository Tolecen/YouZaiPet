//
//  ReceiptAddress.h
//  TalkingPet
//
//  Created by wangxr on 15/6/13.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReceiptAddress : NSObject
@property(nonatomic,retain)NSString * addressID;
@property(nonatomic,retain)NSString * receiptName;
@property(nonatomic,retain)NSString * phoneNo;
@property(nonatomic,retain)NSString * province;
@property(nonatomic,retain)NSString * city;
@property(nonatomic,retain)NSString * address;
@property(nonatomic,retain)NSString * zipCode;
@property(nonatomic,assign)BOOL action;
@end
