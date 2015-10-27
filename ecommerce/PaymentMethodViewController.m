//
//  PaymentMethodViewController.m
//  Ecommerce
//
//  Created by Han Hu on 9/15/15.
//  Copyright (c) 2015 Twixxies. All rights reserved.
//

#import "PaymentMethodViewController.h"
#import "NSURLConnectionBlock.h"
#import "ionicons-codes.h"
#import "IonIcons.h"
#import "Design.h"
#import "ViewWithData.h"
#import "NSString+FontAwesome.h"
//authoriznet
#import "CreateCustomerProfileRequest.h"
#import "CreateCustomerProfileResponse.h"
#import "CustomerProfileBaseType.h"
#import "StringUtility.h"
@interface PaymentMethodViewController ()

@end

@implementation PaymentMethodViewController

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 44)] ;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:17.3];
    
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor colorWithRed:0.302 green:0.302 blue:0.318 alpha:1]; // change this color
    self.navigationItem.titleView = label;
    if (self.is_checkout)
        label.text = [self.config localisedString:@"Select Payment"];
    else label.text = [self.config localisedString:@"Payment Method"];
    //[label sizeToFit];
    [Design navigationbar_title:label config:self.config];
    
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
    
    
    
    seg = [[UILabel alloc] init];
    seg.text = [self.config localisedString:@"Add"];
    seg.textAlignment = NSTextAlignmentRight;
    seg.frame = CGRectMake(80-60, 0, 60, 44);
    UITapGestureRecognizer *tapseg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(add)];
    [seg addGestureRecognizer:tapseg];
    seg.userInteractionEnabled = YES;
    [Design style:[[DOM alloc] initWithView:seg parent:nil] design:[[self.config.design objectForKey:@"design"] objectForKey:@"navigation_icon"] config:self.config];
    
    
    
    UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView:seg];
    //[seg release];
    
    self.navigationItem.rightBarButtonItem = segmentBarItem;
    
    
    
    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.config.screenWidth, self.config.screenHeight-64)];
    [self.view addSubview:scroll];
    
    
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(self.config.screenWidth/2-indicator.frame.size.width/2, self.config.screenHeight/2-indicator.frame.size.height/2, indicator.frame.size.width, indicator.frame.size.height);
    [self.view addSubview:indicator];
    
    self.view.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
    
    
    if (self.config.user_payment_methods.count == 0){
        AddEditPaymentMethodViewController *aep = [[AddEditPaymentMethodViewController alloc] init];
        aep.config = self.config;
        aep.allusermethods = self.config.user_payment_methods;
        aep.parent = self.parent;
        [self.navigationController pushViewController:aep animated:NO];
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    if ((self.config.user_id == nil || self.config.user_id == 0 || self.config.user_id.length == 0) && self.config.guest_checkout){
        [self build_payment];
        
    } else {
        [self load_payment_method];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)load_payment_method{
    [NSThread detachNewThreadSelector:@selector(startAnimating) toTarget:self withObject:nil];
    user_payment_method = [[NSMutableArray alloc] init];
    NSString *myRequestString = [NSString stringWithFormat:@"app_uuid=%@&user_id=%@&access_token=%@", self.config.APP_UUID, self.config.user_id, self.config.token];
    
    // Create Data from request
    NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", self.config.API_ROOT, self.config.API_GET_USER_PAYMENTMETHOD]]];
    
    
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
            NSArray *arr = [dic objectForKey:@"payment_method"];
            for (NSDictionary *pay in arr){
                UserPaymentMethod *upm = [[UserPaymentMethod alloc] init];
                [upm dictionary_to_method:pay];
                [user_payment_method addObject:upm];
            }
            [self.config.user_payment_methods removeAllObjects];
            self.config.user_payment_methods = nil;
            self.config.user_payment_methods = user_payment_method;
            [self build_payment];
            [indicator stopAnimating];
            
        } else {
            //There was an error
            NSLog(@"%@", err.description);
        }
        
    };
    [connection start];
}

-(void)build_payment{
    for (UIView *v in scroll.subviews) [v removeFromSuperview];
    
    
    payment_views = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < self.config.user_payment_methods.count; i++){
        
        UserPaymentMethod *apm = [self.config.user_payment_methods objectAtIndex:i];
        
        ViewWithData *v = [[ViewWithData alloc] initWithFrame:CGRectMake(-1, (80-0.5)*i-0.5, self.config.screenWidth+1, 80)];
        v.itemID = apm.payment_method_id;
        v.backgroundColor = [UIColor whiteColor];
        v.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pay_sel:)];
        [v addGestureRecognizer:tap];
        
        v.layer.borderColor = [[UIColor colorWithRed:197.0/255.0 green:197.0/255.0 blue:197.0/255.0 alpha:1] CGColor];
        v.layer.borderWidth = 0.5;
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 25, 40, 25)];
        icon.contentMode = UIViewContentModeScaleAspectFit;
        //icon.textAlignment = NSTextAlignmentCenter;
        //icon.font = [UIFont fontWithName:kFontAwesomeFamilyName size:30];
        [v addSubview:icon];
        
        NSString *brand = @"CC";
        if ([apm.cardtype isEqualToString:@"visa"]){
            //icon.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-cc-visa"];
            icon.image = [UIImage imageNamed:@"visa.png"];
            brand = @"Visa";
        } else if ([apm.cardtype isEqualToString:@"mastercard"]){
            //icon.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-cc-mastercard"];
            icon.image = [UIImage imageNamed:@"master-card.png"];
            brand = @"Mastercard";
        } else if ([apm.cardtype isEqualToString:@"discover"]){
            //icon.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-cc-discover"];
            icon.image = [UIImage imageNamed:@"discover.png"];
            brand = @"Discover";
        } else if ([apm.cardtype isEqualToString:@"amex"]){
            //icon.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-cc-amex"];
            icon.image = [UIImage imageNamed:@"amex.png"];
            brand = @"Amex";
        } else {
            
            //icon.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-credit-card"];
        }
        
        
        UILabel *ptitle = [[UILabel alloc] initWithFrame:CGRectMake(icon.frame.origin.x+icon.frame.size.width+10, 10, self.config.screenWidth - icon.frame.origin.x-icon.frame.size.width-5-70, 40)];
        ptitle.font =[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f];
        
        BOOL selectd = NO;
        if (self.is_checkout && self.config.selected_payment != nil && [apm.payment_method_id isEqualToString:self.config.selected_payment.payment_method_id]){
            ptitle.font = [UIFont boldSystemFontOfSize:16.0f];
            selectd = YES;
        }
        
        [v addSubview:ptitle];
        if (![apm.payment_gateway isEqualToString:@"Custom"]){
            if ([apm.payment_method isEqualToString:@"cc"] || [apm.payment_method isEqualToString:@"credit card"]){
                NSString *deftstr =[NSString stringWithFormat:@"%@ **** %@", brand, apm.last4];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc]
                                                  initWithString:deftstr];
                [str addAttribute:NSForegroundColorAttributeName
                            value:[UIColor colorWithRed:41.0/255.0 green:39.0/255.0 blue:39.0/255.0 alpha:1] range:NSMakeRange(0, deftstr.length)];
                
                if (selectd){
                    [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17] range:NSMakeRange(0, deftstr.length)];
                } else {
                    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f] range:NSMakeRange(0, deftstr.length)];
                }
                if (apm.is_default == 1){
                    NSString *deftstr =[NSString stringWithFormat:@"%@ **** %@ - %@", brand,apm.last4, [self.config localisedString:@"Default"]];
                    str = [[NSMutableAttributedString alloc] initWithString: deftstr];
                    NSRange r = [deftstr rangeOfString:[NSString stringWithFormat:@"- %@", [self.config localisedString:@"Default"]]];
                    [str addAttribute:NSForegroundColorAttributeName
                                value:[UIColor colorWithRed:43.0/255.0 green:194.0/255.0 blue:116.0/255.0 alpha:1] range:r];
                    [str addAttribute:NSFontAttributeName
                                value:[UIFont boldSystemFontOfSize:14] range:r];
                    [str addAttribute:NSForegroundColorAttributeName
                                value:[UIColor colorWithRed:41.0/255.0 green:39.0/255.0 blue:39.0/255.0 alpha:1] range:NSMakeRange(0, r.location)];
                    if (selectd){
                        [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16.0f] range:NSMakeRange(0, r.location)];
                    } else {
                        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f] range:NSMakeRange(0, r.location)];
                    }
                }
                
                
                
                [ptitle setAttributedText: str];
                //title = [NSString stringWithFormat:@"**** %@", apm.last4];
                UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(ptitle.frame.origin.x, 40, 80, 20)];
                date.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f];
                date.textColor = [UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:157.0/255.0 alpha:1];
                date.text = [NSString stringWithFormat:@"%@/%@", apm.expmonth, apm.expyear];
                [v addSubview:date];
                
                
                UILabel *cname = [[UILabel alloc] initWithFrame:CGRectMake(date.frame.origin.x+date.frame.size.width+5, 40, 100, 20)];
                cname.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f];
                cname.textColor = [UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:157.0/255.0 alpha:1];
                cname.text = [NSString stringWithFormat:@"%@ %@", apm.billingfirstname, apm.billinglastname];
                [v addSubview:cname];
                
                
            } else if ([apm.payment_method isEqualToString:@"paypal"]){
                NSMutableAttributedString *str =[[NSMutableAttributedString alloc]
                                                 initWithString:[self.config localisedString:@"Paypal"]];
                if (apm.is_default == 1){
                    NSString *deftstr =[NSString stringWithFormat:@"%@ - %@", [self.config localisedString:@"Paypal"], [self.config localisedString:@"Default"]];
                    
                    str =[[NSMutableAttributedString alloc]
                          initWithString:deftstr];
                    NSRange r = [deftstr rangeOfString:[NSString stringWithFormat:@"- %@", [self.config localisedString:@"Default"]]];
                    [str addAttribute:NSForegroundColorAttributeName
                                value:[UIColor colorWithRed:43.0/255.0 green:194.0/255.0 blue:116.0/255.0 alpha:1] range:r];
                }
                [ptitle setAttributedText: str];
                
                UILabel *account = [[UILabel alloc] initWithFrame:CGRectMake(ptitle.frame.origin.x, 40, 180, 20)];
                account.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f];
                account.textColor = [UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:157.0/255.0 alpha:1];
                account.text = [NSString stringWithFormat:@"%@", apm.account_id];
                [v addSubview:account];
                //title = [self.config localisedString:@"Paypal"];
                icon.image = [UIImage imageNamed:@"paypal.png"];
                //icon.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-paypal"];
            }
        } else {
            NSMutableAttributedString *str =[[NSMutableAttributedString alloc]
                                             initWithString:apm.payment_method];
            if (apm.is_default == 1){
                NSString *deftstr =[NSString stringWithFormat:@"%@ - %@", apm.payment_method, [self.config localisedString:@"Default"]];
                
                str =[[NSMutableAttributedString alloc]
                      initWithString:deftstr];
                NSRange r = [deftstr rangeOfString:[NSString stringWithFormat:@"- %@", [self.config localisedString:@"Default"]]];
                [str addAttribute:NSForegroundColorAttributeName
                            value:[UIColor colorWithRed:43.0/255.0 green:194.0/255.0 blue:116.0/255.0 alpha:1] range:r];
            }
            [ptitle setAttributedText: str];
            ptitle.frame = CGRectMake(ptitle.frame.origin.x, 40-ptitle.frame.size.height/2, ptitle.frame.size.width, ptitle.frame.size.height);
            icon.image = [UIImage imageNamed:@"custom-payment.png"];
        }
        
        
        
        
        
        
        ButtonWithData *btn = [[ButtonWithData alloc] initWithFrame:CGRectMake(self.config.screenWidth-70, 0, 70, 80)];
        btn.item_id = apm.payment_method_id;
        [btn addTarget:self action:@selector(edit_pay:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:[self.config localisedString:@"Edit"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateNormal];
        [v addSubview:btn];
        
        [scroll addSubview: v];
    }
    
    [scroll setContentSize:CGSizeMake(self.config.screenWidth, self.config.user_payment_methods.count*64)];
    if (scroll.contentSize.height < self.config.screenHeight){
        [scroll setContentSize:CGSizeMake(self.config.screenWidth, self.config.screenHeight+1)];
    }
}

