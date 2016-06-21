//
//  SoundTouchViewController.m
//  TalkingPet
//
//  Created by wangxr on 14-7-10.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//
#import "SoundTouchViewController.h"
#import "Recorder.h"
#import "SoundConverter.h"
#import "SVProgressHUD.h"
#import "FinalPublishPageViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "RecordView.h"
#import "ProgressView.h"
#import "TFileManager.h"

@interface Sound  : NSObject//音效实体
@property (nonatomic,assign)CGFloat tempo;
@property (nonatomic,assign)CGFloat pitch;
@property (nonatomic,assign)CGFloat rate;
@property (nonatomic,retain)NSString * imageName;
@property (nonatomic,retain)NSString * descriptionContent;
@end
@implementation Sound

@end

@interface EffectCell : UICollectionViewCell
@property (nonatomic,retain)UIImageView * imageV;
@end
@implementation EffectCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIView * selectedV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        selectedV.backgroundColor = [UIColor clearColor];
        UIImageView*selectedIV =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        selectedIV.image = [UIImage imageNamed:@"selected_accessory"];
        [selectedV addSubview:selectedIV];
        self.selectedBackgroundView = selectedV;
        self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(2.5, 2.5, 65, 85)];
        [self.contentView addSubview:_imageV];
    }
    return self;
}
@end

@interface SoundTouchViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIActionSheetDelegate,AVAudioPlayerDelegate,RecorderDelegate>
{
    UIButton * recordB;
    NSTimer * audioDurationTimer;
    ProgressView * progressV;
    RecordView * recordView;
    UIImageView * imageV;
    UIImageView * mouthIV;
    UIButton * playB;
    UILabel * alertL;
    
    UIButton * BackButton;
    UIButton * rightButton;
}
@property (nonatomic,retain)Recorder * recorder;
@property (nonatomic,retain)NSArray * soundArr;
@property (nonatomic,assign)Sound * nowAound;
@property (nonatomic,retain)NSMutableData * soundData;
@property (nonatomic,retain)AVAudioPlayer* audioPalyer;
@property (nonatomic,retain)UICollectionView * soundCollectionV;
@end

@implementation SoundTouchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.canScrollBack = NO;
        self.soundArr = @[
            ({
                Sound * sound = [[Sound alloc]init];
                sound.descriptionContent = @"原音";
                sound.imageName = @"Sound1";
                sound.tempo = 0;
                sound.pitch = 0;
                sound.rate = 0;
                sound;
            }),
            ({
              Sound * sound = [[Sound alloc]init];
              sound.descriptionContent = @"萝莉";
              sound.imageName = @"Sound2";
              sound.tempo = 0;
              sound.pitch = 3;
              sound.rate = 0;
              sound;
            }),
            ({
                Sound * sound = [[Sound alloc]init];
                sound.descriptionContent = @"少侠";
                sound.imageName = @"Sound3";
                sound.tempo = 0;
                sound.pitch = -2;
                sound.rate = 0;
                sound;
            }),
            ({
                Sound * sound = [[Sound alloc]init];
                sound.descriptionContent = @"猫咪";
                sound.imageName = @"Sound4";
                sound.tempo = 0;
                sound.pitch = 5;
                sound.rate = 0;
                sound;
            }),
            ({
                Sound * sound = [[Sound alloc]init];
                sound.descriptionContent = @"型男";
                sound.imageName = @"Sound5";
                sound.tempo = 0;
                sound.pitch = -4;
                sound.rate = 0;
                sound;
            }),
            ({
                Sound * sound = [[Sound alloc]init];
                sound.descriptionContent = @"萌音";
                sound.imageName = @"Sound6";
                sound.tempo = 0;
                sound.pitch = 8;
                sound.rate = 0;
                sound;
            }),
            ({
                Sound * sound = [[Sound alloc]init];
                sound.descriptionContent = @"狗狗";
                sound.imageName = @"Sound7";
                sound.tempo = 0;
                sound.pitch = -6;
                sound.rate = 0;
                sound;
            }),
            ({
                Sound * sound = [[Sound alloc]init];
                sound.descriptionContent = @"高音";
                sound.imageName = @"Sound8";
                sound.tempo = 0;
                sound.pitch = 11;
                sound.rate = 0;
                sound;
            }),
            ({
                Sound * sound = [[Sound alloc]init];
                sound.descriptionContent = @"魔鬼";
                sound.imageName = @"Sound9";
                sound.tempo = 0;
                sound.pitch = -8;
                sound.rate = 0;
                sound;
            }),
            ({
                Sound * sound = [[Sound alloc]init];
                sound.descriptionContent = @"欢快";
                sound.imageName = @"Sound10";
                sound.tempo = 0;
                sound.pitch = -5;
                sound.rate = 30;
                sound;
            }),
            ({
                Sound * sound = [[Sound alloc]init];
                sound.descriptionContent = @"蜗牛";
                sound.imageName = @"Sound11";
                sound.tempo = 0;
                sound.pitch = 5;
                sound.rate = -20;
                sound;
            })];
        self.nowAound = _soundArr[0];
    }
    return self;
}
- (void)setHeaderView
{
    UIView * headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    headView.backgroundColor = [UIColor colorWithWhite:110/255.0 alpha:1];
    [self.view addSubview:headView];
    
    BackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    BackButton.frame = CGRectMake(10, 6, 65, 32);
    [BackButton setBackgroundImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [BackButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:BackButton];
    
    rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(self.view.frame.size.width-90, 6, 85, 32);
    [rightButton setTitle:@"下一步" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [rightButton addTarget:self action:@selector(puthNextViewController) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:rightButton];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 32)];
    label.center = CGPointMake(CGRectGetMidX(headView.frame), CGRectGetMidY(headView.frame));
    label.backgroundColor = [UIColor clearColor];
    label.text = @"编辑";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:20];
    [headView addSubview:label];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithWhite:110/255.0 alpha:1];
    [self setHeaderView];
    
    self.recorder = [[Recorder alloc]init];
    _recorder.delegate = self;
