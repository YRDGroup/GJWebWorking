//
//  GJWebRequestCash.m
//  GJWebViewController
//
//  Created by 张旭东 on 16/8/12.
//  Copyright © 2016年 Alien. All rights reserved.
//

#import "GJWebRequestCash.h"

@implementation GJWebRequestCash
- (NSCachedURLResponse*)cachedResponseForRequest:(NSURLRequest*)request
{
//    NSURL *url = [request URL];
//    BOOL blockURL = YES;
//    if (blockURL) {
//        NSURLResponse *response =
//        [[NSURLResponse alloc] initWithURL:url
//                                  MIMEType:@"text/plain"
//                     expectedContentLength:1
//                          textEncodingName:nil];
//        NSCachedURLResponse *cachedResponse =
//        [[NSCachedURLResponse alloc] initWithResponse:response
//                                                 data:[NSData dataWithBytes:" " length:1]];
//        [super storeCachedResponse:cachedResponse forRequest:request];
//        
//    }
    NSCachedURLResponse *cachedURLResponse =  [super cachedResponseForRequest:request];
    NSURLResponse *response = cachedURLResponse.response;
    return cachedURLResponse;
}
@end