-(IBAction)edit_pay:(id)sender{
    ButtonWithData *v = (ButtonWithData *)sender;
    for (UserPaymentMethod *apm in self.config.user_payment_methods){
        if ([apm.payment_method_id isEqualToString:v.item_id]){
            
            if (![apm.payment_gateway isEqualToString:@"Custom"]){
                if ([apm.payment_method isEqualToString:@"cc"] || [apm.payment_method isEqualToString:@"credit card"]){
                    CreditCardViewController *cc = [[CreditCardViewController alloc] init];
                    cc.config = self.config;
                    cc.appmethod = apm.appmethod;
                    cc.usermethod = apm;
                    cc.allusermethods = self.config.user_payment_methods;
                    cc.parent = self;
                    [self.navigationController pushViewController:cc animated:YES];
                } else if ([apm.payment_gateway isEqualToString:@"Paypal"] && [apm.payment_method isEqualToString:@"paypal"]){
                    AccountPaymentViewController *cp = [[AccountPaymentViewController alloc] init];
                    cp.config = self.config;
                    cp.appmethod = apm.appmethod;
                    cp.usermethod = apm;
                    cp.allusermethods = self.config.user_payment_methods;
                    cp.parent = self;
                    [self.navigationController pushViewController:cp animated:YES];
                }
            } else {
                CustomePaymentViewController *cp = [[CustomePaymentViewController alloc] init];
                cp.config = self.config;
                cp.appmethod = apm.appmethod;
                cp.usermethod = apm;
                cp.allusermethods = self.config.user_payment_methods;
                cp.parent = self;
                [self.navigationController pushViewController:cp animated:YES];
            }
        }
    }
}

-(void)pay_sel:(UITapGestureRecognizer *)ges{
    if (!self.is_checkout) return;
    ViewWithData *v = (ViewWithData *)ges.view;
    for (UserPaymentMethod *apm in self.config.user_payment_methods){
        if ([apm.payment_method_id isEqualToString:v.itemID]){
            self.config.selected_payment = apm;
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(void)add{
    AddEditPaymentMethodViewController *aep = [[AddEditPaymentMethodViewController alloc] init];
    aep.config = self.config;
    aep.allusermethods = self.config.user_payment_methods;
    aep.parent = self;
    [self.navigationController pushViewController:aep animated:YES];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)startAnimating{
    [indicator startAnimating];
}

@end











































@implementation AddEditPaymentMethodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 44)] ;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:17.3];
    
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor colorWithRed:0.302 green:0.302 blue:0.318 alpha:1]; // change this color
    self.navigationItem.titleView = label;
    label.text = [self.config localisedString:@"Payment Options"];
    //[label sizeToFit];
    [Design navigationbar_title:label config:self.config];
    
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
    scroll.backgroundColor = [UIColor colorWithRed:245/255.0 green:243/255.0 blue:243/255.0 alpha:1];
    [self.view addSubview:scroll];
    
    [self load_payment_method];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)load_payment_method{
    app_payment_method = [[NSMutableArray alloc] init];
    NSString *myRequestString = [NSString stringWithFormat:@"app_uuid=%@&user_id=%@&access_token=%@", self.config.APP_UUID, self.config.user_id, self.config.token];
    
    // Create Data from request
    NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", self.config.API_ROOT, self.config.API_GET_APP_PAYMENTMETHOD]]];
    
    
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
            NSArray *arr = [dic objectForKey:@"payment_method"];
            for (NSDictionary *pay in arr){
                AppPaymentMethod *upm = [[AppPaymentMethod alloc] init];
                [upm dictionary_to_method:pay];
                [app_payment_method addObject:upm];
            }
            [self build_payment];
            
        } else {
            //There was an error
            NSLog(@"%@", err.description);
        }
        
    };
    [connection start];
}

-(void)build_payment{
    payment_views = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < app_payment_method.count; i++){
        
        AppPaymentMethod *apm = [app_payment_method objectAtIndex:i];
        
        ViewWithData *v = [[ViewWithData alloc] initWithFrame:CGRectMake(5, 64*i+5, self.config.screenWidth-10, 64)];
        v.itemID = apm.payment_method_id;
        v.backgroundColor = [UIColor whiteColor];
        if (i > 0){
            CALayer *layer = [CALayer layer];
            layer.frame = CGRectMake(0, 0, v.frame.size.width, 0.5);
            layer.backgroundColor = [[UIColor colorWithRed:197.0/255.0 green:197.0/255.0 blue:197.0/255.0 alpha:1] CGColor];
            [v.layer addSublayer:layer];
        }
        v.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pay_sel:)];
        [v addGestureRecognizer:tap];
        
        UILabel *icon = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
        icon.textAlignment = NSTextAlignmentCenter;
        icon.font = [UIFont fontWithName:kFontAwesomeFamilyName size:30];
        [v addSubview:icon];
        
        NSString *title = @"";
        if (![apm.payment_gateway isEqualToString:@"Custom"]){
            if ([apm.payment_method isEqualToString:@"cc"] || [apm.payment_method isEqualToString:@"credit card"]){
                title = [self.config localisedString:@"Credit Card"];
                icon.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-credit-card"];
            } else if ([apm.payment_method isEqualToString:@"paypal"]){
                title = [self.config localisedString:@"Paypal"];
                icon.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-paypal"];
            }
        } else {
            title = apm.payment_method;
            icon.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-university"];
        }
        
        UILabel *ptitle = [[UILabel alloc] initWithFrame:CGRectMake(icon.frame.origin.x+icon.frame.size.width+5, 0, self.config.screenWidth - icon.frame.origin.x+icon.frame.size.width+5, icon.frame.size.height)];
        ptitle.text = title;
        [v addSubview:ptitle];
        
        [scroll addSubview: v];
    }
    
    [scroll setContentSize:CGSizeMake(self.config.screenWidth, app_payment_method.count*64)];
    if (scroll.contentSize.height < self.config.screenHeight){
        [scroll setContentSize:CGSizeMake(self.config.screenWidth, self.config.screenHeight+1)];
    }
    
}

