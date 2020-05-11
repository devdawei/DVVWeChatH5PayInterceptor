//
//  DVVWeChatH5PayInterceptor.h
//  DVVWeChatH5PayInterceptor <https://github.com/devdawei/DVVWeChatH5PayInterceptor.git>
//
//  Created by David on 2020/1/14.
//  Copyright © 2020 David. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DVVWeChatH5PayInterceptorModel : NSObject

/// 用于标识是否为微信H5支付
@property (nonatomic, assign) BOOL isWeChatH5Pay;

/// 替换后的网址
@property (nonatomic, copy) NSString *replacedURL;
/// 原重定向网址
@property (nonatomic, copy) NSString *redirectURL;
/// 自定义的重定向网址
@property (nonatomic, copy) NSString *customRedirectURL;

@end

@interface DVVWeChatH5PayInterceptor : NSObject

/// 微信H5支付拦截处理
/// @param url 即将加载的网址
/// @param customSchemePrefix 自定义的 URLScheme 前缀标识（例如：xxx-wechatpay，xxx 需要具有 APP 的特有标识，防止和其他 APP 重复，导致从微信跳转回 APP 有问题）
/// @param ignoreHosts 忽略列表（如果 redirect_url 的 host 包含在这个列表中，则不进行拦截处理，防止微信接口有变动导致支付有问题。这个参数应该做成后台可配置的形式，例如每次启动 APP 如果会调用一个获取某些配置的接口，则可以将忽略列表的配置放到这个接口）
+ (DVVWeChatH5PayInterceptorModel *)weChatH5PayInterceptorWithURL:(NSURL *)url customSchemePrefix:(NSString *)customSchemePrefix ignoreHosts:(NSString * _Nullable)ignoreHosts;

@end

NS_ASSUME_NONNULL_END
