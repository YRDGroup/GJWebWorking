//
//  ViewController.m
//  GJWebViewController
//
//  Created by Alien on 16/5/24.
//  Copyright © 2016年 Alien. All rights reserved.
//
/**
 *
 
 

 
 NSURLRequestUseProtocolCachePolicy = 0,对特定的 URL 请求使用网络协议中实现的缓存逻辑。这是默认的策略。
 
 NSURLRequestReloadIgnoringLocalCacheData = 1,数据需要从原始地址加载。不使用现有缓存。
 NSURLRequestReloadIgnoringLocalAndRemoteCacheData = 4, // Unimplemented 不仅忽略本地缓存，同时也忽略代理服务器或其他中间介质目前已有的、协议允许的缓存
 NSURLRequestReloadIgnoringCacheData = NSURLRequestReloadIgnoringLocalCacheData,无论缓存是否过期，先使用本地缓存数据。如果缓存中没有请求所对应的数据，那么从原始地址加载数据
 
 NSURLRequestReturnCacheDataElseLoad = 2, 无论缓存是否过期，先使用本地缓存数据。如果缓存中没有请求所对应的数据，那么从原始地址加载数据
 NSURLRequestReturnCacheDataDontLoad = 3,无论缓存是否过期，先使用本地缓存数据。如果缓存中没有请求所对应的数据，那么放弃从原始地址加载数据，请求视为失败（即：“离线”模式）。

 NSURLRequestReloadRevalidatingCacheData = 5, // Unimplemented 指定如果已存的缓存数据被提供它的源段确认为有效则允许使用缓存数据响应请求，否则从源段加载数据。
 *
 *
 */


#import "GCWebViewController.h"
#import <WebKit/WebKit.h>
#import "GJNJKWebViewProgress.h"
#import "GJNJKWebViewProgressView.h"
#import "GJWebViewWorking.h"
#import "GJWKWebViewViewModel.h"
#import "GJWebViewViewModel.h"
#import "GJWebViewProtocol.h"
#import "GJWebView.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

//@"http://testyingchat.yixinonline.com/webpage/question/index.html#first_page"
static NSString *const gj_webView_default_url = @"http://testyingchat.yixinonline.com/webpage/question/index.html#first_page";;

@interface __GJWebBGView : UIView
@property (nonatomic ,strong,readonly)UILabel *titleLabel;
@end
@implementation __GJWebBGView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithRed:0x2d/255.f green:0x32/255.f blue:0x31/255.f alpha:1.f];
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [UIColor colorWithRed:0x70/255.f green:0x75/255.f blue:0x76/255.f alpha:1.f];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_titleLabel];
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _titleLabel.frame = CGRectMake(0, 10, self.frame.size.width, 18);
}
@end


@interface GCWebViewController ()<UINavigationBarDelegate>

@property (strong, nonatomic, readwrite) GJNJKWebViewProgressView *progressView;
@property (strong ,nonatomic, readwrite)__GJWebBGView *bgView;
@property (strong, nonatomic ,readwrite)GJWebView *gjWebView;


@end

