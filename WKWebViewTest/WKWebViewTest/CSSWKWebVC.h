//
//  CSSWKWebVC.h
//  WKWebViewTest
//
//  Created by 三只鸟 on 2017/9/28.
//  Copyright © 2017年 景彦铭. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CSSCookieMode) {
    CSSCookieModeDefault, //cookie设置跟随上一页
    CSSCookieModeNone,  //不设置任何cookie 会将该域名下所有cookie清空
    CSSCookieModeToken,  //设置token
};

@interface CSSWKWebVC : UIViewController

/**
 配置url

 @param url url
 @param cookieMode cookie的设置模式
 */
- (void)configureWithURL:(NSString *)url needCookie:(CSSCookieMode)cookieMode;


@end
