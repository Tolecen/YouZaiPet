//
//  SoundConverter.h
//  TalkingPet
//
//  Created by wangxr on 14-7-8.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoundConverter : NSObject
+ (void)updataAudioData:(NSData*)audioData SampleRate:(int)sampleRate tempoChangeValue:(int)tempoChange pitchSemiTones:(int)pitch rateChange:(int)rate finish:(void(^)(NSData* wavDatas))finish;
@end
