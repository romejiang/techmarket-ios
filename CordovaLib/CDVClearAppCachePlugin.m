//
//  CDVClearAppCachePlugin.m
//  CordovaLib
//
//  Created by jing zhao on 9/22/13.
//
//

#import "CDVClearAppCachePlugin.h"
#import  <ApplicationUnity/ActivityIndicatorView.h>
#import <ApplicationUnity/KGStatusBar.h>

#define CustomActivity_IndicatorViewFrame  CGRectMake(115, 170, 90, 75)

@interface CDVClearAppCachePlugin ()

@property (strong, nonatomic) ActivityIndicatorView *viewActivityIndicatorView;

@end

@implementation CDVClearAppCachePlugin

-(void)pluginInitialize
{
    //自定制缓冲等待
    _viewActivityIndicatorView = [[ActivityIndicatorView alloc]initWithFrame:CustomActivity_IndicatorViewFrame];
    [_viewActivityIndicatorView setLabelTextWithContent:@"正在清理缓存"];
    [self.viewController.view addSubview:_viewActivityIndicatorView];
}


-(void)clearcache:(CDVInvokedUrlCommand*)command
{
    [_viewActivityIndicatorView startAnimation];
    
    [self performSelector:@selector(stopClearCache) withObject:self afterDelay:10.0];
}

-(void)stopClearCache
{
    [_viewActivityIndicatorView stopAnimation];
    [KGStatusBar showSuccessWithStatus:@"清理缓冲成功"];

}


@end
