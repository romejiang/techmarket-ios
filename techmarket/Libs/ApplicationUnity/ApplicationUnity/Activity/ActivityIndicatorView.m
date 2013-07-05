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
@property (strong, nonatomic) UILabel                 *label;

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
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 46, self.frame.size.width, 30)];
        _label.hidden = NO;
        [_label setBackgroundColor:[UIColor clearColor]];
        _label.text = @"";
        _label.font = [UIFont systemFontOfSize:12];
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = UITextAlignmentCenter;
        [self addSubview:_label];
        
        self.hidden = YES;
        [_largeActivity stopAnimating];
    }
    return self;
}

-(void)setLabelTextWithContent:(NSString*)labelText
{
    _label.text =labelText;
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
