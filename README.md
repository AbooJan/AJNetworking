# AJNetworking
AFNetworking 3.0 版本的封装，结合MJExtension框架处理JSON序列化问题

---

### 使用方法

一、 全局网络配置，使用类 `AJNetworkConfig`  在  `AppDelegate` 中配置.
	
	```
	/// 服务器域名
	@property (nonatomic, copy) NSString *hostUrl;
	/// HTTPS 证书密码
	@property (nonatomic, assign) CFStringRef httpsCertificatePassword;
	/// HTTPS 证书路径
	@property (nonatomic, copy) NSString *httpsCertificatePath;
	```
 
 
 二、 发起请求

1. 新建一个请求类继承自 `RequestBeanBase` , 一个响应类继承自 `ResponseBeanBase` 。 

	> #### 命名规则
	
	> 1. 请求类: `RequestBean` + `业务名称`
	
	> 2. 响应类: `ResponseBean` + `业务名称`
	
	> 3. 请求类跟响应类的 `业务名称` 必须相同
	
	> 4. 例如一个登录请求，请求类为：`RequestBeanLogin` , 响应类为：`ResponseBeanLogin`
	
	
 2. 请求类里面的成员变量即为发起请求的入参，响应类里面的成员变量即为返回参数。
 
 3. 请求类需要遵循协议：`RequestBeanProtocol` . 响应类需要遵循协议：`ResponseBeanProtocol` 
 
 4. 网络请求的相关配置通过实现协议 `RequestBeanProtocol` 的方法。
 
 5. 发起请求有类 `AJNetworkManager` 管理，里面负责网络的请求和返回数据的处理，示例：
 
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
 	

 	
 	
 	
 	
 	
 	
 	
 	
 	
 	
 	


