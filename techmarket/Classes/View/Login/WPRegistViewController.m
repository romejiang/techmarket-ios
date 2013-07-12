//
//  WPRegistViewController.m
//  techmarket
//
//  Created by jing zhao on 7/12/13.
//
//

#import "WPRegistViewController.h"

@interface WPRegistViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *ui_textFieldUserName;
@property (weak, nonatomic) IBOutlet UITextField *ui_textFieldPhone;
@property (weak, nonatomic) IBOutlet UITextField *ui_passWord;
@property (weak, nonatomic) IBOutlet UITextField *ui_againPassword;

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setUi_textFieldUserName:nil];
    [self setUi_textFieldPhone:nil];
    [self setUi_passWord:nil];
    [self setUi_againPassword:nil];
}


/**************************************************************************************/

#pragma mark -
#pragma mark 私有
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
    //    [self.ui_scrollView setContentOffset:CGPointMake(0, KUILoginViewController_ScrollViewOffset)];
    [UIView commitAnimations];
}

/*
 键盘隐藏的时候
*/
-(void)_observerkeyboardWasHidden:(NSNotification *)_notificationInfo
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
//    [self.ui_scrollView setContentOffset:CGPointMake(0, 0)];
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

/**************************************************************************************/

#pragma mark -
#pragma mark button
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
        [self.ui_textFieldPhone becomeFirstResponder];
    }
    else if (textField == self.ui_passWord)
    {
        [self.ui_againPassword becomeFirstResponder];
    }
    else
    {
        [self.ui_againPassword resignFirstResponder];
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
    if ([self.ui_textFieldUserName.text length]<  6 || [self.ui_textFieldUserName.text length] >15 )
	{
		if ([self.ui_textFieldUserName.text length] == 0)
		{
            [self _alertViewWithTitle:@"信息" withMessage:@"用户名不得为空"];
			return;
		}
        [self _alertViewWithTitle:@"信息" withMessage:@"用户名在6-15字数之间"];
	}
    else if ([self.ui_textFieldPhone.text length]<  11  )
	{
		[self _alertViewWithTitle:@"信息" withMessage:@"手机号码位数不全"];
	}
    else if ([self _isTelePhone])
    {
            [self _alertViewWithTitle:@"信息" withMessage:@"请确定手机格式正确"];
    }
    else if ([self.ui_passWord.text length]<  6 || [self.ui_passWord.text length] >15 )
	{
		if ([self.ui_passWord.text length] == 0)
		{
            [self _alertViewWithTitle:@"信息" withMessage:@"密码不得为空"];
			return;
		}
        [self _alertViewWithTitle:@"信息" withMessage:@"密码在6-15字数之间"];
	}
    else if ([self.ui_passWord.text isEqualToString:self.ui_againPassword.text])
	{

        [self _alertViewWithTitle:@"信息" withMessage:@"确认密码必须与密码相同"];
	}
    else
    {
    }
    
    
}

- (IBAction)onCacell:(id)sender
{
    
}

@end
