//
//  WPRegistViewController.m
//  techmarket
//
//  Created by jing zhao on 7/12/13.
//
//

#import "WPRegistViewController.h"

#import "WPNetKey.h"

#import <ApplicationUnity/KGStatusBar.h>

#import <ApplicationUnity/ASIFormDataRequest.h>

#define KUIRegistViewController_ScrollViewOffset 130

@interface WPRegistViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *ui_textFieldUserName;

@property (weak, nonatomic) IBOutlet UITextField *ui_textFieldEmail;

@property (weak, nonatomic) IBOutlet UITextField *ui_textFieldPhone;

@property (weak, nonatomic) IBOutlet UITextField *ui_passWord;

@property (weak, nonatomic) IBOutlet UIScrollView *ui_scrollView;

@property (strong, nonatomic) ASIHTTPRequest *asiHttpRequest;

@end

@implementation WPRegistViewController

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
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload
{
    [self setUi_scrollView:nil];
    [self setUi_textFieldEmail:nil];
    [self setUi_textFieldUserName:nil];
    [self setUi_textFieldPhone:nil];
    [self setUi_passWord:nil];
    [super viewDidUnload];
}

/**************************************************************************************/

#pragma mark -
#pragma mark 私有
#pragma mark -

/**************************************************************************************/


-(void)_netserviceUserLoginWithUserCode:(NSString*)paramUserCode
                            andUserPwd:(NSString*)paramPWd
                               andEmai:(NSString*)paramEmail
                              andMobil:(NSString*)paramMobile
                        
              
{
    NSString *stringUrl = @"http://market.xayoudao.com/apiproxy.php?action=register";
    
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:stringUrl]];
    
    _asiHttpRequest = request;
    
    [request setRequestMethod:@"POST"];
    
    [request setPostValue:paramUserCode forKey:WPNetKeyRegister_UserCode];
    
    [request setPostValue:paramPWd forKey:WPNetKeyRegister_UserPwd];
    
    [request setPostValue:paramEmail forKey:WPNetKeyRegister_Email];
    
    [request setPostValue:paramMobile forKey:WPNetKeyRegister_Mobile];
    
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
            
            [self _alertViewWithTitle:@"注册失败"
                          withMessage:@"由于网路原因，登陆失败请重试"];
        }
        else
        {
            NSLog(@"%@",dicApp);
            
            NSString *strNetKeyCode = [dicApp objectForKey:WPNetKeyCode];
            
            if ([strNetKeyCode intValue] == 0)
            {
                [KGStatusBar showSuccessWithStatus:@"注册成功"];
                
                [self dismissModalViewControllerAnimated:YES];
            }
            
            else
            {
                NSString *strNetMessage = [dicApp objectForKey:WPNetKeyMessage];
                
                [self _alertViewWithTitle:@"注册失败"
                              withMessage:strNetMessage];
            }
        }
    }];
    
    [request  setFailedBlock:^{
        
        [self _alertViewWithTitle:@"注册失败"
                      withMessage:@"由于网路原因，登陆失败请重试"];
        
    }];
    
    [request startAsynchronous];
    
}


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

/*
移除监听
*/
- (void) _removeListenKeyBoard
{
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIKeyboardWillShowNotification
												  object:nil];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIKeyboardWillHideNotification
												  object:nil];
}

/*
 当键盘出现的时候
 */
- (void) _observerKeyboardWasShown:(NSNotification *)_notificationInfo
{
    [UIView beginAnimations:nil
                    context:nil];
    [UIView setAnimationDuration:0.3];
    [self.ui_scrollView setContentOffset:CGPointMake(0, KUIRegistViewController_ScrollViewOffset)];
    
    [UIView commitAnimations];
}

/*
 键盘隐藏的时候
*/
-(void)_observerkeyboardWasHidden:(NSNotification *)_notificationInfo
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [self.ui_scrollView setContentOffset:CGPointMake(0, 0)];
    [UIView commitAnimations];
}


/*
电话号码
*/
-(BOOL)_isTelePhone
{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^(1(([35][0-9])|(47)|[8][01236789]))\\d{8}$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    NSUInteger numberofMatches = [regex numberOfMatchesInString:self.ui_textFieldPhone.text
                                                        options:0
                                                          range:NSMakeRange(0, [self.ui_textFieldPhone.text length])];
    
    if (numberofMatches >0)
    {
        return YES;
    }
  
    return NO;
}

/*
 alert Show
*/
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


-(BOOL)_isValidEmailAddress:(NSString*) _strEmailAddress
{
	NSString* strRegexEmailPattern = @"\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*";
    
	NSRange range = [_strEmailAddress rangeOfString:strRegexEmailPattern options:NSRegularExpressionSearch];
    
	if (range.location != NSNotFound)
	{
		return YES;
	}
	else
	{
        return(NO);
	}
}

/**************************************************************************************/

#pragma mark -
#pragma mark UITextFieldDelegate
#pragma mark -

/**************************************************************************************/

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.ui_textFieldUserName)
    {
        [self.ui_textFieldPhone becomeFirstResponder];
    }
    else if (textField  == self.ui_textFieldPhone)
    {
        [self.ui_textFieldEmail becomeFirstResponder];
    }
    else
    {
        [self.ui_passWord becomeFirstResponder ];
    }

return (YES);
}

/**************************************************************************************/


#pragma mark -
#pragma mark buttonTouch
#pragma mark -


/**************************************************************************************/

- (IBAction)onRegist:(id)sender
{
    //用户名
     if ([self.ui_textFieldUserName.text length]<  6 || [self.ui_textFieldUserName.text length] >15 )
	{
		if ([self.ui_textFieldUserName.text length] == 0)
		{
            [self _alertViewWithTitle:@"信息" withMessage:@"用户名不得为空"];
			
            return;
		}
        [self _alertViewWithTitle:@"信息" withMessage:@"用户名在6-15字数之间"];
	}
    
    //邮箱
    else if (![self _isValidEmailAddress:self.ui_textFieldEmail.text])
    {
        if ([self.ui_textFieldEmail.text isEqualToString:@""] )
        {
            [self _alertViewWithTitle:@"信息" withMessage:@"邮箱不得为空"];
            
            return;
        }
      
        [self _alertViewWithTitle:@"信息" withMessage:@"邮箱格式不正确"];
    }
    
    //电话号码
    else if ([self.ui_textFieldPhone.text length]<  11  )
	{
		[self _alertViewWithTitle:@"信息" withMessage:@"手机号码位数不全"];
	}
    else if (![self _isTelePhone])
    {
            [self _alertViewWithTitle:@"信息" withMessage:@"请确定手机格式正确"];
    }
    
    //密码
    else if ([self.ui_passWord.text length]<  6 || [self.ui_passWord.text length] >15 )
	{
		if ([self.ui_passWord.text length] == 0)
		{
            [self _alertViewWithTitle:@"信息" withMessage:@"密码不得为空"];
			return;
		}
        [self _alertViewWithTitle:@"信息" withMessage:@"密码在6-15字数之间"];
	}
    
    //网络
    else
    {
        [self _netserviceUserLoginWithUserCode:self.ui_textFieldUserName.text
                                    andUserPwd:self.ui_passWord.text
                                       andEmai:self.ui_textFieldEmail.text
                                      andMobil:self.ui_textFieldPhone.text];
    }
}


- (IBAction)onCacell:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
