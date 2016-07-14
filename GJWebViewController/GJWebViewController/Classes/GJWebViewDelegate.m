//
//  GJWebViewDelegate.m
//  GJWebViewController
//
//  Created by Alien on 16/7/13.
//  Copyright © 2016年 Alien. All rights reserved.
//

#import "GJWebViewDelegate.h"
#import "GJWebViewWorking.h"
#import "UIWebView+AFNetworking.h"
@implementation GJWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSURL *url = request.URL;
    //登录请求
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
    
//    [webView loadRequest:request progress:nil success:^NSString * _Nonnull(NSHTTPURLResponse * _Nonnull response, NSString * _Nonnull HTML) {
//        return HTML;
//    } failure:^(NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//    }];

    return YES;
    
}


- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}
@end
