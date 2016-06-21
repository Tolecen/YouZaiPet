//
//  ShareSheet.h
//  TalkingPet
//
//  Created by wangxr on 14-8-28.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareServe.h"
@interface ShareSheet : UIView
-(id)initWithIconArray:(NSArray*)icons titleArray:(NSArray*)titles action:(void(^)(NSInteger index))action;
-(void)show;
////分享试用
//- (id)initWithTrialName:(NSString*)name Code:(NSString *)code imageURL:(NSString*)img;
//- (void)showWithShareSucceed:(void (^)())success;
////分享说说
//- (id)initWithPetalkId:(NSString *)petalkId nickName:(NSString *)nickName thumbnail:(NSString *)thumbnail content:(NSString *)description;
//- (void)showWithForward:(void (^)())forward;
@end
