//
//  GJWebView.m
//  GJWebViewController
//
//  Created by Alien on 16/7/14.
//  Copyright © 2016年 Alien. All rights reserved.
//

#import "GJWebView.h"
#import <WebKit/WebKit.h>
#import "GJWebViewViewModel.h"
#import "GJWKWebViewViewModel.h"
// ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
#define gj_webView_isWKWebAvailable 0
@interface GJWebView(){
    UIView * _webView;
    id<GJWebViewViewModelPortocol> _gjWebViewModel;
}
@end

@implementation GJWebView
@synthesize webView = _webView;
@synthesize gjWebViewModel = _gjWebViewModel;

- (instancetype)initWithFrame:(CGRect)frame WebKitType:(GJWebViewWebKitType)webKitType {
    if (self = [super initWithFrame:frame]) {
        _webKitType = webKitType;
        _gjWebViewModel = [self getWebViewManagerWithWebKitType];
        _webView = _gjWebViewModel.webView;
        [self addSubview:_webView];
        _webView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraint:[NSLayoutConstraint  constraintWithItem:_webView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint  constraintWithItem:_webView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint  constraintWithItem:_webView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint  constraintWithItem:_webView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    }
    return self;
}

- (instancetype)initWithWebKitType:(GJWebViewWebKitType)webKitType{
    return [self initWithFrame:CGRectZero WebKitType:webKitType];
}

- (instancetype)initWithFrame:(CGRect)frame{
    return [self initWithFrame:frame WebKitType:GJWebViewWebKitTypeAuto];
}

- (id<GJWebViewViewModelPortocol>)getWebViewManagerWithWebKitType{
    id<GJWebViewViewModelPortocol> viewManager = nil;
    switch (_webKitType) {
        case GJWebViewWebKitTypeAuto:
            viewManager = gj_webView_isWKWebAvailable ?[[GJWKWebViewViewModel alloc]init] :[[GJWebViewViewModel alloc]init];
            break;
        case GJWebViewWebKitTypeUIWebView:
            viewManager = [[GJWebViewViewModel alloc]init];
            break;
        case GJWebViewWebKitTypeWKWebView:
            viewManager = [[GJWKWebViewViewModel alloc]init];
            break;
        default:
            break;
    }
    return viewManager;
}

- (void)gj_webViewLoadRequest:(NSURLRequest * _Nonnull)request
                   shouldSart:(_Nullable GJWebShouldStartLoadBlock)shouldStart
                     progress:(_Nullable GJWebViewProgressBlock)progress
                      didFinshLoad:(_Nullable GJWebViewDidFinishLoadBlock)didFinshLoad{
    _gjWebViewModel.shouldStartBlock = shouldStart;
    _gjWebViewModel.progressBlock = progress;
    _gjWebViewModel.didFinshLoadBlock = didFinshLoad;
    [_gjWebViewModel gj_loadRequest:request];  
}

- (UIScrollView *)webScrollView{
    if ([_webView isKindOfClass:[WKWebView class]]) {
        return [(WKWebView *)_webView scrollView];
    }
    return [(UIWebView *)_webView scrollView];
}



- (void)dealloc{
    GJ_WebView_DLog(@"dealoc");
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
