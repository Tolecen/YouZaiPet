//
//  FinalPublishPageViewController.m
//  TalkingPet
//
//  Created by Tolecen on 14-7-8.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "FinalPublishPageViewController.h"
#import "RootViewController.h"
#import "TagViewController.h"
#import "SystemServer.h"
#import "DatabaseServe.h"
#import "ShareServe.h"
#import "PublishServer.h"
#import "SVProgressHUD.h"

#if TARGET_IPHONE_SIMULATOR

#elif TARGET_OS_IPHONE
#import "amrFileCodec.h"
#endif
@interface FinalPublishPageViewController ()<UITextViewDelegate,EmojiViewDelegate,UIActionSheetDelegate,UIScrollViewDelegate,SelectTagDelegate>
{
    BOOL hasLocation;
    UILabel * wechatL;
    UILabel * sinaL;
    
    UILabel * tagL;
    UILabel * addressL;
}

@property (nonatomic,strong) UIImageView * imageV;
@property (nonatomic,strong) UITextView * textV;
@property (nonatomic,strong) UIButton * emojiBtn;
@property (nonatomic,strong) UILabel * remainingL;
@property (nonatomic,strong) UIView * shareBGV;

@property (nonatomic,strong) UIImageView * sinaWeiboImageV;
@property (nonatomic,strong) UIImageView * wechatImageV;
@property (nonatomic,strong) UIImageView * tencentWeiboImageV;
@property (nonatomic,strong) UIImageView * qqImageV;
@property (nonatomic,strong) UIActivityIndicatorView * indicatorView;

@property (strong,nonatomic) EmojiView *theEmojiView;

@end

