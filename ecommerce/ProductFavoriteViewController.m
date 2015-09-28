//
//  ProductFavoriteViewController.m
//  Ecommerce
//
//  Created by Hanqing Hu on 5/24/15.
//  Copyright (c) 2015 Twixxies. All rights reserved.
//

#import "ProductFavoriteViewController.h"
#import "NSURLConnectionBlock.h"
#import "PKRevealController.h"
#import "ProductDetailViewController.h"
#import "CartViewController.h"
#import "LoginViewController.h"
#import "ProductFilterViewController.h"
#import "PromotionViewController.h"
#import "IonIcons.h"
#import "ionicons-codes.h"
#import "NSString+FontAwesome.h"
#import "Design.h"
#import "ViewWithData.h"
#import "SDImageCache.h"
#import "SDWebImageDownloader.h"

@interface ProductFavoriteViewController ()

@end

@implementation ProductFavoriteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        cachedContentOffset = 0;
        lastContentOffset = 0;
        reloading = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [Design navigationbar:self.navigationController.navigationBar config:self.config];
    // Do any additional setup after loading the view from its nib.
    //filterview = [[ProductFilterViewController alloc] init];
    
    /*titlelabel = [[UILabel alloc] initWithFrame:CGRectZero] ;
     titlelabel.textAlignment = NSTextAlignmentCenter;
     self.navigationItem.titleView = titlelabel;
     titlelabel.text = self.titleText;
     if (self.titleText == nil || self.titleText.length == 0){
     titlelabel.text = @"Products";
     }
     titlelabel.frame = CGRectMake(0, 0, 180, 44);*/
    
    
    UILabel *carttitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 44)];
    //carttitle.backgroundColor = [UIColor blackColor];
    [Design navigationbar_title:carttitle config:self.config];
    
    titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, carttitle.frame.size.width, 24)] ;
    
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:17.3];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = carttitle.textColor;
    titlelabel.text = [self.config localisedString:@"My Favorites"];
   
    [carttitle addSubview:titlelabel];
    
    cartCounter = [[UILabel alloc] initWithFrame:CGRectMake(0, 24, carttitle.frame.size.width, 20)] ;
    cartCounter.backgroundColor = [UIColor clearColor];
    cartCounter.font = [UIFont boldSystemFontOfSize:12.0];
    cartCounter.textAlignment = NSTextAlignmentCenter;
    cartCounter.textColor = carttitle.textColor;
    //cartCounter.text = NSLocalizedString(@"0 Item", @"");
    //[cartCounter sizeToFit];
    [carttitle addSubview:cartCounter];
    self.navigationItem.titleView = carttitle;
    
   
    
    [Design product_page:self config:self.config];
    
    
    NSDictionary *d = [[[self.config.design objectForKey:@"components"] objectForKey:@"product_page"] objectForKey:@"style"];
    design = [[ProductFavoriteViewDesign alloc] init];
    design.product_view = [[self.config.design objectForKey:@"design"] objectForKey:[d objectForKey:@"view"]];
    design.product_image = [[self.config.design objectForKey:@"design"] objectForKey:[d objectForKey:@"image"]];
    design.product_brand = [[self.config.design objectForKey:@"design"] objectForKey:[d objectForKey:@"brand"]];
    design.product_name = [[self.config.design objectForKey:@"design"] objectForKey:[d objectForKey:@"name"]];
    design.product_price = [[self.config.design objectForKey:@"design"] objectForKey:[d objectForKey:@"price"]];
    design.product_sale = [[self.config.design objectForKey:@"design"] objectForKey:[d objectForKey:@"sale"]];
    design.column = [[[[self.config.design objectForKey:@"components"] objectForKey:@"product_page"] objectForKey:@"column"] intValue];
    design.column_spacing =[[[self.config.design objectForKey:@"components"] objectForKey:@"product_page"] objectForKey:@"column_spacing"];
    if (design.column <= 0)design.column = 2;
    
    
    
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    screenWidth = screenSize.width;
    screenHeight = screenSize.height;
    
    
    //UIBarButtonItem *menuBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navMenu"] style:UIBarButtonItemStylePlain target:self action:@selector(menu:)];
    
    //[menuBtn setBackButtonTitlePositionAdjustment:UIOffsetMake(20, 0) forBarMetrics:UIBarMetricsDefault] ;
    
    // self.navigationItem.leftBarButtonItem = menuBtn;
    
    UIView *cartView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
    cartView.userInteractionEnabled = YES;
    
    cartbtn = [IonIcons labelWithIcon:icon_ios7_cart size:22 color:[UIColor blackColor]];
    //cartbtn.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    
    cartbtn.frame = CGRectMake(00, 0, 40, 44);
    cartbtn.textAlignment = NSTextAlignmentRight;
    // cartbtn.font = [UIFont fontWithName:kFontAwesomeFamilyName size:22.f];
    // cartbtn.text =[NSString fontAwesomeIconStringForIconIdentifier:@"fa-shopping-cart"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cart:)];
    [cartbtn addGestureRecognizer:tap];
    cartbtn.userInteractionEnabled = YES;
    [Design navigationbar_ion_icon:cartbtn config:self.config];
    [Design style:[[DOM alloc] initWithView:cartbtn parent:nil] design:[[self.config.design objectForKey:@"design"] objectForKey:@"right_navigation_ion_icon"] config:self.config];
    
    
    
    
    UIBarButtonItem *menuBtn2 = [[UIBarButtonItem alloc] initWithCustomView:cartView];
    
    
    self.navigationItem.rightBarButtonItem = menuBtn2;
    
    
    UILabel *menubtn = [IonIcons labelWithIcon:icon_ios7_arrow_back size:22 color:[UIColor blackColor]];;
    
    
    menubtn.frame = CGRectMake(0, 0, 60, 44);
    // menubtn.font = [UIFont fontWithName:kFontAwesomeFamilyName size:22.f];
    // menubtn.text =[NSString fontAwesomeIconStringForIconIdentifier:@"fa-bars"];
    
    UITapGestureRecognizer *menutap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    [menubtn addGestureRecognizer:menutap];
    menubtn.userInteractionEnabled = YES;
    [Design navigationbar_ion_icon:menubtn config:self.config];
    [Design style:[[DOM alloc] initWithView:menubtn parent:nil] design:[[self.config.design objectForKey:@"design"] objectForKey:@"left_navigation_ion_icon"] config:self.config];
    
    UIBarButtonItem *barbtn = [[UIBarButtonItem alloc] initWithCustomView:menubtn];
    
    
    self.navigationItem.leftBarButtonItem = barbtn;
    
    
    
    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.config.screenWidth, self.config.screenHeight-64)];
    scroll.delegate = self;
    [self.view addSubview:scroll];
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSString *style_id = [[[self.config.design objectForKey:@"components"] objectForKey:@"product_page"] objectForKey:@"style_id"];
    NSDictionary *parent_style = [[self.config.design objectForKey:@"design"] objectForKey:style_id];
    
    [Design style:[[DOM alloc] initWithView:scroll parent:nil] design:parent_style config:self.config];
    
   
    
    
    refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(pageRefresh:) forControlEvents:UIControlEventValueChanged];
    [scroll addSubview:refresh];
    
    
    
    receivedData = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < 5; i++){
        NSMutableData *rec = [[NSMutableData alloc] init];
        [receivedData addObject:rec];
    }
   
    
    loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, -55, self.config.screenWidth, 50)];
    loadingView.backgroundColor = [UIColor whiteColor];
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, loadingView.frame.size.height, loadingView.frame.size.width, 0.5);
    layer.backgroundColor = [[UIColor colorWithRed:196.0/255.0 green:196.0/255.0  blue:196.0/255.0  alpha:1] CGColor];
    [loadingView.layer addSublayer:layer];
    
    UILabel *loadinglabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, loadingView.frame.size.width, loadingView.frame.size.height)];
    loadinglabel.text = [self.config localisedString:@"Loading More..."];
    loadinglabel.textColor = [UIColor colorWithRed:41.0/255.0 green:39.0/255.0 blue:39.0/255.0 alpha:1];
    loadinglabel.textAlignment = NSTextAlignmentCenter;
    loadinglabel.font = [UIFont systemFontOfSize:13];
    [loadingView addSubview:loadinglabel];
    
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.hidesWhenStopped = YES;
    indicator.frame = CGRectMake(self.config.screenWidth/2+55, loadingView.frame.size.height/2-indicator.frame.size.height/2, indicator.frame.size.width, indicator.frame.size.height);
    [loadingView addSubview:indicator];
    [self.view addSubview:loadingView];
    
    
    
    [self load_product:0];
}
-(void)viewWillAppear:(BOOL)animated{
    [UIView setAnimationsEnabled:YES];
    [self.config add_badge:cartbtn withnumber:self.config.cartnum];
    [self.config check_cart_with_view:cartbtn];
    
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)menu:(id)sender
{
    if (self.navigationController.revealController.focusedController == self.navigationController.revealController.leftViewController)
    {
        [self.navigationController.revealController showViewController:self.navigationController.revealController.frontViewController];
    }
    else
    {
        [self.navigationController.revealController showViewController:self.navigationController.revealController.leftViewController];
    }
}
-(IBAction)pageRefresh:(id)sender{
    
    reloading = YES;
    
    [self load_product:0];
}
-(IBAction)cart:(id)sender{
    if (self.config.user_id != nil && ![self.config.user_id isEqualToString:@"0"] && self.config.user_id.length > 0){
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

-(IBAction)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)showLoadingView:(BOOL)show{
    if (show){
        [UIView animateWithDuration:0.5f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             CGRect frame = loadingView.frame;
                             frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
                             loadingView.frame = frame;
                         }
                         completion:^(BOOL finished){
                         }];
    } else {
        [UIView animateWithDuration:0.5f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             CGRect frame = loadingView.frame;
                             frame = CGRectMake(0, -55, frame.size.width, frame.size.height);
                             loadingView.frame = frame;
                         }
                         completion:^(BOOL finished){
                         }];
    }
    
}


