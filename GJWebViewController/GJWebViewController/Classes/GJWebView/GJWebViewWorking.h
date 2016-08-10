//
//  GJWebViewWorking.h
//  GJWebViewController
//
//  Created by Alien on 16/7/13.
//  Copyright © 2016年 Alien. All rights reserved.
//

#ifndef GJWebViewWorking_h
#define GJWebViewWorking_h
#ifndef GJ_WebView_DLog

#ifdef DEBUG
//定义了日志输出 DLog 如果需要输出 请使用此语句 替换系统的NSLog

#define GJ_WebView_DLog(format, ...) do {                                      \
fprintf(stderr, "<%s : %d> %s\n",                                              \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],     \
__LINE__, __func__);                                                           \
(NSLog)((format), ##__VA_ARGS__);                                              \
fprintf(stderr, "--------------------------------------------------------\n"); \
} while (0)
#else
#define GJ_WebView_DLog(format, ...) do {} while (0)
#endif


#endif
#endif /* GJWebViewWorking_h */
