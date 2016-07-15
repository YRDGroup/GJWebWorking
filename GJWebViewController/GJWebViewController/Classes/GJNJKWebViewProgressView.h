//
//  NJKWebViewProgressView.h
// iOS 7 Style WebView Progress Bar
//
//  Created by Satoshi Aasano on 11/16/13.
//  Copyright (c) 2013 Satoshi Asano. All rights reserved.
//
/**
 *  声明 此类事用了  NJKWebViewProgress 的  NJKWebViewProgressView https://github.com/ninjinkun/NJKWebViewProgress 
 *  为了避免 在引入过程中出现 错误 所以修改了名字，如果侵权立即删除。十分感谢 https://github.com/ninjinkun 作者的辛勤付出。
 */
#import <UIKit/UIKit.h>

@interface GJNJKWebViewProgressView : UIView
@property (nonatomic) float progress;

@property (nonatomic) UIView *progressBarView;
@property (nonatomic) NSTimeInterval barAnimationDuration; // default 0.1
@property (nonatomic) NSTimeInterval fadeAnimationDuration; // default 0.27
@property (nonatomic) NSTimeInterval fadeOutDelay; // default 0.1

- (void)setProgress:(float)progress animated:(BOOL)animated;

@end