-(void)load_product:(int)start{
    if (loading == 1) return;
    if (start == 0) {
        for (UIView *v in itemViews){
            [v removeFromSuperview];
        }
        
        [itemViews removeAllObjects];
        itemViews = nil;
        itemViews = [[NSMutableArray alloc] init];
        [items removeAllObjects];
        items = nil;
        items = [[NSMutableArray alloc] init];
        [scroll setContentOffset:CGPointMake(0, 0)];
        scrollDirection = 0;
        hasmore = 0;
        lastContentOffset = 0;
        
    }
    if (!reloading)
        [NSThread detachNewThreadSelector:@selector(threadStartAnimating) toTarget:self withObject:nil];
    loading = 1;
    [self showLoadingView:YES];
   
  
    
    NSString *myRequestString = [NSString stringWithFormat:@"app_uuid=%@&start=%d&user_id=%@&token=%@", self.config.APP_UUID, start, self.config.user_id, self.config.token];
    
    NSLog(@"%@", myRequestString);
    
    // Create Data from request
    NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", self.config.API_ROOT, self.config.API_GET_FAV]]];
    
    // set Request Type
    [request setHTTPMethod: @"POST"];
    // Set content-type
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    // Set Request Body
    [request setHTTPBody: myRequestData];
    
    
    
    NSURLConnectionBlock *connection = [[NSURLConnectionBlock alloc] initWithRequest:request];
    connection.completion = ^(id obj, NSError *err) {
        
        if (!err) {
            NSData *received = (NSData *)obj;
            
            NSString *myxml = [[NSString alloc] initWithData:received encoding:NSASCIIStringEncoding];
            NSLog(@"%@", myxml);
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:received options:0 error:nil];
            
            NSString *total_product = [dic objectForKey:@"total_product"];
            cartCounter.text = [NSString stringWithFormat:@"%@ %@", total_product, [self.config localisedString:@"Item(s)"]];
            
            NSArray *a = [dic objectForKey:@"products"];
            
            hasmore = [[dic objectForKey:@"hasmore"] intValue];
            
            for (NSDictionary *d in a){
                Product *e = [[Product alloc] init];
                [e product_from_dictionary:d];
                [items addObject:e];
                
            }
            
            if (items.count == 0){
                //[self show_search_bar:3 distance:0 isDragging:NO isOutsideContent:NO];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"No Product Found"] message:nil delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles:nil];
                [alert show];
            }
            [self display_product];
            //[indicator stopAnimating];
            [refresh endRefreshing];
            loading = 0;
            [self showLoadingView:NO];
            reloading=NO;
            
            
        } else {
            //There was an error
            NSLog(@"%@", err.description);
        }
       
    };
    [connection start];}