-(void)pay_sel:(UITapGestureRecognizer *)ges{
    ViewWithData *v = (ViewWithData *)ges.view;
    for (AppPaymentMethod *apm in app_payment_method){
        if ([apm.payment_method_id isEqualToString:v.itemID]){
            if (![apm.payment_gateway isEqualToString:@"Custom"]) {
                if ([apm.payment_method isEqualToString:@"cc"] || [apm.payment_method isEqualToString:@"credit card"]){
                    CreditCardViewController *cc = [[CreditCardViewController alloc] init];
                    cc.config = self.config;
                    cc.appmethod = apm;
                    cc.allusermethods = self.allusermethods;
                    cc.parent = self.parent;
                    [self.navigationController pushViewController:cc animated:YES];
                }  else if ([apm.payment_gateway isEqualToString:@"Paypal"] && [apm.payment_method isEqualToString:@"paypal"]){
                    AccountPaymentViewController *cp = [[AccountPaymentViewController alloc] init];
                    cp.config = self.config;
                    cp.appmethod = apm;
                    cp.allusermethods = self.config.user_payment_methods;
                    cp.parent = self.parent;
                    [self.navigationController pushViewController:cp animated:YES];
                }
            } else {
                CustomePaymentViewController *cp = [[CustomePaymentViewController alloc] init];
                cp.config = self.config;
                cp.appmethod = apm;
                //cp.usermethod = apm;
                cp.allusermethods = self.allusermethods;
                cp.parent = self.parent;
                [self.navigationController pushViewController:cp animated:YES];
            }
        }
    }
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

@end










































const int CARD_INFO_CHANGED = 1;
const int CARD_INFO_UNCHANGED = 2;
const int CARD_NO_CHANGE = 0;

@implementation CreditCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    changed = CARD_NO_CHANGE;
    tableloaded = 0;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 44)] ;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:17.3];
    
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor colorWithRed:0.302 green:0.302 blue:0.318 alpha:1]; // change this color
    self.navigationItem.titleView = label;
    label.text = [self.config localisedString:@"Payment Details"];
    //[label sizeToFit];
    [Design navigationbar_title:label config:self.config];
    
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
    
    
    UILabel *seg = [[UILabel alloc] init];
    seg.text = [self.config localisedString:@"Save"];
    seg.textAlignment = NSTextAlignmentRight;
    seg.frame = CGRectMake(80-120, 0, 120, 44);
    UITapGestureRecognizer *tapseg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(save)];
    [seg addGestureRecognizer:tapseg];
    seg.userInteractionEnabled = YES;
    [Design style:[[DOM alloc] initWithView:seg parent:nil] design:[[self.config.design objectForKey:@"design"] objectForKey:@"navigation_icon"] config:self.config];
    
    
    
    UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView:seg];
    //[seg release];
    
    self.navigationItem.rightBarButtonItem = segmentBarItem;
    
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.config.screenWidth, self.config.screenHeight-64) style:UITableViewStyleGrouped];
    
    
    table.delegate = self;
    table.dataSource = self;
    table.rowHeight = 80;
    table.separatorColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1];
    [self.view addSubview:table];
    
    
    picker_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.config.screenWidth, 40)];
    picker_view.backgroundColor = [UIColor whiteColor];
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, self.config.screenWidth, 0.5);
    layer.backgroundColor = [[UIColor colorWithRed:196.0/255.0 green:196.0/255.0 blue:196.0/255.0 alpha:1] CGColor];
    [picker_view.layer addSublayer:layer];
    
    UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 100, 30)];
    cancel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [cancel setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [cancel setTitle:[self.config localisedString:@"Cancel"] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [picker_view addSubview:cancel];
    
    UIButton *select = [[UIButton alloc] initWithFrame:CGRectMake(self.config.screenWidth-110, 5, 100, 30)];
    select.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [select setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [select setTitle:[self.config localisedString:@"Select"] forState:UIControlStateNormal];
    [select addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    [picker_view addSubview:select];
    
    state_picker = [[UIPickerView alloc] init];
    state_picker.delegate = self;
    state_picker.dataSource = self;
    
    country_picker = [[UIPickerView alloc] init];
    country_picker.delegate = self;
    country_picker.dataSource = self;
    
    
    states = [NSArray arrayWithObjects: [self.config localisedString:@"Non U.S. (Please type)"],@"Alabama", @"Alaska", @"Arizona", @"Arkansas", @"California", @"Colorado", @"Connecticut", @"Delaware", @"Florida", @"Georgia", @"Hawaii", @"Idaho", @"Illinois", @"Indiana", @"Iowa", @"Kansas", @"Kentucky", @"Louisiana", @"Maine", @"Maryland", @"Massachusetts", @"Michigan", @"Minnesota", @"Mississippi", @"Missouri", @"Montana", @"Nebraska", @"Nevada", @"New Hampshire", @"New Jersey", @"New Mexico", @"New York", @"North Carolina", @"North Dakota", @"Ohio", @"Oklahoma", @"Oregon", @"Pennsylvania", @"Rhode Island", @"South Carolina", @"South Dakota", @"Tennessee", @"Texas", @"Utah", @"Vermont", @"Virginia", @"Washington", @"West Virginia", @"Wisconsin", @"Wyoming", nil];
    
    
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(self.config.screenWidth/2-indicator.frame.size.width/2, self.config.screenHeight/2-indicator.frame.size.height/2, indicator.frame.size.width, indicator.frame.size.height);
    [self.view addSubview:indicator];
    
    cardnumber = [[UITextField alloc] init];
    cardnumber.keyboardType = UIKeyboardTypeNumberPad;
    expmonth = [[UITextField alloc] init];
    expmonth.keyboardType = UIKeyboardTypeNumberPad;
    expmonth.placeholder = @"MM";
    expyear = [[UITextField alloc] init];
    expyear.placeholder = @"YYYY";
    expyear.keyboardType = UIKeyboardTypeNumberPad;
    cvc = [[UITextField alloc] init];
    cvc.keyboardType = UIKeyboardTypeNumberPad;
    fn = [[UITextField alloc] init];
    ln = [[UITextField alloc] init];
    addr = [[UITextField alloc] init];
    city = [[UITextField alloc] init];
    state = [[UITextField alloc] init];
    zip = [[UITextField alloc] init];
    country = [[UITextField alloc] init];
    isdefault = [[UISwitch alloc] init];
    [isdefault addTarget:self action:@selector(default_switch:) forControlEvents:UIControlEventValueChanged];
    if (self.usermethod.is_default){
        [isdefault setOn:YES];
    } else [isdefault setOn:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) return 4;
    else if (section == 1) return 6;
    else return 1;
    
    return 0;
    
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) return [self.config localisedString:@"Credit Card"];
    if (section == 1) return [self.config localisedString:@"Billing Info"];
    
    return @"";
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    
    header.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];;
    CGRect headerFrame = header.frame;
    header.textLabel.frame = headerFrame;
    
}

/*-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
 if (section == 2){
 UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.config.screenWidth, 200)];
 return v;
 
 } else if (section == 1) {
 return nil;
 }
 return nil;
 }*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Config *cf = (Config *)self.config;
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
    [cell setPreservesSuperviewLayoutMargins:NO];
    //cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];
    UILabel *ctitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 2, 150, 30)];
    ctitle.textColor = [UIColor colorWithRed:41/255.0 green:39/255.0 blue:39/255.0 alpha:1];
    ctitle.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    [cell addSubview:ctitle];
    
    UILabel *ctitle2 = [[UILabel alloc] initWithFrame:CGRectMake(self.config.screenWidth/2+15, 2, 150, 30)];
    ctitle2.textColor = [UIColor colorWithRed:41/255.0 green:39/255.0 blue:39/255.0 alpha:1];
    ctitle2.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    [cell addSubview:ctitle2];
    
    CALayer *mid = [CALayer layer];
    mid.frame = CGRectMake(self.config.screenWidth/2, 0, 0.5, table.rowHeight);
    mid.backgroundColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
    
    if (indexPath.section == 0){
        if (indexPath.row == 0){
            ctitle.text = [self.config localisedString:@"Card Number"];
            cardnumber.frame = CGRectMake(15, 30, self.config.screenWidth-30, table.rowHeight-30);
            cardnumber.delegate = self;
            if (self.usermethod != nil){
                cardnumber.placeholder = [NSString stringWithFormat:@"%@: **** - %@", [self.config localisedString:@"Saved Card"], self.usermethod.last4];
            }
            [cell addSubview:cardnumber];
            
        }
        
        if (indexPath.row == 1){
            ctitle.text = [self.config localisedString:@"Expire Month"];
            expmonth.frame = CGRectMake(15, 30, self.config.screenWidth/2-30, table.rowHeight-30);
            expmonth.delegate = self;
            if (expmonth.text.length == 0) expmonth.text = self.usermethod.expmonth;
            [cell addSubview:expmonth];
            
            ctitle2.text = [self.config localisedString:@"Expire Year"];
            expyear.frame = CGRectMake(self.config.screenWidth/2+15, 30, self.config.screenWidth/2-30, table.rowHeight-30);
            expyear.delegate = self;
            if (expyear.text.length == 0) expyear.text = self.usermethod.expyear;
            [cell addSubview:expyear];
            
            [cell.layer addSublayer:mid];
            
        }
        
        if (indexPath.row == 2){
            ctitle.text = [self.config localisedString:@"CVC"];
            cvc.frame = CGRectMake(15, 30, self.config.screenWidth-30, table.rowHeight-30);
            cvc.delegate = self;
            [cell addSubview:cvc];
            
        }
        
        if (indexPath.row == 3){
            cell.textLabel.text = [self.config localisedString:@"Set Default"];
            cell.textLabel.font =[UIFont fontWithName:@"HelveticaNeue-Light" size:17];
            isdefault.frame = CGRectMake(self.config.screenWidth-isdefault.frame.size.width-20, table.rowHeight/2-isdefault.frame.size.height/2, isdefault.frame.size.width, isdefault.frame.size.height);
            
            [cell addSubview: isdefault];
            
        }
        
    } else if (indexPath.section == 1){
        
        if (indexPath.row == 0){
            ctitle.text = [self.config localisedString:@"First Name"];
            fn.frame = CGRectMake(15, 30, self.config.screenWidth/2-30, table.rowHeight-30);
            fn.delegate = self;
            if (fn.text.length == 0) fn.text = self.usermethod.billingfirstname;
            [cell addSubview:fn];
            
            ctitle2.text = [self.config localisedString:@"Last Name"];
            ln.frame = CGRectMake(self.config.screenWidth/2+15, 30, self.config.screenWidth/2-30, table.rowHeight-30);
            ln.delegate = self;
            if (ln.text.length == 0) ln.text = self.usermethod.billinglastname;
            [cell addSubview:ln];
            
            [cell.layer addSublayer:mid];
        }
        
        if (indexPath.row == 1){
            ctitle.text = [self.config localisedString:@"Address"];
            addr.frame = CGRectMake(15, 30, self.config.screenWidth-30, table.rowHeight-30);
            addr.delegate = self;
            if (addr.text.length == 0) addr.text = self.usermethod.billingaddress;
            [cell addSubview:addr];
            
            
        }
        
        if (indexPath.row == 2){
            ctitle.text = [self.config localisedString:@"City"];
            city.frame = CGRectMake(15, 30, self.config.screenWidth-30, table.rowHeight-30);
            city.delegate = self;
            if (city.text.length == 0) city.text = self.usermethod.billingcity;
            [cell addSubview:city];
            
        }
        if (indexPath.row == 3){
            ctitle.text = [self.config localisedString:@"State"];
            state.frame = CGRectMake(15, 30, self.config.screenWidth-30, table.rowHeight-30);
            state.delegate = self;
            state.inputAccessoryView = picker_view;
            state.inputView = state_picker;
            if (state.text.length == 0) state.text = self.usermethod.billingstate;
            [cell addSubview:state];
            
        }
        if (indexPath.row == 4){
            ctitle.text = [self.config localisedString:@"Zip"];
            zip.frame = CGRectMake(15, 30, self.config.screenWidth-30, table.rowHeight-30);
            zip.delegate = self;
            if (zip.text.length == 0) zip.text = self.usermethod.billingzip;
            [cell addSubview:zip];
            
        }
        if (indexPath.row == 5){
            ctitle.text = [self.config localisedString:@"Country"];
            country.frame = CGRectMake(15, 30, self.config.screenWidth-30, table.rowHeight-30);
            country.delegate = self;
            country.inputView = country_picker;
            country.inputAccessoryView = picker_view;
            if (self.usermethod.billingcountry != nil && country.text.length == 0){
                country.text = [self.config.codetocountry objectForKey:self.usermethod.billingcountry];
            }
            [cell addSubview:country];
            
        }
        
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[self.config localisedString:@"Delete"]];
        cell.textLabel.font =[UIFont fontWithName:@"HelveticaNeue-Light" size:17];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    if (indexPath.section == 2 && indexPath.row == 0 && tableloaded == 0){
        tableloaded = 1;
        table.contentSize = CGSizeMake(table.contentSize.width, table.contentSize.height+200);
        
    }
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2 && indexPath.row == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Delete Payment Method"] message:nil delegate:self cancelButtonTitle:[self.config localisedString:@"Cancel"] otherButtonTitles:[self.config localisedString:@"Delete"], nil];
        alert.delegate = self;
        [alert show];
        
        
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1){
        if ((self.config.user_id == nil || self.config.user_id == 0 || self.config.user_id.length == 0) && self.config.guest_checkout){
            if (self.config.selected_payment == self.usermethod)
                self.config.selected_payment = nil;
            for (UserPaymentMethod *up in self.config.user_payment_methods){
                if ([up.payment_method_id isEqualToString:self.usermethod.payment_method_id]){
                    [self.config.user_payment_methods removeObject:up];
                }
            }
            [self.navigationController popToViewController:self.parent animated:YES];
            return;
        }
        
        [NSThread detachNewThreadSelector:@selector(startAnimating) toTarget:self withObject:nil];
        NSString *myRequestString = [NSString stringWithFormat:@"app_uuid=%@&user_id=%@&access_token=%@&method_id=%@&payment_gateway=%@&customer_id=%@&payment_token=%@&last4=%@&exp_month=%@&exp_year=%@&payment_method=%@&billing_firstname=%@&billing_lastname=%@&billing_address=%@&billing_city=%@&billing_state=%@&billing_zip=%@&billing_country=%@&is_default=%d&is_delete=1&card_changed=0", self.config.APP_UUID, self.config.user_id, self.config.token, self.usermethod.payment_method_id, self.usermethod.payment_gateway, self.usermethod.customer_id, self.usermethod.payment_token, self.usermethod.last4, self.usermethod.expmonth, self.usermethod.expyear, self.usermethod.payment_method, self.usermethod.billingfirstname, self.usermethod.billinglastname, self.usermethod.billingaddress, self.usermethod.billingcity, self.usermethod.billingstate, self.usermethod.billingzip, self.usermethod.billingcountry,self.usermethod.is_default];
        
        
        
        // Create Data from request
        NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", self.config.API_ROOT, self.config.API_ADD_EDIT_USER_PAYMENTMETHOD]]];
        
        
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
                
                if (self.usermethod != nil && self.usermethod.payment_method_id != nil && [self.usermethod.payment_method_id isEqualToString:self.config.selected_payment.payment_method_id]){
                    self.config.selected_payment = nil;
                }
                
                [self.navigationController popToViewController:self.parent animated:YES];
                
            } else {
                //There was an error
                NSLog(@"%@", err.description);
            }
            [self.navigationController popToViewController:self.parent animated:YES];
            
            [indicator stopAnimating];
            
        };
        [connection start];
    }
}




-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (changed == CARD_NO_CHANGE){
        changed = CARD_INFO_UNCHANGED;
    }
    if (textField == cardnumber || textField == expmonth || textField == expyear || textField == cvc){
        changed = CARD_INFO_CHANGED;
    }
    return YES;
}
-(IBAction)default_switch:(id)sender{
    if (changed == CARD_NO_CHANGE){
        changed = CARD_INFO_UNCHANGED;
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(IBAction)cancel:(id)sender {
    [state resignFirstResponder];
    [country resignFirstResponder];
}

-(IBAction)done:(id)sender{
    if ([state isFirstResponder]){
        if ([state_picker selectedRowInComponent:0] > 0){
            NSString *s = [states objectAtIndex:[state_picker selectedRowInComponent:0]];
            state.text = s;
            [state resignFirstResponder];
        } else if ([state_picker selectedRowInComponent:0] == 0){
            [state resignFirstResponder];
            state.inputView = nil;
            state.inputAccessoryView = nil;
            [state becomeFirstResponder];
        }
    } else if ([country isFirstResponder]){
        NSString *s = [self.config.countries objectAtIndex:[country_picker selectedRowInComponent:0]];
        country.text = s;
        [country resignFirstResponder];
    }
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    /* if (pickerView == picker){
     if (row == 0) return;
     else if (row > 1){
     NSString *s = [states objectAtIndex:row];
     state.text = s;
     [state resignFirstResponder];
     } else if (row == 1){
     [state resignFirstResponder];
     state.inputView = nil;
     [state becomeFirstResponder];
     }
     }
     if (pickerView == countrypicker){
     if (row == 0) return;
     NSString *s = [self.config.countries objectAtIndex:row];
     country.text = s;
     [country resignFirstResponder];
     }*/
}



- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == state_picker) return [states objectAtIndex:row];
    else return [self.config.countries objectAtIndex:row];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == state_picker) return states.count;
    else return self.config.countries.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)save{
    BOOL isnew = NO;
    if (self.usermethod == nil) isnew = YES;
    else if (![self.usermethod.payment_gateway isEqualToString:self.appmethod.payment_gateway] && ![self.usermethod.payment_method isEqualToString:self.appmethod.payment_method]) isnew = YES;
    
    self.usermethod.payment_gateway = self.appmethod.payment_gateway;
    self.usermethod.payment_method = self.appmethod.payment_method;
    
    [NSThread detachNewThreadSelector:@selector(startAnimating) toTarget:self withObject:nil];
    
    NSString *cutomserid = @"";
    
    if (isnew) {
        for (UserPaymentMethod *p in self.allusermethods){
            if ([self.appmethod.payment_gateway isEqualToString:p.payment_gateway] && [self.appmethod.payment_method isEqualToString:p.payment_method]){
                if (p.customer_id != nil){
                    cutomserid = p.customer_id;
                    break;
                }
                
            }
        }
    } else {
        cutomserid = self.usermethod.customer_id;
    }
    
    if ([self.appmethod.payment_gateway isEqualToString:@"AuthorizeNet"]){
        if ([self.appmethod.api_version isEqualToString:@"CIM"]){
            if (isnew){
                [self save_authorizenet:cutomserid];
                return;
            } else {
                if (changed == CARD_NO_CHANGE) {
                    [self.navigationController popViewControllerAnimated:YES];
                    return;
                } else if (changed == CARD_INFO_UNCHANGED){
                    self.usermethod.billingfirstname = fn.text;
                    self.usermethod.billinglastname = ln.text;
                    self.usermethod.billingaddress = addr.text;
                    self.usermethod.billingcity = city.text;
                    self.usermethod.billingstate = state.text;
                    self.usermethod.billingzip = zip.text;
                    self.usermethod.billingcountry = [self.config.countrytocode objectForKey:country.text];
                    if (isdefault.isOn) self.usermethod.is_default = YES;
                    else self.usermethod.is_default = NO;
                    
                    [self save_user_method_no_card];
                    return;
                } else {
                    [self edit_authorizenet];
                    return;
                }
            }
        } else {
            self.usermethod = [[UserPaymentMethod alloc] init];
            self.usermethod.appmethod = self.appmethod;
            self.usermethod.payment_gateway = self.appmethod.payment_gateway;
            self.usermethod.payment_method = self.appmethod.payment_method;
            self.usermethod.last4 = [cardnumber.text substringFromIndex:cardnumber.text.length-4];
            self.usermethod.cc = cardnumber.text;
            self.usermethod.cvc = cvc.text;
            OLCreditCardType cardType = [Luhn typeFromString:cardnumber.text];
            if (cardType == OLCreditCardTypeAmex) self.usermethod.cardtype = @"amex";
            else if (cardType == OLCreditCardTypeDinersClub) self.usermethod.cardtype = @"dinersclub";
            else if (cardType == OLCreditCardTypeDiscover) self.usermethod.cardtype = @"discover";
            else if (cardType == OLCreditCardTypeMastercard) self.usermethod.cardtype = @"mastercard";
            else if (cardType == OLCreditCardTypeVisa) self.usermethod.cardtype = @"visa";
            self.usermethod.expyear = expyear.text;
            self.usermethod.expmonth = expmonth.text;
            self.usermethod.billingfirstname = fn.text;
            self.usermethod.billinglastname = ln.text;
            self.usermethod.billingaddress = addr.text;
            self.usermethod.billingcity = city.text;
            self.usermethod.billingstate = state.text;
            self.usermethod.billingzip = zip.text;
            self.usermethod.billingcountry = [self.config.countrytocode objectForKey:country.text];
            if (isdefault.isOn) self.usermethod.is_default = YES;
            else self.usermethod.is_default = NO;
            self.usermethod.handle_payment = YES;
            self.config.selected_payment = self.usermethod;
            [self.navigationController popToViewController:self.parent animated:YES];
        }
    }
    if ([self.appmethod.payment_gateway isEqualToString:@"Conekta"]){
        if (isnew){
            [self save_conekta:cutomserid];
            return;
        } else {
            if (changed == CARD_NO_CHANGE) {
                [self.navigationController popViewControllerAnimated:YES];
                return;
            } else if (changed == CARD_INFO_UNCHANGED){
                self.usermethod.billingfirstname = fn.text;
                self.usermethod.billinglastname = ln.text;
                self.usermethod.billingaddress = addr.text;
                self.usermethod.billingcity = city.text;
                self.usermethod.billingstate = state.text;
                self.usermethod.billingzip = zip.text;
                self.usermethod.billingcountry = [self.config.countrytocode objectForKey:country.text];
                if (isdefault.isOn) self.usermethod.is_default = YES;
                else self.usermethod.is_default = NO;
                
                [self save_user_method_no_card];
                return;
            } else {
                [self save_conekta:cutomserid];
                return;
            }
        }
    }
}

-(void)save_user_method{
    if ((self.config.user_id == nil || self.config.user_id == 0 || self.config.user_id.length == 0) && self.config.guest_checkout){
        if (self.config.selected_payment==nil)
            self.config.selected_payment = self.usermethod;
        self.usermethod.appmethod = self.appmethod;
        if (self.usermethod.payment_method_id == nil || self.usermethod.payment_method_id.length == 0){
            self.usermethod.payment_method_id = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
            [self.config.user_payment_methods addObject:self.usermethod];
        }
        [self.navigationController popToViewController:self.parent animated:YES];
        return;
    }
    
    int isdef = 0;
    self.usermethod.cc = cardnumber.text;
    if (self.usermethod.is_default) isdef = 1;
    NSString *myRequestString = [NSString stringWithFormat:@"app_uuid=%@&user_id=%@&access_token=%@&method_id=%@&payment_gateway=%@&customer_id=%@&payment_token=%@&last4=%@&exp_month=%@&exp_year=%@&payment_method=%@&card_type=%@&account_id=%@&billing_firstname=%@&billing_lastname=%@&billing_address=%@&billing_city=%@&billing_state=%@&billing_zip=%@&billing_country=%@&is_default=%d&is_delete=0&card_changed=1", self.config.APP_UUID, self.config.user_id, self.config.token, self.usermethod.payment_method_id, self.usermethod.payment_gateway, self.usermethod.customer_id, self.usermethod.payment_token, self.usermethod.last4, self.usermethod.expmonth, self.usermethod.expyear, self.usermethod.payment_method, self.usermethod.cardtype, self.usermethod.account_id, self.usermethod.billingfirstname, self.usermethod.billinglastname, self.usermethod.billingaddress, self.usermethod.billingcity, self.usermethod.billingstate, self.usermethod.billingzip, self.usermethod.billingcountry,isdef];
    
    
    
    // Create Data from request
    NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", self.config.API_ROOT, self.config.API_ADD_EDIT_USER_PAYMENTMETHOD]]];
    
    
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
            if (self.usermethod.payment_method_id == nil || self.usermethod.payment_method_id.length == 0) {
                self.usermethod.payment_method_id = [dic objectForKey:@"payment_method_id"];
            }
            
            if (self.config.user_payment_methods.count == 0) self.config.selected_payment = self.usermethod;
            
            [self.navigationController popToViewController:self.parent animated:YES];
            
        } else {
            //There was an error
            NSLog(@"%@", err.description);
        }
        
        [indicator stopAnimating];
        
    };
    [connection start];
}


