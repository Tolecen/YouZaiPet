//
//  AddressDetailViewController.h
//  TalkingPet
//
//  Created by wangxr on 15/6/13.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "BaseViewController.h"
@class ReceiptAddress;
@interface AddressDetailViewController : BaseViewController
@property (nonatomic,copy)void(^finish) (ReceiptAddress * address);
@property (nonatomic,copy)NSString * finishTitle;
-(void)updateReceiptAddress:(ReceiptAddress *) address;
@end
