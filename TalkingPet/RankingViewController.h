//
//  RankingViewController.h
//  TalkingPet
//
//  Created by wangxr on 15/3/13.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "BaseViewController.h"
#import "PaiHangShuoShuoTableHelper.h"
@interface RankingViewController : BaseViewController<BrowserTableHelperDelegate>
@property (nonatomic,strong) PaiHangShuoShuoTableHelper * paihangHelper;
@property (nonatomic,strong) UIView * buttonbgV;
@property (nonatomic,strong) UIButton * button1;
@property (nonatomic,strong) UIButton * button2;
@end
