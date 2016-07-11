//
//  DraftsViewController.m
//  TalkingPet
//
//  Created by wangxr on 14-7-17.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "DraftsViewController.h"
#import "PublishServer.h"

@interface DraftsCell : UITableViewCell
@property (nonatomic,retain)UIImageView * themImgView;
@property (nonatomic,retain)UILabel * textL;
@property (nonatomic,retain)UILabel * timeL;
@property (nonatomic,copy)void(^publish)();
@end
@implementation DraftsCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.themImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 40, 40)];
        [self.contentView addSubview:_themImgView];
        
        self.textL = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 200, 20)];
        [self.contentView addSubview:_textL];
        
        self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(60, 25, 200, 20)];
        _timeL.textColor = [UIColor colorWithWhite:150/255.0 alpha:1];
        _timeL.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_timeL];
        
        UIButton * publishB = [UIButton buttonWithType:UIButtonTypeCustom];
        publishB.frame = CGRectMake(ScreenWidth - 70, 15, 55, 20);
        [publishB setBackgroundImage:[UIImage imageNamed:@"republish"] forState:UIControlStateNormal];
        [publishB setTitle:@"发布" forState:UIControlStateNormal];
        publishB.titleLabel.font = [UIFont systemFontOfSize:14];
        [publishB addTarget:self action:@selector(publishAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:publishB];
        
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, ScreenWidth, 1)];
        lineView.backgroundColor = [UIColor colorWithWhite:200/255.0 alpha:1];
        [self.contentView addSubview:lineView];
    }
    return self;
}
-(void)publishAction
{
    if (_publish) {
        _publish();
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
}
@end;

@interface DraftsViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    NSInteger deleteOne;
    UIImageView * emptyDrafts;
}
@property (nonatomic,retain)NSMutableArray * draftsArrar;
@property (nonatomic,retain)UITableView * tableView;
@end

@implementation DraftsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"草稿箱";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBackButtonWithTarget:@selector(back)];
    [self buildViewWithSkintype];
    
    NSArray * arr = [DatabaseServe allPetalkDraftsWithCurrentPetID:[UserServe sharedUserServe].userID];
    self.draftsArrar = [NSMutableArray arrayWithArray:arr];
    for (NSDictionary * dic in [PublishServer sharedPublishServer].publishArray) {
        for (DraftModel * model in arr) {
            if (!dic[@"failure"]&&[model.publishID isEqualToString:dic[@"publisherID"]]) {
                [_draftsArrar removeObject:model];
                break;
            }
        }
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-navigationBarHeight)];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 50;
    
    emptyDrafts = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"EmptyDrafts"]];
    emptyDrafts.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds)-navigationBarHeight);
    [self.view addSubview:emptyDrafts];
    emptyDrafts.hidden = _draftsArrar.count;
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _draftsArrar.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *goodsCellIdentifier = @"draftCell";
    DraftsCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsCellIdentifier];
    if (cell == nil) {
        cell = [[DraftsCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:goodsCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    DraftModel * model = _draftsArrar[indexPath.row];
    cell.themImgView.image = [UIImage imageWithContentsOfFile:[subdirectoryw stringByAppendingString:model.thumImgPath]];
    cell.timeL.text = model.lastEnditDate;
    if (model.textDescription.length) {
        cell.textL.text = model.textDescription;
        cell.textL.textColor = [UIColor blackColor];
    }else
    {
        cell.textL.text = @"未添加描述";
        cell.textL.textColor = [UIColor colorWithWhite:200/255.0 alpha:1];
    }
    __block DraftsViewController * blockSelf = self;
    cell.publish = ^{
        [PublishServer rePublishPetalkWithPublishID:model.publishID];
        [blockSelf.navigationController popToRootViewControllerAnimated:YES];
    };
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    deleteOne = indexPath.row;
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"是否删除该草稿" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
    [alertView show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        DraftModel * model = _draftsArrar[deleteOne];
        [DatabaseServe deletePetalkDraftWithPublishId:model.publishID];
        [[NSFileManager defaultManager] removeItemAtPath:[subdirectoryw stringByAppendingString:model.publishImgPath] error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:[subdirectoryw stringByAppendingString:model.thumImgPath] error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:[subdirectoryw stringByAppendingString:model.publishAudioPath] error:nil];
        [_draftsArrar removeObjectAtIndex:deleteOne];
        [_tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:deleteOne inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        emptyDrafts.hidden = _draftsArrar.count;
        for (Publisher * dic in [PublishServer sharedPublishServer].publishArray) {
            if (dic.failure&&[model.publishID isEqualToString:dic.publishID]) {
                [[PublishServer sharedPublishServer].publishArray removeObject:dic];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WXRPublishServerBeginPublish" object:nil];
                break;
            }
        }
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
