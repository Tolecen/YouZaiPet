//
//  MyCommentViewController.h
//  TalkingPet
//
//  Created by Tolecen on 14/12/11.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "BrowserTableHelper.h"
#import "XHAudioPlayerHelper.h"
@interface MyCommentViewController : BaseViewController<BrowserTableHelperDelegate,XHAudioPlayerHelperDelegate>
{
    NSString * currentPlayingUrl;
    UIImageView * genderIV;
    UILabel * breedAgeL;
    
}
@property (nonatomic,strong) XHAudioPlayerHelper * audioPlayer;
@end
