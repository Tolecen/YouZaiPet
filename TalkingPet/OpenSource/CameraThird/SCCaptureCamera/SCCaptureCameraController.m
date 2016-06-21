//
//  SCCaptureCameraController.m
//  SCCaptureCameraDemo
//
//  Created by Aevitx on 14-1-16.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import "SCCaptureCameraController.h"
#import "SCSlider.h"
#import "SCCommon.h"
#import "SVProgressHUD.h"

#import "SCNavigationController.h"
#import "DecorateViewController.h"
#import "SelectImageViewController.h"
#import "EGOImageView.h"
//static void * CapturingStillImageContext = &CapturingStillImageContext;
//static void * RecordingContext = &RecordingContext;
//static void * SessionRunningAndDeviceAuthorizedContext = &SessionRunningAndDeviceAuthorizedContext;

#define SWITCH_SHOW_FOCUSVIEW_UNTIL_FOCUS_DONE      0   //对焦框是否一直闪到对焦完成

#define SWITCH_SHOW_DEFAULT_IMAGE_FOR_NONE_CAMERA   1   //没有拍照功能的设备，是否给一张默认图片体验一下

//height
#define CAMERA_TOPVIEW_HEIGHT   44  //title
#define CAMERA_MENU_VIEW_HEIGH  44  //menu

//color
#define bottomContainerView_UP_COLOR     [UIColor colorWithRed:110/255.0f green:110/255.0f blue:110/255.0f alpha:1.f]       //bottomContainerView的上半部分
#define bottomContainerView_DOWN_COLOR   [UIColor colorWithRed:110/255.0f green:110/255.0f blue:110/255.0f alpha:1.f]       //bottomContainerView的下半部分
#define DARK_GREEN_COLOR        [UIColor colorWithRed:10/255.0f green:107/255.0f blue:42/255.0f alpha:1.f]    //深绿色
#define LIGHT_GREEN_COLOR       [UIColor colorWithRed:143/255.0f green:191/255.0f blue:62/255.0f alpha:1.f]    //浅绿色


//对焦
#define ADJUSTINT_FOCUS @"adjustingFocus"
#define LOW_ALPHA   0.7f
#define HIGH_ALPHA  1.0f

#define DelayTime  1.2f
@interface photoCell : UICollectionViewCell
@property (nonatomic,retain)UIImageView * imageV;
@end
@implementation photoCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIImageView * selectedV =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        selectedV.image = [UIImage imageNamed:@"selected_accessory"];
        self.imageV = [[EGOImageView alloc] initWithFrame:CGRectMake(3, 3, frame.size.width-6, frame.size.height-6)];
        [self.contentView addSubview:_imageV];
        self.selectedBackgroundView = selectedV;
    }
    return self;
}
@end
@interface Voice  : NSObject//音效实体
@property (nonatomic,retain)NSString * fileName;
@property (nonatomic,retain)NSString * imageName;
@end
@implementation Voice

@end
@interface SCCaptureCameraController ()<UICollectionViewDelegate,UICollectionViewDataSource,AVAudioPlayerDelegate>
{
    int alphaTimes;
    CGPoint currTouchPoint;
    UIButton * camB;
    UILabel * alertL;
    UIPageControl * page;
    double nowTime;
    UIButton * musicB;
    UIButton * captureFlashB;
    Voice * contuntVoice;
}
@property (nonatomic, strong) SCCaptureSessionManager *captureManager;

@property (nonatomic, strong) UIView *topContainerView;//顶部view
@property (nonatomic, strong) UILabel *topLbl;//顶部的标题

@property (nonatomic, strong) UIView *bottomContainerView;//除了顶部标题、拍照区域剩下的所有区域
@property (nonatomic, strong) UIView *cameraMenuView;//网格、闪光灯、前后摄像头等按钮
@property (nonatomic, strong) NSMutableSet *cameraBtnSet;

@property (nonatomic, strong) UIImageView *doneCameraUpView;
@property (nonatomic, strong) UIImageView *doneCameraDownView;

//对焦
@property (nonatomic, strong) UIImageView *focusImageView;

@property (nonatomic, strong) SCSlider *scSlider;

//连拍
@property (nonatomic, retain) NSMutableArray * photoArr;
//
@property (nonatomic, retain)UICollectionView * soundCollectionView;
@property (nonatomic, retain)AVAudioPlayer * getcoinAudio;
@property (nonatomic, retain)NSArray * voiceArr;
@end

@implementation SCCaptureCameraController

