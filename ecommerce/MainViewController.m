//
//  MainViewController.m
//  quoteskahuna
//
//  Created by Hanqing Hu on 4/24/14.
//  Copyright (c) 2014 Big Kahuna Studios. All rights reserved.
//

#import "MainViewController.h"
#import "PKRevealController.h"
#import "LeftMenuViewController.h"
#import "FinxLeftMenuViewController.h"
#import "PromotionViewController.h"
#import "NSURLConnectionWithTag.h"
#import "NSURLConnectionBlock.h"
#import "LanguageViewController.h"
#import "Department.h"
#import "PayPalMobile.h"
#import "Design.h"
#import "Branch.h"
#import "AffiliateModule.h"
#import "WholesaleModule.h"
const int USER_LOG_IN = 1;
const int USER_REGISTER = 2;
const int LOAD_DEPARTMENT = 3;
const int SHIPPING_TAX = 4;
@interface MainViewController ()

@end

@implementation MainViewController
@synthesize config;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.reload = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNeedsStatusBarAppearanceUpdate];
    receivedData = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < 5; i++){
        NSMutableData *rec = [[NSMutableData alloc] init];
        [receivedData addObject:rec];
    }
    
    
    loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, -75, self.config.screenWidth, 70)];
    loadingView.backgroundColor = [UIColor whiteColor];
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, loadingView.frame.size.height, loadingView.frame.size.width, 0.5);
    layer.backgroundColor = [[UIColor colorWithRed:196.0/255.0 green:196.0/255.0  blue:196.0/255.0  alpha:1] CGColor];
    [loadingView.layer addSublayer:layer];
    
    loadinglabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, loadingView.frame.size.width, loadingView.frame.size.height-20)];
    loadinglabel.text = [self.config localisedString:@"Loading App..."];
    loadinglabel.textColor = [UIColor colorWithRed:41.0/255.0 green:39.0/255.0 blue:39.0/255.0 alpha:1];
    loadinglabel.textAlignment = NSTextAlignmentCenter;
    loadinglabel.font = [UIFont systemFontOfSize:13];
    [loadingView addSubview:loadinglabel];
    
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.hidesWhenStopped = YES;
    indicator.frame = CGRectMake(self.config.screenWidth/2+55, (loadingView.frame.size.height+20)/2-indicator.frame.size.height/2, indicator.frame.size.width, indicator.frame.size.height);
    [indicator startAnimating];
    [loadingView addSubview:indicator];
    [self.view addSubview:loadingView];
    
    
    
    
    [self load_department];
    //[self load_shipping_tax];
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    if (self.reload){
        self.config = [[Config alloc] init];
        [self.config load_default];
        self.config.device_token = [UIDevice currentDevice].identifierForVendor.UUIDString;
        loadinglabel.text = [self.config localisedString:@"Loading App..."];
        [self load_department];
        //[self load_shipping_tax];
        
        
        self.reload = NO;
    }
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
                             frame = CGRectMake(0, -75, frame.size.width, frame.size.height);
                             loadingView.frame = frame;
                         }
                         completion:^(BOOL finished){
                         }];
    }
    
}

-(void)load_main{
    
    
    
    LeftMenuViewController *lm;
    UINavigationController *frontViewController;
    if (!first){
        promo = [[PromotionViewController alloc] initWithNibName:@"PromotionViewController" bundle:nil];
        promo.config = self.config;
        
        frontViewController = [[UINavigationController alloc] initWithRootViewController:promo];
    } else {
        LanguageViewController *lan = [[LanguageViewController alloc] initWithNibName:@"LanguageViewController" bundle:nil];
        lan.config = self.config;
        lan.first = YES;
        frontViewController = [[UINavigationController alloc] initWithRootViewController:lan];
        first = NO;
    }
    
    [Design navigationbar:frontViewController.navigationBar config:self.config];
    //[frontViewController setNavigationBarHidden:YES];
    
    lm = [[LeftMenuViewController alloc] initWithNibName:@"LeftMenuViewController" bundle:nil];
    lm.selected = 1;
    [lm setSelected:1];
    lm.config = self.config;
    
    UIViewController *leftViewController = lm;
    
    
    // Step 3: Instantiate your PKRevealController.
    PKRevealController *revealController = [PKRevealController revealControllerWithFrontViewController:frontViewController leftViewController:leftViewController  rightViewController:nil options:nil];
    
    [self presentViewController:revealController animated:NO completion:nil];
}

