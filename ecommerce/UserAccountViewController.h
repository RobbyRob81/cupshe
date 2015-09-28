//
//  SettingsViewController.h
//  Ecommerce
//
//  Created by Hanqing Hu on 7/31/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
@interface UserAccountViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate> {
    IBOutlet UITableView *table;
    NSMutableDictionary *menuItems;
    NSMutableArray *sectionTitle;
    UILabel *logoutbtn;
    
    int orderhistory;
    int account_setitngs;
    int credit_card;
    int billing_info;
    int shipping_info;
    int push_count;
}
@property (nonatomic, strong) Config *config;

@end
