//
//  CDVClearAppCachePlugin.h
//  CordovaLib
//
//  Created by jing zhao on 9/22/13.
//
//


#import <Foundation/Foundation.h>
#import "CDVPlugin.h"

@interface CDVClearAppCachePlugin : CDVPlugin

-(void)clearcache:(CDVInvokedUrlCommand*)command;


@end