-(void)load_finx_main{
    FinxLeftMenuViewController *lm;
    UINavigationController *frontViewController;
    if (!first || self.config.available_locations.count == 1){
        promo = [[PromotionViewController alloc] initWithNibName:@"PromotionViewController" bundle:nil];
        promo.config = self.config;
        
        frontViewController = [[UINavigationController alloc] initWithRootViewController:promo];
    } else {
        LanguageViewController *lan = [[LanguageViewController alloc] initWithNibName:@"LanguageViewController" bundle:nil];
        lan.config = self.config;
        lan.first = YES;
        frontViewController = [[UINavigationController alloc] initWithRootViewController:lan];
        first = NO;
    }
    
    [Design navigationbar:frontViewController.navigationBar config:self.config];
    //[frontViewController setNavigationBarHidden:YES];
    
    lm = [[FinxLeftMenuViewController alloc] initWithNibName:@"FinxLeftMenuViewController" bundle:nil];
    lm.selected = 1;
    [lm setSelected:1];
    lm.config = self.config;
    
    UIViewController *leftViewController = lm;
    
    
    // Step 3: Instantiate your PKRevealController.
    PKRevealController *revealController = [PKRevealController revealControllerWithFrontViewController:frontViewController leftViewController:leftViewController  rightViewController:nil options:nil];
    
    [self presentViewController:revealController animated:NO completion:nil];
}
-(void)load_department{
    [self showLoadingView:YES];
    if (self.config.language == nil || self.config.location == nil){
        first = YES;
        
        NSLocale *currentLocale = [NSLocale currentLocale];  // get the current locale.
        NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
        NSString *lancode = [[[currentLocale objectForKey:NSLocaleLanguageCode] substringToIndex:2] uppercaseString];
        self.config.location = [countryCode uppercaseString];
        self.config.language = lancode;
        [self.config change_language:self.config.language];
        
    }
    
     NSString *myRequestString = [NSString stringWithFormat:@"email=%@&passowrd=0&token=%@&app_uuid=%@&language=%@&location=%@&currency=%@&app_version=%@", self.config.email, self.config.token, self.config.APP_UUID,self.config.language, self.config.location, self.config.currency, self.config.app_version];
    
    
    NSLog(myRequestString);
    
    // Create Data from request
    NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", self.config.API_ROOT, self.config.API_LOAD_DEPARTMENT]]];
    
    
    
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
    
    NSMutableData *received = [receivedData objectAtIndex:LOAD_DEPARTMENT];
    [received setLength:0];
    NSURLConnectionWithTag *urlConnection = [[NSURLConnectionWithTag alloc] initWithRequest:request delegate:self tag:LOAD_DEPARTMENT];
}

-(void)signin{
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating) toTarget:self withObject:nil];
    if (self.config.email != nil && self.config.email.length > 0 && self.config.token != nil && self.config.token.length > 0){
        if (self.config.user_id == 0){
            NSString *myRequestString = [NSString stringWithFormat:@"email=%@&passowrd=0&token=%@&device_token=%@&app_uuid=%@&cached_data=%@", self.config.email, self.config.token, self.config.device_token, self.config.APP_UUID, [self.config.cache to_json] ];
            
            NSLog(@"%@", myRequestString);
            
            // Create Data from request
            NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", self.config.API_ROOT, self.config.API_LOG_IN]]];
            
            NSLog(@"%@", request.description);
            
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
            
            NSMutableData *received = [receivedData objectAtIndex:USER_LOG_IN];
            [received setLength:0];
            NSURLConnectionWithTag *urlConnection = [[NSURLConnectionWithTag alloc] initWithRequest:request delegate:self tag:USER_LOG_IN];
        }
        
    } else {
        NSString *myRequestString = [NSString stringWithFormat:@"device_token=%@&push_token=%@&app_uuid=%@", self.config.device_token, self.config.push_token, self.config.APP_UUID];
        
        
        
        // Create Data from request
        NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", self.config.API_ROOT, self.config.API_SESSION_START]]];
        
        
        
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
        
        NSMutableData *received = [receivedData objectAtIndex:USER_REGISTER];
        [received setLength:0];
        NSURLConnectionWithTag *urlConnection = [[NSURLConnectionWithTag alloc] initWithRequest:request delegate:self tag:USER_REGISTER];
        
    }
}