#pragma mark -------------life cycle---------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        alphaTimes = -1;
        currTouchPoint = CGPointZero;
        _cameraBtnSet = [[NSMutableSet alloc] init];
        self.voiceArr = @[({
                                Voice * voice = [[Voice alloc] init];
                                voice.fileName = @"sound1";
                                voice.imageName = @"voiceImg1";
                                voice;
                            }),
                          ({
                              Voice * voice = [[Voice alloc] init];
                              voice.fileName = @"sound2";
                              voice.imageName = @"voiceImg2";
                              voice;
                          }),({
                              Voice * voice = [[Voice alloc] init];
                              voice.fileName = @"sound3";
                              voice.imageName = @"voiceImg3";
                              voice;
                          }),
                          ({
                              Voice * voice = [[Voice alloc] init];
                              voice.fileName = @"sound4";
                              voice.imageName = @"voiceImg4";
                              voice;
                          }),
                          ({
                              Voice * voice = [[Voice alloc] init];
                              voice.fileName = @"sound5";
                              voice.imageName = @"voiceImg5";
                              voice;
                          }),
                          ({
                              Voice * voice = [[Voice alloc] init];
                              voice.fileName = @"sound6";
                              voice.imageName = @"voiceImg6";
                              voice;
                          }),
                          ({
                              Voice * voice = [[Voice alloc] init];
                              voice.fileName = @"sound7";
                              voice.imageName = @"voiceImg7";
                              voice;
                          }),
                          ({
                              Voice * voice = [[Voice alloc] init];
                              voice.fileName = @"sound8";
                              voice.imageName = @"voiceImg8";
                              voice;
                          })
                          ];
        contuntVoice = _voiceArr[0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView * img = [[UIImageView alloc] initWithFrame:self.view.frame];
    [img setImage:[UIImage imageNamed:@""]];
    self.view.backgroundColor = bottomContainerView_UP_COLOR;
	// Do any additional setup after loading the view.
    
    //status bar
//    if (!self.navigationController) {
//        _isStatusBarHiddenBeforeShowCamera = [UIApplication sharedApplication].statusBarHidden;
//        if ([UIApplication sharedApplication].statusBarHidden == NO) {
//            //iOS7，需要plist里设置 View controller-based status bar appearance 为NO
//            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
//        }
//    }
    
    //notification
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationOrientationChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange:) name:kNotificationOrientationChange object:nil];
    
    //session manager
    
#if SWITCH_SHOW_DEFAULT_IMAGE_FOR_NONE_CAMERA
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [SVProgressHUD showErrorWithStatus:@"设备不支持拍照功能，给个妹纸给你喵喵T_T"];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CAMERA_TOPVIEW_HEIGHT, self.view.frame.size.width, self.view.frame.size.width)];
        imgView.clipsToBounds = YES;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"meizi" ofType:@"jpg"]];
        [self.view addSubview:imgView];
    }
#endif
    [self buildViewWithSkintype];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([UIApplication sharedApplication].statusBarHidden == NO) {
        //iOS7，需要plist里设置 View controller-based status bar appearance 为NO
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];

    }
    self.navigationController.navigationBarHidden = YES;
    SCCaptureSessionManager *manager = [[SCCaptureSessionManager alloc] init];
    
    //AvcaptureManager
    if (CGRectEqualToRect(_previewRect, CGRectZero)) {
        self.previewRect = CGRectMake(0,  CAMERA_TOPVIEW_HEIGHT, SC_APP_SIZE.width, SC_APP_SIZE.width);
    }
    [manager configureWithParentLayer:self.view previewRect:_previewRect];
    self.captureManager = manager;
    [self addbottomContainerView];
    [self addCameraMenuView];
    [self addTopViewWithText:@"拍 照"];
    [self addFocusView];
    [self addCameraCover];
//    [self addPinchGesture];
    self.photoArr = [NSMutableArray array];
    [_captureManager.session startRunning];
    camB.enabled = YES;
}
-(void)viewDidDisappear:(BOOL)animated
{
    [self showCameraCover:NO];
    [_getcoinAudio stop];
    [self.captureManager.session stopRunning];
    self.captureManager.previewLayer = nil;
    self.captureManager.session = nil;
    self.captureManager.stillImageOutput = nil;
    for (UIView * view in self.bottomContainerView.subviews) {
        [view removeFromSuperview];
    }
    [_soundCollectionView removeFromSuperview];
    [self.bottomContainerView removeFromSuperview];
    self.bottomContainerView = nil;
    [self.cameraMenuView removeFromSuperview];
    self.cameraMenuView = nil;
    [self.cameraBtnSet removeAllObjects];
    [self.topLbl removeFromSuperview];
    self.topLbl = nil;
    [self.focusImageView removeFromSuperview];
    self.focusImageView = nil;
    [self.doneCameraUpView removeFromSuperview];
    self.doneCameraUpView = nil;
    [self.doneCameraDownView removeFromSuperview];
    self.doneCameraDownView = nil;
    [self.scSlider removeFromSuperview];
    self.scSlider = nil;
    [self.view removeGestureRecognizer:pinch];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationOrientationChange object:nil];
    
#if SWITCH_SHOW_FOCUSVIEW_UNTIL_FOCUS_DONE
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device && [device isFocusPointOfInterestSupported]) {
        [device removeObserver:self forKeyPath:ADJUSTINT_FOCUS context:nil];
    }
#endif
    self.captureManager = nil;
}

