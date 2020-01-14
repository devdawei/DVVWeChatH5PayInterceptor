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
+ (DVVWeChatH5PayInterceptorModel *)weChatH5PayInterceptorWithURL:(NSURL *)url customSchemePrefix:(NSString *)customSchemePrefix;

@end

NS_ASSUME_NONNULL_END
