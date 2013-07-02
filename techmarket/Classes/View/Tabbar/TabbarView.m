//
//  TabbarView.m
//  TabBar
//
//  Created by jing zhao on 7/2/13.
//  Copyright (c) 2013 youdao. All rights reserved.
//

#import "TabbarView.h"

@implementation TabbarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setFrame:frame];
        [self layoutView];
    }
    return self;
}


-(void)layoutView
{
    //tabBarView 外页面
    _tabbarView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tabbar_0.png"]];
    
    [_tabbarView setFrame:CGRectMake(0, 9, 320, 51)];
    
    [_tabbarView setUserInteractionEnabled:YES];
     
    [self addSubview:_tabbarView];
        
    [self layoutBtn];
  }

-(void)layoutBtn
{
    _button_1 = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [_button_1 setBackgroundColor:[UIColor blueColor]];
    [_button_1 setFrame:CGRectMake(0, 0, 64, 60)];
    [_button_1 setTag:1];
    [_button_1 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    
    _button_2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_2 setFrame:CGRectMake(65, 0, 64, 60)];
    [_button_2 setTag:2];
    [_button_2 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    
    _button_3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_3 setFrame:CGRectMake(202, 0, 64, 60)];
    [_button_3 setTag:3];
    [_button_3 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    
    _button_4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_4 setFrame:CGRectMake(267, 0, 64, 60)];
    [_button_4 setTag:4];
    [_button_4 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    
    [_tabbarView addSubview:_button_1];
    [_tabbarView addSubview:_button_2];
    [_tabbarView addSubview:_button_3];
    [_tabbarView addSubview:_button_4];
    
    //buttonCenter
    
    _button_center = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_center setBackgroundImage:[UIImage imageNamed:@"tabbar_mainbtn"] forState:UIControlStateNormal];
    [_button_center setFrame:CGRectMake(0, 0, 46, 46)];
    _button_center.center =CGPointMake(self.center.x, self.bounds.size.height/2.0);
    [self addSubview:_button_center];
}

-(void)btn1Click:(id)sender
{
     UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 1:
        {
            [_tabbarView setImage:[UIImage imageNamed:@"tabbar_0"]];
            [self.delegate touchBtnAtIndex:0];
            
            break;
        }
        case 2:
        {
            [_tabbarView setImage:[UIImage imageNamed:@"tabbar_1"]];
            [self.delegate touchBtnAtIndex:1];
            break;
        }
        case 3:
            [_tabbarView setImage:[UIImage imageNamed:@"tabbar_3"]];
            [self.delegate touchBtnAtIndex:2];
            break;
        case 4:
            [_tabbarView setImage:[UIImage imageNamed:@"tabbar_4"]];
            
            [self.delegate touchBtnAtIndex:3];
            break;
        default:
            break;
    }
}

@end
