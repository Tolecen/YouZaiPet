//
//  AccessoryView.h
//  TalkingPet
//
//  Created by wangxr on 14-7-21.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Accessory.h"

typedef enum WXRAccessoryType{
    WXRAccessoryTypeMustHave,
    WXRAccessoryTypeAnyway
}WXRAccessoryType;
@class AccessoryView;
@protocol AccessoryViewDelegate <NSObject>
@optional
- (void)removeAccessoryViewFromSuperView:(AccessoryView*)view;
- (void)beginEditAccessory:(AccessoryView*)view;
- (void)editingAccessory:(AccessoryView*)view;
- (void)endEditAccessory:(AccessoryView*)view;
@optional

@end

@interface AccessoryView : UIView
@property (nonatomic,assign)id<AccessoryViewDelegate>delegate;
@property (nonatomic,assign)WXRAccessoryType accessoryType;
@property (nonatomic,retain)Accessory * accessory;
@property (nonatomic,assign,readonly)CGFloat radianX;
@property (nonatomic,assign,readonly)CGFloat radianY;
@property (nonatomic,assign,readonly)CGFloat radianZ;
- (id)initWithFrame:(CGRect)frame WXRAccessoryType:(WXRAccessoryType)type;
- (void)hiddenEditRect;
- (void)showEditRect;
- (void)playAnimation;
- (void)stopAnimation;
- (void)transform3DRotateYwithRadian:(CGFloat)radian;
- (void)transform3DRotateXwithRadian:(CGFloat)radian;
- (void)enlarged;
- (void)reduced;
- (void)rotateLeft;
- (void)rotateRight;
- (void)restoreToSize:(CGSize)size;
- (UIImage*)getAccessoryStaticImage;
- (CGFloat)getImageViewWidth;
- (CGFloat)getImageViewHeight;
@end
