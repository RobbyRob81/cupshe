//
//  OrderDetailViewController.h
//  Ecommerce
//
//  Created by Hanqing Hu on 8/1/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "Order.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
@interface OrderDetailViewController : UIViewController <MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>{
    IBOutlet UITableView *table;
    UIScrollView *scroll;
}
@property (nonatomic, strong) Config *config;
@property (nonatomic, strong) Order *order;
@end