-(void)load_shipping_tax{
    NSString *myRequestString = [NSString stringWithFormat:@"app_uuid=%@&location=%@&currency=%@", self.config.APP_UUID,self.config.location, self.config.currency];
    
    // Create Data from request
    NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", self.config.API_ROOT, self.config.API_SHIPPING_AND_TAX]]];
    
    
    
    // set Request Type
    [request setHTTPMethod: @"POST"];
    // Set content-type
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    // Set Request Body
    [request setHTTPBody: myRequestData];
    
    
    NSMutableData *received = [receivedData objectAtIndex:SHIPPING_TAX];
    [received setLength:0];
    NSURLConnectionWithTag *urlConnection = [[NSURLConnectionWithTag alloc] initWithRequest:request delegate:self tag:SHIPPING_TAX];
}
-(void)load_sharing{
    NSString *myRequestString = [NSString stringWithFormat:@"app_uuid=%@", self.config.APP_UUID];
    
    // Create Data from request
    NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", self.config.API_ROOT, self.config.API_SHARING_TEXT]]];
    
    
    
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
                [self.config.sharingText setObject:[dic objectForKey:@"product"] forKey:@"product"];
                [self.config.sharingText setObject:[dic objectForKey:@"side_menu"] forKey:@"side_menu"];
            }
            
            
        } else {
            //There was an error
            NSLog(@"%@", err.description);
        }
        
    };
    [connection start];
    
}
-(void)load_affiliate{
    [AffiliateModule getMerchant:self.config completion:^(AffiliateModule *am, NSError *error) {
        if ([am.aid isEqualToString:@"0"] || am == nil || [am isKindOfClass:[NSNull class]]) {
            self.config.affiliate = nil;
        }
        else {
            if (self.config.affiliate == nil) self.config.affiliate = am;
            else {
                NSString *aid = self.config.affiliate.aid;
                self.config.affiliate = nil;
                self.config.affiliate = am;
                self.config.affiliate.aid = aid;
            }
        }
    }];
}
-(void)load_modules{
    [WholesaleModule getWholesaleApp:self.config completion:^(WholesaleModule *wm, NSError *error) {
        if (wm!= nil) {
            self.config.wholesale.wholesale_app_id = wm.wholesale_app_id;
        }
    }];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self signin];
        [self load_department];
        //[self load_shipping_tax];
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
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Cannot Connect to Internet"] message:[self.config localisedString:@"This app requires internet connection."] delegate:self cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles:[self.config localisedString:@"Retry"], nil];
        [alert show];
        
        [indicator stopAnimating];
        [self showLoadingView:NO];
        
    }
    
    
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [indicator stopAnimating];
    [self showLoadingView:NO];
    NSURLConnectionWithTag *conn = (NSURLConnectionWithTag *)connection;
    if (conn.tag ==LOAD_DEPARTMENT ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Cannot Connect to Internet"] message:[self.config localisedString:@"This app requires internet connection."] delegate:self cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles:[self.config localisedString:@"Retry"], nil];
        [alert show];
    }
    
    
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSURLConnectionWithTag *conn = (NSURLConnectionWithTag *)connection;
    NSMutableData *received = [receivedData objectAtIndex:conn.tag];
    
    @try {
        
        if (conn.tag == USER_LOG_IN){
            NSString *myxml = [[NSString alloc] initWithData:received encoding:NSASCIIStringEncoding];
            NSLog(@"%@", myxml);
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:received options:0 error:nil];
            if ([[dic objectForKey:@"success"] intValue] == 1){
                [self.config user_info_from_dictionary:dic];
                [[Branch getInstance] setIdentity:[NSString stringWithFormat:@"%@:%@", self.config.email, self.config.APP_UUID]];
                [self get_credit];
                
                [AffiliateModule getAffiliateID:self.config.APP_UUID email:self.config.email completion:^(NSString *aid, NSError *error) {
                    if ([aid isEqualToString:@"0"]) return;
                    if (self.config.affiliate == nil){
                        self.config.affiliate = [[AffiliateModule alloc] init];
                    }
                    self.config.affiliate.aid = aid;
                }];
                
                if (promo != nil) [promo refresh_badge];
                [self.config.cache clear];
                
            } else {
                //self.config.user_id = [dic objectForKey:@"user_id"];
                //self.config.email = @"";
                
                [self get_credit];
            }
            
            [self.config check_cart_with_view:nil];
            
        }
        else if (conn.tag == USER_REGISTER){
            
            NSString *myxml = [[NSString alloc] initWithData:received encoding:NSASCIIStringEncoding];
            NSLog(@"%@", myxml);
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:received options:0 error:nil];
            int success = [[dic objectForKey:@"success"] intValue];
            if (success == 1){
                //self.config.user_id = [dic objectForKey:@"user_id"];
                //  self.config.token = [dic objectForKey:@"access_token"];
                //  self.config.cartnum = [[dic objectForKey:@"cart_number"] intValue];
                //  [self.config check_cart_with_view:nil];
                [self get_credit];
            }
            
            
            
        } else if (conn.tag == LOAD_DEPARTMENT){
            [indicator stopAnimating];
            [self showLoadingView:NO];
            
            NSString *myxml = [[NSString alloc] initWithData:received encoding:NSASCIIStringEncoding];
            NSLog(@"%@", myxml);
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:received options:0 error:nil];
            NSString *uuid = [dic objectForKey:@"uuid"];
            if (![uuid isEqualToString:self.config.APP_UUID]){
                NSString *parentuuid = [dic objectForKey:@"parent_uuid"];
                if ([parentuuid isEqualToString:self.config.APP_UUID]){
                    self.config.APP_UUID = uuid;
                    
                }
            } else {
                
                
            }
            self.config.language = [dic objectForKey:@"language"];
            self.config.location = [dic objectForKey:@"location"];
            self.config.currency = [dic objectForKey:@"currency"];
            self.config.currency_symbol = [[dic objectForKey:@"currency_symbol"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            self.config.currency_rate = [NSDecimalNumber decimalNumberWithString:[dic objectForKey:@"currency_rate"]];
            if (self.config.language != nil && self.config.language.length > 0){
                [self.config change_language:self.config.language];
            }
            
            [self signin];
            [self load_affiliate];
            [self load_modules];
            [self load_shipping_tax];
            [self load_sharing];
            
            self.config.available_locations = [dic objectForKey:@"location_options"];
            
            
            
            NSArray *deps= [dic objectForKey:@"departments"];
            for (NSDictionary *d in deps){
                NSString *did = [d objectForKey:@"department_id"] ;
                NSString *name = [d objectForKey:@"name"];
                Department *d = [[Department alloc] init];
                d.department_id = did;
                d.name = name;
                d.department_type = @"product";
                [self.config.departments addObject:d];
            }
            NSString *appname = [dic objectForKey:@"app_name"];
            self.config.app_name = appname;
            self.config.app_email = [dic objectForKey:@"app_email"];
            self.config.app_logo = [dic objectForKey:@"logo"];
            self.config.app_text_logo = [dic objectForKey:@"text_logo"];
            NSDictionary *social = [dic objectForKey:@"social_feed"];
            if (social != nil && ![social isKindOfClass:[NSNull class]]){
                for (NSString *key in [social allKeys]){
                    if (key.length > 0){
                        Department *d = [[Department alloc] init];
                        d.department_id = key;
                        d.name = key;
                        d.department_type = @"social";
                        d.content_url = [[social objectForKey:key] objectForKey:@"content_url"];
                        d.image_url = [[social objectForKey:key] objectForKey:@"image_url"];
                        d.social_username = [[social objectForKey:key] objectForKey:@"username"];
                        [self.config.departments addObject:d];
                        
                    }
                }
            }
            NSString *link = [dic objectForKey:@"link_inventory"];
            if (![link isKindOfClass:[NSNull class]]){
                self.config.link_inventory = link;
            }
            
            NSString *pay = [dic objectForKey:@"payment_method"];
            if (![pay isKindOfClass:[NSNull class]] && ![pay isEqualToString:@"Paypal"]){
                //self.config.payment_method = pay;
            }
            if ([pay isEqualToString:@"Paypal"]){
                NSString *cid = [dic objectForKey:@"paypal_client_id"];
                NSString *scid = [dic objectForKey:@"paypal_sandbox_id"];
                self.config.paypal_live = [[dic objectForKey:@"paypal_live"] intValue];
                [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction :cid,
                                                                       PayPalEnvironmentSandbox : scid}];
                //self.config.payment_method = pay;
            }
            self.config.app_template = [dic objectForKey:@"app_template"];
            
            self.config.design = [dic objectForKey:@"design"];
            if ([self.config.design isKindOfClass:[NSNull class]]) self.config.design = [[NSMutableDictionary alloc] init];
            [self.config save_default];
            
            [self.config change_active_app];
            
            //[self load_main];
            [self load_finx_main];
        } else if (conn.tag == SHIPPING_TAX){
            NSString *myxml = [[NSString alloc] initWithData:received encoding:NSASCIIStringEncoding];
            NSLog(@"%@", myxml);
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:received options:0 error:nil];
            NSArray *shipping = [dic objectForKey:@"shipping"];
            
            for (NSDictionary *d in shipping){
                ShippingCountry *sc = [[ShippingCountry alloc] init];
                [sc shipping_country_from_dictionary:d];
                [self.config.shipping addObject:sc];
            }
            
            
            /*for (NSDictionary *d in shipping){
                Shipping *s = [[Shipping alloc] init];
                [s shipping_from_dictionary:d];
                [self.config.shipping addObject:s];
            }
            
            NSArray *tax = [dic objectForKey:@"tax"];
            for (NSDictionary *d in tax){
                NSString *state= [d objectForKey:@"tax_state"];
                NSDecimalNumber *tax = [NSDecimalNumber decimalNumberWithString:[d objectForKey:@"tax"]];
                [self.config.tax setObject:tax forKey:state];
            }*/
            
        }
        
        
    }
    @catch (NSException *exception) {
        
        [indicator stopAnimating];
        [self showLoadingView:NO];
    }
    @finally {
        
        
        
        //searchBarState = 0;
    }
    
}

-(void)get_credit{
    [[Branch getInstance] loadRewardsWithCallback:^(BOOL changed, NSError *error) {
        
        NSInteger credits = [[Branch getInstance] getCredits];
        self.config.store_credit = [[NSDecimalNumber alloc] initWithInteger:credits];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        int credit = [[defaults objectForKey:@"store_credit"] intValue];
        int current =[self.config.store_credit intValue];
        if (credit < current){
            int diff = current - credit;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Congratulations"] message:[NSString stringWithFormat:[self.config localisedString:@"You just received $%d store credit. Go to Account and log in to redeem it."], diff] delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
            
            [alert show];
        }
        [defaults setObject:[NSString stringWithFormat:@"%d", current] forKey:@"store_credit"];
        
    }];
}

-(void)threadStartAnimating{
    [indicator startAnimating];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
