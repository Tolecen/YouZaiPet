//
//  SelectedHotViewVontroller.m
//  TalkingPet
//
//  Created by wangxr on 14/12/1.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "SelectedHotViewVontroller.h"
#import "TalkingBrowse.h"
#import "EGOImageView.h"
#import "TTImageHelper.h"
#import "SVProgressHUD.h"
#import "TFileManager.h"
#import "BrowserForwardedTalkingTableViewCell.h"
#import "XHAudioPlayerHelper.h"
@protocol SelectedHotCellDelegate<NSObject>
@optional
-(void)passThePetalk;
-(void)praiseThePetalk;
-(void)contentImageVClicked:(UITableViewCell *)cell CellType:(int)cellType;
-(void)ImagesLoadedCellIndex:(int)cellIndex;
@end
@interface SelectedHotCell : UITableViewCell<EGOImageButtonDelegate,ImagesLoadedDelegate>
{
    
    
    UIView * layerView;
    UIView * lineView;
    UIButton * passB;
    UIButton * praiseB;
    
    UITapGestureRecognizer * playTap;
}
@property (nonatomic,assign)id <SelectedHotCellDelegate> delegate;
@property (nonatomic,assign) TalkCellType talkCellType;
@property (nonatomic,assign) NSInteger cellIndex;
@property (nonatomic,retain) UIImageView * praiseIV;
@property (nonatomic,retain)EGOImageButton * petalkIV;
@property (nonatomic,retain)UIImageView * mouthIV;
@property (nonatomic,retain)UILabel * descriptionL;
@property (nonatomic,retain)TalkingBrowse * talking;
@property (nonatomic,strong) NSString * currentPlayingUrl;
@property (nonatomic,strong) UIImageView * loadingBGV;
@property (nonatomic,strong) UIImageView * loadingImgV;
@property (nonatomic,strong) UIImageView * playBtnImageV;
@property (nonatomic,strong) UIActivityIndicatorView * loadingV;
//- (void)buttonEnable:(BOOL)enable;
+(float)rowHeightWithTalking:(TalkingBrowse*)talk;
@end
@implementation SelectedHotCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        layerView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, ScreenWidth-10, ScreenWidth+110)];
        layerView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.22];
        layerView.layer.masksToBounds = YES;
        layerView.layer.cornerRadius = 3;
        [self.contentView addSubview:layerView];
        
        self.petalkIV = [[EGOImageButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-10, ScreenWidth-10)];
        _petalkIV.clipsToBounds = YES;
        self.petalkIV.delegate = self;
        self.petalkIV.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        self.petalkIV.adjustsImageWhenHighlighted = NO;
