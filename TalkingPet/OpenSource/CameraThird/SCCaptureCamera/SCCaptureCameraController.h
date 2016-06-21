//
//  SCCaptureCameraController.h
//  SCCaptureCameraDemo
//
//  Created by Aevitx on 14-1-16.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCCaptureSessionManager.h"
#import "BaseViewController.h"
#import "TTImageHelper.h"
#import "MDRadialProgressView.h"
#import "MDRadialProgressTheme.h"
#import "MDRadialProgressLabel.h"
#import "PromptView.h"
@class Tag;
@interface SCCaptureCameraController : BaseViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIPinchGestureRecognizer *pinch;
    NSTimer * showTimer;
    MDRadialProgressView *radialView2;
}
@property (nonatomic, assign) CGRect previewRect;
@property (nonatomic, assign) BOOL isStatusBarHiddenBeforeShowCamera;
@property (nonatomic, retain)Tag * tag;

@end
