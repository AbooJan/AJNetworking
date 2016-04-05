//
//  ViewController.m
//  AJNetworking
//
//  Created by aboojan on 16/3/19.
//  Copyright © 2016年 aboojan. All rights reserved.
//

#import "ViewController.h"
#import "RequestBeanPhoneNum.h"
#import "ResponseBeanPhoneNum.h"
#import "AJNetworkManager.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextView *resultTV;

- (IBAction)checkBtnClick:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)checkBtnClick:(id)sender
{
    NSString *phoneStr = self.phoneTF.text;
    
    RequestBeanPhoneNum *requestBean = [[RequestBeanPhoneNum alloc] init];
    requestBean.phone = phoneStr;
    
    [AJNetworkManager cacheWithRequestWithBean:requestBean callBack:^(__kindof ResponseBeanBase * _Nullable responseBean, BOOL success) {
        
        if (success) {
            
            AJLog(@"==============读取缓存=============");
            
            ResponseBeanPhoneNum *response = responseBean;
            
            [self handleReponse:response];
        }
    }];
    
    [self performSelector:@selector(readFromNetwork) withObject:nil afterDelay:3.0];
}

- (void)readFromNetwork
{
    NSString *phoneStr = self.phoneTF.text;
    
    RequestBeanPhoneNum *requestBean = [[RequestBeanPhoneNum alloc] init];
    requestBean.phone = phoneStr;
    
    [AJNetworkManager requestWithBean:requestBean callBack:^(__kindof ResponseBeanBase *responseBean, BOOL success) {
        
        if (success) {
            ResponseBeanPhoneNum *response = responseBean;
            
            [self handleReponse:response];
        }
    }];
}

- (void)handleReponse:(ResponseBeanPhoneNum *)response
{
    NSString *resultStr = [NSString stringWithFormat:@"%@ \n%@ \n%@ \n%@ \n%@ \n%@", response.retData.phone, response.retData.prefix, response.retData.supplier, response.retData.province, response.retData.city, response.retData.suit];
    
    self.resultTV.text = [NSString stringWithFormat:@"%@", resultStr];
}

@end
