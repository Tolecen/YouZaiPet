//
//  ProgressView.m
//  TalkingPet
//
//  Created by wangxr on 14-8-9.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "ProgressView.h"
#import <AVFoundation/AVFoundation.h>
@interface ProgressView()
{
    UIView * planV;
    NSTimer * progressTimer;
}
@property (nonatomic,assign)AVAudioPlayer * audioPlayer;
@end
@implementation ProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
       
        planV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, frame.size.height)];
        planV.backgroundColor = [UIColor colorWithRed:60/255.0 green:198/255.0 blue:255/255.0 alpha:1];
        [self addSubview:planV];
    }
    return self;
}
-(void)playWithAudioPlayer:(AVAudioPlayer*)audioPlayer
{
    [progressTimer invalidate];
    self.audioPlayer = audioPlayer;
    progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(play) userInfo:nil repeats:YES];
    [progressTimer fire];
}
-(void)play
{
    if (_audioPlayer) {
        planV.frame = CGRectMake(0, 0, self.frame.size.width*_audioPlayer.currentTime/_audioPlayer.duration, self.frame.size.height);
    }else
    {
         [progressTimer invalidate];
    }
}
-(void)stop
{
    [progressTimer invalidate];
    planV.frame = CGRectMake(0, 0, 0, self.frame.size.height);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
