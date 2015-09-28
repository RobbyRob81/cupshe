//
//  CheckoutPaypalViewController.h
//  Vanessa Gade
//
//  Created by Hanqing Hu on 9/30/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayPalMobile.h"
#import "Config.h"
#import "Cart.h"
@interface CheckoutPaypalViewController : UIViewController <PayPalPaymentDelegate> {
    
    IBOutlet UITableView *table;
    NSMutableArray *tableItem;
    NSMutableArray *receivedData;
    NSDecimalNumber  *tax;
    NSDecimalNumber *shipping;
    IBOutlet UIActivityIndicatorView *indicator;
    IBOutlet UIButton *submit;
    UIView *submit_view;
    UILabel *submit_middle;
    int sel_method;
}
@property (nonatomic, strong) NSDecimalNumber *total;
@property (nonatomic, strong) NSDecimalNumber *store_credit_used;
@property  (nonatomic, strong) NSDecimalNumber *totalsaved;
@property (nonatomic, strong) Config *config;
@property (nonatomic, strong) UIViewController *parent;
@property (nonatomic, strong) PayPalConfiguration *payPalConfig;


-(void)pay;
-(IBAction)paysel:(id)sender;
-(IBAction)paysubmit:(id)sender;
-(void)startAnimating;
@end