#pragma mark -------------UI---------------
//顶部标题
- (void)addTopViewWithText:(NSString*)text {
    /*
    if (!_topContainerView) {
//        CGRect topFrame = CGRectMake(0, 0, SC_APP_SIZE.width, CAMERA_TOPVIEW_HEIGHT);
//        
//        UIView *tView = [[UIView alloc] initWithFrame:topFrame];
//        tView.backgroundColor = [UIColor clearColor];
//        [self.view addSubview:tView];
//        self.topContainerView = tView;
//        
//        UIView *emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, topFrame.size.width, topFrame.size.height)];
//        emptyView.backgroundColor = [UIColor blackColor];
//        emptyView.alpha = 0.4f;
//        [_topContainerView addSubview:emptyView];
//        
//        topFrame.origin.x += 10;
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
        lbl.backgroundColor = [UIColor clearColor];
        lbl.textColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        [lbl setFont:[UIFont boldSystemFontOfSize:21]];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        
//        lbl.font = [UIFont systemFontOfSize:25.f];
        [self.view addSubview:lbl];
        self.topLbl = lbl;
    }
    _topLbl.text = text;*/

}

//bottomContainerView，总体
- (void)addbottomContainerView {
    
    CGFloat bottomY = _captureManager.previewLayer.frame.origin.y + _captureManager.previewLayer.frame.size.height;
    CGRect bottomFrame = CGRectMake(0, bottomY, SC_APP_SIZE.width, SC_APP_SIZE.height - bottomY);
    
    UIView *view = [[UIView alloc] initWithFrame:bottomFrame];
    view.backgroundColor = bottomContainerView_UP_COLOR;
    [self.view addSubview:view];
    self.bottomContainerView = view;
}

