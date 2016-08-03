//
//  GJWebViewDelegate.m
//  GJWebViewController
//
//  Created by Alien on 16/7/13.
//  Copyright © 2016年 Alien. All rights reserved.
//

#import "GJWebViewViewModel.h"
#import "GJWebViewWorking.h"
#import "GJNJKWebViewProgress.h"
#import "GJWebViewBackListItem.h"
@interface GJWebViewViewModel()
<
UIWebViewDelegate,
GJ_NJKWebViewProgressDelegate
>
@property (nonnull , nonatomic, readwrite, strong)UIWebView *webView;
@property (nonnull , nonatomic, readwrite, strong) GJNJKWebViewProgress *progressProxy;



/**
 *  array that hold snapshots
 */
@property (nonatomic)NSMutableArray <GJWebViewBackListItem *>* snapShotsArray;

/**
 *  current snapshotview displaying on screen when start swiping
 */
@property (nonatomic)UIView* currentSnapShotView;

/**
 *  previous view
 */
@property (nonatomic)UIView* prevSnapShotView;

/**
 *  background alpha black view
 */
@property (nonatomic)UIView* swipingBackgoundView;

/**
 *  left pan ges
 */
@property (nonatomic)UIPanGestureRecognizer* swipePanGesture;
/**
 *  if is swiping now
 */
@property (nonatomic)BOOL isSwipingBack;
@end

@implementation GJWebViewViewModel

- (instancetype)init{
    if (self = [super init]) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectZero];
        [_webView addGestureRecognizer:self.swipePanGesture];
        _progressProxy = [[GJNJKWebViewProgress alloc]init];
        _webView.delegate = _progressProxy;
        _progressProxy.progressDelegate =self;
        _progressProxy.webViewProxyDelegate = self;
    }
    return self;
}
#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(GJNJKWebViewProgress *)webViewProgress updateProgress:(float)progress{

    !_progressBlock?:_progressBlock(_webView,progress);
}
#pragma mark - GJWebViewViewModelPortocol
/**
 *  webView是否可以回退到上一个页面
 */

- (BOOL)gj_webViewCanGoBack{
    BOOL hasURLStack = [_webView canGoBack];
    if (hasURLStack) {
        [_webView goBack];
    }
    return !hasURLStack;
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//      !_shouldStartBlock? YES:_shouldStartBlock(webView,request ,navigationType);
    BOOL shouldLoad = YES;
    if (_shouldStartBlock) {
        shouldLoad = _shouldStartBlock(webView,request ,navigationType);
    }
    if (!shouldLoad) {
        return shouldLoad;
    }
    switch (navigationType) {
        case UIWebViewNavigationTypeLinkClicked: {
            [self pushCurrentSnapshotViewWithRequest:request];
            break;
        }
        case UIWebViewNavigationTypeFormSubmitted: {
            [self pushCurrentSnapshotViewWithRequest:request];
            break;
        }
        case UIWebViewNavigationTypeBackForward: {
            break;
        }
        case UIWebViewNavigationTypeReload: {
            break;
        }
        case UIWebViewNavigationTypeFormResubmitted: {
            break;
        }
        case UIWebViewNavigationTypeOther: {
            [self pushCurrentSnapshotViewWithRequest:request];
            break;
        }
        default: {
            break;
        }
    }
    return shouldLoad;

}
- (void)webViewDidStartLoad:(UIWebView *)webView{
     [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if (self.prevSnapShotView.superview) {
        [self.prevSnapShotView removeFromSuperview];
    }

    _didFinshLoadBlock?:_didFinshLoadBlock(webView , nil);
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    _didFinshLoadBlock?:_didFinshLoadBlock(webView , error);
}
- (void)dealloc{
    GJ_WebView_DLog(@"dealoc");
}
#pragma mark- webViewTransition getter
-(UIView*)swipingBackgoundView{
    if (!_swipingBackgoundView) {
        _swipingBackgoundView = [[UIView alloc] initWithFrame:self.webView.bounds];
        _swipingBackgoundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }
    return _swipingBackgoundView;
}

-(NSMutableArray*)snapShotsArray{
    if (!_snapShotsArray) {
        _snapShotsArray = [NSMutableArray array];
    }
    return _snapShotsArray;
}

-(BOOL)isSwipingBack{
    if (!_isSwipingBack) {
        _isSwipingBack = NO;
    }
    return _isSwipingBack;
}

-(UIPanGestureRecognizer*)swipePanGesture{
    if (!_swipePanGesture) {
        _swipePanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipePanGestureHandler:)];
    }
    return _swipePanGesture;
}
#pragma mark - events handler




-(void)swipePanGestureHandler:(UIPanGestureRecognizer*)panGesture{
    CGPoint translation = [panGesture translationInView:self.webView];
//    NSLog(@"pan x %f,pan y %f",translation.x,translation.y);
//    UIViewController *controller = (UIViewController *)self.webView.superview.superview.nextResponder;
//    controller.navigationController.interactivePopGestureRecognizer.enabled = NO;
    if (panGesture.state == UIGestureRecognizerStateBegan) {//location.x <= 50 &&
        if ( translation.x >= 0) {  //开始动画
            [self startPopSnapshotView];
        }
    }else if (panGesture.state == UIGestureRecognizerStateCancelled || panGesture.state == UIGestureRecognizerStateEnded){
        [self endPopSnapShotView];
        
    }else if (panGesture.state == UIGestureRecognizerStateChanged){
        [self popSnapShotViewWithPanGestureDistance:translation.x];
    }
}

