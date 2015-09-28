//
//  ProductViewController.m
//  Ecommerce
//
//  Created by Hanqing Hu on 5/25/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import "ProductViewController.h"
#import "NSURLConnectionWithTag.h"
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
const int PRODUCT = 1;
const int FILTER = 2;
@interface ProductViewController ()

@end

@implementation ProductViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.rank = @"featured";
        self.category = [[NSMutableArray alloc] init];
        self.attribute = [[NSMutableArray alloc] init];
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
    titlelabel.text = self.titleText;
    if (self.titleText == nil || self.titleText.length == 0){
        titlelabel.text = [self.config localisedString:@"Products"];
    }
    //[label sizeToFit];
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
    
    [searchCancelBtn setTitle:[self.config localisedString:@"Cancel"] forState:UIControlStateNormal];
    
    [Design product_page:self config:self.config];
    
    
    NSDictionary *d = [[[self.config.design objectForKey:@"components"] objectForKey:@"product_page"] objectForKey:@"style"];
    design = [[ProductViewDesign alloc] init];
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
    
    UIView *cartView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    cartView.userInteractionEnabled = YES;
    
    cartbtn = [IonIcons labelWithIcon:icon_ios7_cart size:22 color:[UIColor blackColor]];
    //cartbtn.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    
    cartbtn.frame = CGRectMake(40, 0, 40, 44);
    cartbtn.textAlignment = NSTextAlignmentRight;
    // cartbtn.font = [UIFont fontWithName:kFontAwesomeFamilyName size:22.f];
    // cartbtn.text =[NSString fontAwesomeIconStringForIconIdentifier:@"fa-shopping-cart"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cart:)];
    [cartbtn addGestureRecognizer:tap];
    cartbtn.userInteractionEnabled = YES;
    [Design navigationbar_ion_icon:cartbtn config:self.config];
    [Design style:[[DOM alloc] initWithView:cartbtn parent:nil] design:[[self.config.design objectForKey:@"design"] objectForKey:@"right_navigation_ion_icon"] config:self.config];
    
    
    UILabel* filtbtn = [[UILabel alloc] init];
    filtbtn.frame = CGRectMake(0, 0, 40, 44);
    filtbtn.font = [UIFont fontWithName:kFontAwesomeFamilyName size:19];
    filtbtn.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-filter"];
    filtbtn.textAlignment = NSTextAlignmentRight;
    //[filtbtn setImage:[UIImage imageNamed:@"navFilter"] forState:UIControlStateNormal];
    //[filtbtn addTarget:self action:@selector(filter:) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *ftap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(filter:)];
    [filtbtn addGestureRecognizer:ftap];
    filtbtn.userInteractionEnabled = YES;
    [Design navigationbar_fa_icon:filtbtn config:self.config];
    [Design style:[[DOM alloc] initWithView:filtbtn parent:nil] design:[[self.config.design objectForKey:@"design"] objectForKey:@"right_navigation_fa_icon"] config:self.config];
    [cartView addSubview:cartbtn];
    [cartView addSubview:filtbtn];
    
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
    
    
    
    [Design product_search_bar:searchbar config:self.config];
    
    CGRect frame = CGRectMake(0, searchbar.frame.origin.y+searchbar.frame.size.height, screenWidth, screenHeight-searchbar.frame.origin.y-searchbar.frame.size.height+200);
    search_display = [[UITableView alloc] initWithFrame:frame];
    search_display.separatorColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1];
    search_display.dataSource = self;
    search_display.delegate = self;
    search_display.hidden = YES;
    [scroll addSubview:search_display];
    
    
    frame = CGRectMake(0, -0.5, self.config.screenWidth, 44);
    searchbar.placeholder = [self.config localisedString:@"Search Product"];
    searchbar.frame = frame;
    searchbar.barTintColor = [UIColor whiteColor];
    searchbar.searchBarStyle = UISearchBarStyleMinimal;
    searchbar.tintColor = [UIColor lightGrayColor];
    searchbar.layer.borderColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
    searchbar.layer.borderWidth = 0.5;
    
    [self.view addSubview:searchbar];
    
    
    refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(pageRefresh:) forControlEvents:UIControlEventValueChanged];
    [scroll addSubview:refresh];
    
    
    //[scroll addSubview:searchbar];
    
    receivedData = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < 5; i++){
        NSMutableData *rec = [[NSMutableData alloc] init];
        [receivedData addObject:rec];
    }
    filters = [[NSMutableDictionary alloc] init];
    
    /*loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, -55, self.config.screenWidth, 50)];
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
     [loadingView addSubview:loadinglabel];*/
    
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.hidesWhenStopped = YES;
    indicator.frame = CGRectMake(self.config.screenWidth/2-indicator.frame.size.width/2, (self.config.screenHeight-64)/2-indicator.frame.size.height/2, indicator.frame.size.width, indicator.frame.size.height);
    //[loadingView addSubview:indicator];
    [scroll addSubview:indicator];
    
    
    lastScrollOffset = scroll.contentOffset.y;
    search_is_toggling = 0;
    
    [self load_filter];
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
    filters = [[NSMutableDictionary alloc] init];
    reloading = YES;
    [self load_filter];
    [self load_product:0];
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
-(IBAction)filter:(id)sender{
    ProductFilterViewController *filterview = [[ProductFilterViewController alloc] initWithNibName:@"ProductFilterViewController" bundle:nil];
    filterview.parent = self;
    filterview.filters = filters;
    filterview.config = self.config;
    [filterview.table reloadData];
    [self presentViewController:filterview animated:YES completion:nil];
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

-(void)load_filter{
    NSString *f = self.filter;
    if (self.filter == nil) f = @"";
    NSString *st = self.searchTerm;
    if (self.searchTerm == nil) st = @"";
    NSString *myRequestString = [NSString stringWithFormat:@"app_uuid=%@&filter=%@&search_terms=%@&department_id=%@", self.config.APP_UUID, f, st, self.departmentid];
    
    NSLog(@"%@", myRequestString);
    
    // Create Data from request
    NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", self.config.API_ROOT, self.config.API_LOAD_FILTER]]];
    
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
    NSMutableData *received = [receivedData objectAtIndex:FILTER];
    [received setLength:0];
    NSURLConnectionWithTag *urlConnection = [[NSURLConnectionWithTag alloc] initWithRequest:request delegate:self tag:FILTER];
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
        loading = 1;
    //[self showLoadingView:YES];
    NSString *f = self.filter;
    if (self.filter == nil) f = @"";
    NSString *st = nil;
    if (self.searchTerm == nil) st = @"";
    else st = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                    NULL,
                                                                                    (__bridge CFStringRef) self.searchTerm,
                                                                                    NULL,
                                                                                    CFSTR("!*'();:@&=+$,/?%#[]\" "),
                                                                                    kCFStringEncodingUTF8));
    //construct category json
    
    NSMutableArray *cat = [[NSMutableArray alloc] init];
    for (NSString *s in self.category){
        
        [cat addObject:(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                             NULL,
                                                                                             (__bridge CFStringRef) s,
                                                                                             NULL,
                                                                                             CFSTR("!*'();:@&=+$,/?%#[]\" "),
                                                                                             kCFStringEncodingUTF8))];
    }
    
    NSMutableDictionary *catjsondic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:cat,@"categories", nil];
    NSData *catjsonData = [NSJSONSerialization dataWithJSONObject:catjsondic options:0 error:nil];
    NSString *catjson = [[NSString alloc] initWithData:catjsonData encoding:NSUTF8StringEncoding];
    /*NSMutableString *catjson = [[NSMutableString alloc] initWithFormat:@"{\"categories\":["];
     for (int i = 0 ; i < self.category.count;i++){
     if (i > 0) [catjson appendString:@","];
     [catjson appendFormat:@"\"%@\"",[self.category objectAtIndex:i]];
     
     }
     [catjson appendString:@"]}"];*/
    
    //construct attribute string
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating) toTarget:self withObject:nil];
    
    NSMutableArray *attr = [[NSMutableArray alloc] init];
    for (NSDictionary *d in self.attribute){
        NSString *name = [d objectForKey:@"name"];
        NSString *value = [d objectForKey:@"value"];
        NSString *cat = [d objectForKey:@"category"];
        if (name != nil) name = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                      NULL,
                                                                                                      (__bridge CFStringRef) name,
                                                                                                      NULL,
                                                                                                      CFSTR("!*'();:@&=+$,/?%#[]\" "),
                                                                                                      kCFStringEncodingUTF8));;
        if (value != nil) value = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                        NULL,
                                                                                                        (__bridge CFStringRef) value,
                                                                                                        NULL,
                                                                                                        CFSTR("!*'();:@&=+$,/?%#[]\" "),
                                                                                                        kCFStringEncodingUTF8));;
        if (cat != nil) cat = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                    NULL,
                                                                                                    (__bridge CFStringRef) cat,
                                                                                                    NULL,
                                                                                                    CFSTR("!*'();:@&=+$,/?%#[]\" "),
                                                                                                    kCFStringEncodingUTF8));;
        NSMutableDictionary *urld = [[NSMutableDictionary alloc] initWithObjectsAndKeys:name, @"name", value,@"value", cat,@"category", nil];
        [attr addObject:urld];
    }
    
    NSMutableDictionary *attrjsondic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:attr,@"attributes", nil];
    NSData *attrjsonData = [NSJSONSerialization dataWithJSONObject:attrjsondic options:0 error:nil];
    NSString *attrjson = [[NSString alloc] initWithData:attrjsonData encoding:NSUTF8StringEncoding];
    /*NSMutableString *attrjson = [[NSMutableString alloc] initWithFormat:@"{\"attributes\":["];
     for (int i = 0 ; i < self.attribute.count; i++){
     NSDictionary *d = [self.attribute objectAtIndex:i];
     NSString *name = [d objectForKey:@"name"];
     NSString *value = [d objectForKey:@"value"];
     NSString *cat = [d objectForKey:@"category"];
     if (i > 0) [attrjson appendString:@","];
     [attrjson appendFormat:@"{\"name\":\"%@\",\"value\":\"%@\",\"category\":\"%@\"}",name, value, cat];
     }
     [attrjson appendString:@"]}"];*/
    NSString *wid = self.config.wholesale.wholesale_user_id;
    if (wid == nil) wid = @"";
    
    NSString *myRequestString = [NSString stringWithFormat:@"app_uuid=%@&start=%d&filter=%@&search_terms=%@&rank=%@&category=%@&attributes=%@&department_id=%@&wholesale_user_id=%@&location=%@&currency=%@", self.config.APP_UUID, start, f, st, self.rank, catjson, attrjson, self.departmentid, wid,self.config.location, self.config.currency];
    
    NSLog(@"%@", myRequestString);
    
    // Create Data from request
    NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", self.config.API_ROOT, self.config.API_PRODUCT]]];
    
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
    NSMutableData *received = [receivedData objectAtIndex:PRODUCT];
    [received setLength:0];
    //NSURLConnectionWithTag *urlConnection = [[NSURLConnectionWithTag alloc] initWithRequest:request delegate:self tag:PRODUCT];
    
    NSURLConnectionWithTag *urlConnection = [[NSURLConnectionWithTag alloc] initWithRequest:request
                                                                                   delegate:self startImmediately:NO];
    urlConnection.tag = PRODUCT;
    
    [urlConnection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    [urlConnection start];
    
    
    if (start == 0){
        [self load_product_count:myRequestString];
    }
}