-(void)save_user_method_no_card{
    
    
    if ((self.config.user_id == nil || self.config.user_id == 0 || self.config.user_id.length == 0) && self.config.guest_checkout){
        self.config.selected_payment = self.usermethod;
        [self.navigationController popToViewController:self.parent animated:YES];
        return;
    }
    
    int isdef = 0;
    if (self.usermethod.is_default) isdef = 1;
    NSString *myRequestString = [NSString stringWithFormat:@"app_uuid=%@&user_id=%@&access_token=%@&method_id=%@&payment_gateway=%@&customer_id=%@&payment_token=%@&last4=%@&exp_month=%@&exp_year=%@&payment_method=%@&card_type=%@&account_id=%@&billing_firstname=%@&billing_lastname=%@&billing_address=%@&billing_city=%@&billing_state=%@&billing_zip=%@&billing_country=%@&is_default=%d&is_delete=0&card_changed=0", self.config.APP_UUID, self.config.user_id, self.config.token, self.usermethod.payment_method_id, self.usermethod.payment_gateway, self.usermethod.customer_id, self.usermethod.payment_token, self.usermethod.last4, self.usermethod.expmonth, self.usermethod.expyear, self.usermethod.payment_method,self.usermethod.cardtype, self.usermethod.account_id, self.usermethod.billingfirstname, self.usermethod.billinglastname, self.usermethod.billingaddress, self.usermethod.billingcity, self.usermethod.billingstate, self.usermethod.billingzip, self.usermethod.billingcountry,isdef];
    
    
    
    // Create Data from request
    NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", self.config.API_ROOT, self.config.API_ADD_EDIT_USER_PAYMENTMETHOD]]];
    
    
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
            
            [self.navigationController popToViewController:self.parent animated:YES];
            
        } else {
            //There was an error
            NSLog(@"%@", err.description);
        }
        
        [indicator stopAnimating];
        
    };
    [connection start];
}

//**********Authorize Net

-(void)save_authorizenet:(NSString *)customerid{
    if (self.appmethod.islive == 0) {
        [AuthNet authNetWithEnvironment:ENV_TEST];
    } else {
        [AuthNet authNetWithEnvironment:ENV_LIVE];
    }
    AuthNet *an = [AuthNet getInstance];
    [an setDelegate:self];
    
    if (customerid.length == 0){
        NSString *appid = self.appmethod.api_userid;
        NSString *appkey = self.appmethod.api_token;
        if (self.appmethod.islive == 0){
            appid = self.appmethod.sandbox_api_userid;
            appkey = self.appmethod.sandbox_api_token;
        }
        
        CreateCustomerProfileRequest *c = [CreateCustomerProfileRequest createCustomerProfileRequest];
        c.anetApiRequest.merchantAuthentication.name = appid;
        c.anetApiRequest.merchantAuthentication.transactionKey = appkey;
        
        CustomerProfileBaseType* profile = [[CustomerProfileBaseType alloc] init];
        //profile.merchantCustomerId = @"test123";
        
        if ((self.config.user_id == nil || self.config.user_id.length == 0) && self.config.guest_checkout){
            profile.merchantCustomerId = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
        } else {
            profile.email = self.config.email;
            profile.desc = @"Twixxies User";
        }
        
        c.profile = profile;
        
        
        [an createCustomerProfileRequest:c];
    } else {
        if (self.usermethod == nil){
            self.usermethod = [[UserPaymentMethod alloc] init];
            self.usermethod.appmethod = self.appmethod;
            self.usermethod.customer_id =customerid;
        }
        [self save_authorize_payment];
    }
    
}

-(void)save_authorize_payment{
    AuthNet *an = [AuthNet getInstance];
    [an setDelegate:self];
    CreateCustomerPaymentProfileRequest *c = [CreateCustomerPaymentProfileRequest createCustomerPaymentProfileRequest];
    NSString *appid = self.appmethod.api_userid;
    NSString *appkey = self.appmethod.api_token;
    if (self.appmethod.islive == 0){
        appid = self.appmethod.sandbox_api_userid;
        appkey = self.appmethod.sandbox_api_token;
    }
    c.anetApiRequest.merchantAuthentication.name = appid;
    c.anetApiRequest.merchantAuthentication.transactionKey = appkey;
    c.customerProfileId = self.usermethod.customer_id;
    
    CreditCardType *cc = [[CreditCardType alloc] init];
    cc.cardNumber = cardnumber.text;
    cc.expirationDate = [NSString stringWithFormat:@"%4d-%2d", [expyear.text intValue], [expmonth.text intValue]];
    cc.cardCode = cvc.text;
    
    PaymentProfileType *profile = [[PaymentProfileType alloc] init];
    profile.creditCard = cc;
    c.paymentProfile = profile;
    
    /*PaymentType *pt = [[PaymentType alloc] init];
     pt.creditCard = cc;
     c.payment = pt;*/
    
    [an createCustomerPaymentProfileRequest:c];
    
    
    
}

-(void)createCustomerProfileSucceeded:(CreateCustomerProfileResponse *)response{
    self.usermethod = [[UserPaymentMethod alloc] init];
    self.usermethod.appmethod = self.appmethod;
    self.usermethod.customer_id = response.customerProfileId;
    [self save_authorize_payment];
}

-(void)createCustomerPaymentProfileSucceeded:(CreateCustomerPaymentProfileResponse *)response{
    self.usermethod.payment_token = response.customerPaymentProfileId;
    self.usermethod.payment_gateway = self.appmethod.payment_gateway;
    self.usermethod.payment_method = self.appmethod.payment_method;
    self.usermethod.last4 = [cardnumber.text substringFromIndex:cardnumber.text.length-4];
    OLCreditCardType cardType = [Luhn typeFromString:cardnumber.text];
    if (cardType == OLCreditCardTypeAmex) self.usermethod.cardtype = @"amex";
    else if (cardType == OLCreditCardTypeDinersClub) self.usermethod.cardtype = @"dinersclub";
    else if (cardType == OLCreditCardTypeDiscover) self.usermethod.cardtype = @"discover";
    else if (cardType == OLCreditCardTypeMastercard) self.usermethod.cardtype = @"mastercard";
    else if (cardType == OLCreditCardTypeVisa) self.usermethod.cardtype = @"visa";
    self.usermethod.expyear = expyear.text;
    self.usermethod.expmonth = expmonth.text;
    self.usermethod.billingfirstname = fn.text;
    self.usermethod.billinglastname = ln.text;
    self.usermethod.billingaddress = addr.text;
    self.usermethod.billingcity = city.text;
    self.usermethod.billingstate = state.text;
    self.usermethod.billingzip = zip.text;
    self.usermethod.billingcountry = [self.config.countrytocode objectForKey:country.text];
    if (isdefault.isOn) self.usermethod.is_default = YES;
    else self.usermethod.is_default = NO;
    
    [self save_user_method];
    
    
}

- (void) requestFailed:(AuthNetResponse *)response{
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Failed to save card"] message:@"" delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
    [alert show];
    [indicator stopAnimating];
    
}


-(void)edit_authorizenet{
    if (self.appmethod.islive == 0) {
        [AuthNet authNetWithEnvironment:ENV_TEST];
    } else {
        [AuthNet authNetWithEnvironment:ENV_LIVE];
    }
    
    [AuthNet authNetWithEnvironment:ENV_TEST];
    AuthNet *an = [AuthNet getInstance];
    [an setDelegate:self];
    
    UpdateCustomerPaymentProfileRequest *u = [UpdateCustomerPaymentProfileRequest updateCustomerPaymentProfileRequest];
    NSString *appid = self.appmethod.api_userid;
    NSString *appkey = self.appmethod.api_token;
    if (self.appmethod.islive == 0){
        appid = self.appmethod.sandbox_api_userid;
        appkey = self.appmethod.sandbox_api_token;
    }
    u.anetApiRequest.merchantAuthentication.name = appid;
    u.anetApiRequest.merchantAuthentication.transactionKey = appkey;
    u.customerProfileId = self.usermethod.customer_id;
    
    CreditCardType *cc = [[CreditCardType alloc] init];
    cc.cardNumber = cardnumber.text;
    cc.expirationDate = [NSString stringWithFormat:@"%4d-%2d", [expyear.text intValue], [expmonth.text intValue]];
    cc.cardCode = cvc.text;
    
    PaymentProfileType *profile = [[PaymentProfileType alloc] init];
    profile.creditCard = cc;
    profile.customerPaymentProfileId = self.usermethod.payment_token;
    
    u.paymentProfile = profile;
    
    [an updateCustomerPaymentProfileRequest:u];
    
}
-(void)updateCustomerPaymentProfileSucceeded:(UpdateCustomerPaymentProfileResponse *)response{
    //self.usermethod.payment_token = response.;
    //self.usermethod.payment_gateway = self.appmethod.payment_gateway;
    //self.usermethod.payment_method = self.appmethod.payment_method;
    OLCreditCardType cardType = [Luhn typeFromString:cardnumber.text];
    if (cardType == OLCreditCardTypeAmex) self.usermethod.cardtype = @"amex";
    else if (cardType == OLCreditCardTypeDinersClub) self.usermethod.cardtype = @"dinersclub";
    else if (cardType == OLCreditCardTypeDiscover) self.usermethod.cardtype = @"discover";
    else if (cardType == OLCreditCardTypeMastercard) self.usermethod.cardtype = @"mastercard";
    else if (cardType == OLCreditCardTypeVisa) self.usermethod.cardtype = @"visa";
    self.usermethod.last4 = [cardnumber.text substringFromIndex:cardnumber.text.length-4];
    self.usermethod.expyear = expyear.text;
    self.usermethod.expmonth = expmonth.text;
    self.usermethod.billingfirstname = fn.text;
    self.usermethod.billinglastname = ln.text;
    self.usermethod.billingaddress = addr.text;
    self.usermethod.billingcity = city.text;
    self.usermethod.billingstate = state.text;
    self.usermethod.billingzip = zip.text;
    self.usermethod.billingcountry = [self.config.countrytocode objectForKey:country.text];
    if (isdefault.isOn) self.usermethod.is_default = YES;
    else self.usermethod.is_default = NO;
    
    [self save_user_method];
}


