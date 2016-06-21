//
//  SoundConverter.m
//  TalkingPet
//
//  Created by wangxr on 14-7-8.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "SoundConverter.h"
#include "SoundTouch.h"
#include "WaveHeader.h"

using namespace soundtouch;

@implementation SoundConverter
+ (void)updataAudioData:(NSData*)audioData SampleRate:(int)sampleRate tempoChangeValue:(int)tempoChange pitchSemiTones:(int)pitch rateChange:(int)rate finish:(void(^)(NSData* wavDatas))finish

{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        soundtouch::SoundTouch mSoundTouch;
        mSoundTouch.setSampleRate(sampleRate); //setSampleRate
        mSoundTouch.setChannels(1);       //设置声音的声道
        mSoundTouch.setTempoChange(tempoChange);    //这个就是传说中的变速不变调
        mSoundTouch.setPitchSemiTones(pitch); //设置声音的pitch (集音高变化semi-tones相比原来的音调) //男: -8 女:8
        mSoundTouch.setRateChange(rate);     //设置声音的速率
        mSoundTouch.setSetting(SETTING_SEQUENCE_MS, 40);
        mSoundTouch.setSetting(SETTING_SEEKWINDOW_MS, 15); //寻找帧长
        mSoundTouch.setSetting(SETTING_OVERLAP_MS, 6);  //重叠帧长
        NSMutableData *soundTouchDatas = [[NSMutableData alloc] init];
        if (audioData != nil) {
            char *pcmData = (char *)audioData.bytes;
            int pcmSize = (int)audioData.length;
            int nSamples = pcmSize / 2;
            mSoundTouch.putSamples((short *)pcmData, nSamples);
            short *samples = new short[pcmSize];
            int numSamples = 0;
            do {
                memset(samples, 0, pcmSize);
//                short samples[nSamples];
                numSamples = mSoundTouch.receiveSamples(samples, pcmSize);
                [soundTouchDatas appendBytes:samples length:numSamples*2];
                
            } while (numSamples > 0);
            delete [] samples;
            
        }
        NSMutableData *wavDatas = [[NSMutableData alloc] init];
        int fileLength = (int)soundTouchDatas.length;
        void *header = createWaveHeader(fileLength, 1, sampleRate, 16);
        [wavDatas appendBytes:header length:44];
        [wavDatas appendData:soundTouchDatas];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            finish([wavDatas mutableCopy]);
        });
    });
}
@end
