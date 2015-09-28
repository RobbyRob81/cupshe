//
//  SettingsViewController.h
//  Ecommerce
//
//  Created by Hanqing Hu on 7/23/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
@interface ProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, NSURLConnectionDelegate, UIPickerViewDataSource, UIPickerViewDelegate>{
    NSMutableDictionary *profile;
    NSMutableDictionary *cache;
    NSMutableData *received;
    IBOutlet UITableView *table;
    IBOutlet UIActivityIndicatorView *indicator;
    
    
    IBOutlet UIPickerView *picker;
    IBOutlet UIPickerView *countrypicker;
    IBOutlet UIView *picker_view;
    IBOutlet UIButton *picker_cancel;
    IBOutlet UIButton *picker_done;
    
     NSArray *states;
    UITextField *state_text;
    UITextField *country_text;
}

@property (nonatomic, strong) Config *config;

-(void)sendEdit:(NSString *)edit for_field:(NSString *)field witholdpassword:(NSString *)old andnewpassword:(NSString *)pass;
-(IBAction)back:(id)sender;
-(void)threadStartAnimating;

-(IBAction)cancel:(id)sender;
-(IBAction)done:(id)sender;

@end





