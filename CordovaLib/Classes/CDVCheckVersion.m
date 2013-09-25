//
//  CDVUpdate.m
//  CordovaLib
//
//  Created by jingzhao on 4/8/13.
//
//

#import "CDVCheckVersion.h"
#import <NSLog/NSLog.h>
#import <QuartzCore/QuartzCore.h>
#import <ApplicationUnity/ASIHTTPRequest.h>
#import  <ApplicationUnity/ActivityIndicatorView.h>

#define Technology_Id                      @"715319098"
#define CustomActivity_IndicatorViewFrame  CGRectMake(115, 170, 90, 75)

#define KCDVUpdateVersion_TrackViewUrl      @"trackViewUrl"
#define KCDVUpdateVersion_Result            @"results"
#define KCDVUpdateVersion_Version           @"version"

typedef void (^NewVersion)(BOOL version);


@interface CDVCheckVersion ()<SKStoreProductViewControllerDelegate,
UIAlertViewDelegate>
{
    NSString*   _trackViewUrl;
}

@property (strong, nonatomic) ActivityIndicatorView *viewActivityIndicatorView;
@property (strong, nonatomic) ASIHTTPRequest *asiHttpRequest;

@end

@implementation CDVCheckVersion

/**************************************************************************************/

#pragma mark -
#pragma mark 公有
#pragma mark -

/**************************************************************************************/


-(void)pluginInitialize
{
    //自定制缓冲等待
    _viewActivityIndicatorView = [[ActivityIndicatorView alloc]initWithFrame:CustomActivity_IndicatorViewFrame];
    [_viewActivityIndicatorView setLabelTextWithContent:@"正在检查更新..."];
    [self.viewController.view addSubview:_viewActivityIndicatorView];
}
-(void)checkVersion:(CDVInvokedUrlCommand*)command
{
    
    [_viewActivityIndicatorView startAnimation];

    NSInfo(@"检测版本开始");
    
    NSString *itunesItemIdentifier = [command.arguments count] > 0?[command.arguments objectAtIndex:0]:  Technology_Id;
    
    NSInfo(@"检测新版本传入参数Id = %@",itunesItemIdentifier);
    
    if (!itunesItemIdentifier)
    {
        [self _sendResultWithPluginResult:CDVCommandStatus_ERROR
                         WithResultString:@"缺少参数"
                               callbackId:command.callbackId];
        
        [self _showAlertViewWithTitle:@"版本更新"
                          withMessage:@"连接商店信息错误"
                 withCancelButtonInfo:@"忽略"];
    
        [_viewActivityIndicatorView stopAnimation];
        
        return;
    }
    
    [self _boolHaveNewVersionWithItunesIdentifier:itunesItemIdentifier
                                       andCommand:command
                                    andNewVersion:^(BOOL version) {
                                        if (version)
                                        {
                                            //跟着系统版本走适当的途径
                                            if ([[[UIDevice currentDevice]systemVersion] floatValue] < 6.0)
                                            {
                                                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"版本更新"
                                                                                                   message:@"发现新版本，是否更新"
                                                                                                  delegate:self
                                                                                         cancelButtonTitle:@"忽略"
                                                                                         otherButtonTitles:@"更新", nil];
                                                [alertView show];
                                                
                                                [self _sendResultWithPluginResult:CDVCommandStatus_OK
                                                                 WithResultString:@"ios6以下用户，弹出alert自己决定去不去商店"
                                                                       callbackId:command.callbackId];
                                            }
                                            else
                                            {
                                                //直接在应用内部弹出商店
                                                SKStoreProductViewController *storeProductController = [[SKStoreProductViewController alloc]init];
                                                
                                                storeProductController.delegate = self;
                                                
                                                NSDictionary *dictProductIndentify = @{SKStoreProductParameterITunesItemIdentifier:itunesItemIdentifier};
                                                
                                                [self.viewController presentViewController:storeProductController
                                                                                  animated:YES
                                                                                completion:nil];
                                                
                                                //passing the iTunes item identifie
                                                [ storeProductController loadProductWithParameters:dictProductIndentify
                                                                                   completionBlock:^(BOOL result, NSError *error)
                                                 {
                                                     if (error)
                                                     {
                                                         NSWarn(@"加载商店信息错误错误信息= %@",error);
                                                         
                                                         [self _showAlertViewWithTitle:@"版本更新"
                                                                           withMessage:@"加载商店信息错误"
                                                                  withCancelButtonInfo:@"忽略"];
                                                         [self _sendResultWithPluginResult:CDVCommandStatus_ERROR
                                                                          WithResultString:@"加载商店信息错误"
                                                                                callbackId:command.callbackId];
                                                     }
                                                     else
                                                     {
                                                         [self _sendResultWithPluginResult:CDVCommandStatus_OK
                                                                          WithResultString:@"加载商店信息成功"
                                                                                callbackId:command.callbackId];
                                                     }
                                                     
                                                 }];
                                            }
                                            
                                            
                                        }
                                        
                                        [_viewActivityIndicatorView stopAnimation];
                                    }];
}