-(void)display_product{
    NSMutableArray *tempimg = [[NSMutableArray alloc] init];
    int count = 0;
    int line = 0;
    CGRect prev = [Design product_initial_frame:(int)itemViews.count config:self.config];
    CGRect last = CGRectMake(0, 0, 0, 0);
    for (int i = (int)itemViews.count ; i < items.count; i++){
        Product *temp = [items objectAtIndex:i];
        line = i/2;
        
        
        ViewWithData *pv = [[ViewWithData alloc] init];
        pv.tag = i;
        pv.itemID = temp.product_id;
        [pv.layer setMasksToBounds:YES];
        pv.layer.masksToBounds = NO;
        pv.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemsel:)];
        singleTap.numberOfTapsRequired = 1;
        pv.userInteractionEnabled = YES;
        [pv addGestureRecognizer:singleTap];
        
        
        CGRect frame = pv.frame;
        
        frame.origin.x = self.config.screenWidth/design.column * (i%design.column);
        frame.size.width = self.config.screenWidth/design.column;
        if (i/design.column > 0){
            UIView *prev = [itemViews objectAtIndex:i-design.column];
            frame.origin.y = prev.frame.origin.y+prev.frame.size.height;
        }
        //figure out column row and col spacing
        if (design.column_spacing != nil){
            float col_spacing = [[design.column_spacing objectAtIndex:0] floatValue];
            float row_spacing = [[design.column_spacing objectAtIndex:1] floatValue];
            float first_row = [[design.column_spacing objectAtIndex:2] floatValue];
            if (i/design.column > 0){
                frame.origin.y += row_spacing;
            } else {
                frame.origin.y += row_spacing;
            }
            if (design.column <= 1){
                frame.origin.x += col_spacing;
                frame.size.width -= col_spacing*2;
            } else {
                if (i%design.column == 0){
                    frame.origin.x += col_spacing;
                    frame.size.width -= col_spacing/2+col_spacing;
                }
                if (i%design.column == design.column - 1){
                    frame.origin.x += col_spacing/2;
                    frame.size.width -= col_spacing + col_spacing/2;
                }
                if (i%design.column != 0 && i%design.column != design.column - 1) {
                    frame.origin.x += col_spacing/2;
                    frame.size.width -= col_spacing/2 + col_spacing/2;
                }
            }
        }
        pv.frame = frame;
        
        [Design style:[[DOM alloc] initWithView:pv parent:scroll] design:design.product_view config:self.config];
        
        //  [vs setObject:image forKey:@"main"];
        
        [self build_productView:pv withProduct:temp imageQueue:tempimg];
        pv.load_status = 1;
        
        [scroll addSubview:pv];
        [itemViews addObject:pv];
        count++;
        if (i == items.count-1) last = pv.frame;
    }
    if (count > 0){
        //[scroll setContentSize:CGSizeMake(320, (120.0 * 1.255+20)*(line+1)+49)];
        if (last.origin.y+last.size.height <= screenHeight){
            [scroll setContentSize:CGSizeMake(screenWidth, screenHeight)];
        } else {
            [scroll setContentSize:CGSizeMake(screenWidth, last.origin.y+last.size.height)];
        }
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        [self load_image:scroll.contentOffset inArray:tempimg];
    });
}

