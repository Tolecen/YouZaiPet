//
//  AddStoryViewController.m
//  TalkingPet
//
//  Created by wangxr on 15/7/9.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "AddStoryViewController.h"
#import "ImageAssetsViewController.h"
#import "NSMutableArray+Asset.h"
#import "AddStoryItemView.h"
#import "TextEditViewController.h"
#import "T&AEditViewController.h"
#import "StoryCell.h"
#import "UIActionSheet+block.h"
#import "StoryRecorderView.h"
#import "PreviewStoryViewController.h"
#import "PublishStoryViewController.h"
#import "SVProgressHUD.h"
#import "PromptView.h"
@interface AddStoryViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate>
{
    UITextView * titleView;
    PromptView * p;
    PromptView * s;
}
@property (nonatomic,retain)UICollectionView *storyView;
@end
@implementation AddStoryViewController
- (void)dealloc
{
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"添加故事";
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setBackButtonWithTarget:@selector(back)];
    [self setRightButtonWithName:@"下一步" BackgroundImg:nil Target:@selector(setStoryCover)];
    self.view.backgroundColor = [UIColor colorWithWhite:238/255.0 alpha:1];
    titleView = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, self.view.frame.size.width-10, 60)];
    titleView.backgroundColor = [UIColor whiteColor];
    titleView.layer.borderWidth = 1;
    titleView.delegate = self;
    titleView.textColor = [UIColor orangeColor];
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.font = [UIFont systemFontOfSize:17];
    titleView.text = _story.title;
    titleView.returnKeyType = UIReturnKeyDone;
    titleView.layer.borderColor = [UIColor colorWithWhite:200/255.0 alpha:1].CGColor;
    [self.view addSubview: titleView];
    
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc]init];
    float whith = (self.view.frame.size.width-41)/3;
    layout.itemSize = CGSizeMake(whith,whith);
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.storyView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height-70-navigationBarHeight) collectionViewLayout:layout];
    _storyView.backgroundColor = [UIColor colorWithWhite:50/255.0 alpha:1];
    _storyView.contentInset = UIEdgeInsetsMake(10, 10, 80, 10);
    _storyView.alwaysBounceVertical = YES;
    _storyView.delegate = self;
    _storyView.dataSource = self;
    [self.view addSubview:_storyView];
    _storyView.showsHorizontalScrollIndicator = NO;
    [_storyView registerClass:[StoryCell class] forCellWithReuseIdentifier:@"storyCell"];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [_storyView addGestureRecognizer:longPress];
    
    UIButton * addItemB = [UIButton buttonWithType:UIButtonTypeCustom];
    addItemB.frame = CGRectMake(10, self.view.frame.size.height-80-navigationBarHeight, 46, 61.5);
    [addItemB setImage:[UIImage imageNamed:@"addStoryItem"] forState:UIControlStateNormal];
    [addItemB addTarget:self action:@selector(addItemAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addItemB];
    UIButton * previewB = [UIButton buttonWithType:UIButtonTypeCustom];
    previewB.frame = CGRectMake(self.view.frame.size.width-56, self.view.frame.size.height-80-navigationBarHeight, 46, 61.5);
    [previewB setImage:[UIImage imageNamed:@"previewStory"] forState:UIControlStateNormal];
    [previewB addTarget:self action:@selector(previewStory) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:previewB];
}
-(void)addTapTishi
{
    p = [[PromptView alloc] initWithPoint:CGPointMake(140, 80+(self.view.frame.size.width-41)/3) image:[UIImage imageNamed:@"story_tap"] arrowDirection:1];
    p.autoHide = NO;
    [self.view addSubview:p];
    [p show];
    [Common setGuided:@"story_tap"];
}
-(void)addAddTishi
{
    s = [[PromptView alloc] initWithPoint:CGPointMake(95, self.view.frame.size.height-80-10) image:[UIImage imageNamed:@"story_wanshan"] arrowDirection:3];
    s.autoHide = NO;
    [self.view addSubview:s];
    [s show];
    [Common setGuided:@"story_wanshan"];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (![Common ifHaveGuided:@"story_tap"]) {
        [self addTapTishi];
    }
    
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setImageArr:(NSMutableArray *)imageArr
{
    self.story.storyItems = [NSMutableArray array];/*all type:img,set,t&a,text*/
    _imageArr = imageArr;
    for (id obj in imageArr) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        if ([obj isKindOfClass:[UIImage class]]) {
            [dic setObject:@"img" forKey:@"type"];
            [dic setObject:obj forKey:@"img"];
        }
        if ([obj isKindOfClass:[ALAsset class]]) {
            [dic setObject:@"set" forKey:@"type"];
            [dic setObject:obj forKey:@"set"];
        }
        [self.story.storyItems addObject:dic];
    }
    [_storyView reloadData];
}
-(void)setStoryCover
{
    for (UIView * view in self.view.subviews) {
        if ([view isKindOfClass:[AddStoryItemView class]]||[view isKindOfClass:[StoryRecorderView class]]) {
            [view removeFromSuperview];
        }
    }
    if (titleView.text.length<2) {
        [SVProgressHUD showErrorWithStatus:@"请输入至少2个字标题"];
        return;
    }
    if (titleView.text.length>50) {
        [SVProgressHUD showErrorWithStatus:@"标题最多50字请酌情删减"];
        return;
    }
    _story.title = titleView.text;
    if (_imageArr.count>20||_imageArr.count<5) {
        [SVProgressHUD showErrorWithStatus:@"故事必须包含5到20张图片"];
        return;
    }
    BOOL haveText = NO;
    BOOL haveT_A = NO;
    for (NSDictionary * dic in _story.storyItems) {
        if ([dic[@"type"] isEqualToString:@"text"]) {
            haveText = YES;
        }
        if ([dic[@"type"] isEqualToString:@"t&a"]) {
            haveT_A = YES;
        }
    }
    if (!haveText) {
        [SVProgressHUD showErrorWithStatus:@"故事至少含有一个文字描述"];
        return;
    }
    if (!haveT_A) {
        [SVProgressHUD showErrorWithStatus:@"故事至少含有一个文字时间地点"];
        return;
    }
    PublishStoryViewController * vc = [[PublishStoryViewController alloc] init];
    vc.imgArr = _imageArr;
    vc.story = _story;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)previewStory
{
    PreviewStoryViewController * vc = [[PreviewStoryViewController alloc] init];
    [vc loadPreviewStoryViewWithStory:_story];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}
