//
//  CartViewController.m
//  Ecommerce
//
//  Created by Hanqing Hu on 5/27/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//
#import "NSURLConnectionWithTag.h"
#import "NSURLConnectionBlock.h"
#import "CartViewController.h"
#import "ProductViewController.h"
#import "PKRevealController.h"
#import "CartTableViewCell.h"
#import "CheckoutViewController.h"

#import "LoginViewController.h"
#import "IonIcons.h"
#import "ionicons-codes.h"
#import "Design.h"
#import "Branch.h"
#import "GuestCheckoutViewController.h"
const int GET_CART = 0;
const int DELETE_CART = 1;
@interface CartViewController ()

@end

@implementation CartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        random = [[NSUUID UUID] UUIDString];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UILabel *carttitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 44)];
    //carttitle.backgroundColor = [UIColor blackColor];
    [Design navigationbar_title:carttitle config:self.config];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, carttitle.frame.size.width, 24)] ;
    
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:17.3];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = carttitle.textColor;
    label.text = [self.config localisedString:@"Shopping Cart"];
    //[label sizeToFit];
    [carttitle addSubview:label];
    
    cartCounter = [[UILabel alloc] initWithFrame:CGRectMake(0, 24, carttitle.frame.size.width, 20)] ;
    
    cartCounter.backgroundColor = [UIColor clearColor];
    cartCounter.font = [UIFont boldSystemFontOfSize:14.0];
    cartCounter.textAlignment = NSTextAlignmentCenter;
    cartCounter.textColor = carttitle.textColor;
    cartCounter.text = [NSString stringWithFormat:@"0 %@", [self.config localisedString:@"Item"]];
    //[cartCounter sizeToFit];
    [carttitle addSubview:cartCounter];
    self.navigationItem.titleView = carttitle;
    
    checkout_view = [[UIView alloc] init];
    checkout_view.userInteractionEnabled = NO;
    checkout_middle = [[UILabel alloc] init];
    checkout_middle.userInteractionEnabled = NO;
    [checkout addSubview:checkout_view];
    [checkout_view addSubview:checkout_middle];
    NSMutableDictionary *vs = [[NSMutableDictionary alloc] init];
    totalPrice = [[UILabel alloc] init];
    totalSave = [[UILabel alloc] init];
    checkout_back.frame = CGRectMake(2, checkout_back.frame.origin.y, self.config.screenWidth-4, checkout_back.frame.size.height);
    [checkout_back addSubview:checkout];
    [checkout_back addSubview:totalPrice];
    [checkout_back addSubview:totalSave];
    [checkout setTitle:[self.config localisedString:@"Check Out"] forState:UIControlStateNormal];
    [vs setObject:checkout_back forKey:@"main"];
    [vs setObject:checkout forKey:@"checkout_btn"];
    [vs setObject:checkout_view forKey:@"checkout_view"];
    [vs setObject:checkout_middle forKey:@"checkout_middle"];
    [vs setObject:totalPrice forKey:@"total_price"];
    [vs setObject:totalSave forKey:@"total_save"];
    [Design checkout_view_with_btn:vs config:self.config];
    totalPrice.font = [UIFont boldSystemFontOfSize:15];
    totalSave.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
     NSString *dstr = [[[[self.config.design objectForKey:@"components"] objectForKey:@"filter_page"] objectForKey:@"style"] objectForKey:@"apply-background"];
    [Design style:[[DOM alloc] initWithView:checkout_view parent:nil] design:[[self.config.design objectForKey:@"design"] objectForKey:dstr] config:self.config];
   
    checkout.enabled = NO;
    checkout_view.alpha = 0.5;
    
    NSMutableData *da = [[NSMutableData alloc] init];
    NSMutableData *da2 = [[NSMutableData alloc] init];
    receivedData = [[NSMutableArray alloc] initWithObjects:da, da2,nil];
    cart = [[NSMutableArray alloc] init];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    /*UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(-10, 0, 44, 44);
    [button setImage:[UIImage imageNamed:@"navMenu"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(menu:) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:button];*/
    
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
    seg.text = [self.config localisedString:@"Edit"];
    seg.textAlignment = NSTextAlignmentRight;
    seg.frame = CGRectMake(80-60, 0, 60, 44);
    UITapGestureRecognizer *tapseg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(edit)];
    [seg addGestureRecognizer:tapseg];
    seg.userInteractionEnabled = YES;
    [Design style:[[DOM alloc] initWithView:seg parent:nil] design:[[self.config.design objectForKey:@"design"] objectForKey:@"navigation_icon"] config:self.config];
    
    
    
    UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView:seg];
    //[seg release];
    
    self.navigationItem.rightBarButtonItem = segmentBarItem;
    
    
    table = [[UITableView alloc] init];
    table.separatorColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1];
    table.delegate = self;
    table.dataSource = self;
    table.rowHeight = 140;
    table.frame = CGRectMake(0, 0, self.config.screenWidth, self.config.screenHeight-64-101);
    
    [self.view insertSubview:table belowSubview:indicator];
    
    
    [self load_cart:0];
    [self load_payment];
    
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)viewWillAppear:(BOOL)animated{
    [UIView setAnimationsEnabled:YES];
    if (!self.config.refresh_cart){
        [table reloadData];
        [self update_price];
    } else {
        [self load_cart:0];
        self.config.refresh_cart = NO;
    }
}
-(void)viewDidAppear:(BOOL)animated{
    if (creditview != nil) return;
    [[Branch getInstance] loadRewardsWithCallback:^(BOOL changed, NSError *error) {
        if (self.config.email == nil || self.config.email.length == 0) return;
        NSInteger credits = [[Branch getInstance] getCredits];
        self.config.store_credit = [[NSDecimalNumber alloc] initWithInteger:credits];
        if ([self.config.store_credit floatValue] > 0){
            creditview = [[UIView alloc] initWithFrame:CGRectMake(0, -40, self.config.screenWidth, 40)];
            CALayer *layer = [CALayer layer];
            layer.frame = CGRectMake(0, creditview.frame.size.height, creditview.frame.size.width, 0.5);
            layer.backgroundColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
            [creditview.layer addSublayer:layer];
            
            credit = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.config.screenWidth, creditview.frame.size.height)];
            credit.text = [NSString stringWithFormat:@"%@: %@%0.2f", [self.config localisedString:@"Available Credit"], [self.config getCurrencySymbol],[self.config.store_credit floatValue]*[self.config.currency_rate floatValue]];
            credit.font = [UIFont systemFontOfSize:13];
            [creditview addSubview:credit];
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(creditview.frame.size.width-76, 5, 60, 30)];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            [btn setTitle:[self.config localisedString:@"Apply"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            btn.tag = 0;
            [btn addTarget:self action:@selector(apply_credit:) forControlEvents:UIControlEventTouchUpInside];
            btn.layer.borderWidth = 0.5;
            btn.layer.cornerRadius = 5;
            btn.layer.borderColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
            [creditview addSubview:btn];
            
            applyCredit = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, btn.frame.size.width, btn.frame.size.height)];
            applyCredit.font = [IonIcons fontWithSize:22];
            applyCredit.text = icon_checkmark;
            applyCredit.textAlignment = NSTextAlignmentCenter;
            applyCredit.textColor = [UIColor colorWithRed:0.8196 green:0.2627 blue:0.2627 alpha:1];
            applyCredit.hidden = YES;
            //applyCredit.textColor = [UIColor colorWithRed:(CGFloat) green:<#(CGFloat)#> blue:<#(CGFloat)#> alpha:<#(CGFloat)#>];
            [btn addSubview:applyCredit];
            
            [self.view addSubview:creditview];
            
            [UIView animateWithDuration:0.2f
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 creditview.frame = CGRectMake(0, 0, self.config.screenWidth, 40);
                                 table.frame = CGRectMake(0, 40, self.config.screenWidth, self.config.screenHeight-64-101-40);
                             }
                             completion:^(BOOL finished){
                             }];
            
        }
    }];
}
-(IBAction)apply_credit:(id)sender{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 0){
        applyCredit.hidden = NO;
        self.config.use_credit = true;
        //btn.backgroundColor = [UIColor darkGrayColor];
        [btn setTitle:@"" forState:UIControlStateNormal];
        btn.tag = 1;
        [self update_price];
    } else {
        self.config.use_credit = false;
        //btn.backgroundColor = [UIColor whiteColor];
        btn.titleLabel.hidden = NO;
        applyCredit.hidden = YES;
        [btn setTitle:[self.config localisedString:@"Apply"] forState:UIControlStateNormal];
        btn.tag = 0;
        [self update_price];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)edit{
    if (seg.tag == 0){
        seg.tag = 1;
        //[seg setTitle:[self.config localisedString:@"Done"] forSegmentAtIndex:0];
        seg.text = [self.config localisedString:@"Done"];
        [table setEditing:YES animated:YES];
    } else {
        seg.tag = 0;
        seg.text = [self.config localisedString:@"Edit"];
        [table setEditing:NO animated:YES];
    }
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



-(void)load_cart:(int)start{
    if (loading == 1) return;
    if (start == 0){
        [self.config.cart removeAllObjects];
        
        [NSThread detachNewThreadSelector:@selector(threadStartAnimating) toTarget:self withObject:nil];
    }
    loading = 1;
    
    if (self.config.user_id != nil && ![self.config.user_id isEqualToString:@"0"] && self.config.user_id.length > 0 ) {
            NSString *wu = self.config.wholesale.wholesale_user_id;
            if (wu == nil) wu = @"";
    
            NSString *myRequestString = [NSString stringWithFormat:@"app_uuid=%@&user_id=%@&access_token=%@&device_token=%@&wholesale_user_id=%@&start=%d&location=%@&currency=%@", self.config.APP_UUID, self.config.user_id, self.config.token,self.config.device_token, wu, start, self.config.location, self.config.currency];
    
            NSLog(@"%@", myRequestString);
            // Create Data from request
            NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", self.config.API_ROOT, self.config.API_GET_CART]]];
    
    
    
            // set Request Type
            [request setHTTPMethod: @"POST"];
            // Set content-type
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
            // Set Request Body
            [request setHTTPBody: myRequestData];
    
    
            NSMutableData *received = [receivedData objectAtIndex:GET_CART];
            [received setLength:0];
            NSURLConnectionWithTag *urlConnection = [[NSURLConnectionWithTag alloc] initWithRequest:request delegate:self tag:GET_CART index:0 withid:random];
    } else if (self.config.guest_checkout){
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.config.cache.cart
                                                           options:0
                                                             error:nil];
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSString *myRequestString = [NSString stringWithFormat:@"app_uuid=%@&device_token=%@&location=%@&currency=%@&cached_cart=%@", self.config.APP_UUID, self.config.device_token, self.config.location, self.config.currency, jsonString];
        
        NSLog(@"%@", myRequestString);
        // Create Data from request
        NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", self.config.API_ROOT, self.config.API_GUEST_GET_CART]]];
        
        
        
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
                NSLog(@"%@",response);
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
                
                
               
                NSArray *pros = [dic objectForKey:@"products"];
                for (NSDictionary *d in pros){
                    Cart *p = [[Cart alloc] init];
                    //p.cart_id = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
                    [p cart_from_dictionary:d];
                    [self.config.cart addObject:p];
                }
                if (self.config.cart.count > 0){
                    checkout.enabled = YES;
                    checkout.alpha = 1;
                }
                [table reloadData];
                cartCounter.text = [NSString stringWithFormat:@"%ld %@",self.config.cart.count,[self.config localisedString:@"Item(s)"]];
                [self update_price];
                
                [indicator stopAnimating];
                
            } else {
                //There was an error
                
            }
            
        };
        [connection start];
    }
    
    
}

