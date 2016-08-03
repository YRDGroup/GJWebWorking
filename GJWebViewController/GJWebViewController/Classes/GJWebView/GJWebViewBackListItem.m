//
//  GJWebViewBackListItem.m
//  GJWebViewController
//
//  Created by 张旭东 on 16/8/3.
//  Copyright © 2016年 Alien. All rights reserved.
//

#import "GJWebViewBackListItem.h"

@implementation GJWebViewBackListItem
- (nullable instancetype)initWtihURL:(nonnull NSURL *)URL
                               title:(nullable NSString *)title
                        snapShotView:(nullable UIView *)snapShotView
                             request:(nullable NSURLRequest *)request{
    if (self = [super init]) {
        _URL = URL;
        _title = title;
        _snapShotView = snapShotView;
        _request = request;
    }
    return  self;
}

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_URL forKey:@"_URL"];
    [encoder encodeObject:_title forKey:@"_title"];
    [encoder encodeObject:_snapShotView forKey:@"_snapShotView"];
    [encoder encodeObject:_request forKey:@"_request"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    _URL = [decoder decodeObjectForKey:@"_URL"];
    _title  = [decoder decodeObjectForKey:@"_title"];
    _snapShotView = [decoder decodeObjectForKey:@"_snapShotView"];
    _request = [decoder decodeObjectForKey:@"_request"];
    return self;
}
@end