-(void)load_product_count:(NSString *)reqStr{
    NSData *myRequestData2 = [NSData dataWithBytes: [reqStr UTF8String] length: [reqStr length]];
    NSMutableURLRequest *request2 = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@",self.config.API_ROOT, self.config.API_PRODUCT_COUNT]]];
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
            
            NSString *count = [dic objectForKey:@"count"];
            
            cartCounter.text = [NSString stringWithFormat:@"%@ %@", count, [self.config localisedString:@"Item(s)"]];
            
            
        } else {
            //There was an error
            //completion(nil, nil);
            
        }
        
    };
    [connection start];
}

-(void)display_product{
    //[refresh endRefreshing];
    [self showLoadingView:NO];
    
    NSMutableArray *tempimg = [[NSMutableArray alloc] init];
    int count = 0;
    int line = 0;
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
                frame.origin.y += first_row;
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
        
        NSLog(@"%f", pv.frame.origin.y);
        
        //  [vs setObject:image forKey:@"main"];
        
        [self build_productView:pv withProduct:temp imageQueue:tempimg];
        pv.load_status = 1;
        
        [scroll insertSubview:pv belowSubview:search_display];
        [itemViews addObject:pv];
        count++;
        if (i == items.count-1) last = pv.frame;
    }
    if (count > 0){
        //[scroll setContentSize:CGSizeMake(320, (120.0 * 1.255+20)*(line+1)+49)];
        if (last.origin.y+last.size.height <= screenHeight){
            indicator.frame = CGRectMake(self.config.screenWidth/2-indicator.frame.size.width/2, last.origin.y+last.size.height+15, indicator.frame.size.width, indicator.frame.size.height);
            [scroll setContentSize:CGSizeMake(screenWidth, screenHeight)];
        } else {
            indicator.frame = CGRectMake(self.config.screenWidth/2-indicator.frame.size.width/2, last.origin.y+last.size.height+15, indicator.frame.size.width, indicator.frame.size.height);
            
            [scroll setContentSize:CGSizeMake(screenWidth, last.origin.y+last.size.height+30)];
        }
    }
    // dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    //dispatch_async(queue, ^{
    [self load_image:scroll.contentOffset inArray:tempimg];
    //});
    
    
}