-(void)load_payment{
    self.config.user_payment_methods = [[NSMutableArray alloc] init];
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
                [self.config.user_payment_methods addObject:upm];
                
                if (upm.is_default || arr.count == 1){
                    self.config.selected_payment = upm;
                }
            }
            
            
        } else {
            //There was an error
            NSLog(@"%@", err.description);
        }
        
    };
    [connection start];


}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.config.cart.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    @try {
        
    
    Cart *temp = [self.config.cart objectAtIndex:indexPath.row];
    
    
    CartTableViewCell *cell = [[CartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] ;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (temp.sku == nil || [temp.sku isKindOfClass:[NSNull class]] || temp.sku.length == 0) cell.name.text = [self.config localisedString:@"Product Deleted"];
    else {
        
        cell.name.text = temp.name;
        
        
        cell.brand.text = temp.brand;
        cell.brand.frame = CGRectMake(cell.brand.frame.origin.y, cell.name.frame.origin.y+cell.name.frame.size.height+5, cell.brand.frame.size.width, cell.brand.frame.size.height);
        cell.attr.text = temp.attr_string;
        cell.qty.text = [NSString stringWithFormat:@"%@: %d", [self.config localisedString:@"Qty"], temp.quantity];
        cell.price.text = [NSString stringWithFormat:@"%@%@", [self.config getCurrencySymbol], [temp.price stringValue]];
        NSDecimalNumber *zero = [NSDecimalNumber decimalNumberWithString:@"0"];
        if ([temp.sale_price compare:[NSNumber numberWithInt:0]] != NSOrderedSame){
            NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%0.2f  %@%0.2f",[self.config getCurrencySymbol], [temp.price floatValue], [self.config getCurrencySymbol], [temp.sale_price floatValue]]];
            [attributeString addAttribute:NSFontAttributeName value:cell.price.font range:(NSRange){0,[attributeString length]}];
            
            NSString *p = [NSString stringWithFormat:@"%@%0.2f", [self.config getCurrencySymbol],[temp.price floatValue]];
            //NSString *s = [NSString stringWithFormat:@"$%0.2f", sale_price];
            [attributeString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:1] range:(NSRange){0,[p length]}];
            
            UIColor *priceColor = [UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:1];
            
            UIColor *saleColor = [UIColor colorWithRed:204/255.0 green:76/255.0 blue:70/255.0 alpha:1];
            
            
            [attributeString addAttribute:NSForegroundColorAttributeName value:(id)priceColor range:NSMakeRange(0, [p length])];
            [attributeString addAttribute:NSFontAttributeName value:(id)[UIFont systemFontOfSize:13] range:NSMakeRange(0, [p length])];
            [attributeString addAttribute:NSForegroundColorAttributeName value:(id)saleColor range:NSMakeRange([p length], [attributeString length]-[p length])];
            [attributeString addAttribute:NSFontAttributeName value:(id)[UIFont boldSystemFontOfSize:13] range:NSMakeRange([p length], [attributeString length]-[p length])];
            cell.price.text = @"";
            cell.price.attributedText = attributeString;
        }
        cell.leftImage.contentMode = UIViewContentModeScaleAspectFit;
    // cell.leftImage.image = temp.itemImage;
        

        
        if (temp.imageURL != nil && ![temp.imageURL isKindOfClass:[NSNull class]] && temp.itemImage == nil) {
        //but.image = [UIImage imageNamed:@"default-shop.png"];
            NSString *url = [temp.imageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            dispatch_async(queue, ^{
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
                UIImage *image = [UIImage imageWithData:data];
                CGSize isize = [image size];
                CGSize newSize=CGSizeMake(isize.width/2,isize.height/2); // I am giving resolution 50*50 , you can change your need
                UIGraphicsBeginImageContext(newSize);
                [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
                UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            //[self forceImageDecompression:image];
                image = nil;
                data = nil;
                
            
                dispatch_async(dispatch_get_main_queue(), ^{
                //but.image = newImage;
                    temp.itemImage = newImage;
                    cell.leftImage.image = newImage;
                    
                });
            });
        } else {
            cell.leftImage.image = temp.itemImage;
        }
        
        if (temp.deleted == 0) {
            
        } else {
            cell.brand.text= @"";
            cell.name.text = [self.config localisedString:@"Sold Out"];
        }
    }
    //cell.secondaryLabel.text = temp.selected_var;
    
    
    //[Design cart_tableCell:cell config:self.config];
    
    return cell;
    }
    @catch (NSException *exception) {
        //NSLog(@"%@", [exception callStackSymbols]);
    }
    @finally {
        
    }
    
    
    
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // If row is deleted, remove it from the list.
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Cart *temp = [self.config.cart objectAtIndex:indexPath.row];
        if (self.config.user_id > 0) {
        [NSThread detachNewThreadSelector:@selector(threadStartAnimating) toTarget:self withObject:nil];
        
        
        NSString *myRequestString = [NSString stringWithFormat:@"user_id=%@&access_token=%@&device_token=%@&cart_id=%@&product_id=%@&sku=%@&quantity=%d&app_uuid=%@", self.config.user_id, self.config.token, self.config.device_token,temp.cart_id,temp.product_id,temp.sku, temp.quantity, self.config.APP_UUID];
        
        NSLog(myRequestString);
        // Create Data from request
        NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", self.config.API_ROOT, self.config.API_DELETE_CART]]];
        
        
        
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
        
        NSMutableData *received = [receivedData objectAtIndex:DELETE_CART];
        [received setLength:0];
        NSURLConnectionWithTag *urlConnection = [[NSURLConnectionWithTag alloc] initWithRequest:request delegate:self tag:DELETE_CART index:indexPath.row withid:random];
        } else if (self.config.guest_checkout){
            for (int i = 0 ; i < self.config.cache.cart.count; i++){
                NSDictionary *d = [self.config.cache.cart objectAtIndex:i];
                if ([[d objectForKey:@"cart_id"] isEqualToString:temp.cart_id]){
                    [self.config.cache.cart removeObjectAtIndex:i];
                    
                    self.config.cartnum--;
                }
            }
            [self.config.cache save_default];
            [self.config.cart removeObjectAtIndex:indexPath.row];
            cartCounter.text = [NSString stringWithFormat:@"%ld %@",self.config.cart.count, [self.config localisedString:@"Item(s)"]];
            [self update_price];
            [table reloadData];
        }
        
    }
}




- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)update_price{
    total = [NSDecimalNumber decimalNumberWithString:@"0"];
    totalsaved = [NSDecimalNumber decimalNumberWithString:@"0"];
    for (Cart *p in self.config.cart){
        if (p.deleted) continue;
        if ([p.sale_price compare:[NSNumber numberWithInt:0]] != NSOrderedSame) {
            totalsaved =[totalsaved decimalNumberByAdding: [p.price decimalNumberBySubtracting:p.sale_price]];
            total = [total decimalNumberByAdding:p.sale_price];
        }
        else total = [total decimalNumberByAdding:p.price];
    }
    
    totalPrice.text = [NSString stringWithFormat:@"%@:    %@%0.2f", [self.config localisedString:@"Subtotal"], [self.config getCurrencySymbol], [total floatValue]];
    totalSave.text = [NSString stringWithFormat:@"%@:     %@%0.2f", [self.config localisedString:@"Savings"], [self.config getCurrencySymbol],[totalsaved floatValue]];
    if ([total compare:[NSNumber numberWithInt:0]] == NSOrderedSame){
        checkout.enabled = NO;
        checkout_view.alpha = 0.5;
    } else {
        checkout.enabled = YES;
        checkout_view.alpha = 1;
    }
    
    if (self.config.use_credit){
        if ([total compare:self.config.store_credit] == NSOrderedAscending || [total compare:self.config.store_credit] == NSOrderedSame){
            NSDecimalNumber *remaining = [self.config.store_credit decimalNumberBySubtracting:total];
            totalPrice.text = [NSString stringWithFormat:@"%@:    %@%d", [self.config localisedString:@"Subtotal"], [self.config getCurrencySymbol], 0];
            credit.text = [NSString stringWithFormat:@"%@: %@%0.2f", [self.config localisedString:@"Available Credit"], [self.config getCurrencySymbol],[remaining floatValue]*[self.config.currency_rate floatValue]];
            NSDecimalNumber *saved = [totalsaved decimalNumberByAdding:total];
            totalSave.text = [NSString stringWithFormat:@"%@:     %@%0.2f", [self.config localisedString:@"Savings"], [self.config getCurrencySymbol],[total floatValue]];
        } else {
            NSDecimalNumber *remaining = [total decimalNumberBySubtracting:self.config.store_credit];
            totalPrice.text = [NSString stringWithFormat:@"%@:    %@%0.2f", [self.config localisedString:@"Subtotal"], [self.config getCurrencySymbol], [remaining floatValue]];
            credit.text = [NSString stringWithFormat:@"%@: %@0", [self.config localisedString:@"Available Credit"], [self.config getCurrencySymbol]];
            NSDecimalNumber *saved = [totalsaved decimalNumberByAdding:self.config.store_credit];
            totalSave.text = [NSString stringWithFormat:@"%@:     %@%0.2f", [self.config localisedString:@"Savings"], [self.config getCurrencySymbol],[saved floatValue]];
        }
    } else {
        credit.text = [NSString stringWithFormat:@"%@: %@%0.2f", [self.config localisedString:@"Available Credit"], [self.config getCurrencySymbol],[self.config.store_credit floatValue]*[self.config.currency_rate floatValue]];
    }
}


