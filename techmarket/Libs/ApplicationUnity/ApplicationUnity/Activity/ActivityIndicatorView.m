//
//  ActivityIndicatorView.m
//  ApplicationUnity
//
//  Created by jing zhao on 7/4/13.
//  Copyright (c) 2013 youdao. All rights reserved.
//

#define CustomActivity_ActivityIndicatorFrame CGRectMake(21, 10, 37, 37)

#import <QuartzCore/QuartzCore.h>
#import "ActivityIndicatorView.h"

@interface ActivityIndicatorView ()

@property (strong, nonatomic) UIActivityIndicatorView *largeActivity;

@end



@implementation ActivityIndicatorView

/***********************************************************************************/

#pragma mark -
#pragma mark 私有
#pragma mark -

/**************************************************************************************/


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
    }
    return self;
}

-(void)setLabelTextWithContent:(NSString*)labelText
{
    
    //view
    [self setBackgroundColor:[UIColor blackColor]];
    [self setAlpha:0.5];
    self.layer.cornerRadius = 10;
    
    //缓冲
    CGFloat largeActivityOriginX = (self.frame.size.width - CustomActivity_ActivityIndicatorFrame.size.width)/2;
    _largeActivity = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(largeActivityOriginX, CustomActivity_ActivityIndicatorFrame.origin.y, CustomActivity_ActivityIndicatorFrame.size.width, CustomActivity_ActivityIndicatorFrame.size.height)];
    _largeActivity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [self addSubview:_largeActivity];
    
    
    //label
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 46, self.frame.size.width, 30)];
    label.hidden = NO;
    [label setBackgroundColor:[UIColor clearColor]];
    label.text = labelText;
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = UITextAlignmentCenter;
    [self addSubview:label];
  
}

/***********************************************************************************/

#pragma mark -
#pragma mark 私有
#pragma mark -

/**************************************************************************************/

-(void)stopAnimation
{
    [_largeActivity stopAnimating];
    self.hidden = YES;
}

-(void)startAnimation
{
    [_largeActivity startAnimating];
    self.hidden = NO;
}

@end
