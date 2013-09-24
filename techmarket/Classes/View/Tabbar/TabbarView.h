//
//  TabbarView.h
//  TabBar
//
//  Created by jing zhao on 7/2/13.
//  Copyright (c) 2013 youdao. All rights reserved.
//


@protocol tabbarDelegate <NSObject>

-(void)touchBtnAtIndex:(NSInteger)index;
-(void)falseTouchBtnAtIndex:(NSInteger)index withNSstringStartPage:(NSString*)startPage;


@end

#import <UIKit/UIKit.h>

@interface TabbarView : UIView

@property(nonatomic,weak) id<tabbarDelegate> delegate;

-(void)tapButtonIndex:(NSInteger)index;
-(void)falseTapButtonIndex:(NSInteger)index withNSstringStartPage:(NSString*)startPage;

@end
