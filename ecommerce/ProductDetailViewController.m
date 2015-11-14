//
//  ProductDetailViewController.m
//  Ecommerce
//
//  Created by Hanqing Hu on 5/26/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "NSURLConnectionWithTag.h"
#import "NSURLConnectionBlock.h"
#import "LoginViewController.h"
#import "CartViewController.h"
#import "IonIcons.h"
#import "ionicons-codes.h"
#import "NSString+FontAwesome.h"
#import "Design.h"
#import "PromotionViewController.h"
#import "ViewWithData.h"
#import "SDImageCache.h"
#import "SDWebImageDownloader.h"
#import "ProductDetailImageViewController.h"

const int ADD_TO_CART = 0;
@interface ProductDetailViewController ()

@end

@implementation ProductDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.viewPresented = NO;
        shoudLoadImg = YES;
        self.fav_id = @"";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    // Do any additional setup after loading the view from its nib.
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 44)] ;
    label.backgroundColor = [UIColor clearColor];
    //label.font = [UIFont boldSystemFontOfSize:17.3];
    label.font = [UIFont boldSystemFontOfSize:17.3];
    
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor colorWithRed:0.302 green:0.302 blue:0.318 alpha:1]; // change this color
    self.navigationItem.titleView = label;
    label.text = self.product.name;
    //[label sizeToFit];
    [Design navigationbar_title:label config:self.config];
    
    
    
    UIView *cartView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    cartView.userInteractionEnabled = YES;
    cartView.clipsToBounds = NO;
    
    cartbtn = [IonIcons labelWithIcon:icon_ios7_cart size:0 color:[UIColor whiteColor]];
    cartbtn.textAlignment = NSTextAlignmentRight;
    cartbtn.frame = CGRectMake(40, 0, 40, 44);
    [Design navigationbar_ion_icon:cartbtn config:self.config];
    [Design style:[[DOM alloc] initWithView:cartbtn parent:nil] design:[[self.config.design objectForKey:@"design"] objectForKey:@"right_navigation_ion_icon"] config:self.config];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cart:)];
    [cartbtn addGestureRecognizer:tap];
    cartbtn.userInteractionEnabled = YES;
    [Design navigationbar_ion_icon:cartbtn config:self.config];
    [Design style:[[DOM alloc] initWithView:cartbtn parent:nil] design:[[self.config.design objectForKey:@"design"] objectForKey:@"right_navigation_ion_icon"] config:self.config];
    
    
    //favbtn = [IonIcons labelWithIcon:icon_ios7_star_outline size:0 color:[UIColor whiteColor]];
    favbtn = [[UILabel alloc] init];
    
    favbtn.textAlignment = NSTextAlignmentCenter;
    favbtn.frame = CGRectMake(10, 0, 40, 44);
    [Design navigationbar_ion_icon:favbtn config:self.config];
    [Design style:[[DOM alloc] initWithView:favbtn parent:nil] design:[[self.config.design objectForKey:@"design"] objectForKey:@"right_navigation_ion_icon"] config:self.config];
    favbtn.font = [UIFont fontWithName:kFontAwesomeFamilyName size:26];;
    UITapGestureRecognizer *favtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(add_edit_fav)];
    [favbtn addGestureRecognizer:favtap];
    favbtn.userInteractionEnabled = YES;
    if (self.fav_id.length > 0){
        favbtn.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-heart"];;
        //favbtn.textColor = [UIColor colorWithRed:0.886 green:0.886 blue:0.392 alpha:1];
        [Design style:[[DOM alloc] initWithView:favbtn parent:nil] design:[[self.config.design objectForKey:@"design"] objectForKey:@"navigation_icon_active"] config:self.config];
    } else {
        favbtn.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-heart-o"];;
        //favbtn.textColor = [UIColor colorWithRed:55.0/255.0 green:55.0/255.0 blue:55.0/255.0 alpha:1];
        NSDictionary *d = [[self.config.design objectForKey:@"design"] objectForKey:@"navigation_icon_inactive"];
        
        [Design style:[[DOM alloc] initWithView:favbtn parent:nil] design:[[self.config.design objectForKey:@"design"] objectForKey:@"navigation_icon_inactive"] config:self.config];
    }
    
    
    [cartView addSubview:cartbtn];
    [cartView addSubview:favbtn];
    
    UIBarButtonItem *menuBtn2 = [[UIBarButtonItem alloc] initWithCustomView:cartView];
    
    
    self.navigationItem.rightBarButtonItem = menuBtn2;
    
    
    
    
    UILabel *menubtn = [IonIcons labelWithIcon:icon_ios7_arrow_back size:22 color:[UIColor blackColor]];;
    
    
    menubtn.frame = CGRectMake(0, 0, 60, 44);
    // menubtn.font = [UIFont fontWithName:kFontAwesomeFamilyName size:22.f];
    // menubtn.text =[NSString fontAwesomeIconStringForIconIdentifier:@"fa-bars"];
    [Design navigationbar_ion_icon:menubtn config:self.config];
    [Design style:[[DOM alloc] initWithView:menubtn parent:nil] design:[[self.config.design objectForKey:@"design"] objectForKey:@"left_navigation_ion_icon"] config:self.config];
    
    UITapGestureRecognizer *menutap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    [menubtn addGestureRecognizer:menutap];
    menubtn.userInteractionEnabled = YES;
    UIBarButtonItem *barbtn = [[UIBarButtonItem alloc] initWithCustomView:menubtn];
    self.navigationItem.leftBarButtonItem = barbtn;
    
    
    [var_cancel setTitle:[self.config localisedString:@"Cancel"] forState:UIControlStateNormal];
    [var_done setTitle:[self.config localisedString:@"Done"] forState:UIControlStateNormal];
    [var_clear setTitle:[self.config localisedString:@"Clear"] forState:UIControlStateNormal];
    
    
    
    NSDictionary *d = [[[self.config.design objectForKey:@"components"] objectForKey:@"product_detail_page"] objectForKey:@"style"];
    design = [[ProductDetailDesign alloc] init];
    design.brand = [[self.config.design objectForKey:@"design"] objectForKey:[d objectForKey:@"brand"]];
    design.price = [[self.config.design objectForKey:@"design"] objectForKey:[d objectForKey:@"price"]];
    design.name = [[self.config.design objectForKey:@"design"] objectForKey:[d objectForKey:@"name"]];
    design.sale_price = [[self.config.design objectForKey:@"design"] objectForKey:[d objectForKey:@"sale_price"]];
    design.desc_type = [[[self.config.design objectForKey:@"components"] objectForKey:@"product_detail_page"] objectForKey:@"description"];
    design.hide_brand = [[[[self.config.design objectForKey:@"components"] objectForKey:@"product_detail_page"] objectForKey:@"hide-brand"] intValue];
    design.detail_type = [[[self.config.design objectForKey:@"components"] objectForKey:@"product_detail_page"] objectForKey:@"type"];
    
    
    pickerdisabled = [[NSMutableArray alloc] init];
    
    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.config.screenWidth, self.config.screenHeight-64)];
    [self.view addSubview:scroll];
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(self.config.screenWidth/2-indicator.frame.size.width/2, (self.config.screenHeight-64)/2-indicator.frame.size.height/2, indicator.frame.size.width, indicator.frame.size.height);
    indicator.hidesWhenStopped = YES;
    [scroll addSubview:indicator];
    
    
    if (self.product.detail_loaded == 0){
        [NSThread detachNewThreadSelector:@selector(startAnimating) toTarget:self withObject:nil];
        NSString *wid = self.config.wholesale.wholesale_user_id;
        if (wid == nil) wid = @"";
        
        NSString *myRequestString = [NSString stringWithFormat:@"app_uuid=%@&product_id=%@&wholesale_user_id=%@&location=%@&currency=%@",self.config.APP_UUID, self.product.product_id, wid, self.config.location, self.config.currency];
        
        
        NSData *myRequestData2 = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
        NSMutableURLRequest *request2 = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@",self.config.API_ROOT, self.config.API_SINGLE_PRODUCT]]];
        [request2 setHTTPMethod: @"POST"];
        [request2 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
        [request2 setHTTPBody: myRequestData2];
        
        NSURLConnectionBlock *connection = [[NSURLConnectionBlock alloc] initWithRequest:request2];
        connection.completion = ^(id obj, NSError *err) {
            
            if (!err) {
                //It's ok, do domething with the response data (obj)
                NSMutableData *d = (NSMutableData *)obj;
                NSString *response = [[NSString alloc] initWithBytes:[d bytes] length:[d length] encoding:NSUTF8StringEncoding];
                NSLog(@"%@", response);
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
                
                int success = [[dic objectForKey:@"success"] intValue];
                
                if (success == 1){
                    
                    [self.product product_from_dictionary:[dic objectForKey:@"product"]];
                    self.product.detail_loaded = 1;
                    if ([design.detail_type isEqualToString:@"finx"]){
                        [self build_finx_detailpage];
                    } else {
                        [self build_vargus_detailpage];
                        //[self build_finx_detailpage];
                    }
                    
                } else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Item Not Available"] message:nil delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
                    [alert show];
                }
                
                
                
            } else {
                //There was an error
                //completion(nil, nil);
                
            }
            
            [indicator stopAnimating];
            
        };
        [connection start];
    } else {
        if ([design.detail_type isEqualToString:@"finx"]){
            [self build_finx_detailpage];
        } else {
            [self build_vargus_detailpage];
            //[self build_finx_detailpage];
        }
        
    }
    
    
    
    //[self.view addSubview:close];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [UIView setAnimationsEnabled:YES];
    [self.config add_badge:cartbtn withnumber:self.config.cartnum];
    
    if (self.config.user_id == nil || self.config.user_id.length == 0 || [self.config.user_id isEqualToString:@"0"]){
        //[addcart setTitle:@"Sign in to add to cart" forState:UIControlStateNormal];
        addcarttop.text = [self.config localisedString:@"SIGN UP OR LOG IN TO"];
        addcartbottom.text = [self.config localisedString:@"ADD TO CART"];
        addcartmiddle.text = @"";
    } else {
        // [addcart setTitle:@"Add to cart" forState:UIControlStateNormal];
        [self check_fav];
        [self.config check_cart_with_view:cartbtn];
        addcarttop.text = @"";
        addcartbottom.text = @"";
        addcartmiddle.text = [self.config localisedString:@"ADD TO CART"];
        
        
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)check_fav{
    
    NSString *myRequestString = [NSString stringWithFormat:@"app_uuid=%@&product_name=%@&user_id=%@&token=%@", self.config.APP_UUID, self.product.name, self.config.user_id, self.config.token ];
    
    // Create Data from request
    NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", self.config.API_ROOT, self.config.API_CHECK_FAV]]];
    
    NSLog(@"%@", myRequestString);
    // set Request Type
    [request setHTTPMethod: @"POST"];
    // Set content-type
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    // Set Request Body
    [request setHTTPBody: myRequestData];
    
    NSURLConnectionBlock *connection = [[NSURLConnectionBlock alloc] initWithRequest:request];
    connection.completion = ^(id obj, NSError *err) {
        
        if (!err) {
            //It's ok, do domething with the response data (obj)
            NSMutableData *d = (NSMutableData *)obj;
            NSString *response = [[NSString alloc] initWithBytes:[d bytes] length:[d length] encoding:NSUTF8StringEncoding];
            NSLog(@"%@", response);
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            if (dic != nil){
                self.fav_id = [dic objectForKey:@"fav_id"];
                if (self.fav_id == nil) self.fav_id = @"";
                if (self.fav_id.length > 0){
                    favbtn.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-heart"];
                    //favbtn.textColor = [UIColor colorWithRed:0.886 green:0.886 blue:0.392 alpha:1];
                    [Design style:[[DOM alloc] initWithView:favbtn parent:nil] design:[[self.config.design objectForKey:@"design"] objectForKey:@"navigation_icon_active"] config:self.config];
                } else {
                    favbtn.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-heart-o"];
                    //favbtn.textColor = [UIColor colorWithRed:55.0/255.0 green:55.0/255.0 blue:55.0/255.0 alpha:1];
                    [Design style:[[DOM alloc] initWithView:favbtn parent:nil] design:[[self.config.design objectForKey:@"design"] objectForKey:@"navigation_icon_inactive"] config:self.config];
                    
                }
            }
            
            
        } else {
            //There was an error
            NSLog(@"%@", err.description);
        }
        
    };
    [connection start];
}

