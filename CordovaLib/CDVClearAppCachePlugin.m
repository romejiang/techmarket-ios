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

@property (strong, nonatomic) UIControl*             overlayer;

@end

@implementation CDVClearAppCachePlugin

-(void)pluginInitialize
{
    //自定制缓冲等待
    _viewActivityIndicatorView = [[ActivityIndicatorView alloc]initWithFrame:CustomActivity_IndicatorViewFrame];
    [_viewActivityIndicatorView setLabelTextWithContent:@"正在清理缓存"];
    [self.viewController.view addSubview:_viewActivityIndicatorView];

    self.overlayer = [[UIControl alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.overlayer.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:0.6];
    [self.overlayer addTarget:self
                       action:@selector(touch)
             forControlEvents:UIControlEventTouchUpInside];
    [self.viewController.view addSubview:self.overlayer];
    self.overlayer.hidden = YES;
}


-(void)clearcache:(CDVInvokedUrlCommand*)command
{
    [_viewActivityIndicatorView startAnimation];
    
    self.overlayer.hidden = NO;
    
    [self performSelector:@selector(stopClearCache) withObject:self afterDelay:10.0];
}

-(void)stopClearCache
{
    [_viewActivityIndicatorView stopAnimation];
    
    self.overlayer.hidden = YES;
    
    [KGStatusBar showSuccessWithStatus:@"清理缓冲成功"];
    

}

-(void)touch
{


}

@end
