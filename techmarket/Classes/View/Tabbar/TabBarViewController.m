//
//  TabBarViewController.m
//  techmarket
//
//  Created by jing zhao on 7/2/13.
//
//


#define kTabBarHeight								60

#import <QuartzCore/QuartzCore.h>
#import <Cordova/CDVViewController.h>
#import <NSLog/NSLog.h>
#include <ApplicationUnity/ActivityIndicatorView.h>

#import "NSBundle+Image.h"
#import "TabBarViewController.h"
#import "TabbarView.h"
#import "WPHelpView.h"
#import "WPSplashView.h"

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
    
//    [self showSplashView];
//
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
        
        NSLog(@"viewConroller.view.frame.origin.y = %1.2f",viewConroller.view.frame.origin.y);
    }
}


- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


/**************************************************************************************/

#pragma mark -
#pragma mark tabbarDelegate
#pragma mark -

/**************************************************************************************/

-(void)touchBtnAtIndex:(NSInteger)index
{
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
    _firstViewController.wwwFolderName = @"www";
    _firstViewController.startPage = @"index.html";
    
    _secondViewController = [CDVViewController new];
    _secondViewController.wwwFolderName = @"qj";
    _secondViewController.startPage = @"index.html";
    
    _thirdViewController = [CDVViewController new];
    _thirdViewController.wwwFolderName = @"mec";
    _thirdViewController.startPage = @"index.html";
    
    _FourViewController = [CDVViewController new];
    _FourViewController.wwwFolderName = @"va";
    _FourViewController.startPage = @"index.html";
    
    _FiveViewController = [CDVViewController new];
    _FiveViewController.wwwFolderName = @"yu";
    _FiveViewController.startPage =@"index.html";
    
    _arrayViewController = [NSArray arrayWithObjects:_firstViewController,_secondViewController,_thirdViewController,_FourViewController,_FiveViewController, nil];
    
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

///*
// 显示SplashView
// */
//
//-(void)showSplashView
//{
//    WPSplashView *splash = [[WPSplashView alloc]initWithFrame:[UIScreen mainScreen].bounds];
//
//    //根据图片调整frame
//    [splash setFrame:[splash boundsSize]];
//    
//    [self.view addSubview:splash];
//}


@end
