//
//  GJWebViewDelegate.m
//  GJWebViewController
//
//  Created by Alien on 16/7/13.
//  Copyright © 2016年 Alien. All rights reserved.
//

#import "GJWebViewViewModel.h"
#import "GJWebViewWorking.h"
#import "GJNJKWebViewProgress.h"
@interface GJWebViewViewModel()
<
UIWebViewDelegate,
GJ_NJKWebViewProgressDelegate
>
@property (nonnull , nonatomic, readwrite, strong)UIWebView *webView;
@property (nonnull , nonatomic, readwrite, strong) GJNJKWebViewProgress *progressProxy;
@end

@implementation GJWebViewViewModel

- (instancetype)init{
    if (self = [super init]) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectZero];
        _progressProxy = [[GJNJKWebViewProgress alloc]init];
        _webView.delegate = _progressProxy;
        _progressProxy.progressDelegate =self;
        _progressProxy.webViewProxyDelegate = self;
    }
    return self;
}
#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(GJNJKWebViewProgress *)webViewProgress updateProgress:(float)progress{
//    [self.progressView setProgress:progress animated:YES];
//    self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    !_progressBlock?:_progressBlock(_webView,progress);
}
#pragma mark - GJWebViewViewModelPortocol
/**
 *  webView是否可以回退到上一个页面
 */
- (void)gj_webViewCanGoBack:(nonnull void (^)(BOOL isCanBack))isCanBack{
    BOOL jsCanGoBack = [_webView stringByEvaluatingJavaScriptFromString:@"goBack()"].length;
    BOOL hasURLStack = [_webView canGoBack];
    if (!jsCanGoBack) {
        if (hasURLStack) {
            [_webView goBack];
            !isCanBack?:isCanBack(NO);
        }
    }
    if (!jsCanGoBack && !hasURLStack) {
        !isCanBack?:isCanBack(YES);
    }
}
#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return  !_shouldStartBlock? YES:_shouldStartBlock(webView,request ,navigationType);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    _didFinshLoadBlock?:_didFinshLoadBlock(webView , nil);
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    _didFinshLoadBlock?:_didFinshLoadBlock(webView , error);
}
@end
