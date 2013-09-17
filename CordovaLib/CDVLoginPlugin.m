//
//  CDVLoginPlugin.m
//  CordovaLib
//
//  Created by jing zhao on 9/16/13.
//
//

#import "CDVLoginPlugin.h"

@implementation CDVLoginPlugin

-(void)login:(CDVInvokedUrlCommand*)command
{
    [[NSNotificationCenter defaultCenter]postNotificationName:UILoginShowNotification
         object:nil];
}

@end