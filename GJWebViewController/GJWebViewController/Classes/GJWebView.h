//
//  GJWebView.h
//  GJWebViewController
//
//  Created by 张旭东 on 16/7/14.
//  Copyright © 2016年 Alien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GJWebViewProtocol.h"
@interface GJWebView : UIView
<
GJWebViewProtocol
>
@property (nonatomic ,copy, readwrite)GJWebShouldStartLoadBlock _Nullable shouldStartBlock;
@property (nonatomic ,copy, readwrite)GJWebViewProgressBlock _Nullable progressBlock;
@property (nonatomic ,copy, readwrite)GJWebViewDidFinishLoadBlock _Nullable didFinshLoadBlock;
@end
