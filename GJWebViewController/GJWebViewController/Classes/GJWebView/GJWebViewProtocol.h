//
//  GJWebViewProtocol.h
//  GJWebViewController
//
//  Created by Alien on 16/7/14.
//  Copyright © 2016年 Alien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GJWebViewWorking.h"
#import "GJWebViewBackListItemProtocol.h"


/*! @enum WKNavigationType
 @abstract The type of action triggering a navigation.
 @constant GJWKNavigationTypeLinkActivated    A link with an href attribute was activated by the user.
 @constant GJWKNavigationTypeFormSubmitted    A form was submitted.
 @constant GJWKNavigationTypeBackForward      An item from the back-forward list was requested.
 @constant GJWKNavigationTypeReload           The webpage was reloaded.
 @constant GJWKNavigationTypeFormResubmitted  A form was resubmitted (for example by going back, going forward, or reloading).
 @constant GJWKNavigationTypeOther            Navigation is taking place for some other reason.
 */
typedef NS_ENUM(NSUInteger,GJWebNavgitionType) {
    GJWKNavigationTypeLinkActivated,
    GJWKNavigationTypeFormSubmitted,
    GJWKNavigationTypeBackForward,
    GJWKNavigationTypeReload,
    GJWKNavigationTypeFormResubmitted,
    GJWKNavigationTypeOther = -1,
};

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
typedef BOOL (^GJWebShouldStartLoadBlock) (UIView * _Nonnull webView, NSURLRequest * _Nonnull request , GJWebNavgitionType navigationType);
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

- (void)gj_loadRequest:(NSURLRequest *)request;
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

/**
 *  GJWebView抽象协议
 */
@protocol GJWebViewProtocol <NSObject>
/**
 *  viewModel
 */
@property (nonnull ,nonatomic ,strong , readonly) NSObject<GJWebViewViewModelPortocol> * gjWebViewModel;
/**
 *  webView UIWebView 或者是 WKWebView
 */
@property (nonnull ,nonatomic ,strong ,readonly)UIView  * webView;

@property (nonnull ,nonatomic ,strong ,readonly)UIScrollView *webScrollView;



/**
 *  GJWebView发起一个请求 初始化传入的参数会传入viewModel 中
 *
 *  @param request      NSURLRequest
 *  @param shouldStart  将要发起请求的block 会多次请求
 *  @param progress     进度条的Block
 *  @param didFinshLoad 加载完成的Block
 */
- (void)gj_webViewLoadRequest:(NSURLRequest * _Nonnull)request
                   shouldSart:(_Nullable GJWebShouldStartLoadBlock)shouldStart
                     progress:(_Nullable GJWebViewProgressBlock)progress
                      didFinshLoad:(_Nullable GJWebViewDidFinishLoadBlock)didFinshLoad;


@end