#pragma mark - logic of push and pop snap shot views
-(void)pushCurrentSnapshotViewWithRequest:(NSURLRequest*)request{
    // NSLog(@"push with request %@",request);
    NSURLRequest* lastRequest = (NSURLRequest*)[[self.snapShotsArray lastObject]request];
    
    //如果url是很奇怪的就不push
    if ([request.URL.absoluteString isEqualToString:@"about:blank"]) {
        //        // NSLog(@"about blank!! return");
        return;
    }
    //如果url一样就不进行push
    if ([lastRequest.URL.absoluteString isEqualToString:request.URL.absoluteString]) {
        return;
    }
    
    UIView* currentSnapShotView = [self.webView snapshotViewAfterScreenUpdates:YES];
    GJWebViewBackListItem *item = [[GJWebViewBackListItem alloc]initWtihURL:request.URL
                                                                      title:nil
                                                               snapShotView:currentSnapShotView
                                                                    request:request];
    [self.snapShotsArray addObject:item];
}

- (NSArray <GJWebViewBackListItemProtocol>*)gjBackList{
    return [_snapShotsArray copy];
}


-(void)startPopSnapshotView{
    if (self.isSwipingBack) {
        return;
    }
    if (!self.webView.canGoBack) {
        return;
    }
    self.isSwipingBack = YES;
    //create a center of scrren
    CGPoint center = CGPointMake(self.webView.bounds.size.width/2, self.webView.bounds.size.height/2);
    
    self.currentSnapShotView = [self.webView snapshotViewAfterScreenUpdates:YES];
    
    //add shadows just like UINavigationController
    self.currentSnapShotView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.currentSnapShotView.layer.shadowOffset = CGSizeMake(3, 3);
    self.currentSnapShotView.layer.shadowRadius = 5;
    self.currentSnapShotView.layer.shadowOpacity = 0.75;
    
    //move to center of screen
    self.currentSnapShotView.center = center;
    
    self.prevSnapShotView = (UIView*)[[self.snapShotsArray lastObject] snapShotView];
    center.x -= 60;
    self.prevSnapShotView.center = center;
    self.prevSnapShotView.alpha = 1;
    self.webView.backgroundColor = [UIColor blackColor];
    
    [self.webView addSubview:self.prevSnapShotView];
    [self.webView addSubview:self.swipingBackgoundView];
    [self.webView addSubview:self.currentSnapShotView];
}

-(void)popSnapShotViewWithPanGestureDistance:(CGFloat)distance{
    if (!self.isSwipingBack) {
        return;
    }
    
    if (distance <= 0) {
        return;
    }
    
    CGPoint currentSnapshotViewCenter = CGPointMake(_webView.bounds.size.width/2, _webView.bounds.size.height/2);
    currentSnapshotViewCenter.x += distance;
    CGPoint prevSnapshotViewCenter = CGPointMake(_webView.bounds.size.width/2, _webView.bounds.size.height/2);
    prevSnapshotViewCenter.x -= (_webView.bounds.size.width - distance)*60/_webView.bounds.size.width;
    //    // NSLog(@"prev center x%f",prevSnapshotViewCenter.x);
    
    self.currentSnapShotView.center = currentSnapshotViewCenter;
    self.prevSnapShotView.center = prevSnapshotViewCenter;
    self.swipingBackgoundView.alpha = (_webView.bounds.size.width - distance)/_webView.bounds.size.width;
}

-(void)endPopSnapShotView{
    if (!self.isSwipingBack) {
        return;
    }
    
    //prevent the user touch for now
    //self.webView.superview.userInteractionEnabled = NO;
    
    if (self.currentSnapShotView.center.x >= _webView.bounds.size.width) {
        // pop success
        [UIView animateWithDuration:0.2 animations:^{
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            
            self.currentSnapShotView.center = CGPointMake(_webView.bounds.size.width*3/2, _webView.bounds.size.height/2);
            self.prevSnapShotView.center = CGPointMake(_webView.bounds.size.width/2, _webView.bounds.size.height/2);
            self.swipingBackgoundView.alpha = 0;
        }completion:^(BOOL finished) {
            
            [self.webView goBack];
            [self.snapShotsArray removeLastObject];
            [self.currentSnapShotView removeFromSuperview];
            [self.swipingBackgoundView removeFromSuperview];
            
            //self.webView.superview.userInteractionEnabled = YES;
            self.isSwipingBack = NO;
        }];
    }else{
        //pop fail
        [UIView animateWithDuration:0.2 animations:^{
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            
            self.currentSnapShotView.center = CGPointMake(_webView.bounds.size.width/2, _webView.bounds.size.height/2);
            self.prevSnapShotView.center = CGPointMake(_webView.bounds.size.width/2-60, _webView.bounds.size.height/2);
            self.prevSnapShotView.alpha = 1;
        }completion:^(BOOL finished) {
            [self.prevSnapShotView removeFromSuperview];
            [self.swipingBackgoundView removeFromSuperview];
            [self.currentSnapShotView removeFromSuperview];
            //self.webView.superview.userInteractionEnabled = YES;
            self.isSwipingBack = NO;
        }];
    }
}


@end
