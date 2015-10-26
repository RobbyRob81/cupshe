//
//  CartViewController.h
//  Ecommerce
//
//  Created by Hanqing Hu on 5/27/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "Cart.h"
@interface CartViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    
    IBOutlet UITableView *table;

    IBOutlet UIActivityIndicatorView *indicator;
    IBOutlet UIButton *checkout;
    UILabel *cartCounter;
    UILabel *applyCredit;
    UILabel *credit;
    UIView *creditview;
    IBOutlet UIView *checkout_back;
    UIView *checkout_view;
    UILabel *checkout_middle;
    UILabel *totalPrice;
    UILabel *totalSave;
    UILabel *seg;
    
    NSMutableArray *receivedData;
    NSMutableArray *cart;
    
    NSDecimalNumber *total;
    NSDecimalNumber *totalsaved;
    
    
    int loading;
    int applied_credit;
    NSString * random;
    
}

@property (nonatomic, strong) Config *config;
@property int isFromMenu;
@property (nonatomic, strong) UIViewController *parent;

-(IBAction)checkout:(id)sender;

-(void)threadStartAnimating;
@end
