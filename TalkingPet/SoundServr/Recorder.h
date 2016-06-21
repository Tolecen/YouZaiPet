//
//  Recorder.h
//  TalkingPet
//
//  Created by wangxr on 14-7-8.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Recorder;
@protocol RecorderDelegate<NSObject>
@optional
- (void) recorderBeginRecord:(Recorder*)recorder;
- (void) recording:(Recorder*)recorder;
- (void) recorderEndRecord:(Recorder*)recorder;
@end
@interface Recorder : NSObject
@property (nonatomic,assign)id<RecorderDelegate>delegate;
- (void) startRecording;
- (NSData*) stopRecordingWithData;
@end
