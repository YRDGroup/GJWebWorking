//
//  GJWKWebViewController.m
//  GJWebViewController
//
//  Created by Alien on 16/7/13.
//  Copyright © 2016年 Alien. All rights reserved.
//

#import "GJWKWebViewViewModel.h"
#import "GJWebViewWorking.h"
#import <WebKit/WebKit.h>
@interface GJWKWebViewViewModel()
<
WKUIDelegate,
WKNavigationDelegate,
WKScriptMessageHandler
>
@property (nonnull , nonatomic ,readwrite ,strong)WKWebView *webView;

@end


@implementation GJWKWebViewViewModel

- (instancetype)init{
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
    }
    return self;
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        !_progressBlock?:_progressBlock(_webView,_webView.estimatedProgress);
    }
    if ([keyPath isEqualToString:@"title"]) {
//        self.title = self.wkWebView.title;
    }
}
    
- (BOOL)gj_webViewCanGoBack{
    BOOL hasURLStack = [_webView canGoBack];
    if (hasURLStack) {
        [_webView goBack];
    }
    return !hasURLStack;
}
//    [_webView evaluateJavaScript:@"goBack()" completionHandler:^(id jsCanGoBack, NSError * error) {
//        BOOL hasURLStack = [_webView canGoBack];
//        if (!jsCanGoBack && hasURLStack) {
//            [_webView goBack];
//            !isCanBack?:isCanBack(NO);
//        }else if (!jsCanGoBack && !hasURLStack) {
//            !isCanBack?:isCanBack(YES);
//            return ;
//        }
//        !isCanBack?:isCanBack(YES);
//        //             [(WKWebView *)_webView reloadFromOrigin];
//    }];



#pragma mark-
#pragma mark-  wkwebViewDelegate  implementation
#pragma mark - WKNavigationDelegate 页面跳转
#pragma mark 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
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
    //登录请求
    if ([url.absoluteString hasPrefix:GCJSLoginAPI]) {
        
        return;
    }
    
    //分享请求
    if ([url.absoluteString hasPrefix:GCJSShareAPI]) {
        
        return;
    }
    //注册
    if ([url.absoluteString hasPrefix:GCJSRegisterAPI]) {
        
        return;
    }
    //跳转购买宜定盈页面接口（buyProduct API）
    if ([url.absoluteString hasPrefix:GCJSBuyProductAPI]) {
        
        return;
    }
     decisionHandler(WKNavigationActionPolicyAllow);
    
}

#pragma mark 身份验证
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler{
    GJ_WebView_DLog(@"--");
    completionHandler(NSURLSessionAuthChallengeUseCredential, nil);
}

#pragma mark 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    GJ_WebView_DLog(@"--");
    decisionHandler(WKNavigationResponsePolicyAllow);
}

#pragma mark 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    GJ_WebView_DLog(@"--");
}

#pragma mark WKNavigation导航错误
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    GJ_WebView_DLog(@"--");
}

#pragma mark WKWebView终止
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    GJ_WebView_DLog(@"--");
}

#pragma mark - WKNavigationDelegate 页面加载
#pragma mark 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    GJ_WebView_DLog(@"--");
}

#pragma mark 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
    webView.opaque = NO;
    GJ_WebView_DLog(@"--");
}

#pragma mark 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    GJ_WebView_DLog(@"--");
}

#pragma mark 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    GJ_WebView_DLog(@"--");
}



- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
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


- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
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


- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
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

//- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
//
//    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
//
//}
//
//- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
//
//    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
//
//        [[challenge sender]  useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
//
//        [[challenge sender]  continueWithoutCredentialForAuthenticationChallenge: challenge];
//
//    }
//
//}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    GJ_WebView_DLog(@"%s---%@---%@",__FUNCTION__,message.name,message.body);
}


+ (UIViewController *)GJBase_topViewController{
    return [self GJBase_topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

+ (UIViewController *)GJBase_topViewController:(UIViewController *)rootViewController
{
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
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
}
@end