//***conketa

-(void)save_conekta:(NSString *)customer_id{
    NSString *cardnum = self.config.card.number;
    if (cardnum == nil) cardnum = @"";
    
    NSString *billingname = [NSString stringWithFormat:@"%@ %@", fn.text, ln.text];
    
    NSString *key = @"";
    if (self.appmethod.islive == 1){
        key = self.appmethod.api_token;
    } else {
        key = self.appmethod.sandbox_api_token;
    }
    NSData *plain = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data64 = [plain base64EncodedDataWithOptions:0];
    
    NSString *key64 = [[NSString alloc] initWithData:data64 encoding:NSUTF8StringEncoding];
    
    
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:cardnumber.text, @"number", billingname, @"name", cvc.text, @"cvc", expmonth.text, @"exp_month", expyear.text, @"exp_year", nil];
    NSDictionary *card = [[NSDictionary alloc] initWithObjectsAndKeys:dic, @"card", nil];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:card
                                                       options:0
                                                         error:nil];
    
    
    
    
    
    // Create Data from request
    NSData *myRequestData = jsonData;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: @"https://api.conekta.io/tokens"]];
    
    
    // set Request Type
    [request setHTTPMethod: @"POST"];
    // Set content-type
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:[NSString stringWithFormat:@"Basic %@",key64] forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/vnd.conekta-v0.3.0+json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"{\"agent\":\"Conekta Conekta iOS SDK\"}" forHTTPHeaderField:@"Conekta-Client-User-Agent"];
    // Set Request Body
    [request setHTTPBody: myRequestData];
    // Now send a request and get Response
    // NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
    // Log Response
    // NSString *response = [[NSString alloc] initWithBytes:[returnData bytes] length:[returnData length] encoding:NSUTF8StringEncoding];
    // NSLog(@"%@",response);
    NSURLConnectionBlock *connection = [[NSURLConnectionBlock alloc] initWithRequest:request];
    connection.completion = ^(id obj, NSError *err) {
        
        if (!err) {
            //It's ok, do domething with the response data (obj)
            NSMutableData *data = (NSMutableData *)obj;
            
            NSString *myxml = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            NSLog(@"%@", myxml);
            
            NSDictionary *d = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSString *cardtoken = [d objectForKey:@"id"];
            
            if (cardtoken == nil){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"The card is invalid."] message:@"" delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
                [alert show];
                [indicator stopAnimating];
                return;
            }
            if (self.usermethod == nil) {
                self.usermethod = [[UserPaymentMethod alloc] init];
                self.usermethod.appmethod = self.appmethod;
            }
            self.usermethod.payment_token = cardtoken;
            self.usermethod.payment_gateway = self.appmethod.payment_gateway;
            self.usermethod.payment_method = self.appmethod.payment_method;
            self.usermethod.customer_id = customer_id;
            self.usermethod.last4 = [cardnumber.text substringFromIndex:cardnumber.text.length-4];
            self.usermethod.expyear = expyear.text;
            self.usermethod.expmonth = expmonth.text;
            self.usermethod.billingfirstname = fn.text;
            self.usermethod.billinglastname = ln.text;
            self.usermethod.billingaddress = addr.text;
            self.usermethod.billingcity = city.text;
            self.usermethod.billingstate = state.text;
            self.usermethod.billingzip = zip.text;
            self.usermethod.billingcountry = [self.config.countrytocode objectForKey:country.text];
            if (isdefault.isOn) self.usermethod.is_default = YES;
            else self.usermethod.is_default = NO;
            
            [self save_user_method];
            
            
            
        } else {
            //There was an error
            
        }
        
    };
    [connection start];
}

-(void)startAnimating{
    [indicator startAnimating];
}

@end





























@implementation CustomePaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 44)] ;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:17.3];
    
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor colorWithRed:0.302 green:0.302 blue:0.318 alpha:1]; // change this color
    self.navigationItem.titleView = label;
    label.text = [self.config localisedString:@"Payment Details"];
    //[label sizeToFit];
    [Design navigationbar_title:label config:self.config];
    
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
    
    
    UILabel *seg = [[UILabel alloc] init];
    seg.text = [self.config localisedString:@"Save"];
    seg.textAlignment = NSTextAlignmentRight;
    seg.frame = CGRectMake(80-120, 0, 120, 44);
    UITapGestureRecognizer *tapseg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(save)];
    [seg addGestureRecognizer:tapseg];
    seg.userInteractionEnabled = YES;
    [Design style:[[DOM alloc] initWithView:seg parent:nil] design:[[self.config.design objectForKey:@"design"] objectForKey:@"navigation_icon"] config:self.config];
    
    
    
    UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView:seg];
    //[seg release];
    
    self.navigationItem.rightBarButtonItem = segmentBarItem;
    
    textview = [[UITextView alloc] initWithFrame:CGRectMake(5, 0, self.config.screenWidth-10, 0)];
    textview.font =[UIFont fontWithName:@"HelveticaNeue-Light" size:17.3f];
    textview.textColor = [UIColor colorWithRed:41.0/255.0 green:39.0/255.0 blue:39.0/255.0 alpha:1];
    textview.editable = NO;
    textview.scrollEnabled = NO;
    textview.userInteractionEnabled = NO;
    textview.text= self.appmethod.desc;
    CGSize newSize = [textview sizeThatFits:CGSizeMake(textview.frame.size.width, MAXFLOAT)];
    textview.frame = CGRectMake(5, 0,self.config.screenWidth-10, newSize.height);
    
    
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.config.screenWidth, self.config.screenHeight-64) style:UITableViewStyleGrouped];
    
    
    table.delegate = self;
    table.dataSource = self;
    table.rowHeight = 80;
    table.separatorColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1];
    [self.view addSubview:table];
    
    
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(self.config.screenWidth/2-indicator.frame.size.width/2, self.config.screenHeight/2-indicator.frame.size.height/2, indicator.frame.size.width, indicator.frame.size.height);
    [self.view addSubview:indicator];
    
    
    isdefault = [[UISwitch alloc] init];
    [isdefault addTarget:self action:@selector(default_switch:) forControlEvents:UIControlEventValueChanged];
    if (self.usermethod.is_default) [isdefault setOn:YES];
    else [isdefault setOn:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) return [self.config localisedString:@"Payment Description"];
    if (section == 1) return [self.config localisedString:@"Settings"];
    else return @"";
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    
    header.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];;
    CGRect headerFrame = header.frame;
    header.textLabel.frame = headerFrame;
    
}

/*-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
 if (section == 2){
 UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.config.screenWidth, 200)];
 return v;
 
 } else if (section == 1) {
 return nil;
 }
 return nil;
 }*/
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0){
        if (textview.frame.size.height < 80) return 80;
        else return textview.frame.size.height;
    }
    
    return table.rowHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Config *cf = (Config *)self.config;
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
    [cell setPreservesSuperviewLayoutMargins:NO];
    //cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];
    UILabel *ctitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 2, 150, 30)];
    ctitle.textColor = [UIColor colorWithRed:41/255.0 green:39/255.0 blue:39/255.0 alpha:1];
    ctitle.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    [cell addSubview:ctitle];
    
    UILabel *ctitle2 = [[UILabel alloc] initWithFrame:CGRectMake(self.config.screenWidth/2+15, 2, 150, 30)];
    ctitle2.textColor = [UIColor colorWithRed:41/255.0 green:39/255.0 blue:39/255.0 alpha:1];
    ctitle2.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    [cell addSubview:ctitle2];
    
    CALayer *mid = [CALayer layer];
    mid.frame = CGRectMake(self.config.screenWidth/2, 0, 0.5, table.rowHeight);
    mid.backgroundColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
    
    if (indexPath.section == 0){
        [cell addSubview:textview];
    }
    
    else if (indexPath.section == 1){
        
        
        if (indexPath.row == 0){
            cell.textLabel.text = [self.config localisedString:@"Set Default"];
            cell.textLabel.font =[UIFont fontWithName:@"HelveticaNeue-Light" size:17];
            isdefault.frame = CGRectMake(self.config.screenWidth-isdefault.frame.size.width-20, table.rowHeight/2-isdefault.frame.size.height/2, isdefault.frame.size.width, isdefault.frame.size.height);
            if (self.usermethod.is_default){
                [isdefault setOn:YES];
            }
            [cell addSubview: isdefault];
            
        }
        
    }  else {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[self.config localisedString:@"Delete"]];
        cell.textLabel.font =[UIFont fontWithName:@"HelveticaNeue-Light" size:17];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2 && indexPath.row == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Delete Payment Method"] message:nil delegate:self cancelButtonTitle:[self.config localisedString:@"Cancel"] otherButtonTitles:[self.config localisedString:@"Delete"], nil];
        alert.delegate = self;
        [alert show];
        
        
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1){
        
        if ((self.config.user_id == nil || self.config.user_id == 0 || self.config.user_id.length == 0) && self.config.guest_checkout){
            if (self.config.selected_payment == self.usermethod)
                self.config.selected_payment = nil;
            for (UserPaymentMethod *up in self.config.user_payment_methods){
                if ([up.payment_method_id isEqualToString:self.usermethod.payment_method_id]){
                    [self.config.user_payment_methods removeObject:up];
                }
            }
            [self.navigationController popToViewController:self.parent animated:YES];
            return;
        }
        
        [NSThread detachNewThreadSelector:@selector(startAnimating) toTarget:self withObject:nil];
        NSString *myRequestString = [NSString stringWithFormat:@"app_uuid=%@&user_id=%@&access_token=%@&method_id=%@&payment_gateway=%@&customer_id=%@&payment_token=%@&last4=%@&exp_month=%@&exp_year=%@&payment_method=%@&card_type=%@&account_id=%@&billing_firstname=%@&billing_lastname=%@&billing_address=%@&billing_city=%@&billing_state=%@&billing_zip=%@&billing_country=%@&is_default=%d&is_delete=1&card_changed=0", self.config.APP_UUID, self.config.user_id, self.config.token, self.usermethod.payment_method_id, self.usermethod.payment_gateway, self.usermethod.customer_id, self.usermethod.payment_token, self.usermethod.last4, self.usermethod.expmonth, self.usermethod.expyear, self.usermethod.payment_method, self.usermethod.cardtype, self.usermethod.account_id, self.usermethod.billingfirstname, self.usermethod.billinglastname, self.usermethod.billingaddress, self.usermethod.billingcity, self.usermethod.billingstate, self.usermethod.billingzip, self.usermethod.billingcountry,self.usermethod.is_default];
        
        
        
        // Create Data from request
        NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", self.config.API_ROOT, self.config.API_ADD_EDIT_USER_PAYMENTMETHOD]]];
        
        
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
                
                if (self.usermethod != nil && self.usermethod.payment_method_id != nil && [self.usermethod.payment_method_id isEqualToString:self.config.selected_payment.payment_method_id]){
                    self.config.selected_payment = nil;
                }
                
                [self.navigationController popToViewController:self.parent animated:YES];
                
            } else {
                //There was an error
                NSLog(@"%@", err.description);
            }
            [self.navigationController popToViewController:self.parent animated:YES];
            
            [indicator stopAnimating];
            
        };
        [connection start];
    }
}




