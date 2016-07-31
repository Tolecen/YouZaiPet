//
//  YZDogDetalMiddleView.m
//  TalkingPet
//
//  Created by Tolecen on 16/7/31.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZDogDetalMiddleView.h"
#import "YZQuanSheDetailIntroCell.h"
@interface YZDogDetalMiddleView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UIButton * aboutDogBtn;
@property (nonatomic,strong)UIButton * mfBtn;
@property (nonatomic,strong)UIButton * aboutQuansheBtn;
@property (nonatomic,strong)UIView * lineV;
@property (nonatomic,strong)UILabel * introL;
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)UILabel * quansheIntroL;

@end
@implementation YZDogDetalMiddleView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView * tv = [[UIView alloc] initWithFrame:CGRectZero];
        
        tv.backgroundColor = [UIColor colorWithRed:.9
                                                         green:.9
                                                          blue:.9
                                                         alpha:1.f];
        [self addSubview:tv];
        
        self.aboutDogBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.aboutDogBtn.backgroundColor = [UIColor whiteColor];
        self.aboutDogBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.aboutDogBtn setTitle:@"关于狗狗" forState:UIControlStateNormal];
        [self.aboutDogBtn setTitleColor:CommonGreenColor forState:UIControlStateNormal];
        [self addSubview:self.aboutDogBtn];
        self.aboutDogBtn.tag = 1;
        [self.aboutDogBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        self.mfBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.mfBtn.backgroundColor = [UIColor whiteColor];
        self.mfBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.mfBtn setTitle:@"狗狗父母" forState:UIControlStateNormal];
        [self.mfBtn setTitleColor:[UIColor colorWithR:150 g:150 b:150 alpha:1] forState:UIControlStateNormal];
        [self addSubview:self.mfBtn];
        self.mfBtn.tag = 2;
        [self.mfBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        self.aboutQuansheBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.aboutQuansheBtn.backgroundColor = [UIColor whiteColor];
        self.aboutQuansheBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.aboutQuansheBtn setTitle:@"犬舍信息" forState:UIControlStateNormal];
        [self.aboutQuansheBtn setTitleColor:[UIColor colorWithR:150 g:150 b:150 alpha:1] forState:UIControlStateNormal];
        [self addSubview:self.aboutQuansheBtn];
        self.aboutQuansheBtn.tag = 3;
        [self.aboutQuansheBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView * lc = [[UIView alloc] initWithFrame:CGRectZero];
        lc.backgroundColor = [UIColor colorWithR:240 g:240 b:240 alpha:1];
        [self addSubview:lc];
        
        self.lineV = [[UIView alloc] initWithFrame:CGRectZero];
        self.lineV.backgroundColor = CommonGreenColor;
        [self addSubview:self.lineV];
        
        
        
        [tv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(10);
            make.width.mas_equalTo(ScreenWidth);
        }];
        
        [self.aboutDogBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self);
            make.top.mas_equalTo(10);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(ScreenWidth/3);
        }];
        
        [self.mfBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.aboutDogBtn.mas_right);
            make.top.mas_equalTo(10);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(ScreenWidth/3);
        }];
        
        [self.aboutQuansheBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mfBtn.mas_right);
            make.top.mas_equalTo(10);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(ScreenWidth/3);
        }];
        
        [self.lineV mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo((ScreenWidth/3)*2);
//            make.top.mas_equalTo(0);
            make.height.mas_equalTo(2);
            make.width.mas_equalTo(ScreenWidth/3-20);
            make.top.mas_equalTo(48);
            make.left.mas_equalTo((ScreenWidth/3)/2-(ScreenWidth/3-20)/2);
        }];
        
        [lc mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.left.mas_equalTo((ScreenWidth/3)*2);
            //            make.top.mas_equalTo(0);
            make.height.mas_equalTo(1);
            make.width.mas_equalTo(ScreenWidth);
            make.top.mas_equalTo(49);
            make.left.mas_equalTo(0);
        }];
        
        
        self.introL = [[UILabel alloc] initWithFrame:CGRectZero];
        self.introL.backgroundColor = [UIColor clearColor];
        self.introL.font = [UIFont systemFontOfSize:12];
        self.introL.textColor = [UIColor lightGrayColor];
        self.introL.numberOfLines = 0;
        self.introL.lineBreakMode = NSLineBreakByClipping;
        [self addSubview:self.introL];
        
        [self.introL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(130);
            make.width.mas_equalTo(ScreenWidth-20);
            make.top.mas_equalTo(self.aboutDogBtn.mas_bottom).mas_offset(10);
            make.left.mas_equalTo(10);
        }];
        
        UITableView *tableView = [[UITableView alloc] init];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 100;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[YZQuanSheDetailIntroCell class] forCellReuseIdentifier:NSStringFromClass([YZQuanSheDetailIntroCell class])];
        [self addSubview:tableView];
        self.tableView = tableView;
        _tableView.hidden = YES;
        
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(150);
            make.width.mas_equalTo(ScreenWidth);
            make.top.mas_equalTo(self.aboutDogBtn.mas_bottom).mas_offset(0);
            make.left.mas_equalTo(0);
        }];

    }
    return self;
}

