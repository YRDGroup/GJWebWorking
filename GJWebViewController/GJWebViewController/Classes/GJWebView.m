//
//  GJWebView.m
//  GJWebViewController
//
//  Created by 张旭东 on 16/7/14.
//  Copyright © 2016年 Alien. All rights reserved.
//

#import "GJWebView.h"
@interface GJWebView(){
    UIView *_webView;
}



@end

@implementation GJWebView
@synthesize webView = _webView;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)gj_webViewLoadRequest:(NSURLRequest * _Nonnull)request
                   shouldSart:(_Nullable GJWebShouldStartLoadBlock)shouldStart
                     progress:(_Nullable GJWebViewProgressBlock)progress
                      success:(_Nullable GJWebViewDidFinishLoadBlock)didFinshLoad{
    
}

- (BOOL)gj_webViewCanGoBack{
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
