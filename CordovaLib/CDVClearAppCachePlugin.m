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
#import "Setting.h"

#define CustomActivity_IndicatorViewFrame  CGRectMake(115, 170, 90, 75)

@interface CDVClearAppCachePlugin ()


@end

@implementation CDVClearAppCachePlugin

-(void)pluginInitialize
{

}


-(void)clearcache:(CDVInvokedUrlCommand*)command
{
    [[NSNotificationCenter defaultCenter]postNotificationName:ShowMaskView
                                                       object:nil];

    [self performSelector:@selector(stopClearCache) withObject:self afterDelay:8.0];
}

-(void)stopClearCache
{
    [[NSNotificationCenter defaultCenter]postNotificationName:HideMaskView
                                                       object:nil];


}

-(void)touch
{


}

@end
