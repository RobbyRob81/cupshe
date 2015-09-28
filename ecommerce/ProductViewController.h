//
//  ProductViewController.h
//  Ecommerce
//
//  Created by Hanqing Hu on 5/25/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "Product.h"
#import "ProductVar.h"
#import "ProductFilterViewController.h"
@class ProductViewDesign;
@interface ProductViewController : UIViewController <NSURLConnectionDelegate, UIScrollViewDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>{
    IBOutlet UIScrollView *scroll;
    IBOutlet UIActivityIndicatorView *indicator;
    IBOutlet UISearchBar *searchbar;
    IBOutlet UIButton *searchCancelBtn;
    //IBOutlet UITextField *searchText;
    // IBOutlet UIButton *cancelbtn;
    
    UILabel *titlelabel;
    UILabel *cartCounter;
    UILabel *cartbtn;
    UIView *loadingView;
    NSMutableArray *itemViews;
    NSMutableArray *items;
    
    int loading;
    CGFloat currentScrollHeight;
    BOOL reloading;
    UIRefreshControl *refresh;
    
    CGFloat contentHeight;
    NSMutableArray *receivedData;
    NSMutableDictionary *filters;
    NSMutableArray *searchResult;
    NSMutableArray *searchWords;
    UITableView *search_display;
    
    //ProductFilterViewController *filterview;
    
    
    CGFloat screenHeight;
    CGFloat screenWidth;
    CGFloat lastContentOffset;
    CGFloat cachedContentOffset;
    int scrollDirection;
    int hasmore;
    
    ProductViewDesign *design;
    
    
    //scroll direction
    CGFloat lastScrollOffset;
    int search_is_toggling;
    
}

@property (nonatomic, strong) Config *config;
@property (nonatomic, strong) NSString *departmentid;
@property (nonatomic, strong) NSString *filter;
@property (nonatomic, strong) NSString *searchTerm;
@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, strong) NSString *rank;
@property (nonatomic, strong) NSMutableArray *category;
@property (nonatomic, strong) NSMutableArray *attribute;

-(void)load_product:(int)start;
@end


@interface ProductViewDesign : NSObject

@property (nonatomic, strong) NSDictionary *product_view;
@property (nonatomic, strong) NSDictionary *product_image;
@property (nonatomic, strong) NSDictionary *product_brand;
@property (nonatomic, strong) NSDictionary *product_name;
@property (nonatomic, strong) NSDictionary *product_price;
@property (nonatomic, strong) NSDictionary *product_sale;
@property (nonatomic, strong) NSDictionary *product_soldout;
@property int column;
@property (nonatomic, strong) NSArray *column_spacing;
@end


