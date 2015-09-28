//
//  ProductReviewViewControllerModule.h
//  Moooh
//
//  Created by Hanqing Hu on 2/20/15.
//  Copyright (c) 2015 Twixxies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "Product.h"
@protocol ProductReviewViewControllerModuleDelegate;
@class ProductReviewViewControllerModuleDesign;
@class ProductReview;
@class ProductReviewItemView;
@interface ProductReviewViewControllerModule : UIViewController <NSURLConnectionDataDelegate, UITextFieldDelegate, UITextViewDelegate> {
    UIActivityIndicatorView *preview_indicator;
    UIActivityIndicatorView *detail_indicator;
    
    UIScrollView *scroll;
    UIView *add_review;
    UILabel *cartbtn;
    
    NSString *api_sec;
    
    //add review related
    UIBarButtonItem *addbtn;
    UIBarButtonItem *backbtn;
    UIBarButtonItem *closebtn;
    UIBarButtonItem *savebtn;
    NSMutableArray *star_buttons;
    UITextField *review_name;
    UITextField *review_title;
    UITextView *review_message;
    
    int tried_login;
    int updating;
    BOOL product_purchased;
    
}
@property (nonatomic, strong) NSString *API_LOAD_PRODUCT_REVIEW;
@property (nonatomic, strong) NSString *API_POST_PRODUCT_REVIEW;
@property (nonatomic, strong) Config *config;
@property (nonatomic, strong) NSString *API_KEY;
@property (nonatomic, strong) NSString *reviewSource;
@property (nonatomic, strong) NSString *moduleType;
@property (nonatomic, strong) Product *product;
@property (nonatomic, strong) NSMutableArray *reviews;
@property (nonatomic, strong) NSMutableArray *review_item_views;
@property (nonatomic, strong) NSString *self_review_id;
@property (nonatomic, strong) UIView *preview;
@property (nonatomic, strong) NSString *display_name;
@property (nonatomic, strong) NSString *display_text;
@property (nonatomic, strong) NSString *display_title;
@property float display_rating;
@property float totalrating;
@property int totalreview;
@property (nonatomic, strong) id<ProductReviewViewControllerModuleDelegate> delegate;

-(void)init_preview:(CGRect)frame;

@end


@interface ProductReviewViewControllerModuleDesign : NSObject


@end

@interface ProductReview : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *text;
@property float rating;
@property int status;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *response;
@property (nonatomic, strong) NSString *review_id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *timestamp;
@end

@interface ProductReviewItemView : UIView

@property CGRect default_frame;
@property CGRect full_frame;
@property BOOL isFull;
@property NSString *review_id;
@property CALayer *bottom_border;

@end


@protocol ProductReviewViewControllerModuleDelegate <NSObject>

-(void)preview_finish_loading;
-(void)goto_detail_page;
@end