-(void)add_edit_fav{
    if (self.config.user_id == nil || self.config.user_id.length == 0 || [self.config.user_id isEqualToString:@"0"]){
        LoginViewController *lefty = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        lefty.config = self.config;
        [self presentViewController:lefty animated:YES completion:nil];
        return;
    }
    int isdelete = 1;
    if (self.fav_id == nil || self.fav_id.length == 0 ) isdelete = 0;
    if (isdelete == 0){
        favbtn.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-heart"];
        //favbtn.textColor = [UIColor colorWithRed:0.886 green:0.886 blue:0.392 alpha:1];
        [Design style:[[DOM alloc] initWithView:favbtn parent:nil] design:[[self.config.design objectForKey:@"design"] objectForKey:@"navigation_icon_active"] config:self.config];
        CABasicAnimation *rotate =
        [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        rotate.byValue = @(M_PI*2); // Change to - angle for counter clockwise rotation
        rotate.duration = 0.5;
        
        [favbtn.layer addAnimation:rotate
                            forKey:@"myRotationAnimation"];
    } else {
        favbtn.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-heart-o"];
        //favbtn.textColor = [UIColor colorWithRed:55.0/255.0 green:55.0/255.0 blue:55.0/255.0 alpha:1];
        [Design style:[[DOM alloc] initWithView:favbtn parent:nil] design:[[self.config.design objectForKey:@"design"] objectForKey:@"navigation_icon_inactive"] config:self.config];
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             
                             favbtn.transform = CGAffineTransformRotate(favbtn.transform, (1080.0/180.0)*M_PI);;
                         }
                         completion:^(BOOL finished){
                         }];
    }
    
    NSString *myRequestString = [NSString stringWithFormat:@"app_uuid=%@&product_name=%@&user_id=%@&token=%@&fav_id=%@&is_delete=%d", self.config.APP_UUID, self.product.name, self.config.user_id, self.config.token, self.fav_id, isdelete];
    
    // Create Data from request
    NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", self.config.API_ROOT, self.config.API_ADD_EDIT_FAV]]];
    
    NSLog(@"%@", myRequestString);
    // set Request Type
    [request setHTTPMethod: @"POST"];
    // Set content-type
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    // Set Request Body
    [request setHTTPBody: myRequestData];
    
    NSURLConnectionBlock *connection = [[NSURLConnectionBlock alloc] initWithRequest:request];
    connection.completion = ^(id obj, NSError *err) {
        
        if (!err) {
            //It's ok, do domething with the response data (obj)
            NSMutableData *d = (NSMutableData *)obj;
            NSString *response = [[NSString alloc] initWithBytes:[d bytes] length:[d length] encoding:NSUTF8StringEncoding];
            NSLog(@"%@", response);
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            if (dic != nil){
                self.fav_id = [dic objectForKey:@"fav_id"];
                if (self.fav_id == nil) self.fav_id = @"";
                if (self.fav_id.length > 0){
                    favbtn.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-heart"];;
                    //favbtn.textColor = [UIColor colorWithRed:0.886 green:0.886 blue:0.392 alpha:1];
                    [Design style:[[DOM alloc] initWithView:favbtn parent:nil] design:[[self.config.design objectForKey:@"design"] objectForKey:@"navigation_icon_active"] config:self.config];
                } else {
                    favbtn.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-heart-o"];;
                    //favbtn.textColor = [UIColor colorWithRed:55.0/255.0 green:55.0/255.0 blue:55.0/255.0 alpha:1];
                    [Design style:[[DOM alloc] initWithView:favbtn parent:nil] design:[[self.config.design objectForKey:@"design"] objectForKey:@"navigation_icon_inactive"] config:self.config];
                }
            }
            
            
        } else {
            //There was an error
            NSLog(@"%@", err.description);
        }
        
    };
    [connection start];
}

