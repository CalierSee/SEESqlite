//
//  CSSWKWebVC.m
//  WKWebViewTest
//
//  Created by 三只鸟 on 2017/9/28.
//  Copyright © 2017年 景彦铭. All rights reserved.
//

#import "CSSWKWebVC.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface CSSWKWebVC () <WKUIDelegate,WKNavigationDelegate>

@property (nonatomic,weak)WKWebView * webView;

@property (nonatomic,copy)NSString * urlString;

@property (nonatomic,strong)NSURL * url;

@property (nonatomic,assign)CSSCookieMode cookieMode;

@end

@implementation CSSWKWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    WKUserContentController * controller = [[WKUserContentController alloc]init];
//    controller addUserScript:<#(nonnull WKUserScript *)#>
//    WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc]init];
//    configuration.userContentController
    WKWebView * webView = [[WKWebView alloc]init];
    webView.UIDelegate = self;
    webView.navigationDelegate = self;
    _webView = webView;
    [self.view addSubview:webView];
    //创建请求
    NSURLRequest * request = [[NSURLRequest alloc]initWithURL:self.url];
    [webView loadRequest:request];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _webView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - public method
- (void)configureWithURL:(NSString *)url needCookie:(CSSCookieMode)cookieMode{
    self.urlString = url;
    self.cookieMode = cookieMode;
}

#pragma mark - private method

/**
 检查cookie

 @param name 名字
 @param value value
 @param url url
 */
- (void)css_checkCookieWithName:(NSString *)name value:(NSString *)value url:(NSString *)url {
    //检查url  cookieValue  cookieName
    if (!url.length || ![url hasPrefix:@"http"] || !name.length || !value.length) return;
    
    //查询已有cookie
    NSHTTPCookie * targetCookie = [self css_getCookieWithName:name url:url];
    if (targetCookie == nil) { //没有  设置
        [self css_setCookieWithName:name value:value url:url];
    }
    else {
        //有
        if ([targetCookie.value isEqualToString:value]) {
            if (targetCookie.expiresDate.timeIntervalSinceNow >= 60 * 60) {
                //cookie没有过期  且 值相等不作处理
                return;
            }
        }
        [[NSHTTPCookieStorage sharedHTTPCookieStorage]deleteCookie:targetCookie];
        [self css_setCookieWithName:name value:value url:url];
    }
    
}

/**
 设置cookie

 @param name 名字
 @param value value
 @param url url
 */
- (void)css_setCookieWithName:(NSString *)name value:(NSString *)value url:(NSString *)url {
    //创建cookie属性字典
    NSMutableDictionary * properties = [NSMutableDictionary dictionary];
    //设置cookie过期时间
    [properties setValue:[NSDate dateWithTimeIntervalSinceNow:604800]  forKey:NSHTTPCookieExpires];
    //设置cookie domain
    [properties setValue:[NSURL URLWithString:url].host forKey:NSHTTPCookieDomain];
    //设置路径
    [properties setValue:@"/" forKey:NSHTTPCookiePath];
    //设置版本
    [properties setValue:@"0" forKey:NSHTTPCookieVersion];
    //设置cookieName
    [properties setValue:name forKey:NSHTTPCookieName];
    //设置cookieValue
    [properties setValue:value forKey:NSHTTPCookieValue];
    NSHTTPCookie * cookie = [NSHTTPCookie cookieWithProperties:properties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage]setCookie:cookie];
}

//通过cookie名获取cookie
- (NSHTTPCookie *)css_getCookieWithName:(NSString *)cookieName url:(NSString *)url {
    NSArray <NSHTTPCookie *> * cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage]cookiesForURL:[NSURL URLWithString:url]];
    __block NSHTTPCookie * result;
    [cookies enumerateObjectsUsingBlock:^(NSHTTPCookie * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.name isEqualToString:cookieName]) {
            result = obj;
            *stop = YES;
        }
    }];
    return result;
}

/**
 删除某一域名下的所有cookie

 @param url url
 */
- (void)css_clearCookiesWithUrl:(NSString *)url {
    NSArray <NSHTTPCookie *> * cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage]cookiesForURL:[NSURL URLWithString:url]];
    [cookies enumerateObjectsUsingBlock:^(NSHTTPCookie * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage]deleteCookie:obj];
    }];
}

#pragma mark - WKUIDelegate

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(nonnull WKNavigationAction *)navigationAction decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL * targetURL = navigationAction.request.URL;
#ifdef DEBUG
    NSLog(@"%@",targetURL);
#endif
    if (self.navigationController == nil) return decisionHandler(WKNavigationActionPolicyAllow);
    //判断是否为同一个网页  如果是则不跳转  不是跳转界面
    if ([targetURL.path isEqualToString:self.url.path]) {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    else {
        //创建新的控制器
        CSSWKWebVC * vc = [[CSSWKWebVC alloc]init];
        [vc configureWithURL:targetURL.absoluteString needCookie:self.cookieMode];
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    
}

#pragma mark - getter & setter

- (void)setUrlString:(NSString *)urlString {
    NSAssert(urlString.length, @"url为空");
    if (![urlString hasPrefix:@"http"] && ![urlString hasPrefix:@"file"]) {
//        urlString = H5URL(urlString);
    }
    _urlString = urlString;
    self.url = [NSURL URLWithString:_urlString];
    NSAssert(self.url, @"NSURL对象创建失败，请检查url地址是否有误!");
}

- (void)setCookieMode:(CSSCookieMode)cookieMode {
    _cookieMode = cookieMode;
}

@end
