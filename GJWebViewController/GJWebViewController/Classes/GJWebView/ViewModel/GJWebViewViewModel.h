//
//  GJWebViewDelegate.h
//  GJWebViewController
//
//  Created by Alien on 16/7/13.
//  Copyright © 2016年 Alien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GJWebViewProtocol.h"
/**
 *  UIWebView delegate 类
 */
@interface GJWebViewViewModel : NSObject
<
GJWebViewViewModelPortocol
>

@property (nullable, nonatomic ,copy, readwrite)GJWebShouldStartLoadBlock shouldStartBlock;
@property (nullable, nonatomic ,copy, readwrite)GJWebViewProgressBlock  progressBlock;
@property (nullable, nonatomic ,copy, readwrite)GJWebViewDidFinishLoadBlock  didFinshLoadBlock;

@end