//拍照菜单栏
- (void)addCameraMenuView {
    
    //拍照按钮
//    CGFloat downH = (isHigherThaniPhone4_SC ? CAMERA_MENU_VIEW_HEIGH : 0);
    CGFloat cameraBtnLength = 110;
    
    CGRect frame = CGRectMake((SC_APP_SIZE.width - cameraBtnLength) / 2+5+3, (_bottomContainerView.frame.size.height - 0 - cameraBtnLength) / 2 +5+4, 92, 92);
    radialView2 = [self progressViewWithFrame:frame];
    radialView2.progressTotal = (int)((float)DelayTime/0.01);
    radialView2.progressCounter = 0;
    radialView2.hidden = YES;
    radialView2.theme.thickness = 15;
    radialView2.theme.incompletedColor = [UIColor clearColor];
    radialView2.theme.completedColor = [UIColor colorWithRed:133/255.0 green:209/255.0 blue:252/255.0 alpha:1];
    radialView2.theme.sliceDividerHidden = YES;
    radialView2.label.hidden = YES;
    [_bottomContainerView addSubview:radialView2];
    
    camB = [UIButton buttonWithType:UIButtonTypeCustom];
    [camB setImage:[UIImage imageNamed:@"paisheanniu"] forState:UIControlStateNormal];
    [camB setFrame:CGRectMake((SC_APP_SIZE.width - cameraBtnLength) / 2, (_bottomContainerView.frame.size.height - 0 - cameraBtnLength) / 2 , cameraBtnLength, cameraBtnLength)];
    camB.showsTouchWhenHighlighted = YES;
    [camB addTarget:self action:@selector(takePictureBtnPressed:) forControlEvents:UIControlEventTouchDown];
    [camB addTarget:self action:@selector(reSetAlertText) forControlEvents:UIControlEventTouchUpOutside];
    [camB addTarget:self action:@selector(stopTimer) forControlEvents:UIControlEventTouchUpInside];
    [_bottomContainerView addSubview:camB];
    [_cameraBtnSet addObject:camB];
    

    
    alertL = [[UILabel alloc] initWithFrame:CGRectMake(0, camB.frame.origin.y-30, self.view.frame.size.width, 20)];
    alertL.textAlignment = NSTextAlignmentCenter;
    alertL.font = [UIFont systemFontOfSize:14];
    alertL.textColor = [UIColor whiteColor];
    alertL.backgroundColor = [UIColor clearColor];
    alertL.text = @"长按体验连拍功能";
    [_bottomContainerView addSubview:alertL];
    
    page = [[UIPageControl alloc] init];
    page.frame = alertL.frame;
    page.pageIndicatorTintColor = [UIColor whiteColor];
    page.currentPageIndicatorTintColor = [UIColor whiteColor];
    [_bottomContainerView addSubview:page];
    
    UICollectionViewFlowLayout* soundLayout = [[UICollectionViewFlowLayout alloc]init];
    soundLayout.itemSize = CGSizeMake(50,50);
    soundLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    soundLayout.minimumInteritemSpacing = 5;
    soundLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.soundCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, camB.frame.origin.y-47, self.view.frame.size.width, 60) collectionViewLayout:soundLayout];
    _soundCollectionView.frame = [self.view convertRect:_soundCollectionView.frame fromView:_bottomContainerView];
    _soundCollectionView.delegate = self;
    _soundCollectionView.dataSource = self;
    _soundCollectionView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    [self.view addSubview:_soundCollectionView];
    _soundCollectionView.showsHorizontalScrollIndicator = NO;
    [_soundCollectionView registerClass:[photoCell class] forCellWithReuseIdentifier:@"cell"];
    _soundCollectionView.hidden = YES;
    
    if (self.view.frame.size.height<500) {
        _soundCollectionView.frame = CGRectOffset(_soundCollectionView.frame, 0, -16);
    }
    
    UIButton *libraryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [libraryBtn setImage:[UIImage imageNamed:@"choosephotos"] forState:UIControlStateNormal];
    [libraryBtn setFrame:CGRectMake(30, (_bottomContainerView.frame.size.height-30)/2, 30, 30)];
    libraryBtn.showsTouchWhenHighlighted = YES;
    [libraryBtn addTarget:self action:@selector(libraryBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomContainerView addSubview:libraryBtn];
    [_cameraBtnSet addObject:libraryBtn];
    
    musicB = [UIButton buttonWithType:UIButtonTypeCustom];
    musicB .frame = CGRectMake(_bottomContainerView.frame.size.width-70, (_bottomContainerView.frame.size.height-40)/2, 40, 40);
    musicB.layer.cornerRadius = 20;
    musicB.layer.masksToBounds = YES;
    musicB.userInteractionEnabled = YES;
    musicB.backgroundColor = [UIColor whiteColor];
    [_bottomContainerView addSubview:musicB];
    [_cameraBtnSet addObject:musicB];
    [musicB addTarget:self action:@selector(selectSound) forControlEvents:UIControlEventTouchUpInside];
    [musicB setImage:[UIImage imageNamed:@"voiceImgNone"] forState:UIControlStateNormal];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"VoiceAttract"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"VoiceAttract"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        PromptView * p = [[PromptView alloc] initWithPoint:CGPointMake(musicB.center.x-20, musicB.center.y-30) image:[UIImage imageNamed:@"sound_prompt"] arrowDirection:3];
        [_bottomContainerView addSubview:p];
        [p show];
    }
    
    //拍照的菜单栏view（屏幕高度大于480的，此view在上面，其他情况在下面）
    CGFloat menuViewY = 0;
    UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(0, menuViewY, self.view.frame.size.width, CAMERA_MENU_VIEW_HEIGH)];
    menuView.backgroundColor = bottomContainerView_DOWN_COLOR;
    [self.view addSubview:menuView];
    self.cameraMenuView = menuView;
    
    [self addMenuViewButtons];
}
- (MDRadialProgressView *)progressViewWithFrame:(CGRect)frame
{
    MDRadialProgressView *view = [[MDRadialProgressView alloc] initWithFrame:frame];
    
    // Only required in this demo to align vertically the progress views.
//    view.center = CGPointMake(160, 400);
    
    return view;
}
//拍照菜单栏上的按钮
- (void)addMenuViewButtons {
    NSMutableArray *normalArr = [[NSMutableArray alloc] initWithObjects:@"close_cha.png", @"camera_line.png", @"switch_camera.png", @"flashing_off.png", nil];
    NSMutableArray *highlightArr = [[NSMutableArray alloc] initWithObjects:@"close_cha_h.png", @"", @"", @"", nil];
    NSMutableArray *selectedArr = [[NSMutableArray alloc] initWithObjects:@"", @"camera_line_h.png", @"switch_camera_h.png", @"", nil];
    
    NSMutableArray *actionArr = [[NSMutableArray alloc] initWithObjects:@"dismissBtnPressed:", @"gridBtnPressed:", @"switchCameraBtnPressed:", @"flashBtnPressed:", nil];
    
    CGFloat eachW = SC_APP_SIZE.width / actionArr.count;
    
    //屏幕高度大于480的，后退按钮放在_cameraMenuView；小于480的，放在_bottomContainerView
    float cha = (160-eachW*3)/3;
    CGFloat theH = (/*i == 0 ? _bottomContainerView.frame.size.height :*/ CAMERA_MENU_VIEW_HEIGH);
    UIView *parent = ( /*i == 0 ? _bottomContainerView :*/ _cameraMenuView);

    UIButton * btn = [self buildButton:CGRectMake(/*(i==0)?0:*/0, 0, eachW, theH)
                          normalImgStr:[normalArr objectAtIndex:0]
                       highlightImgStr:[highlightArr objectAtIndex:0]
                        selectedImgStr:[selectedArr objectAtIndex:0]
                                action:NSSelectorFromString([actionArr objectAtIndex:0])
                            parentView:parent];
    
    btn.showsTouchWhenHighlighted = YES;
    
    [_cameraBtnSet addObject:btn];
    for (int i = 1; i < actionArr.count; i++) {
        UIButton * btn = [self buildButton:CGRectMake(/*(i==0)?0:*/SELF_CON_SIZE.width- 230 +(cha*i+eachW*i), 0, eachW, theH)
                              normalImgStr:[normalArr objectAtIndex:i]
                           highlightImgStr:[highlightArr objectAtIndex:i]
                            selectedImgStr:[selectedArr objectAtIndex:i]
                                    action:NSSelectorFromString([actionArr objectAtIndex:i])
                                parentView:parent];
        
        btn.showsTouchWhenHighlighted = YES;
        
        [_cameraBtnSet addObject:btn];
        if (i == actionArr.count-1) {
            captureFlashB = btn;
        }
    }
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device.flashMode == AVCaptureFlashModeOff) {
        return;
    }
    [device lockForConfiguration:nil];
    device.flashMode = AVCaptureFlashModeOff;
    [device unlockForConfiguration];
}