-(void)build_productView:(ViewWithData *)pv withProduct:(Product *)temp imageQueue:(NSMutableArray *)tempimg{
    
    
    ImageWithData *but = [[ImageWithData alloc] init];
    but.tag = 99;
    [but setUserInteractionEnabled:YES];
    but.contentMode = UIViewContentModeScaleAspectFit;
    [Design style:[[DOM alloc] initWithView:but parent:pv] design:design.product_image config:self.config];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.tag = 98;
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
    
    //[vs setObject:exprice forKey:@"price"];
}

-(void)load_image:(CGPoint)contentOffset inArray:(NSMutableArray *)array{
    NSMutableArray *uncached = [[NSMutableArray alloc] init];
    __block int count = 0;
    for (ImageWithData *v in array){
        if (v == nil) continue;
        //if (v.frame.origin.y <= contentOffset.y+self.config.screenHeight){
        if (!v.loaded){
            /*[Config syncLoadImageURL:[v.url absoluteString] toImageView:v withCacheKey:[v.url absoluteString] trim:YES sizeMultiplyer:1 completion:^{
             [v.indicator stopAnimating];
             }];*/
            /*[Config loadImageURL:[v.url absoluteString] toImageView:v withCacheKey:[v.url absoluteString] trim:NO sizeMultiplyer:1 completion:^{
             [v.indicator stopAnimating];
             }];*/
            
            [Config getCachedImage:[v.url absoluteString] toImageView:v trim:YES sizeMultiplyer:1 completion:^(UIImage *image) {
                if (image == nil) [uncached addObject:v];
                else {
                    [v.indicator stopAnimating];
                }
                count++;
                if (count == array.count){
                    
                    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                    dispatch_async(queue, ^{
                        [self download_image:uncached];
                    });
                    
                }
                
            }];
            
            
            
            v.loaded = true;
        }
        //}
    }
    
    //[array removeAllObjects];
}

