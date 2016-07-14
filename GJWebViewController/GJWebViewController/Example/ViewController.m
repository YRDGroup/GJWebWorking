//
//  ViewController.m
//  GJWebViewController
//
//  Created by Alien on 16/6/1.
//  Copyright © 2016年 Alien. All rights reserved.
//

#import "ViewController.h"
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

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    UIView *maskView = [[UIView alloc] initWithFrame:self.view.bounds];
//    maskView.backgroundColor = [UIColor grayColor];
//    maskView.alpha = 0.4;
//    self.view.maskView = maskView;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
