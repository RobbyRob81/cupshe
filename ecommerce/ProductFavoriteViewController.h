//
//  ProductFavoriteViewController.h
//  Ecommerce
//
//  Created by Hanqing Hu on 5/24/15.
//  Copyright (c) 2015 Twixxies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
@class ProductFavoriteViewDesign;
@interface ProductFavoriteViewController : UIViewController <NSURLConnectionDelegate, UIScrollViewDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>{
    IBOutlet UIScrollView *scroll;
    IBOutlet UIActivityIndicatorView *indicator;
    
    //IBOutlet UITextField *searchText;
    // IBOutlet UIButton *cancelbtn;
    
    UILabel *titlelabel;
    UILabel *cartCounter;
    UILabel *cartbtn;
    UIView *loadingView;
    NSMutableArray *itemViews;
    NSMutableArray *items;
    
    int loading;
    BOOL reloading;
    UIRefreshControl *refresh;
    
    CGFloat contentHeight;
    NSMutableArray *receivedData;
   
   
    
    //ProductFilterViewController *filterview;
    
    
    CGFloat screenHeight;
    CGFloat screenWidth;
    CGFloat lastContentOffset;
    CGFloat cachedContentOffset;
    int scrollDirection;
    int hasmore;
    
    ProductFavoriteViewDesign *design;
    
}

@property (nonatomic, strong) Config *config;


-(void)load_product:(int)start;
@end


@interface ProductFavoriteViewDesign : NSObject

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