-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}
-(IBAction)default_switch:(id)sender{
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)save{
    BOOL isnew = NO;
    if (self.usermethod == nil) isnew = YES;
    else if (![self.usermethod.payment_gateway isEqualToString:self.appmethod.payment_gateway] && ![self.usermethod.payment_method isEqualToString:self.appmethod.payment_method]) isnew = YES;
    
    
    
    [NSThread detachNewThreadSelector:@selector(startAnimating) toTarget:self withObject:nil];
    
    if (self.usermethod == nil) {
        self.usermethod = [[UserPaymentMethod alloc] init];
        self.usermethod.appmethod = self.appmethod;
    }
    self.usermethod.payment_gateway = self.appmethod.payment_gateway;
    self.usermethod.payment_method = self.appmethod.payment_method;
    self.usermethod.is_default = NO;
    if (isdefault.isOn) self.usermethod.is_default = YES;
    
    [self save_user_method_no_card];
    
    
}


-(void)save_user_method_no_card{
    if ((self.config.user_id == nil || self.config.user_id == 0 || self.config.user_id.length == 0) && self.config.guest_checkout){
        if (self.config.selected_payment == nil)
            self.config.selected_payment = self.usermethod;
        if (self.usermethod.payment_method_id == nil || self.usermethod.payment_method_id.length == 0){
            self.usermethod.payment_method_id = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
            [self.config.user_payment_methods addObject:self.usermethod];
        }
        [self.navigationController popToViewController:self.parent animated:YES];
        return;
    }
    
    int isdef = 0;
    if (self.usermethod.is_default) isdef = 1;
    NSString *myRequestString = [NSString stringWithFormat:@"app_uuid=%@&user_id=%@&access_token=%@&method_id=%@&payment_gateway=%@&customer_id=%@&payment_token=%@&last4=%@&exp_month=%@&exp_year=%@&payment_method=%@&card_type=%@&account_id=%@&billing_firstname=%@&billing_lastname=%@&billing_address=%@&billing_city=%@&billing_state=%@&billing_zip=%@&billing_country=%@&is_default=%d&is_delete=0&card_changed=0", self.config.APP_UUID, self.config.user_id, self.config.token, self.usermethod.payment_method_id, self.usermethod.payment_gateway, self.usermethod.customer_id, self.usermethod.payment_token, self.usermethod.last4, self.usermethod.expmonth, self.usermethod.expyear, self.usermethod.payment_method,self.usermethod.cardtype, self.usermethod.account_id, self.usermethod.billingfirstname, self.usermethod.billinglastname, self.usermethod.billingaddress, self.usermethod.billingcity, self.usermethod.billingstate, self.usermethod.billingzip, self.usermethod.billingcountry,isdef];
    
    
    
    // Create Data from request
    NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", self.config.API_ROOT, self.config.API_ADD_EDIT_USER_PAYMENTMETHOD]]];
    
    
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
            
            [self.navigationController popToViewController:self.parent animated:YES];
            
        } else {
            //There was an error
            NSLog(@"%@", err.description);
        }
        
        [indicator stopAnimating];
        
    };
    [connection start];
}



-(void)startAnimating{
    [indicator startAnimating];
}

@end














@implementation AccountPaymentViewController
const int PAYMENT_ACCOUNT_NO_CHANGE = 0;
const int PAYMENT_ACCOUNT_CHANGED = 1;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 44)] ;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:17.3];
    
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor colorWithRed:0.302 green:0.302 blue:0.318 alpha:1]; // change this color
    self.navigationItem.titleView = label;
    label.text = [self.config localisedString:@"Payment Details"];
    //[label sizeToFit];
    [Design navigationbar_title:label config:self.config];
    
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
    
    
    UILabel *seg = [[UILabel alloc] init];
    seg.text = [self.config localisedString:@"Save"];
    seg.textAlignment = NSTextAlignmentRight;
    seg.frame = CGRectMake(80-120, 0, 120, 44);
    UITapGestureRecognizer *tapseg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(save)];
    [seg addGestureRecognizer:tapseg];
    seg.userInteractionEnabled = YES;
    [Design style:[[DOM alloc] initWithView:seg parent:nil] design:[[self.config.design objectForKey:@"design"] objectForKey:@"navigation_icon"] config:self.config];
    
    
    
    UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView:seg];
    //[seg release];
    
    self.navigationItem.rightBarButtonItem = segmentBarItem;
    
    textview = [[UITextView alloc] initWithFrame:CGRectMake(5, 0, self.config.screenWidth-10, 0)];
    textview.font =[UIFont fontWithName:@"HelveticaNeue-Light" size:17.3f];
    textview.textColor = [UIColor colorWithRed:41.0/255.0 green:39.0/255.0 blue:39.0/255.0 alpha:1];
    textview.editable = NO;
    textview.scrollEnabled = NO;
    textview.userInteractionEnabled = NO;
    textview.text= self.appmethod.desc;
    CGSize newSize = [textview sizeThatFits:CGSizeMake(textview.frame.size.width, MAXFLOAT)];
    textview.frame = CGRectMake(5, 0,self.config.screenWidth-10, newSize.height);
    
    
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.config.screenWidth, self.config.screenHeight-64) style:UITableViewStyleGrouped];
    
    
    table.delegate = self;
    table.dataSource = self;
    table.rowHeight = 80;
    table.separatorColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1];
    [self.view addSubview:table];
    
    
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(self.config.screenWidth/2-indicator.frame.size.width/2, self.config.screenHeight/2-indicator.frame.size.height/2, indicator.frame.size.width, indicator.frame.size.height);
    [self.view addSubview:indicator];
    
    
    isdefault = [[UISwitch alloc] init];
    [isdefault addTarget:self action:@selector(default_switch:) forControlEvents:UIControlEventValueChanged];
    if (self.usermethod.is_default) [isdefault setOn:YES];
    else [isdefault setOn:NO];
    
    is_changed = PAYMENT_ACCOUNT_NO_CHANGE;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) return [self.config localisedString:@"Account"];
    if (section == 1) return [self.config localisedString:@"Settings"];
    else return @"";
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    
    header.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];;
    CGRect headerFrame = header.frame;
    header.textLabel.frame = headerFrame;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0){
        if (textview.frame.size.height < 80) return 80;
        else return textview.frame.size.height;
    }
    
    return table.rowHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Config *cf = (Config *)self.config;
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
    [cell setPreservesSuperviewLayoutMargins:NO];
    //cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];
    UILabel *ctitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 2, 150, 30)];
    ctitle.textColor = [UIColor colorWithRed:41/255.0 green:39/255.0 blue:39/255.0 alpha:1];
    ctitle.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    [cell addSubview:ctitle];
    
    UILabel *ctitle2 = [[UILabel alloc] initWithFrame:CGRectMake(self.config.screenWidth/2+15, 2, 150, 30)];
    ctitle2.textColor = [UIColor colorWithRed:41/255.0 green:39/255.0 blue:39/255.0 alpha:1];
    ctitle2.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    [cell addSubview:ctitle2];
    
    CALayer *mid = [CALayer layer];
    mid.frame = CGRectMake(self.config.screenWidth/2, 0, 0.5, table.rowHeight);
    mid.backgroundColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
    
    if (indexPath.section == 0){
        if (self.usermethod.account_id == nil || self.usermethod.account_id.length == 0){
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [self.config localisedString:@"Paypal"], [self.config localisedString:@"Login"]];
            
        } else {
            cell.textLabel.text = self.usermethod.account_id;
        }
        cell.textLabel.font =[UIFont fontWithName:@"HelveticaNeue-Light" size:17];
        if (self.usermethod == nil || self.usermethod.payment_token == nil || self.usermethod.payment_token.length == 0)
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        else cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    else if (indexPath.section == 1){
        
        
        if (indexPath.row == 0){
            cell.textLabel.text = [self.config localisedString:@"Set Default"];
            cell.textLabel.font =[UIFont fontWithName:@"HelveticaNeue-Light" size:17];
            isdefault.frame = CGRectMake(self.config.screenWidth-isdefault.frame.size.width-20, table.rowHeight/2-isdefault.frame.size.height/2, isdefault.frame.size.width, isdefault.frame.size.height);
            if (self.usermethod.is_default){
                [isdefault setOn:YES];
            }
            [cell addSubview: isdefault];
            
        }
        
    }  else {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[self.config localisedString:@"Delete"]];
        cell.textLabel.font =[UIFont fontWithName:@"HelveticaNeue-Light" size:17];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0){
        if ([self.appmethod.payment_gateway isEqualToString:@"Paypal"] && [self.appmethod.payment_method isEqualToString:@"paypal"]){
            
            [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction :self.appmethod.api_userid,
                                                                   PayPalEnvironmentSandbox : self.appmethod.sandbox_api_userid}];
            if (self.appmethod.islive == 0) {
                [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentSandbox];
            } else {
                [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentProduction];
            }
            
            
            PayPalConfiguration *_payPalConfiguration = [[PayPalConfiguration alloc] init];
            
            // See PayPalConfiguration.h for details and default values.
            
            // Minimally, you will need to set three merchant information properties.
            // These should be the same values that you provided to PayPal when you registered your app.
            _payPalConfiguration.merchantName = @"Ultramagnetic Omega Supreme";
            _payPalConfiguration.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.omega.supreme.example/privacy"];
            _payPalConfiguration.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.omega.supreme.example/user_agreement"];
            
            
            
            
            // Update payPalConfig re accepting credit cards.
            //self.payPalConfig.acceptCreditCards = YES;
            
            PayPalFuturePaymentViewController *paymentViewController = [[PayPalFuturePaymentViewController alloc] initWithConfiguration:_payPalConfiguration delegate:self];
            
            
            [self presentViewController:paymentViewController animated:YES completion:nil];
        }
    }
    if (indexPath.section == 2 && indexPath.row == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Delete Payment Method"] message:nil delegate:self cancelButtonTitle:[self.config localisedString:@"Cancel"] otherButtonTitles:[self.config localisedString:@"Delete"], nil];
        alert.delegate = self;
        [alert show];
        
        
    }
}




