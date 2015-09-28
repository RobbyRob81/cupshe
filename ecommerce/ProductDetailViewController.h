//
//  ProductDetailViewController.h
//  Ecommerce
//
//  Created by Hanqing Hu on 5/26/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "Product.h"
#import "ProductVar.h"
#import "ProductReviewViewControllerModule.h"
#import "SocialShareModule.h"
#import "ViewWithData.h"
@class ButtonWithValues;
@class ProductDetailDesign;
@interface ProductDetailViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UIGestureRecognizerDelegate, UIWebViewDelegate, ProductReviewViewControllerModuleDelegate> {
    IBOutlet UIScrollView *scroll;
    UIActivityIndicatorView *indicator;
    //IBOutlet UIImageView *image;
    //IBOutlet UILabel *name;
   // IBOutlet UIButton *choose;
   // IBOutlet UILabel *price;
    //IBOutlet UILabel *sale_ori;
    //IBOutlet UILabel *sale_sale;
    IBOutlet UIButton *addcart;
    UILabel *addcarttop;
    UILabel *addcartbottom;
    UILabel *addcartmiddle;
    ImageWithData *productImage;
    IBOutlet UIPickerView *picker;
    IBOutlet UIButton *var_cancel;
    IBOutlet UIButton *var_done;
    IBOutlet UIButton *var_clear;
    IBOutlet UIView *accessory;
    UILabel *cartbtn;
    ButtonWithValues *choose;
    UITextField *hidden;
    
    NSMutableArray *receivedData;
    NSMutableDictionary *attributes;
    NSMutableDictionary *sel_attr;
    NSMutableDictionary *prev_sel_var;
    NSMutableArray *varbtns;
    NSMutableArray *pickerval;
    NSMutableArray *pickerdisabled;
    ProductVar *selvar;
    BOOL hasvar;
    UILabel *price;
    UILabel *sale_ori, *sale_sale;
    
    
    NSMutableArray *images;
    UIScrollView *imgscroll;
    CGRect imgscrollframe;
    ImageWithData *activeImg;
    UIPageControl *page;
    NSMutableArray *image_laoding_queue;
    BOOL shoudLoadImg;
    
    
    ProductDetailDesign *design;
    UIView *webbackground;
    UIView *webbackbutton;
    UIButton *readmore;
    UIButton *readless;
    UILabel *favbtn;
    
    //modules
    ProductReviewViewControllerModule* review;
    SocialShareModule *ss;
    
    
    //views that need adjustment after description
    NSMutableArray *after_desc;
    float extra;
}

@property (nonatomic, strong) Config *config;
@property (nonatomic, strong) Product *product;
@property (nonatomic, strong) NSString *fav_id;
@property BOOL viewPresented;

-(void)build_vargus_detailpage;
-(void)build_finx_detailpage;


-(IBAction)add_to_card:(id)sender;
-(IBAction)close:(id)sender;
-(IBAction)var_clear:(id)sender;
-(IBAction)var_select:(id)sender;

@end


@interface ButtonWithValues : UIButton


@property (nonatomic, strong) NSString *key;


@end


@interface ProductDetailDesign : NSObject
@property (nonatomic, strong) NSString *detail_type;
@property (nonatomic, strong) NSDictionary *brand;
@property (nonatomic, strong) NSDictionary *price;
@property (nonatomic, strong) NSDictionary *sale_price;
@property (nonatomic, strong) NSDictionary *name;
@property (nonatomic, strong) NSString *desc_type;
@property int hide_brand;
@property CGRect desc_hide;
@property CGRect desc_show;
@end