//        self.petalkIV.clipsToBounds = YES;
        [layerView addSubview:_petalkIV];
        [self.petalkIV addTarget:self action:@selector(clickedContentImageV:) forControlEvents:UIControlEventTouchUpInside];
        
        self.praiseIV = [[UIImageView alloc] initWithFrame:_petalkIV.frame];
        _praiseIV.animationImages = @[[UIImage imageNamed:@"praise_1"],[UIImage imageNamed:@"praise_2"],[UIImage imageNamed:@"praise_3"],[UIImage imageNamed:@"praise_4"],[UIImage imageNamed:@"praise_5"],[UIImage imageNamed:@"praise_6"],[UIImage imageNamed:@"praise_7"],[UIImage imageNamed:@"praise_8"]];
        _praiseIV.animationDuration = _praiseIV.animationImages.count * 0.15;
        [layerView addSubview:_praiseIV];
        
        self.mouthIV = [[UIImageView alloc] init];
        [_petalkIV addSubview:_mouthIV];
        
        self.loadingBGV = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-84)/2, (ScreenWidth-84)/2, 84, 84)];
        [self.loadingBGV setImage:[UIImage imageNamed:@"loadingBGV"]];
        [self.petalkIV addSubview:self.loadingBGV];
        self.loadingBGV.hidden = YES;
        
        playTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playButtonTapped)];
        [self.loadingBGV addGestureRecognizer:playTap];
        
        
        //        self.playBtnImageV = [[UIImageView alloc] initWithFrame:CGRectMake(118-5, 118-75, 84, 84)];
        //        [self.playBtnImageV setFrame:self.loadingBGV.frame];
        //        [self.playBtnImageV setImage:[UIImage imageNamed:@"shuoshuoPlayBtn"]];
        //        [self.contentTextBgV addSubview:self.playBtnImageV];
        //        self.playBtnImageV.hidden = YES;
        
        //        NSMutableArray * aniArray = [NSMutableArray array];
        //        for (int i = 0; i<24; i++) {
        //            [aniArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loadingAni%d",i+1]]];
        //        }
        //
        //        self.loadingImgV = [[UIImageView alloc] initWithFrame:CGRectMake(120-5, 120-75, 80, 80)];
        //        [self.loadingImgV setImage:[UIImage imageNamed:@"loadingAni1"]];
        //        [self.contentTextBgV addSubview:self.loadingImgV];
        //        self.loadingImgV.animationImages = aniArray;
        //        self.loadingImgV.animationDuration = 2;
        //        self.loadingImgV.animationRepeatCount = 0;
        //        self.loadingImgV.hidden = YES;
        
        self.loadingV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.loadingV setCenter:CGPointMake(42, 42)];
        [self.loadingBGV addSubview:self.loadingV];
        
        self.descriptionL = [[UILabel alloc] initWithFrame:CGRectMake(5, ScreenWidth-10+5, ScreenWidth-20, 20)];
        _descriptionL.backgroundColor = [UIColor clearColor];
        _descriptionL.textColor = [UIColor whiteColor];
        _descriptionL.font = [UIFont systemFontOfSize:14];
        _descriptionL.numberOfLines = 0;
        [layerView addSubview:_descriptionL];
        
