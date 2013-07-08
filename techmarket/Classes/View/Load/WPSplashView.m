//
//  WPSplashView.m
//  techmarket
//
//  Created by jing zhao on 7/8/13.
//
//

#import "WPSplashView.h"
#import <Cordova/CDVAvailability.h>


@interface WPSplashView ()

@property (strong, nonatomic)UIActivityIndicatorView*   activityView;
@property (strong, nonatomic) UIImage*                  imageSplash;
@property (assign, nonatomic) CGRect                    rectImage;

@end

@implementation WPSplashView



#pragma mark -
#pragma mark- 初始化
#pragma mark -


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        _imageSplash = [self _updateImage];
        
        //image of imageView
        self.image = _imageSplash;
        
        _rectImage = [self _updateBounds];
        
        [self _addActivityViewWithImageBounds:_rectImage.size];
    }
    
    return self;
}



#pragma mark -
#pragma mark 外部调用
#pragma mark -

-(CGRect)boundsSize
{
    
    return _rectImage;
}

#pragma mark -
#pragma mark 私有
#pragma mark -

/*
根据图片计算View大小
*/

-(CGRect)_updateBounds
{
    if (!_imageSplash)
    {
        _imageSplash = [self _updateImage];
    }
    
    CGRect imgBounds = CGRectMake(0, 0, _imageSplash.size.width, _imageSplash.size.height);
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    if (CGSizeEqualToSize(screenSize, imgBounds.size)) {
        
        CGRect statusFrame = [UIApplication sharedApplication].statusBarFrame;
        
        imgBounds.origin.y -= statusFrame.size.height;
    }
     
    return imgBounds;
}


/*
 添加activity
 */

-(void)_addActivityViewWithImageBounds:(CGSize)imageSize
{
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    _activityView.center = CGPointMake(imageSize.width / 2, imageSize.height / 2);
    
    _activityView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin
    | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
   
    [_activityView startAnimating];
    
    [self addSubview:_activityView];
}

/*
 选择适当的图片
*/
- (UIImage *)_updateImage
{
    // Use UILaunchImageFile if specified in plist.  Otherwise, use Default.
    NSString* imageName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UILaunchImageFile"];
    
    if (imageName)
    {
        imageName = [imageName stringByDeletingPathExtension];
    }
    else
    {
        imageName = @"Default";
    }
    
    if (CDV_IsIPhone5())
    {
        imageName = [imageName stringByAppendingString:@"-568h"];
    }
    else if (CDV_IsIPad())
    {
        imageName = [imageName stringByAppendingString:@"-Portrait"];

    }
     UIImage * img = [UIImage imageNamed:imageName];
    
    return img;
}

@end