-(void)download_image:(NSMutableArray *)images{
    for (ImageWithData *v in images){
        [Config syncLoadImageURL:[v.url absoluteString] toImageView:v withCacheKey:[v.url absoluteString] trim:YES sizeMultiplyer:1 completion:^{
            [v.indicator stopAnimating];
            v.loaded = true;
        }];
    }
    
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



- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    @try {
        NSURLConnectionWithTag *conn = (NSURLConnectionWithTag *)connection;
        NSMutableData *received = [receivedData objectAtIndex:conn.tag];
        [received appendData:data];
        
    }
    @catch (NSException *exception) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Something went wrong..."] message:@"" delegate:self cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles:nil];
        
        [alert show];
        
        [indicator stopAnimating];
        loading = 0;
        [self showLoadingView:NO];
        reloading=NO;
        
    }
    
    
    
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [indicator stopAnimating];
    loading = 0;
    [self showLoadingView:NO];
    reloading=NO;
    
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSURLConnectionWithTag *conn = (NSURLConnectionWithTag *)connection;
    NSMutableData *received = [receivedData objectAtIndex:conn.tag];
    
    // @try {
    if (conn.tag == PRODUCT ){
        NSString *myxml = [[NSString alloc] initWithData:received encoding:NSASCIIStringEncoding];
        NSLog(@"%@", myxml);
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:received options:0 error:nil];
        
        NSString *total_product = [dic objectForKey:@"total_product"];
        
        
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
        
        if (itemViews.count == 0) [self display_product];
        else {
            NSTimer *elapsedTimeTimer = [NSTimer scheduledTimerWithTimeInterval:0.00005
                                                                         target:self
                                                                       selector:@selector(display_product2)
                                                                       userInfo:nil
                                                                        repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:elapsedTimeTimer
                                         forMode:NSRunLoopCommonModes];
        }
        
        
        if (refresh.isRefreshing){
            [refresh endRefreshing];
        }
        
        [indicator stopAnimating];
        
        /*NSTimer *elapsedTimeTimer = [NSTimer scheduledTimerWithTimeInterval:0.0001
         target:self
         selector:@selector(display_product)
         userInfo:nil
         repeats:NO];
         [[NSRunLoop currentRunLoop] addTimer:elapsedTimeTimer
         forMode:NSRunLoopCommonModes];*/
        
        
        loading = 0;
        
        reloading=NO;
    }
    if (conn.tag == FILTER){
        [filters removeAllObjects];
        NSString *myxml = [[NSString alloc] initWithData:received encoding:NSASCIIStringEncoding];
        NSLog(@"%@", myxml);
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:received options:0 error:nil];
        searchWords = [dic objectForKey:@"search_words"];
        NSArray *a = [dic objectForKey:@"categories"];
        NSArray *sorteda = [a sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        NSMutableDictionary *catd = [[NSMutableDictionary alloc] init];
        [catd setObject:sorteda forKey:self.config.APP_UUID]; //special treatment because on server query side category and attribute are separate
        [filters setObject:catd forKey:@"Categories"];
        NSArray *attr = [dic objectForKey:@"attributes"];
        for (NSDictionary *d in attr){
            NSString *name = [d objectForKey:@"attrname"];
            NSArray *arr = [d objectForKey:@"attrvalue"];
            if (arr.count > 0){
                NSMutableDictionary *attrd = [[NSMutableDictionary alloc] init];
                [attrd setObject:arr forKey:name];
                [filters setObject:attrd forKey:name];
            }
        }
        /* NSDictionary *sd = [dic objectForKey:@"size_with_category"];
         NSMutableDictionary *size = [[NSMutableDictionary alloc] init];
         for (NSString *key in [sd allKeys]){
         NSArray *temp = [sd objectForKey:key];
         NSArray *sortedtemp = [temp sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
         if (temp.count > 0)[size setObject:sortedtemp forKey:key];
         }
         NSArray *snocat = [dic objectForKey:@"size_wo_category"];
         NSArray *sortedsnocat = [snocat sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
         if (snocat.count > 0)[size setObject:sortedsnocat forKey:@""];
         if ([[size allKeys] count] > 0)[filters setObject:size forKey:@"Size"];*/
        
    }
    
    
    //  }
    //  @catch (NSException *exception) {
    //      NSLog(exception.description);
    //      [indicator stopAnimating];
    //   }
    //  @finally {
    
    //      loading = 0;
    
    //searchBarState = 0;
    //   }
    
}


