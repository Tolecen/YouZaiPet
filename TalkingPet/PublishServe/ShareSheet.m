//
//  ShareSheet.m
//  TalkingPet
//
//  Created by wangxr on 14-8-28.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "ShareSheet.h"
#import "ShareServe.h"
#import "SVProgressHUD.h"

@interface ShareSheet()
{
//    UIView * weiChatFriendV;
//    UIView * friendCircleV;
//    UIView * sinaV;
//    UIView * qqV;
//    UIView * capyV;
//    UIButton * cancalB;
}
@property (nonatomic,copy)void(^action)(NSInteger index);
//
@property (nonatomic,copy)void(^success) ();
@property (nonatomic,copy)void(^forward) ();
@property (nonatomic,retain)NSString * petalkId;
@property (nonatomic,retain)NSString * nickName;
@property (nonatomic,retain)NSString * thumbnail;
@property (nonatomic,retain)NSString * descriptionContent;
@property (nonatomic,retain)NSString * trialName;
@property (nonatomic,retain)NSString * trialCode;
@property (nonatomic,retain)NSString * trialImg;
@end
@implementation ShareSheet
-(id)initWithIconArray:(NSArray*)icons titleArray:(NSArray*)titles action:(void(^)(NSInteger index))action
{
    self = [super init];
    if (self) {
        self.action = action;
        
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
        self.backgroundColor = [UIColor clearColor];
        self.frame =CGRectMake(0, window.bounds.size.height, window.bounds.size.width, window.bounds.size.height);
        
        UIView * blackView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-170, self.frame.size.width, 170)];
        blackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        [self addSubview:blackView];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 100, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"分享到:";
        label.textColor = [UIColor colorWithRed:140/255.0 green:140/255.0 blue:140/255.0 alpha:1];
        [blackView addSubview:label];
        UIButton*cancalB = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancalB setBackgroundImage:[UIImage imageNamed:@"cancal"] forState:UIControlStateNormal];
        [cancalB addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        cancalB.frame = CGRectMake(self.frame.size.width/2-100, 120, 200, 35);
        [cancalB setTitle:@"取消" forState:UIControlStateNormal];
        [blackView addSubview:cancalB];
        float width = (ScreenWidth-20)/icons.count;
        for (int i = 0; i<icons.count; i++) {
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(10+i*width, 40, width, 70)];
            view.backgroundColor = [UIColor clearColor];
            [blackView addSubview:view];
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = i;
            [button setBackgroundImage:[UIImage imageNamed:icons[i]] forState:UIControlStateNormal];
            button.frame = CGRectMake(0, 0, 45.5, 45.5);
            button.center  =CGPointMake(CGRectGetMidX(view.bounds), button.center.y);
            [view addSubview:button];
            UILabel * subLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, width, 20)];
            subLabel.backgroundColor = [UIColor clearColor];
            subLabel.font = [UIFont systemFontOfSize:13];
            subLabel.text = titles[i];
            subLabel.textColor = [UIColor colorWithRed:180/255.5 green:180/255.5 blue:180/255.5 alpha:1];
            subLabel.textAlignment = NSTextAlignmentCenter;
            [view addSubview:subLabel];
            
        }
        
    }
    return self;
}
-(void)show
{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }];
}
-(void)buttonAction:(UIButton*)button
{
    if (_action) {
        _action(button.tag);
    }
    [self dismiss];
}
- (id)initWithTrialName:(NSString*)name Code:(NSString *)code imageURL:(NSString*)img
{
    self = [super init];
    if (self) {
        self.trialCode = code;
        self.trialName = name;
        self.trialImg = img;
        
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
        self.backgroundColor = [UIColor clearColor];
        self.frame =CGRectMake(0, window.bounds.size.height, window.bounds.size.width, window.bounds.size.height);
        
        UIView * blackView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-170, self.frame.size.width, 170)];
        blackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        [self addSubview:blackView];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 100, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"分享到:";
        label.textColor = [UIColor colorWithRed:140/255.0 green:140/255.0 blue:140/255.0 alpha:1];
        [blackView addSubview:label];
        
