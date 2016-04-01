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
- (IBAction)suspendDownloadBtnClick:(id)sender;
- (IBAction)cancelDownloadBtnClick:(id)sender;

@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, assign) BOOL isDownloading;

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
//    NSString *fileUrl = @"http://temp.26923.com/2016/pic/000/378/032ad9af805a8e83d8323f515d1d6645.jpg";
    NSString *fileUrl = @"http://125.89.74.165/10/m/m/j/a/mmjazvfnzomddhahggpebnswqfeutw/hc.yinyuetai.com/026601346FEFC3079F2136B68B0ECFD7.flv?sc=5927e705d66bde7b&br=717";
    NSString *fileMD5 = [MD5Util md5ExamNum:fileUrl];
    
    RequestBeanDownloadTaskBase *downloadRequest = [[RequestBeanDownloadTaskBase alloc] init];
    
    downloadRequest.fileUrl = fileUrl;
//    downloadRequest.saveFileName = [NSString stringWithFormat:@"%@.jpg", fileMD5];
    
    downloadRequest.saveFileName = [NSString stringWithFormat:@"%@.mp4", fileMD5];
    
    downloadRequest.saveFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    self.downloadTask = [AJNetworkManager downloadTaskWithBean:downloadRequest progress:^(int64_t totalUnitCount, int64_t completedUnitCount, double progressRate) {
        
        AJLog(@"下载进度：%lf", progressRate);
        
    } completion:^(NSURL *filePath, NSError *error) {
        
        if (error) {
            AJLog(@"下载失败：%@", [error description]);
        }else{
            AJLog(@"下载成功：%@", [filePath description]);
        }
        
    }];

    self.isDownloading = YES;
}

- (IBAction)suspendDownloadBtnClick:(UIButton *)sender
{
    // 暂停下载
    if (self.downloadTask) {
        
        if (self.isDownloading) {
            
            [self.downloadTask suspend];
            [sender setTitle:@"继续下载" forState:UIControlStateNormal];
            
            self.isDownloading = NO;
            
        }else{
            
            [self.downloadTask resume];
            [sender setTitle:@"暂停下载" forState:UIControlStateNormal];
            
            self.isDownloading = YES;
        }
    }
}

- (IBAction)cancelDownloadBtnClick:(id)sender
{
    // 取消下载
    if (self.downloadTask) {
        [self.downloadTask cancel];
    }
}
@end
