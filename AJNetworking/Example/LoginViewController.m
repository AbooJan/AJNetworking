//
//  LoginViewController.m
//  AJNetworking
//
//  Created by 钟宝健 on 16/3/28.
//  Copyright © 2016年 aboojan. All rights reserved.
//

#import "LoginViewController.h"
#import "RequestBeanLogin.h"
#import "ResponseBeanLogin.h"
#import "AJNetworkManager.h"
#import "TripleDESEncrypt.h"
#import "ResponseBeanAlipayConfig.h"
#import "RequestBeanAlipayConfig.h"
#import "RequestBeanUploadAvatar.h"
#import "ResponseBeanUploadAvatar.h"
#import "ResponseBeanDownloadFile.h"
#import "RequestBeanDownloadFile.h"
#import "RequestBeanDownloadTaskBase.h"
#import "MD5Util.h"


@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

- (IBAction)loginBtnClick:(id)sender;
- (IBAction)httpsTestBtnClick:(id)sender;
- (IBAction)uploadBtnClick:(id)sender;
- (IBAction)downloadBtnClick:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    AJLog(@"%@", documentsPath);
}
 
- (IBAction)loginBtnClick:(id)sender
{
    [self.view endEditing:YES];
    
    NSString *accountStr = self.accountTF.text;
    NSString *pwStr = self.passwordTF.text;
    
    RequestBeanLogin *requestBean = [[RequestBeanLogin alloc] init];
    requestBean.phone = [TripleDESEncrypt tripleDES:accountStr encryptOrDecrypt:kCCEncrypt];
    requestBean.pwd = [TripleDESEncrypt tripleDES:pwStr encryptOrDecrypt:kCCEncrypt];
    
    [AJNetworkManager requestWithBean:requestBean callBack:^(__kindof ResponseBeanBase *responseBean, BOOL success) {
        if (success) {
            ResponseBeanLogin *response = responseBean;
            AJLog(@"#: %@", response.rawData);
//            self.resultTV.text = [NSString stringWithFormat:@"%@", [response description]];
        }
    }];
}

- (IBAction)httpsTestBtnClick:(id)sender
{
    // https 测试
    
    RequestBeanAlipayConfig *requestBean = [[RequestBeanAlipayConfig alloc] init];
    [AJNetworkManager requestWithBean:requestBean callBack:^(__kindof ResponseBeanBase *responseBean, BOOL success) {
        if (success) {
            ResponseBeanAlipayConfig *response = responseBean;
            AlipayConfigBean *configBean = response.obj;
            
//            self.resultTV.text = [NSString stringWithFormat:@"%@", [configBean description]];
        }
    }];
}

- (IBAction)uploadBtnClick:(id)sender
{
    RequestBeanUploadAvatar *requestBean = [[RequestBeanUploadAvatar alloc] init];
    requestBean.compid = @"1702487";
    requestBean.avatar = [UIImage imageNamed:@"testImg"];
    
    [AJNetworkManager requestWithBean:requestBean callBack:^(__kindof ResponseBeanBase *responseBean, BOOL success) {
        if (success) {
            ResponseBeanUploadAvatar *response = responseBean;
            
            
        }
    }];
}

- (IBAction)downloadBtnClick:(id)sender
{
    NSString *fileUrl = @"http://temp.26923.com/2016/pic/000/378/032ad9af805a8e83d8323f515d1d6645.jpg";
    NSString *fileMD5 = [MD5Util md5ExamNum:fileUrl];
    
    RequestBeanDownloadTaskBase *downloadRequest = [[RequestBeanDownloadTaskBase alloc] init];
    
    downloadRequest.fileUrl = fileUrl;
    downloadRequest.saveFileName = [NSString stringWithFormat:@"%@.jpg", fileMD5];
    
//    downloadRequest.fileUrl = @"http://118.212.145.146/music.qqvideo.tc.qq.com/l0015sn8rg9.mp4?type=mp4&fmt=mp4&vkey=B299F833D4EC200ABCFB722C3031DAA4EBCEAB0C380ABD42F6C78B2563F105BDD10A75773C9DD4577427018E8A424E43E0CE1D8788B6ED7503EC2C6E02A316C19A88665BEE7BD3F743325A10C2E3B76C190B7CE75B2F4786&locid=8fbc5585-bde6-4332-96d4-61aae48e57a4&size=18968956&ocid=2418480556";
//    downloadRequest.saveFileName = @"可以了.mp4";
    
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

}
@end
