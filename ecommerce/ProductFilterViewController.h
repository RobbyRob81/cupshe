//
//  ProductFilterViewController.h
//  Ecommerce
//
//  Created by Hanqing Hu on 8/14/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
@class ProductFilterDesign;
@interface ProductFilterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSURLConnectionDelegate>{
    //IBOutlet UITableView *table;
    IBOutlet UIButton *cancel;
    IBOutlet UIButton *apply;
    IBOutlet UIButton *clear;
    
    IBOutlet UINavigationBar *titleBar;
    IBOutlet UINavigationBar *titleBar2;
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *featuredLabel;
    IBOutlet UILabel *lowhighLabel;
    IBOutlet UILabel *highlowLabel;
    IBOutlet UIView *separator;
    IBOutlet UIButton *rankfeature;
    IBOutlet UIButton *ranklow;
    IBOutlet UIButton *rankhigh;
    IBOutlet UISegmentedControl *filterseg;
    IBOutlet UIActivityIndicatorView *indicator;
    IBOutlet UITableView *table;
    
    NSMutableDictionary *active_filter;
    NSArray *sorted_filter_keys;
    NSString *rank;
    NSMutableArray *cat;
    NSMutableArray *selattr;
   
    
    
    NSMutableArray *receivedData;
    NSMutableArray *updatefilters;
    NSString *lastchange; // used for when user choose filters, if they didn't select any new filters from other section, then don't updated the last change they made
    
    ProductFilterDesign *design;
}
@property (nonatomic, strong) UIViewController *parent;
@property (nonatomic, strong) NSMutableDictionary *filters;
@property (nonatomic, strong) Config *config;
@property (nonatomic, strong) IBOutlet UITableView *table;



-(IBAction)rankchange:(id)sender;
-(IBAction)cancel:(id)sender;
-(IBAction)clear:(id)sender;
-(IBAction)apply:(id)sender;
-(IBAction)filter_change:(id)sender;
@end


@interface ProductFilterDesign : NSObject
@property (nonatomic, strong) NSDictionary *active_sel_but;
@property (nonatomic, strong) NSDictionary *select_but;
@property (nonatomic, strong) NSDictionary *filter_checkmark;
@property (nonatomic, strong) NSDictionary *apply_background;

@end