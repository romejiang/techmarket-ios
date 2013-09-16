//
//  TabBarViewController.m
//  techmarket
//
//  Created by jing zhao on 7/2/13.
//
//


#define kTabBarHeight								57
#import "Setting.h"

#import <QuartzCore/QuartzCore.h>
#import <Cordova/CDVViewController.h>
#import <NSLog/NSLog.h>
#include <ApplicationUnity/ActivityIndicatorView.h>

#import "NSBundle+Image.h"
#import "TabBarViewController.h"
#import "TabbarView.h"
#import "WPHelpView.h"
#import "WPSplashView.h"
#import "WPLoginViewController.h"
#import "WPRegistViewController.h"

#define CustomActivity_IndicatorViewFrame  CGRectMake(115, 170, 90, 75)

@interface TabBarViewController ()<tabbarDelegate,WPHelpViewDelegate>


@property (strong, nonatomic)WPHelpView*        helpView;
@property (strong, nonatomic)TabbarView *       tabBarView;
@property (strong, nonatomic)NSArray *          arrayViewController;
@property (strong, nonatomic)CDVViewController* firstViewController;
@property (strong, nonatomic)CDVViewController* secondViewController;
@property (strong, nonatomic)CDVViewController* thirdViewController;
@property (strong, nonatomic)CDVViewController* FourViewController;
@property (strong, nonatomic)CDVViewController* FiveViewController;

@property (strong, nonatomic)WPLoginViewController *    loginView;
@property (strong, nonatomic)WPRegistViewController*     regist;
@property (strong, nonatomic)ActivityIndicatorView * activityIndicatorView;

//解决下移问题(存放CDv)
@property (strong,nonatomic)UIView*      customView;

@end

@implementation TabBarViewController

/**************************************************************************************/

#pragma mark -
#pragma mark 公有
#pragma mark -

