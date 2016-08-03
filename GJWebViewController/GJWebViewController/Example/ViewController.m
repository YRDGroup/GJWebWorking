//
//  ViewController.m
//  GJWebViewController
//
//  Created by Alien on 16/6/1.
//  Copyright © 2016年 Alien. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.gurView = [[GCGradienteCurveView alloc]initWithFrame:CGRectZero];
//    [self.view addSubview:self.gurView];
//    self.gurView.translatesAutoresizingMaskIntoConstraints = NO;
//    self.gurView.dataSource =self;
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.gurView
//                                                          attribute:NSLayoutAttributeWidth
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:self.view
//                                                          attribute:NSLayoutAttributeWidth
//                                                         multiplier:1
//                                                           constant:0]];
//    
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.gurView
//                                                          attribute:NSLayoutAttributeLeft
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:self.view
//                                                          attribute:NSLayoutAttributeLeft
//                                                         multiplier:1
//                                                           constant:0]];
//    
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.gurView
//                                                          attribute:NSLayoutAttributeTop
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:self.view
//                                                          attribute:NSLayoutAttributeTop
//                                                         multiplier:1
//                                                           constant:180]];
//    
//    
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.gurView
//                                                          attribute:NSLayoutAttributeHeight
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:self.view
//                                                          attribute:NSLayoutAttributeHeight
//                                                         multiplier:0
//                                                           constant:180]];
    

}
//
//- (void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    UIView *maskView = [[UIView alloc] initWithFrame:self.view.bounds];
//    maskView.backgroundColor = [UIColor grayColor];
//    maskView.alpha = 0.4;
////    [[UIApplication sharedApplication].windows firstObject].maskView = maskView;
//    if (self.navigationController) {
//       self.navigationController.view.maskView = maskView;
//    }else{
//       self.view.maskView = maskView;
//    }
//    
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
//    view.backgroundColor = [UIColor redColor];
//    view.layer.cornerRadius = 50;
//    [self.navigationController.view addSubview:view];
//    view.center = self.view.center;
//    
////    LAContext *myContext = [[LAContext alloc] init];
////    NSError *error = nil;
////    if (![myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
////        NSLog(@"%@",error);
////        return;
////    }
////    [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"hello TouchID" reply:^(BOOL success, NSError * _Nullable error) {
////        NSLog(@"%@",error);
////    }];
//
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