//        weiChatFriendV = [[UIView alloc] initWithFrame:CGRectMake(10, 40, 60, 70)];
//        weiChatFriendV.backgroundColor = [UIColor clearColor];
//        [blackView addSubview:weiChatFriendV];
//        UIButton * weichatB = [UIButton buttonWithType:UIButtonTypeCustom];
//        [weichatB addTarget:self action:@selector(shareToWeichat) forControlEvents:UIControlEventTouchUpInside];
//        [weichatB setBackgroundImage:[UIImage imageNamed:@"weiChatFriend"] forState:UIControlStateNormal];
//        weichatB.frame = CGRectMake(7, 0, 45.5, 45.5);
//        [weiChatFriendV addSubview:weichatB];
//        UILabel * weichatL = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 60, 20)];
//        weichatL.backgroundColor = [UIColor clearColor];
//        weichatL.font = [UIFont systemFontOfSize:13];
//        weichatL.text = @"微信好友";
//        weichatL.textColor = [UIColor colorWithRed:180/255.5 green:180/255.5 blue:180/255.5 alpha:1];
//        weichatL.textAlignment = NSTextAlignmentCenter;
//        [weiChatFriendV addSubview:weichatL];
//        
//        friendCircleV = [[UIView alloc] initWithFrame:CGRectMake(10+(self.frame.size.width-10)/4, 40, 60, 70)];
//        friendCircleV.backgroundColor = [UIColor clearColor];
//        [blackView addSubview:friendCircleV];
//        UIButton * friendCircleB = [UIButton buttonWithType:UIButtonTypeCustom];
//        [friendCircleB addTarget:self action:@selector(shareToFriendCircle) forControlEvents:UIControlEventTouchUpInside];
//        [friendCircleB setBackgroundImage:[UIImage imageNamed:@"friendCircle"] forState:UIControlStateNormal];
//        friendCircleB.frame = CGRectMake(7, 0, 45.5, 45.5);
//        [friendCircleV addSubview:friendCircleB];
//        UILabel * friendCircleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 60, 20)];
//        friendCircleL.backgroundColor = [UIColor clearColor];
//        friendCircleL.font = [UIFont systemFontOfSize:13];
//        friendCircleL.text = @"朋友圈";
//        friendCircleL.textColor = [UIColor colorWithRed:180/255.5 green:180/255.5 blue:180/255.5 alpha:1];
//        friendCircleL.textAlignment = NSTextAlignmentCenter;
//        [friendCircleV addSubview:friendCircleL];
//        
//        sinaV = [[UIView alloc] initWithFrame:CGRectMake(10+(self.frame.size.width-10)*2/4, 40, 60, 70)];
//        sinaV.backgroundColor = [UIColor clearColor];
//        [blackView addSubview:sinaV];
//        UIButton * sinaB = [UIButton buttonWithType:UIButtonTypeCustom];
//        [sinaB addTarget:self action:@selector(shareToSina) forControlEvents:UIControlEventTouchUpInside];
//        [sinaB setBackgroundImage:[UIImage imageNamed:@"sina"] forState:UIControlStateNormal];
//        sinaB.frame = CGRectMake(7, 0, 45.5, 45.5);
//        [sinaV addSubview:sinaB];
//        UILabel * sinaL = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 60, 20)];
//        sinaL.backgroundColor = [UIColor clearColor];
//        sinaL.font = [UIFont systemFontOfSize:13];
//        sinaL.text = @"微博";
//        sinaL.textColor = [UIColor colorWithRed:180/255.5 green:180/255.5 blue:180/255.5 alpha:1];
//        sinaL.textAlignment = NSTextAlignmentCenter;
//        [sinaV addSubview:sinaL];
//        
//        qqV = [[UIView alloc] initWithFrame:CGRectMake(10+(self.frame.size.width-10)*3/4, 40, 60, 70)];
//        qqV.backgroundColor = [UIColor clearColor];
//        [blackView addSubview:qqV];
//        UIButton * qqB = [UIButton buttonWithType:UIButtonTypeCustom];
//        [qqB addTarget:self action:@selector(shareToQQ) forControlEvents:UIControlEventTouchUpInside];
//        [qqB setBackgroundImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
//        qqB.frame = CGRectMake(7, 0, 45.5, 45.5);
//        [qqV addSubview:qqB];
//        UILabel * qqL = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 60, 20)];
//        qqL.backgroundColor = [UIColor clearColor];
//        qqL.font = [UIFont systemFontOfSize:13];
//        qqL.text = @"QQ";
//        qqL.textColor = [UIColor colorWithRed:180/255.5 green:180/255.5 blue:180/255.5 alpha:1];
//        qqL.textAlignment = NSTextAlignmentCenter;
//        [qqV addSubview:qqL];
//        cancalB = [UIButton buttonWithType:UIButtonTypeCustom];
//        [cancalB setBackgroundImage:[UIImage imageNamed:@"cancal"] forState:UIControlStateNormal];
//        [cancalB addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
//        cancalB.frame = CGRectMake(self.frame.size.width/2-100, 120, 200, 35);
//        [cancalB setTitle:@"取消" forState:UIControlStateNormal];
//        [blackView addSubview:cancalB];
        
    }
    return self;
}
- (void)showWithShareSucceed:(void (^)())success
{
    self.success = success;
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }];
}
- (id)initWithPetalkId:(NSString *)petalkId nickName:(NSString *)nickName thumbnail:(NSString *)thumbnail content:(NSString *)descriptionContent
{
    self = [super init];
    if (self) {
        self.petalkId = petalkId;
        self.nickName = nickName;
        self.thumbnail = thumbnail;
        self.descriptionContent = descriptionContent;
        
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
        self.backgroundColor = [UIColor clearColor];
        self.frame =CGRectMake(0, window.bounds.size.height, window.bounds.size.width, window.bounds.size.height);
        
        UIView * blackView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-170, self.frame.size.width, 170)];
        blackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        [self addSubview:blackView];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 100, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"分享到:";
        label.textColor = [UIColor colorWithRed:140/255.0 green:140/255.0 blue:140/255.0 alpha:1];
        [blackView addSubview:label];
        