-(void)build_vargus_detailpage{
    
    
    NSMutableDictionary *vs = [[NSMutableDictionary alloc] init];
    
    addcart = [[UIButton alloc] init];
    [addcart addTarget:self action:@selector(add_to_card:) forControlEvents:UIControlEventTouchUpInside];
    UIView *addcartview = [[UIView alloc] init];
    addcartview.userInteractionEnabled = NO;
    addcarttop = [[UILabel alloc] init];
    addcarttop.userInteractionEnabled = NO;
    addcartmiddle = [[UILabel alloc] init];
    addcartmiddle.userInteractionEnabled = NO;
    addcartbottom = [[UILabel alloc] init];
    addcartbottom.userInteractionEnabled = NO;
    [addcart addSubview:addcartview];
    [addcartview addSubview:addcarttop];
    [addcartview addSubview:addcartmiddle];
    [addcartview addSubview:addcartbottom];
    [vs setObject:addcart forKey:@"add_cart"];
    [vs setObject:addcartview forKey:@"add_cart_view"];
    [vs setObject:addcarttop forKey:@"add_cart_top"];
    [vs setObject:addcartmiddle forKey:@"add_cart_middle"];
    [vs setObject:addcartbottom forKey:@"add_cart_bottom"];
    NSString *dstr = [[[[self.config.design objectForKey:@"components"] objectForKey:@"filter_page"] objectForKey:@"style"] objectForKey:@"apply-background"];
    [Design style:[[DOM alloc] initWithView:addcartview parent:nil] design:[[self.config.design objectForKey:@"design"] objectForKey:dstr] config:self.config];
    [self.view addSubview:addcart];
    
    if (self.product.total_stock == 0) {
        addcart.enabled = NO;
        addcartview.alpha = 0.5;
        addcartmiddle.text = [self.config localisedString:@"Sold Out"];
        
    } else {
        if (self.config.user_id == nil || self.config.user_id.length == 0 || [self.config.user_id isEqualToString:@"0"]){
            //[addcart setTitle:@"Sign in to add to cart" forState:UIControlStateNormal];
            addcarttop.text = [self.config localisedString:@"SIGN UP OR LOG IN TO"];
            addcartbottom.text = [self.config localisedString:@"ADD TO CART"];
            addcartmiddle.text = @"";
        } else {
            // [addcart setTitle:@"Add to cart" forState:UIControlStateNormal];
            [self check_fav];
            [self.config check_cart_with_view:cartbtn];
            addcarttop.text = @"";
            addcartbottom.text = @"";
            addcartmiddle.text = [self.config localisedString:@"ADD TO CART"];
            
            
        }
    }
    
    NSMutableData *da = [[NSMutableData alloc] init];
    receivedData = [[NSMutableArray alloc] initWithObjects:da, nil];
    pickerval = [[NSMutableArray alloc] init];
    sel_attr = [[NSMutableDictionary alloc] init];
    [vs setObject:var_cancel forKey:@"var_sel_cancel"];
    [vs setObject:var_done forKey:@"var_sel_done"];
    [vs setObject:var_clear forKey:@"var_sel_clear"];
    [vs setObject:accessory forKey:@"var_sel_view"];
    
    
    
    hidden = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    hidden.inputView = picker;
    hidden.inputAccessoryView = accessory;
    [self.view addSubview:hidden];
    
    double height = 0;
    imgscroll = [[UIScrollView alloc] init];
    
    UISwipeGestureRecognizer *toright = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goleft)];
    toright.direction = UISwipeGestureRecognizerDirectionRight;
    UISwipeGestureRecognizer *toleft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goright)];
    toleft.direction = UISwipeGestureRecognizerDirectionLeft;
    [imgscroll addGestureRecognizer:toleft];
    [imgscroll addGestureRecognizer:toright];
    
    imgscroll.scrollEnabled = NO;
    [imgscroll delaysContentTouches];
    
    [vs setObject:imgscroll forKey:@"image_scroll"];
    
    images = [[NSMutableArray alloc] init];
    image_laoding_queue = [[NSMutableArray alloc] init];
    NSMutableArray *spinners = [[NSMutableArray alloc] init];
    
    
    UIActivityIndicatorView *indi = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indi startAnimating];
    indi.hidesWhenStopped = YES;
    [imgscroll addSubview:indi];
    [spinners addObject:indi];
    
    
    UITapGestureRecognizer *imgtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgtapped:)];
    productImage = [[ImageWithData alloc] init];
    productImage.userInteractionEnabled = YES;
    [productImage addGestureRecognizer:imgtap];
    productImage.contentMode = UIViewContentModeScaleAspectFit;
    
    
    
    productImage.image = self.product.itemImage;
    
    activeImg = productImage;
    [images addObject:productImage];
    [imgscroll addSubview:productImage];
    
    if (productImage.image == nil){
        NSString *url = self.product.imageURL;
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        productImage.url = [NSURL URLWithString:url];
        productImage.indicator = indi;
        [image_laoding_queue addObject:productImage];
        /*[Config loadImageURL:self.product.imageURL toImageView:productImage withCacheKey:[NSString stringWithFormat:@"prod_%@", self.product.product_id] trim:YES sizeMultiplyer:3 completion:^{
         [indi stopAnimating];
         }];*/
    }
    
    
    
    for (int i= 0 ; i < self.product.images.count; i++){
        NSString *url = [self.product.images objectAtIndex:i];
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        UIActivityIndicatorView *indi = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [indi startAnimating];
        indi.hidesWhenStopped = YES;
        [imgscroll addSubview:indi];
        [spinners addObject:indi];
        
        
        
        ImageWithData *uiv = [[ImageWithData alloc] init];
        uiv.contentMode = UIViewContentModeScaleAspectFit;
        uiv.url = [NSURL URLWithString:url];
        uiv.userInteractionEnabled = YES;
        UITapGestureRecognizer *otherimgtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgtapped:)];
        [uiv addGestureRecognizer:otherimgtap];
        uiv.indicator = indi;
        [images addObject:uiv];
        [image_laoding_queue addObject:uiv];
        [imgscroll addSubview:uiv];
        
        
        /*[Config loadImageURL:url toImageView:uiv withCacheKey:url trim:YES sizeMultiplyer:3 completion:^{
         [indi stopAnimating];
         }];*/
        
    }
    
    
    [vs setObject:images forKey:@"images"];
    [vs setObject:spinners forKey:@"spinners"];
    [scroll addSubview:imgscroll];
    
    
    
    page = [[UIPageControl alloc] init];
    page.numberOfPages = images.count;
    [vs setObject:page forKey:@"image_page"];
    [scroll addSubview:page];
    if (images.count <= 1) page.hidden = YES;
    
    
    UIView *infopane = [[UIView alloc] init];
    [vs setObject:infopane forKey:@"info_pane"];
    height+=40;
    UITextView *name = [[UITextView alloc] init];
    name.text = self.product.name;
    name.editable = NO;
    name.scrollEnabled = NO;
    name.textAlignment = NSTextAlignmentLeft;
    [infopane addSubview:name];
    [vs setObject:name forKey:@"name"];
    
    UILabel *brand = [[UILabel alloc] init];
    brand.text = self.product.brand;
    brand.font = [UIFont systemFontOfSize:16];
    brand.textAlignment = NSTextAlignmentLeft;
    [infopane addSubview:brand];
    [vs setObject:brand forKey:@"brand"];
    
    
    double p = 0;
    double sp = 0;
    BOOL hassale = false;
    NSString *varid;
    for (ProductVar *pv in self.product.variations){
        if (p == 0) {
            p = pv.price;
            if (pv.sale_price > 0 && pv.sale_price < pv.price) {
                hassale = YES;
                sp=pv.sale_price;
            }
            varid = pv.product_var_id;
        }
        if (pv.price < p) {
            p = pv.price;
            if (pv.sale_price > 0 && pv.sale_price<pv.price) {
                hassale = YES;
                sp=pv.sale_price;
            }
            varid = pv.product_var_id;
        }
        
        
    }
    
    
    price = [[UILabel alloc] init];
    price.text =[NSString stringWithFormat:@"%@%0.2f", [self.config getCurrencySymbol], p];
    price.textAlignment = NSTextAlignmentLeft;
    
    
    [infopane addSubview:price];
    [vs setObject:price forKey:@"price"];
    
    
    sale_sale = [[UILabel alloc] init];
    sale_sale.adjustsFontSizeToFitWidth = YES;
    sale_sale.textAlignment = NSTextAlignmentLeft;
    [vs setObject:sale_sale forKey:@"sale"];
    [infopane addSubview:sale_sale];
    
    if (hassale){
        
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%0.2f", [self.config getCurrencySymbol], p]];
        [attributeString addAttribute:NSStrikethroughStyleAttributeName
                                value:[NSNumber numberWithInt:1]
                                range:(NSRange){0,[attributeString length]}];
        sale_sale.text = @"";
        
        sale_sale.attributedText = attributeString;
        
        
        price.text = [NSString stringWithFormat:@"%@%0.2f",[self.config getCurrencySymbol],sp];
        price.textColor = [UIColor colorWithRed:204/255.0 green:76/255.0 blue:70/255.0 alpha:1];
        price.hidden = NO;
    }
    
    
    [scroll addSubview:infopane];
    
    attributes = [[NSMutableDictionary alloc] init];
    for (ProductVar *pv in self.product.variations){
        NSArray *keys = [pv.attributes allKeys];
        for (NSString *key in keys){
            if ([attributes objectForKey:key] == nil){
                [attributes setObject:[[NSMutableArray alloc] init] forKey:key];
            }
        }
    }
    for (ProductVar *pv in self.product.variations){
        NSArray *keys = [pv.attributes allKeys];
        for (NSString *key in keys){
            NSString *val = [pv.attributes objectForKey:key];
            if (val == nil || val.length == 0) val=[NSString stringWithFormat:@"No %@", key];
            NSMutableArray *vals = [attributes objectForKey:key];
            BOOL found = false;
            for (NSString *str in vals){
                if ([str isEqualToString:val]){
                    found = true;
                }
            }
            if (!found) {
                hasvar = YES;
                [vals addObject:val];
            }
        }
    }
    
    if (self.product.variations.count == 1) hasvar = NO;
    
    
    
    
    
    if (hasvar){
        
        
        UIView *varview = [[UIView alloc] init];
        varbtns = [[NSMutableArray alloc] init];
        
        int hasOneVar = 0;
        for (NSString *str in [attributes allKeys]){
            
            ButtonWithValues *bval = [[ButtonWithValues alloc] init];
            
            
            bval.key = str;
            
            NSArray *vals = [attributes objectForKey:str];
            int hasOneVar = 0;
            if (vals.count == 1){
                NSString *attr =[[attributes objectForKey:str] objectAtIndex:0];
                [bval setTitle:attr forState:UIControlStateNormal];
                [bval addTarget:self action:@selector(no_attr_btn:) forControlEvents:UIControlEventTouchUpInside];
                
                
                UILabel *carrot = [[UILabel alloc] init];
                carrot.font = [IonIcons fontWithSize:15];
                carrot.textAlignment = NSTextAlignmentCenter;
                carrot.textColor = [UIColor lightGrayColor];
                carrot.tag = 1;
                [bval addSubview:carrot];
                hasOneVar++;
                [sel_attr setObject:attr forKey:bval.key];
                
            } else {
                [bval setTitle:[NSString stringWithFormat:@"%@",str] forState:UIControlStateNormal];
                [bval addTarget:self action:@selector(attr_btn:) forControlEvents:UIControlEventTouchUpInside];
                
                UILabel *carrot = [[UILabel alloc] init];
                carrot.font = [IonIcons fontWithSize:15];
                carrot.textAlignment = NSTextAlignmentCenter;
                carrot.textColor = [UIColor lightGrayColor];
                carrot.text = icon_arrow_down_b;
                carrot.tag = 1;
                [bval addSubview:carrot];
            }
            [varview addSubview:bval];
            [varbtns addObject:bval];
            
        }
        if (hasOneVar == [[attributes allKeys] count] && self.product.variations.count > 0){
            selvar = [self.product.variations objectAtIndex:0];
        }
        [vs setObject:varbtns forKey:@"var_btns"];
        [vs setObject:varview forKey:@"var_sel"];
        [scroll addSubview:varview];
        
        
        
    } else {
        
        
        UIView *varview = [[UIView alloc] init];
        varbtns = [[NSMutableArray alloc] init];
        int count = 0;
        for (NSString *str in [attributes allKeys]){
            
            ButtonWithValues *bval = [[ButtonWithValues alloc] init];
            bval.key = str;
            //NSLog(@"%@", [attributes objectForKey:str]);
            [bval setTitle:[[attributes objectForKey:str] objectAtIndex:0] forState:UIControlStateNormal];
            [bval addTarget:self action:@selector(no_attr_btn:) forControlEvents:UIControlEventTouchUpInside];
            
            [varview addSubview:bval];
            [varbtns addObject:bval];
            count++;
        }
        
        [vs setObject:varbtns forKey:@"var_btns"];
        [vs setObject:varview forKey:@"var_sel"];
        [scroll addSubview:varview];
        
        
    }
    
    
    
    
    
    UIFont *font = [UIFont systemFontOfSize:16];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                                                forKey:NSFontAttributeName];
    
    
    ss = [[SocialShareModule alloc] init];
    ss.parent = self;
    ss.config = self.config;
    [ss build_share_buttons];
    [ss share_action_target:self action:@selector(share:)];
    [vs setObject:ss forKey:@"share"];
    [scroll addSubview:ss];
    
    
    
    webbackground = [[UIView alloc] init];
    webbackground.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0.0f, 0.0f, webbackground.frame.size.width, 0.5f);
    topBorder.backgroundColor = [[UIColor colorWithRed:0.945 green:0.945 blue:0.945 alpha:1] CGColor];
    [webbackground.layer addSublayer:topBorder];
    
    [vs setObject:webbackground forKey:@"web_background"];
    
    
    UITextView *tv = [[UITextView alloc] init];
    tv.text = self.product.desc;
    [vs setObject:tv forKey:@"web_size"];
    
    UIWebView *wv =[[UIWebView alloc] init];
    //wv.userInteractionEnabled = NO;
    
    wv.delegate = self;
    [vs setObject:wv forKey:@"web"];
    [webbackground addSubview:wv];
    
    UILabel *desTitle = [[UILabel alloc] init];
    desTitle.text = [self.config localisedString:@"Description"];
    [vs setObject:desTitle forKey:@"des_title"];
    [webbackground addSubview:desTitle];
    
    
    
    [scroll addSubview:webbackground];
    
    height+=wv.frame.size.height;
    
    
    
    [self.view insertSubview:scroll belowSubview:addcart];
    
    [vs setObject:scroll forKey:@"main"];
    
    [Design product_detail:vs config:self.config];
    
    [NSThread detachNewThreadSelector:@selector(load_images) toTarget:self withObject:nil];
    
    NSString *myDescriptionHTML = [NSString stringWithFormat:@"<html> \n"
                                   "<head> \n"
                                   "<style type=\"text/css\"> \n"
                                   "body {font-family: \"%@\"; font-size: %@; word-break:break-all;}\n"
                                   "</style> \n"
                                   "</head> \n"
                                   "<body>%@</body> \n"
                                   "</html>", @"helvetica", @"10pt", self.product.desc ];
    [wv loadHTMLString:myDescriptionHTML baseURL:nil];
    
    imgscrollframe = imgscroll.frame;
}


