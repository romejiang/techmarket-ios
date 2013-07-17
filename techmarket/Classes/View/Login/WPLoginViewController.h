//
//  WPLoginViewController.h
//  techmarket
//
//  Created by jing zhao on 7/12/13.
//
//

#import <UIKit/UIKit.h>


@protocol WpLoginViewDelegate <NSObject>

@optional

-(void)delegateWithRegist;
-(void)delegateWithLogin;
-(void)delegateWithLoginSuccess;

@end

@interface WPLoginViewController : UIViewController

-(void)setDelegate:(id<WpLoginViewDelegate>)_delegate;


@end
