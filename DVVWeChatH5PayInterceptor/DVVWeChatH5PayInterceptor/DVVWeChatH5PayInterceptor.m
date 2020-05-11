//
//  DVVWeChatH5PayInterceptor.m
//  DVVWeChatH5PayInterceptor <https://github.com/devdawei/DVVWeChatH5PayInterceptor.git>
//
//  Created by David on 2020/1/14.
//  Copyright © 2020 David. All rights reserved.
//

#import "DVVWeChatH5PayInterceptor.h"

@implementation DVVWeChatH5PayInterceptorModel

@end

@implementation DVVWeChatH5PayInterceptor

+ (DVVWeChatH5PayInterceptorModel *)weChatH5PayInterceptorWithURL:(NSURL *)url customSchemePrefix:(NSString *)customSchemePrefix ignoreHosts:(NSString *)ignoreHosts {
    DVVWeChatH5PayInterceptorModel *model = nil;
    if ([url.host isEqualToString:@"wx.tenpay.com"] &&
        [url.path isEqualToString:@"/cgi-bin/mmpayweb-bin/checkmweb"] &&
        url.query) {
        NSMutableDictionary *dict = [self dictionaryFromQueryString:url.query].mutableCopy;
        NSString *redirectURL = dict[@"redirect_url"] ?: nil;
        if (redirectURL && ![redirectURL hasPrefix:customSchemePrefix]) {
            redirectURL = [redirectURL stringByRemovingPercentEncoding];
            NSURL *rurl = [NSURL URLWithString:redirectURL];
            if (rurl) {
                NSString *rhost = rurl.host;
                if (ignoreHosts &&
                    [ignoreHosts containsString:rhost]) {
                    return nil;
                }
                if ([rhost hasPrefix:@"www."]) {
                    NSRange range = [rhost rangeOfString:@"."];
                    rhost = [rhost substringFromIndex:range.location + 1];
                }
                NSString *scheme = [NSString stringWithFormat:@"%@.%@", customSchemePrefix, rhost];
                NSString *customRedirectURL = [NSString stringWithFormat:@"%@://", scheme];
                dict[@"redirect_url"] = customRedirectURL;
                NSString *query = [self queryStringFromDictionary:dict];
                NSString *replacedURL = [NSString stringWithFormat:@"%@://%@%@?%@", url.scheme, url.host, url.path, query];
                model = [[DVVWeChatH5PayInterceptorModel alloc] init];
                model.isWeChatH5Pay = YES;
                model.replacedURL = replacedURL;
                model.redirectURL = redirectURL;
                model.customRedirectURL = customRedirectURL;
            }
        }
    }
    return model;
}

+ (NSMutableDictionary *)dictionaryFromQueryString:(NSString *)queryString {
    if (!queryString ||
        ![queryString isKindOfClass:[NSString class]] ||
        !queryString.length) {
        return nil;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *arr = [queryString componentsSeparatedByString:@"&"];
    for (NSString *kv in arr) {
        NSRange r = [kv rangeOfString:@"="];
        if (r.location != NSNotFound) {
            NSString *k = [kv substringToIndex:r.location];
            NSString *v = [kv substringFromIndex:r.location + 1];
            dict[k] = v;
        }
    }
    return dict;
}

+ (NSString *)queryStringFromDictionary:(NSDictionary *)dict {
    if (!dict ||
        ![dict isKindOfClass:[NSDictionary class]] ||
        !dict.count) {
        return @"";
    }
    NSMutableString *str = [[NSMutableString alloc] init];
    BOOL flag = NO;
    for (NSString *k in dict.allKeys) {
        if (!flag) {
            flag = YES;
        } else {
            [str appendString:@"&"];
        }
        NSString *v = dict[k];
        [str appendString:[k stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPasswordAllowedCharacterSet]]];
        [str appendString:@"="];
        [str appendString:[v stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPasswordAllowedCharacterSet]]];
    }
    return str.copy;
}

@end
