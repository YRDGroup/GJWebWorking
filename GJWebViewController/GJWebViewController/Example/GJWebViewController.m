//
//  ViewController.m
//  GJWebViewController
//
//  Created by Alien on 16/5/24.
//  Copyright © 2016年 Alien. All rights reserved.
//
/**
 *
 
 
 NSURLRequestUseProtocolCachePolicy = 0,	默认缓存策略。具体工作：如果一个NSCachedURLResponse对于请求并不存在，数据将会从源端获取。如果请求拥有一个缓存的响应，那么URL加载系统会检查这个响应来决定，如果它指定内容必须重新生效的话。假如内容必须重新生效，将建立一个连向源端的连接来查看内容是否发生变化。假如内容没有变化，那么响应就从本地缓存返回数据。如果内容变化了，那么数据将从源端获取
 
 　　NSURLRequestReloadIgnoringLocalCacheData = 1,	URL应该加载源端数据，不使用本地缓存数据
 　　NSURLRequestReloadIgnoringLocalAndRemoteCacheData =4,	Unimplemented本地缓存数据、代理和其他中介都要忽视他们的缓存，直接加载源数据
 　　NSURLRequestReloadIgnoringCacheData = NSURLRequestReloadIgnoringLocalCacheData, 两个的设置相同
 　　NSURLRequestReturnCacheDataElseLoad = 2, 指定已存的缓存数据应该用来响应请求，不管它的生命时长和过期时间。如果在缓存中没有已存数据来响应请求的话，数据从源端加载。
 　　NSURLRequestReturnCacheDataDontLoad = 3,	指定已存的缓存数据用来满足请求，不管生命时长和过期时间。如果在缓存中没有已存数据来响应URL加载请求的话，不去尝试从源段加载数据，此时认为加载请求失败。这个常量指定了一个类似于离线模式的行为
 　　NSURLRequestReloadRevalidatingCacheData = 5	  Unimplemented 指定如果已存的缓存数据被提供它的源段确认为有效则允许使用缓存数据响应请求，否则从源段加载数据。
 　　只有响应http和https的请求会被缓存。ftp和文件协议当被缓存策略允许的时候尝试接入源段。自定义的NSURLProtocol类能够保护缓存，如果它们被选择使用的话。
 
 NSURLRequestUseProtocolCachePolicy = 0,对特定的 URL 请求使用网络协议中实现的缓存逻辑。这是默认的策略。
 
 NSURLRequestReloadIgnoringLocalCacheData = 1,数据需要从原始地址加载。不使用现有缓存。
 NSURLRequestReloadIgnoringLocalAndRemoteCacheData = 4, // Unimplemented 不仅忽略本地缓存，同时也忽略代理服务器或其他中间介质目前已有的、协议允许的缓存
 NSURLRequestReloadIgnoringCacheData = NSURLRequestReloadIgnoringLocalCacheData,无论缓存是否过期，先使用本地缓存数据。如果缓存中没有请求所对应的数据，那么从原始地址加载数据
 
 NSURLRequestReturnCacheDataElseLoad = 2, 无论缓存是否过期，先使用本地缓存数据。如果缓存中没有请求所对应的数据，那么从原始地址加载数据
 NSURLRequestReturnCacheDataDontLoad = 3,无论缓存是否过期，先使用本地缓存数据。如果缓存中没有请求所对应的数据，那么放弃从原始地址加载数据，请求视为失败（即：“离线”模式）。
 
 NSURLRequestReloadRevalidatingCacheData = 5, // Unimplemented
 *
 *
 */


#import "GJWebViewController.h"

@implementation GJWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
}




@end