-(void)libraryBtnClicked:(UIButton *)sender
{
    UIImagePickerController * imagePicker;
    imagePicker=[[UIImagePickerController alloc]init];
    imagePicker.delegate=self;
    imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.allowsEditing = YES;
//    if (!imagePicker.navigationController) {
//        if ([UIApplication sharedApplication].statusBarHidden == YES) {
//            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
//        }
//    }
    [self presentViewController:imagePicker animated:YES completion:^{
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
           [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        }
        
        }];

}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
//    if (!picker.navigationController) {
//        if ([UIApplication sharedApplication].statusBarHidden == NO) {
//            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
//        }
//    }
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage*selectImage = [info objectForKey:UIImagePickerControllerEditedImage];
    NSLog(@"sizesssssss:%f,%f",selectImage.size.width,selectImage.size.height);
    if (selectImage.size.width!=selectImage.size.height) {
        selectImage = [TTImageHelper cutImage:selectImage targetSizeX:600 targetSizeY:600];
        NSLog(@"sizemmmmmmmmm:%f,%f",selectImage.size.width,selectImage.size.height);
    }

    [picker dismissViewControllerAnimated:NO completion:^{
//        WEAKSELF_SC
//        SCNavigationController *nav = (SCNavigationController*)weakSelf_SC.navigationController;
//        if ([nav.scNaigationDelegate respondsToSelector:@selector(didTakePicture:image:)]) {
//            [nav.scNaigationDelegate didTakePicture:nav image:selectImage];
//        }
        [self publisSoundTouchViewWithImage:selectImage];
    }];
    
}

- (UIButton*)buildButton:(CGRect)frame
            normalImgStr:(NSString*)normalImgStr
         highlightImgStr:(NSString*)highlightImgStr
          selectedImgStr:(NSString*)selectedImgStr
                  action:(SEL)action
              parentView:(UIView*)parentView {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    if (normalImgStr.length > 0) {
        [btn setImage:[UIImage imageNamed:normalImgStr] forState:UIControlStateNormal];
    }
    if (highlightImgStr.length > 0) {
        [btn setImage:[UIImage imageNamed:highlightImgStr] forState:UIControlStateHighlighted];
    }
    if (selectedImgStr.length > 0) {
        [btn setImage:[UIImage imageNamed:selectedImgStr] forState:UIControlStateSelected];
    }
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [parentView addSubview:btn];
    
    return btn;
}

//对焦的框
- (void)addFocusView {
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"touch_focus_x.png"]];
    imgView.alpha = 0;
    [self.view addSubview:imgView];
    self.focusImageView = imgView;
    
#if SWITCH_SHOW_FOCUSVIEW_UNTIL_FOCUS_DONE
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device && [device isFocusPointOfInterestSupported]) {
        [device addObserver:self forKeyPath:ADJUSTINT_FOCUS options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
#endif
}

//拍完照后的遮罩
- (void)addCameraCover {
  
    
    UIImageView *downView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _bottomContainerView.frame.origin.y, SC_APP_SIZE.width, 0)];
//    downView.backgroundColor = [UIColor blackColor];
    [downView setImage:[UIImage imageNamed:@"capdown"]];
    [self.view addSubview:downView];
    self.doneCameraDownView = downView;
    
    UIImageView *upView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SC_APP_SIZE.width, 0)];
    //    upView.backgroundColor = [UIColor blackColor];
    [upView setImage:[UIImage imageNamed:@"captop"]];
    [self.view addSubview:upView];
    self.doneCameraUpView = upView;
}

- (void)showCameraCover:(BOOL)toShow {
    
    [UIView animateWithDuration:0.2f animations:^{
        CGRect upFrame = CGRectMake(0, CAMERA_TOPVIEW_HEIGHT, _doneCameraUpView.frame.size.width, _doneCameraUpView.frame.size.height);
        upFrame.size.height = (toShow ? SC_DEVICE_SIZE.width / 2 + CAMERA_TOPVIEW_HEIGHT+((ScreenWidth>320)?10:0) : 0);
        _doneCameraUpView.frame = upFrame;
        
        CGRect downFrame = _doneCameraDownView.frame;
        downFrame.origin.y = (toShow ? SC_DEVICE_SIZE.width / 2 + CAMERA_TOPVIEW_HEIGHT +1: _bottomContainerView.frame.origin.y);
        downFrame.size.height = (toShow ? SC_DEVICE_SIZE.width / 2 : 0);
        _doneCameraDownView.frame = downFrame;
    }];
}