-(void)build_finx_detailpage{
    
    
    NSMutableDictionary *vs = [[NSMutableDictionary alloc] init];
    
    addcart = [[UIButton alloc] init];
    [addcart addTarget:self action:@selector(add_to_card:) forControlEvents:UIControlEventTouchUpInside];
    UIView *addcartview = [[UIView alloc] init];
    addcartview.userInteractionEnabled = NO;
    addcarttop = [[UILabel alloc] init];
    addcarttop.userInteractionEnabled = NO;
    addcartmiddle = [[UILabel alloc] init];
    addcartmiddle.userInteractionEnabled = NO;
    addcartbottom = [[UILabel alloc] init];
    addcartbottom.userInteractionEnabled = NO;
    [addcart addSubview:addcartview];
    [addcartview addSubview:addcarttop];
    [addcartview addSubview:addcartmiddle];
    [addcartview addSubview:addcartbottom];
    [vs setObject:addcart forKey:@"add_cart"];
    [vs setObject:addcartview forKey:@"add_cart_view"];
    [vs setObject:addcarttop forKey:@"add_cart_top"];
    [vs setObject:addcartmiddle forKey:@"add_cart_middle"];
    [vs setObject:addcartbottom forKey:@"add_cart_bottom"];
    NSString *dstr = [[[[self.config.design objectForKey:@"components"] objectForKey:@"filter_page"] objectForKey:@"style"] objectForKey:@"apply-background"];
    [Design style:[[DOM alloc] initWithView:addcartview parent:nil] design:[[self.config.design objectForKey:@"design"] objectForKey:dstr] config:self.config];
    [self.view addSubview:addcart];
    
    if (self.product.total_stock == 0) {
        addcart.enabled = NO;
        addcartview.alpha = 0.5;
        addcartmiddle.text = [self.config localisedString:@"Sold Out"];
        
    } else {
        if (self.config.user_id == nil || self.config.user_id.length == 0 || [self.config.user_id isEqualToString:@"0"]){
            //[addcart setTitle:@"Sign in to add to cart" forState:UIControlStateNormal];
            addcarttop.text = [self.config localisedString:@"SIGN UP OR LOG IN TO"];
            addcartbottom.text = [self.config localisedString:@"ADD TO CART"];
            addcartmiddle.text = @"";
        } else {
            // [addcart setTitle:@"Add to cart" forState:UIControlStateNormal];
            [self check_fav];
            [self.config check_cart_with_view:cartbtn];
            addcarttop.text = @"";
            addcartbottom.text = @"";
            addcartmiddle.text = [self.config localisedString:@"ADD TO CART"];
            
            
        }
    }
    
    NSMutableData *da = [[NSMutableData alloc] init];
    receivedData = [[NSMutableArray alloc] initWithObjects:da, nil];
    pickerval = [[NSMutableArray alloc] init];
    sel_attr = [[NSMutableDictionary alloc] init];
    [vs setObject:var_cancel forKey:@"var_sel_cancel"];
    [vs setObject:var_done forKey:@"var_sel_done"];
    [vs setObject:var_clear forKey:@"var_sel_clear"];
    [vs setObject:accessory forKey:@"var_sel_view"];
    
    
    
    hidden = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    hidden.inputView = picker;
    hidden.inputAccessoryView = accessory;
    [self.view addSubview:hidden];
    
    double height = 0;
    imgscroll = [[UIScrollView alloc] init];
    
    UISwipeGestureRecognizer *toright = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goleft)];
    toright.direction = UISwipeGestureRecognizerDirectionRight;
    UISwipeGestureRecognizer *toleft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goright)];
    toleft.direction = UISwipeGestureRecognizerDirectionLeft;
    [imgscroll addGestureRecognizer:toleft];
    [imgscroll addGestureRecognizer:toright];
    
    imgscroll.scrollEnabled = NO;
    [imgscroll delaysContentTouches];
    
    [vs setObject:imgscroll forKey:@"image_scroll"];
    
    images = [[NSMutableArray alloc] init];
    image_laoding_queue = [[NSMutableArray alloc] init];
    NSMutableArray *spinners = [[NSMutableArray alloc] init];
    
    
    UIActivityIndicatorView *indi = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indi.hidesWhenStopped = YES;
    [indi startAnimating];
    [imgscroll addSubview:indi];
    [spinners addObject:indi];
    
    
    
    UITapGestureRecognizer *imgtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgtapped:)];
    productImage = [[ImageWithData alloc] init];
    productImage.userInteractionEnabled = YES;
    [productImage addGestureRecognizer:imgtap];
    productImage.contentMode = UIViewContentModeScaleAspectFit;
    productImage.tag = 0;
    productImage.item_id = self.product.imageURL;
    productImage.image = self.product.itemImage;
    
    
    activeImg = productImage;
    [images addObject:productImage];
    [imgscroll addSubview:productImage];
    
    
    if (productImage.image == nil){
        NSString *url = self.product.imageURL;
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        productImage.url = [NSURL URLWithString:url];
        productImage.indicator = indi;
        [image_laoding_queue addObject:productImage];
        /*[Config loadImageURL:self.product.imageURL toImageView:productImage withCacheKey:[NSString stringWithFormat:@"prod_%@", self.product.product_id] trim:YES sizeMultiplyer:3 completion:^{
         [indi stopAnimating];
         }];*/
    }
    
    
    for (int i= 0 ; i < self.product.images.count; i++){
        NSString *url = [self.product.images objectAtIndex:i];
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        UIActivityIndicatorView *indi = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [indi startAnimating];
        indi.hidesWhenStopped = YES;
        [imgscroll addSubview:indi];
        [spinners addObject:indi];
        
        
        
        ImageWithData *uiv = [[ImageWithData alloc] init];
        uiv.tag = i+1;
        uiv.contentMode = UIViewContentModeScaleAspectFit;
        uiv.userInteractionEnabled = YES;
        UITapGestureRecognizer *otherimgtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgtapped:)];
        [uiv addGestureRecognizer:otherimgtap];
        uiv.indicator = indi;
        uiv.url = [NSURL URLWithString:url];
        uiv.item_id = [self.product.images objectAtIndex:i];
        [images addObject:uiv];
        [imgscroll addSubview:uiv];
        [image_laoding_queue addObject:uiv];
        
        
        
        
        /*[Config loadImageURL:url toImageView:uiv withCacheKey:url trim:YES sizeMultiplyer:3 completion:^{
         [indi stopAnimating];
         }];*/
        
    }
    
    
    [vs setObject:images forKey:@"images"];
    [vs setObject:spinners forKey:@"spinners"];
    [scroll addSubview:imgscroll];
    
    page = [[UIPageControl alloc] init];
    page.numberOfPages = images.count;
    [vs setObject:page forKey:@"image_page"];
    [scroll addSubview:page];
    if (images.count <= 1) page.hidden = YES;
    
    
    UIView *infopane = [[UIView alloc] init];
    [vs setObject:infopane forKey:@"info_pane"];
    
    UITextView *name = [[UITextView alloc] init];
    UILabel *brand = [[UILabel alloc] init];
    
    
    name.text = self.product.name;
    name.editable = NO;
    name.scrollEnabled = NO;
    name.textAlignment = NSTextAlignmentLeft;
    CGRect nameframe = CGRectMake(20, 15, self.config.screenWidth-40, 45);
    name.contentInset = UIEdgeInsetsMake(-5, -5, 0, 0);
    name.font = [UIFont boldSystemFontOfSize:20];
    CGSize s =[name sizeThatFits:CGSizeMake(nameframe.size.width, FLT_MAX)];
    nameframe.size.height = s.height;
    name.frame = nameframe;
    [vs setObject:name forKey:@"name"];
    
    name.textColor = [UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1];
    [infopane addSubview:name];
    //[vs setObject:name forKey:@"name"];
    if (design.hide_brand == 0) {
        UILabel *brand = [[UILabel alloc] init];
        brand.text = self.product.brand;
        brand.font = [UIFont systemFontOfSize:16];
        brand.textAlignment = NSTextAlignmentLeft;
        brand.frame = CGRectMake(20, 3, self.config.screenWidth-40, 15);
        brand.textColor = [UIColor colorWithRed:61/255.0 green:61/255.0 blue:61/255.0 alpha:1];
        [infopane addSubview:brand];
        //[vs setObject:brand forKey:@"brand"];
    }
    
    
    double p = 0;
    double sp = 0;
    BOOL hassale = false;
    NSString *varid;
    for (ProductVar *pv in self.product.variations){
        if (p == 0) {
            p = pv.price;
            if (pv.sale_price > 0 && pv.sale_price < pv.price) {
                hassale = YES;
                sp=pv.sale_price;
            }
            varid = pv.product_var_id;
        }
        if (pv.price < p) {
            p = pv.price;
            if (pv.sale_price > 0 && pv.sale_price<pv.price) {
                hassale = YES;
                sp=pv.sale_price;
            }
            varid = pv.product_var_id;
        }
        
        
    }
    
    UILabel *exprice = [[UILabel alloc] init];
    exprice.textAlignment=NSTextAlignmentLeft;
    exprice.text = [NSString stringWithFormat:@"%@%0.2f",[self.config getCurrencySymbol], p];
    exprice.frame = CGRectMake(name.frame.origin.x, name.frame.origin.y+name.frame.size.height, name.frame.size.width, 15);
    exprice.font = [UIFont systemFontOfSize:20];
    [vs setObject:exprice forKey:@"price"];
    [infopane addSubview:exprice];
    
    if (hassale){
        //frame = CGRectMake(0, image.frame.size.width*1.533+45, image.frame.size.width/2, 10);
        //exprice.frame = frame;
        exprice.adjustsFontSizeToFitWidth = YES;
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%0.2f  %@%0.2f",[self.config getCurrencySymbol], p, [self.config getCurrencySymbol], sp]];
        
        
        NSString *pstr = [NSString stringWithFormat:@"%@%0.2f", [self.config getCurrencySymbol],p];
        //NSString *s = [NSString stringWithFormat:@"$%0.2f", sale_price];
        [attributeString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:1] range:(NSRange){0,[pstr length]}];
        
        UIColor *priceColor = [UIColor colorWithRed:61/255.0 green:61/255.0 blue:61/255.0 alpha:1];
        
        UIColor *saleColor = [UIColor colorWithRed:204/255.0 green:76/255.0 blue:70/255.0 alpha:1];
        
        
        [attributeString addAttribute:NSForegroundColorAttributeName value:(id)priceColor range:NSMakeRange(0, [pstr length])];
        [attributeString addAttribute:NSFontAttributeName value:(id)[UIFont systemFontOfSize:20] range:NSMakeRange(0, [pstr length])];
        [attributeString addAttribute:NSForegroundColorAttributeName value:(id)saleColor range:NSMakeRange([pstr length], [attributeString length]-[pstr length])];
        [attributeString addAttribute:NSFontAttributeName value:(id)[UIFont boldSystemFontOfSize:20] range:NSMakeRange([pstr length], [attributeString length]-[pstr length])];
        
        exprice.text = @"";
        exprice.attributedText = attributeString;
        
    }
    
    
    
    [scroll addSubview:infopane];
    
    attributes = [[NSMutableDictionary alloc] init];
    int varcount = 0;
    for (ProductVar *pv in self.product.variations){
        if (pv.stock == 0) continue;
        NSArray *keys = [pv.attributes allKeys];
        varcount++;
        for (NSString *key in keys){
            if ([attributes objectForKey:key] == nil ){
                [attributes setObject:[[NSMutableArray alloc] init] forKey:key];
            }
        }
    }
    for (ProductVar *pv in self.product.variations){
        NSArray *keys = [pv.attributes allKeys];
        for (NSString *key in keys){
            NSString *val = [pv.attributes objectForKey:key];
            if (val == nil || val.length == 0) val=[NSString stringWithFormat:@"No %@", key];
            NSMutableArray *vals = [attributes objectForKey:key];
            BOOL found = false;
            for (NSString *str in vals){
                if ([str isEqualToString:val]){
                    found = true;
                }
            }
            if (!found) {
                hasvar = YES;
                [vals addObject:val];
            }
        }
    }
    
    
    
    if (varcount == 1) hasvar = NO;
    
    
    
    
    
    if (hasvar){
        
        
        UIView *varview = [[UIView alloc] init];
        varbtns = [[NSMutableArray alloc] init];
        int hasOneVar = 0;
        for (NSString *str in [attributes allKeys]){
            
            ButtonWithValues *bval = [[ButtonWithValues alloc] init];
            
            
            bval.key = str;
            
            NSArray *vals = [attributes objectForKey:str];
            if (vals.count == 1){
                NSString *attr =[[attributes objectForKey:str] objectAtIndex:0];
                [bval setTitle:attr forState:UIControlStateNormal];
                [bval addTarget:self action:@selector(no_attr_btn:) forControlEvents:UIControlEventTouchUpInside];
                
                
                UILabel *carrot = [[UILabel alloc] init];
                carrot.font = [IonIcons fontWithSize:15];
                carrot.textAlignment = NSTextAlignmentCenter;
                carrot.textColor = [UIColor lightGrayColor];
                carrot.tag = 1;
                [bval addSubview:carrot];
                
                carrot.text = icon_checkmark;
                bval.titleLabel.font = [UIFont boldSystemFontOfSize:17.3];
                hasOneVar++;
                [sel_attr setObject:attr forKey:bval.key];
                
            } else {
                [bval setTitle:[NSString stringWithFormat:@"%@",str] forState:UIControlStateNormal];
                [bval addTarget:self action:@selector(attr_btn:) forControlEvents:UIControlEventTouchUpInside];
                
                UILabel *carrot = [[UILabel alloc] init];
                carrot.font = [IonIcons fontWithSize:15];
                carrot.textAlignment = NSTextAlignmentCenter;
                carrot.textColor = [UIColor lightGrayColor];
                carrot.text = icon_arrow_down_b;
                carrot.tag = 1;
                [bval addSubview:carrot];
            }
            
            [varview addSubview:bval];
            [varbtns addObject:bval];
            
        }
        
        if (hasOneVar == [[attributes allKeys] count] && self.product.variations.count > 0){
            selvar = [self.product.variations objectAtIndex:0];
        }
        
        [vs setObject:varbtns forKey:@"var_btns"];
        [vs setObject:varview forKey:@"var_sel"];
        [scroll addSubview:varview];
        
        
    } else {
        
        
        UIView *varview = [[UIView alloc] init];
        varbtns = [[NSMutableArray alloc] init];
        int count = 0;
        for (NSString *str in [attributes allKeys]){
            
            ButtonWithValues *bval = [[ButtonWithValues alloc] init];
            bval.key = str;
            //NSLog(@"%@", [attributes objectForKey:str]);
            [bval setTitle:[[attributes objectForKey:str] objectAtIndex:0] forState:UIControlStateNormal];
            [bval addTarget:self action:@selector(no_attr_btn:) forControlEvents:UIControlEventTouchUpInside];
            
            
            UILabel *carrot = [[UILabel alloc] init];
            carrot.font = [IonIcons fontWithSize:15];
            carrot.textAlignment = NSTextAlignmentCenter;
            carrot.textColor = [UIColor lightGrayColor];
            carrot.tag = 1;
            [bval addSubview:carrot];
            
            carrot.text = icon_checkmark;
            bval.titleLabel.font = [UIFont boldSystemFontOfSize:17.3];
            
            [varview addSubview:bval];
            [varbtns addObject:bval];
            count++;
        }
        
        [vs setObject:varbtns forKey:@"var_btns"];
        [vs setObject:varview forKey:@"var_sel"];
        [scroll addSubview:varview];
        
        
    }
    UIFont *font = [UIFont systemFontOfSize:16];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                                                forKey:NSFontAttributeName];
    
    UIView *shareback = [[UIView alloc] init];
    
    
    ss = [[SocialShareModule alloc] init];
    ss.parent = self;
    ss.config = self.config;
    [ss build_share_buttons];
    [ss share_action_target:self action:@selector(share:)];
    [vs setObject:ss forKey:@"share"];
    [vs setObject:shareback forKey:@"share_background"];
    [shareback addSubview:ss];
    [scroll addSubview:shareback];
    
    
    
    webbackground = [[UIView alloc] init];
    webbackground.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    [vs setObject:webbackground forKey:@"web_background"];
    
    
    UITextView *tv = [[UITextView alloc] init];
    tv.text = self.product.desc;
    [vs setObject:tv forKey:@"web_size"];
    
    UIWebView *wv =[[UIWebView alloc] init];
    //wv.userInteractionEnabled = NO;
    
    [vs setObject:wv forKey:@"web"];
    [webbackground addSubview:wv];
    
    UILabel *desTitle = [[UILabel alloc] init];
    desTitle.text = [self.config localisedString:@"Description"];
    desTitle.font = [UIFont boldSystemFontOfSize:16];
    [vs setObject:desTitle forKey:@"des_title"];
    [webbackground addSubview:desTitle];
    
    
    
    [scroll addSubview:webbackground];
    
    height+=wv.frame.size.height;
    
    
    
    
    [self.view insertSubview:scroll belowSubview:addcart];
    
    [vs setObject:scroll forKey:@"main"];
    
    [Design finx_product_detail:vs config:self.config];
    
    [NSThread detachNewThreadSelector:@selector(load_images) toTarget:self withObject:nil];
    
    //add modules here
    after_desc = [[NSMutableArray alloc] init];
    review = [[ProductReviewViewControllerModule alloc] init];
    review.config = self.config;
    review.product = self.product;
    review.delegate = self;
    //review.reviewSource = @"Twixxies";
    review.reviewSource = @"Twixxies";
    
    
    [review init_preview:CGRectMake(webbackground.frame.origin.x, webbackground.frame.origin.y+webbackground.frame.size.height, webbackground.frame.size.width, 40)];
    
    
    
    //review.preview.hidden = YES;
    
    [scroll addSubview:review.preview];
    [after_desc addObject:review.preview];
    
    
    NSString *myDescriptionHTML = [NSString stringWithFormat:@"<html> \n"
                                   "<head> \n"
                                   "<style type=\"text/css\"> \n"
                                   "body {font-family: \"%@\"; word-break:break-all;}\n"
                                   "</style> \n"
                                   "</head> \n"
                                   "<body>%@</body> \n"
                                   "</html>", @"HelveticaNeue-Light", self.product.desc ];
    [wv loadHTMLString:myDescriptionHTML baseURL:nil];
    wv.delegate = self;
    
    
    imgscrollframe = imgscroll.frame;
}