- (void)payPalFuturePaymentDidCancel:(PayPalFuturePaymentViewController *)futurePaymentViewController {
    // User cancelled login. Dismiss the PayPalLoginViewController, breathe deeply.
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalFuturePaymentViewController:(PayPalFuturePaymentViewController *)futurePaymentViewController
                didAuthorizeFuturePayment:(NSDictionary *)futurePaymentAuthorization {
    // The user has successfully logged into PayPal, and has consented to future payments.
    
    // Your code must now send the authorization response to your server.
    
    is_changed = PAYMENT_ACCOUNT_CHANGED;
    
    
    NSString *code = [[futurePaymentAuthorization objectForKey:@"response"] objectForKey:@"code"];
    
    
    //obtain refresh token
    
    NSString *myRequestString = [NSString stringWithFormat:@"grant_type=authorization_code&response_type=token&redirect_uri=urn:ietf:wg:oauth:2.0:oob&code=%@", code];
    
    NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    
    // Create Data from request
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"https://api.paypal.com/v1/oauth2/token"]]];
    if (self.appmethod.islive == 0){
        request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"https://api.sandbox.paypal.com/v1/oauth2/token"]]];
    }
    
    
    
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", self.appmethod.api_userid, self.appmethod.api_secret];
    if (self.appmethod.islive == 0){
        authStr = [NSString stringWithFormat:@"%@:%@", self.appmethod.sandbox_api_userid, self.appmethod.sandbox_api_secret];
    }
    
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:0]];
    NSLog(authValue);
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    
    // set Request Type
    [request setHTTPMethod: @"POST"];
    // Set content-type
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
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
            
            
            if (self.usermethod == nil) {
                self.usermethod = [[UserPaymentMethod alloc] init];
                self.usermethod.appmethod = self.appmethod;
            }
            self.usermethod.payment_gateway = self.appmethod.payment_gateway;
            self.usermethod.payment_method = self.appmethod.payment_method;
            self.usermethod.payment_token = [dic objectForKey:@"refresh_token"];
            self.usermethod.is_default = NO;
            if (isdefault.isOn) self.usermethod.is_default = YES;
            
            
            [table reloadData];
            
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
            
        } else {
            //There was an error
            NSLog(@"%@", err.description);
        }
        
        [indicator stopAnimating];
        
    };
    [connection start];
    
    
    
    
    
}




-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1){
        
        if ((self.config.user_id == nil || self.config.user_id == 0 || self.config.user_id.length == 0) && self.config.guest_checkout){
            if (self.config.selected_payment == self.usermethod)
                self.config.selected_payment = nil;
            for (UserPaymentMethod *up in self.config.user_payment_methods){
                if ([up.payment_method_id isEqualToString:self.usermethod.payment_method_id]){
                    [self.config.user_payment_methods removeObject:up];
                }
            }
            [self.navigationController popToViewController:self.parent animated:YES];
            return;
        }
        
        [NSThread detachNewThreadSelector:@selector(startAnimating) toTarget:self withObject:nil];
        NSString *myRequestString = [NSString stringWithFormat:@"app_uuid=%@&user_id=%@&access_token=%@&method_id=%@&payment_gateway=%@&customer_id=%@&payment_token=%@&last4=%@&exp_month=%@&exp_year=%@&payment_method=%@&card_type=%@&account_id=%@&billing_firstname=%@&billing_lastname=%@&billing_address=%@&billing_city=%@&billing_state=%@&billing_zip=%@&billing_country=%@&is_default=%d&is_delete=1&card_changed=0", self.config.APP_UUID, self.config.user_id, self.config.token, self.usermethod.payment_method_id, self.usermethod.payment_gateway, self.usermethod.customer_id, self.usermethod.payment_token, self.usermethod.last4, self.usermethod.expmonth, self.usermethod.expyear, self.usermethod.payment_method, self.usermethod.cardtype, self.usermethod.account_id, self.usermethod.billingfirstname, self.usermethod.billinglastname, self.usermethod.billingaddress, self.usermethod.billingcity, self.usermethod.billingstate, self.usermethod.billingzip, self.usermethod.billingcountry,self.usermethod.is_default];
        
        
        
        // Create Data from request
        NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", self.config.API_ROOT, self.config.API_ADD_EDIT_USER_PAYMENTMETHOD]]];
        
        
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
                
                if (self.usermethod != nil && self.usermethod.payment_method_id != nil && [self.usermethod.payment_method_id isEqualToString:self.config.selected_payment.payment_method_id]){
                    self.config.selected_payment = nil;
                }
                
                [self.navigationController popToViewController:self.parent animated:YES];
                
            } else {
                //There was an error
                NSLog(@"%@", err.description);
            }
            [self.navigationController popToViewController:self.parent animated:YES];
            
            [indicator stopAnimating];
            
        };
        [connection start];
    }
}




-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}
-(IBAction)default_switch:(id)sender{
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)save{
    
    if (self.usermethod == nil) {
        return;
    }
    self.usermethod.payment_gateway = self.appmethod.payment_gateway;
    self.usermethod.payment_method = self.appmethod.payment_method;
    self.usermethod.is_default = NO;
    if (isdefault.isOn) self.usermethod.is_default = YES;
    
    
    if (is_changed == PAYMENT_ACCOUNT_NO_CHANGE){
        [self save_user_method_no_card];
    } else {
        [self save_user_method];
    }
    
    
}

-(void)save_user_method{
    if ((self.config.user_id == nil || self.config.user_id == 0 || self.config.user_id.length == 0) && self.config.guest_checkout){
        if (self.config.selected_payment == nil)
            self.config.selected_payment = self.usermethod;
        if (self.usermethod.payment_method_id == nil || self.usermethod.payment_method_id.length == 0){
            self.usermethod.payment_method_id = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
            [self.config.user_payment_methods addObject:self.usermethod];
        }
        [self.navigationController popToViewController:self.parent animated:YES];
        return;
    }
    
    int isdef = 0;
    if (self.usermethod.is_default) isdef = 1;
    NSString *myRequestString = [NSString stringWithFormat:@"app_uuid=%@&user_id=%@&access_token=%@&method_id=%@&payment_gateway=%@&customer_id=%@&payment_token=%@&last4=%@&exp_month=%@&exp_year=%@&payment_method=%@&card_type=%@&account_id=%@&billing_firstname=%@&billing_lastname=%@&billing_address=%@&billing_city=%@&billing_state=%@&billing_zip=%@&billing_country=%@&is_default=%d&is_delete=0&card_changed=1", self.config.APP_UUID, self.config.user_id, self.config.token, self.usermethod.payment_method_id, self.usermethod.payment_gateway, self.usermethod.customer_id, self.usermethod.payment_token, self.usermethod.last4, self.usermethod.expmonth, self.usermethod.expyear, self.usermethod.payment_method,self.usermethod.cardtype, self.usermethod.account_id, self.usermethod.billingfirstname, self.usermethod.billinglastname, self.usermethod.billingaddress, self.usermethod.billingcity, self.usermethod.billingstate, self.usermethod.billingzip, self.usermethod.billingcountry,isdef];
    
    
    
    // Create Data from request
    NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", self.config.API_ROOT, self.config.API_ADD_EDIT_USER_PAYMENTMETHOD]]];
    
    
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
            
            self.usermethod.payment_method_id = [dic objectForKey:@"payment_method_id"];
            if (self.usermethod.payment_method_id == nil || self.usermethod.payment_method_id.length == 0) {
                self.usermethod.payment_method_id = [dic objectForKey:@"payment_method_id"];
            }
            
            if (self.config.user_payment_methods.count == 0) self.config.selected_payment = self.usermethod;
            
            [self.navigationController popToViewController:self.parent animated:YES];
            
        } else {
            //There was an error
            NSLog(@"%@", err.description);
        }
        
        [indicator stopAnimating];
        
    };
    [connection start];
}


-(void)save_user_method_no_card{
    if ((self.config.user_id == nil || self.config.user_id == 0 || self.config.user_id.length == 0) && self.config.guest_checkout){
        if (self.config.selected_payment == nil)
            self.config.selected_payment = self.usermethod;
        if (self.usermethod.payment_method_id == nil || self.usermethod.payment_method_id.length == 0){
            self.usermethod.payment_method_id = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
            [self.config.user_payment_methods addObject:self.usermethod];
        }
        [self.navigationController popToViewController:self.parent animated:YES];
        return;
    }
    
    int isdef = 0;
    if (self.usermethod.is_default) isdef = 1;
    NSString *myRequestString = [NSString stringWithFormat:@"app_uuid=%@&user_id=%@&access_token=%@&method_id=%@&payment_gateway=%@&customer_id=%@&payment_token=%@&last4=%@&exp_month=%@&exp_year=%@&payment_method=%@&card_type=%@&account_id=%@&billing_firstname=%@&billing_lastname=%@&billing_address=%@&billing_city=%@&billing_state=%@&billing_zip=%@&billing_country=%@&is_default=%d&is_delete=0&card_changed=0", self.config.APP_UUID, self.config.user_id, self.config.token, self.usermethod.payment_method_id, self.usermethod.payment_gateway, self.usermethod.customer_id, self.usermethod.payment_token, self.usermethod.last4, self.usermethod.expmonth, self.usermethod.expyear, self.usermethod.payment_method,self.usermethod.cardtype, self.usermethod.account_id, self.usermethod.billingfirstname, self.usermethod.billinglastname, self.usermethod.billingaddress, self.usermethod.billingcity, self.usermethod.billingstate, self.usermethod.billingzip, self.usermethod.billingcountry,isdef];
    
    
    
    // Create Data from request
    NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", self.config.API_ROOT, self.config.API_ADD_EDIT_USER_PAYMENTMETHOD]]];
    
    
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
            
            
            [self.navigationController popToViewController:self.parent animated:YES];
            
        } else {
            //There was an error
            NSLog(@"%@", err.description);
        }
        
        [indicator stopAnimating];
        
    };
    [connection start];
}



-(void)startAnimating{
    [indicator startAnimating];
}

@end


