//
//  GJWebViewProtocol.h
//  GJWebViewController
//
//  Created by Alien on 16/7/14.
//  Copyright © 2016年 Alien. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol GJWebViewProtocol;
/**
 *  进度条Block
 *
 *  @param webView        UIWebView 或者是WKWebView
 *
 *  @param progress 当前进度
 */
typedef void (^GJWebViewProgressBlock) (UIView * _Nonnull webView, float progress);

/**
 *  是否开发起请求的回调
 *
 *  @param webView        UIWebView 或者是 WKWebView
 *  @param request        request
 *  @param navigationType 导航类型
 *
 *  @return 是否发起请求
 */
typedef BOOL (^GJWebShouldStartLoadBlock) (UIView * _Nonnull webView, NSURLRequest * _Nonnull request , UIWebViewNavigationType navigationType);
/**
 *  webView加载结束时的回调
 *
 *  @param webView UIWebView 或者是 WKWebView
 */
typedef void (^GJWebViewDidFinishLoadBlock) (UIView * _Nonnull webView,NSError * _Nullable error);
/**
 *  GJWebView抽象协议
 */
@protocol GJWebViewProtocol <NSObject>
/**
 *  webView UIWebView 或者是 WKWebView
 */
@property (nonatomic ,strong ,nonnull ,readonly)UIView *webView;


/**
 *  webView是否可以回退到生一个页面
 */
- (BOOL)gj_webViewCanGoBack;
/**
 *  GJWebView发起一个请求
 *
 *  @param request      NSURLRequest
 *  @param shouldStart  将要发起请求的block 会多次请求
 *  @param progress     进度条的Block
 *  @param didFinshLoad 加载完成的Block
 */
- (void)gj_webViewLoadRequest:(NSURLRequest * _Nonnull)request
                   shouldSart:(_Nullable GJWebShouldStartLoadBlock)shouldStart
                     progress:(_Nullable GJWebViewProgressBlock)progress
                      success:(_Nullable GJWebViewDidFinishLoadBlock)didFinshLoad;

@end