-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //CGFloat newHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"] floatValue];
    CGFloat newHeight = webView.scrollView.contentSize.height;
    extra = 30;
    float mult = 5;
    
    /* if (self.config.screenWidth >= 375){
     extra = 70;
     mult = 10;
     } else if (self.config.screenWidth >= 400) {
     extra = 160;
     mult = 30;
     }
     extra += mult * (((int)newHeight/50)+1);*/
    
    webView.frame = CGRectMake(10, 37, webbackground.frame.size.width-20, newHeight+extra);
    webbackground.frame = CGRectMake(webbackground.frame.origin.x, webbackground.frame.origin.y, webbackground.frame.size.width, webView.frame.origin.y+webView.frame.size.height);
    
    
    
    if ([design.desc_type isEqualToString:@"partial"] && webView.frame.size.height > 80){
        design.desc_show = webbackground.frame;
        design.desc_hide = CGRectMake(webbackground.frame.origin.x, webbackground.frame.origin.y, webbackground.frame.size.width, 180);
        
        webbackground.clipsToBounds = YES;
        webbackground.frame= design.desc_hide;
        
        webbackbutton = [[UIView alloc] initWithFrame:CGRectMake(0, webbackground.frame.size.height-30, webbackground.frame.size.width, 30)];
        webbackbutton.backgroundColor = [UIColor whiteColor];
        [webbackground addSubview:webbackbutton];
        
        if (design.desc_show.size.height > design.desc_hide.size.height) {
            readmore = [[UIButton alloc] initWithFrame:CGRectMake(webbackbutton.frame.size.width-110, 0, 100, 20)];
            [readmore setTitle:[self.config localisedString:@"Read more"] forState:UIControlStateNormal];
            [readmore setTitleColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
            readmore.titleLabel.font = [UIFont boldSystemFontOfSize:16];
            [readmore addTarget:self action:@selector(readmore:) forControlEvents:UIControlEventTouchUpInside];
            [webbackbutton addSubview:readmore];
            
            readless = [[UIButton alloc] initWithFrame:CGRectMake(webbackbutton.frame.size.width-70, 0, 60, 20)];
            [readless setTitle:[self.config localisedString:@"Hide"] forState:UIControlStateNormal];
            [readless setTitleColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
            readless.titleLabel.font = [UIFont boldSystemFontOfSize:16];
            readless.hidden = YES;
            [readless addTarget:self action:@selector(readmore:) forControlEvents:UIControlEventTouchUpInside];
            [webbackbutton addSubview:readless];
        }
        
        
        
        for (int i = 0 ; i < after_desc.count; i++){
            UIView *v = [after_desc objectAtIndex:i];
            CGRect frame = v.frame;
            if (i == 0){
                frame.origin.y = webbackground.frame.origin.y+webbackground.frame.size.height;
                v.frame = frame;
            } else {
                UIView *prev = [after_desc objectAtIndex:i-1];
                frame.origin.y = prev.frame.origin.y+prev.frame.size.height;
                v.frame = frame;
            }
            [scroll setContentSize:CGSizeMake(self.config.screenWidth, v.frame.origin.y+v.frame.size.height + 71+extra)];
        }
        
        [scroll setContentSize:CGSizeMake(self.config.screenWidth, webbackground.frame.origin.y+webbackground.frame.size.height+71+extra)];
        if (webbackground.frame.origin.y+webbackground.frame.size.height+71+extra < self.config.screenHeight) [scroll setContentSize:CGSizeMake(self.config.screenWidth, self.config.screenHeight+71+extra)];
        
        
    } else {
        
        [scroll setContentSize:CGSizeMake(self.config.screenWidth, webbackground.frame.origin.y+webbackground.frame.size.height + 71+extra)];
        if (webbackground.frame.origin.y+webbackground.frame.size.height+71+extra < self.config.screenHeight) [scroll setContentSize:CGSizeMake(self.config.screenWidth, self.config.screenHeight+71+extra)];
    }
    
    for (int i = 0 ; i < after_desc.count; i++){
        UIView *v = [after_desc objectAtIndex:i];
        CGRect frame = v.frame;
        if (i == 0){
            frame.origin.y = webbackground.frame.origin.y+webbackground.frame.size.height;
            v.frame = frame;
        } else {
            UIView *prev = [after_desc objectAtIndex:i-1];
            frame.origin.y = prev.frame.origin.y+prev.frame.size.height;
            v.frame = frame;
        }
        [scroll setContentSize:CGSizeMake(self.config.screenWidth, v.frame.origin.y+v.frame.size.height + 71+extra)];
        if (webbackground.frame.origin.y+webbackground.frame.size.height+71+extra < self.config.screenHeight) [scroll setContentSize:CGSizeMake(self.config.screenWidth, self.config.screenHeight+71+extra)];
    }
    
}

-(void)load_images{
    for (ImageWithData *img in image_laoding_queue){
        if (!shoudLoadImg) return;
        if (img != nil && img.url != nil){
            NSString *url = [img.url absoluteString];
            
            
            [Config loadImageURL:url toImageView:img withCacheKey:url trim:YES sizeMultiplyer:2.5 completion:^{
                [img.indicator stopAnimating];
            }];
        }
    }
}
-(IBAction)readmore:(id)sender{
    if (sender == readmore){
        webbackground.frame=design.desc_show;
        [scroll setContentSize:CGSizeMake(self.config.screenWidth, webbackground.frame.origin.y+webbackground.frame.size.height+71+extra)];
        webbackbutton.frame = CGRectMake(0, webbackground.frame.size.height-30, webbackground.frame.size.width, 30);
        readmore.hidden = YES;
        readless.hidden = NO;
        
        for (UIView *v in after_desc){
            CGRect frame = v.frame;
            frame.origin.y = webbackground.frame.origin.y+webbackground.frame.size.height;
            v.frame = frame;
            [scroll setContentSize:CGSizeMake(self.config.screenWidth, v.frame.origin.y+v.frame.size.height + 71+extra)];
            if (webbackground.frame.origin.y+webbackground.frame.size.height+71+extra < self.config.screenHeight) [scroll setContentSize:CGSizeMake(self.config.screenWidth, self.config.screenHeight+71+extra)];
        }
        
    } else {
        webbackground.frame=design.desc_hide;
        [scroll setContentSize:CGSizeMake(self.config.screenWidth, webbackground.frame.origin.y+webbackground.frame.size.height+71+extra)];
        readmore.hidden = NO;
        readless.hidden = YES;
        webbackbutton.frame = CGRectMake(0, webbackground.frame.size.height-30, webbackground.frame.size.width, 30);
        
        for (UIView *v in after_desc){
            CGRect frame = v.frame;
            frame.origin.y = webbackground.frame.origin.y+webbackground.frame.size.height;
            v.frame = frame;
            [scroll setContentSize:CGSizeMake(self.config.screenWidth, v.frame.origin.y+v.frame.size.height + 71+extra)];
            if (webbackground.frame.origin.y+webbackground.frame.size.height+71+extra < self.config.screenHeight) [scroll setContentSize:CGSizeMake(self.config.screenWidth, self.config.screenHeight+71+extra)];
        }
    }
}

-(void)preview_finish_loading{
    [self adjust_scroll_height];
}

-(void)goto_detail_page{
    if (review != nil)
        [self.navigationController pushViewController:review animated:YES];
}

-(void)adjust_scroll_height{
    if (scroll == nil) return;
    CGFloat maxheight = -100;
    CGFloat maxy = -100;
    for (UIView *v in scroll.subviews){
        if (v.frame.origin.y > maxy){
            maxy = v.frame.origin.y;
            maxheight = v.frame.size.height;
        }
    }
    scroll.contentSize = CGSizeMake(self.config.screenWidth, maxy+maxheight+71+64+extra);
    if (maxy+maxheight+71+extra < self.config.screenHeight) [scroll setContentSize:CGSizeMake(self.config.screenWidth, self.config.screenHeight+71+64+extra)];
}

-(void)imgtapped:(UITapGestureRecognizer *)ges{
    /*enlargeimgeview.image = activeImg.image;
     enlargeView.hidden = NO;
     enlargeView.userInteractionEnabled = YES;
     
     [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
     animations:^{
     enlargeView.alpha = 1;
     } completion:^(BOOL finished) {
     }];*/
    
    ProductDetailImageViewController *pdi = [[ProductDetailImageViewController alloc] initWithNibName:@"ProductDetailImageViewController" bundle:nil];
    pdi.config = self.config;
    pdi.images = images;
    pdi.activeImage = activeImg;
    pdi.product_name = self.product.name;
    [self.navigationController presentViewController:pdi animated:YES completion:nil];
    
}

-(void)goleft{
    for (int i = 0; i < images.count; i++){
        UIImageView *img = [images objectAtIndex:i];
        if (imgscroll.contentOffset.x == img.frame.origin.x - 30){
            if (i > 0) {
                ImageWithData *prev = (ImageWithData *)[images objectAtIndex:i-1];
                activeImg = prev;
                [self scroll:imgscroll animateTo:CGPointMake(prev.frame.origin.x-30, 0)];
                page.currentPage--;
                return;
            }
            
        }
    }
}
-(void)goright{
    for (int i = 0; i < images.count; i++){
        UIImageView *img = [images objectAtIndex:i];
        if (imgscroll.contentOffset.x == img.frame.origin.x - 30){
            if (i < images.count - 1) {
                ImageWithData *prev = (ImageWithData *)[images objectAtIndex:i+1];
                activeImg = prev;
                [self scroll:imgscroll animateTo:CGPointMake(prev.frame.origin.x-30, 0)];
                page.currentPage++;
                return;
            }
            
        }
    }
}

-(void)scroll:(UIScrollView *)scrollView animateTo:(CGPoint)point{
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [scrollView setContentOffset:point];
                         
                         
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(IBAction)no_attr_btn:(id)sender{
    UIButton *btn = (UIButton *)sender;
    UILabel *carrot = (UILabel *)[btn viewWithTag:1];
    if (carrot.text.length == 0){
        carrot.text = icon_checkmark;
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:17.3];
    } else {
        carrot.text = @"";
        btn.titleLabel.font = [UIFont systemFontOfSize:17.3];
    }
}
-(IBAction)attr_btn:(id)sender{
    @try {
        choose = (ButtonWithValues *)sender;
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        [pickerdisabled removeAllObjects];
        
        [pickerval removeAllObjects];
        
        NSMutableArray *notavailable = [[NSMutableArray alloc] init];
        if ([sel_attr objectForKey:choose.key] != nil){
            prev_sel_var = [[NSMutableDictionary alloc] init];
            [prev_sel_var setObject:[sel_attr objectForKey:choose.key] forKey:choose.key];
        }
        [sel_attr removeObjectForKey:choose.key];
        //[choose setTitle:[NSString stringWithFormat:@"%@", choose.key] forState:UIControlStateNormal];
        //selvarid = @"";
        if ([[sel_attr allKeys] count] > 0){
            //[pickerval addObject:choose.key];
            for (NSString *key in [sel_attr allKeys]){
                NSString *val = [sel_attr objectForKey:key];
                if (val == nil || val.length == 0) continue;
                for (ProductVar *v in self.product.variations){
                    NSString *pval = [v.attributes objectForKey:key];
                    if (pval == nil || pval.length == 0) continue;
                    int found = 0;
                    if ([val isEqualToString:pval] && v.stock > 0){
                        pval = [v.attributes objectForKey:choose.key];
                        if (pval == nil || pval.length == 0) continue;
                        
                        
                        for (NSString *str in arr) {
                            if ([str isEqualToString: pval]) found = 1;
                        }
                        
                        if (found == 0) [arr addObject:pval];
                        
                    } else {
                        
                        pval = [v.attributes objectForKey:choose.key];
                        for (NSString *str in notavailable) {
                            if ([str isEqualToString:pval]) found = 1;
                        }
                        if (found == 0 && v.stock != 0) [notavailable addObject:pval];
                        
                    }
                    
                }
                for (NSString *str in arr){
                    int removeindex = -1;
                    for (int i = 0 ; i < notavailable.count; i++) {
                        NSString *not = [notavailable objectAtIndex:i];
                        if ([str isEqualToString:not]) removeindex = i;
                    }
                    if (removeindex >= 0)[notavailable removeObjectAtIndex:removeindex];
                }
                for (NSString *str in notavailable){
                    [arr addObject:str];
                    [pickerdisabled addObject:str];
                }
            }
        }
        else if ([[sel_attr allKeys] count] == 0) {
            // [pickerval addObject:choose.key];
            for (ProductVar *v in self.product.variations){
                
                NSString *pval = [v.attributes objectForKey:choose.key];
                if (pval == nil || pval.length == 0 || v.stock == 0) continue;
                int found = 0;
                for (NSString *str in arr) {
                    if ([str isEqualToString: pval]) found = 1;
                }
                if (found == 0) [arr addObject:pval];
                
            }
        }
        
        [pickerval addObjectsFromArray:[arr sortedArrayUsingComparator:^NSComparisonResult(NSString *a, NSString *b) {
            NSDictionary *sizecompare = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"OS",@"2", @"3XS", @"3",@"XXXS", @"4", @"2XS", @"5", @"XXS", @"6", @"XS", @"7", @"S",@"8", @"M",@"9", @"L",@"10",@"XL",@"11",@"2XL", @"12", @"XXL",@"13", @"3XL", @"14",@"XXXL", @"15",@"4XL", @"16",@"XXXXL", @"17", @"5XL",@"18",@"XXXXXL", nil];
            NSString *key1 = [sizecompare objectForKey:[a uppercaseString]];
            NSString *key2 = [sizecompare objectForKey:[b uppercaseString]];
            if (key1 == nil || key2 == nil){
                float f1 = [a floatValue];
                float f2 = [b floatValue];
                if (f1 >0 && f2 > 0) return f1 > f2 ? 1: -1;
                else if (f1 > 0 && f2 == 0) return 1;
                else if (f1 == 0 && f2 > 0) return -1;
                else return [a compare:b];
            } else {
                float f1 = [key1 intValue];
                float f2 = [key2 intValue];
                return f1 > f2 ? 1: -1;
            }
            
        }]];
        
        
        
        [picker reloadAllComponents];
        //[picker selectRow:0 inComponent:0 animated:NO];
        [hidden becomeFirstResponder];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}






-(CGSize)imageSizeAfterAspectFit:(UIImageView*)imgview{
    
    
    float newwidth;
    float newheight;
    
    UIImage *i=imgview.image;
    
    if (i.size.height>=i.size.width){
        newheight=imgview.frame.size.height;
        newwidth=(i.size.width/i.size.height)*newheight;
        
        if(newwidth>imgview.frame.size.width){
            float diff=imgview.frame.size.width-newwidth;
            newheight=newheight+diff/newheight*newheight;
            newwidth=imgview.frame.size.width;
        }
        
    }
    else{
        newwidth=imgview.frame.size.width;
        newheight=(i.size.height/i.size.width)*newwidth;
        
        if(newheight>imgview.frame.size.height){
            float diff=imgview.frame.size.height-newheight;
            newwidth=newwidth+diff/newwidth*newwidth;
            newheight=imgview.frame.size.height;
        }
    }
    
    
    
    
    //adapt UIImageView size to image size
    //imgview.frame=CGRectMake(imgview.frame.origin.x+(imgview.frame.size.width-newwidth)/2,imgview.frame.origin.y+(imgview.frame.size.height-newheight)/2,newwidth,newheight);
    
    return CGSizeMake(newwidth, newheight);
    
}



-(void)update_price:(ProductVar *)var{
    price.hidden = NO;
    sale_ori.hidden = YES;
    sale_sale.hidden = YES;
    
    
    price.text =[NSString stringWithFormat:@"%@%0.2f",[self.config getCurrencySymbol],var.price];
    
    if (var.sale_price > 0 && var.sale_price < var.price){
        
        
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%0.2f",[self.config getCurrencySymbol],var.price]];
        [attributeString addAttribute:NSStrikethroughStyleAttributeName
                                value:[NSNumber numberWithInt:1]
                                range:(NSRange){0,[attributeString length]}];
        price.text = @"";
        price.hidden = YES;
        sale_ori.attributedText = attributeString;
        sale_ori.hidden = NO;
        
        sale_sale.text = [NSString stringWithFormat:@"%@%0.2f",[self.config getCurrencySymbol],var.sale_price];
        sale_sale.hidden = NO;
        
    }
    
    
}

-(IBAction)close:(id)sender{
    [hidden resignFirstResponder];
    if (prev_sel_var != nil) {
        [sel_attr setObject:[prev_sel_var objectForKey:choose.key] forKey:choose.key];
        prev_sel_var = nil;
    }
}

-(IBAction)var_clear:(id)sender{
    for (ButtonWithValues *cho in varbtns){
        NSArray *vals = [attributes objectForKey:cho.key];
        if (vals.count == 1) continue;
        [cho setTitle:cho.key forState:UIControlStateNormal];
        UILabel *icon = (UILabel *)[cho viewWithTag:1];
        icon.text = icon_arrow_down_b;
        cho.titleLabel.font = [UIFont systemFontOfSize:17.3];
        [sel_attr removeObjectForKey:cho.key];
    }
    
    
    ProductVar *v = [self.product.variations objectAtIndex:0];
    [self update_price:v];
    selvar = nil;
    prev_sel_var = nil;
    [hidden resignFirstResponder];
    
    
}
-(IBAction)var_select:(id)sender{
    NSString *d=[pickerval objectAtIndex:[picker selectedRowInComponent:0]];
    for (NSString *str in pickerdisabled){
        if ([d isEqualToString:str]){
            return;
        }
    }
    
    [choose setTitle:d forState:UIControlStateNormal];
    UILabel *icon = (UILabel *)[choose viewWithTag:1];
    icon.text = icon_checkmark;
    choose.titleLabel.font = [UIFont boldSystemFontOfSize:17.3];
    
    [sel_attr setObject:d forKey:choose.key];
    int count = 0;
    ProductVar *matched = nil;
    
    ImageWithData *scrolltoimg;
    int imgindex = 0;
    for (ProductVar *v in self.product.variations){
        BOOL match = YES;
        int firstvar = 0;
        for (NSString *key in [v.attributes allKeys]){
            //if ( ((NSString *)[v.attributes objectForKey:key]).length == 0) continue;
            
            if (![[sel_attr objectForKey:key] isEqualToString:[v.attributes objectForKey:key]]){
                match = NO;
            } else {
                
                if (firstvar == 0){
                    firstvar++;
                    if (v.images.count > 0 && count == 0){
                        NSString *url = [v.images objectAtIndex:0];
                        
                        for (int i = 0 ; i < images.count;i++){
                            ImageWithData *img = [images objectAtIndex:i];
                            if ([img.item_id isEqualToString:url]){
                                //[imgscroll setContentOffset:CGPointMake(img.frame.origin.x-30, 0) animated:YES];
                                scrolltoimg = img;
                                imgindex = i;
                            }
                        }
                    }
                    
                }
                
            }
        }
        if (match) {
            count++;
            matched = v;
            
            
            if (v.images.count > 0 && count == 1){
                NSString *url = [v.images objectAtIndex:0];
                
                for (int i = 0 ; i < images.count;i++){
                    ImageWithData *img = [images objectAtIndex:i];
                    if ([img.item_id isEqualToString:url]){
                        scrolltoimg = img;
                        imgindex = i;
                    }
                }
            } else {
                scrolltoimg = [images objectAtIndex:0];
                imgindex = 0;
            }
            
            
        }
    }
    if (count == 1) {
        [self update_price:matched];
        selvar = matched;
    }
    else selvar = nil;
    
    prev_sel_var = nil;
    
    if (scrolltoimg != nil){
        
        [imgscroll setContentOffset:CGPointMake(scrolltoimg.frame.origin.x-30, 0) animated:YES];
        page.currentPage = imgindex;
    }
    
    [hidden resignFirstResponder];
}



- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    /*NSString *d=[pickerval objectAtIndex:row];
     if (row == 0) {
     [choose setTitle:[NSString stringWithFormat:@"%@", d] forState:UIControlStateNormal];
     [sel_attr removeObjectForKey:choose.key];
     return;
     } else {
     [choose setTitle:d forState:UIControlStateNormal];
     [sel_attr setObject:d forKey:choose.key];
     }*/
    
    
    
    //selvar = [d objectForKey:@"product_var_id"];
    //[hidden resignFirstResponder];
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    NSString *d = [pickerval objectAtIndex:row];
    for (NSString *str in pickerdisabled){
        if ([d isEqualToString:str]){
            UILabel *disabled = [[UILabel alloc] init];
            disabled.textColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8];
            disabled.textAlignment = NSTextAlignmentCenter;
            disabled.text = str;
            return disabled;
        } else {
            
        }
    }
    UILabel *enabled = [[UILabel alloc] init];
    enabled.textColor = [UIColor blackColor];
    enabled.textAlignment = NSTextAlignmentCenter;
    enabled.text = d;
    return enabled;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *d=[pickerval objectAtIndex:row];
    return d;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickerval.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}



