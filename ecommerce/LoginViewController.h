//
//  LoginViewController.h
//  Ecommerce
//
//  Created by Hanqing Hu on 5/27/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate> {
    UIView *loginView;
    UITextField *loginEmail;
    UITextField *loginPass;
    UIButton *loginClose;
    UIButton *switchToSignup;
    IBOutlet UIActivityIndicatorView *indicatorlogin;
    
    
    UIView *signupView;
    UIButton *signupClose;
    UIButton *switchToLogin;
    UITextField *signupEmail;
    UITextField *signupPass;
    UIActivityIndicatorView *indicatorsignup;
    
    /*IBOutlet UIView *signupView;
    IBOutlet UILabel *signupTitle;
    IBOutlet UIView *signupEmailPane;
    IBOutlet UIView *signupPassPane;
    IBOutlet UILabel *signupEmailIcon;
    IBOutlet UILabel *signupPassIcon;
    IBOutlet UITextField *signupEmail;
    IBOutlet UITextField *signupPass;
    IBOutlet UIButton *switchToLogin;
    IBOutlet UIButton *signupCancel;
    IBOutlet UIButton *signupBut;
    IBOutlet UIActivityIndicatorView *indicatorsignup;*/
    
    
    
    NSMutableArray *receivedData;
    CGFloat screenHeight;
    CGFloat screenWidth;
}

@property (nonatomic, strong) Config *config;
@property (nonatomic, strong) UIViewController *passView;
@property (nonatomic, strong) UIViewController *nav;

-(IBAction)seg_pressed:(id)sender;
-(IBAction)cancel:(id)sender;


-(IBAction)signup:(id)sender;
-(IBAction)login:(id)sender;
-(IBAction)forgetPass:(id)sender;

-(void)threadStartAnimating;
@end
