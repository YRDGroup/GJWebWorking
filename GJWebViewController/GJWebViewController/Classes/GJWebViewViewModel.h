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

//- (instancetype)init
@property (nonatomic ,copy, readwrite)GJWebShouldStartLoadBlock _Nullable shouldStartBlock;
@property (nonatomic ,copy, readwrite)GJWebViewProgressBlock _Nullable progressBlock;
@property (nonatomic ,copy, readwrite)GJWebViewDidFinishLoadBlock _Nullable didFinshLoadBlock;
@end
