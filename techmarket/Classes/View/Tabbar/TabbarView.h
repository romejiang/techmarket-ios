//
//  TabbarView.h
//  TabBar
//
//  Created by jing zhao on 7/2/13.
//  Copyright (c) 2013 youdao. All rights reserved.
//


@protocol tabbarDelegate <NSObject>

-(void)touchBtnAtIndex:(NSInteger)index;

@end

#import <UIKit/UIKit.h>

@interface TabbarView : UIView

//@property(nonatomic,strong) UIImageView *tabbarView;
//@property(nonatomic,strong) UIImageView *tabbarViewCenter;
//@property(nonatomic,strong) UIButton *button_1;
//@property(nonatomic,strong) UIButton *button_2;
//@property(nonatomic,strong) UIButton *button_3;
//@property(nonatomic,strong) UIButton *button_4;
//@property(nonatomic,strong) UIButton *button_center;
@property(nonatomic,weak) id<tabbarDelegate> delegate;


@end