/**************************************************************************************/

#pragma mark -
#pragma mark SKStoreProductViewControllerDelegate ios6以上版本
#pragma mark -

/**************************************************************************************/

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [self.viewController dismissModalViewControllerAnimated:YES];
    
    NSInfo(@"检测版本结束");
}

/**************************************************************************************/

#pragma mark -
#pragma mark UIAlertViewDelegate ios6以下版本
#pragma mark -

/**************************************************************************************/

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //ios6以下版本用户点击更新，打开AppStore
    if (buttonIndex == 1)
    {
        UIApplication *application = [UIApplication sharedApplication];
        
        [application openURL:[NSURL URLWithString:_trackViewUrl]];
    }
}

/**************************************************************************************/

#pragma mark -
#pragma mark 私有  是否有新的版本  失败成功后向外传递信息
#pragma mark -

/**************************************************************************************/

/*
 是否有新的版本
 */

-(void)_boolHaveNewVersionWithItunesIdentifier:(NSString*)itunesItemIdentifier
                                    andCommand:(CDVInvokedUrlCommand*)command
                                 andNewVersion:(NewVersion)boolVersion
{
    
    //当前版本号
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    
    NSString *currentVersion = [infoDict objectForKey:@"CFBundleVersion"];
    
    //AppStore版本号
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",itunesItemIdentifier]];
    
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    _asiHttpRequest = request;
    
    [request setCompletionBlock:^{
        
        NSError *error = nil;
        
        NSData *dataApp = [_asiHttpRequest responseData];
        
        //解析appstore数据
        NSDictionary *dicApp = [NSJSONSerialization JSONObjectWithData:dataApp
                                                               options:kNilOptions
                                                                 error:&error];
        if (error)
        {
            [self _showAlertViewWithTitle:@"版本更新"
                              withMessage:@"获取商店信息错误"
                     withCancelButtonInfo:@"忽略"];
            
            boolVersion(NO);
        }
        else
        {
            NSArray *arrayApp = [dicApp objectForKey:KCDVUpdateVersion_Result];
            
            if ([arrayApp count]== 0)
            {
                [self _showAlertViewWithTitle:@"版本更新"
                                  withMessage:@"没有新版本"
                         withCancelButtonInfo:@"忽略"];
                
                NSWarn(@"itune 没有返回任何信息，可能id错误");
                
                boolVersion(NO);
            }
            else
            {
                
                NSDictionary *infoAppResult = [arrayApp objectAtIndex:0];
                
                NSString *stringVersion = [infoAppResult objectForKey:KCDVUpdateVersion_Version];
                
                NSInfo(@"currentVersion= %@取得Version%@",currentVersion,stringVersion);
                
                _trackViewUrl = [infoAppResult objectForKey:KCDVUpdateVersion_TrackViewUrl];
                
                NSInfo(@"取得的_trackUrl%@",_trackViewUrl);
                
                //判断是否有新版本
              if (currentVersion.floatValue < stringVersion.floatValue)
                {
                    boolVersion(YES);
                }
                else
                {
                    [self _showAlertViewWithTitle:@"版本更新"
                                      withMessage:@"没有发现新版本"
                             withCancelButtonInfo:@"忽略"];
                    
                    boolVersion(NO);
                    
                }
            }
        }
        
    }];
    [request setFailedBlock:^{
        
        [self _showAlertViewWithTitle:@"版本更新"
                          withMessage:@"网络请求失败,请重试"
                 withCancelButtonInfo:@"忽略"];
        
        boolVersion(NO);
    }];
    
    [request startAsynchronous];
    
    
}

/*弹出Alert信息*/
-(void)_showAlertViewWithTitle:(NSString*)Title
                   withMessage:(NSString*)message
          withCancelButtonInfo:(NSString*)cancelButtonInfo
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:Title
                                                       message:message
                                                      delegate:self
                                             cancelButtonTitle:cancelButtonInfo
                                             otherButtonTitles:nil];
    [alertView show];
    
    
}



/*失败成功后向外传递信息*/

-(void)_sendResultWithPluginResult:(CDVCommandStatus)plugResult
                  WithResultString:(NSString*)resultStr
                        callbackId:(NSString*)callbackId
{
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:plugResult
                                                      messageAsString:resultStr];
    
    [self.commandDelegate sendPluginResult:pluginResult
                                callbackId:callbackId];
}

@end