//soundTouch
    imageV = [[UIImageView alloc] init];
    if (self.view.frame.size.height-self.view.frame.size.width-160>0) {
        imageV.frame = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.width);
    }else
    {
        imageV.frame = CGRectMake(0, 44, self.view.frame.size.width-56, self.view.frame.size.width-56);
    }
    imageV.center = CGPointMake(self.view.center.x, imageV .center.y);
    imageV.image = _talkingPublish.publishImg;
    imageV.clipsToBounds = YES;
    imageV.userInteractionEnabled = YES;
    [self.view addSubview:imageV];
    
    mouthIV = [[UIImageView alloc] init];
    [imageV addSubview:mouthIV];
    mouthIV.image = [TFileManager getFristImageWithID:self.talkingPublish.mouthAccessory.fileName];
    mouthIV.animationImages = [TFileManager getAllImagesWithID:self.talkingPublish.mouthAccessory.fileName];
    mouthIV.animationDuration = mouthIV.animationImages.count *0.15;
    mouthIV.frame = CGRectMake(0, 0, self.talkingPublish.animationImg.width*imageV.frame.size.width, self.talkingPublish.animationImg.height*imageV.frame.size.height);
    mouthIV.center = CGPointMake( self.talkingPublish.animationImg.centerX*imageV.frame.size.width, self.talkingPublish.animationImg.centerY*imageV.frame.size.height);
    mouthIV.transform = CGAffineTransformRotate(mouthIV.transform, self.talkingPublish.animationImg.rotationZ);
    
    progressV = [[ProgressView alloc] initWithFrame:CGRectMake(CGRectGetMinX(imageV.frame), CGRectGetMaxY(imageV.frame), imageV.frame.size.width, 5)];
    [self.view addSubview:progressV];
    
    UICollectionViewFlowLayout* soundLayout = [[UICollectionViewFlowLayout alloc]init];
    soundLayout.itemSize = CGSizeMake(70,90);
    soundLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.soundCollectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-90, self.view.frame.size.width,90) collectionViewLayout:soundLayout];
    _soundCollectionV.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _soundCollectionV.delegate = self;
    _soundCollectionV.dataSource = self;
    _soundCollectionV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_soundCollectionV];
    _soundCollectionV.showsHorizontalScrollIndicator = NO;
    [_soundCollectionV registerClass:[EffectCell class] forCellWithReuseIdentifier:@"cell"];
    [_soundCollectionV selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    
    self.soundData = [[NSMutableData alloc] init];
    recordB = [UIButton buttonWithType:UIButtonTypeCustom];
    recordB.frame = CGRectMake(0,0, 99, 99);
    recordB.center = CGPointMake(CGRectGetMidX(self.view.bounds), self.view.frame.size.height-130);
    [self.view addSubview:recordB];
    [recordB setBackgroundImage:[UIImage imageNamed:@"record-normal"] forState:UIControlStateNormal];
    [recordB setBackgroundImage:[UIImage imageNamed:@"record_click"] forState:UIControlStateHighlighted];
    [recordB addTarget:self action:@selector(recordBegin) forControlEvents:UIControlEventTouchDown];
    
    alertL = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-190, self.view.frame.size.width, 20)];
    alertL.font = [UIFont systemFontOfSize:14];
    alertL.textAlignment = NSTextAlignmentCenter;
    alertL.backgroundColor = [UIColor clearColor];
    alertL.textColor = [UIColor whiteColor];
    [self.view addSubview:alertL];
    alertL.text = @"长按开始录音";
    
    playB = [UIButton buttonWithType:UIButtonTypeCustom];
    playB.frame = CGRectMake(0, 0, 67, 67);
    [playB setBackgroundImage:[UIImage imageNamed:@"play_normal"] forState:UIControlStateNormal];
    [playB setBackgroundImage:[UIImage imageNamed:@"play_click"] forState:UIControlStateHighlighted];
    playB.center = CGPointMake(CGRectGetMidX(imageV.bounds), CGRectGetMidY(imageV.bounds));
    [imageV addSubview:playB];
    [playB addTarget:self action:@selector(playAudioWithData) forControlEvents:UIControlEventTouchUpInside];
}
- (void)back
{
    [self stopPreview];
    [_audioPalyer stop];
    UIActionSheet * action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"重新录音",@"编辑装饰",@"取消发布", nil];
    [action showInView:self.view];
}
#pragma mark - 录音相关
- (void)audioDurationUp
{
    if (++self.talkingPublish.originalDuration >= 60) {
        [self recordEnd];
        [recordB setBackgroundImage:[UIImage imageNamed:@"record_forbidden"] forState:UIControlStateNormal];
        recordB.enabled = NO;
        [SVProgressHUD showErrorWithStatus:@"录音60秒就可以了哦,亲~"];
    }
    if (recordView) {
        recordView.timeL.text = [NSString stringWithFormat:@"%ld\"",(long)self.talkingPublish.originalDuration];
    }
}
- (void)recordBegin
{
    [recordB addTarget:self action:@selector(recordEnd) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside|UIControlEventTouchCancel];
    _soundCollectionV.userInteractionEnabled = NO;
    [_audioPalyer stop];
    [self stopPreview];
    [_recorder startRecording];
    recordView = [[RecordView alloc] init];
    [recordView recordViewShow];
    BackButton.enabled = NO;
    rightButton.enabled = NO;
}
- (void) recorderBeginRecord:(Recorder*)recorder
{
    audioDurationTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(audioDurationUp) userInfo:nil repeats:YES];
    [audioDurationTimer fire];
    alertL.text = @"松开停止录音";
}
- (void)recordEnd
{
    [recordB removeTarget:self action:@selector(recordEnd) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside|UIControlEventTouchCancel];
    _soundCollectionV.userInteractionEnabled = YES;
    [recordView recordViewhidden];
    recordView = nil;
    [audioDurationTimer invalidate];
    [_soundData appendData:[_recorder stopRecordingWithData]];
    [self playAudioWithData];
    self.talkingPublish.originalAudioData = _soundData;
    alertL.text = @"长按继续录音";
    BackButton.enabled = YES;
    rightButton.enabled = YES;
}
-(void)playAudioWithData
{
    
    if (_soundData.length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"还没有录音,先录个音呗~"];
        return;
    }
    playB.hidden = YES;
    [SoundConverter updataAudioData:_soundData SampleRate:8000 tempoChangeValue:self.nowAound.tempo pitchSemiTones:self.nowAound.pitch rateChange:self.nowAound.rate finish:^(NSData *wavDatas) {
        NSError * error = nil;
        self.audioPalyer = [[AVAudioPlayer alloc] initWithData:wavDatas error:&error];
        [_audioPalyer prepareToPlay];
        _audioPalyer.delegate = self;
        [_audioPalyer play];
        [progressV playWithAudioPlayer:_audioPalyer];
        self.talkingPublish.publishAudioData = wavDatas;
        self.talkingPublish.audioDuration = _audioPalyer.duration;
        [mouthIV startAnimating];
    }];
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self stopPreview];
}
- (void)stopPreview
{
    playB.hidden = NO;
    [progressV stop];
    [mouthIV stopAnimating];
}

