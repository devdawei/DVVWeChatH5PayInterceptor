//
//  ViewController.m
//  DVVWeChatH5PayInterceptor
//
//  Created by David on 2020/1/14.
//  Copyright © 2020 David. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import "DVVWeChatH5PayInterceptor.h"
#import "Const.h"

@interface ViewController () <WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

// 微信H5支付拦截处理
@property (nonatomic, copy) NSString *weChatH5PayRedirectURL;
@property (nonatomic, copy) NSString *weChatH5PayCustomRedirectURL;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    self.webView.frame = self.view.bounds;
    
    NSString *urlString = @"这里填写微信 H5 测试支付页面";
    [self loadRequestWithURLString:urlString];
}

#pragma mark - LoadRequest

- (void)loadRequestWithURLString:(NSString *)URLString {
    [self loadRequestWithURLString:URLString willLoadRequestHandler:nil];
}

- (void)loadRequestWithURLString:(NSString *)URLString willLoadRequestHandler:(void (^)(NSMutableURLRequest *mutableURLRequest))willLoadRequestHandler {
    NSURL *url = [NSURL URLWithString:URLString];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url];
    if (willLoadRequestHandler) {
        willLoadRequestHandler(req);
    }
    [self.webView loadRequest:req];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURLRequest *request = navigationAction.request;
    NSLog(@"即将加载网址：%@", request.URL);
    
    [self weChatH5PayInterceptorWithRequest:request completionHandler:^(BOOL success) {
        if (success) {
            if (decisionHandler) decisionHandler(WKNavigationActionPolicyCancel);
        } else {
            if (![request.URL.scheme isEqualToString:@"http"] &&
                ![request.URL.scheme isEqualToString:@"https"]) {
                [[UIApplication sharedApplication] openURL:request.URL options:@{} completionHandler:^(BOOL success) {
                    NSLog(@"跳转结果：%@", @(success));
                    if (decisionHandler) decisionHandler(success ? WKNavigationActionPolicyCancel : WKNavigationActionPolicyAllow);
                }];
            } else {
                if (decisionHandler) decisionHandler(WKNavigationActionPolicyAllow);
            }
        }
    }];
}

- (void)weChatH5PayInterceptorWithRequest:(NSURLRequest *)request completionHandler:(void(^)(BOOL))completionHandler {
    DVVWeChatH5PayInterceptorModel *model = [DVVWeChatH5PayInterceptor weChatH5PayInterceptorWithURL:request.URL customSchemePrefix:WeChatH5PayCustomSchemePrefix ignoreHosts:nil];
    if (model.isWeChatH5Pay) {
        if (completionHandler) completionHandler(YES);
        // 处理微信H5支付
        NSLog(@"微信H5转原生支付跳转回 APP 的 URL，需要将 URLSchemes 添加到 info.plist 中的 URL Types 中才能从微信跳转回 APP：%@", model.customRedirectURL);
        self.weChatH5PayRedirectURL = model.redirectURL;
        self.weChatH5PayCustomRedirectURL = model.customRedirectURL;
        // Referer，如果没有的话，会报“商家参数格式有误,请联系商家解决”
        NSString *referer = self.weChatH5PayCustomRedirectURL;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadRequestWithURLString:model.replacedURL willLoadRequestHandler:^(NSMutableURLRequest *mutableURLRequest) {
                [mutableURLRequest setValue:referer forHTTPHeaderField:@"Referer"];
            }];
        });
    } else {
        if ([request.URL.absoluteString isEqualToString:self.weChatH5PayCustomRedirectURL]) {
            if (completionHandler) completionHandler(YES);
            // 处理微信H5支付
            self.weChatH5PayCustomRedirectURL = nil;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self loadRequestWithURLString:self.weChatH5PayRedirectURL];
                self.weChatH5PayRedirectURL = nil;
            });
        } else {
            if (completionHandler) completionHandler(NO);
        }
    }
}

#pragma mark - Getters

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] init];
        // 允许前进后退导航手势
        _webView.allowsBackForwardNavigationGestures = YES;
        // 设置代理
        _webView.navigationDelegate = self;
    }
    return _webView;
}

@end
