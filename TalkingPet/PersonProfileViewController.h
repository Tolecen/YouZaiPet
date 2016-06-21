//
//  PersonProfileViewController.h
//  TalkingPet
//
//  Created by Tolecen on 14-7-16.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "EGOImageButton.h"
#import "ChatDetailViewController.h"
@protocol AttentionDelegate <NSObject>

@optional
- (void)attentionPetWithPetId:(NSString *)petId AndRelationship:(NSString *)relationship;

@end
@interface PersonProfileViewController : BaseViewController
{
    UIButton * relationBtn;
}
@property (nonatomic,strong) NSString * relationShip;
@property (nonatomic,strong) NSString * petId;
@property (nonatomic,strong) NSString * petAvatarUrlStr;
@property (nonatomic,strong) NSString * petNickname;
@property (nonatomic,retain) UIImageView * darenV;
@property (nonatomic,assign) id<AttentionDelegate> delegate;

@end
