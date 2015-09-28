//
//  CheckoutViewController.h
//  Ecommerce
//
//  Created by Hanqing Hu on 5/27/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Config.h"
@interface CheckoutViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>{
    IBOutlet UITableView *table;
    NSMutableArray *tableItem;
    NSMutableArray *receivedData;
    IBOutlet UIButton *submit;
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

-(IBAction)buy:(id)sender;
@end