//伸缩镜头的手势
- (void)addPinchGesture {
    pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self.view addGestureRecognizer:pinch];
    
    //横向
    //    CGFloat width = _previewRect.size.width - 100;
    //    CGFloat height = 40;
    //    SCSlider *slider = [[SCSlider alloc] initWithFrame:CGRectMake((SC_APP_SIZE.width - width) / 2, SC_APP_SIZE.width + CAMERA_MENU_VIEW_HEIGH - height, width, height)];
    
    //竖向
    CGFloat width = 40;
    CGFloat height = _previewRect.size.height - 100;
    SCSlider *slider = [[SCSlider alloc] initWithFrame:CGRectMake(_previewRect.size.width - width, (_previewRect.size.height + CAMERA_MENU_VIEW_HEIGH - height) / 2, width, height) direction:SCSliderDirectionVertical];
    slider.alpha = 0.f;
    slider.minValue = MIN_PINCH_SCALE_NUM;
    slider.maxValue = MAX_PINCH_SCALE_NUM;
    
    WEAKSELF_SC
    [slider buildDidChangeValueBlock:^(CGFloat value) {
        [weakSelf_SC.captureManager pinchCameraViewWithScalNum:value];
    }];
    [slider buildTouchEndBlock:^(CGFloat value, BOOL isTouchEnd) {
        [weakSelf_SC setSliderAlpha:isTouchEnd];
    }];
    
    [self.view addSubview:slider];
    
    self.scSlider = slider;
}

void c_slideAlpha() {
    
}

- (void)setSliderAlpha:(BOOL)isTouchEnd {
    if (_scSlider) {
        _scSlider.isSliding = !isTouchEnd;
        
        if (_scSlider.alpha != 0.f && !_scSlider.isSliding) {
            double delayInSeconds = 3.88;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                if (_scSlider.alpha != 0.f && !_scSlider.isSliding) {
                    [UIView animateWithDuration:0.3f animations:^{
                        _scSlider.alpha = 0.f;
                    }];
                }
            });
        }
    }
}

#pragma mark -------------touch to focus---------------
#if SWITCH_SHOW_FOCUSVIEW_UNTIL_FOCUS_DONE
//监听对焦是否完成了
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:ADJUSTINT_FOCUS]) {
        BOOL isAdjustingFocus = [[change objectForKey:NSKeyValueChangeNewKey] isEqualToNumber:[NSNumber numberWithInt:1] ];
        //        SCDLog(@"Is adjusting focus? %@", isAdjustingFocus ? @"YES" : @"NO" );
        //        SCDLog(@"Change dictionary: %@", change);
        if (!isAdjustingFocus) {
            alphaTimes = -1;
        }
    }
}

- (void)showFocusInPoint:(CGPoint)touchPoint {
    
    [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        
        int alphaNum = (alphaTimes % 2 == 0 ? HIGH_ALPHA : LOW_ALPHA);
        self.focusImageView.alpha = alphaNum;
        alphaTimes++;
        
    } completion:^(BOOL finished) {
        
        if (alphaTimes != -1) {
            [self showFocusInPoint:currTouchPoint];
        } else {
            self.focusImageView.alpha = 0.0f;
        }
    }];
}
#endif

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //    [super touchesBegan:touches withEvent:event];
    
    alphaTimes = -1;
    
    UITouch *touch = [touches anyObject];
    currTouchPoint = [touch locationInView:self.view];
    
    if (CGRectContainsPoint(_captureManager.previewLayer.bounds, currTouchPoint) == NO) {
        return;
    }
    if (currTouchPoint.y<44) {
        return;
    }
    
    [_captureManager focusInPoint:currTouchPoint];
    
    //对焦框
    [_focusImageView setCenter:currTouchPoint];
    _focusImageView.transform = CGAffineTransformMakeScale(2.0, 2.0);
    
#if SWITCH_SHOW_FOCUSVIEW_UNTIL_FOCUS_DONE
    [UIView animateWithDuration:0.1f animations:^{
        _focusImageView.alpha = HIGH_ALPHA;
        _focusImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        [self showFocusInPoint:currTouchPoint];
    }];
#else
    [UIView animateWithDuration:0.3f delay:0.f options:UIViewAnimationOptionAllowUserInteraction animations:^{
        _focusImageView.alpha = 1.f;
        _focusImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5f delay:0.5f options:UIViewAnimationOptionAllowUserInteraction animations:^{
            _focusImageView.alpha = 0.f;
        } completion:nil];
    }];
#endif
}

