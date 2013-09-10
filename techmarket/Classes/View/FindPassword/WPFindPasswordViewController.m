//
//  WPFindPasswordViewController.m
//  techmarket
//
//  Created by jing zhao on 8/29/13.
//
//
#import <ApplicationUnity/ASIFormDataRequest.h>

#import <ApplicationUnity/KGStatusBar.h>

#import "WPFindPasswordViewController.h"

#import "WPNetKey.h"


#define WPFindPasswordViewController_findType  @"findType"

#define WPFindPasswordViewController_findNumber @"findNumber"

@interface WPFindPasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *ui_textField;

@property (weak, nonatomic) IBOutlet UIButton *ui_buttonFindPassword;

@property (weak, nonatomic) IBOutlet UIButton *ui_buttonBack;

@property (strong, nonatomic) ASIHTTPRequest *asiHttpRequest;

@end

@implementation WPFindPasswordViewController

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
    [self setUi_textField:nil];
    [self setUi_buttonFindPassword:nil];
    [self setUi_buttonBack:nil];
    [super viewDidUnload];
}

/**************************************************************************************/


#pragma mark -
#pragma mark inter
#pragma mark -


/**************************************************************************************/

/*
 电话号码
 */
-(BOOL)_isTelePhone
{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^(1(([35][0-9])|(47)|[8][01236789]))\\d{8}$"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    NSUInteger numberofMatches = [regex numberOfMatchesInString:self.ui_textField.text
                                                        options:0
                                                          range:NSMakeRange(0, [self.ui_textField.text length])];
    
    if (numberofMatches >0)
    {
        return YES;
    }
    
    return NO;
}

/*
 邮箱
 */

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

-(void)_netserviceUserLoginWithFindType:(NSString*)paramFindType
                          andFindNumber:(NSString*)paramFindNumber
{
    NSString *stringUrl = @"http://market.xayoudao.com/apiproxy.php?action=backPassword";
    
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:stringUrl]];
     
    _asiHttpRequest = request;
    
    [request setRequestMethod:@"POST"];
    
    [request setPostValue:paramFindType forKey:WPFindPasswordViewController_findType];
    
    [request setPostValue:paramFindNumber forKey:WPFindPasswordViewController_findNumber];
    
    [request setCompletionBlock:^{
        
        NSError *error = nil;
        
        NSData *dataApp = [_asiHttpRequest responseData];
        
        NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:dataApp
                                                                     options:kNilOptions
                                                                       error:&error];
        
        if (error)
        {
            NSLog(@"数据解析错误");
            
            [self _alertViewWithTitle:@"找回密码失败"
                          withMessage:@"由于网路原因，找回密码失败请重试"];
        }
        
        else
        {
            NSDictionary *dicRoot = [dictResponse objectForKey:WPNetKeyRoot];
            
            NSString *strCode = [dicRoot objectForKey:WPNetKeyCode];
            
            if ([strCode intValue] == 0)
            {
                [KGStatusBar showSuccessWithStatus:@"找回密码成功"];
                
                [self dismissModalViewControllerAnimated:YES];
            }
            else
            {
                NSString *strNetMessage = [dicRoot objectForKey:WPNetKeyMessage];
                
                [self _alertViewWithTitle:@"找回密码失败"
                              withMessage:strNetMessage];
                
            }
            
        }
    }];
    
    [request  setFailedBlock:^{
        
        [self _alertViewWithTitle:@"找回密码失败"
                      withMessage:@"由于网路原因，找回密码失败请重试"];
        
    }];
    
    [request startAsynchronous];
}


/**************************************************************************************/


#pragma mark -
#pragma mark netservice
#pragma mark -


/**************************************************************************************/

- (IBAction)onButtonLoginTap:(id)sender
{
    if ([self.ui_textField.text isEqualToString:@""])
    {
        [self _alertViewWithTitle:@"消息"
                      withMessage:@"输入的用户名和邮箱不能为空"];
    }
    else if ([self _isTelePhone])
    {
        //电话号码
        [self _netserviceUserLoginWithFindType:@"2" andFindNumber:self.ui_textField.text];
    }
    else if ([self _isValidEmailAddress:self.ui_textField.text])
    {
        //邮箱
        [self _netserviceUserLoginWithFindType:@"1" andFindNumber:self.ui_textField.text];
    }
    else
    {
        [self _alertViewWithTitle:@"消息"
                      withMessage:@"你登陆的用户名或者邮箱格式不正确"];
    }
    
}

- (IBAction)onButtonBack:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}


@end
