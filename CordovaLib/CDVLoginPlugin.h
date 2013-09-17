//
//  CDVLoginPlugin.h
//  CordovaLib
//
//  Created by jing zhao on 9/16/13.
//
//

#import <Foundation/Foundation.h>
#import "CDVPlugin.h"
#import "Setting.h"

@interface CDVLoginPlugin : CDVPlugin

-(void)login:(CDVInvokedUrlCommand*)command;
@end