-(void)btnClicked:(UIButton *)sender
{
    [self.lineV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo((ScreenWidth/3)*(sender.tag-1)+((ScreenWidth/3)/2-(ScreenWidth/3-20)/2));
    }];
    if (sender.tag==1) {
        [self.aboutDogBtn setTitleColor:CommonGreenColor forState:UIControlStateNormal];
        [self.aboutQuansheBtn setTitleColor:[UIColor colorWithR:150 g:150 b:150 alpha:1] forState:UIControlStateNormal];
        [self.mfBtn setTitleColor:[UIColor colorWithR:150 g:150 b:150 alpha:1] forState:UIControlStateNormal];
        
        self.introL.text = [self filterHTML:self.detailModel.content];
        self.introL.hidden = NO;
        _tableView.hidden = YES;
    }
    else if(sender.tag==2){
        [self.mfBtn setTitleColor:CommonGreenColor forState:UIControlStateNormal];
        [self.aboutQuansheBtn setTitleColor:[UIColor colorWithR:150 g:150 b:150 alpha:1] forState:UIControlStateNormal];
        [self.aboutDogBtn setTitleColor:[UIColor colorWithR:150 g:150 b:150 alpha:1] forState:UIControlStateNormal];
        
        self.introL.hidden = YES;
        _tableView.hidden = NO;
    }
    else if (sender.tag==3){
        [self.aboutQuansheBtn setTitleColor:CommonGreenColor forState:UIControlStateNormal];
        [self.aboutDogBtn setTitleColor:[UIColor colorWithR:150 g:150 b:150 alpha:1] forState:UIControlStateNormal];
        [self.mfBtn setTitleColor:[UIColor colorWithR:150 g:150 b:150 alpha:1] forState:UIControlStateNormal];
        
        self.introL.text = [self filterHTML:self.detailModel.shop.dogIntro];
        
        self.introL.hidden = NO;
        _tableView.hidden = YES;
    }
    
    [self setNeedsUpdateConstraints];
}

-(void)setDetailModel:(YZDogDetailModel *)dogModel
{
    _detailModel = dogModel;
    self.introL.text = [self filterHTML:dogModel.content];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YZQuanSheDetailIntroCell *introCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YZQuanSheDetailIntroCell class])];
    introCell.parents = indexPath.row==0 ? self.detailModel.father : self.detailModel.mother;
    return introCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 2;
}

-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
//    while([scanner isAtEnd]==NO)
//    {
//        //找到标签的起始位置
//        [scanner scanUpToString:@"<" intoString:nil];
//        //找到标签的结束位置
//        [scanner scanUpToString:@">" intoString:&text];
//        //替换字符
//        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
//    }
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"&lt;" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@"gt;" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@gt;",text] withString:@""];
    }
//    NSString * regEx = @"&lt;([^>]*)gt;";
//    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}
@end