-(void)toggle_search_bar:(BOOL)show{
    search_is_toggling = 1;
    if (show){
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             searchbar.frame = CGRectMake(0, -0.5, searchbar.frame.size.width, searchbar.frame.size.height);
                             scroll.frame = CGRectMake(0, searchbar.frame.size.height, self.config.screenWidth, self.config.screenHeight-64-searchbar.frame.size.height);
                         }
                         completion:^(BOOL finished){
                             search_is_toggling = 0;
                         }];
    } else {
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             searchbar.frame = CGRectMake(0, -0.5-searchbar.frame.size.height, searchbar.frame.size.width, searchbar.frame.size.height);
                             scroll.frame = CGRectMake(0, 0, self.config.screenWidth, self.config.screenHeight-64);
                         }
                         completion:^(BOOL finished){
                             search_is_toggling = 0;
                         }];
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
    if (search_is_toggling == 0){
        if (lastContentOffset > scroll.contentOffset.y && scroll.contentOffset.y > 0 && scroll.contentOffset.y + scroll.frame.size.height < scroll.contentSize.height-100)
            [self toggle_search_bar:YES];
        else if (lastContentOffset < scroll.contentOffset.y && scroll.contentOffset.y > 0 && scroll.contentOffset.y + scroll.frame.size.height< scroll.contentSize.height-100) {
            [self toggle_search_bar:NO];
        }
    }
    
    
    lastContentOffset = scroll.contentOffset.y;
    
    
    
    if (sender.contentOffset.y - cachedContentOffset > self.config.screenHeight || cachedContentOffset - sender.contentOffset.y > self.config.screenHeight){
        cachedContentOffset = sender.contentOffset.y;
        
        NSDecimalNumber *dec = [NSDecimalNumber numberWithDouble:cachedContentOffset];
        //[self recaching_views:sender.contentOffset.y];
        
        NSTimer *elapsedTimeTimer = [NSTimer scheduledTimerWithTimeInterval:0.00005
                                                                     target:self
                                                                   selector:@selector(recaching_views:)
                                                                   userInfo:@{@"position" : dec}
                                                                    repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:elapsedTimeTimer
                                     forMode:NSRunLoopCommonModes];
    }
    
    if (itemViews.count > 0 && itemViews.count != items.count && loading == 0) {
        UIView *example = [itemViews objectAtIndex:0];
        if (scroll.contentOffset.y+scroll.frame.size.height+example.frame.size.height > scroll.contentSize.height) {
            loading = 1;
            NSLog(@"%f",scroll.contentSize.height);
            NSTimer *elapsedTimeTimer = [NSTimer scheduledTimerWithTimeInterval:0.00005
                                                                         target:self
                                                                       selector:@selector(display_product2)
                                                                       userInfo:nil
                                                                        repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:elapsedTimeTimer
                                         forMode:NSRunLoopCommonModes];
            
        }
        
    }
    
    
    BOOL position = scroll.contentOffset.y+scroll.frame.size.height+2000 > scroll.contentSize.height;
    
    if (items > 0){
        position = items.count - itemViews.count <10;
    }
    
    if (loading == 0 && position && hasmore == 1 && currentScrollHeight != scroll.contentSize.height){
        //CGRect frame = CGRectMake(0, sender.contentSize.height-49, 320, 44);
        //loadmoreView.frame = frame;
        //[scroll addSubview:loadmoreView];
        
        currentScrollHeight = scroll.contentSize.height;
        NSLog(@"%f, %f", currentScrollHeight, scroll.contentSize.height);
        
        [self load_product:(int)items.count];
        
    }
    
    
    
}