#pragma mark -------------button actions---------------
//拍照页面，拍照按钮
- (void)takePictureBtnPressed:(UIButton*)sender {
    _soundCollectionView.hidden = YES;
    alertL.hidden = NO;
    page.hidden = NO;
    nowTime = [[NSDate date] timeIntervalSince1970];
    radialView2.hidden = NO;
    showTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(setProgressOfTime) userInfo:nil repeats:YES];
    [self performSelector:@selector(startContinuousPhotograph) withObject:nil afterDelay:DelayTime];
}
-(void)setProgressOfTime
{
    if (radialView2.progressCounter<(int)(DelayTime/0.01)) {
        radialView2.progressCounter++;
    }
    else
        [showTimer invalidate];
    
}
- (void)stopTimer
{
    [_getcoinAudio stop];
    if ([showTimer isValid]) {
        [showTimer invalidate];
    }
    radialView2.hidden = YES;
    alertL.hidden = YES;
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(startContinuousPhotograph) object:nil];
#if SWITCH_SHOW_DEFAULT_IMAGE_FOR_NONE_CAMERA
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self publisSoundTouchViewWithImage:[UIImage imageNamed:@"meizi.jpg"]];
        return;
    }
#endif
    camB.enabled = NO;
    if ([[NSDate date] timeIntervalSince1970] - nowTime > DelayTime) {
        [self getstillImages];
    }else
    {
        [self getOneImage];
    }
}
- (void)reSetAlertText
{
    alertL.text = @"长按体验连拍功能";
    if ([showTimer isValid]) {
        [showTimer invalidate];
    }
    radialView2.hidden = YES;
    radialView2.progressCounter = 0;
}
- (void)startContinuousPhotograph
{
    alertL.text = @"松开开始连拍";
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device.flashMode == AVCaptureFlashModeOff) {
        return;
    }
    [device lockForConfiguration:nil];
    [captureFlashB setImage:[UIImage imageNamed:@"flashing_off.png"] forState:UIControlStateNormal];
    device.flashMode = AVCaptureFlashModeOff;
    [device unlockForConfiguration];
}
- (void)getstillImages
{
    WEAKSELF_SC
    [_captureManager takePicture:^(UIImage *stillImage) {
        if (stillImage) {
            [weakSelf_SC.photoArr addObject:stillImage];
        }
        page.numberOfPages = _photoArr.count;
        if (_photoArr.count >= 5) {
            __block UIActivityIndicatorView *actiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            actiView.center = CGPointMake(self.view.center.x, self.view.center.y - CAMERA_TOPVIEW_HEIGHT-44);
            [actiView startAnimating];
            [weakSelf_SC.view addSubview:actiView];
            [weakSelf_SC showCameraCover:YES];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSMutableArray * arr = [NSMutableArray array];
                for (UIImage * image in _photoArr) {
                    [arr addObject:[_captureManager cutImage:image]];
                }
                self.photoArr = arr;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [actiView stopAnimating];
                    [actiView removeFromSuperview];
                    actiView = nil;
                    [self showCameraCover:NO];
                    [weakSelf_SC publisAffirmImageView];
                });
            });
        }else
        {
            [weakSelf_SC performSelector:@selector(getstillImages) withObject:nil afterDelay:0.3];
        }
    }];
}
- (void)getOneImage
{
    __block UIActivityIndicatorView *actiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    actiView.center = CGPointMake(self.view.center.x, self.view.center.y - CAMERA_TOPVIEW_HEIGHT-44);
//    [actiView startAnimating];
    [self.view addSubview:actiView];
    [self showCameraCover:YES];
    WEAKSELF_SC
    [_captureManager takePicture:^(UIImage *stillImage) {
        if (stillImage) {
//            [actiView stopAnimating];
            [actiView removeFromSuperview];
            actiView = nil;
//            [weakSelf_SC showCameraCover:NO];
            [weakSelf_SC publisSoundTouchViewWithImage:stillImage];
        }else
        {
            [weakSelf_SC getOneImage];
        }
        
    }];
}
- (void)publisAffirmImageView
{
    SCNavigationController *nav = (SCNavigationController*)self.navigationController;
    SelectImageViewController * selectV = [[SelectImageViewController alloc] init];
    selectV.imageArr = _photoArr;
    TalkingPublish * talkPublish = [[TalkingPublish alloc] init];
    if (_tag) {
        talkPublish.tagArray = @[_tag];
    }
    selectV.talkingPublish = talkPublish ;
    [nav pushViewController:selectV animated:YES];
}
- (void)publisSoundTouchViewWithImage:(UIImage *)image;
{
    image = [_captureManager cutImage:image];
    SCNavigationController *nav = (SCNavigationController*)self.navigationController;
    DecorateViewController * decorateVC = [[DecorateViewController alloc] init];
    TalkingPublish * talkPublish = [[TalkingPublish alloc] init];
    talkPublish.originalImg = image;
    if (_tag) {
        talkPublish.tagArray = @[_tag];
    }
    decorateVC.talkingPublish = talkPublish ;
    [nav pushViewController:decorateVC animated:YES];
}
- (void)tmpBtnPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//拍照页面，"X"按钮
- (void)dismissBtnPressed:(id)sender {
    if (self.navigationController) {
        if (self.navigationController.viewControllers.count == 1) {
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                
            }];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}


//拍照页面，网格按钮
- (void)gridBtnPressed:(UIButton*)sender {
    sender.selected = !sender.selected;
    [_captureManager switchGrid:sender.selected];
}

