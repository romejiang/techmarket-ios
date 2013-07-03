//
//  TabBarViewController.m
//  techmarket
//
//  Created by jing zhao on 7/2/13.
//
//


#define kTabBarHeight								60
#import "TabBarViewController.h"
#import "TabbarView.h"
#import <Cordova/CDVViewController.h>

@interface TabBarViewController ()<tabbarDelegate>

@property(strong,nonatomic)TabbarView *  tabBarView;
@property (strong,nonatomic)NSArray *    arrayViewController;
@property (strong,nonatomic)CDVViewController *firstViewController;
@property (strong, nonatomic)CDVViewController *secondViewController;

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
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarHidden = NO;

//     [self willRotateToInterfaceOrientation:self.interfaceOrientation duration:0];
    [self willRotateToInterfaceOrientation:self.interfaceOrientation duration:0];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //customView init
    _customView = [[UIView alloc]init];
    
    [self.view addSubview:_customView];
        
    //tabBarView init
    _tabBarView = [[TabbarView alloc]init];
        
    _tabBarView.delegate = self;
    
    [_customView addSubview:_tabBarView];
    
    [self getViewControllers];
    
    for (UIViewController * viewController in _arrayViewController)
    {
        [_customView insertSubview:viewController.view belowSubview:_tabBarView];
    }
    
    [self touchBtnAtIndex:0];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
      
}



-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //位置调整 （ViewAppear中调用过）
    
    int width  = 0;
    
    int height = 0;
    
    CGSize sizeDevice = [UIScreen mainScreen].bounds.size;
    
//    //横屏判断
//    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation))
//    {
        width = sizeDevice.width;
        
        height = sizeDevice.height;
//    }
//    else if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
//    {
//       width = sizeDevice.height;
//       
//       height = sizeDevice.width;
//    }

    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
   
    _customView.frame = CGRectMake(0, 0, width, height);
    
    _tabBarView.frame = CGRectMake(0, height-20 -kTabBarHeight, width, kTabBarHeight);
    
    for (UIViewController *viewConroller in _arrayViewController)
    {
        viewConroller.view.frame = CGRectMake(0, 0, width, height-kTabBarHeight-20);
        
        NSLog(@"viewConroller.view.frame.origin.y = %1.2f",viewConroller.view.frame.origin.y);
    
    }
    

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
#pragma mark 私有 初始化Controller
#pragma mark -

/**************************************************************************************/

-(void)getViewControllers
{
    _firstViewController = [CDVViewController new];
    _firstViewController.wwwFolderName = @"www";
    _firstViewController.startPage = @"spec.html";
    _firstViewController.useSplashScreen = NO;
//    _firstViewController.view.frame = CGRectMake(0, 0, 320, 480);
    
    _secondViewController = [CDVViewController new];
    _secondViewController.wwwFolderName = @"www";
    _secondViewController.startPage = @"index.html";
    _secondViewController.useSplashScreen = NO;
//    _secondViewController.view.frame = CGRectMake(0, 0, 320, 480);
    
    _arrayViewController = [NSArray arrayWithObjects:_firstViewController,_secondViewController,_firstViewController,_secondViewController, nil];
    
}

@end
