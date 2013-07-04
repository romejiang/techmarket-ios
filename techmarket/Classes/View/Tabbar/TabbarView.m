//
//  TabbarView.m
//  TabBar
//
//  Created by jing zhao on 7/2/13.
//  Copyright (c) 2013 youdao. All rights reserved.
//

#define TabbarView_TabBarViewFrame       CGRectMake(0, 9, 320, 51)
#import "TabbarView.h"



@interface TabbarView ()

@property(nonatomic,strong) UIImageView *tabbarView;
@property(nonatomic,strong) UIImageView *tabbarViewCenter;
@property(nonatomic,strong) UIButton *button_1;
@property(nonatomic,strong) UIButton *button_2;
@property(nonatomic,strong) UIButton *button_3;
@property(nonatomic,strong) UIButton *button_4;
@property(nonatomic,strong) UIButton *button_center;

@end

@implementation TabbarView


-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self _layoutView];


}

-(id)init
{
    self = [super init];
    
    if (self)
    {
        [self _addSubviewInTabBarView];
    }
    return self;
}


/*
 addSubview
 */

-(void)_addSubviewInTabBarView
{
    //tabBarView 外页面
    _tabbarView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tabbar_0.png"]];
    [_tabbarView setUserInteractionEnabled:YES];
    [self addSubview:_tabbarView];
    
    //button1
    _button_1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_1 setTag:0];
    [_button_1 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
     [_tabbarView addSubview:_button_1];
    
    //button2
    _button_2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_2 setTag:1];
    [_button_2 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    [_tabbarView addSubview:_button_2];
    
    //buttonCenter
    _button_center = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_center setTag:2];
    [_button_center setBackgroundImage:[UIImage imageNamed:@"tabbar_mainbtn"] forState:UIControlStateNormal];
    [_button_center addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_button_center];
    
    //button3
    _button_3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_3 setTag:3];
    [_button_3 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    [_tabbarView addSubview:_button_3];
    
    //button4
    _button_4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_4 setTag:4];
    [_button_4 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    [_tabbarView addSubview:_button_4];
}

/*
 layout
 */
-(void)_layoutView
{
    [_tabbarView setFrame:CGRectMake(TabbarView_TabBarViewFrame.origin.x, TabbarView_TabBarViewFrame.origin.y, self.frame.size.width, TabbarView_TabBarViewFrame.size.height)];

    [_button_1 setFrame:CGRectMake(0, 0, 64, 60)];
    
    [_button_2 setFrame:CGRectMake(65, 0, 64, 60)];
    
    [_button_3 setFrame:CGRectMake(202, 0, 64, 60)];
    
    [_button_4 setFrame:CGRectMake(267, 0, 64, 60)];
    
    [_button_center setFrame:CGRectMake(0, 0, 46, 46)];
    
    _button_center.center = CGPointMake(self.center.x, self.bounds.size.height/2.0);

}


-(void)btn1Click:(id)sender
{
     UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 0:
        {
            [_tabbarView setImage:[UIImage imageNamed:@"tabbar_0"]];
            [self.delegate touchBtnAtIndex:0];
            
            break;
        }
        case 1:
        {
            [_tabbarView setImage:[UIImage imageNamed:@"tabbar_1"]];
            [self.delegate touchBtnAtIndex:1];
            break;
        }
        case 2:
        {
            [_tabbarView setImage:[UIImage imageNamed:@"tabbar_0"]];
            [self.delegate touchBtnAtIndex:2];
            break;
        }
        case 3:
            [_tabbarView setImage:[UIImage imageNamed:@"tabbar_3"]];
            [self.delegate touchBtnAtIndex:3];
            break;
        case 4:
            [_tabbarView setImage:[UIImage imageNamed:@"tabbar_4"]];
            
            [self.delegate touchBtnAtIndex:4];
            break;
        default:
            break;
    }
}

@end
