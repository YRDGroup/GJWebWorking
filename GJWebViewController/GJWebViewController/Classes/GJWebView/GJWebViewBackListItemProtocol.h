//
//  GJWebViewBackListItemProtocol.h
//  GJWebViewController
//
//  Created by 张旭东 on 16/8/3.
//  Copyright © 2016年 Alien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol GJWebViewBackListItemProtocol <NSObject>
@required
/*! @abstract The URL of the webpage represented by this item.
 */
@property (nonnull, readonly, copy) NSURL *URL;
/*! @abstract The title of the webpage represented by this item.
 */
@property (nullable, readonly, copy) NSString *title;
@end