//        weiChatFriendV = [[UIView alloc] initWithFrame:CGRectMake(5, 40, 60, 70)];
//        weiChatFriendV.backgroundColor = [UIColor clearColor];
//        [blackView addSubview:weiChatFriendV];
//        UIButton * weichatB = [UIButton buttonWithType:UIButtonTypeCustom];
//        [weichatB addTarget:self action:@selector(shareToWeichat) forControlEvents:UIControlEventTouchUpInside];
//        [weichatB setBackgroundImage:[UIImage imageNamed:@"weiChatFriend"] forState:UIControlStateNormal];
//        weichatB.frame = CGRectMake(7, 0, 45.5, 45.5);
//        [weiChatFriendV addSubview:weichatB];
//        UILabel * weichatL = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 60, 20)];
//        weichatL.backgroundColor = [UIColor clearColor];
//        weichatL.font = [UIFont systemFontOfSize:13];
//        weichatL.text = @"微信好友";
//        weichatL.textColor = [UIColor colorWithRed:180/255.5 green:180/255.5 blue:180/255.5 alpha:1];
//        weichatL.textAlignment = NSTextAlignmentCenter;
//        [weiChatFriendV addSubview:weichatL];
//        
//        friendCircleV = [[UIView alloc] initWithFrame:CGRectMake(5+(self.frame.size.width-10)/5, 40, 60, 70)];
//        friendCircleV.backgroundColor = [UIColor clearColor];
//        [blackView addSubview:friendCircleV];
//        UIButton * friendCircleB = [UIButton buttonWithType:UIButtonTypeCustom];
//        [friendCircleB addTarget:self action:@selector(shareToFriendCircle) forControlEvents:UIControlEventTouchUpInside];
//        [friendCircleB setBackgroundImage:[UIImage imageNamed:@"friendCircle"] forState:UIControlStateNormal];
//        friendCircleB.frame = CGRectMake(7, 0, 45.5, 45.5);
//        [friendCircleV addSubview:friendCircleB];
//        UILabel * friendCircleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 60, 20)];
//        friendCircleL.backgroundColor = [UIColor clearColor];
//        friendCircleL.font = [UIFont systemFontOfSize:13];
//        friendCircleL.text = @"朋友圈";
//        friendCircleL.textColor = [UIColor colorWithRed:180/255.5 green:180/255.5 blue:180/255.5 alpha:1];
//        friendCircleL.textAlignment = NSTextAlignmentCenter;
//        [friendCircleV addSubview:friendCircleL];
//        
//        sinaV = [[UIView alloc] initWithFrame:CGRectMake(5+(self.frame.size.width-10)*2/5, 40, 60, 70)];
//        sinaV.backgroundColor = [UIColor clearColor];
//        [blackView addSubview:sinaV];
//        UIButton * sinaB = [UIButton buttonWithType:UIButtonTypeCustom];
//        [sinaB addTarget:self action:@selector(shareToSina) forControlEvents:UIControlEventTouchUpInside];
//        [sinaB setBackgroundImage:[UIImage imageNamed:@"sina"] forState:UIControlStateNormal];
//        sinaB.frame = CGRectMake(7, 0, 45.5, 45.5);
//        [sinaV addSubview:sinaB];
//        UILabel * sinaL = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 60, 20)];
//        sinaL.backgroundColor = [UIColor clearColor];
//        sinaL.font = [UIFont systemFontOfSize:13];
//        sinaL.text = @"微博";
//        sinaL.textColor = [UIColor colorWithRed:180/255.5 green:180/255.5 blue:180/255.5 alpha:1];
//        sinaL.textAlignment = NSTextAlignmentCenter;
//        [sinaV addSubview:sinaL];
//        
//        qqV = [[UIView alloc] initWithFrame:CGRectMake(5+(self.frame.size.width-10)*3/5, 40, 60, 70)];
//        qqV.backgroundColor = [UIColor clearColor];
//        [blackView addSubview:qqV];
//        UIButton * qqB = [UIButton buttonWithType:UIButtonTypeCustom];
//        [qqB addTarget:self action:@selector(shareToQQ) forControlEvents:UIControlEventTouchUpInside];
//        [qqB setBackgroundImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
//        qqB.frame = CGRectMake(7, 0, 45.5, 45.5);
//        [qqV addSubview:qqB];
//        UILabel * qqL = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 60, 20)];
//        qqL.backgroundColor = [UIColor clearColor];
//        qqL.font = [UIFont systemFontOfSize:13];
//        qqL.text = @"QQ";
//        qqL.textColor = [UIColor colorWithRed:180/255.5 green:180/255.5 blue:180/255.5 alpha:1];
//        qqL.textAlignment = NSTextAlignmentCenter;
//        [qqV addSubview:qqL];
//        
//        capyV = [[UIView alloc] initWithFrame:CGRectMake(5+(self.frame.size.width-10)*4/5, 40, 60, 70)];
//        capyV.backgroundColor = [UIColor clearColor];
//        [blackView addSubview:capyV];
//        UIButton * capyB = [UIButton buttonWithType:UIButtonTypeCustom];
//        [capyB addTarget:self action:@selector(copyAddress) forControlEvents:UIControlEventTouchUpInside];
//        [capyB setBackgroundImage:[UIImage imageNamed:@"petaking"] forState:UIControlStateNormal];
//        capyB.frame = CGRectMake(7, 0, 45.5, 45.5);
//        [capyV addSubview:capyB];
//        UILabel * capyL = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 60, 20)];
//        capyL.backgroundColor = [UIColor clearColor];
//        capyL.font = [UIFont systemFontOfSize:13];
//        capyL.text = @"宠物说";
//        capyL.textColor = [UIColor colorWithRed:180/255.5 green:180/255.5 blue:180/255.5 alpha:1];
//        capyL.textAlignment = NSTextAlignmentCenter;
//        [capyV addSubview:capyL];
//        
//        cancalB = [UIButton buttonWithType:UIButtonTypeCustom];
//        [cancalB setBackgroundImage:[UIImage imageNamed:@"cancal"] forState:UIControlStateNormal];
//        [cancalB addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
//        cancalB.frame = CGRectMake(self.frame.size.width/2-100, 120, 200, 35);
//        [cancalB setTitle:@"取消" forState:UIControlStateNormal];
//        [blackView addSubview:cancalB];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}
- (void)shareToWeichat
{
    if (_success) {
        [ShareServe shareToWeixiFriendWithTitle:[NSString stringWithFormat:@"【免费试用】%@可以免费领取啦，有钱就任性，有领就敢送。",_trialName] Content:@"宠物说社区，最有趣的宠物社交平台。更有免费试用大奖等你来领！" imageUrl:_trialImg webUrl:[NSString stringWithFormat:GOODSBASEURL,_trialCode] Succeed:^{
            _success();
        }];
    }else
    {
        [ShareServe shareToWeixiFriendWithTitle:[NSString stringWithFormat:@"看%@的动态",_nickName] Content:[NSString stringWithFormat:@"分享自%@的友仔动态:\"%@\"",_nickName,_descriptionContent] imageUrl:_thumbnail webUrl:[NSString stringWithFormat:SHAREBASEURL@"%@",_petalkId] Succeed:^{
            [ShareServe shareNumberUpWithPetalkId:_petalkId];
        }];
    }
    [self dismiss];
}
- (void)shareToFriendCircle
{
    if (_success) {
        [ShareServe shareToFriendCircleWithTitle:[NSString stringWithFormat:@"【免费试用】%@可以免费领取啦，有钱就任性，有领就敢送。",_trialName] Content:@"宠物说社区，最有趣的宠物社交平台。更有免费试用大奖等你来领！" imageUrl:_trialImg webUrl:[NSString stringWithFormat:GOODSBASEURL,_trialCode] Succeed:^{
            _success();
        }];
    }else{
        [ShareServe shareToFriendCircleWithTitle:[NSString stringWithFormat:@"看%@的动态",_nickName] Content:[NSString stringWithFormat:@"分享自%@的友仔动态:\"%@\"",_nickName,_descriptionContent] imageUrl:_thumbnail webUrl:[NSString stringWithFormat:SHAREBASEURL@"%@",_petalkId] Succeed:^{
            [ShareServe shareNumberUpWithPetalkId:_petalkId];
        }];
    }
    [self dismiss];
}
- (void)shareToSina
{
    if (_success) {
        [ShareServe shareToSineWithContent:[NSString stringWithFormat:@"【免费试用】%@可以免费领取啦，有钱就任性，有领就敢送。宠物说社区，最有趣的宠物社交平台。更有免费试用大奖等你来领！%@",_trialName,[NSString stringWithFormat:GOODSBASEURL,_trialCode]] imageUrl:_trialImg Succeed:^{
            _success();
        }];
    }else{
        [ShareServe shareToSineWithContent:[NSString stringWithFormat:@"分享自%@的友仔动态:\"%@\"%@%@",_nickName,_descriptionContent,SHAREBASEURL,_petalkId] imageUrl:_thumbnail Succeed:^{
            [ShareServe shareNumberUpWithPetalkId:_petalkId];
        }];
    }
    [self dismiss];
}
- (void)shareToQQ
{
    if (_success) {
        [ShareServe shareToQQWithTitle:[NSString stringWithFormat:@"【免费试用】%@可以免费领取啦，有钱就任性，有领就敢送。",_trialName] Content:@"宠物说社区，最有趣的宠物社交平台。更有免费试用大奖等你来领！" imageUrl:_trialImg webUrl:[NSString stringWithFormat:GOODSBASEURL,_trialCode] Succeed:^{
            _success();
        }];
    }else{
        [ShareServe shareToQQWithTitle:[NSString stringWithFormat:@"看%@的动态",_nickName] Content:[NSString stringWithFormat:@"分享自%@的友仔动态:\"%@\"",_nickName,_descriptionContent] imageUrl:_thumbnail webUrl:[NSString stringWithFormat:SHAREBASEURL@"%@",_petalkId] Succeed:^{
            [ShareServe shareNumberUpWithPetalkId:_petalkId]; 
        }];
    }
    [self dismiss];
}
- (void)copyAddress
{
    if (_forward) {
        _forward();
    }
    [self dismiss];
}
- (void)showWithForward:(void (^)())forward
{
    self.forward = forward;
    [UIView animateWithDuration:0.3 animations:^{
       self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }];
}
- (void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end