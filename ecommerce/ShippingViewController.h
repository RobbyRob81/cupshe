//
//  ShippingViewController.h
//  Ecommerce
//
//  Created by Hanqing Hu on 5/27/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
@interface ShippingViewController : UIViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate>{
    IBOutlet UITextField *name;
    IBOutlet UITextField *address;
    IBOutlet UITextField *city;
    IBOutlet UITextField *state;
    IBOutlet UITextField *zip;
    IBOutlet UITextField *country;
    IBOutlet UITextField *phone;
    IBOutlet UITableView *table;
    IBOutlet UIPickerView *statepicker;
    IBOutlet UIPickerView *countrypicker;
    IBOutlet UISwitch *billing;
    IBOutlet UISwitch *save;
    UIScrollView *scroll;
    IBOutlet UIActivityIndicatorView *indicator;
    
    NSArray *states;
    
    IBOutlet UIView *picker_view;
    IBOutlet UIButton *picker_cancel;
    IBOutlet UIButton *picker_done;
    
    
    int samerow;
    int saveasrow;
    int namerow;
    int cityrow;
    int staterow;
    int addrrow;
    int ziprow;
    int countryrow;
    int phonerow;
    
    BOOL shipping_all_country;
}


@property (nonatomic, strong) Config *config;
@property BOOL is_setting;

-(IBAction)save:(id)sender;
-(IBAction)cancel:(id)sender;
-(IBAction)done:(id)sender;
@end