/**************************************************************************************/

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_pageDidLoadFinish)
                                                     name:CDVPageDidLoadFinishNotification
                                                   object:nil];
        // Custom initialization
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated
{
    

    [self willRotateToInterfaceOrientation:self.interfaceOrientation duration:0];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    //customView init
    _customView = [[UIView alloc]init];
    
    [self.view addSubview:_customView];
        
    [self _showHelpView];
    
    [self debugStart];
    
    //tabBarView init
    _tabBarView = [[TabbarView alloc]init];
    
    _tabBarView.delegate = self;
    
    [_customView addSubview:_tabBarView];
    
    [self getViewControllers];
    
    for (CDVViewController * viewController in _arrayViewController)
    {
        [_customView insertSubview:viewController.view belowSubview:_tabBarView];
        viewController.webView.dataDetectorTypes  = UIDataDetectorTypeNone;
        
    }
    
    //监听登陆结果
    [self _addObserverLoginResult];
    
    [self _addObserverPushNotification];
    
    [self touchBtnAtIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //位置调整 （ViewAppear中调用过）
    
    int width  = 0;
    
    int height = 0;
    
    CGSize sizeDevice = [UIScreen mainScreen].bounds.size;
    
    width = sizeDevice.width;
    
    height = sizeDevice.height;

    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    _customView.frame = CGRectMake(0, 0, width, height);
    
    _tabBarView.frame = CGRectMake(0, height-statusBarHeight -kTabBarHeight, width, kTabBarHeight);
    
    for (UIViewController *viewConroller in _arrayViewController)
    {
        viewConroller.view.frame = CGRectMake(0, 0, width, height-kTabBarHeight-statusBarHeight+9);
        
    }
}


- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(void)viewDidUnload
{
    [self _removeObserverLoginResult];
    
    [self _removeObservePushNotification];
}

/**************************************************************************************/

#pragma mark -
#pragma mark tabbarDelegate
#pragma mark -

/**************************************************************************************/

-(void)touchBtnAtIndex:(NSInteger)index
{
    if (index == 3)
    {
        if (![[NSUserDefaults standardUserDefaults]objectForKey:UserDefaultData])
        {
            [self _showLoginView];
            return;
          }
    }
    //根据用户点击tabbar控制View显示和隐藏
    for (UIViewController *viewController in _arrayViewController)
    {
        viewController.view.hidden = YES;
    }
    
    UIViewController *viewTouchController = [_arrayViewController objectAtIndex:index];
    
    viewTouchController.view.hidden = NO;
}

/**************************************************************************************/

#pragma mark -
#pragma mark WPHelpViewDelegate
#pragma mark -

/**************************************************************************************/

/* 帮助看完了 */
- (void) helpFinished:(WPHelpView *)helpView
{
    [self _hiddenHelpView];
    
    [WPHelpView markHelped:YES];
}

/**************************************************************************************/

#pragma mark -
#pragma mark CDVPageDidLoadFinishNotification
#pragma mark -

/**************************************************************************************/

- (void) _pageDidLoadFinish
{
    [UIApplication sharedApplication].statusBarHidden = NO;
}



/**************************************************************************************/

#pragma mark -
#pragma mark 私有
#pragma mark -

/**************************************************************************************/

-(void)getViewControllers
{
    _firstViewController = [CDVViewController new];
    _firstViewController.wwwFolderName = @"home";
    _firstViewController.startPage = @"index.html";
    
    _secondViewController = [CDVViewController new];
    _secondViewController.wwwFolderName = @"market";
    _secondViewController.startPage = @"index.html";
    
    _thirdViewController = [CDVViewController new];
    _thirdViewController.wwwFolderName = @"innovation";
    _thirdViewController.startPage = @"index.html";
    
    _FourViewController = [CDVViewController new];
    _FourViewController.wwwFolderName = @"mine";
    _FourViewController.startPage = @"index.html";
    
    _FiveViewController = [CDVViewController new];
    _FiveViewController.wwwFolderName = @"more";
    _FiveViewController.startPage =@"index.html";
    
    _arrayViewController = [NSArray arrayWithObjects:_firstViewController,_secondViewController,_thirdViewController,_FourViewController,_FiveViewController, nil];
    
}

/*
 显示登陆界面
 */
-(void)_showLoginView
{
    self.loginView = [[WPLoginViewController alloc]initWithNibName:@"WPLoginViewController" bundle:nil];
    
    [self presentModalViewController:self.loginView animated:YES];
}


/*
 显示帮助
 */
- (void) _showHelpView
{
    // 看过帮助
    if (YES == [WPHelpView helped])
        return ;
    
    // 未启用该插件
    NSArray *imageFils = [[NSBundle mainBundle] picturesWithDirectoryName:@"help"];
    
    
    if ([imageFils count] == 0)
    {
        NSInfo(@"没有帮助图片");
        return;
    }
    
    NSInfo(@"显示帮助信息开始");
    
    if (nil == _helpView)
    {
        _helpView = [[[NSBundle mainBundle] loadNibNamed:@"WPHelpView"
                                                   owner:nil
                                                 options:nil] lastObject];
        
        _helpView.delegate = self;
        
        [self.view insertSubview:_helpView
                    aboveSubview:self.view];
        
    }
    
    _helpView.hidden = NO;
}

/*
 隐藏帮助
 */
- (void) _hiddenHelpView
{
    if (nil == _helpView)
        return;
    
    // - acimation
    CATransition            *transitionC        =   [CATransition animation];
    
    transitionC.duration                        =   0.5f;
    
    transitionC.timingFunction                  =   [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    transitionC.type                            =   kCATransitionFade;
    
    transitionC.subtype                         =   kCATransitionFromRight;
    
    [_helpView.layer addAnimation:transitionC
                           forKey:nil];
    _helpView.hidden = YES;
    
    NSInfo(@"显示帮助信息结束");
}

/*
 添加监听
 */

-(void)_addObserverLoginResult
{
  [[NSNotificationCenter defaultCenter]addObserver:self
                                          selector:@selector(_observerKeyLoginSuccess:)
                                              name:KUILoginViewController_LoginSuccess
                                            object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(_observerKeyLoginFail:)
                                                name:KUILoginViewController_LoginFail
                                              object:nil];

}

/*
移除监听
 */

-(void)_removeObserverLoginResult
{
     [[NSNotificationCenter defaultCenter]removeObserver:self
                                                name:KUILoginViewController_LoginSuccess
                                              object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:KUILoginViewController_LoginFail
                                                 object:nil];

}

-(void)_addObserverPushNotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(_observerkeyPush:)
                                                name:KUINetWork_PushNotification
                                              object:nil];
}


-(void)_removeObservePushNotification
{
 [[NSNotificationCenter defaultCenter]removeObserver:self
                                                name:KUINetWork_PushNotification
                                              object:nil];


}

-(void)_observerkeyPush:(NSNotification*)_notificationInfo
{
    NSDictionary *dicURI = [_notificationInfo userInfo];
    
    NSString  *strPageIndex = [dicURI objectForKey:KUINetWork_Index];
    
    NSString *uri = [dicURI objectForKey:KUINetWork_uri];
    
    NSString *strPage = [dicURI objectForKey:KUINetWork_Name];
    
    NSString *pathResource =  [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@/index.html",strPage] ofType:nil];
    
    NSString* urlResultStr = [NSString stringWithFormat:@"%@%@%@",pathResource,@"?",uri];
    
    NSURL *urlResultRequest = [NSURL fileURLWithPath:urlResultStr];
    
    CDVViewController *viewPage = [_arrayViewController objectAtIndex:[strPageIndex integerValue]];
    
    [viewPage.webView loadRequest:[NSURLRequest requestWithURL:urlResultRequest]];
    
    NSLog(@"[strPage integerValue] = %i",[strPageIndex integerValue]);
    
    NSLog(@"urlResultStr = %@",urlResultStr);
    

    [_tabBarView tapButtonIndex:[strPageIndex integerValue]];
}


-(void)_observerKeyLoginSuccess:(NSNotification*)_notificationInfo
{
    [_tabBarView tapButtonIndex:3];
    
}


-(void)_observerKeyLoginFail:(NSNotification*)_notification
{
   [_tabBarView tapButtonIndex:0];
}


@end
