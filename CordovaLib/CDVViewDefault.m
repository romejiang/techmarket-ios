//
//  CDVViewDefault.m
//  CordovaLib
//
//  Created by jing zhao on 9/23/13.
//
//

#import "CDVViewDefault.h"

@interface CDVViewDefault ()

@property(strong, nonatomic)UIImageView *imageView;
@property (strong, nonatomic) UIActivityIndicatorView *largeActivity;

@end


@implementation CDVViewDefault

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self _initDefaultViewwithFrame:frame];
    }
    return self;
}

-(void)_initDefaultViewwithFrame:(CGRect)frame
{
    //UIImageView
    _imageView = [[UIImageView alloc]initWithFrame:frame];
   
    [_imageView setImage:[UIImage imageNamed:@"Default.png"]];
    
    [self addSubview:_imageView];

    //activityIndicatorView
    _largeActivity  = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    _largeActivity.center = CGPointMake(frame.size.width/2, 200);
    
    [self addSubview:_largeActivity];
    
    [_largeActivity startAnimating];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
