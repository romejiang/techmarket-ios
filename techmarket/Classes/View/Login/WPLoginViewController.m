//
//  WPLoginViewController.m
//  techmarket
//
//  Created by jing zhao on 7/12/13.
//
//

#import <ApplicationUnity/ASIFormDataRequest.h>

#import <ApplicationUnity/KGStatusBar.h>

#import "WPLoginViewController.h"

#import "WPFindPasswordViewController.h"

#import "WPNetKey.h"

#define KUILoginViewController_ScrollViewOffset     180

#define KUILoginViewController_Password             @"password"

#define KUILoginViewController_UserName             @"userName"



@interface WPLoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIScrollView *ui_scrollView;
@property (unsafe_unretained,nonatomic)id<WpLoginViewDelegate> loginDelegate;
@property (strong, nonatomic) ASIHTTPRequest *asiHttpRequest;



@end

@implementation WPLoginViewController


-(void)setDelegate:(id<WpLoginViewDelegate>)_delegate
{
    self.loginDelegate =_delegate;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self _addListenKeyBoard];
    
    [self.userName becomeFirstResponder];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
}

- (void)viewDidUnload {
    [self setUserName:nil];
    [self setPassword:nil];
    [self setUi_scrollView:nil];
    [super viewDidUnload];
}

/**************************************************************************************/


#pragma mark -
#pragma mark internal
#pragma mark -


/**************************************************************************************/

-(void)_addListenKeyBoard
{
    //键盘
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(_observerKeyboardWasShown:)
												 name:UIKeyboardWillShowNotification
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(_observerkeyboardWasHidden:)
												 name:UIKeyboardWillHideNotification
											   object:nil];
}

//移除监听

- (void) _removeListenKeyBoard
{
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIKeyboardWillShowNotification
												  object:nil];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIKeyboardWillHideNotification
												  object:nil];
}

//当键盘出现的时候

- (void) _observerKeyboardWasShown:(NSNotification *)_notificationInfo
{
    [UIView beginAnimations:nil
                    context:nil];
    [UIView setAnimationDuration:0.3];
    [self.ui_scrollView setContentOffset:CGPointMake(0, KUILoginViewController_ScrollViewOffset)];
    [UIView commitAnimations];
}

//键盘隐藏的时候

-(void)_observerkeyboardWasHidden:(NSNotification *)_notificationInfo
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [self.ui_scrollView setContentOffset:CGPointMake(0, 0)];
    [UIView commitAnimations];
}

//alert Show

-(void)_alertViewWithTitle:(NSString*)_strtitle
               withMessage:(NSString*)_message
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:_strtitle
                                                   message:_message
                                                  delegate:nil
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:nil];
    [alert show];
}

/**************************************************************************************/


#pragma mark -
#pragma mark netservice
#pragma mark -


/**************************************************************************************/

-(void)_netserviceUserLoginWithUserName:(NSString*)paramUserName
                            andPassword:(NSString*)paramPassWord
{
    
    NSString *stringUrl = @"http://market.xayoudao.com/apiproxy.php?action=userLoginToken";
    
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:stringUrl]];
    
    _asiHttpRequest = request;
    
    [request setRequestMethod:@"POST"];
    
    [request setPostValue:paramUserName forKey:KUILoginViewController_UserName];
    
    [request setPostValue:paramPassWord forKey:KUILoginViewController_Password];
    
    [request setCompletionBlock:^{
        
        NSError *error = nil;
        
        NSData *dataApp = [_asiHttpRequest responseData];
        
        //解析appstore数据
        NSDictionary *dicApp = [NSJSONSerialization JSONObjectWithData:dataApp
                                                               options:kNilOptions
                                                                 error:&error];
        if (error)
        {
            NSLog(@"数据解析错误");
            
            [self _alertViewWithTitle:@"登陆失败"
                          withMessage:@"由于网路原因，登陆失败请重试"];
        }
        else
        {
            NSLog(@"%@",dicApp);
            
            NSString *strNetKeyCode = [dicApp objectForKey:WPNetKeyCode];
            
            if ([strNetKeyCode intValue] == 0)
            {
                [KGStatusBar showSuccessWithStatus:@"登陆成功"];
                
                [self dismissModalViewControllerAnimated:YES];
            }
            
            else
            {
                NSString *strNetMessage = [dicApp objectForKey:WPNetKeyMessage];
                
                [self _alertViewWithTitle:@"登录失败"
                              withMessage:strNetMessage];
                
            }
            
            [self.loginDelegate delegateWithLoginSuccess];
        }
        
        
        
    }];
    
    [request  setFailedBlock:^{
        
        [self _alertViewWithTitle:@"登陆失败"
                      withMessage:@"由于网路原因，登陆失败请重试"];
        
    }];
    
    [request startAsynchronous];
    
}

/**************************************************************************************/


#pragma mark -
#pragma mark UITextFieldDelegate
#pragma mark -


/**************************************************************************************/

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _userName)
    {
        [_password becomeFirstResponder];
    }
    else
    {
        [_password resignFirstResponder];
    }
    return (YES);
}

/**************************************************************************************/


#pragma mark -
#pragma mark ON_button
#pragma mark -


/**************************************************************************************/

- (IBAction)onShow:(id)sender
{
	[self _removeListenKeyBoard];
	
	//判断textField是否正在编辑模式
	if (self.password.editing)
	{
		//在锁定模式下 不可更换密码样式 所以：
        [self.password resignFirstResponder];
        self.password.secureTextEntry	=	!self.password.secureTextEntry;
        [self.password becomeFirstResponder];
 	}
	else
	{
        self.password.secureTextEntry	=	!self.password.secureTextEntry;
	}
	
	[self _addListenKeyBoard];
}


- (IBAction)onFind:(id)sender
{
    
    WPFindPasswordViewController *findPassWord = [[WPFindPasswordViewController alloc]initWithNibName:@"WPFindPasswordViewController"
                                                                                               bundle:nil];
    
    [self presentModalViewController:findPassWord animated:YES];
    
}


- (IBAction)onLogin:(id)sender
{
    if ([self.userName.text length]<  2 || [self.userName.text length] >10 )
	{
		if ([self.userName.text length] == 0)
		{
            [self _alertViewWithTitle:@"信息" withMessage:@"用户名不得为空"];
			return;
		}
        [self _alertViewWithTitle:@"信息" withMessage:@"用户名在2-10字数之间"];
	}
    else if ([self.password.text length]<  5 || [self.password.text length] >10 )
    {
        if ([self.password.text length] == 0)
        {
            [self _alertViewWithTitle:@"信息" withMessage:@"密码不得为空"];
            return;
        }
        [self _alertViewWithTitle:@"信息" withMessage:@"密码在5-10字数之间"];
    }
    else
    {
        [self _netserviceUserLoginWithUserName:self.userName.text
                                   andPassword:self.password.text];
        
    }
}


- (IBAction)onRegist:(id)sender
{
    [self.loginDelegate delegateWithRegist];
}


@end