-(IBAction)add_to_card:(id)sender{
    if ((self.config.user_id == nil || self.config.user_id.length == 0) && !self.config.guest_checkout ){
        LoginViewController *lefty = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        lefty.config = self.config;
        [self presentViewController:lefty animated:YES completion:nil];
    } else if ((self.config.user_id == nil || self.config.user_id.length == 0) && self.config.guest_checkout){
        if (hasvar && selvar == nil){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Please choose a product variation."] message:nil delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
            [alert show];
            if (varbtns.count > 0){
                UIButton *varbtn = [varbtns objectAtIndex:0];
                UIView *varview = [varbtn superview];
                if (varview != nil){
                    CGPoint to = CGPointMake(varview.frame.origin.x, varview.frame.origin.y-60);
                    [scroll setContentOffset:to animated:YES];
                }
                
            }
            //[hidden becomeFirstResponder];
            return;
        } else if (!hasvar) selvar = [self.product.variations objectAtIndex:0];
        
        
        NSString *sku = @"";
        sku = selvar.sku;
        
        NSMutableDictionary *d = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.product.product_id, @"product_id", sku, @"sku", @"1", @"quantity", [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]], @"cart_id",nil];
        [self.config.cache.cart addObject:d];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Item has been added to your cart!"] message:nil delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
        [alert show];
        self.config.cartnum++;
        [self.config add_badge:cartbtn withnumber:self.config.cartnum];
        [self.config.cache save_default];
        shoudLoadImg = NO;
        [self.navigationController popViewControllerAnimated:YES];
        
    }else {
        if (hasvar && selvar == nil){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Please choose a product variation."] message:nil delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
            [alert show];
            if (varbtns.count > 0){
                UIButton *varbtn = [varbtns objectAtIndex:0];
                UIView *varview = [varbtn superview];
                if (varview != nil){
                    CGPoint to = CGPointMake(varview.frame.origin.x, varview.frame.origin.y-60);
                    [scroll setContentOffset:to animated:YES];
                }
                
            }
            //[hidden becomeFirstResponder];
            return;
        } else if (!hasvar) selvar = [self.product.variations objectAtIndex:0];
        
        
        NSString *sku = @"";
        sku = selvar.sku;
        
        NSString *myRequestString = [NSString stringWithFormat:@"user_id=%@&access_token=%@&device_token=%@&product_id=%@&sku=%@&app_uuid=%@&quantity=1", self.config.user_id, self.config.token, self.config.device_token, self.product.product_id, sku, self.config.APP_UUID];
        //NSLog(myRequestString);
        
        // Create Data from request
        NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", self.config.API_ROOT, self.config.API_ADD_CART]]];
        
        
        
        // set Request Type
        [request setHTTPMethod: @"POST"];
        // Set content-type
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
        // Set Request Body
        [request setHTTPBody: myRequestData];
        // Now send a request and get Response
        // NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
        // Log Response
        // NSString *response = [[NSString alloc] initWithBytes:[returnData bytes] length:[returnData length] encoding:NSUTF8StringEncoding];
        // NSLog(@"%@",response);
        
        NSMutableData *received = [receivedData objectAtIndex:ADD_TO_CART];
        [received setLength:0];
        NSURLConnectionWithTag *urlConnection = [[NSURLConnectionWithTag alloc] initWithRequest:request delegate:self tag:ADD_TO_CART];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    @try {
        NSURLConnectionWithTag *conn = (NSURLConnectionWithTag *)connection;
        NSMutableData *received = [receivedData objectAtIndex:conn.tag];
        [received appendData:data];
        
    }
    @catch (NSException *exception) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Failed to add to cart."] message:@"" delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
        [alert show];
        
        // [indicator stopAnimating];
        
        
    }
    
    
    
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    //[indicator stopAnimating];
    //loading = 0;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Failed to add to cart."] message:@"" delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
    [alert show];
    
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSURLConnectionWithTag *conn = (NSURLConnectionWithTag *)connection;
    NSMutableData *received = [receivedData objectAtIndex:conn.tag];
    
    @try {
        if (conn.tag == ADD_TO_CART ){
            NSLog(@"%@", conn.originalRequest.description);
            NSString *myxml = [[NSString alloc] initWithData:received encoding:NSASCIIStringEncoding];
            NSLog(@"%@", myxml);
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:received options:0 error:nil];
            if ([[dic objectForKey:@"success"] intValue] == 1){
                
                Product *p = [self.product copy_product];
                p.cart_id =[dic objectForKey:@"cart_id"];
                //p.selected_var = selvar;
                [self.config.cart addObject:p];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Item has been added to your cart!"] message:nil delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
                [alert show];
                self.config.cartnum++;
                [self.config add_badge:cartbtn withnumber:self.config.cartnum];
                shoudLoadImg = NO;
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                NSString *mes = [dic objectForKey:@"error"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Failed to add to cart."] message:@"" delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
                [alert show];
            }
            
            
            
            
            
        }
        
        
        
    }
    @catch (NSException *exception) {
        //NSLog(exception.description);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Failed to add to cart."] message:@"" delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
        [alert show];
    }
    @finally {
        //[indicator stopAnimating];
        //loading = 0;
        
        //searchBarState = 0;
    }
    
}