-(void)addItemAction
{
    AddStoryItemView * view = [[AddStoryItemView alloc] init];
    __weak AddStoryItemView * weakView = view;
    __weak AddStoryViewController * bself = self;
    [view showAtView:self.view WithAction:^(NSInteger index) {
        switch (index) {
            case 0:{
                [bself addT_A];
            }break;
            case 1:{
                [bself addImage];
            }break;
            case 2:{
                [bself addText];
            }break;
            default:
                break;
        }
        [weakView removeFromSuperview];
    }];
}
-(void)addT_A
{
    __block AddStoryViewController *blockSelf = self;
    T_AEditViewController * vc = [[T_AEditViewController alloc] init];
    vc.title = @"添加地点与时间";
    vc.finish = ^(NSString * time,NSString * address){
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:@{@"type":@"t&a",@"time":time,@"address":address}];
        [blockSelf.story.storyItems addObject:dic];
        [blockSelf.storyView reloadData];
    };
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}
-(void)addImage
{
    __block AddStoryViewController *blockSelf = self;
    ImageAssetsViewController * imageAssetsVC = [[ImageAssetsViewController alloc] init];
    imageAssetsVC.maxCount = 20-(int)_imageArr.count;
    imageAssetsVC.finish = ^(NSMutableArray*assetArray,NSMutableArray *appends){
        [blockSelf.imageArr addObjectsFromArray:appends];
        for (id obj in appends) {
            NSMutableDictionary * dic = [NSMutableDictionary dictionary];
            if ([obj isKindOfClass:[UIImage class]]) {
                [dic setObject:@"img" forKey:@"type"];
                [dic setObject:obj forKey:@"img"];
            }
            if ([obj isKindOfClass:[ALAsset class]]) {
                [dic setObject:@"set" forKey:@"type"];
                [dic setObject:obj forKey:@"set"];
            }
            [blockSelf.story.storyItems addObject:dic];
        }
        [blockSelf.storyView reloadData];
    };
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:imageAssetsVC];
    [self presentViewController:nav animated:YES completion:nil];
}
-(void)addText
{
    __block AddStoryViewController *blockSelf = self;
    TextEditViewController * vc = [[TextEditViewController alloc] init];
    vc.title = @"输入文字";
    vc.max = 200;
    vc.finish = ^(NSString * text){
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:@{@"type":@"text",@"text":text}];
        [blockSelf.story.storyItems addObject:dic];
        [blockSelf.storyView reloadData];
    };
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}
#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.story.storyItems.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SectionCellIdentifier = @"storyCell";
    NSDictionary * source = self.story.storyItems[indexPath.row];
    StoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SectionCellIdentifier forIndexPath:indexPath];
    if ([source[@"type"] isEqualToString:@"img"]) {
        [cell layoutWithImage:source[@"img"] text:source[@"text"] lineFeed:NO haveAudio:source[@"sound"]];
    }
    if ([source[@"type"] isEqualToString:@"set"]) {
        [cell layoutWithImage:[UIImage imageWithCGImage:((ALAsset*)source[@"set"]).thumbnail] text:source[@"text"] lineFeed:NO haveAudio:source[@"sound"]];
    }
    if ([source[@"type"] isEqualToString:@"text"]) {
        [cell layoutWithText:source[@"text"]];
    }
    if ([source[@"type"] isEqualToString:@"t&a"]) {
        [cell layoutWithAddress:source[@"address"] lineFeed:NO time:source[@"time"]];
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    __weak AddStoryViewController *blockSelf = self;
    NSMutableDictionary * source = self.story.storyItems[indexPath.row];
    if ([source[@"type"] isEqualToString:@"img"]) {
        NSString * text = @"添加文字描述";
        NSString * sound = @"添加语音";
        if (source[@"text"]) {
            text = @"删除文字描述";
        }
        if (source[@"sound"]) {
            sound = @"删除语音";
        }
        UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:text,sound,@"删除图片", nil];
        [sheet showInView:self.view action:^(NSInteger index) {
            if (index == 0) {
                if (source[@"text"]) {
                    [source removeObjectForKey:@"text"];
                    [blockSelf.storyView reloadItemsAtIndexPaths:@[indexPath]];
                }else{
                    TextEditViewController * vc = [[TextEditViewController alloc] init];
                    vc.title = @"输入文字";
                    vc.max = 50;
                    vc.finish = ^(NSString * text){
                        [source setObject:text forKey:@"text"];
                        [blockSelf.storyView reloadItemsAtIndexPaths:@[indexPath]];
                    };
                    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
                    [blockSelf presentViewController:nav animated:YES completion:nil];
                }
            }else if (index == 1){
                if (source[@"sound"]) {
                    [source removeObjectForKey:@"sound"];
                    [source removeObjectForKey:@"duration"];
                    [blockSelf.storyView reloadItemsAtIndexPaths:@[indexPath]];
                }else
                {
                    StoryRecorderView * recorderV = [[StoryRecorderView alloc]init];
                    [recorderV showWithView:blockSelf.view finish:^(NSData *sound, NSString *duration) {
                        [source setObject:sound forKey:@"sound"];
                        [source setObject:duration forKey:@"duration"];
                        [blockSelf.storyView reloadItemsAtIndexPaths:@[indexPath]];
                    }];
                }
            }else if (index == 2){
                [blockSelf.story.storyItems removeObjectAtIndex:indexPath.row];
                [blockSelf.imageArr removeObject:source[@"img"]];
                [blockSelf.storyView deleteItemsAtIndexPaths:@[indexPath]];
            }
        }];
    }
    if ([source[@"type"] isEqualToString:@"set"]) {
        NSString * text = @"添加文字描述";
        NSString * sound = @"添加语音";
        if (source[@"text"]) {
            text = @"删除文字描述";
        }
        if (source[@"sound"]) {
            sound = @"删除语音";
        }
        UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:text,sound,@"删除图片", nil];
        [sheet showInView:self.view action:^(NSInteger index) {
            if (index == 0) {
                if (source[@"text"]) {
                    [source removeObjectForKey:@"text"];
                    [blockSelf.storyView reloadItemsAtIndexPaths:@[indexPath]];
                }else{
                    TextEditViewController * vc = [[TextEditViewController alloc] init];
                    vc.title = @"输入文字";
                    vc.max = 50;
                    vc.finish = ^(NSString * text){
                        [source setObject:text forKey:@"text"];
                        [blockSelf.storyView reloadItemsAtIndexPaths:@[indexPath]];
                    };
                    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
                    [blockSelf presentViewController:nav animated:YES completion:nil];
                }
            }else if (index == 1){
                if (source[@"sound"]) {
                    [source removeObjectForKey:@"sound"];
                    [source removeObjectForKey:@"duration"];
                    [blockSelf.storyView reloadItemsAtIndexPaths:@[indexPath]];
                }else
                {
                    StoryRecorderView * recorderV = [[StoryRecorderView alloc]init];
                    [recorderV showWithView:blockSelf.view finish:^(NSData *sound, NSString *duration) {
                        [source setObject:sound forKey:@"sound"];
                        [source setObject:duration forKey:@"duration"];
                        [blockSelf.storyView reloadItemsAtIndexPaths:@[indexPath]];
                    }];
                }
            }else if (index == 2){
                [blockSelf.story.storyItems removeObjectAtIndex:indexPath.row];
                [blockSelf.imageArr removeAsset:source[@"set"]];
                [blockSelf.storyView deleteItemsAtIndexPaths:@[indexPath]];
            }
        }];
    }
    if ([source[@"type"] isEqualToString:@"text"]) {
        UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"修改",@"删除", nil];
        [sheet showInView:self.view action:^(NSInteger index) {
            if (index == 0) {
                TextEditViewController * vc = [[TextEditViewController alloc] init];
                vc.title = @"输入文字";
                vc.max = 200;
                [vc setText:source[@"text"]];
                vc.finish = ^(NSString * text){
                    [source setObject:text forKey:@"text"];
                    [blockSelf.storyView reloadItemsAtIndexPaths:@[indexPath]];
                };
                UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
                [blockSelf presentViewController:nav animated:YES completion:nil];
            }else if (index == 1){
                [blockSelf.story.storyItems removeObjectAtIndex:indexPath.row];
                [blockSelf.storyView deleteItemsAtIndexPaths:@[indexPath]];
            }
        }];
    }
    if ([source[@"type"] isEqualToString:@"t&a"]) {
        UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"修改",@"删除", nil];
        [sheet showInView:self.view action:^(NSInteger index) {
            if (index == 0) {
                T_AEditViewController * vc = [[T_AEditViewController alloc] init];
                vc.title = @"添加地点与时间";
                [vc setTimeString:source[@"time"] andAddress:source[@"address"]];
                vc.finish = ^(NSString * time,NSString * address){
                    [source setObject:time forKey:@"time"];
                    [source setObject:address forKey:@"address"];
                    [blockSelf.storyView reloadItemsAtIndexPaths:@[indexPath]];
                };
                UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
                [blockSelf presentViewController:nav animated:YES completion:nil];
            }else if (index == 1){
                [blockSelf.story.storyItems removeObjectAtIndex:indexPath.row];
                [blockSelf.storyView deleteItemsAtIndexPaths:@[indexPath]];
            }
        }];
    }
}
#pragma mark - UITextView
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
#pragma mark - Cell Move
- (void)longPressGestureRecognized:(id)sender {
    
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:_storyView];
    NSIndexPath *indexPath = [_storyView indexPathForItemAtPoint:location];
    
    static UIView       *snapshot = nil;
    static NSIndexPath  *sourceIndexPath = nil;
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                
                UICollectionViewCell *cell = [_storyView cellForItemAtIndexPath:indexPath];
                
                snapshot = [self customSnapshoFromView:cell];
                
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [_storyView addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    
                    center.y = location.y;
                    center.x = location.x;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    
                    cell.alpha = 0.0;
                } completion:nil];
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            center.x = location.x;
            snapshot.center = center;
            
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                id item = self.story.storyItems[sourceIndexPath.row];
                [self.story.storyItems removeObject:item];
                [self.story.storyItems insertObject:item atIndex:indexPath.row];
                [_storyView moveItemAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                sourceIndexPath = indexPath;
                UICollectionViewCell *cell = [_storyView cellForItemAtIndexPath:indexPath];
                cell.alpha = 0;
            }
            break;
        }
            
        default: {
            UICollectionViewCell *cell = [_storyView cellForItemAtIndexPath:sourceIndexPath];
            [UIView animateWithDuration:0.25 animations:^{
                
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                
                cell.alpha = 1.0;
                
            } completion:^(BOOL finished) {
                
                [snapshot removeFromSuperview];
                snapshot = nil;
                
            }];
            sourceIndexPath = nil;
            break;
        }
    }
}
- (UIView *)customSnapshoFromView:(UIView *)inputView {
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(5.0, 5.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touched");
    if ([s superview]&&[Common ifHaveGuided:@"story_wanshan"]) {
        [s removeFromSuperview];
    }
    if ([p superview]) {
        [p removeFromSuperview];
        if (![Common ifHaveGuided:@"story_wanshan"]) {
            [self performSelector:@selector(addAddTishi) withObject:nil afterDelay:0.3];
        }
        
    }
 
}
-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"dddddddd");
}
@end
