//
//  ShippingMethodViewController.h
//  Ecommerce
//
//  Created by Hanqing Hu on 7/14/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Shipping.h"
#import "Config.h"
@interface ShippingMethodViewController : UIViewController <UIAlertViewDelegate>{
    IBOutlet UITableView *table;
    NSMutableArray *shipping;
}

@property (nonatomic, strong) NSDecimalNumber * totalprice;
@property (nonatomic, strong) Config *config;


@end
