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
#import "GJWebViewViewModelPortocol.h"
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
 *  GJWebView发起一个请求 初始化传入的参数会传入viewModel中
 *  需要注意的是 这些 block 会被 viewModel 持有 注意循环引用
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


/**
 *  GJWebView加载本地的html 初始化传入的参数会传入viewModel中
 *  需要注意的是 这些 block 会被 viewModel 持有 注意循环引用
 *
 *  @param string       htmlStr
 *  @param baseURL      baseURL
 *  @param shouldStart  将要发起请求的block 会多次请求
 *  @param progress     进度条的Block
 *  @param didFinshLoad 加载完成的Block
 */
- (void)gj_webViewLoadHTMLString:( NSString * _Nullable )string
                         baseURL:(nullable NSURL *)baseURL
                   shouldSart:(_Nullable GJWebShouldStartLoadBlock)shouldStart
                     progress:(_Nullable GJWebViewProgressBlock)progress
                 didFinshLoad:(_Nullable GJWebViewDidFinishLoadBlock)didFinshLoad;




@end
