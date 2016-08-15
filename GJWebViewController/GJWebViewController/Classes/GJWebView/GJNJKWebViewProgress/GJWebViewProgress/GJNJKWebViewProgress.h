//
//  NJKWebViewProgress.h
//
//  Created by Satoshi Aasano on 4/20/13.
//  Copyright (c) 2013 Satoshi Asano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GJWebViewWorking.h"
/**
 *  声明 此类事用了  NJKWebViewProgress 的  NJKWebViewProgress https://github.com/ninjinkun/NJKWebViewProgress
 *  为了避免在引入过程中出现错误,所以修改了名字，如果侵权立即删除。十分感谢 https://github.com/ninjinkun 作者的辛勤付出。
 */

#undef GJ_njk_weak
#if __has_feature(objc_arc_weak)
#define GJ_njk_weak weak
#else
#define GJ_njk_weak unsafe_unretained
#endif

extern const float GJ_NJKInitialProgressValue;
extern const float GJ_NJKInteractiveProgressValue;
extern const float GJ_NJKFinalProgressValue;

typedef void (^GJ_NJKWebViewProgressBlock)(float progress);
@protocol GJ_NJKWebViewProgressDelegate;
@protocol GJ_NJK_UIWebViewDelegate ;
@interface GJNJKWebViewProgress : NSObject<UIWebViewDelegate>
@property (nonatomic, GJ_njk_weak) id<GJ_NJKWebViewProgressDelegate>progressDelegate;
@property (nonatomic, GJ_njk_weak) id<GJ_NJK_UIWebViewDelegate>webViewProxyDelegate;
@property (nonatomic, copy) GJ_NJKWebViewProgressBlock progressBlock;
@property (nonatomic, readonly) float progress; // 0.0..1.0

- (void)reset;
@end
@protocol GJ_NJK_UIWebViewDelegate <UIWebViewDelegate>

- (void)webviewWillStartNewPageRequest:(NSURLRequest *)request navigationType:(GJWebNavigationType)navigationType;

@end
@protocol GJ_NJKWebViewProgressDelegate <NSObject>

- (void)webViewProgress:(GJNJKWebViewProgress *)webViewProgress updateProgress:(float)progress;
@end