-(void)display_product2{
    
    NSMutableArray *tempimg = [[NSMutableArray alloc] init];
    int count = 0;
    long line = 0;
    //CGRect prev = [Design product_initial_frame:(int)itemViews.count config:self.config];
    CGRect last = CGRectMake(0, 0, 0, 0);
    long currentcount = itemViews.count;
    for (long i = itemViews.count; i < currentcount+1 && i < items.count; i++){
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
                frame.origin.y += first_row;
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
        
        [scroll insertSubview:pv belowSubview:search_display];
        [itemViews addObject:pv];
        count++;
        last = pv.frame;
    }
    if (count > 0){
        //[scroll setContentSize:CGSizeMake(320, (120.0 * 1.255+20)*(line+1)+49)];
        if (last.origin.y+last.size.height <= screenHeight){
            [scroll setContentSize:CGSizeMake(screenWidth, screenHeight)];
        } else {
            indicator.frame = CGRectMake(self.config.screenWidth/2-indicator.frame.size.width/2, last.origin.y+last.size.height+15, indicator.frame.size.width, indicator.frame.size.height);
            [scroll setContentSize:CGSizeMake(screenWidth, last.origin.y+last.size.height)];
        }
    }
    // dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    //dispatch_async(queue, ^{
    [self load_image:scroll.contentOffset inArray:tempimg];
    
    loading = 0;
    
    
}
-(void)recaching_views:(NSTimer *)timer{
    NSMutableArray *tempimg = [[NSMutableArray alloc] init];
    NSDecimalNumber *pos = [timer.userInfo objectForKey:@"position"];
    CGFloat offset = [pos doubleValue];
    NSLog(@"LOAD STARTED *************************");
    for (int i = 0 ; i < itemViews.count; i++){
        ViewWithData *v = (ViewWithData *)[itemViews objectAtIndex:i];
        if (v.frame.origin.y+v.frame.size.height < offset - 10 * self.config.screenHeight){
            NSArray *sub = [v subviews];
            for (int i = 0 ; i < sub.count; i++){
                UIView *vi = [sub objectAtIndex:i];
                
                UIView *img = [vi viewWithTag:99];
                [img removeFromSuperview];
                img = nil;
                
                [vi removeFromSuperview];
                vi = nil;
            }
            /*UIView *img = [v viewWithTag:99];
             [img removeFromSuperview];
             img = nil;*/
            v.load_status = 0;
        } else if (v.frame.origin.y > offset + 10*self.config.screenHeight){
            NSArray *sub = [v subviews];
            for (int i = 0 ; i < sub.count; i++){
                UIView *vi = [sub objectAtIndex:i];
                
                UIView *img = [vi viewWithTag:99];
                [img removeFromSuperview];
                img = nil;
                
                [vi removeFromSuperview];
                vi = nil;
            }
            /*UIView *img = [v viewWithTag:99];
             [img removeFromSuperview];
             img = nil;*/
            v.load_status = 0;
        } else if ( (v.frame.origin.y < offset + v.frame.size.height/2 || v.frame.origin.y +v.frame.size.height  > offset - v.frame.size.height/2)  && v.load_status == 0){
            
            NSLog(@"%@, %d, %d", v.itemID, v.frame.origin.y < offset + self.config.screenHeight/2, v.frame.origin.y +v.frame.size.height  > offset - self.config.screenHeight/2);
            for (Product *p in items){
                if ([p.product_id isEqualToString:v.itemID]){
                    [self build_productView:v withProduct:p imageQueue:tempimg];
                    
                    /*ImageWithData *but = [[ImageWithData alloc] init];
                     but.tag = 99;
                     [but setUserInteractionEnabled:YES];
                     but.contentMode = UIViewContentModeScaleAspectFit;
                     [Design style:[[DOM alloc] initWithView:but parent:v] design:design.product_image config:self.config];
                     but.indicator = [v viewWithTag:98];
                     [v addSubview:but];
                     NSString *url = [p.imageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                     but.url = [NSURL URLWithString:url];
                     
                     [tempimg addObject:but];*/
                    
                    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    
    return searchResult.count;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSString *str = [searchResult objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = str;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
    
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = [searchResult objectAtIndex:indexPath.row];
    // [self.delegate mpSearchDidSearch:str inPage:self.activePage];
    [searchbar resignFirstResponder];
    //if (searchbar.text.length > 0){
    self.searchTerm = str;
    [self load_product:0];
    searchbar.text = @"";
    [searchbar setShowsCancelButton:NO animated:YES];
    search_display.hidden = YES;
    titlelabel.text = [NSString stringWithFormat:@"\"%@\"", str];
    [searchbar resignFirstResponder];
    search_display.hidden = YES;
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [searchbar setShowsCancelButton:YES animated:YES];
    search_display.hidden = NO;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    //if (searchbar.text.length > 0){
    
    [searchbar resignFirstResponder];
    //if (searchbar.text.length > 0){
    self.searchTerm = searchbar.text;
    [self load_product:0];
    searchbar.text = @"";
    [searchbar setShowsCancelButton:NO animated:YES];
    search_display.hidden = YES;
    titlelabel.text = [NSString stringWithFormat:@"\"%@\"", self.searchTerm];
    
    //  }
    
    
    // }
    
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchbar resignFirstResponder];
    searchbar.text = @"";
    search_display.hidden = YES;
    [searchbar setShowsCancelButton:NO animated:YES];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    searchResult = [[NSMutableArray alloc] init];
    for(NSString *curString in searchWords) {
        NSString *dstr =[NSString stringWithFormat:@"%@", curString];
        NSString *str = [dstr lowercaseString];
        searchText = [searchText lowercaseString];
        if (str != nil && ![ str isKindOfClass:[NSNull class]] && str.length > 0){
            NSRange substringRange = [str rangeOfString:searchText];
            if (substringRange.location == 0) {
                [searchResult addObject:dstr];
            }
        }
    }
    [search_display reloadData];
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




@implementation ProductViewDesign


@end