//
//  CDVMemoryCard.h
//  CordovaLib
//
//  Created by jing zhao on 9/10/13.
//
//

#import <Foundation/Foundation.h>
#import "CDVPlugin.h"
#import <OpenUDID/OpenUDIDD.h>
#import <NSLog/NSLog.h>


@interface CDVGetUserInfoPlugin : CDVPlugin

-(void)getuserinfo:(CDVInvokedUrlCommand*)command;

@end