-(IBAction)cart:(id)sender{
    if ((self.config.user_id != nil && ![self.config.user_id isEqualToString:@"0"] && self.config.user_id.length > 0 ) || self.config.guest_checkout){
        CartViewController *cc = [[CartViewController alloc] initWithNibName:@"CartViewController" bundle:nil];
        cc.config = self.config;
        cc.isFromMenu = 0;
        cc.parent = self;
        [self.navigationController pushViewController:cc animated:YES];
    } else {
        LoginViewController *lefty = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        lefty.config = self.config;
        [self presentViewController:lefty animated:YES completion:nil];
    }
}

-(IBAction)share:(id)sender{
    
    BOOL ok = [SocialShareModule check_share_available_with_sender:sender withConfig:self.config];
    
    
    if (!ok) return;
    
    NSString *message = [[self.config.sharingText objectForKey:@"product"] objectForKey:[SocialShareModule check_share_type:sender]];
    message = [message stringByReplacingOccurrencesOfString:@"{{product-name}}" withString:self.product.name];
    NSString *brand = self.product.brand;
    if (brand == nil || brand.length == 0) brand = self.config.app_name;
    message = [message stringByReplacingOccurrencesOfString:@"{{product-brand}}" withString:brand];
    if (message == nil || message.length == 0) message = [NSString stringWithFormat:@"%@ %@ %@",[self.config localisedString:@"Check out this from"],self.config.app_name, self.product.name];
    UIImage *shareImage = activeImg.image;
    
    NSString *aid = @"0";
    UIView *loadingView = nil;
    if (self.config.affiliate != nil && self.config.affiliate.hasAffiliate == 1) {
        aid = self.config.affiliate.aid;
        if (aid != nil && ![aid isEqualToString:@"0"]){
            loadingView = [AffiliateModule getLoadingScreen:CGRectMake(0, 0, self.config.screenWidth, self.config.screenHeight) withMessage:[self.config localisedString:@"Generating Your Affiliate Link."]];
        } else {
            loadingView = [AffiliateModule getLoadingScreen:CGRectMake(0, 0, self.config.screenWidth, self.config.screenHeight) withMessage:[self.config localisedString:@"Generating Sharing Link."]] ;
        }
    } else {
        loadingView = [AffiliateModule getLoadingScreen:CGRectMake(0, 0, self.config.screenWidth, self.config.screenHeight) withMessage:[self.config localisedString:@"Generating Sharing Link."]];
    }
    [self.navigationController.view addSubview:loadingView];
    
    
    
    
    [AffiliateModule getLink:self.config.APP_UUID affiliate:aid item:self.product.product_id itemType:@"product" filter:@"" completion:^(NSString *url, NSError *error) {
        
        [loadingView removeFromSuperview];
        
        [ss present_sharing_dialog_with_message:message image:shareImage imageurl:[activeImg.url absoluteString]  url:url action_sender:sender action_parent:self];
        
    }];
    
    
}

