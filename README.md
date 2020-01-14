# DVVWeChatH5PayInterceptor
微信H5支付跳转回APP的解决方案

正常情况下微信的 H5 支付跳转到微信并支付成功后，微信会跳转到 Safari 浏览器，打开支付结果页面，不能正常返回 APP 中。这种跳转逻辑对用户来说非常不友好，经过查找资料和一番尝试，我发现通过修改微信支付链接中的 redirect_url，可以做到从 APP 中的微信 H5 支付页面跳转到微信支付完成后直接返回 APP，然后在 APP 中加载支付结果页面。并且多个 APP，多个支付域名也可以正常的返回到 APP。

核心替换逻辑在 `DVVWeChatH5PayInterceptor.h` 和 `DVVWeChatH5PayInterceptor.m` 文件中。

拦截 WebView 加载微信 H5 支付逻辑在 `- (void)weChatH5PayInterceptorWithRequest:(NSURLRequest *)request completionHandler:(void(^)(BOOL))completionHandler;` 方法中。

具体的使用示例在 `ViewController.m` 文件中。

## 使用方式
在`Podfile`里添加此行内容：
```
pod 'DVVWeChatH5PayInterceptor', :git => 'https://github.com/devdawei/DVVWeChatH5PayInterceptor.git', :tag => '1.0.0'
```

然后在`Terminal`中`cd`到工程目录，执行如下命令：
```
pod install
```

没有使用 CocoaPods 的项目则只需要把 `DVVWeChatH5PayInterceptor` 文件夹拖到项目中即可。