-(IBAction)checkout:(id)sender{
    
    //if (![self.config.payment_method isEqualToString:@"Paypal"]) {
            CheckoutViewController *cv = [[CheckoutViewController alloc] initWithNibName:@"CheckoutViewController" bundle:nil];
            cv.config = self.config;
            cv.total = total;
            cv.totalsaved = totalsaved;
            cv.parent = self.parent;
        if ((self.config.email == nil || self.config.email.length == 0 || self.config.user_id == nil || self.config.user_id == 0 || self.config.user_id.length == 0) && !self.config.guest_checkout){
            LoginViewController *lefty = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            lefty.config = self.config;
            
            [self presentViewController:lefty animated:YES completion:nil];
        } else if ((self.config.email == nil || self.config.email.length == 0 || self.config.user_id == nil || self.config.user_id == 0 || self.config.user_id.length == 0) && self.config.guest_checkout){
            GuestCheckoutViewController *gcv = [[GuestCheckoutViewController alloc] initWithNibName:@"GuestCheckoutViewController" bundle:nil];
            gcv.config = self.config;
            //gcv.parent = self.parent;
            gcv.next = cv;
            [self.navigationController pushViewController:gcv animated:YES];
        }else {
            
            [self.navigationController pushViewController:cv animated:YES];
        }
   /* } else {
            
            CheckoutPaypalViewController *cpv = [[CheckoutPaypalViewController alloc] initWithNibName:@"CheckoutPaypalViewController" bundle:nil];
            cpv.config = self.config;
            cpv.total = total;
            cpv.totalsaved = totalsaved;
            cpv.parent = self.parent;
        if ((self.config.email == nil || self.config.email.length == 0 || self.config.user_id == nil || self.config.user_id == 0 || self.config.user_id.length == 0) && !self.config.guest_checkout){
            LoginViewController *lefty = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            lefty.config = self.config;
            
            [self presentViewController:lefty animated:YES completion:nil];
        } else if ((self.config.email == nil || self.config.email.length == 0 || self.config.user_id == nil || self.config.user_id == 0 || self.config.user_id.length == 0) && self.config.guest_checkout){
            GuestCheckoutViewController *gcv = [[GuestCheckoutViewController alloc] initWithNibName:@"GuestCheckoutViewController" bundle:nil];
            gcv.config = self.config;
            //gcv.parent = self.parent;
            gcv.next = @"";
            [self.navigationController pushViewController:gcv animated:YES];
        }else {
            
            [self.navigationController pushViewController:cpv animated:YES];
        }
    }*/
    
}




- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    @try {
        NSURLConnectionWithTag *conn = (NSURLConnectionWithTag *)connection;
        if ([conn.uuid isEqualToString:random]){
            NSMutableData *received = [receivedData objectAtIndex:conn.tag];
            [received appendData:data];
        }
        
    }
    @catch (NSException *exception) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Failed to load cart."] message:@"" delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
        [alert show];
        
        [indicator stopAnimating];
        loading = 0;
        
    }
    
    
    
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [indicator stopAnimating];
    loading = 0;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Failed to load cart."] message:@"" delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
    [alert show];
    
    [indicator stopAnimating];
    loading = 0;
    
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSURLConnectionWithTag *conn = (NSURLConnectionWithTag *)connection;
    NSMutableData *received = [receivedData objectAtIndex:conn.tag];
    
    @try {
        if (conn.tag == GET_CART){
            NSString *myxml = [[NSString alloc] initWithData:received encoding:NSASCIIStringEncoding];
            NSLog(@"%@", myxml);
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:received options:0 error:nil];
            NSArray *pros = [dic objectForKey:@"products"];
            for (NSDictionary *d in pros){
                Cart *p = [[Cart alloc] init];
                [p cart_from_dictionary:d];
                [self.config.cart addObject:p];
            }
            if (self.config.cart.count > 0){
                checkout.enabled = YES;
                checkout.alpha = 1;
            }
            [table reloadData];
            cartCounter.text = [NSString stringWithFormat:@"%ld %@",self.config.cart.count,[self.config localisedString:@"Item(s)"]];
            [self update_price];
            
        }
        if (conn.tag == DELETE_CART ){
            NSString *myxml = [[NSString alloc] initWithData:received encoding:NSASCIIStringEncoding];
            NSLog(@"%@", myxml);
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:received options:0 error:nil];
            if ([[dic objectForKey:@"success"] intValue] == 1){
                [self.config.cart removeObjectAtIndex:conn.index];
                NSIndexPath *myIP = [NSIndexPath indexPathForRow:conn.index inSection:0] ;
                [table deleteRowsAtIndexPaths:[NSArray arrayWithObject:myIP] withRowAnimation:UITableViewRowAnimationFade];
                self.config.cartnum--;
                cartCounter.text = [NSString stringWithFormat:@"%ld %@",self.config.cart.count, [self.config localisedString:@"Item(s)"]];
                [self update_price];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Failed to delete item."] message:@"" delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
                [alert show];
            }
            
            
            
            
            
        }
        
        
        
    }
    @catch (NSException *exception) {
        //NSLog(exception.description);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Failed to load cart."] message:@"" delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
        [alert show];
        
        [indicator stopAnimating];
        loading = 0;
    }
    @finally {
        [indicator stopAnimating];
        loading = 0;
        
        //searchBarState = 0;
    }
    
}


-(void)threadStartAnimating{
    [indicator startAnimating];
}

-(void)back{
    table.delegate = nil;
    table.dataSource = nil;
    [self.navigationController popViewControllerAnimated:YES];
}



@end