@implementation GCWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationController.navigationBar.hidden = YES;
    // Do any additional setup after loading the view, typically from a nib.
   
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"gj_webViewCanGoBack"]) {
        self.fd_interactivePopDisabled = [self.gjWebView.gjWebViewModel gj_webViewCanGoBack];
    }
    if ([keyPath isEqualToString:@"gj_title"]) {
        self.title = self.gjWebView.gjWebViewModel.gj_title;
    }
    
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.progressView.progress = 0;
    if (self.navigationController) {
        [self.customNavgationBar addSubview:self.progressView];
    }
    if (_gjWebView) {
        return;
    }
    _gjWebView = [[GJWebView alloc]initWithFrame:CGRectZero];
    _gjWebView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_gjWebView];
    [self.view addConstraint:[NSLayoutConstraint  constraintWithItem:_gjWebView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint  constraintWithItem:_gjWebView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view  attribute:NSLayoutAttributeTop multiplier:1 constant:64]];
    [self.view addConstraint:[NSLayoutConstraint  constraintWithItem:_gjWebView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view  attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint  constraintWithItem:_gjWebView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self makeWebBGView];
    __weak typeof(self) wSelf = self;
    NSURLRequest *request = nil;
    [_gjWebView.gjWebViewModel addObserver:self forKeyPath:@"gj_webViewCanGoBack" options:NSKeyValueObservingOptionNew context:nil];
    [_gjWebView.gjWebViewModel addObserver:self forKeyPath:@"gj_title" options:NSKeyValueObservingOptionNew context:nil];
    request =[NSURLRequest requestWithURL:[NSURL URLWithString:gj_webView_default_url] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    
    [_gjWebView gj_webViewLoadRequest:request shouldSart:^BOOL(UIView * _Nonnull webView, NSURLRequest * _Nonnull request, GJWebNavigationType navigationType) {
        //        NSURL *url = request.URL;
        //        if ([url.absoluteString hasPrefix:GCJSLoginAPI]) {
        //
        //            return NO;
        //        }
        //
        //        //分享请求
        //        if ([url.absoluteString hasPrefix:GCJSShareAPI]) {
        //
        //            return NO;
        //        }
        //        //注册
        //        if ([url.absoluteString hasPrefix:GCJSRegisterAPI]) {
        //
        //            return NO;
        //        }
        //        //跳转购买宜定盈页面接口（buyProduct API）
        //        if ([url.absoluteString hasPrefix:GCJSBuyProductAPI]) {
        //
        //            return NO;
        //        }
        if ([webView isKindOfClass:[UIWebView class]]) {
            UIWebView *aWebView = (UIWebView *)webView;
            _bgView.titleLabel.text = [NSString stringWithFormat:@"网页由%@提供",aWebView.request.URL.host];
        }
        return  YES;
    } progress:^(UIView * _Nonnull webView, float progress) {
        [wSelf.progressView setProgress:progress animated:YES];
    } didFinshLoad:^(UIView * _Nonnull webView, NSError * _Nullable error) {
        
        
        NSLog(@"%@ --- %@",webView , error);
    }];

    
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.progressView removeFromSuperview];
}


- (GJNJKWebViewProgressView *)progressView{
    if (!_progressView && self.navigationController) {
        CGFloat progressBarHeight = 3.f;
        CGRect navigaitonBarBounds = self.customNavgationBar.bounds;
        CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
        _progressView = [[GJNJKWebViewProgressView alloc] initWithFrame:barFrame];
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        _progressView.progressBarView.backgroundColor = [UIColor colorWithRed:0x00/255.f green:0xC2/255.f blue:0x15/255.f alpha:1.f];
        
    }
    return _progressView;
}
#pragma mark- bgViewMake

- (void)setBgLabelText:(NSString *)bgLabelText{
    if ([bgLabelText isEqualToString:_bgLabelText]) {
        return;
    }
    _bgLabelText = [bgLabelText copy];
    self.bgView.titleLabel.text = _bgLabelText;
}

- (void)makeWebBGView{
    __GJWebBGView *view = [[__GJWebBGView alloc]initWithFrame:self.view.bounds];
//    view.titleLabel.text = _bgLabelText?:@"网页有www.yirendai.com提供";
     [self.gjWebView.webView insertSubview:view belowSubview:self.gjWebView.webScrollView];
    self.bgView = view;
}


#pragma mark- webView make
- (IBAction)backBtnClicked:(id)sender {
    if (![_gjWebView.gjWebViewModel gj_webViewCanGoBack]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [self.gjWebView.gjWebViewModel gj_goBack];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (void)dealloc{
    [_gjWebView.gjWebViewModel removeObserver:self forKeyPath:@"gj_webViewCanGoBack"];
    [_gjWebView.gjWebViewModel removeObserver:self forKeyPath:@"gj_title"];
    [_gjWebView removeFromSuperview];
    _gjWebView = nil;
    GJ_WebView_DLog(@"dealoc");
}

@end


