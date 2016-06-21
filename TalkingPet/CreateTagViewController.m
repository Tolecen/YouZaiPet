//
//  CreateTagViewController.m
//  TalkingPet
//
//  Created by wangxr on 15/2/10.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "CreateTagViewController.h"
#import "Tag.h"
#import "SVProgressHUD.h"
#import "IdentifyingString.h"
#import "NSString+CutSpacing.h"

@interface CreateTagViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView * tabView;
    UITextField * searchTF;
}
@property (nonatomic,retain)NSMutableArray * searchArr;
@end

@implementation CreateTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBackButtonWithTarget:@selector(back)];
    UIImageView * imageV= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-navigationBarHeight)];
    imageV.image = [UIImage imageNamed:@"tagBackGround"];
    [self.view addSubview:imageV];
    
    UIButton * useB = [UIButton buttonWithType:UIButtonTypeCustom];
    [useB addTarget:self action:@selector(userCurrentText) forControlEvents:UIControlEventTouchUpInside];
    useB.frame = CGRectMake(self.view.frame.size.width - 47.5, 6, 37.5, 28);
    [useB setBackgroundImage:[UIImage imageNamed:@"userTag"] forState:UIControlStateNormal];
    [self.view addSubview:useB];
    
    UIImageView * searchBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, self.view.frame.size.width - 70, 30)];
    searchBg.image = [UIImage imageNamed:@"searchTag"];
    [self.view addSubview: searchBg];
    
    searchTF = [[UITextField alloc] initWithFrame:CGRectMake(15, 10, self.view.frame.size.width - 80, 20)];
    searchTF.delegate = self;
    searchTF.textColor = [UIColor colorWithWhite:120/255.0 alpha:1];
    searchTF.ClearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:searchTF];
    [searchTF becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:searchTF];
    
    tabView = [[UITableView alloc] initWithFrame:CGRectMake(10, 40, self.view.frame.size.width - 20, self.view.frame.size.height - navigationBarHeight - 40)];
    tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabView.backgroundColor = [UIColor clearColor];
    tabView.rowHeight = 31;
    tabView.delegate = self;
    tabView.dataSource = self;
    [self.view addSubview:tabView];
    
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)userCurrentText
{
    if (searchTF.text.length>14) {
        [SVProgressHUD showErrorWithStatus:@"创建的标签必须小于15个字"];
        return;
    }
    [SVProgressHUD showWithStatus:@"创建中，请稍等"];
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"tag" forKey:@"command"];
    [mDict setObject:@"create" forKey:@"options"];
    [mDict setObject:[searchTF.text CutSpacing] forKey:@"keyword"];
    [mDict setObject:[UserServe sharedUserServe].currentPet.petID forKey:@"currPetId"];
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary * dic = responseObject[@"value"];
        Tag * tag = [Tag new];
        tag.tagID = dic[@"id"];
        tag.tagName = dic[@"name"];
        if ([dic[@"deleted"] isEqualToString:@"false"]) {
            tag.deleted = 0;
        }else
        {
            tag.deleted = 1;
        }
        if (tag.deleted) {
            [SVProgressHUD showErrorWithStatus:@"此标签已停用"];
            return;
        }
        if (_delegate && [_delegate respondsToSelector:@selector(selectedTag:)]) {
            [self dismissViewControllerAnimated:YES completion:^{
                [_delegate selectedTag:tag];
            }];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"创建失败"];
    }];
}
- (void)textFieldChanged:(NSNotification*)notification
{
    if (!searchTF.text) {
        [_searchArr removeAllObjects];
        [tabView reloadData];
    }else if (searchTF.markedTextRange == nil && searchTF.text) {
        NSMutableDictionary* mDict = [NetServer commonDict];
        [mDict setObject:@"tag" forKey:@"command"];
        [mDict setObject:@"search" forKey:@"options"];
        [mDict setObject:searchTF.text forKey:@"keyword"];
        [mDict setObject:@"100" forKey:@"pageSize"];
        [mDict setObject:@"0" forKey:@"pageIndex"];
        [mDict setObject:[UserServe sharedUserServe].currentPet.petID forKey:@"currPetId"];
        [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.searchArr = [NSMutableArray array];
            if (((NSArray*)responseObject[@"value"]).count) {
                for (NSDictionary * dic in responseObject[@"value"]) {
                    Tag * tag = [Tag new];
                    tag.tagID = dic[@"id"];
                    tag.tagName = dic[@"name"];
                    if ([dic[@"deleted"] isEqualToString:@"false"]) {
                        tag.deleted = 0;
                    }else
                    {
                        tag.deleted = 1;
                    }
                    [_searchArr addObject:tag];
                }
            }
            [tabView reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [_searchArr removeAllObjects];
            [tabView reloadData];
        }];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [searchTF resignFirstResponder];
}
#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *goodsCellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:goodsCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor colorWithWhite:120/255.0 alpha:1];
        UIView * whithView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tabView.frame.size.width, 30)];
        whithView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
        [cell addSubview:whithView];
        [cell bringSubviewToFront:cell.textLabel];
    }
    Tag * tag = _searchArr[indexPath.row];
    cell.textLabel.text = tag.tagName;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tag * tag = _searchArr[indexPath.row];
    if (tag.deleted) {
        [SVProgressHUD showErrorWithStatus:@"此标签已停用"];
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(selectedTag:)]) {
        [self dismissViewControllerAnimated:YES completion:^{
            [_delegate selectedTag:tag];
        }];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