//拍照页面，切换前后摄像头按钮按钮
- (void)switchCameraBtnPressed:(UIButton*)sender {
    sender.selected = !sender.selected;
    [_captureManager switchCamera:sender.selected];
}

//拍照页面，闪光灯按钮
- (void)flashBtnPressed:(UIButton*)sender {
    [_captureManager switchFlashMode:sender];
}
#pragma mark 声音相关
- (void)selectSound
{
    if (_soundCollectionView.hidden) {
        _soundCollectionView.hidden = NO;
        alertL.hidden = YES;
        page.hidden = YES;
    }else
    {
        _soundCollectionView.hidden = YES;
        alertL.hidden = NO;
        page.hidden = NO;
    }
}
- (void)playSound
{
    _soundCollectionView.hidden = YES;
    alertL.hidden = NO;
    page.hidden = NO;
    NSString * stringUrl3 = [[NSBundle mainBundle] pathForResource:contuntVoice.fileName ofType:@"wav"];
    NSURL * url3 = [NSURL fileURLWithPath:stringUrl3];
    if (_getcoinAudio) {
        [_getcoinAudio stop];
    }
    self.getcoinAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:url3 error:nil];
    _getcoinAudio.delegate = self;
    [_getcoinAudio prepareToPlay];
    [_getcoinAudio play];
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [_getcoinAudio play];
}
#pragma mark - UICollectionView
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        _soundCollectionView.hidden = YES;
        alertL.hidden = NO;
        page.hidden = NO;
        [musicB setImage:[UIImage imageNamed:@"voiceImgNone"] forState:UIControlStateNormal];
        [_getcoinAudio stop];
    }else{
        [musicB setImage:[UIImage imageNamed:((Voice*)_voiceArr[indexPath.row]).imageName] forState:UIControlStateNormal] ;
        contuntVoice = _voiceArr[indexPath.row];
        [self playSound];
    }
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 8;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellIdentifier = @"cell";
        photoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.imageV.image = [UIImage imageNamed:@"voiceImgNone"];
        return  cell;
    }
    static NSString *cellIdentifier = @"cell";
    photoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.imageV.image = [UIImage imageNamed:((Voice*)_voiceArr[indexPath.row]).imageName];
    return  cell;
}
#pragma mark -------------pinch camera---------------
//伸缩镜头
- (void)handlePinch:(UIPinchGestureRecognizer*)gesture {
    
    [_captureManager pinchCameraView:gesture];
    
    if (_scSlider) {
        if (_scSlider.alpha != 1.f) {
            [UIView animateWithDuration:0.3f animations:^{
                _scSlider.alpha = 1.f;
            }];
        }
        [_scSlider setValue:_captureManager.scaleNum shouldCallBack:NO];
        
        if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
            [self setSliderAlpha:YES];
        } else {
            [self setSliderAlpha:NO];
        }
    }
}


//#pragma mark -------------save image to local---------------
////保存照片至本机
//- (void)saveImageToPhotoAlbum:(UIImage*)image {
//    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//}
//
//- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
//    if (error != NULL) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"出错了!" message:@"存不了T_T" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        [alert show];
//    } else {
//        SCDLog(@"保存成功");
//    }
//}

#pragma mark ------------notification-------------
- (void)orientationDidChange:(NSNotification*)noti {
    
    //    [_captureManager.previewLayer.connection setVideoOrientation:(AVCaptureVideoOrientation)[UIDevice currentDevice].orientation];
    
    if (!_cameraBtnSet || _cameraBtnSet.count <= 0) {
        return;
    }
    [_cameraBtnSet enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        UIButton *btn = ([obj isKindOfClass:[UIButton class]] ? (UIButton*)obj : nil);
        if (!btn) {
            *stop = YES;
            return ;
        }
        
        btn.layer.anchorPoint = CGPointMake(0.5, 0.5);
        CGAffineTransform transform = CGAffineTransformMakeRotation(0);
        switch ([UIDevice currentDevice].orientation) {
            case UIDeviceOrientationPortrait://1
            {
                transform = CGAffineTransformMakeRotation(0);
                break;
            }
            case UIDeviceOrientationPortraitUpsideDown://2
            {
                transform = CGAffineTransformMakeRotation(M_PI);
                break;
            }
            case UIDeviceOrientationLandscapeLeft://3
            {
                transform = CGAffineTransformMakeRotation(M_PI_2);
                break;
            }
            case UIDeviceOrientationLandscapeRight://4
            {
                transform = CGAffineTransformMakeRotation(-M_PI_2);
                break;
            }
            default:
                break;
        }
        [UIView animateWithDuration:0.3f animations:^{
            btn.transform = transform;
        }];
    }];
}

#pragma mark ---------rotate(only when this controller is presented, the code below effect)-------------
//<iOS6
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOrientationChange object:nil];
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0
//iOS6+
- (BOOL)shouldAutorotate
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOrientationChange object:nil];
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    //    return [UIApplication sharedApplication].statusBarOrientation;
	return UIInterfaceOrientationPortrait;
}
#endif

@end
