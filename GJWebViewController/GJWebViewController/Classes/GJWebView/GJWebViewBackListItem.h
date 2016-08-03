//
//  GJWebViewBackListItem.h
//  GJWebViewController
//
//  Created by 张旭东 on 16/8/3.
//  Copyright © 2016年 Alien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GJWebViewBackListItemProtocol.h"
@interface GJWebViewBackListItem : NSObject<NSCoding,GJWebViewBackListItemProtocol>

- (nullable instancetype)initWtihURL:(nonnull NSURL *)URL
                      title:(nullable NSString *)title
               snapShotView:(nullable UIView *)snapShotView
                    request:(nullable NSURLRequest *)request;

/*! @abstract The URL of the webpage represented by this item.
 */
@property (nonnull, readonly, copy) NSURL *URL;

/*! @abstract The title of the webpage represented by this item.
 */
@property (nullable, readonly, copy) NSString *title;
/*! @abstract 跳转时的截图
 */
@property (nullable, readonly, copy) UIView *snapShotView;
/*! @abstract request
 */
@property (nullable, readonly, copy)NSURLRequest *request;
@end
