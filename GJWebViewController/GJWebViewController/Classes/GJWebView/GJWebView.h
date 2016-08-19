//
//  GJWebView.h
//  GJWebViewController
//
//  Created by Alien on 16/7/14.
//  Copyright © 2016年 Alien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GJWebViewProtocol.h"


@interface GJWebView : UIView <GJWebViewProtocol>
@property (nonatomic ,assign ,readonly)GJWebViewWebKitType webKitType;
- (instancetype)initWithWebKitType:(GJWebViewWebKitType)webKitType;
- (instancetype)initWithFrame:(CGRect)frame WebKitType:(GJWebViewWebKitType)webKitType;
@end
