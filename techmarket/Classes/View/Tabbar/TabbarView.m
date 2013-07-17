//
//  TabbarView.m
//  TabBar
//
//  Created by jing zhao on 7/2/13.
//  Copyright (c) 2013 youdao. All rights reserved.
//

#define TabbarView_TabBarViewFrame       CGRectMake(0, 8, 320, 49)
#import "TabbarView.h"



@interface TabbarView ()

@property(nonatomic,strong) UIImageView *tabbarView;
@property(nonatomic,strong) UIImageView *tabbarViewCenter;
@property(nonatomic,strong) NSArray*  arrayButton;
@property(nonatomic,strong) UIButton *button_0;
@property(nonatomic,strong) UIButton *button_1;
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
    _tabbarView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tabbar_background.png"]];
    [_tabbarView setUserInteractionEnabled:YES];
    [self addSubview:_tabbarView];
    
    //中间那个image
    _tabbarViewCenter = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tabbar_round.png"]];
    [self insertSubview:_tabbarViewCenter aboveSubview:_tabbarView];
    
    //buttonCenter
    _button_center = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_center setTag:2];
    [_button_center setImage:[UIImage imageNamed:@"tabbar_innovation.png"] forState:UIControlStateNormal];
    [_button_center setImage:[UIImage imageNamed:@"tabbar_innovation_down.png"] forState:UIControlStateSelected];
    [_button_center addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
//    [self insertSubview:_button_center aboveSubview:_tabbarViewCenter];
    _tabbarViewCenter.userInteractionEnabled = YES;
    [_tabbarViewCenter addSubview:_button_center];

   //button0
    _button_0 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_0 setTag:0];
    [_button_0 setImage:[UIImage imageNamed:@"tabbar_home.png"] forState:UIControlStateNormal];
    [_button_0 setImage:[UIImage imageNamed:@"tabbar_home_down.png"] forState:UIControlStateSelected];
    [_button_0 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
     [_tabbarView addSubview:_button_0];
    [_button_0 setSelected:YES];
    
    //button1
    _button_1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_1 setTag:1];
    [_button_1 setImage:[UIImage imageNamed:@"tabbar_market.png"] forState:UIControlStateNormal];
    [_button_1 setImage:[UIImage imageNamed:@"tabbar_market_down.png"] forState:UIControlStateSelected];
    [_button_1 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    [_tabbarView addSubview:_button_1];
    
    
    //button2
    _button_3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_3 setTag:3];
    [_button_3 setImage:[UIImage imageNamed:@"tabbar_mine.png"] forState:UIControlStateNormal];
    [_button_3 setImage:[UIImage imageNamed:@"tabbar_mine_down.png"] forState:UIControlStateSelected];
    [_button_3 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    [_tabbarView addSubview:_button_3];
    
    //button4
    _button_4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_4 setTag:4];
    [_button_4 setImage:[UIImage imageNamed:@"tabbar_more.png"] forState:UIControlStateNormal];
    [_button_4 setImage:[UIImage imageNamed:@"tabbar_more_down.png"] forState:UIControlStateSelected];
        [_button_4 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    [_tabbarView addSubview:_button_4];
    
    _arrayButton = [NSArray arrayWithObjects:_button_0,_button_1,_button_center,_button_3,_button_4,nil];
}

/*
 layout
 */
-(void)_layoutView
{
    [_tabbarView setFrame:CGRectMake(TabbarView_TabBarViewFrame.origin.x, TabbarView_TabBarViewFrame.origin.y, self.frame.size.width, TabbarView_TabBarViewFrame.size.height)];
    
    [_tabbarViewCenter setFrame:CGRectMake(0, 0, 65, 57)];
    
     _tabbarViewCenter.center = CGPointMake(self.center.x, self.bounds.size.height/2);
    
    [_button_center setFrame:CGRectMake(0, 0, 65, 57)];
      
    [_button_0 setFrame:CGRectMake(10, 2, 45, 45)];
    
    [_button_1 setFrame:CGRectMake(67, 2, 45, 45)];
    
    [_button_3 setFrame:CGRectMake(202, 2, 45, 45)];
    
    [_button_4 setFrame:CGRectMake(264, 2, 45, 45)];
       
}


-(void)btn1Click:(id)sender
{
     UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 0:
        {
            [self.delegate touchBtnAtIndex:0];
                break;
        }
        case 1:
        {
            [self.delegate touchBtnAtIndex:1];
            break;
        }
        case 2:
        {
            [self.delegate touchBtnAtIndex:2];
            break;
        }
        case 3:
          
            [self.delegate touchBtnAtIndex:3];
            break;
        case 4:
          
            
            [self.delegate touchBtnAtIndex:4];
            break;
        default:
            break;
    }
    [self _buttonSelectedwithIndex:btn.tag];
}



-(void)_buttonSelectedwithIndex:(NSInteger)index
{
    for (UIButton *button in _arrayButton)
    {
        [button setSelected:NO];
    }

    UIButton *button = [_arrayButton objectAtIndex:index];
    [button setSelected:YES];
}

@end
