//
//  ViewController.m
//  GJWebViewController
//
//  Created by Alien on 16/5/24.
//  Copyright © 2016年 Alien. All rights reserved.
//
/**
 *
 
 
 NSURLRequestUseProtocolCachePolicy = 0,	默认缓存策略。具体工作：如果一个NSCachedURLResponse对于请求并不存在，数据将会从源端获取。如果请求拥有一个缓存的响应，那么URL加载系统会检查这个响应来决定，如果它指定内容必须重新生效的话。假如内容必须重新生效，将建立一个连向源端的连接来查看内容是否发生变化。假如内容没有变化，那么响应就从本地缓存返回数据。如果内容变化了，那么数据将从源端获取
 
 　　NSURLRequestReloadIgnoringLocalCacheData = 1,	URL应该加载源端数据，不使用本地缓存数据
 　　NSURLRequestReloadIgnoringLocalAndRemoteCacheData =4,	Unimplemented本地缓存数据、代理和其他中介都要忽视他们的缓存，直接加载源数据
 　　NSURLRequestReloadIgnoringCacheData = NSURLRequestReloadIgnoringLocalCacheData, 两个的设置相同
 　　NSURLRequestReturnCacheDataElseLoad = 2, 指定已存的缓存数据应该用来响应请求，不管它的生命时长和过期时间。如果在缓存中没有已存数据来响应请求的话，数据从源端加载。
 　　NSURLRequestReturnCacheDataDontLoad = 3,	指定已存的缓存数据用来满足请求，不管生命时长和过期时间。如果在缓存中没有已存数据来响应URL加载请求的话，不去尝试从源段加载数据，此时认为加载请求失败。这个常量指定了一个类似于离线模式的行为
 　　NSURLRequestReloadRevalidatingCacheData = 5	  Unimplemented 指定如果已存的缓存数据被提供它的源段确认为有效则允许使用缓存数据响应请求，否则从源段加载数据。
 　　只有响应http和https的请求会被缓存。ftp和文件协议当被缓存策略允许的时候尝试接入源段。自定义的NSURLProtocol类能够保护缓存，如果它们被选择使用的话。
 
 NSURLRequestUseProtocolCachePolicy = 0,对特定的 URL 请求使用网络协议中实现的缓存逻辑。这是默认的策略。
 
 NSURLRequestReloadIgnoringLocalCacheData = 1,数据需要从原始地址加载。不使用现有缓存。
 NSURLRequestReloadIgnoringLocalAndRemoteCacheData = 4, // Unimplemented 不仅忽略本地缓存，同时也忽略代理服务器或其他中间介质目前已有的、协议允许的缓存
 NSURLRequestReloadIgnoringCacheData = NSURLRequestReloadIgnoringLocalCacheData,无论缓存是否过期，先使用本地缓存数据。如果缓存中没有请求所对应的数据，那么从原始地址加载数据
 
 NSURLRequestReturnCacheDataElseLoad = 2, 无论缓存是否过期，先使用本地缓存数据。如果缓存中没有请求所对应的数据，那么从原始地址加载数据
 NSURLRequestReturnCacheDataDontLoad = 3,无论缓存是否过期，先使用本地缓存数据。如果缓存中没有请求所对应的数据，那么放弃从原始地址加载数据，请求视为失败（即：“离线”模式）。
 
 NSURLRequestReloadRevalidatingCacheData = 5, // Unimplemented
 *
 *
 */


#import "GJWebViewController.h"
#import "UIWebView+AFNetworking.h"
#import <WebKit/WebKit.h>
#import "GJNJKWebViewProgress.h"
#import "GJNJKWebViewProgressView.h"
#import "GJWebViewWorking.h"
#import "GJWKWebViewViewModel.h"
#import "GJWebViewViewModel.h"
#import "GJWebViewProtocol.h"
#import "GJWebView.h"
//static NSString *const gj_webView_default_url = @"http://m1.yirendai.com/Sell/fromapp/enc_passportId?ppid=af68a52fefd44e6585d0020440eb7f38&from=app&to=user_center?ppid=af68a52fefd44e6585d0020440eb7f38&is_reg=0";
static NSString *const gj_webView_default_url = @"https://www.baidu.com";

//([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
//#define gj_webView_isWKWebAvailable 0




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


@interface GJWebViewController ()

@property (strong, nonatomic, readwrite) GJNJKWebViewProgressView *progressView;
@property (strong ,nonatomic, readwrite)__GJWebBGView *bgView;
@property (strong, nonatomic ,readwrite)GJWebView *gjWebView;
@end

@implementation GJWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _gjWebView = [[GJWebView alloc]initWithFrame:CGRectZero];
    _gjWebView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_gjWebView];
    [self.view addConstraint:[NSLayoutConstraint  constraintWithItem:_gjWebView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint  constraintWithItem:_gjWebView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view  attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint  constraintWithItem:_gjWebView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view  attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint  constraintWithItem:_gjWebView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    
    
    [self makeWebBGView];
    
    __weak typeof(self) wSelf = self;
    NSURLRequest *request = nil;
    [self makeWebBGView];
    request =[NSURLRequest requestWithURL:[NSURL URLWithString:gj_webView_default_url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:13];
    [_gjWebView gj_webViewLoadRequest:request shouldSart:^BOOL(UIView * _Nonnull webView, NSURLRequest * _Nonnull request, UIWebViewNavigationType navigationType) {
        NSURL *url = request.URL;
        if ([url.absoluteString hasPrefix:GCJSLoginAPI]) {
            
            return NO;
        }
        
        //分享请求
        if ([url.absoluteString hasPrefix:GCJSShareAPI]) {
            
            return NO;
        }
        //注册
        if ([url.absoluteString hasPrefix:GCJSRegisterAPI]) {
            
            return NO;
        }
        //跳转购买宜定盈页面接口（buyProduct API）
        if ([url.absoluteString hasPrefix:GCJSBuyProductAPI]) {
            
            return NO;
        }
        return  YES;
    } progress:^(UIView * _Nonnull webView, float progress) {
        NSLog(@"%f",progress);
        [wSelf.progressView setProgress:progress animated:YES];
    } didFinshLoad:^(UIView * _Nonnull webView, NSError * _Nullable error) {
        NSLog(@"%@ --- %@",webView , error);
    }];
    
}
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item{

    __block BOOL canBack = NO;
     [self.gjWebView gj_webViewCanGoBack:^(BOOL isCanBack) {
         canBack = isCanBack;
     }];
    if (canBack) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    return canBack;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.progressView.progress = 0;
    if (self.navigationController) {
        [self.navigationController.navigationBar addSubview:self.progressView];
    }
    
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.progressView removeFromSuperview];
}


- (GJNJKWebViewProgressView *)progressView{
    if (!_progressView && self.navigationController) {
        CGFloat progressBarHeight = 3.f;
        CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
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
    view.titleLabel.text = _bgLabelText?:@"网页有www.yirendai.com提供";
     [self.gjWebView.webView insertSubview:view atIndex:0];
    self.bgView = view;
}


#pragma mark- webView make


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


