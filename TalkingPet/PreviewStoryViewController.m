//
//  PreviewStoryViewController.m
//  TalkingPet
//
//  Created by wangxr on 15/7/13.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "PreviewStoryViewController.h"
#import "StoryPublish.h"
#import "StoryCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "EGOImageView.h"
#import <AVFoundation/AVFoundation.h>
#import "TFileManager.h"
#import "SVProgressHUD.h"
#if TARGET_OS_IPHONE
#import "amrFileCodec.h"
#endif

@interface EGOStoryCell :UICollectionViewCell<AVAudioPlayerDelegate>
{
    UIImageView * imageV;
    UIImageView * playView;
    UIActivityIndicatorView * activity;
    EGOImageView * subIV;
    UIImageView * textBG;
    UIImageView * audio;
    UILabel * contentL;
    UILabel * subL;
}
@end
@implementation EGOStoryCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        imageV = [[UIImageView alloc]initWithFrame:self.bounds];
        imageV.contentMode = UIViewContentModeScaleAspectFill;
        imageV.clipsToBounds = YES;
        [self.contentView addSubview:imageV];
        subIV = [[EGOImageView alloc]init];
        subIV.hidden = YES;
        [self.contentView addSubview:subIV];
        textBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height-20, frame.size.width, 20)];
        textBG.image = [UIImage imageNamed:@"story_img_text"];
        textBG.hidden = YES;
        [self.contentView addSubview:textBG];
        audio = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        audio.image = [UIImage imageNamed:@"story_img_audio"];
        audio.hidden = YES;
        audio.animationImages = @[[UIImage imageNamed:@"story_audio_play1"],[UIImage imageNamed:@"story_audio_play2"],[UIImage imageNamed:@"story_audio_play3"]];
        audio.animationDuration = 0.5;
        [self.contentView addSubview:audio];
        activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [self.contentView addSubview:activity];
        contentL = [[UILabel alloc] initWithFrame:textBG.frame];
        contentL.font = [UIFont systemFontOfSize:12];
        contentL.numberOfLines = 0;
        contentL.hidden = YES;
        [self.contentView addSubview:contentL];
        subL = [[UILabel alloc] init];
        subL.font = [UIFont systemFontOfSize:12];
        subL.hidden = YES;
        [self.contentView addSubview:subL];
    }
    return self;
}
-(void)beginLoad
{
    audio.hidden = YES;
    [activity startAnimating];
}
-(void)loadfinish
{
    audio.hidden = NO;
    [activity stopAnimating];
}
-(void)playAudio
{
    [audio startAnimating];
}
-(void)stop
{
    [audio stopAnimating];
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self stop];
}
-(void)layoutWithTitle:(NSString*)title time:(NSString*)time coverURL:(NSString*)url
{
    [audio stopAnimating];
    subIV.hidden = NO;
    imageV.image = [UIImage imageNamed:@"story_preview_cover"];
    subIV.imageURL = [NSURL URLWithString:url];
    float width = self.bounds.size.width;
    subIV.frame = CGRectMake(width*40/640, width*224/640, width*560/640, width*320/640);
    audio.hidden = YES;
    textBG.hidden = YES;
    contentL.hidden = NO;
    contentL.text = title;
    contentL.textAlignment = NSTextAlignmentLeft;
    contentL.frame = textBG.frame;
    contentL.font = [UIFont systemFontOfSize:16];
    subL.hidden = NO;
    subL.text = time;
    subL.font = [UIFont systemFontOfSize:12];
    imageV.frame=self.bounds;
    textBG.frame=CGRectMake(0, self.bounds.size.height-20, self.bounds.size.width, 20);
    contentL.frame = CGRectMake(width*40/640, width*116/640, width*560/640, 20);;
    subL.frame = CGRectMake(width*40/640, width*164/640, width*560/640, 20);
    contentL.textColor = [UIColor orangeColor];
    subL.textColor = [UIColor orangeColor];
}
-(void)layoutWithImageURL:(NSString*)url text:(NSString*)text haveAudio:(BOOL)avdio
{
    [audio stopAnimating];
    subIV.hidden = NO;
    imageV.image = nil;
    subIV.imageURL = [NSURL URLWithString:url];
    audio.hidden = !avdio;
    textBG.hidden = !text.length;
    imageV.frame=self.bounds;
    subIV.frame =self.bounds;
    contentL.hidden = !text.length;
    contentL.text = text;
    contentL.textAlignment = NSTextAlignmentLeft;
    subL.hidden = YES;
    imageV.frame=self.bounds;
    contentL.font = [UIFont systemFontOfSize:16];
    CGSize size = [text sizeWithFont:contentL.font constrainedToSize:CGRectInset(self.bounds, 5, 5).size lineBreakMode:NSLineBreakByWordWrapping];
    textBG.frame=CGRectMake(0, self.bounds.size.height-size.height-5, self.bounds.size.width, size.height+5);
    contentL.frame=CGRectInset(textBG.frame, 5, 0);
    audio.frame = CGRectMake(0, 0, 50, 50);
    contentL.textColor = [UIColor whiteColor];
    subL.textColor = [UIColor whiteColor];
}
-(void)layoutWithText:(NSString*)text
{
    [audio stopAnimating];
    imageV.image = [UIImage imageNamed:@"story_text_bg"];
    subIV.hidden = YES;
    audio.hidden = YES;
    textBG.hidden = YES;
    contentL.hidden = NO;
    contentL.text = text;
    contentL.frame = self.bounds;
    subL.hidden = YES;
    imageV.frame=self.bounds;
    textBG.frame=CGRectMake(0, self.bounds.size.height-20, self.bounds.size.width, 20);
    contentL.frame= CGRectInset(self.bounds, self.bounds.size.width*15/100, self.bounds.size.height*15/100);
    contentL.textAlignment = NSTextAlignmentLeft;
    contentL.font = [UIFont systemFontOfSize:12];
    contentL.textColor = [UIColor colorWithWhite:128/255.0 alpha:1];
    subL.textColor = [UIColor colorWithWhite:128/255.0 alpha:1];
}
-(void)layoutWithAddress:(NSString*)address time:(NSString*)time
{
    [audio stopAnimating];
    imageV.image = [UIImage imageNamed:@"story_a&t_bg"];
    subIV.hidden = YES;
    audio.hidden = YES;
    textBG.hidden = YES;
    contentL.hidden = NO;
    contentL.text = address;
    contentL.textAlignment = NSTextAlignmentRight;
    subL.hidden = NO;
    subL.text = time;
    imageV.frame=self.bounds;
    textBG.frame=CGRectMake(0, self.bounds.size.height-20, self.bounds.size.width, 20);
    contentL.font = [UIFont systemFontOfSize:16];
    subL.font = [UIFont systemFontOfSize:22];
    CGSize size = [address sizeWithFont:contentL.font constrainedToSize:CGSizeMake(self.bounds.size.width*8/10, 60) lineBreakMode:NSLineBreakByWordWrapping];
    contentL.frame=CGRectMake(self.bounds.size.width/10, self.bounds.size.height*8/10-size.height, self.bounds.size.width*8/10, size.height);;
    subL.frame = CGRectMake(self.bounds.size.width/10, self.bounds.size.height*3/10, self.bounds.size.width*9/10, 24);
    contentL.textColor = [UIColor orangeColor];
    subL.textColor = [UIColor orangeColor];
}
-(void)layoutBackCover
{
    [audio stopAnimating];
    imageV.image = [UIImage imageNamed:@"story_preview_backCover"];
    imageV.frame=self.bounds;
    subIV.hidden = YES;
    subIV.hidden = YES;
    audio.hidden = YES;
    textBG.hidden = YES;
    contentL.hidden = YES;
    subL.hidden = YES;
}
@end