//        lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 340, 310, 1)];
//        lineView.backgroundColor = [UIColor whiteColor];
//        [layerView addSubview:lineView];
        
 
    }
    return self;
}
- (void)imageButtonLoadedImage:(EGOImageButton*)imageButton
{
    self.mouthIV.hidden = NO;
    //    if ([SystemServer sharedSystemServer].autoPlay) {
    //        if (<#condition#>) {
    //            <#statements#>
    //        }
    //    }
    //    NSLog(@"loaded");
    if (_delegate&& [_delegate respondsToSelector:@selector(ImagesLoadedCellIndex:)]){
        [_delegate ImagesLoadedCellIndex:self.cellIndex];
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
//    CGSize size = [_descriptionL.text sizeWithFont:_descriptionL.font constrainedToSize:CGSizeMake(300, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    
//    lineView.frame = CGRectMake(0, 320 + size.height, 310, 1);
//    passB.frame = CGRectMake(50, 320 + size.height, 50, 50);
//    praiseB.frame = CGRectMake(205, 320 + size.height, 50, 50);
    
    if (_descriptionL.text.length>0) {
//        lineView.hidden = NO;
        _descriptionL.frame = CGRectMake(5, ScreenWidth-10+5, ScreenWidth-20, 20);
        layerView .frame = CGRectMake(5, 0, ScreenWidth-10, ScreenWidth + 20);
    }else{
//        lineView.hidden = YES;
        layerView .frame = CGRectMake(5, 0, ScreenWidth-10, ScreenWidth-10);
    }
    [self.petalkIV setImageURL:[NSURL URLWithString:[self.talking.imgUrl stringByAppendingString:@""]]];
    
    if ([TFileManager ifExsitFolder:self.talking.playAnimationImg.fileName]) {
        self.mouthIV.image = [TFileManager getFristImageWithID:self.talking.playAnimationImg.fileName];
        self.mouthIV.hidden = NO;
        self.mouthIV.transform = CGAffineTransformIdentity;
        self.mouthIV.layer.transform = CATransform3DIdentity;
        
        [self.mouthIV setFrame:CGRectMake(0, 0, self.talking.playAnimationImg.width*(ScreenWidth-10), self.talking.playAnimationImg.height*(ScreenWidth-10))];
        self.mouthIV.center = CGPointMake(self.talking.playAnimationImg.centerX*(ScreenWidth-10), self.talking.playAnimationImg.centerY*(ScreenWidth-10));
        self.mouthIV.transform = CGAffineTransformRotate(self.mouthIV.transform, self.talking.playAnimationImg.rotationZ);
        
        
        if ([self.talking.audioUrl isEqualToString:self.currentPlayingUrl]) {
            [self.mouthIV startAnimating];
        }
        /* 3D透视变换
         
         CATransform3D tf = self.mouthIV.layer.transform;
         tf.m34 = 1.0 / -500;
         tf = CATransform3DRotate(tf, self.talking.playAnimationImg.rotationY, 0.0f, 1.0f, 0.0f);
         self.mouthIV.layer.transform = tf;
         self.mouthIV.layer.zPosition = 1000;
         
         */
        
    }
    else
    {
        self.mouthIV.hidden = YES;
    }
    
    [self.loadingBGV setFrame:CGRectMake(self.petalkIV.center.x-42, self.petalkIV.center.x-42, 84, 84)];
    

    self.loadingBGV.hidden = NO;
    [self.loadingBGV setImage:[UIImage imageNamed:@"browser_play"]];
    [self.loadingV stopAnimating];
    if ([self.petalkIV ifExsitUrl:[NSURL URLWithString:[self.talking.imgUrl stringByAppendingString:@""]]]) {
        self.mouthIV.hidden = NO;
        
    }
    else
        self.mouthIV.hidden = YES;

}
-(void)showPlayBtn
{
    
    self.loadingBGV.hidden = NO;
    [self.loadingBGV setImage:[UIImage imageNamed:@"browser_play"]];
    [self.loadingV stopAnimating];
}
-(void)showLoading
{
    //    [self.loadingBGV removeGestureRecognizer:playTap];
    [self.loadingBGV setImage:[UIImage imageNamed:@"loadingBGV"]];
    
    self.loadingBGV.hidden = NO;
    //        [self.loadingImgV setFrame:CGRectMake(self.contentImgV.frame.origin.x+110, self.contentImgV.frame.origin.y+110, 84, 84)];
    if (![self.loadingV isAnimating]) {
        
        [self.loadingV startAnimating];
        
        
    }
}

-(void)hideLoading
{
    self.loadingBGV.hidden = YES;
    //    self.loadingImgV.hidden = YES;
    [self.loadingV stopAnimating];
}

-(void)clickedContentImageV:(EGOImageButton *)sender
{
    if (_delegate&& [_delegate respondsToSelector:@selector(contentImageVClicked:CellType:)]) {
        [_delegate contentImageVClicked:self CellType:2];
    }
}

-(void)playButtonTapped
{
    if ([self.loadingV isAnimating]) {
        return;
    }
    else
    {
        if (_delegate&& [_delegate respondsToSelector:@selector(contentImageVClicked:CellType:)]) {
            [self.loadingBGV setImage:[UIImage imageNamed:@"loadingBGV"]];
            //        self.loadingImgV.hidden = NO;
            //            [self.loadingBGV setFrame:CGRectMake(self.petalkIV.frame.origin.x+108, self.petalkIV.frame.origin.y+108, 84, 84)];
            
            self.loadingBGV.hidden = NO;
            //        [self.loadingImgV setFrame:CGRectMake(self.petalkIV.frame.origin.x+110, self.petalkIV.frame.origin.y+110, 84, 84)];
            if (![self.loadingV isAnimating]) {
                
                [self.loadingV startAnimating];
                
                
            }
            [_delegate contentImageVClicked:self CellType:2];
        }
    }
}
+(float)rowHeightWithTalking:(TalkingBrowse*)talk
{
     CGSize size = [talk.descriptionContent sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    return 310 + size.height;
}
@end
@interface SelectedHotViewVontroller ()<EGOImageViewDelegate,UITableViewDelegate,UITableViewDataSource,SelectedHotCellDelegate,XHAudioPlayerHelperDelegate>
{
    NSString * currentPlayingUrl;
    BOOL clickedBtn;
    
    UIButton * praiseB;
    UIButton * passB;
}
@property (nonatomic,retain)UITableView * tabview;
@property (nonatomic,retain)NSMutableArray * petalkArr;
@property (nonatomic,strong) XHAudioPlayerHelper * audioPlayer;
@property (nonatomic,assign)BOOL iamActive;
@end
@implementation SelectedHotViewVontroller
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"一起选热门";
        self.petalkArr = [NSMutableArray array];
        self.iamActive = YES;
        clickedBtn = NO;
    }
    return self;
}
-(void)dealloc
{
    if (self.audioPlayer) {
        
        [self.audioPlayer stopAudio];
        //        cell.currentPlayingUrl = currentPlayingUrl;
        self.audioPlayer.delegate = nil;
        self.audioPlayer = nil;
    }
    self.iamActive = NO;
    self.audioPlayer.delegate = nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
    [self setBackButtonWithTarget:@selector(backBtnDo:)];
    
    backImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height)];
    [self.view addSubview:backImageV];
    
    self.tabview = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tabview.backgroundColor = [UIColor clearColor];
    _tabview.dataSource = self;
    _tabview.delegate = self;
    _tabview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tabview.scrollEnabled = NO;
    [self.view addSubview:_tabview];
    
    [self buildViewWithSkintype];
    
    [self getSelectedHotPetalk];
    
    passB = [UIButton buttonWithType:UIButtonTypeCustom];
    [passB addTarget:self action:@selector(passAction) forControlEvents:UIControlEventTouchUpInside];
    passB.frame = CGRectMake(self.view.center.x-40-60, self.view.frame.size.height-navigationBarHeight-(self.view.frame.size.height<500?70:100), 60, 60);
    [passB setBackgroundImage:[UIImage imageNamed:@"selected_pass"] forState:UIControlStateNormal];
    [self.view addSubview:passB];
    passB.layer.cornerRadius = 30;
    passB.layer.borderColor = [[UIColor whiteColor] CGColor];
    passB.layer.borderWidth = 1;
    passB.layer.masksToBounds = YES;
    praiseB = [UIButton buttonWithType:UIButtonTypeCustom];
    [praiseB addTarget:self action:@selector(praiseAction) forControlEvents:UIControlEventTouchUpInside];
    praiseB.frame = CGRectMake(self.view.center.x+40, self.view.frame.size.height-navigationBarHeight-(self.view.frame.size.height<500?70:100), 60, 60);
    [praiseB setBackgroundImage:[UIImage imageNamed:@"selected_praise"] forState:UIControlStateNormal];
    [self.view addSubview:praiseB];
    praiseB.layer.cornerRadius = 30;
    praiseB.layer.borderColor = [[UIColor whiteColor] CGColor];
    praiseB.layer.borderWidth = 1;
    praiseB.layer.masksToBounds = YES;
}
- (void)getSelectedHotPetalk
{
    NSMutableDictionary * hotDic = [NetServer commonDict];
    [hotDic setObject:@"fun" forKey:@"command"];
    [hotDic setObject:@"10" forKey:@"pageSize"];
    [hotDic setObject:@"schedule" forKey:@"options"];
    [hotDic setObject:[UserServe sharedUserServe].userID forKey:@"petId"];
    [NetServer requestWithParameters:hotDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray * arr = responseObject[@"value"];
        for (NSDictionary * dic in arr) {
            TalkingBrowse * talking = [[TalkingBrowse alloc] initWithHostInfo:dic];
            [_petalkArr addObject:talking];
        }
        if (_petalkArr.count<=10) {
            [self doAnimations];
            [_tabview reloadData];
            [SVProgressHUD dismiss];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

- (void)buttonEnable:(BOOL)enable
{
    passB.enabled = enable;
    praiseB.enabled = enable;
}

-(void)passAction
{
    [self buttonEnable:NO];
//    if ([_delegate respondsToSelector:@selector(passThePetalk)]) {
        [self passThePetalk];
//    }
}
-(void)praiseAction
{
    [self buttonEnable:NO];
    NSIndexPath * indexPathTo = [NSIndexPath indexPathForRow:0 inSection:0];
    
    SelectedHotCell * cell = (SelectedHotCell *)[self.tabview cellForRowAtIndexPath:indexPathTo];

    [cell.praiseIV startAnimating];
    [self performSelector:@selector(praiseAnimatingFinish) withObject:nil afterDelay:cell.praiseIV.animationDuration];
}
-(void)praiseAnimatingFinish
{
//    if ([_delegate respondsToSelector:@selector(praiseThePetalk)]) {
        [self praiseThePetalk];
//    }
}

-(void)backBtnDo:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SelectedHotCell rowHeightWithTalking:[_petalkArr firstObject]];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *petCellIdentifier = @"selectedHotCell";
    SelectedHotCell *cell = [tableView dequeueReusableCellWithIdentifier:petCellIdentifier ];
    if (cell == nil) {
        cell = [[SelectedHotCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:petCellIdentifier];
        cell.delegate = self;
    
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cellIndex = indexPath.row;
    TalkingBrowse * talking = [_petalkArr firstObject];
    cell.talking = talking;
    cell.descriptionL.text = talking.descriptionContent;
    return cell;
}
-(void)ImagesLoadedCellIndex:(int)cellIndex
{
        NSIndexPath * indexPathTo = [NSIndexPath indexPathForRow:0 inSection:0];

        SelectedHotCell * cell = (SelectedHotCell *)[self.tabview cellForRowAtIndexPath:indexPathTo];
        //            tempCell = [cell copy];
    
    if (cell) {
        dispatch_queue_t queue = dispatch_queue_create("Blur queue", NULL);
        dispatch_async(queue, ^ {
            UIImage * image = [TTImageHelper blurImage:cell.petalkIV.currentImage];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.5 animations:^{
                    backImageV.image = image;
                } completion:^(BOOL finished) {
                    
                }];
                
            });
        });
    }

            if (clickedBtn) {
                [self playOrDownloadForCell:cell PlayBtnClicked:YES];
            }
    
 
    
    
}


