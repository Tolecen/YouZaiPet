//
//  AddressManageViewController.h
//  TalkingPet
//
//  Created by wangxr on 15/6/13.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "BaseViewController.h"
@class ReceiptAddress;
@interface AddressManageViewController : BaseViewController
@property (nonatomic,copy)void(^useAddress) (ReceiptAddress * address);
@property (nonatomic,copy)NSString * finishTitle;
@end
