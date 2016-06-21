//
//  UploadTaskTableViewCell.m
//  TalkingPet
//
//  Created by Tolecen on 14-8-1.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "UploadTaskTableViewCell.h"
#import "PublishServer.h"

@interface UploadTaskTableViewCell ()
@property (nonatomic, strong) UIImageView * progressBGV;
@property (nonatomic,strong) UIImageView * progressImageV;
@property (nonatomic,strong) UIActivityIndicatorView * indicatorV;

@property (nonatomic,strong) UILabel * failedLabel;
@property (nonatomic,strong) UIButton * resendBtn;
@property (nonatomic,strong) UIButton * delTaskBtn;
@end
@implementation UploadTaskTableViewCell
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        UIView * bgV = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 310, 55)];
        [bgV setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:bgV];
        
        self.thumbnailImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        self.thumbnailImageV.backgroundColor = [UIColor grayColor];
        [self.thumbnailImageV setImage:[UIImage imageNamed:@"meizi.jpg"]];
        [self.contentView addSubview:self.thumbnailImageV];
        
        self.progressBGV = [[UIImageView alloc] initWithFrame:CGRectMake(60, 25, ScreenWidth-110, 10)];
        [_progressBGV setImage:[UIImage imageNamed:@"jindutiao_bg"]];
        [self.contentView addSubview:_progressBGV];
        
        self.progressImageV = [[UIImageView alloc] initWithFrame:CGRectMake(60, 25, 0, 10)];
        [self.progressImageV setImage:[UIImage imageNamed:@"jindutiao_jindu"]];
        [self.contentView addSubview:self.progressImageV];
        
        self.indicatorV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_indicatorV setFrame:CGRectMake(ScreenWidth-40, 17, 27, 27)];
        [self.contentView addSubview:_indicatorV];
        
        self.rePublishView = [[UIView alloc] init];
        _rePublishView.backgroundColor = [UIColor whiteColor];
        _rePublishView.hidden = YES;
        [self.contentView addSubview:self.rePublishView];
        
        self.failedLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 180, 20)];
        [self.failedLabel setBackgroundColor:[UIColor clearColor]];
        [self.failedLabel setText:@"发布失败"];
        [self.failedLabel setFont:[UIFont systemFontOfSize:16]];
        [self.failedLabel setTextColor:[UIColor redColor]];
        [self.rePublishView addSubview:self.failedLabel];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 180, 20)];
        label.textColor = [UIColor lightGrayColor];
        label.text = @"已保存到草稿箱";
        label.font = [UIFont systemFontOfSize:14];
        [self.rePublishView addSubview:label];
        
        self.resendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.resendBtn setFrame:CGRectMake(ScreenWidth-145, 13, 35, 35)];
        [self.resendBtn setBackgroundImage:[UIImage imageNamed:@"rangd_normal"] forState:UIControlStateNormal];
        [self.rePublishView addSubview:self.resendBtn];
        [self.resendBtn addTarget:self action:@selector(resendFailedTask) forControlEvents:UIControlEventTouchUpInside];
        
        self.delTaskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.delTaskBtn setFrame:CGRectMake(ScreenWidth-100, 13, 35, 35)];
        [self.delTaskBtn setBackgroundImage:[UIImage imageNamed:@"deleteTask_normal"] forState:UIControlStateNormal];
        [self.rePublishView addSubview:self.delTaskBtn];
        [self.delTaskBtn addTarget:self action:@selector(removeThisTask) forControlEvents:UIControlEventTouchUpInside];
        
        UIView * lineV = [[UIView alloc] initWithFrame:CGRectMake(10, 59, ScreenWidth-10, 1)];
        [lineV setBackgroundColor:[UIColor colorWithWhite:230/255.0f alpha:1]];
        [self.contentView addSubview:lineV];
        
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = self.contentView.frame.size;
    _rePublishView.frame = CGRectMake(50, 0, size.width-50, size.height);
}
- (void)startAnimating
{
    [_indicatorV startAnimating];
}
-(void)setPublishID:(NSString *)publishID
{
    if (![_publishID isEqualToString:publishID]) {
        _publishID = publishID;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changProgressSize:) name:publishID object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showRepublishView) name:[NSString stringWithFormat:@"%@PublishFailure",publishID] object:nil];
    }
}
- (void)changProgressSize:(NSNotification*)not
{
    NSDictionary * dic = not.userInfo;
    NSLog(@"==%@",dic[@"written"]);
    double scale = [dic[@"written"] doubleValue];
    [self setProgressSizeWithScale:scale];
}
- (void)setProgressSizeWithScale:(double)scale
{
    CGSize size = _progressBGV.frame.size;
    _progressImageV.frame = CGRectMake(60, 25, size.width*scale, size.height);
}
- (void)showRepublishView
{
    _rePublishView.hidden = NO;
}
-(void)resendFailedTask
{
    [PublishServer rePublishWithPublishID:_publishID];
}

-(void)removeThisTask
{
    [PublishServer cancelPublishWithPublishID:_publishID];
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