-(void)playOrDownloadForCell:(UITableViewCell *)cellTo PlayBtnClicked:(BOOL)playBtnClicked
{
    
    
    NSIndexPath * indexPathTo = [NSIndexPath indexPathForRow:0 inSection:0];
    SelectedHotCell * cell = (SelectedHotCell *)[self.tabview cellForRowAtIndexPath:indexPathTo];
    //            tempCell = [cell copy];
    //    EGOImageButton * cV = cell.petalkIV;
    //    if ([self.audioPlayer isPlaying]) {
    //        [self.audioPlayer stopAudio];
    //    }
    if (![currentPlayingUrl isEqualToString:cell.talking.audioUrl]&&[self.audioPlayer isPlaying]) {
        [self.audioPlayer stopAudio];
    }
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory , NSUserDomainMask, YES) objectAtIndex:0];
    NSString *subdirectory = [documents stringByAppendingPathComponent:@"Audios"];
    
    //                    NSArray * g = [cell.talking.audioUrl componentsSeparatedByString:@"/"];
    NSString *audioPath = [subdirectory stringByAppendingPathComponent:cell.talking.audioName];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    
    
    
    
    
    if ([TFileManager ifExsitFolder:cell.talking.playAnimationImg.fileName]&&[fm fileExistsAtPath:audioPath]) {
        if (![cell.mouthIV isAnimating]) {
            cell.mouthIV.image = [TFileManager getFristImageWithID:cell.talking.playAnimationImg.fileName];
            cell.mouthIV.animationImages = [TFileManager getAllImagesWithID:cell.talking.playAnimationImg.fileName];
            cell.mouthIV.animationDuration = cell.mouthIV.animationImages.count*0.15;
        }
        
        
        if (!playBtnClicked) {
            return;
        }
        if (![cell.petalkIV ifExsitUrl:[NSURL URLWithString:[cell.talking.imgUrl stringByAppendingString:@""]]]) {
            return;
            
        }
        //            if (![cell.petalkIV ifExsitUrl:[NSURL URLWithString:[cell.talking.imgUrl stringByAppendingString:@""]]]) {
        //                return;
        //
        //            }
        [cell hideLoading];
        //            EGOImageButton * cV = cell.petalkIV;
        //            CGRect rect = [self.theView convertRect:cV.frame fromView:cell.contentView];
        //            if (rect.origin.y>(self.naviH==0?120:-10)&&rect.origin.y+rect.size.height<self.theView.frame.size.height-self.naviH) {
        
        if (![cell.mouthIV isAnimating]) {
            [cell.mouthIV startAnimating];
        }
        
        if ([currentPlayingUrl isEqualToString:cell.talking.audioUrl]&&[self.audioPlayer isPlaying]) {
            return;
        }
        else{
            //                            [self.audioPlayer stopAudio];
        }
        currentPlayingUrl = cell.talking.audioUrl;
        cell.currentPlayingUrl = currentPlayingUrl;
        self.audioPlayer = [XHAudioPlayerHelper shareInstance];
        [self.audioPlayer setDelegate:self];
        [self.audioPlayer managerAudioWithFileName:audioPath toPlay:YES];
        //            }
        //                        dispatch_async(dispatch_get_main_queue(), ^{
        
        
        //                        });
        
        
    }
    else
    {
        if (![TFileManager ifExsitFolder:cell.talking.playAnimationImg.fileName]) {
            [NetServer downloadZipFileWithUrl:cell.talking.playAnimationImg.fileUrlStr ZipName:[NSString stringWithFormat:@"%@.%@",cell.talking.playAnimationImg.fileName,cell.talking.playAnimationImg.fileType] Success:^(NSString *zipfileName) {
                if (![[NSString stringWithFormat:@"%@.%@",cell.talking.playAnimationImg.fileName,cell.talking.playAnimationImg.fileType] isEqualToString:zipfileName]) {
                    return;
                }
                cell.mouthIV.image = [TFileManager getFristImageWithID:cell.talking.playAnimationImg.fileName];
                cell.mouthIV.animationImages = [TFileManager getAllImagesWithID:cell.talking.playAnimationImg.fileName];
                cell.mouthIV.animationDuration = cell.mouthIV.animationImages.count*0.15;
                cell.mouthIV.transform = CGAffineTransformIdentity;
                cell.mouthIV.layer.transform = CATransform3DIdentity;
                
                [cell.mouthIV setFrame:CGRectMake(0, 0, cell.talking.playAnimationImg.width*(ScreenWidth-10), cell.talking.playAnimationImg.height*(ScreenWidth-10))];
                cell.mouthIV.center = CGPointMake(cell.talking.playAnimationImg.centerX*(ScreenWidth-10), cell.talking.playAnimationImg.centerY*(ScreenWidth-10));
                cell.mouthIV.transform = CGAffineTransformRotate(cell.mouthIV.transform, cell.talking.playAnimationImg.rotationZ);
                if([fm fileExistsAtPath:audioPath]){
                    
                    if (!playBtnClicked) {
                        NSLog(@"returned111");
                        return;
                    }
                    if (![cell.petalkIV ifExsitUrl:[NSURL URLWithString:[cell.talking.imgUrl stringByAppendingString:@""]]]) {
                        NSLog(@"returned111222");
                        return;
                        
                    }
                    
                    [cell hideLoading];
                    if ([currentPlayingUrl isEqualToString:cell.talking.audioUrl]&&[self.audioPlayer isPlaying]) {
                        NSLog(@"returned111333");
                        return;
                    }
                    else{
                        //                                        [self.audioPlayer stopAudio];
                    }
                    
                    //                        EGOImageButton * cV = cell.petalkIV;
                    //                        CGRect rect = [self.theView convertRect:cV.frame fromView:cell.contentView];
                    //                        if (rect.origin.y>(self.naviH==0?120:-10)&&rect.origin.y+rect.size.height<self.theView.frame.size.height-self.naviH) {
                    currentPlayingUrl = cell.talking.audioUrl;
                    cell.currentPlayingUrl = currentPlayingUrl;
                    self.audioPlayer = [XHAudioPlayerHelper shareInstance];
                    [self.audioPlayer setDelegate:self];
                    [self.audioPlayer managerAudioWithFileName:audioPath toPlay:YES];
                    
                    //                                    dispatch_async(dispatch_get_main_queue(), ^{
                    if (![cell.mouthIV isAnimating]) {
                        [cell.mouthIV startAnimating];
                        
                    }
                    //                        }
                    
                    //                                    });
                }
                
            } failure:^(NSError *error) {
                
            }];
            
        }
        
        if (!playBtnClicked) {
//            NSLog(@"returned222");
            return;
        }
        
        if(![fm fileExistsAtPath:audioPath]){
            currentPlayingUrl = cell.talking.audioUrl;
            [self getAudioFromNet:cell.talking.audioUrl LocalPath:audioPath Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                
                
                if ([responseObject writeToFile:audioPath atomically:YES]) {
                    if (![TFileManager ifExsitFolder:cell.talking.playAnimationImg.fileName])
                    {
                        NSLog(@"returned333");
                        return;
                    }
                    if (![cell.petalkIV ifExsitUrl:[NSURL URLWithString:[cell.talking.imgUrl stringByAppendingString:@""]]]) {
                        NSLog(@"returned333111");
                        return;
                        
                    }
                    [cell hideLoading];
                    if ([cell.talking.audioUrl isEqualToString:currentPlayingUrl]) {
                        if ([currentPlayingUrl isEqualToString:cell.talking.audioUrl]&&[self.audioPlayer isPlaying]) {
                            return;
                        }
                        else{
                            //                                            [self.audioPlayer stopAudio];
                        }
                        if (![cell.petalkIV ifExsitUrl:[NSURL URLWithString:[cell.talking.imgUrl stringByAppendingString:@""]]]) {
                            NSLog(@"returned333222");
                            return;
                            
                        }
                        //                            EGOImageButton * cV = cell.petalkIV;
                        //                            CGRect rect = [self.theView convertRect:cV.frame fromView:cell.contentView];
                        //                            if (rect.origin.y>(self.naviH==0?120:-10)&&rect.origin.y+rect.size.height<self.theView.frame.size.height-self.naviH) {
                        currentPlayingUrl = cell.talking.audioUrl;
                        cell.currentPlayingUrl = currentPlayingUrl;
                        self.audioPlayer = [XHAudioPlayerHelper shareInstance];
                        [self.audioPlayer setDelegate:self];
                        [self.audioPlayer managerAudioWithFileName:audioPath toPlay:YES];
                        //                                        dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (![cell.mouthIV isAnimating]) {
                            cell.mouthIV.image = [TFileManager getFristImageWithID:cell.talking.playAnimationImg.fileName];
                            cell.mouthIV.animationImages = [TFileManager getAllImagesWithID:cell.talking.playAnimationImg.fileName];
                            cell.mouthIV.animationDuration = cell.mouthIV.animationImages.count*0.15;
                            cell.mouthIV.transform = CGAffineTransformIdentity;
                            cell.mouthIV.layer.transform = CATransform3DIdentity;
                            
                            [cell.mouthIV setFrame:CGRectMake(0, 0, cell.talking.playAnimationImg.width*(ScreenWidth-10), cell.talking.playAnimationImg.height*(ScreenWidth-10))];
                            cell.mouthIV.center = CGPointMake(cell.talking.playAnimationImg.centerX*(ScreenWidth-10), cell.talking.playAnimationImg.centerY*(ScreenWidth-10));
                            cell.mouthIV.transform = CGAffineTransformRotate(cell.mouthIV.transform, cell.talking.playAnimationImg.rotationZ);
                            [cell.mouthIV startAnimating];
                        }
                        //                            }
                        
                        //                                        });
                    }
                    
                }
                else
                {
                    NSLog(@"%@ write failed",audioPath);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
        }
    }
    
    //                });
    
    
}
-(void)getAudioFromNet:(NSString *)audioURL LocalPath:(NSString *)localPath Success:(void (^)(AFHTTPRequestOperation *operation,  id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    [NetServer downloadAudioFileWithURL:audioURL TheController:nil Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSString  *localRecordPath = [NSString stringWithFormat:@"%@/%@.caf",rootRecordPath,audioID];
        //        NSData *  wavData = DecodeAMRToWAVE(responseObject);
        
        if (!self.iamActive) {
            return;
        }
        success(operation,responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
}
-(void)contentImageVClicked:(UITableViewCell *)cell CellType:(int)cellType
{
    NSIndexPath * indexPathTo = [NSIndexPath indexPathForRow:0 inSection:0];
    SelectedHotCell * cells = (SelectedHotCell *)[self.tabview cellForRowAtIndexPath:indexPathTo];
    
    if ([cells.mouthIV isAnimating]) {
        clickedBtn = NO;
        [cells.mouthIV stopAnimating];
        [cells showPlayBtn];
    }
    if ([self.audioPlayer isPlaying]) {
        clickedBtn = NO;
        [self.audioPlayer stopAudio];
        cells.currentPlayingUrl = @"";
        [cells showPlayBtn];
    }
    else
    {
        /******源代码，注释于2014-11-14
         NSString *documents = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory , NSUserDomainMask, YES) objectAtIndex:0];
         NSArray * g = [cells.talking.audioUrl componentsSeparatedByString:@"/"];
         NSString *accessorys2 = [[documents stringByAppendingPathComponent:@"Audios"] stringByAppendingPathComponent:[g lastObject]];
         if ([self.audioPlayer isPlaying]) {
         [self.audioPlayer stopAudio];
         }
         self.audioPlayer = [XHAudioPlayerHelper shareInstance];
         [self.audioPlayer setDelegate:self];
         [self.audioPlayer managerAudioWithFileName:accessorys2 toPlay:YES];
         //            [cells.mouthIV startAnimating];
         
         if (![cells.mouthIV isAnimating]) {
         cells.mouthIV.image = [TFileManager getFristImageWithID:cells.talking.playAnimationImg.fileName];
         cells.mouthIV.animationImages = [TFileManager getAllImagesWithID:cells.talking.playAnimationImg.fileName];
         cells.mouthIV.animationDuration = cells.mouthIV.animationImages.count*0.15;
         [cells.mouthIV startAnimating];
         }
         ******/
        clickedBtn = YES;
        [cells showLoading];
        [self playOrDownloadForCell:cells PlayBtnClicked:YES];
        
    }
    
    
    
}
-(void)didAudioPlayerStopPlay:(AVAudioPlayer *)audioPlayer
{

        NSIndexPath * indexPathTo = [NSIndexPath indexPathForRow:0 inSection:0];
        SelectedHotCell * cell = (SelectedHotCell *)[self.tabview cellForRowAtIndexPath:indexPathTo];
        //        if ([currentPlayingUrl isEqualToString:cell.talking.audioUrl]) {
        [cell.mouthIV stopAnimating];
        cell.currentPlayingUrl = @"";
    clickedBtn = NO;
        [cell showPlayBtn];
        //        }
        
 
}
-(void)passThePetalk
{
    TalkingBrowse * talking = [_petalkArr firstObject];
    if (!talking.theID) {
        return;
    }
    [self guodu];
    NSMutableDictionary * hotDic = [NetServer commonDict];
    [hotDic setObject:@"fun" forKey:@"command"];
    [hotDic setObject:talking.theID forKey:@"petalkId"];
    [hotDic setObject:@"0" forKey:@"code"];
    [hotDic setObject:@"choice" forKey:@"options"];
    [hotDic setObject:[UserServe sharedUserServe].userID forKey:@"petId"];
    [NetServer requestWithParameters:hotDic success:nil failure:nil];
}
-(void)praiseThePetalk
{
    TalkingBrowse * talking = [_petalkArr firstObject];
    if (!talking.theID) {
        return;
    }
    [self guodu];
    NSMutableDictionary * hotDic = [NetServer commonDict];
    [hotDic setObject:@"fun" forKey:@"command"];
    [hotDic setObject:talking.theID forKey:@"petalkId"];
    [hotDic setObject:@"1" forKey:@"code"];
    [hotDic setObject:@"choice" forKey:@"options"];
    [hotDic setObject:[UserServe sharedUserServe].userID forKey:@"petId"];
    [NetServer requestWithParameters:hotDic success:nil failure:nil];
}
- (void)guodu
{
    if (_petalkArr.count>0) {
        clickedBtn = NO;
        [self.audioPlayer stopAudio];
        [self doAnimations];
        [_petalkArr removeObjectAtIndex:0];
        [_tabview reloadData];
    }else{
        [SVProgressHUD showWithStatus:@"正在加载,请稍后"];
    }
    if (_petalkArr.count == 1) {
        [self getSelectedHotPetalk];
    }
}
- (void)doAnimations
{
    [UIView beginAnimations:@"animationID" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:_tabview cache:YES];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationFinash)];
    [_tabview exchangeSubviewAtIndex:1 withSubviewAtIndex:0];
    [UIView commitAnimations];
}
- (void)animationFinash
{
//     SelectedHotCell * cell = (SelectedHotCell *)[self.tabview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [self buttonEnable:YES];
}
@end
