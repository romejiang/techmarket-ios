//
//  ActivityIndicatorView.m
//  ApplicationUnity
//
//  Created by jing zhao on 7/4/13.
//  Copyright (c) 2013 youdao. All rights reserved.
//

#define CustomActivity_ActivityIndicatorFrame CGRectMake(31, 32, 37, 37)

#import <QuartzCore/QuartzCore.h>
#import "ActivityIndicatorView.h"

@interface ActivityIndicatorView ()

@property (strong, nonatomic) UIActivityIndicatorView *largeActivity;

@end



@implementation ActivityIndicatorView

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
        _largeActivity = [[UIActivityIndicatorView alloc]initWithFrame:CustomActivity_ActivityIndicatorFrame];
        _largeActivity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [self addSubview:_largeActivity];
    }
    return self;
}

-(void)stopAnimation
{
    [_largeActivity stopAnimating];
}

-(void)stapAnimation
{
    [_largeActivity stopAnimating];
}


@end