-(void)build_productView:(ViewWithData *)pv withProduct:(Product *)temp imageQueue:(NSMutableArray *)tempimg{
    
    
    ImageWithData *but = [[ImageWithData alloc] init];
    [but setUserInteractionEnabled:YES];
    but.contentMode = UIViewContentModeScaleAspectFit;
    [Design style:[[DOM alloc] initWithView:but parent:pv] design:design.product_image config:self.config];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.hidesWhenStopped = YES;
    spinner.frame = CGRectMake(but.frame.origin.x+but.frame.size.width/2-spinner.frame.size.width/2, but.frame.origin.y+but.frame.size.height/2-spinner.frame.size.height/2, spinner.frame.size.width, spinner.frame.size.height);
    [pv addSubview:spinner];
    [spinner startAnimating];
    but.indicator = spinner;
    [pv addSubview:but];
    
    // [vs setObject:but forKey:@"image"];
    
    NSString *url = [temp.imageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    but.url = [NSURL URLWithString:url];
    
    [tempimg addObject:but];
    //[Config loadImageURL:url toImageView:but withCacheKey:key trim:YES];
    
    
    if (temp.total_stock <= 0){
        
        UILabel *l = [[UILabel alloc] init];
        l.textAlignment = NSTextAlignmentCenter;
        l.text = [self.config localisedString:@"Sold Out"];
        [Design style:[[DOM alloc] initWithView:l parent:pv] design:design.product_soldout config:self.config];
        [pv addSubview:l];
        // [vs setObject:l forKey:@"sold_out"];
        
    }
    
    double price = -1;
    double sale_price = 0;
    BOOL hassale = false;
    for (ProductVar *pv in temp.variations){
        if (price < 0) {
            price = pv.price;
            if (pv.sale_price > 0 && pv.sale_price < price) {
                hassale = YES;
                sale_price=pv.sale_price;
            }
        }
        if (pv.price < price) {
            price = pv.price;
            if (pv.sale_price > 0 && pv.sale_price < price) {
                hassale = YES;
                sale_price=pv.sale_price;
            }
        }
        
        
    }
    
    
    UILabel *brand = [[UILabel alloc] init];
    brand.text = temp.brand;
    [Design style:[[DOM alloc] initWithView:brand parent:pv] design:design.product_brand config:self.config];
    [pv addSubview:brand];
    // [vs setObject:brand forKey:@"brand"];
    
    UITextView *name = [[UITextView alloc] init];
    name.text = temp.name;
    [Design style:[[DOM alloc] initWithView:name parent:pv] design:design.product_name config:self.config];
    name.text = temp.name;
    name.editable = NO;
    name.userInteractionEnabled = NO;
    [pv addSubview:name];
    
    //NSLog(@"%f", name.frame.size.width);
    // [vs setObject:exname forKey:@"name"];
    
    
    
    //frame = CGRectMake(5, image.frame.size.width*1.533+45, image.frame.size.width-10, 10);
    UILabel *exprice = [[UILabel alloc] init];
    exprice.textAlignment=NSTextAlignmentCenter;
    exprice.text = [NSString stringWithFormat:@"%@%0.2f",[self.config getCurrencySymbol],price];
    exprice.frame = CGRectMake(name.frame.origin.x+4, name.frame.origin.y+name.frame.size.height+5, exprice.frame.size.width, exprice.frame.size.height);
    [Design style:[[DOM alloc] initWithView:exprice parent:pv] design:design.product_price config:self.config];
    [pv addSubview:exprice];
    
    if (hassale){
        //frame = CGRectMake(0, image.frame.size.width*1.533+45, image.frame.size.width/2, 10);
        //exprice.frame = frame;
        exprice.adjustsFontSizeToFitWidth = YES;
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%0.2f  %@%0.2f",[self.config getCurrencySymbol], price, [self.config getCurrencySymbol], sale_price]];
        [attributeString addAttribute:NSFontAttributeName value:exprice.font range:(NSRange){0,[attributeString length]}];
        
        NSString *p = [NSString stringWithFormat:@"%@%0.2f", [self.config getCurrencySymbol],price];
        //NSString *s = [NSString stringWithFormat:@"$%0.2f", sale_price];
        [attributeString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:1] range:(NSRange){0,[p length]}];
        
        UIColor *priceColor = [UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:1];
        if ([design.product_price objectForKey:@"color"]!= nil){
            NSArray *array = [design.product_price objectForKey:@"color"];
            priceColor = [UIColor colorWithRed:[[array objectAtIndex:0] floatValue]/255.0 green:[[array objectAtIndex:1] floatValue]/255.0 blue:[[array objectAtIndex:2] floatValue]/255.0 alpha:[[array objectAtIndex:3] floatValue]];
        }
        UIColor *saleColor = [UIColor colorWithRed:204/255.0 green:76/255.0 blue:70/255.0 alpha:1];
        if ([design.product_sale objectForKey:@"color"]!= nil){
            NSArray *array = [design.product_sale objectForKey:@"color"];
            saleColor = [UIColor colorWithRed:[[array objectAtIndex:0] floatValue]/255.0 green:[[array objectAtIndex:1] floatValue]/255.0 blue:[[array objectAtIndex:2] floatValue]/255.0 alpha:[[array objectAtIndex:3] floatValue]];
        }
        
        [attributeString addAttribute:NSForegroundColorAttributeName value:(id)priceColor range:NSMakeRange(0, [p length])];
        [attributeString addAttribute:NSFontAttributeName value:(id)[UIFont systemFontOfSize:13] range:NSMakeRange(0, [p length])];
        [attributeString addAttribute:NSForegroundColorAttributeName value:(id)saleColor range:NSMakeRange([p length], [attributeString length]-[p length])];
        [attributeString addAttribute:NSFontAttributeName value:(id)[UIFont boldSystemFontOfSize:13] range:NSMakeRange([p length], [attributeString length]-[p length])];
        
        exprice.text = @"";
        exprice.attributedText = attributeString;
        
        
        //[vs setObject:@"1" forKey:@"sale"];
        
    }
    
    ButtonWithData *favbtn = [[ButtonWithData alloc] initWithFrame:CGRectMake(pv.frame.size.width-44, 0, 44, 44)];
    favbtn.tag = 2;
    favbtn.item_id = temp.fav_id;
    favbtn.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:28];
    [favbtn setTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"fa-heart"] forState:UIControlStateNormal];
    [favbtn setTitleColor:[UIColor colorWithRed:229/255.0 green:29/255.0 blue:64/255.0 alpha:1] forState:UIControlStateNormal];
    [favbtn addTarget:self action:@selector(add_edit_fav:) forControlEvents:UIControlEventTouchUpInside];
    [pv addSubview:favbtn];
    
    //[vs setObject:exprice forKey:@"price"];
}

