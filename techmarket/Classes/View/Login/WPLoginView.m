//
//  WPLoginView.m
//  techmarket
//
//  Created by Zhao Jing on 7/15/13.
//
//

#import "WPLoginView.h"

@interface WPLoginView()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation WPLoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    
    }
    return self;
}

-(void)awakeFromNib
{

  [self _addListenKeyBoard];

}


-(void)_addListenKeyBoard
{
    //键盘
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(_observerKeyboardWasShown:)
												 name:UIKeyboardWillShowNotification
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(_observerkeyboardWasHidden:)
												 name:UIKeyboardWillHideNotification
											   object:nil];
}


//当键盘出现的时候

- (void) _observerKeyboardWasShown:(NSNotification *)_notificationInfo
{
    [UIView beginAnimations:nil
                    context:nil];
    [UIView setAnimationDuration:0.3];
    //    [self.ui_scrollView setContentOffset:CGPointMake(0, KUILoginViewController_ScrollViewOffset)];
    [UIView commitAnimations];
}

//键盘隐藏的时候

-(void)_observerkeyboardWasHidden:(NSNotification *)_notificationInfo
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
//    [self.ui_scrollView setContentOffset:CGPointMake(0, 0)];
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{



    return (YES);
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
