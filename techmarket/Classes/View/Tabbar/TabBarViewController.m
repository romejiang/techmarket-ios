//
//  TabBarViewController.m
//  techmarket
//
//  Created by jing zhao on 7/2/13.
//
//

#import "TabBarViewController.h"
#import "TabbarView.h"
#import <Cordova/CDVViewController.h>

@interface TabBarViewController ()<tabbarDelegate>

@property(strong,nonatomic)TabbarView *  tabBarView;
@property (strong,nonatomic)NSArray *    arrayViewController;
@property (strong,nonatomic)CDVViewController *firstViewController;
@property (strong, nonatomic)CDVViewController *secondViewController;


@end

@implementation TabBarViewController

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
    
    
    _tabBarView = [[TabbarView alloc]initWithFrame:CGRectMake(0, 420, 320, 60)];
    
    _tabBarView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    _tabBarView.delegate = self;
    
    [self.view addSubview:_tabBarView];
    
    [self getViewControllers];
    
    for (UIViewController * viewController in _arrayViewController)
    {
        [self.view insertSubview:viewController.view belowSubview:_tabBarView];
    }
    
    [self touchBtnAtIndex:0];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}


-(void)touchBtnAtIndex:(NSInteger)index
{
    for (UIViewController *viewController in _arrayViewController)
    {
        viewController.view.hidden = YES;
    }
    
    UIViewController *viewTouchController = [_arrayViewController objectAtIndex:index];
    viewTouchController.view.hidden = NO;
 }


-(void)getViewControllers
{
    _firstViewController = [CDVViewController new];
    _firstViewController.wwwFolderName = @"www";
    _firstViewController.startPage = @"spec.html";
    _firstViewController.useSplashScreen = NO;
    _firstViewController.view.frame = CGRectMake(0, 0, 320, 480);
    
    _secondViewController = [CDVViewController new];
    _secondViewController.wwwFolderName = @"www";
    _secondViewController.startPage = @"index.html";
    _secondViewController.useSplashScreen = NO;
    _secondViewController.view.frame = CGRectMake(0, 0, 320, 480);
    
    _arrayViewController = [NSArray arrayWithObjects:_firstViewController,_secondViewController,_firstViewController,_secondViewController, nil];
    
//    aaViewController *aa = [[aaViewController alloc]init];
//    aa.view.frame = CGRectMake(0, 0, 320, 480);
//    
//    bbViewController *bb = [[bbViewController alloc]init];
//    bb.view.frame =CGRectMake(0, 0, 320, 480);
//    ccViewController *cc = [[ccViewController alloc]init];
//    cc.view.frame = CGRectMake(0, 0, 320, 480);
    
//    _arrayViewController = [NSArray arrayWithObjects:aa,bb,cc,cc, nil];
    
}

@end
