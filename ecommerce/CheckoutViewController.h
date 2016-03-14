//
//  CheckoutViewController.h
//  Ecommerce
//
//  Created by Han Hu on 9/17/15.
//  Copyright (c) 2015 Twixxies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
//ApplePay
@import PassKit;
#import "BraintreeApplePay.h"
@interface CheckoutViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UserPaymentMethodDelegate,PKPaymentAuthorizationViewControllerDelegate>{
    IBOutlet UITableView *table;
    
    NSMutableArray *sections;
    NSMutableDictionary *titles;
    
    
   
    UIView *submit;
    UIView *submit_view;
    UILabel *submit_middle;
    NSDecimalNumber *tax;
    NSDecimalNumber *shipping;
    UIActivityIndicatorView *indicator;
}
@property (nonatomic, strong) NSDecimalNumber *total;
@property NSDecimalNumber *store_credit_used;
@property  (nonatomic, strong) NSDecimalNumber *totalsaved;
@property (nonatomic, strong) Config *config;
@property (nonatomic, strong) UIViewController *parent;


-(void)submit_order:(UITapGestureRecognizer *)ges;
@end
