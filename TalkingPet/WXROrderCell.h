//
//  WXROrderCell.h
//  TalkingPet
//
//  Created by wangxr on 15/6/17.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXROrderCell : UITableViewCell
@property (nonatomic,copy)void(^liaisonAction) ();
@property (nonatomic,copy)void(^payAction) ();
@end
@interface WXROrderCell (MyOrderViewConyroller)
- (void)bulidCellWithDictionary:(NSDictionary*)source;
@end