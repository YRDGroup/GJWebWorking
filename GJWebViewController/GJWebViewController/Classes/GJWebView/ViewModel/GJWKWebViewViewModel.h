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

@property (nullable, nonatomic ,copy, readwrite)GJWebShouldStartLoadBlock shouldStartBlock;
@property (nullable, nonatomic ,copy, readwrite)GJWebViewProgressBlock  progressBlock;
@property (nullable, nonatomic ,copy, readwrite)GJWebViewDidFinishLoadBlock  didFinshLoadBlock;

@end