-(void)load_image:(CGPoint)contentOffset inArray:(NSMutableArray *)array;{
    for (ImageWithData *v in array){
        if (v == nil) continue;
        //if (v.frame.origin.y <= contentOffset.y+self.config.screenHeight){
        if (!v.loaded){
            [Config syncLoadImageURL:[v.url absoluteString] toImageView:v withCacheKey:[v.url absoluteString] trim:YES sizeMultiplyer:1 completion:^{
                [v.indicator stopAnimating];
            }];
            //[Config loadImageURL:[v.url absoluteString] toImageView:v withCacheKey:[v.url absoluteString] trim:YES];
            v.loaded = true;
        }
        //}
    }
    
    [array removeAllObjects];
}

-(IBAction)add_edit_fav:(id)sender{
    ButtonWithData *btn = (ButtonWithData *)sender;
    int isdelete = 1;
    if (btn.tag == -2) {
        btn.tag = 2;
      isdelete = 0;
        [btn setTitleColor:[UIColor colorWithRed:229/255.0 green:29/255.0 blue:64/255.0 alpha:1] forState:UIControlStateNormal];
        [btn setTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"fa-heart"]  forState:UIControlStateNormal];
    } else {
        btn.tag = -2;
        isdelete = 1;
        [btn setTitleColor:[UIColor colorWithRed:55.0/255.0 green:55.0/255.0 blue:55.0/255.0 alpha:1] forState:UIControlStateNormal];
        [btn setTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"fa-heart-o"]  forState:UIControlStateNormal];
    }
    
    if (isdelete == 0){
        CABasicAnimation *rotate =
        [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        rotate.byValue = @(M_PI*2); // Change to - angle for counter clockwise rotation
        rotate.duration = 0.5;
        
        [btn.layer addAnimation:rotate
                         forKey:@"myRotationAnimation"];
    }
    
    Product *temp = nil;
    for (Product *p in items){
        if ([p.fav_id isEqualToString:btn.item_id]){
            temp = p;
        }
    }
    
    NSString *myRequestString = [NSString stringWithFormat:@"app_uuid=%@&product_name=%@&user_id=%@&token=%@&fav_id=%@&is_delete=%d", self.config.APP_UUID, temp.name, self.config.user_id, self.config.token, btn.item_id, isdelete];
    
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
                
            }
            
            
        } else {
            //There was an error
            NSLog(@"%@", err.description);
        }
        
    };
    [connection start];
}