/*
 -(IBAction)share:(id)sender{
 
 NSString *message = self.product.name;
 UIImage *shareImage = activeImg.image;
 //NSURL *shareUrl = [NSURL URLWithString:[v.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
 
 
 
 NSString *aid = @"0";
 UIView *loadingView = nil;
 if (self.config.affiliate != nil) {
 aid = self.config.affiliate.aid;
 if (aid != nil && ![aid isEqualToString:@"0"]){
 loadingView = [AffiliateModule getLoadingScreen:CGRectMake(self.config.screenWidth/2-130, self.config.screenHeight/2-100, 260, 150) withMessage:@"Generating Your Affiliate Link."];
 } else {
 loadingView = [AffiliateModule getLoadingScreen:CGRectMake(self.config.screenWidth/2-130, self.config.screenHeight/2-100, 260, 150) withMessage:@"Generating Sharing Link."];
 }
 } else {
 loadingView = [AffiliateModule getLoadingScreen:CGRectMake(self.config.screenWidth/2-130, self.config.screenHeight/2-100, 260, 150) withMessage:@"Generating Sharing Link."];
 }
 [self.view addSubview:loadingView];
 
 [AffiliateModule getLink:self.config.APP_UUID affiliate:aid item:self.product.product_id itemType:@"product" completion:^(NSString *url, NSError *error) {
 
 NSString *str = [NSString stringWithFormat:@"%@ %@", self.product.name, url];
 UIImage *img = shareImage;
 
 NSArray *activityItems = [NSArray arrayWithObjects:str, img, nil];
 ;
 UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
 activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
 
 [loadingView removeFromSuperview];
 
 
 [activityViewController setCompletionHandler:^(NSString *activityType, BOOL completed){
 if (completed){
 // [NSThread detachNewThreadSelector:@selector(send_user_share) toTarget:self withObject:nil];
 }
 }];
 
 [self presentViewController:activityViewController animated:YES completion:nil];
 
 }];
 
 
 }*/

-(void)back{
    shoudLoadImg = NO;
    if (! self.viewPresented )[self.navigationController popViewControllerAnimated:YES];
    else [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)startAnimating{
    [indicator startAnimating];
}

@end

@implementation ButtonWithValues



@end

@implementation ProductDetailDesign



@end