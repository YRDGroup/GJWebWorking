//
//  GJWKWebViewController.h
//  GJWebViewController
//
//  Created by 张旭东 on 16/7/13.
//  Copyright © 2016年 Alien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
@interface GJWKWebViewDelegate : NSObject <WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@end
