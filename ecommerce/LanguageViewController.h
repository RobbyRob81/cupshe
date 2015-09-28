//
//  LanguageViewController.h
//  Moooh
//
//  Created by Hanqing Hu on 4/10/15.
//  Copyright (c) 2015 Twixxies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
@class AppLocation;
@interface LanguageViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate>{
    UITableView *table;
    UITextField *hiddenText;
    UIPickerView *picker;
    
    NSArray *countries;
    NSMutableDictionary *applocations;
    AppLocation *sel_loc;
    
    NSMutableArray *buttons;
    UILabel *menubtn;
}

@property (nonatomic, strong) Config *config;
@property BOOL first;

@end


@interface AppLocation :NSObject{
    
}

@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSDictionary *languages;
@property (nonatomic, strong) NSString *country_code;
@end