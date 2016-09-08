//
//  GJWKWebViewController.m
//  GJWebViewController
//
//  Created by Alien on 16/7/13.
//  Copyright © 2016年 Alien. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "GJWebViewWorking.h"
#import "GJWKWebViewViewModel.h"

@interface GJWKWebViewViewModel()
<
WKUIDelegate,
WKNavigationDelegate,
WKScriptMessageHandler
>

@property (nonnull , nonatomic ,readwrite ,strong)WKWebView *webView;

@property (assign ,nonatomic ,readwrite)BOOL gj_webViewCanGoBack;

@end


@implementation GJWKWebViewViewModel
@synthesize gj_webViewCanGoBack = _gj_webViewCanGoBack;
@synthesize gj_title = _gj_title;

#pragma mark -lifeCircle
- (instancetype)init {
    if (self = [super init]) {
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = userContentController;
        _webView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:configuration];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        _webView.allowsBackForwardNavigationGestures = YES;
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
        [_webView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:nil];
        
        [self performSelector:@selector(resetState) withObject:nil withObject:nil];
       
    }
    return self;
}


- (void)resetState {
    [self gj_webViewCanGoBack];
}

+ (UIViewController *)GJBase_topViewController {
    return [self GJBase_topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

+ (UIViewController *)GJBase_topViewController:(UIViewController *)rootViewController {
    if (rootViewController.presentedViewController) {
        return [self GJBase_topViewController:rootViewController.presentedViewController];
    }
    
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController;
        return [self GJBase_topViewController:[navigationController.viewControllers lastObject]];
    }
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabController = (UITabBarController *)rootViewController;
        return [self GJBase_topViewController:tabController.selectedViewController];
    }
    return rootViewController;
}

- (void)dealloc{
    [_webView stopLoading];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView removeObserver:self forKeyPath:@"canGoBack"];
}

#pragma mark - GJWebViewViewModelPortocol
- (void)setGj_title:(NSString *)title {
    
    if ([_gj_title isEqualToString:title]) {
        return;
    }
    [self willChangeValueForKey:@"gj_title"];
    _gj_title = [title copy];
    [self didChangeValueForKey:@"gj_title"];
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        !_progressBlock?:_progressBlock(_webView,_webView.estimatedProgress);
    }
    if ([keyPath isEqualToString:@"title"]) {
        [self setGj_title:self.webView.title];
    }
    if ([keyPath isEqualToString:@"canGoBack"]) {
        [self setGj_webViewCanGoBack:[change[NSKeyValueChangeNewKey] boolValue]];
    }
    
    
}

- (void)gj_goBack {
    [(WKWebView *)self.webView goBack];
}

- (BOOL)gj_webViewCanGoBack {
    BOOL hasURLStack = [_webView canGoBack];
    if (hasURLStack  != _gj_webViewCanGoBack) {
        [self setGj_webViewCanGoBack:hasURLStack];
    }
    return _gj_webViewCanGoBack;
}

- (void)setGj_webViewCanGoBack:(BOOL)gj_webViewCanGoBack {
    
    if (_gj_webViewCanGoBack == gj_webViewCanGoBack) {
        return;
    }
    [self willChangeValueForKey:NSStringFromSelector(@selector(gj_webViewCanGoBack))];
    _gj_webViewCanGoBack = gj_webViewCanGoBack;
    [self didChangeValueForKey:NSStringFromSelector(@selector(gj_webViewCanGoBack))];
    
}

- (void)gj_loadRequest:(NSURLRequest *)request {
    [self.webView loadRequest:request];
}

- (void)gj_loadHTMLString:(NSString * _Nullable )string baseURL:(nullable NSURL *)baseURL {
    [self.webView loadHTMLString:string baseURL:baseURL];
}

- (void)gj_reload {
    [self.webView reload];
}

- (NSArray <GJWebViewBackListItemProtocol>*)gjBackList {
    return [_webView.backForwardList.backList copy];
}

