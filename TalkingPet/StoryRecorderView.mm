//
//  StoryRecorderView.m
//  TalkingPet
//
//  Created by wangxr on 15/7/14.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "StoryRecorderView.h"
#import "Recorder.h"
#import "SoundConverter.h"
#import <AVFoundation/AVFoundation.h>
#include "WaveHeader.h"
#import "SVProgressHUD.h"
#import "RecordView.h"
#define inputViewHeight 240

@interface StoryRecorderView ()<RecorderDelegate>
{
    UIView * inputView;
    UIButton * finishB;
    UIButton * cancelB;
    UIButton * recorderB;
    UIButton * playB;
    UIImageView * progress;
    UILabel * durationL;
    UILabel * alertL;
    double beginTime;
    
    RecordView * recordView;
}
@property (nonatomic,retain)Recorder * recorder;
@property (nonatomic,retain)AVAudioPlayer* audioPalyer;
@property (nonatomic,retain)NSMutableData * wavData;
@property (nonatomic,retain)NSString * duration;
@end
@implementation StoryRecorderView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.recorder = [[Recorder alloc]init];
        _recorder.delegate = self;
        [self creatSubView];
    }
    return self;
}
-(void)creatSubView
{
    inputView = [[UIView alloc] init];
    inputView.backgroundColor = [UIColor whiteColor];
    [self addSubview:inputView];
    cancelB = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelB setTitle:@"取消" forState:UIControlStateNormal];
    [cancelB setTitleColor:[UIColor colorWithWhite:140/255.0 alpha:1] forState:UIControlStateNormal];
    [cancelB addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [inputView addSubview:cancelB];
    finishB = [UIButton buttonWithType:UIButtonTypeCustom];
    [finishB setTitle:@"保存" forState:UIControlStateNormal];
    [finishB addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
    [finishB setTitleColor:[UIColor colorWithRed:133/255.0 green:203/255.0 blue:252/255.0 alpha:1] forState:UIControlStateNormal];
    [inputView addSubview:finishB];
    recorderB = [UIButton buttonWithType:UIButtonTypeCustom];
    [recorderB setImage:[UIImage imageNamed:@"story_recorder_nomo"] forState:UIControlStateNormal];
    [recorderB setImage:[UIImage imageNamed:@"story_recorder_higtlight"] forState:UIControlStateHighlighted];
    [recorderB addTarget:self action:@selector(beginRecorder) forControlEvents:UIControlEventTouchDown];
    [inputView addSubview:recorderB];
    
    progress = [[UIImageView alloc] init];
    progress.image = [[UIImage imageNamed:@"story_recorder_progress"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 18, 0, 18)];
    progress.hidden = YES;
    [self addSubview:progress];
    
    playB = [UIButton buttonWithType:UIButtonTypeCustom];
    [playB setImage:[UIImage imageNamed:@"stror_recorder_play"] forState:UIControlStateNormal];
    [playB addTarget:self action:@selector(playWavData) forControlEvents:UIControlEventTouchUpInside];
    playB.hidden = YES;
    playB.frame = CGRectMake(0, 0, 28.5, 21.5);
    [self addSubview:playB];
    durationL = [[UILabel alloc] init];
    durationL.textColor = [UIColor whiteColor];
    durationL.font = [UIFont systemFontOfSize:12];
    durationL.hidden = YES;
    [self addSubview:durationL];
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    inputView.frame = CGRectMake(0, frame.size.height, frame.size.width, inputViewHeight);
    cancelB.frame = CGRectMake(10, 10, 60, 30);
    finishB.frame = CGRectMake(frame.size.width-70, 10, 60, 30);
    recorderB.frame = CGRectMake(0, 0, 90, 90);
    recorderB.center = CGPointMake(CGRectGetMidX(inputView.bounds), CGRectGetMidY(inputView.bounds));
}
-(void)showWithView:(UIView *)view finish:(void(^) (NSData * sound,NSString * duration))finish
{
    self.finish = finish;
    self.frame = view.bounds;
    [view addSubview:self];
    __block UIView * blockInputView = inputView;
    [UIView animateWithDuration:0.3 animations:^{
        blockInputView.frame  = CGRectOffset(blockInputView.frame, 0, -inputViewHeight);
    } completion:^(BOOL finished) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }];
}
-(void)finishAction
{
    if (!_wavData) {
        [SVProgressHUD showErrorWithStatus:@"请先录音"];
        return;
    }
    if (_finish) {
        _finish(_wavData,_duration);
    }

    [self removeFromSuperview];
}
-(void)cancelAction
{
    if (_wavData) {
        self.wavData = nil;
        [cancelB setTitle:@"取消" forState:UIControlStateNormal];
        recorderB.enabled = YES;
        [recorderB setImage:[UIImage imageNamed:@"story_recorder_nomo"] forState:UIControlStateNormal];
        [recorderB setImage:[UIImage imageNamed:@"story_recorder_higtlight"] forState:UIControlStateHighlighted];
        progress.hidden = YES;
        playB.hidden = YES;
        durationL.hidden = YES;
    }else{
        [self removeFromSuperview];
    }
}
-(void)beginRecorder
{
    CGRect rect = self.bounds;
    progress.frame = CGRectMake(rect.size.width/2-18, rect.size.height-inputViewHeight-60, 36, 36);
    progress.hidden = NO;
    playB.center = progress.center;
    [recorderB addTarget:self action:@selector(recordEnd) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside|UIControlEventTouchCancel];
    [_recorder startRecording];
}
- (void) recorderBeginRecord:(Recorder*)recorder
{
    beginTime = [[NSDate date] timeIntervalSince1970];
    recordView = [[RecordView alloc] init];
    [recordView recordViewShow];
}
- (void) recording:(Recorder*)recorder
{
    
    double time = [[NSDate date] timeIntervalSince1970] - beginTime;
    CGFloat increment = (time/60*(self.frame.size.width-80)-progress.frame.size.width)/2>0;
    if (increment<0) {
        increment = 0;
    }
    progress.frame = CGRectInset(progress.frame, -increment, 0);
    if (time >= 60) {
        [self recordEnd];
        [SVProgressHUD showSuccessWithStatus:@"录音时间已满60秒"];
    }
}
- (void)recordEnd
{
    [recordView recordViewhidden];
    [cancelB setTitle:@"清除" forState:UIControlStateNormal];
    [recorderB setImage:[UIImage imageNamed:@"story_recorder_unuse"] forState:UIControlStateNormal];
    [recorderB setImage:[UIImage imageNamed:@"story_recorder_unuse"] forState:UIControlStateHighlighted];
    recorderB.enabled = NO;
    playB.hidden = NO;
    [recorderB removeTarget:self action:@selector(recordEnd) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside|UIControlEventTouchCancel];
    NSData*soundData = [_recorder stopRecordingWithData];
    self.wavData = [[NSMutableData alloc] init];
    int fileLength = (int)soundData.length;
    void *header = createWaveHeader(fileLength, 1, 8000, 16);
    [_wavData appendBytes:header length:44];
    [_wavData appendData:soundData];
    NSError * error;
    self.audioPalyer = [[AVAudioPlayer alloc] initWithData:_wavData error:&error];
    [_audioPalyer prepareToPlay];
    self.duration = [NSString stringWithFormat:@"%.0f",nearbyint(_audioPalyer.duration)];
    durationL.text = [NSString stringWithFormat:@"%@\"",_duration];
    CGSize size = [durationL.text sizeWithFont:durationL.font constrainedToSize:CGSizeMake(0, 0) lineBreakMode:NSLineBreakByWordWrapping];
    durationL.frame = CGRectMake(CGRectGetMaxX(progress.frame)+10, progress.frame.origin.y, size.width, size.height);
    durationL.hidden = NO;
}
-(void)removeFromSuperview
{
    [_audioPalyer stop];
    self.audioPalyer = nil;
    [super removeFromSuperview];
}
- (void)dealloc
{
    
}
-(void)playWavData
{
    [_audioPalyer play];
}
@end