@implementation FinalPublishPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.canScrollBack = NO;
        self.title = @"发布宠物说";
        hasLocation = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setBackButtonWithTarget:@selector(showActionsheet)];
    [self setRightButtonWithName:@"发布" BackgroundImg:nil Target:@selector(publishBtn)];
    
    self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, self.view.frame.size.width/4, self.view.frame.size.width/4)];
    [self.imageV setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:self.imageV];
    [self.imageV setImage:self.talkingPublish.thumImg];

    self.textV = [[UITextView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/4+10, 5, self.view.frame.size.width*3/4-20, self.view.frame.size.width/4)];
    self.textV.text = @"输入内容";
    self.textV.delegate = self;
    self.textV.backgroundColor = [UIColor clearColor];
    [self.textV setFont:[UIFont systemFontOfSize:17]];
    self.textV.textColor = [UIColor grayColor];
    self.textV.returnKeyType = UIReturnKeyDone;
    [self.view  addSubview:self.textV];
    [_textV becomeFirstResponder];
    
    self.emojiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.emojiBtn setFrame:CGRectMake(self.view.frame.size.width-120, self.view.frame.size.height-355-35, 25, 25)];
    [self.emojiBtn setBackgroundImage:[UIImage imageNamed:@"emoticon"] forState:UIControlStateNormal];
    [self.view  addSubview:self.emojiBtn];
    [self.emojiBtn addTarget:self action:@selector(emojiBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton*tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tagBtn setFrame:CGRectMake(5, self.view.frame.size.height-355-40 ,80 , 35)];
    UIImageView * tagIV = [[UIImageView alloc] initWithFrame:CGRectMake(2, 8, 75.5, 18.5)];
    tagIV.image = [UIImage imageNamed:@"addTag"];
    [tagBtn addSubview:tagIV];
    [self.view  addSubview:tagBtn];
    tagL = [[UILabel alloc] initWithFrame:CGRectMake(19, 8, 55, 18.5)];
    tagL.backgroundColor = [UIColor clearColor];
    tagL.text = @"添加标签";
    tagL.textAlignment = NSTextAlignmentCenter;
    tagL.font = [UIFont systemFontOfSize:12];
    tagL.textColor = [UIColor whiteColor];
    [tagBtn addSubview:tagL];
    [tagBtn addTarget:self action:@selector(selectTag) forControlEvents:UIControlEventTouchUpInside];
    if (self.talkingPublish.tagArray.count) {
        tagL.text =((Tag*)[self.talkingPublish.tagArray firstObject]).tagName;
    }
    else
    {
        PromptView * p = [[PromptView alloc] initWithPoint:CGPointMake(tagBtn.center.x, tagBtn.frame.origin.y-8) image:[UIImage imageNamed:@"add_tag_prompt"] arrowDirection:3];
        [self.view addSubview:p];
        [p show];
    }
    
//    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"TagPrompt"]) {
//        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"TagPrompt"];
//        [[NSUserDefaults standardUserDefaults] synchronize];

//    }
    
    UIButton*locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [locationBtn setFrame:CGRectMake(ScreenWidth>320?95:90, self.view.frame.size.height-355-40, 85, 35)];
    UIImageView * addresIV = [[UIImageView alloc] initWithFrame:CGRectMake(2, 8, 80.5, 18.5)];
    addresIV.image = [UIImage imageNamed:@"addaddress"];
    [locationBtn addSubview:addresIV];
    [self.view  addSubview:locationBtn];
    addressL = [[UILabel alloc] initWithFrame:CGRectMake(19, 8, 65, 18.5)];
    addressL.backgroundColor = [UIColor clearColor];
    addressL.text = @"添加位置";
    addressL.font = [UIFont systemFontOfSize:12];
    addressL.textColor = [UIColor whiteColor];
    [locationBtn addSubview:addressL];
    [locationBtn addTarget:self action:@selector(locationBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.remainingL = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-20-120, self.view.frame.size.height-355-33, 120, 20)];
    [self.remainingL setBackgroundColor:[UIColor clearColor]];
    [self.remainingL setTextColor:[UIColor grayColor]];
    [self.remainingL setFont:[UIFont systemFontOfSize:15]];
    [self.remainingL setTextAlignment:NSTextAlignmentRight];
    [self.remainingL setText:@"剩余:50"];
    [self.view  addSubview:self.remainingL];
    
    self.shareBGV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    [self.shareBGV setBackgroundColor:[UIColor clearColor]];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor colorWithWhite:240/255.0 alpha:1];
    [_shareBGV addSubview:lineView];
    
    UILabel * gb = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 90, 20)];
    [gb setBackgroundColor:[UIColor clearColor]];
    [gb setText:@"内容同步到:"];
    [gb setTextColor:[UIColor grayColor]];
    [gb setFont:[UIFont systemFontOfSize:14]];
    [self.shareBGV addSubview:gb];
    
    SystemServer * sys = [SystemServer sharedSystemServer];
    
    UIButton * sinaWeiboBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sinaWeiboBtn setFrame:CGRectMake(100, 0, 90, 40)];
    [sinaWeiboBtn setBackgroundColor:[UIColor clearColor]];
    [self.shareBGV addSubview:sinaWeiboBtn];
    self.sinaWeiboImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 7.5, 25, 25)];
    [sinaWeiboBtn addSubview:self.sinaWeiboImageV];
    [sinaWeiboBtn addTarget:self action:@selector(autoSinaWeibo:) forControlEvents:UIControlEventTouchUpInside];
    sinaL = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 60, 20)];
    [sinaL setBackgroundColor:[UIColor clearColor]];
    [sinaL setText:@"新浪微博"];
    sinaL.font = [UIFont systemFontOfSize:14];
    [sinaWeiboBtn addSubview:sinaL];
    if (sys.autoSinaWeiBo) {
        [self.sinaWeiboImageV setImage:[UIImage imageNamed:@"Sinamicro-blog_cli"]];
        [sinaL setTextColor:[UIColor colorWithWhite:80/255.0 alpha:1]];
    }else
    {
        [self.sinaWeiboImageV setImage:[UIImage imageNamed:@"Sinamicro-blog"]];
        [sinaL setTextColor:[UIColor grayColor]];
    }

    
    UIButton * weichatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [weichatBtn setFrame:CGRectMake(200, 0, 110, 40)];
    [weichatBtn setBackgroundColor:[UIColor clearColor]];
    [self.shareBGV addSubview:weichatBtn];
    self.wechatImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 7.5, 25, 25)];
    [weichatBtn addSubview:self.wechatImageV];
    [weichatBtn addTarget:self action:@selector(autoWeiChat:) forControlEvents:UIControlEventTouchUpInside];
    wechatL = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 80, 20)];
    [wechatL setBackgroundColor:[UIColor clearColor]];
    [wechatL setText:@"微信朋友圈"];
    wechatL.font = [UIFont systemFontOfSize:14];
    [weichatBtn addSubview:wechatL];
    if (sys.autoFriendCircle) {
        [self.wechatImageV setImage:[UIImage imageNamed:@"pengyouquan-cli"]];
        [wechatL setTextColor:[UIColor colorWithWhite:80/255.0 alpha:1]];
    }else
    {
        [self.wechatImageV setImage:[UIImage imageNamed:@"pengyouquan"]];
        [wechatL setTextColor:[UIColor grayColor]];
    }
    
    _textV.inputAccessoryView = _shareBGV;
    
    self.theEmojiView = [[EmojiView alloc] initWithFrame:CGRectMake(0, [UIApplication sharedApplication].keyWindow.frame.size.height, 320, 273) WithSendBtn:NO];
    self.theEmojiView.delegate = self;
    [self.view addSubview:self.theEmojiView];
    UIView * hh = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    [hh setBackgroundColor:[UIColor grayColor]];
    [self.theEmojiView addSubview:hh];
    self.theEmojiView.hidden = YES;
    
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.indicatorView setFrame:CGRectMake(locationBtn.frame.origin.x+locationBtn.frame.size.width+2, self.view.frame.size.height-355-33, 20, 20)];
    [self.view addSubview:self.indicatorView];
    self.indicatorView.hidden = YES;
    LocationManager * locationM = [LocationManager sharedInstance];
    locationM.autoCheck = YES;
    [self checkLocation];
}
-(void)emojiBtnClicked
{
    if (self.theEmojiView.hidden==YES) {
        [self.emojiBtn setBackgroundImage:[UIImage imageNamed:@"keybord2"] forState:UIControlStateNormal];
        self.theEmojiView.hidden = NO;
        [self.textV resignFirstResponder];
        [UIView animateWithDuration:0.3 animations:^{
            [self.theEmojiView setFrame:CGRectMake(0, [UIApplication sharedApplication].keyWindow.frame.size.height-273, 320, 273)];
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        [self.emojiBtn setBackgroundImage:[UIImage imageNamed:@"emoticon"] forState:UIControlStateNormal];
//        self.theEmojiView.hidden = YES;
        [self.textV becomeFirstResponder];
        [UIView animateWithDuration:0.3 animations:^{
            [self.theEmojiView setFrame:CGRectMake(0, [UIApplication sharedApplication].keyWindow.frame.size.height, 320, 273)];
        } completion:^(BOOL finished) {
            self.theEmojiView.hidden = YES;
        }];
    }

}
- (void)selectTag
{
    TagViewController * tagVC = [[TagViewController alloc]init];
    tagVC.delegate = self;
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:tagVC];
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)selectedTag:(Tag*)tag;
{
    if (tag) {
        self.talkingPublish.tagArray = @[tag];
        tagL.text = tag.tagName;
    }
    [_textV becomeFirstResponder];
}
-(void)locationBtnClicked
{
    if (hasLocation) {
        self.talkingPublish.location = nil;
        addressL.text = @"添加位置";
        hasLocation = NO;
    }
    else
    {
        LocationManager * locationM = [LocationManager sharedInstance];
        locationM.autoCheck = NO;
        [self checkLocation];
    }
}
-(void)checkLocation
{
    
    ((UIButton*) addressL.superview).enabled = NO;
    [self.indicatorView startAnimating];
    self.indicatorView.hidden = NO;
    addressL.text = @"定位中...";
    LocationManager * locationM = [LocationManager sharedInstance];
    [locationM startCheckLocationWithSuccess:^(double lat, double lon) {
        NSLog(@"lat:%f,lon:%f",lat,lon);
        [locationM analysisRegionWithLat:lat Lon:lon WithSuccess:^(NSString *address) {
            NSLog(@"Address:%@",address);
            
            Location *loc = [[Location alloc] init];
            loc.lat = lat;
            loc.lon = lon;
            loc.address = address;
            self.talkingPublish.location = loc;
            addressL.text = address;
            hasLocation = YES;
            ((UIButton*) addressL.superview).enabled = YES;
            [self.indicatorView stopAnimating];
            self.indicatorView.hidden = YES;
            
        } Failure:^{
            ((UIButton*) addressL.superview).enabled = YES;
            [self.indicatorView stopAnimating];
            self.indicatorView.hidden = YES;
            addressL.text = @"添加位置";
        }];
    } Failure:^{
        ((UIButton*) addressL.superview).enabled = YES;
        [self.indicatorView stopAnimating];
        self.indicatorView.hidden = YES;
        addressL.text = @"添加位置";
    }];
}
-(void)publishBtn
{
    if (_textV.text.length>50) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"最多输入50个字哦" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [_textV resignFirstResponder];
    if (!_talkingPublish.tagArray.count) {
        
        [SVProgressHUD showErrorWithStatus:@"请选择一个标签"];
        return;
    }

    if ([_talkingPublish.tagArray firstObject]) {
        [DatabaseServe saveTag:[_talkingPublish.tagArray firstObject]];
    }
    if (![self.textV.textColor isEqual:[UIColor grayColor]]||[self.textV.text CutSpacing].length) {
        _talkingPublish.textDescription = [self.textV.text CutSpacing];
    }
    [self.textV resignFirstResponder];
    
    UINavigationController *navigationController = [RootViewController sharedRootViewController].topVC.currentC;
    if (navigationController.viewControllers.count>1) {
        [navigationController popToRootViewControllerAnimated:YES];
        [[RootViewController sharedRootViewController].topVC showTabBar];
    }
    
    [PublishServer publishPetalk:_talkingPublish model:[SystemServer sharedSystemServer].publishstatu];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([UIApplication sharedApplication].statusBarHidden == YES) {
        //iOS7，需要plist里设置 View controller-based status bar appearance 为NO
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        
    }
    self.navigationController.navigationBarHidden = NO;
//    [self.bgV setFrame:CGRectMake(5, 5, 310, self.view.frame.size.height-navigationBarHeight-20)];

}
-(void)backBtn
{
    [self.navigationController popViewControllerAnimated:YES];
    if ([UIApplication sharedApplication].statusBarHidden == NO) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        
    }
    self.navigationController.navigationBarHidden = YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.emojiBtn setBackgroundImage:[UIImage imageNamed:@"emoticon"] forState:UIControlStateNormal];
    if (self.textV.textColor==[UIColor grayColor]) {
        self.textV.textColor = [UIColor blackColor];
        self.textV.text = @"";
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self.theEmojiView setFrame:CGRectMake(0, [UIApplication sharedApplication].keyWindow.frame.size.height, 320, 273)];
    } completion:^(BOOL finished) {
        self.theEmojiView.hidden = YES;
    }];
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length<=0) {
        self.textV.text = @"输入内容";
        self.textV.textColor = [UIColor grayColor];
    }
}
-(void)textViewDidChange:(UITextView *)textView
{
    self.remainingL.text = [NSString stringWithFormat:@"剩余:%ld",50-self.textV.text.length];
    if (50-(int)self.textV.text.length<0) {
        self.remainingL.textColor = [UIColor redColor];
    }
    else
        self.remainingL.textColor = [UIColor grayColor];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return  YES;
}
-(NSString *)selectedEmoji:(NSString *)ssss
{
    if (self.textV.textColor==[UIColor grayColor]) {
        self.textV.textColor = [UIColor blackColor];
        self.textV.text = @"";
    }
	if (self.textV.text == nil) {
		self.textV.text = ssss;
	}
	else {
		self.textV.text = [self.textV.text stringByAppendingString:ssss];
	}
    self.remainingL.text = [NSString stringWithFormat:@"剩余:%ld",50-self.textV.text.length];
    if (50-(int)self.textV.text.length<0) {
        self.remainingL.textColor = [UIColor redColor];
    }
    else
        self.remainingL.textColor = [UIColor grayColor];
    return 0;
}
-(void)deleteEmojiStr
{
    if (self.textV.text.length>=1) {
        self.textV.text = [self.textV.text substringToIndex:(self.textV.text.length-1)];
    }
}

