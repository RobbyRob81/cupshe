//
//  PaymentMethodViewController.h
//  Ecommerce
//
//  Created by Han Hu on 9/15/15.
//  Copyright (c) 2015 Twixxies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "AuthNet.h"
#import "CreditCardType.h"
#import "Config.h"
#import "PaymentMethod.h"
#import <Braintree/Braintree.h>

@interface PaymentMethodViewController : UIViewController{
    UIActivityIndicatorView *indicator;
    NSMutableArray *user_payment_method;
    UILabel *seg;
    UIScrollView *scroll;
    NSMutableArray *payment_views;
    int initial;
}

@property (nonatomic, strong) Config *config;
@property (nonatomic, strong) UIViewController *parent;
@property BOOL is_checkout;

@end


@interface AddEditPaymentMethodViewController : UIViewController<AuthNetDelegate>{
    UIActivityIndicatorView *indicator;
    NSMutableArray *app_payment_method;
    UIScrollView *scroll;
    NSMutableArray *payment_views;
}

@property (nonatomic, strong) Config *config;
@property (nonatomic, strong) NSMutableArray *allusermethods;
@property (nonatomic, strong) UIViewController *parent;

@end

@interface CreditCardViewController : UIViewController<AuthNetDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate>{
    UIActivityIndicatorView *indicator;
    UITableView *table;
    
    UITextField *cardnumber;
    UITextField *expmonth;
    UITextField *expyear;
    UITextField *cvc;
    
    UITextField *fn;
    UITextField *ln;
    UITextField *addr;
    UITextField *city;
    UITextField *state;
    UITextField *country;
    UITextField *zip;
    
    UISwitch *isdefault;
    
    
    UIPickerView *state_picker;
    UIPickerView *country_picker;
    UIView *picker_view;
    NSArray *states;
    
    
    int changed;
    int tableloaded;
}

@property (nonatomic, strong) Config *config;
@property (nonatomic, strong) AppPaymentMethod *appmethod;
@property (nonatomic, strong) UserPaymentMethod *usermethod;
@property (nonatomic, strong) UIViewController *parent;
@property (nonatomic, strong) NSMutableArray *allusermethods;


@end



@interface CustomePaymentViewController : UIViewController<AuthNetDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate>{
    UIActivityIndicatorView *indicator;
    UITableView *table;
    UITextView *textview;
    CGSize cellsize;
    
    
    UISwitch *isdefault;
    
    
    
}

@property (nonatomic, strong) Config *config;
@property (nonatomic, strong) AppPaymentMethod *appmethod;
@property (nonatomic, strong) UserPaymentMethod *usermethod;
@property (nonatomic, strong) UIViewController *parent;
@property (nonatomic, strong) NSMutableArray *allusermethods;


@end












#import "PayPalMobile.h"

@interface AccountPaymentViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate, PayPalFuturePaymentDelegate, BTPaymentMethodCreationDelegate>{
    UIActivityIndicatorView *indicator;
    UITableView *table;
    UITextView *textview;
    CGSize cellsize;
    
    
    UISwitch *isdefault;
    
    int is_changed;
    
}

@property (nonatomic, strong) Config *config;
@property (nonatomic, strong) AppPaymentMethod *appmethod;
@property (nonatomic, strong) UserPaymentMethod *usermethod;
@property (nonatomic, strong) UIViewController *parent;
@property (nonatomic, strong) NSMutableArray *allusermethods;


@end