//
//  GJWebViewViewModelPortocol.h
//  GJWebViewController
//
//  Created by 张旭东 on 16/8/15.
//  Copyright © 2016年 Alien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GJWebViewWorking.h"
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
typedef BOOL (^GJWebShouldStartLoadBlock) (UIView * _Nonnull webView, NSURLRequest * _Nonnull request , GJWebNavigationType navigationType);
/**
 *  webView加载结束时的回调
 *
 *  @param webView UIWebView 或者是 WKWebView
 */
typedef void (^GJWebViewDidFinishLoadBlock) (UIView * _Nonnull webView,NSError * _Nullable error);

/**
 * viewModel
 */
@protocol GJWebViewViewModelPortocol <NSObject>

/**
 *  webView UIWebView 或者是 WKWebView
 */
@property (nonnull ,nonatomic ,strong ,readonly)UIView  * webView;

/**
 *  是否开发起请求的回调
 */
@property (nonatomic ,copy, readwrite)GJWebShouldStartLoadBlock _Nullable shouldStartBlock;
/**
 *  进度条Block
 */
@property (nonatomic ,copy, readwrite)GJWebViewProgressBlock _Nullable progressBlock;
/**
 *  webView加载结束时的回调
 */
@property (nonatomic ,copy, readwrite)GJWebViewDidFinishLoadBlock _Nullable didFinshLoadBlock;

- (void)gj_loadRequest:(NSURLRequest *_Nullable)request;
/**
 *  webView是否可以回退到生一个页面 此属性可以 KVO
 */
- (BOOL)gj_webViewCanGoBack;
/**
 *  webview会退到上一个页面
 */
- (void)gj_goBack;

/**
 *  返回请求列表
 */
@property (nonnull ,nonatomic ,strong ,readonly)NSArray <GJWebViewBackListItemProtocol > *gjBackList;
/**
 *  页面title 可以kvo
 */
@property (nullable ,nonatomic ,copy ,readonly)NSString *gj_title;

@end