#pragma mark-
#pragma mark-  wkwebViewDelegate  implementation
#pragma mark - WKNavigationDelegate 页面跳转
#pragma mark 在发送请求之前，决定是否跳转

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    GJ_WebView_DLog(@"--");
    NSURL  *url = navigationAction.request.URL;
    if (!navigationAction.targetFrame) {
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    //打电话
    if ([url.scheme isEqualToString:@"tel"]){
        UIAlertController *alertController = nil;
        if ([[UIApplication sharedApplication] canOpenURL:url]){
            alertController = [UIAlertController alertControllerWithTitle:url.resourceSpecifier message:nil preferredStyle:UIAlertControllerStyleAlert];
            // 取消
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
            // 确定按钮
            [alertController addAction:[UIAlertAction actionWithTitle:@"拨打" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:url];
            }]];
        }else{
            alertController = [UIAlertController alertControllerWithTitle:nil message:@"设备不支持电话功能" preferredStyle:UIAlertControllerStyleAlert];
        }
        [[[self class] GJBase_topViewController] presentViewController:alertController animated:YES completion:nil];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    GJWebNavigationType navType = GJWKNavigationTypeOther;
    switch (navigationAction.navigationType) {
        case WKNavigationTypeLinkActivated:
            navType = GJWKNavigationTypeLinkActivated;
            break;
        case WKNavigationTypeFormSubmitted:
            navType = GJWKNavigationTypeFormSubmitted;
            break;
        case WKNavigationTypeBackForward:
            navType = GJWKNavigationTypeBackForward;
            break;
        case WKNavigationTypeReload:
            navType = GJWKNavigationTypeReload;
            break;
        case WKNavigationTypeFormResubmitted:
            navType = GJWKNavigationTypeFormResubmitted;
            break;
        case WKNavigationTypeOther:
            navType = GJWKNavigationTypeOther;
            break;
        default:
            break;
    }
    if (!(!_shouldStartBlock? YES:_shouldStartBlock(_webView,navigationAction.request ,navType))) {
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"");
    });
    decisionHandler(WKNavigationActionPolicyAllow);
    
}

#pragma mark 身份验证
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler {
    GJ_WebView_DLog(@"--");
    completionHandler(NSURLSessionAuthChallengeUseCredential, nil);
}

#pragma mark 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    GJ_WebView_DLog(@"--");
    decisionHandler(WKNavigationResponsePolicyAllow);
}

#pragma mark 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    GJ_WebView_DLog(@"--");
}

#pragma mark WKNavigation导航错误
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    GJ_WebView_DLog(@"--");
}

#pragma mark WKWebView终止
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    GJ_WebView_DLog(@"--");
}

#pragma mark - WKNavigationDelegate 页面加载
#pragma mark 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    GJ_WebView_DLog(@"--");
}

#pragma mark 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    GJ_WebView_DLog(@"--");
}

#pragma mark 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    webView.opaque = NO;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    GJ_WebView_DLog(@"--");
}

#pragma mark 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    GJ_WebView_DLog(@"--");
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    GJ_WebView_DLog(@"%s",__FUNCTION__);
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }];
    // alert弹出框
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:alertAction];
    [[[self class] GJBase_topViewController] presentViewController:alertController animated:YES completion:nil];
    //    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    GJ_WebView_DLog(@"%s",__FUNCTION__);
    // 按钮
    UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        // 返回用户选择的信息
        completionHandler(NO);
    }];
    UIAlertAction *alertActionOK = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }];
    // alert弹出框
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:alertActionCancel];
    [alertController addAction:alertActionOK];
    [[[self class] GJBase_topViewController] presentViewController:alertController animated:YES completion:nil];
    //    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    GJ_WebView_DLog(@"%s",__FUNCTION__);
    
    
    GJ_WebView_DLog(@"%s",__FUNCTION__);
    // alert弹出框
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:nil preferredStyle:UIAlertControllerStyleAlert];
    // 输入框
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = defaultText;
    }];
    // 确定按钮
    [alertController addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 返回用户输入的信息
        UITextField *textField = alertController.textFields.firstObject;
        completionHandler(textField.text);
    }]];
    // 显示
    
    [[[self class] GJBase_topViewController] presentViewController:alertController animated:YES completion:nil];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    GJ_WebView_DLog(@"%s---%@---%@",__FUNCTION__,message.name,message.body);
}

@end
