//
//  GJWKWebViewController.h
//  GJWebViewController
//
//  Created by Alien on 16/7/13.
//  Copyright © 2016年 Alien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GJWebViewProtocol.h"
@interface GJWKWebViewViewModel : NSObject
<
GJWebViewViewModelPortocol
>

//- (instancetype)init
@property (nonatomic ,copy, readwrite)GJWebShouldStartLoadBlock _Nullable shouldStartBlock;
@property (nonatomic ,copy, readwrite)GJWebViewProgressBlock _Nullable progressBlock;
@property (nonatomic ,copy, readwrite)GJWebViewDidFinishLoadBlock _Nullable didFinshLoadBlock;

@end