- (void)showActionsheet
{
    UIActionSheet * actionShoot = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"继续编辑",@"保存草稿",@"取消发布", nil];
    [actionShoot showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:{
            [self performSelector:@selector(backBtn) withObject:nil afterDelay:0.2];
        }break;
        case 1:{
            if (_textV.text.length>50) {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"最多输入50个字哦" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            if (![self.textV.textColor isEqual:[UIColor grayColor]]||[self.textV.text CutSpacing].length) {
                _talkingPublish.textDescription = [self.textV.text CutSpacing];
            }
            [SVProgressHUD showWithStatus:@"保存中,请稍后"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSString * publishID = gen_uuid();
                NSData * publishImgData = UIImageJPEGRepresentation(_talkingPublish.publishImg , 0.8);
                NSData * thumImgData = UIImageJPEGRepresentation(_talkingPublish.thumImg , 0.8);
                NSString * publishImgPath = [NSString stringWithFormat:@"/%@img.jpg",publishID];
                if ([publishImgData writeToFile:[subdirectoryw stringByAppendingString:publishImgPath] atomically:YES]) {
                    NSLog(@"write failed img success");
                }
                else
                {
                    NSLog(@"write failed img failed");
                }
                NSString * thumImgPath = [NSString stringWithFormat:@"/%@thumb.jpg",publishID];
                if ([thumImgData writeToFile:[subdirectoryw stringByAppendingString:thumImgPath] atomically:YES]) {
                    NSLog(@"write failed thumbimg success");
                }
                else
                {
                    NSLog(@"write failed thumbimg failed");
                }
                NSString * publishAudioPath = [NSString stringWithFormat:@"/%@audio.caf",publishID];
                if ([_talkingPublish.publishAudioData writeToFile:[subdirectoryw stringByAppendingString:publishAudioPath] atomically:YES]) {
                    NSLog(@"write failed audio success");
                }
                else
                {
                    NSLog(@"write failed audio failed");
                }
                DraftModel * petalkDraft = [[DraftModel alloc] init];
                petalkDraft.publishModel = [NSNumber numberWithInt:[SystemServer sharedSystemServer].publishstatu];
                petalkDraft.publishID = publishID;
                petalkDraft.publishImgPath = publishImgPath;
                petalkDraft.thumImgPath = thumImgPath;
                petalkDraft.publishAudioPath = publishAudioPath;
                petalkDraft.currentPetID = [UserServe sharedUserServe].currentPet.petID;
                petalkDraft.tagID = ((Tag*)[_talkingPublish.tagArray firstObject]).tagID;
                petalkDraft.audioDuration = [NSString stringWithFormat:@"%ld",(long)_talkingPublish.audioDuration];
                if (_talkingPublish.animationImg.tagID) {
                    petalkDraft.decorationId = [NSString stringWithFormat:@"%ld",(long)_talkingPublish.animationImg.tagID];
                    petalkDraft.width = [NSString stringWithFormat:@"%f",_talkingPublish.animationImg.width];
                    petalkDraft.height = [NSString stringWithFormat:@"%f",_talkingPublish.animationImg.height];
                    petalkDraft.centerX = [NSString stringWithFormat:@"%f",_talkingPublish.animationImg.centerX];
                    petalkDraft.centerY = [NSString stringWithFormat:@"%f",_talkingPublish.animationImg.centerY];
                    petalkDraft.rotationZ = [NSString stringWithFormat:@"%f",_talkingPublish.animationImg.rotationZ];
                }
                if (_talkingPublish.location) {
                    petalkDraft.locationAddress = _talkingPublish.location.address;
                    petalkDraft.locationLon = [NSString stringWithFormat:@"%f",_talkingPublish.location.lon];
                    petalkDraft.locationLat = [NSString stringWithFormat:@"%f",_talkingPublish.location.lat];
                }
                petalkDraft.textDescription = _talkingPublish.textDescription;
                NSDateFormatter * dateF= [[NSDateFormatter alloc]init];
                dateF.dateFormat = @"yyyy.MM.dd HH:mm";
                petalkDraft.lastEnditDate = [dateF stringFromDate:[NSDate date]];
                [DatabaseServe savePetalkDraft:petalkDraft];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [SVProgressHUD showSuccessWithStatus:@"保存成功"];
                });
            });
            [_textV resignFirstResponder];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }break;
        case 2:{
            [_textV resignFirstResponder];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }break;
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}
#pragma mark -
- (void)autoSinaWeibo:(UIButton*)button
{
    SystemServer * sys = [SystemServer sharedSystemServer];
    sys.autoSinaWeiBo = !sys.autoSinaWeiBo;
    [DatabaseServe setAutoShareSinaWeiBo:sys.autoSinaWeiBo];
    if (sys.autoSinaWeiBo) {
        [ShareServe authSineWithSucceed:^(BOOL state) {
            [_textV becomeFirstResponder];
            if (state) {
                [self.sinaWeiboImageV setImage:[UIImage imageNamed:@"Sinamicro-blog_cli"]];
                [sinaL setTextColor:[UIColor colorWithWhite:80/255.0 alpha:1]];
            }
        }];
    }else
    {
        [self.sinaWeiboImageV setImage:[UIImage imageNamed:@"Sinamicro-blog"]];
        [sinaL setTextColor:[UIColor grayColor]];
    }
}
- (void)autoWeiChat:(UIButton *)button
{
    SystemServer * sys = [SystemServer sharedSystemServer];
    sys.autoFriendCircle = !sys.autoFriendCircle;
    [DatabaseServe setAutoShareFriendCircle:sys.autoFriendCircle];
    if (sys.autoFriendCircle) {
        [self.wechatImageV setImage:[UIImage imageNamed:@"pengyouquan-cli"]];
        [wechatL setTextColor:[UIColor colorWithWhite:80/255.0 alpha:1]];
    }else
    {
        [self.wechatImageV setImage:[UIImage imageNamed:@"pengyouquan"]];
        [wechatL setTextColor:[UIColor grayColor]];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
