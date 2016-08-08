//
//  CreatTagview.m
//  TalkingPet
//
//  Created by cc on 16/8/5.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "CreatTagview.h"
#import "SVProgressHUD.h"
#import "IdentifyingString.h"
#import "NSString+CutSpacing.h"
//#import "TagHeaderView.h"
//#import "TagCollectionViewCell.h"

@interface CreatTagview()<UITextFieldDelegate>
{
    UITableView * tabView;
    UITextField * _searchTF;
}

@end


@implementation CreatTagview

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        [self creatCView:frame];

    }
    return self;
}

-(void)creatCView:(CGRect)frame
{
    UIButton * useB = [UIButton buttonWithType:UIButtonTypeCustom];
    [useB addTarget:self action:@selector(userCurrentText) forControlEvents:UIControlEventTouchUpInside];
    useB.frame = CGRectMake(frame.size.width - 47.5, 6, 37.5, 28);
    [useB setBackgroundImage:[UIImage imageNamed:@"userTag"] forState:UIControlStateNormal];
    [self addSubview:useB];
    
    
    _searchTF = [[UITextField alloc] initWithFrame:CGRectMake(15, 10, frame.size.width - 80, 20)];
    _searchTF.delegate = self;
    _searchTF.clearsOnBeginEditing = YES;
    _searchTF.placeholder = @"请输入标签";
    _searchTF.textColor = [UIColor colorWithWhite:120/255.0 alpha:1];
    _searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self addSubview:_searchTF];
    [_searchTF becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:_searchTF];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:_searchTF];
}


- (void)userCurrentText
{
    if (_searchTF.text.length>14) {
        [SVProgressHUD showErrorWithStatus:@"创建的标签必须小于15个字"];
        return;
    }
    [SVProgressHUD showWithStatus:@"创建中，请稍等"];
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"tag" forKey:@"command"];
    [mDict setObject:@"create" forKey:@"options"];
    [mDict setObject:[_searchTF.text CutSpacing] forKey:@"keyword"];
    [mDict setObject:[UserServe sharedUserServe].userID forKey:@"currPetId"];
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
        self.cblock(tag);
        _searchTF.text=@"";
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"创建失败"];
    }];
}

- (void)textFieldChanged:(NSNotification*)notification
{
    if (!_searchTF.text) {
//        [_searchArr removeAllObjects];
//        [tabView reloadData];
    }else if (_searchTF.markedTextRange == nil && _searchTF.text) {
        NSMutableDictionary* mDict = [NetServer commonDict];
        [mDict setObject:@"tag" forKey:@"command"];
        [mDict setObject:@"search" forKey:@"options"];
        [mDict setObject:_searchTF.text forKey:@"keyword"];
        [mDict setObject:@"100" forKey:@"pageSize"];
        [mDict setObject:@"1" forKey:@"pageIndex"];
        [mDict setObject:[UserServe sharedUserServe].userID forKey:@"currPetId"];
        [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            self.searchArr = [NSMutableArray array];
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
//                    [_searchArr addObject:tag];
                }
            }
            [tabView reloadData];
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            
            
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
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_searchTF resignFirstResponder];
}


@end