-(void)itemsel:(UITapGestureRecognizer *)ges{
    ViewWithData *sel = (ViewWithData *)ges.view;
    
    for (Product *p in items){
        if ([p.product_id isEqualToString:sel.itemID]){
            ProductDetailViewController *pd = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:nil];
            pd.config =self.config;
            pd.product = p;
            [self.navigationController pushViewController:pd animated:YES];
            return;
        }
    }
    
}





-(void)scrollViewDidScroll:(UIScrollView *)sender{
    
    /* if (lastContentOffset > scroll.contentOffset.y && scrollDirection != -1 &&  lastContentOffset+scroll.frame.size.height < scroll.contentSize.height && scroll.frame.origin.y == searchbar.frame.origin.y) {
     scrollDirection = -1;
     [self toggle_searchbar:YES];
     }
     
     else if (lastContentOffset < scroll.contentOffset.y && scrollDirection != 1 && lastContentOffset>0 && scroll.frame.origin.y != searchbar.frame.origin.y) {
     scrollDirection = 1;
     [self toggle_searchbar:NO];
     }
     lastContentOffset = scroll.contentOffset.y;*/
    
    //[self load_image:scroll.contentOffset];
    
    if (sender.contentOffset.y - cachedContentOffset > 10*self.config.screenHeight || cachedContentOffset - sender.contentOffset.y > 10*self.config.screenHeight){
        cachedContentOffset = sender.contentOffset.y;
        [self recaching_views:sender.contentOffset.y];
    }
    
    
    
    if (scroll.contentOffset.y+scroll.frame.size.height+1500 > scroll.contentSize.height && hasmore == 1){
        //CGRect frame = CGRectMake(0, sender.contentSize.height-49, 320, 44);
        //loadmoreView.frame = frame;
        //[scroll addSubview:loadmoreView];
        if (loading == 1) return;
        [self load_product:(int)itemViews.count];
        
        
    }
    
}
-(void)recaching_views:(CGFloat)offset{
    NSMutableArray *tempimg = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < itemViews.count; i++){
        ViewWithData *v = (ViewWithData *)[itemViews objectAtIndex:i];
        if (v.frame.origin.y+v.frame.size.height < offset - 10 * self.config.screenHeight){
            NSArray *sub = [v subviews];
            for (int i = 0 ; i < sub.count; i++){
                UIView *vi = [sub objectAtIndex:i];
                [vi removeFromSuperview];
                vi = nil;
            }
            v.load_status = 0;
        } else if (v.frame.origin.y > offset + 10*self.config.screenHeight){
            NSArray *sub = [v subviews];
            for (int i = 0 ; i < sub.count; i++){
                UIView *vi = [sub objectAtIndex:i];
                [vi removeFromSuperview];
                vi = nil;
            }
            v.load_status = 0;
        } else if (v.load_status == 0){
            for (Product *p in items){
                if ([p.product_id isEqualToString:v.itemID]){
                    [self build_productView:v withProduct:p imageQueue:tempimg];
                    v.load_status = 1;
                }
            }
            
        }
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        [self load_image:scroll.contentOffset inArray:tempimg];
    });
    
}






-(void)threadStartAnimating{
    [indicator startAnimating];
}

-(void)back{
    scroll = nil;
    [itemViews removeAllObjects];
    itemViews = nil;
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end




@implementation ProductFavoriteViewDesign


@end