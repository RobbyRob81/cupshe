//
//  GuestCheckoutViewController.h
//  Ecommerce
//
//  Created by Han Hu on 8/18/15.
//  Copyright (c) 2015 Twixxies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
@interface GuestCheckoutViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate> {
    UITextField *email;
    UIButton *guest;
    UIButton *login;
    UIActivityIndicatorView *indicator;
    
   
}

@property (nonatomic, strong) Config *config;
@property (nonatomic, strong) UIViewController *next;

-(void)startAnimating;
@end
