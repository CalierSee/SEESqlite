//
//  ViewController.m
//  WKWebViewTest
//
//  Created by 三只鸟 on 2017/9/28.
//  Copyright © 2017年 景彦铭. All rights reserved.
//

#import "ViewController.h"
#import "CSSWKWebVC.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CSSWKWebVC * VC = [[CSSWKWebVC alloc]init];
        [VC configureWithURL:@"file:///Users/sanzhiniao/Desktop/test.html" needCookie:CSSCookieModeToken];
        [self presentViewController:VC animated:YES completion:nil];
    });
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
