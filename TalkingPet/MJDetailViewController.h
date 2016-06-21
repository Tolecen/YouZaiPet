//
//  MJDetailViewController.h
//  MJPopupViewControllerDemo
//
//  Created by Martin Juhasz on 24.06.12.
//  Copyright (c) 2012 martinjuhasz.de. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PackageInfo.h"
#import "EGOImageView.h"
@protocol MJPopupDelegate;

@interface MJDetailViewController : UIViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (assign, nonatomic) id <MJPopupDelegate>delegate;
@property (nonatomic,strong) UIScrollView * bgScrollV;
@property (nonatomic,strong) UITableView * cTableView;
@property (nonatomic,strong) NSString * theTitle;
@property (nonatomic,strong) NSString * theDescription;
@property (nonatomic,strong) PackageInfo * packageInfo;
@property (nonatomic,strong) NSMutableArray * dArray;
@property (nonatomic,strong) UIActivityIndicatorView * loadingAct;
@property (nonatomic,assign) NSInteger cellIndex;
@property (nonatomic,assign) BOOL haveGot;
@end

@protocol MJPopupDelegate<NSObject>
@optional
- (void)cancelButtonClicked:(MJDetailViewController*)detailViewController;
-(void)alsoResetStatusHaveGotToIndex:(NSInteger)index;
@end
