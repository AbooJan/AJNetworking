# AJNetworking

[![CocoaPods](https://img.shields.io/cocoapods/v/AJNetworking.svg)](https://cocoapods.org/?q=AJNetworking)

AFNetworking 3.0 版本的封装，结合MJExtension框架处理JSON序列化问题



## 安装

```
pod 'AJNetworking'
```


## 使用方法

#### 一、 网络配置
1. 全局网络配置，需要使用类 `AJNetworkConfig`  在  `AppDelegate` 中配置.
	
	```
	/// 服务器域名
	@property (nonatomic, copy) NSString *hostUrl;
	/// HTTPS 证书密码
	@property (nonatomic, assign) CFStringRef httpsCertificatePassword;
	/// HTTPS 证书路径
	@property (nonatomic, copy) NSString *httpsCertificatePath;
	```
 
 --
 
#### 二、 发起请求

1. 新建一个请求类继承自 `RequestBeanBase` , 一个响应类继承自 `ResponseBeanBase` 。 

	> #### 命名规则
	
	> 1. 请求类: `RequestBean` + `业务名称`
	
	> 2. 响应类: `ResponseBean` + `业务名称`
	
	> 3. 请求类跟响应类的 `业务名称` 必须相同
	
	> 4. 例如一个登录请求，请求类为：`RequestBeanLogin` , 响应类为：`ResponseBeanLogin`
	
	
	
2. 请求类里面的成员变量即为发起请求的入参，响应类里面的成员变量即为返回参数。
 
3. 请求类需要遵循协议：`RequestBeanProtocol` . 响应类需要遵循协议：`ResponseBeanProtocol` 
 
4. 网络请求的相关配置通过实现协议 `RequestBeanProtocol` 的方法。
 
5. 发起请求由类 `AJNetworkManager` 管理，里面负责网络的请求和返回数据的处理，示例：
 
 	```
 	// 手机号码归属地查询
 	RequestBeanPhoneNum *requestBean = [[RequestBeanPhoneNum alloc] init];
    requestBean.phone = phoneStr;
    
    [AJNetworkManager requestWithBean:requestBean callBack:^(__kindof ResponseBeanBase *responseBean, BOOL success) {
        
        if (success) {
            ResponseBeanPhoneNum *response = responseBean;
            
            NSString *resultStr = [NSString stringWithFormat:@"%@ \n%@ \n%@ \n%@ \n%@ \n%@", response.retData.phone, response.retData.prefix, response.retData.supplier, response.retData.province, response.retData.city, response.retData.suit];

            self.resultTV.text = [NSString stringWithFormat:@"%@", resultStr];
        }
    }];
 	```
 	
 --
 	
#### 三、 文件上传

1. 请求类需要实现协议 `RequestBeanProtocol` 中的方法, 这个参考了 `YTKNetwork` 框架:

	```
	/**
 	 *  @author aboojan
 	 *
 	 *  @brief 当POST的内容带有文件等富文本时使用
 	 *
	 *  @return MultipartFormData Block
 	 */
	- (AFConstructingBlock)constructingBodyBlock;
	``` 
	
2. 方法实现示例：

	```
	- (AFConstructingBlock)constructingBodyBlock
	{
    	NSData *data = UIImageJPEGRepresentation(self.avatar, 0.8);
    	NSString *name = @"img";
    	NSString *formKey = @"img";
    	NSString *type = @"applicaton/octet-stream";
    
    	return AJConstructingBlockDefine {
        	[formData appendPartWithFileData:data name:formKey fileName:name mimeType:type];
    	};
	}
	```
	
3. 文件上传请求示例，跟发起普通请求一样：

	```
	RequestBeanUploadAvatar *requestBean = [[RequestBeanUploadAvatar alloc] init];
    requestBean.compid = @"1702487";
    requestBean.avatar = [UIImage imageNamed:@"testImg"];
    
    [AJNetworkManager requestWithBean:requestBean callBack:^(__kindof ResponseBeanBase *responseBean, BOOL success) {
        if (success) {
            ResponseBeanUploadAvatar *response = responseBean;
        }
    }];
 	```
 	
 --
 	
#### 四、文件下载

1. 文件下载跟普通请求不同，需要使用类 `AJNetworkManager` 中的以下方法：

	```
	/**
 	 *  @author aboojan
 	 *
 	 *  @brief 文件下载
 	 *
 	 *  @param requestBean        文件下载请求Bean
 	 *  @param progressCallBack   下载进度回调
 	 *  @param completionCallBack 完成回调
 	 *
 	 *  @return 当前下载任务线程
 	 */
	+ ( NSURLSessionDownloadTask * _Nullable )downloadTaskWithBean:(__kindof RequestBeanDownloadTaskBase * _Nonnull)requestBean progress:(AJDownloadProgressCallBack _Nullable )progressCallBack completion:(AJDownloadCompletionCallBack _Nullable)completionCallBack;;
	``` 

2. 文件下载请求类使用 `RequestBeanDownloadTaskBase`，使用示例：

	```
	RequestBeanDownloadTaskBase *downloadRequest = [[RequestBeanDownloadTaskBase alloc] init];
	downloadRequest.fileUrl = @"http://temp.26923.com/2016/pic/000/378/032ad9af805a8e83d8323f515d1d6645.jpg";
 	downloadRequest.saveFileName = @"desktop.jpg";
    downloadRequest.saveFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    [AJNetworkManager downloadTaskWithBean:downloadRequest progress:^(int64_t totalUnitCount, int64_t completedUnitCount, double progressRate) {
        
        AJLog(@"下载进度：%lf", progressRate);
        
    } completion:^(NSURL *filePath, NSError *error) {
        
        if (error) {
            AJLog(@"下载失败：%@", [error description]);
        }else{
            AJLog(@"下载成功：%@", [filePath description]);
        }
        
    }];
	```
 
 3. 下载任务控制, 通过下载请求返回的 `NSURLSessionDownloadTask` 实例来处理。
 
 	```
 	// 暂停任务 
 	[self.downloadTask suspend];
 
 	// 继续下载
 	[self.downloadTask resume];
 
 	// 取消下载
 	[self.downloadTask cancel];
 	```
 
 
 
 
## 感谢
 
   依赖框架   | 
 ------------ |
 [AFNetwoking](https://github.com/AFNetworking/AFNetworking) |
 [MJExtension](https://github.com/CoderMJLee/MJExtension)    |
	
 	
 	
 	
 	
 	
 	
 	
 	
 	


