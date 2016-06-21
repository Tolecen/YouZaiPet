//
//  Recorder.m
//  TalkingPet
//
//  Created by wangxr on 14-7-8.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "Recorder.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioUnit/AudioUnit.h>

#define kNumberAudioQueueBuffers 3
#define kBufferDurationSeconds 0.1f
@interface Recorder ()
{
    AudioQueueRef				_audioQueue;
    AudioQueueBufferRef			_audioBuffers[kNumberAudioQueueBuffers];
    AudioStreamBasicDescription	_recordFormat;
    
}
@property (nonatomic, retain) NSMutableData * audioData;
@end
@implementation Recorder
static const int bufferByteSize = 1600;
static const int sampeleRate = 8000;
static const int bitsPerChannel = 16;
- (id)init
{
    self = [super init];
    if (self) {
        
        AudioSessionInitialize(NULL, NULL, NULL, (__bridge void *)(self));
    }
    return self;
}


// 设置录音格式
- (void) setupAudioFormat:(UInt32) inFormatID SampleRate:(int) sampeleRate
{
    memset(&_recordFormat, 0, sizeof(_recordFormat));
    _recordFormat.mSampleRate = sampeleRate;
    
	UInt32 size = sizeof(_recordFormat.mChannelsPerFrame);
    AudioSessionGetProperty(kAudioSessionProperty_CurrentHardwareInputNumberChannels, &size, &_recordFormat.mChannelsPerFrame);
	_recordFormat.mFormatID = inFormatID;
	if (inFormatID == kAudioFormatLinearPCM){
		// if we want pcm, default to signed 16-bit little-endian
		_recordFormat.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
		_recordFormat.mBitsPerChannel = bitsPerChannel;
		_recordFormat.mBytesPerPacket = _recordFormat.mBytesPerFrame = (_recordFormat.mBitsPerChannel / 8) * _recordFormat.mChannelsPerFrame;
		_recordFormat.mFramesPerPacket = 1;
	}
}

// 回调函数
void inputBufferHandler(void *inUserData, AudioQueueRef inAQ, AudioQueueBufferRef inBuffer, const AudioTimeStamp *inStartTime,
                        UInt32 inNumPackets, const AudioStreamPacketDescription *inPacketDesc)
{
    Recorder *recorder = (__bridge Recorder *)inUserData;
    if (inNumPackets > 0){
        int pcmSize = inBuffer->mAudioDataByteSize;
        char *pcmData = (char *)inBuffer->mAudioData;
        NSData *data = [[NSData alloc] initWithBytes:pcmData length:pcmSize];
        [recorder.audioData appendData:data];
        AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
    }
    id delegate = recorder.delegate;
    if (delegate &&[delegate respondsToSelector:@selector(recording:)]) {
        [delegate performSelectorOnMainThread:@selector(recording:) withObject:recorder waitUntilDone:NO];
    }
}

// 开始录音
- (void) startRecording
{
    if (_delegate &&[_delegate respondsToSelector:@selector(recorderBeginRecord:)]) {
        [_delegate recorderBeginRecord:self];
    }
    self.audioData = [NSMutableData data];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    
    AudioSessionSetActive(true);
    
    // category
    UInt32 category = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);
    // format
    [self setupAudioFormat:kAudioFormatLinearPCM SampleRate:sampeleRate];
    // 设置回调函数
    AudioQueueNewInput(&_recordFormat, inputBufferHandler, (__bridge void *)(self), NULL, NULL, 0, &_audioQueue);
    // 创建缓冲器
    for (int i = 0; i < kNumberAudioQueueBuffers; ++i){
        AudioQueueAllocateBuffer(_audioQueue, bufferByteSize, &_audioBuffers[i]);
        AudioQueueEnqueueBuffer(_audioQueue, _audioBuffers[i], 0, NULL);
    }
    // 开始录音
    AudioQueueStart(_audioQueue, NULL);
}

// 停止录音
- (NSData*) stopRecordingWithData
{
    AudioQueueStop(_audioQueue, true);
    AudioQueueDispose(_audioQueue, true);
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    if (_delegate &&[_delegate respondsToSelector:@selector(recorderEndRecord:)]) {
        [_delegate recorderEndRecord:self];
    }
    return _audioData;
}
@end
