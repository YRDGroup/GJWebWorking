//
//  GJWebViewWorking.h
//  GJWebViewController
//
//  Created by Alien on 16/7/13.
//  Copyright © 2016年 Alien. All rights reserved.
//

#ifndef GJWebViewWorking_h
#define GJWebViewWorking_h

/*! @enum WKNavigationType
 @abstract The type of action triggering a navigation.
 @constant GJWKNavigationTypeLinkActivated    A link with an href attribute was activated by the user.
 @constant GJWKNavigationTypeFormSubmitted    A form was submitted.
 @constant GJWKNavigationTypeBackForward      An item from the back-forward list was requested.
 @constant GJWKNavigationTypeReload           The webpage was reloaded.
 @constant GJWKNavigationTypeFormResubmitted  A form was resubmitted (for example by going back, going forward, or reloading).
 @constant GJWKNavigationTypeOther            Navigation is taking place for some other reason.
 */
typedef NS_ENUM(NSUInteger,GJWebNavigationType) {
    GJWKNavigationTypeLinkActivated,
    GJWKNavigationTypeFormSubmitted,
    GJWKNavigationTypeBackForward,
    GJWKNavigationTypeReload,
    GJWKNavigationTypeFormResubmitted,
    GJWKNavigationTypeOther = -1,
};
/**
 * UIWebViewNavigationType 转为 navigationType
 *
 *  @param navigationType
 *
 *  @return GJWebNavgitionType
 */
static inline GJWebNavigationType gj_webViewnavigationTypeToGJNavigation(UIWebViewNavigationType  navigationType){
    GJWebNavigationType navType = GJWKNavigationTypeOther;
    switch (navigationType) {
        case UIWebViewNavigationTypeLinkClicked: {
            navType = GJWKNavigationTypeLinkActivated;
            break;
        }
        case UIWebViewNavigationTypeFormSubmitted: {
            navType = GJWKNavigationTypeFormSubmitted;
            break;
        }
        case UIWebViewNavigationTypeBackForward: {
            navType = GJWKNavigationTypeBackForward;
            break;
        }
        case UIWebViewNavigationTypeReload: {
            navType = GJWKNavigationTypeReload;
            break;
        }
        case UIWebViewNavigationTypeFormResubmitted: {
            navType = GJWKNavigationTypeFormResubmitted;
            break;
        }
        case UIWebViewNavigationTypeOther: {
            navType = GJWKNavigationTypeOther;
            break;
        }
        default: {
            break;
        }
    }
    return navType;
}

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