#pragma mark - UICollectionView
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.nowAound = _soundArr[indexPath.row];
    [self playAudioWithData];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _soundArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    EffectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.imageV.image = [UIImage imageNamed:((Sound*)_soundArr[indexPath.row]).imageName];
    return  cell;
    
}
#pragma mark - UIActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:{
            self.soundData = [[NSMutableData alloc] init];
            self.talkingPublish.publishAudioData = nil;
            self.talkingPublish.audioDuration = 0;
            self.talkingPublish.originalDuration = 0;
            recordB.enabled = YES;
            [recordB setBackgroundImage:[UIImage imageNamed:@"record-normal"] forState:UIControlStateNormal];
            alertL.text = @"长按开始录音";
            [SVProgressHUD showErrorWithStatus:@"录音已被重置,请重新录音啊"];
        }break;
        case 1:{
            self.talkingPublish.publishAudioData = nil;
            self.talkingPublish.audioDuration = 0;
            self.talkingPublish.originalDuration = 0;
            [self.navigationController popViewControllerAnimated:YES];
        }break;
        case 2:{
            [progressV stop];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }break;
        default:
            break;
    }
}
#pragma mark -
- (void)puthNextViewController
{
    if (!self.talkingPublish.publishAudioData||self.talkingPublish.originalDuration<2) {
       [SVProgressHUD showErrorWithStatus:@"录音时间太短，再说两句吧~"];
        return;
    }
    [self stopPreview];
    [_audioPalyer stop];
    self.talkingPublish.audioDuration = _audioPalyer.duration;
    FinalPublishPageViewController * PublishVC = [[FinalPublishPageViewController alloc] init];
    PublishVC.talkingPublish = self.talkingPublish;
    [self.navigationController pushViewController:PublishVC animated:YES];
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
