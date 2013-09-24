//
//  CDVMemoryCard.m
//  CordovaLib
//
//  Created by jing zhao on 9/10/13.
//
//

#import "CDVGetUserInfoPlugin.h"
#import "Setting.h"

@implementation CDVGetUserInfoPlugin

-(void)getuserinfo:(CDVInvokedUrlCommand*)command
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *dicUserInfo = [userDefault objectForKey:UserDefaultData];
    
    NSError *error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicUserInfo
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSString *jsonString = [[NSString alloc]initWithData:jsonData
                                                encoding:NSUTF8StringEncoding];
    
    
    CDVPluginResult *pluginResult  = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                       messageAsString:jsonString];
    
    //    CDVPluginResult *pluginResult  = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
    //                                                   messageAsDictionary:dicUserInfo ];
    [self.commandDelegate sendPluginResult:pluginResult
                                callbackId:command.callbackId];
    
}

-(void)deleteUserInfo:(CDVInvokedUrlCommand*)command
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:UserDefaultData];
    
    CDVPluginResult *pluginResult  = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                       messageAsString:@"删除成功"];
    [self.commandDelegate sendPluginResult:pluginResult
                                callbackId:command.callbackId];
}

-(void)getuserinfoWithParam:(CDVInvokedUrlCommand*)command
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *dicUserInfo = [userDefault objectForKey:UserDefaultData];
    
    NSString *param = [command.arguments count] > 0?[command.arguments objectAtIndex:0]:  nil;
    
    NSLog(@"param = %@",param);
    
    NSInfo(@"获取用户信息的参数param = %@",param);
    
    NSString *userInfo = [dicUserInfo objectForKey:param];
    
    CDVPluginResult *pluginResult  = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                       messageAsString:userInfo];
    [self.commandDelegate sendPluginResult:pluginResult
                                callbackId:command.callbackId];
    
}


@end