@interface PreviewStoryViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    int previewType;
    UICollectionView * previewView;
}
@property (nonatomic,retain) AVAudioPlayer * audioPalyer;
@property (nonatomic,retain) NSMutableArray * sourceArr;
@end
@implementation PreviewStoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setBackButtonWithTarget:@selector(goBack)];
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:bg];
    bg.image = [UIImage imageNamed:@"story_preview_bg"];
    
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    previewView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.width-20) collectionViewLayout:layout];
    previewView.backgroundColor = [UIColor clearColor];
    previewView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
    previewView.delegate = self;
    previewView.dataSource = self;
    [self.view addSubview:previewView];
    previewView.showsHorizontalScrollIndicator = NO;
    [previewView registerClass:[StoryCell class] forCellWithReuseIdentifier:@"previewStoryCell"];
    [previewView registerClass:[EGOStoryCell class] forCellWithReuseIdentifier:@"EGOStoryCell"];
}
-(void)loadPreviewStoryViewWithStory:(StoryPublish*)story
{
    previewType = 1;
    self.title = @"预览";
    self.sourceArr = [NSMutableArray arrayWithArray:story.storyItems];
    if (story.cover) {
        NSDate* date = [NSDate date];
        NSDateFormatter * dateF= [[NSDateFormatter alloc]init];
        dateF.dateFormat = @"yyyy.MM.dd";
        [_sourceArr insertObject:@{@"type":@"cover",@"cover":story.cover,@"title":story.title,@"time":[dateF stringFromDate:date]} atIndex:0];
    }else
    {
        [_sourceArr insertObject:@{@"type":@"cover"} atIndex:0];       
    }
    [_sourceArr addObject:@{@"type":@"end"}];
}
-(void)loadPreviewStoryViewWithDictionary:(TalkingBrowse*)dic
{
    previewType = 2;
    self.title = dic.descriptionContent;
    self.sourceArr = [NSMutableArray arrayWithArray:dic.storyDict];
}
- (void)goBack
{
    if (self.navigationController.viewControllers.count>1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else
        [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _sourceArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (previewType == 1) {
        static NSString *SectionCellIdentifier = @"previewStoryCell";
        StoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SectionCellIdentifier forIndexPath:indexPath];
        NSDictionary * dic = _sourceArr[indexPath.row];
        if ([dic[@"type"] isEqualToString:@"cover"]) {
            [cell layoutWithTitle:dic[@"title"] time:dic[@"time"] cover:dic[@"cover"]];
        }
        if ([dic[@"type"] isEqualToString:@"img"]) {
            [cell layoutWithImage:dic[@"img"] text:dic[@"text"] lineFeed:YES haveAudio:dic[@"sound"]];
        }
        if ([dic[@"type"] isEqualToString:@"set"]) {
            [cell layoutWithImage:[UIImage imageWithCGImage:((ALAsset*)dic[@"set"]).aspectRatioThumbnail] text:dic[@"text"] lineFeed:YES haveAudio:dic[@"sound"]];
        }
        if ([dic[@"type"] isEqualToString:@"text"]) {
            [cell layoutWithText:dic[@"text"]];
        }
        if ([dic[@"type"] isEqualToString:@"t&a"]) {
            [cell layoutWithAddress:dic[@"address"] lineFeed:YES time:dic[@"time"]];
        }
        if ([dic[@"type"] isEqualToString:@"end"]) {
            [cell layoutBackCover];
        }
        return cell;
    }
    if (previewType == 2) {
        static NSString *cellIdentifier = @"EGOStoryCell";
        EGOStoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        NSDictionary * dic = _sourceArr[indexPath.row];
        if ([dic[@"type"] intValue] == 1) {
            [cell layoutWithTitle:dic[@"typeVals"][1] time:dic[@"typeVals"][2] coverURL:dic[@"typeVals"][0]];
        }
        if ([dic[@"type"] intValue] == 2) {
            [cell layoutWithImageURL:dic[@"typeVals"][0] text:dic[@"typeVals"][2] haveAudio:((NSString*)dic[@"typeVals"][3]).length];
        }
        if ([dic[@"type"] intValue] == 3) {
            [cell layoutWithText:dic[@"typeVals"][0]];
        }
        if ([dic[@"type"] intValue] == 4) {
            [cell layoutWithAddress:dic[@"typeVals"][0] time:dic[@"typeVals"][1]];
        }
        if ([dic[@"type"] intValue] == 5) {
            [cell layoutBackCover];
        }
        return cell;
    }
    return nil;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float height = collectionView.frame.size.height;
    CGSize size;
    if (previewType == 1) {
        NSDictionary * dic = _sourceArr[indexPath.row];
        if ([dic[@"type"] isEqualToString:@"cover"]) {
            size = CGSizeMake(height, height);
        }
        if ([dic[@"type"] isEqualToString:@"img"]) {
            UIImage * image = dic[@"img"];
            size = CGSizeMake(height*image.size.width/image.size.height, height);
        }
        if ([dic[@"type"] isEqualToString:@"set"]) {
            UIImage * image = [UIImage imageWithCGImage:((ALAsset*)dic[@"set"]).aspectRatioThumbnail];
            size = CGSizeMake(height*image.size.width/image.size.height, height);
        }
        if ([dic[@"type"] isEqualToString:@"text"]) {
            size = CGSizeMake(height, height);
        }
        if ([dic[@"type"] isEqualToString:@"t&a"]) {
            size = CGSizeMake(height, height);
        }
        if ([dic[@"type"] isEqualToString:@"end"]) {
            size = CGSizeMake(height, height);
        }
    }
    if (previewType == 2) {
        NSDictionary * dic = _sourceArr[indexPath.row];
        if ([dic[@"type"] intValue] == 1) {
            size = CGSizeMake(height, height);
        }
        if ([dic[@"type"] intValue] == 2) {
            float sc = [dic[@"typeVals"][1] floatValue];
            size = CGSizeMake(sc*height, height);
        }
        if ([dic[@"type"] intValue] == 3) {
            size = CGSizeMake(height, height);
        }
        if ([dic[@"type"] intValue] == 4) {
            size = CGSizeMake(height, height);
        }
        if ([dic[@"type"] intValue] == 5) {
            size = CGSizeMake(height, height);
        }
    }
    return size;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = _sourceArr[indexPath.row];
    if (previewType == 1) {
        if (([dic[@"type"] isEqualToString:@"img"]||[dic[@"type"] isEqualToString:@"set"])&&dic[@"sound"]) {
            NSError * error;
            [_audioPalyer stop];
            self.audioPalyer = [[AVAudioPlayer alloc] initWithData:dic[@"sound"] error:&error];
            [_audioPalyer prepareToPlay];
            [_audioPalyer play];
        }
    }
    if (previewType == 2) {
        if ([dic[@"type"] intValue] == 2 && ((NSString*)dic[@"typeVals"][3]).length) {
            [_audioPalyer stop];
            NSString * audioFileName = [[dic[@"typeVals"][3] componentsSeparatedByString:@"/"] lastObject];
            if ([audioFileName hasSuffix:@".amr"]) {
                NSMutableString * str = [NSMutableString stringWithString:audioFileName];
                [str replaceCharactersInRange:NSMakeRange(str.length-4, 4) withString:@".wav"];
                audioFileName = str;
            }
            NSString *documents = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory , NSUserDomainMask, YES) objectAtIndex:0];
            NSString *subdirectory = [documents stringByAppendingPathComponent:@"Audios"];
            NSString *localAudioPath = [subdirectory stringByAppendingPathComponent:audioFileName];
            EGOStoryCell * cell = (EGOStoryCell*)[collectionView cellForItemAtIndexPath:indexPath];
            if ([TFileManager ifExsitAudio:audioFileName]) {
                NSData *data = [[NSData alloc]initWithContentsOfFile:localAudioPath];
                NSError * error;
                [_audioPalyer stop];
                self.audioPalyer = [[AVAudioPlayer alloc] initWithData:data error:&error];
                 _audioPalyer.delegate = cell;
                [_audioPalyer prepareToPlay];
                [_audioPalyer play];
                [cell playAudio];
            }else
            {
                [cell beginLoad];
                [NetServer downloadAudioFileWithURL:dic[@"typeVals"][3] TheController:nil Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [cell loadfinish];
                    NSData * audioData = responseObject;
                    if ([dic[@"typeVals"][3] hasSuffix:@".amr"]) {
#if TARGET_OS_IPHONE
                        audioData = DecodeAMRToWAVE(responseObject);
#endif
                    }
                    [audioData writeToFile:localAudioPath atomically:YES];
                    NSError * error;
                    [_audioPalyer stop];
                    self.audioPalyer = [[AVAudioPlayer alloc] initWithData:audioData error:&error];
                    _audioPalyer.delegate = cell;
                    [_audioPalyer prepareToPlay];
                    [_audioPalyer play];
                    [cell playAudio];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [cell loadfinish];
                    [SVProgressHUD showErrorWithStatus:@"音频不存在"];
                }];
            }
        }
    }
}
-(void)dealloc
{
    [_audioPalyer stop];
    _audioPalyer.delegate = nil;
    _audioPalyer = nil;
}
@end
