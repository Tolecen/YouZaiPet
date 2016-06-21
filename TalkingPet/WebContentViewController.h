//
//  WebContentViewController.h
//  Boyacai
//
//  Created by Tolecen on 14-6-9.
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
@interface WebContentViewController : BaseViewController<UIWebViewDelegate,NJKWebViewProgressDelegate>
{
    UIWebView * agreeWebView;
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}
@property (assign,nonatomic)int webType;
@property (retain,nonatomic)NSString * urlStr;
@property (retain,nonatomic)NSString * titleName;
//@property (retain, nonatomic)NJKWebViewProgressView *progressView;
//@property (retain, nonatomic)NJKWebViewProgress *progressProxy;
@end
