//
//  WebContentViewController.m
//  Boyacai
//
//  Created by Tolecen on 14-6-9.
//
//

#import "WebContentViewController.h"

@interface WebContentViewController ()

@end

@implementation WebContentViewController
@synthesize webType;
@synthesize urlStr;
@synthesize titleName;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = self.titleName;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:230/255.0f alpha:1];
    UIImageView * bg = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.center.x-105, 20, 210, 137)];
    [bg setImage:[UIImage imageNamed:@"PublishHeader"]];
    [self.view addSubview:bg];
    [self setBackButtonWithTarget:@selector(backBtnDo:)];
    agreeWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, ScreenWidth, self.view.frame.size.height - navigationBarHeight)];
//    agreeWebView.delegate = self;
    agreeWebView.backgroundColor = [UIColor clearColor];
     [self.view addSubview:agreeWebView];
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    agreeWebView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    [agreeWebView loadRequest:request];
    
   
    
    [self buildViewWithSkintype];
    
//    [self.navigationController.navigationBar addSubview:_progressView];
	// Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _progressView.hidden = YES;
    [self.navigationController.navigationBar addSubview:_progressView];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _progressView.hidden = NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    [_progressView removeFromSuperview];
}
-(void)backBtnDo:(UIButton *)sender
{
    [agreeWebView stopLoading];
    if (self.navigationController.viewControllers.count>1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    }
}
#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if (!self.title) {
        self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
