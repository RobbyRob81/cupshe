//
//  CheckoutPaypalViewController.m
//  Vanessa Gade
//
//  Created by Hanqing Hu on 9/30/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import "CheckoutPaypalViewController.h"
#import "NSURLConnectionWithTag.h"
#import "ShippingMethodViewController.h"
#import "ShippingViewController.h"
#import "BillingAddressViewController.h"
#import "AddCardViewController.h"
#import "IonIcons.h"
#import "ionicons-codes.h"
#import "Design.h"
#import "Branch.h"

const int PAYPAL_CHECK_PRICE = 1;
const int PAYPAL_PAID = 2;
const int PAYPAL_CARD_PURCHASE = 3;
@interface CheckoutPaypalViewController ()

@end

@implementation CheckoutPaypalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 44)] ;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:17.3];
    
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor colorWithRed:0.302 green:0.302 blue:0.318 alpha:1]; // change this color
    self.navigationItem.titleView = label;
    label.text = [self.config localisedString:@"Check Out"];
    //[label sizeToFit];
    [Design navigationbar_title:label config:self.config];
    _payPalConfig = [[PayPalConfiguration alloc] init];
    _payPalConfig.acceptCreditCards = NO;
    _payPalConfig.merchantName = self.config.app_name;
    _payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionBoth;
   
    
    receivedData = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < 5; i++){
        [receivedData addObject:[[NSMutableData alloc] init]];
    }
    
    submit_view = [[UIView alloc] init];
    submit_view.userInteractionEnabled = NO;
    submit_middle = [[UILabel alloc] init];
    submit_middle.userInteractionEnabled = NO;
    [submit addSubview:submit_view];
    [submit_view addSubview:submit_middle];
    NSMutableDictionary *vs = [[NSMutableDictionary alloc] init];
    [vs setObject:submit forKey:@"main"];
    [vs setObject:submit_view forKey:@"checkout_view"];
    [vs setObject:submit_middle forKey:@"checkout_middle"];
    [Design checkout_btn:vs config:self.config];
    NSString *dstr = [[[[self.config.design objectForKey:@"components"] objectForKey:@"filter_page"] objectForKey:@"style"] objectForKey:@"apply-background"];
    [Design style:[[DOM alloc] initWithView:submit_view parent:nil] design:[[self.config.design objectForKey:@"design"] objectForKey:dstr] config:self.config];
    

    
    sel_method = 0;
    [submit setTitle:[self.config localisedString:@"Pay with PayPal"] forState:UIControlStateNormal];
   
    
   /* method = [[UISegmentedControl alloc] initWithItems:
                               [NSArray arrayWithObjects:
                                @"Pay with Card",
                                @"Pay with Paypal",
                                nil]];
    [method addTarget:self action:@selector(paysel:) forControlEvents:UIControlEventValueChanged];
    method.frame = CGRectMake(0, 0, 240, 30);
    //seg.segmentedControlStyle = N;
    method.momentary = YES;
    method.tag = 0;
    
    UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView:method];*/
    //[seg release];
    
   // self.navigationItem.rightBarButtonItem = segmentBarItem;
    
    
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
    
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.hidesWhenStopped = YES;
    indicator.frame = CGRectMake(self.config.screenWidth/2-indicator.frame.size.width/2, self.config.screenHeight/2-indicator.frame.size.height/2, indicator.frame.size.width, indicator.frame.size.height);
    [indicator stopAnimating];
    [self.view addSubview:indicator];
    
    
    if (!self.config.use_credit) self.store_credit_used = [NSDecimalNumber zero];
    
    if (self.config.shipping.count == 1){
        Shipping *s = [self.config.shipping objectAtIndex:0];
        NSDecimalNumber * price = [s claculate_shipping:self.config.cart totalprice:self.total];
        if (price == nil){
            
        }
        else {
            self.config.chosen_shipping = s;
            
        }
        
    }
    
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [table reloadData];
    
    // Preconnect to PayPal early
    if (self.config.paypal_live == 1)
    [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentProduction];
    else [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentSandbox];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0){
        return [self.config localisedString:@"Payment Method"];
        
    } else if (section == 1){
        if (sel_method == 0){
         return [self.config localisedString:@"Payment Info"];  //enable this after figuring out other payment method
        }
        return nil;
    }else if (section == 2){
        return [self.config localisedString:@"Shipping Info"];
    } else if (section == 3) {
        return [self.config localisedString:@"Order Summary"];
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    
    header.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f];;
    CGRect headerFrame = header.frame;
    header.textLabel.frame = headerFrame;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0){
        return 2;  //enable this after figuring out other payment method
        //sel_method = 1;
        //return 1;
    } else if (section == 1) {
        if (sel_method == 0)
        return 1;
        else return 0;
    }
    else if (section == 2) return 2;
    else if (section == 3){
        if (self.config.use_credit) return 6;
        else return 5;
    }
    
    else return 0;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0){
        
        if (self.config.name != nil && self.config.name.length &&
            self.config.city != nil && self.config.city.length &&
            self.config.address != nil && self.config.address.length &&
            self.config.state != nil && self.config.state.length &&
            self.config.zip != nil && self.config.zip.length ){
            return 100;
        }
        
    }
    if (indexPath.section == 2 && indexPath.row == 0){
        
        if (self.config.name != nil && self.config.name.length &&
            self.config.city != nil && self.config.city.length &&
            self.config.address != nil && self.config.address.length &&
            self.config.state != nil && self.config.state.length &&
            self.config.zip != nil && self.config.zip.length ){
            return 100;
        }
        
    }
    return table.rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self calculate_tax];
    shipping = [self.config.chosen_shipping claculate_shipping:self.config.cart totalprice:self.total];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *price = [[UILabel alloc] init];
    price.textColor = [UIColor grayColor];
    price.frame = CGRectMake(0, 0, self.config.screenWidth-10, tableView.rowHeight);
   /* if (indexPath.section == 0 && indexPath.row == 0){
            cell.textLabel.text = [self.config localisedString:@"Credit Card"];
        if (sel_method == 0) cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }*/
    if (indexPath.section == 0 && indexPath.row == 1){
        cell.textLabel.text = [self.config localisedString:@"PayPal"];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];
        if (sel_method == 1) cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    if (indexPath.section == 0 && indexPath.row == 0){
        cell.textLabel.text = [self.config localisedString:@"Credit Card"];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (self.config.stripeToken != nil && self.config.stripeToken.length > 0 ){
            cell = nil;
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
            cell.textLabel.text = [self.config localisedString:@"Credit Card"];
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];
            //cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"...%@",[self.config.card.number substringFromIndex:self.config.card.number.length-4]];
            //cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
            cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f];
            if (sel_method == 0)
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else if (self.config.stripeID != nil && self.config.stripeID.length > 0  ){
            cell = nil;
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
            cell.textLabel.text = [self.config localisedString:@"Credit Card"];
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"...%@",self.config.stripeCard];
             cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f];
            if (sel_method == 0)
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
    }
    if (indexPath.section == 1 && indexPath.row == 0){
        cell.textLabel.text = [self.config localisedString:@"Billing Info"];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (self.config.name != nil && self.config.name.length &&
            self.config.city != nil && self.config.city.length &&
            self.config.address != nil && self.config.address.length &&
            self.config.state != nil && self.config.state.length &&
            self.config.zip != nil && self.config.zip.length ){
            cell.textLabel.text = @"";
            /*cell.textLabel.text = [self.config localisedString:@"Billing Info"];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.detailTextLabel.text = self.config.billingaddress;
            cell.detailTextLabel.textAlignment = NSTextAlignmentRight;*/
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, self.config.screenWidth-20, 30)];
            title.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];
            title.textColor = cell.textLabel.textColor;
            title.text = [self.config localisedString:@"Billing Info"];
            [cell addSubview:title];
            
            UILabel *addr = [[UILabel alloc] initWithFrame:CGRectMake(15, title.frame.origin.y+title.frame.size.height, self.config.screenWidth-20, 16)];
            addr.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f];
            addr.text = self.config.billingname;
            [cell addSubview:addr];
            
            UILabel *addr2 = [[UILabel alloc] initWithFrame:CGRectMake(15, addr.frame.origin.y+addr.frame.size.height, self.config.screenWidth-20, 16)];
            addr2.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f];
            addr2.text = self.config.billingaddress;
            [cell addSubview:addr2];
            
            UILabel *addr3 = [[UILabel alloc] initWithFrame:CGRectMake(15, addr2.frame.origin.y+addr2.frame.size.height, self.config.screenWidth-20, 16)];
            addr3.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f];
            addr3.text = [NSString stringWithFormat:@"%@ %@ %@, %@", self.config.billingcity, self.config.billingstate, self.config.billingcountry, self.config.billingzip];
            [cell addSubview:addr3];

            
            
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
    }
    if (indexPath.section == 2 && indexPath.row == 0){
        cell.textLabel.text = [self.config localisedString:@"Shipping Address"];
         cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (self.config.name != nil && self.config.name.length &&
            self.config.city != nil && self.config.city.length &&
            self.config.address != nil && self.config.address.length &&
            self.config.state != nil && self.config.state.length &&
            self.config.zip != nil && self.config.zip.length ){
            cell.textLabel.text = @"";
            /*cell.textLabel.text = [self.config localisedString:@"Billing Info"];
             cell.textLabel.font = [UIFont systemFontOfSize:14];
             cell.detailTextLabel.text = self.config.billingaddress;
             cell.detailTextLabel.textAlignment = NSTextAlignmentRight;*/
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, self.config.screenWidth-20, 30)];
            title.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];
            title.textColor = cell.textLabel.textColor;
            title.text = [self.config localisedString:@"Shipping Address"];
            [cell addSubview:title];
            
            UILabel *addr = [[UILabel alloc] initWithFrame:CGRectMake(15, title.frame.origin.y+title.frame.size.height, self.config.screenWidth-20, 16)];
            addr.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f];
            addr.text = self.config.name;
            [cell addSubview:addr];
            
            UILabel *addr2 = [[UILabel alloc] initWithFrame:CGRectMake(15, addr.frame.origin.y+addr.frame.size.height, self.config.screenWidth-20, 16)];
            addr2.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f];
            addr2.text = self.config.address;
            [cell addSubview:addr2];
            
            UILabel *addr3 = [[UILabel alloc] initWithFrame:CGRectMake(15, addr2.frame.origin.y+addr2.frame.size.height, self.config.screenWidth-20, 16)];
            addr3.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f];
            addr3.text = [NSString stringWithFormat:@"%@ %@ %@, %@", self.config.city, self.config.state, self.config.country, self.config.zip];
            [cell addSubview:addr3];
            
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
    }
    if (indexPath.section == 2 && indexPath.row == 1){
        cell.textLabel.text = [self.config localisedString:@"Shipping Method"];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (self.config.chosen_shipping != nil ){
            cell = nil;
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];
            cell.textLabel.text = [self.config localisedString:@"Shipping Method"];
            //cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.detailTextLabel.text = self.config.chosen_shipping.name;
            cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
            cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
    }
    
    
    if (indexPath.section == 3 && indexPath.row == 0){
        cell.textLabel.text = [NSString stringWithFormat:@"%@:", [self.config localisedString:@"Product Subtotal"]];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];
        //price.frame = CGRectMake(0, 0, cell.frame.size.width-10, cell.frame.size.height);
        price.textAlignment = NSTextAlignmentRight;
        price.text =[NSString stringWithFormat:@"%@%0.2f", [self.config getCurrencySymbol],[self.total doubleValue]];
        price.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];
        [cell addSubview:price];
    }
    if (indexPath.section == 3 && indexPath.row == 1){
        NSString *ship = @"";
        if (self.config.chosen_shipping != nil){
            shipping = [self.config.chosen_shipping claculate_shipping:self.config.cart totalprice:self.total];
            if (shipping == nil){
                ship = @"N/A";
            }
            else {
                ship = [NSString stringWithFormat:@"%@%0.2f", [self.config getCurrencySymbol],[shipping doubleValue]];
            }
           
            
            //price.frame = CGRectMake(0, 0, cell.frame.size.width-10, cell.frame.size.height);
            price.textAlignment = NSTextAlignmentRight;
            price.text = ship;
            price.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];
            [cell addSubview:price];
        }
        
         cell.textLabel.text = [NSString stringWithFormat:@"%@:", [self.config localisedString:@"Shipping Subtotal"]];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];
        
    }
    if (indexPath.section == 3 && indexPath.row == 2){
        [self calculate_tax];
        cell.textLabel.text = [NSString stringWithFormat:@"%@:", [self.config localisedString:@"Tax Subtotal"]];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];
        //cell.textLabel.text = [NSString stringWithFormat:@"Tax:       $%@", [tax stringValue]];
        
        //price.frame = CGRectMake(0, 0, cell.frame.size.width-10, cell.frame.size.height);
        price.textAlignment = NSTextAlignmentRight;
        price.text =[NSString stringWithFormat:@"%@%0.2f", [self.config getCurrencySymbol],[tax doubleValue]];
        price.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];
        [cell addSubview:price];
    }
    if (self.config.use_credit){
        if (indexPath.section == 3 && indexPath.row == 3){
            
            //price.frame = CGRectMake(0, 0, self.config.screenWidth-10, cell.frame.size.height);
            price.textAlignment = NSTextAlignmentRight;
            cell.textLabel.text = [NSString stringWithFormat:@"%@:", [self.config localisedString:@"Store Credit"]];
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];
            NSDecimalNumber *needtopay = [self.total  decimalNumberByAdding:tax] ;
            if (shipping != nil) needtopay = [[self.total decimalNumberByAdding:tax] decimalNumberByAdding:shipping];
            if ([self.config.store_credit compare:needtopay] == NSOrderedDescending || [self.config.store_credit compare:needtopay] == NSOrderedSame) {
                self.store_credit_used = [needtopay decimalNumberByAdding:[NSDecimalNumber zero]];
            } else {
                self.store_credit_used = self.config.store_credit;
            }
            price.text =[NSString stringWithFormat:@"-%@%0.2f",[self.config getCurrencySymbol], [self.store_credit_used floatValue]];
            price.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];
            [cell addSubview:price];
            
        }
        if (indexPath.section == 3 && indexPath.row == 5){
            
            //price.frame = CGRectMake(0, 0, self.config.screenWidth-10, cell.frame.size.height);
            price.textAlignment = NSTextAlignmentRight;
            
            if (shipping != nil) {
                cell.textLabel.text = [NSString stringWithFormat:@"%@:", [self.config localisedString:@"Total"]];
                price.text =[NSString stringWithFormat:@"%@%0.2f", [self.config getCurrencySymbol], [[[[self.total decimalNumberByAdding:tax] decimalNumberByAdding:shipping] decimalNumberBySubtracting:self.store_credit_used] floatValue]];
                [cell addSubview:price];
                price.font = [UIFont boldSystemFontOfSize:18];
            }
            else {
                cell.textLabel.text = [NSString stringWithFormat:@"%@:", [self.config localisedString:@"Total"]];
                price.text =[NSString stringWithFormat:@"%@%0.2f", [self.config getCurrencySymbol], [[[self.total  decimalNumberByAdding:tax] decimalNumberBySubtracting:self.store_credit_used] floatValue]];
                price.font = [UIFont boldSystemFontOfSize:18];
            }
            cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
            [cell addSubview:price];
        }
        if (indexPath.section == 3 && indexPath.row == 4){
            if (self.totalsaved > 0) {
                cell.textLabel.text = [NSString stringWithFormat:@"%@:", [self.config localisedString:@"Total Savings"]];
                
                price.frame = CGRectMake(0, 0, self.config.screenWidth-10, tableView.rowHeight);
                price.textAlignment = NSTextAlignmentRight;
                
                //self.totalsaved = [self.totalsaved decimalNumberByAdding:self.store_credit_used];
                
                price.text =[NSString stringWithFormat:@"-%@%0.2f",[self.config getCurrencySymbol],[[self.totalsaved decimalNumberByAdding:self.store_credit_used] doubleValue]];
                [cell addSubview:price];
            } else {
                cell.textLabel.text = @"";
            }
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];
            price.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];
        }
        
    } else {
        if (indexPath.section == 3 && indexPath.row == 4){
            
            //price.frame = CGRectMake(0, 0, self.config.screenWidth-10, cell.frame.size.height);
            price.textAlignment = NSTextAlignmentRight;
            
            if (shipping != nil) {
                cell.textLabel.text = [NSString stringWithFormat:@"%@:", [self.config localisedString:@"Total"]];
                price.text =[NSString stringWithFormat:@"%@%0.2f", [self.config getCurrencySymbol], [[[self.total decimalNumberByAdding:tax] decimalNumberByAdding:shipping] doubleValue]];
                [cell addSubview:price];
            }
            else {
                cell.textLabel.text = [NSString stringWithFormat:@"%@:", [self.config localisedString:@"Total"]];
                price.text =[NSString stringWithFormat:@"%@%0.2f", [self.config getCurrencySymbol], [[self.total  decimalNumberByAdding:tax] doubleValue]];
            }
            price.font = [UIFont boldSystemFontOfSize:18];
            cell.font = [UIFont boldSystemFontOfSize:18];
            [cell addSubview:price];
        }
        if (indexPath.section == 3 && indexPath.row == 3){
            if (self.totalsaved > 0) {
                cell.textLabel.text = [NSString stringWithFormat:@"%@:", [self.config localisedString:@"Total Savings"]];
                
                price.frame = CGRectMake(0, 0, self.config.screenWidth-10, tableView.rowHeight);
                price.textAlignment = NSTextAlignmentRight;
                
                //self.totalsaved = [self.totalsaved decimalNumberByAdding:self.store_credit_used];
                
                price.text =[NSString stringWithFormat:@"-%@%0.2f",[self.config getCurrencySymbol],[self.totalsaved doubleValue]];
                [cell addSubview:price];
            } else {
                cell.textLabel.text = @"";
            }
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];
            price.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];
        }
        
    }

    
    
    cell.textLabel.textColor = [UIColor darkGrayColor];
    return  cell;
}

-(void)calculate_tax{
    tax = [NSDecimalNumber decimalNumberWithString:@"0"];
    //NSDecimalNumber *taxrate =[self.config.tax objectForKey:self.config.state];
    //if (taxrate == nil) taxrate = [NSDecimalNumber decimalNumberWithString:@"0"];
    ///if (self.config.state != nil) tax = [taxrate decimalNumberByMultiplyingBy:self.total];
    //if ([tax compare:[NSNumber numberWithFloat:0.01]] == NSOrderedAscending) tax = [NSDecimalNumber decimalNumberWithString:@"0"];
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && indexPath.row == 0){
        sel_method = 0;
        [submit setTitle:[self.config localisedString:@"Submit Order"] forState:UIControlStateNormal];
        [table reloadData];
        AddCardViewController *ac = [[AddCardViewController alloc] initWithNibName:@"AddCardViewController" bundle:nil];
        ac.config = self.config;
        ac.enable_savecard = NO;
        [self.navigationController pushViewController:ac animated:YES];
        return;
    }
    if (indexPath.section == 0 && indexPath.row == 1){
        sel_method = 1;
        [submit setTitle:[self.config localisedString:@"Pay with PayPal"] forState:UIControlStateNormal];
        [table reloadData];
    }
    
    /*if (indexPath.section == 1 && indexPath.row == 0){
        AddCardViewController *ac = [[AddCardViewController alloc] initWithNibName:@"AddCardViewController" bundle:nil];
        ac.config = self.config;
        ac.enable_savecard = NO;
        [self.navigationController pushViewController:ac animated:YES];
        return;
    }*/
    if (indexPath.section == 1 && indexPath.row == 0){
        BillingAddressViewController *shipp = [[BillingAddressViewController alloc] initWithNibName:@"BillingAddressViewController" bundle:nil];
        shipp.config = self.config;
        [self.navigationController pushViewController:shipp animated:YES];
        return;
    }
    if (indexPath.section == 2 && indexPath.row == 0){
        ShippingViewController *shipp = [[ShippingViewController alloc] initWithNibName:@"ShippingViewController" bundle:nil];
        shipp.config = self.config;
        [self.navigationController pushViewController:shipp animated:YES];
        return;
    }
    if (indexPath.section == 2 && indexPath.row == 1){
        ShippingMethodViewController *shipp = [[ShippingMethodViewController alloc] initWithNibName:@"ShippingMethodViewController" bundle:nil];
        shipp.config = self.config;
        shipp.totalprice = self.total;
        [self.navigationController pushViewController:shipp animated:YES];
        return;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    
    return NO;
}

-(IBAction)paysubmit:(id)sender{
    NSString *title = @"";
    BOOL error = NO;
    if (self.config.name == nil || self.config.address == nil || self.config.state == nil || self.config.zip == nil || self.config.city == nil ||  self.config.name.length ==0 || self.config.address.length == 0 || self.config.state.length == 0 || self.config.zip.length == 0 || self.config.city.length == 0){
        title = [self.config localisedString:@"Shipping address is required."];;
        error = YES;
    }
    
    if (self.config.shipping.count > 0 && self.config.chosen_shipping == nil){
        
        title = [self.config localisedString:@"Shipping method is required."];
        error = YES;
    } else shipping = [self.config.chosen_shipping claculate_shipping:self.config.cart totalprice:self.total];
    
    if (error){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:@"" delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
        [alert show];
        return;
    }
  
    if (sel_method == 1) {
        NSDecimalNumber *needtopay = [self.total  decimalNumberByAdding:tax] ;
        if (shipping != nil) needtopay = [[self.total decimalNumberByAdding:tax] decimalNumberByAdding:shipping];
        if (self.config.use_credit && ([self.config.store_credit compare:needtopay] == NSOrderedDescending || [self.config.store_credit compare:needtopay] == NSOrderedSame)) {
             [self buy];
            return;
        }
        [self pay];
    } else if (sel_method == 0){
        [self buy];
    }
}
-(void)buy{
    NSString *title = @"";
    NSString *message = @"";
    BOOL error = NO;
    if ((self.config.stripeToken == nil || self.config.stripeToken.length ==0) && (self.config.stripeID == nil || self.config.stripeID.length == 0)){
        title = [self.config localisedString:@"Credit card is required."];
        error = YES;
        NSDecimalNumber *needtopay = [self.total  decimalNumberByAdding:tax] ;
        if (shipping != nil) needtopay = [[self.total decimalNumberByAdding:tax] decimalNumberByAdding:shipping];
        if ([self.config.store_credit compare:needtopay] == NSOrderedDescending || [self.config.store_credit compare:needtopay] == NSOrderedSame) {
            error = NO;
        }
    }
    if (self.config.billingname == nil || self.config.billingaddress == nil || self.config.billingstate == nil || self.config.billingzip == nil || self.config.billingcity == nil ||  self.config.billingname.length ==0 || self.config.billingaddress.length == 0 || self.config.billingstate.length == 0 || self.config.billingzip.length == 0 || self.config.billingcity.length == 0){
        title = [self.config localisedString:@"Billing address is incomplete."];
        error = YES;
    }
    if (self.config.name == nil || self.config.address == nil || self.config.state == nil || self.config.zip == nil || self.config.city == nil ||  self.config.name.length ==0 || self.config.address.length == 0 || self.config.state.length == 0 || self.config.zip.length == 0 || self.config.city.length == 0){
        title = [self.config localisedString:@"Shipping address is incomplete"];
        error = YES;
    }
    if (self.config.shipping.count > 0 && self.config.chosen_shipping == nil ){
        title = [self.config localisedString:@"Shipping method is required"];
        error = YES;
    } else shipping = [self.config.chosen_shipping claculate_shipping:self.config.cart totalprice:self.total];
    
    if (error){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:@"" delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    
     [self calculate_tax];
    NSDecimalNumber *totalp = nil;
    if (shipping == nil) totalp = [self.total decimalNumberByAdding:tax];
    else totalp = [[self.total decimalNumberByAdding:tax] decimalNumberByAdding:shipping] ;
    NSString *stoken = self.config.stripeToken;
    if (self.config.stripeToken == nil) stoken = @"";
    int use_credit = 0;
    if (self.config.use_credit)use_credit = 1;
    NSString *card = @"";
    if (self.config.card != nil && self.config.card.number!= nil) card = self.config.card.number;
    NSString *myRequestString = [NSString stringWithFormat:@"app_uuid=%@&user_id=%@&access_token=%@&name=%@&address=%@&city=%@&state=%@&zip=%@&country=%@&phone=%@&save_address=%d&billingname=%@&billingaddress=%@&billingcity=%@&billingstate=%@&billingzip=%@&billingcountry=%@&save_billing_address=%d&shipping_id=%@&card=%@&exp_month=%ld&exp_year=%ld&cvc=%@&total_paying=%@&use_store_credit=%d&payment_id=%@&location=%@&currency=%@", self.config.APP_UUID, self.config.user_id, self.config.token, self.config.name, self.config.address, self.config.city, self.config.state, self.config.zip,self.config.country, self.config.phone, self.config.save_address,self.config.billingname, self.config.billingaddress, self.config.billingcity, self.config.billingstate, self.config.billingzip, self.config.billingcountry, self.config.save_billing_address,self.config.chosen_shipping.shipping_id, card, (unsigned long)self.config.card.expMonth, (unsigned long)self.config.card.expYear, self.config.card.cvc, [totalp stringValue], use_credit, self.config.stripeID, self.config.location, self.config.currency];
    
    NSLog(myRequestString);
    
    // Create Data from request
    NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", self.config.API_ROOT, self.config.API_PAYPAL_CARD_PURCHASE]]];
    
    
    
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
    
    NSMutableData *received = [receivedData objectAtIndex:PAYPAL_CARD_PURCHASE];
    [received setLength:0];
    NSURLConnectionWithTag *urlConnection = [[NSURLConnectionWithTag alloc] initWithRequest:request delegate:self tag:PAYPAL_CARD_PURCHASE];
}

-(void)pay
{
     [self calculate_tax];
    NSDecimalNumber *totalp = nil;
    NSDecimalNumberHandler *roundPlain = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                       scale:2
                                       raiseOnExactness:NO
                                       raiseOnOverflow:NO
                                       raiseOnUnderflow:NO
                                       raiseOnDivideByZero:YES];
    if (shipping == nil) totalp = [self.total decimalNumberByAdding:tax withBehavior:roundPlain];
    else totalp = [[self.total decimalNumberByAdding:tax] decimalNumberByAdding:shipping withBehavior:roundPlain] ;
    
    
    
    
    [NSThread detachNewThreadSelector:@selector(startAnimating) toTarget:self withObject:nil];
    NSString *myRequestString = [NSString stringWithFormat:@"app_uuid=%@&user_id=%@&access_token=%@&total_paying=%@&shipping_id=%@&state=%@&location=%@&currency=%@", self.config.APP_UUID, self.config.user_id, self.config.token, [totalp stringValue], self.config.chosen_shipping.shipping_id, self.config.state, self.config.location, self.config.currency];
    
    NSLog(@"%@", myRequestString);
    // Create Data from request
    NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", self.config.API_ROOT, self.config.API_PAYPAL_CHECK_PRICE]]];
    
    
    
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
    
    NSMutableData *received = [receivedData objectAtIndex:PAYPAL_CHECK_PRICE];
    [received setLength:0];
    NSURLConnectionWithTag *urlConnection = [[NSURLConnectionWithTag alloc] initWithRequest:request delegate:self tag:PAYPAL_CHECK_PRICE];
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
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Failed to process payment."] message:@"" delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
        [alert show];
        
        [indicator stopAnimating];
        
        
    }
    
    
    
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [indicator stopAnimating];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Failed to process payment."] message:@"" delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
    [alert show];
    
    [indicator stopAnimating];
    
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSURLConnectionWithTag *conn = (NSURLConnectionWithTag *)connection;
    NSMutableData *received = [receivedData objectAtIndex:conn.tag];
    
    @try {
        if (conn.tag == PAYPAL_CHECK_PRICE){
            NSString *myxml = [[NSString alloc] initWithData:received encoding:NSASCIIStringEncoding];
            NSLog(@"%@", myxml);
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:received options:0 error:nil];
            int success = [[dic objectForKey:@"success"] intValue];
            if (success == 1){
                NSDecimalNumberHandler *roundPlain = [NSDecimalNumberHandler
                                                      decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                                      scale:2
                                                      raiseOnExactness:NO
                                                      raiseOnOverflow:NO
                                                      raiseOnUnderflow:NO
                                                      raiseOnDivideByZero:YES];
                
                NSMutableArray *items = [[NSMutableArray alloc] init];
                for (Cart *c in self.config.cart){
                    NSDecimalNumber *p = c.price;
                    if ([c.sale_price compare:[NSNumber numberWithInt:0]] != NSOrderedSame) p = c.sale_price;
                    
                    p = [p decimalNumberByRoundingAccordingToBehavior:roundPlain];
                    PayPalItem *i = [PayPalItem itemWithName:c.name
                                                withQuantity:c.quantity
                                                   withPrice:p
                                                withCurrency:self.config.currency
                                                     withSku:c.sku];
                    [items addObject:i];
                }
                NSDecimalNumber *subtotal = [self.total decimalNumberBySubtracting:[NSDecimalNumber decimalNumberWithString:@"0"]];
                
                NSDecimalNumber *sh = shipping;
                NSDecimalNumber *ta = tax;
                
                
               
                NSDecimalNumber *stotal = [[subtotal decimalNumberByAdding:sh] decimalNumberByAdding:ta];
                
                
                if (self.config.use_credit){
                    stotal = [[[self.total decimalNumberByAdding:sh] decimalNumberByAdding:ta] decimalNumberBySubtracting:self.config.store_credit];
                    if ([self.config.store_credit compare:ta] == NSOrderedDescending){
                        NSDecimalNumber *rem = [self.config.store_credit decimalNumberBySubtracting:ta];
                        ta = [NSDecimalNumber decimalNumberWithString:@"0"];
                        if ([rem compare:sh] == NSOrderedDescending){
                            rem = [rem decimalNumberBySubtracting:sh];
                            sh = [NSDecimalNumber decimalNumberWithString:@"0"];
                            subtotal = [subtotal decimalNumberBySubtracting:rem];
                        } else {
                            sh = [sh decimalNumberBySubtracting:rem];
                        }
                    } else {
                        ta = [ta decimalNumberBySubtracting:self.config.store_credit];
                    }
                 
                    
                }
               
                stotal = [stotal decimalNumberByRoundingAccordingToBehavior:roundPlain];
                subtotal = [subtotal decimalNumberByRoundingAccordingToBehavior:roundPlain];
                
                NSLog(@"%f", stotal.floatValue);
                //NSLog(@"%f", subtotal.floatValue);
                
                PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal withShipping:sh withTax:ta];
                
                PayPalShippingAddress *addr =[[PayPalShippingAddress alloc] init];
                addr.city = self.config.city;
                addr.state = self.config.state;
                addr.postalCode = self.config.zip;
                addr.recipientName = self.config.name;
                addr.line1 = self.config.address;
                addr.countryCode=self.config.country;
                
                
                PayPalPayment *payment = [[PayPalPayment alloc] init];
                payment.amount = stotal;
                payment.currencyCode = self.config.currency;
                payment.shortDescription = [NSString stringWithFormat:@"%@ Purchase", self.config.app_name];
                //if (!self.config.use_credit){
                //payment.items = items;  // if not including multiple items, then leave payment.items as nil
                //}
               // payment.paymentDetails = paymentDetails; // if not including payment details, then leave payment.paymentDetails as nil
                payment.shippingAddress = addr;
                
                
                if (!payment.processable) {
                    // This particular payment will always be processable. If, for
                    // example, the amount was negative or the shortDescription was
                    // empty, this payment wouldn't be processable, and you'd want
                    // to handle that here.
                }
                
                // Update payPalConfig re accepting credit cards.
                //self.payPalConfig.acceptCreditCards = YES;
                
                PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                                            configuration:self.payPalConfig
                                                                                                                 delegate:self];
                [self presentViewController:paymentViewController animated:YES completion:nil];
            } else if (success == -1) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Item price in your cart may have changed. Please refresh your cart."] message:[self.config localisedString:@"Your card is not charged."] delegate:self cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles:[self.config localisedString:@"Refresh"], nil];
                [alert show];
            } else {
                NSString *mes = [dic objectForKey:@"message"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:mes message:nil delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
                [alert show];
            }
            
            
        } else if (conn.tag == PAYPAL_PAID){
            NSString *myxml = [[NSString alloc] initWithData:received encoding:NSASCIIStringEncoding];
            NSLog(@"%@", myxml);
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:received options:0 error:nil];
            int success = [[dic objectForKey:@"success"] intValue];
            NSString *oid = [dic objectForKey:@"order_id"];
            if (success == 1){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Your order is submitted."] message:@"" delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
                [alert show];
                self.config.cartnum = 0;
                [self purchase_event];
                [self.navigationController popToViewController:self.parent animated:YES];
            } else {
                NSString *mes = [dic objectForKey:@"message"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:mes message:[self.config localisedString:@"Please contact store owner"] delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles:nil];
                [alert show];
            }
        } else if (conn.tag == PAYPAL_CARD_PURCHASE){
            NSString *myxml = [[NSString alloc] initWithData:received encoding:NSASCIIStringEncoding];
            NSLog(@"%@", myxml);
            NSDictionary *d = [NSJSONSerialization JSONObjectWithData:received options:0 error:nil];
            int success = [[d objectForKey:@"success"] intValue];
            NSString *oid = [d objectForKey:@"order_id"];
            if (success == 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[d objectForKey:@"message"] message:[self.config localisedString:@"Your card is not charged."] delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
                [alert show];
            } else if (success == -1) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Item price in your cart may have changed. Please refresh your cart."] message:[self.config localisedString:@"Your card is not charged."] delegate:self cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles:[self.config localisedString:@"Refresh"], nil];
                [alert show];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Your order is submitted."] message:@"" delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
                [alert show];
                self.config.cartnum = 0;
                 [self purchase_event];
                [self.navigationController popToViewController:self.parent animated:YES];
            }
        }
        
        
        
        
    }
    @catch (NSException *exception) {
        NSLog(exception.description);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Failed to load paypal."] message:@"" delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
        [alert show];
    }
    @finally {
        [indicator stopAnimating];
        
        
        //searchBarState = 0;
    }
    
}


- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    NSDictionary *json = completedPayment.confirmation;
    NSString *payid = [[json objectForKey:@"response"] objectForKey:@"id"];
    NSString *approved = [[json objectForKey:@"response"] objectForKey:@"state"];
    
    if ([approved isEqualToString:@"approved"]){
        [NSThread detachNewThreadSelector:@selector(startAnimating) toTarget:self withObject:nil];
        NSDecimalNumber *totalp = nil;
        if (shipping == nil) totalp = [self.total decimalNumberByAdding:tax];
        else totalp = [[self.total decimalNumberByAdding:tax] decimalNumberByAdding:shipping] ;
        NSString *stoken = self.config.stripeToken;
        if (self.config.stripeToken == nil) stoken = @"";
        int use_credit = 0;
        if (self.config.use_credit)use_credit = 1;
        NSString *myRequestString = [NSString stringWithFormat:@"app_uuid=%@&user_id=%@&access_token=%@&name=%@&address=%@&city=%@&state=%@&zip=%@&country=%@&phone=%@&save_address=%d&billingname=%@&billingaddress=%@&billingcity=%@&billingstate=%@&billingzip=%@&billingcountry=%@&save_billing_address=%d&shipping_id=%@&total_paying=%@&use_store_credit=%d&payment_id=%@&location=%@&currency=%@", self.config.APP_UUID, self.config.user_id, self.config.token, self.config.name, self.config.address, self.config.city, self.config.state, self.config.zip,self.config.country, self.config.phone, self.config.save_address,self.config.billingname, self.config.billingaddress, self.config.billingcity, self.config.billingstate, self.config.billingzip, self.config.billingcountry, self.config.save_billing_address,self.config.chosen_shipping.shipping_id, [totalp stringValue], use_credit, payid, self.config.location, self.config.currency];
        
        //NSString *myRequestString = [NSString stringWithFormat:@"app_uuid=%@&user_id=%@&access_token=%@&name=%@&address=%@&city=%@&state=%@&zip=%@&country=%@&save_address=%d&shipping_id=%@&payment_id=%@", self.config.APP_UUID, self.config.user_id, self.config.token, self.config.name, self.config.address, self.config.city, self.config.state, self.config.zip, self.config.country, self.config.save_address, self.config.chosen_shipping.shipping_id, payid];
        
        
        // Create Data from request
        NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", self.config.API_ROOT, self.config.API_PAYPAL_PURCHASED]]];
        
        
        
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
        
        NSMutableData *received = [receivedData objectAtIndex:PAYPAL_PAID];
        [received setLength:0];
        NSURLConnectionWithTag *urlConnection = [[NSURLConnectionWithTag alloc] initWithRequest:request delegate:self tag:PAYPAL_PAID];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Your payment was rejected by Paypal."] message:nil delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
        [alert show];
    }
    
    
    [[Branch getInstance] redeemRewards:self.config.store_credit];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)purchase_event{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    for (Cart *p in self.config.cart){
        NSLog(@"%@", p.product_id);
        if (p.deleted) continue;
        if ([p.sale_price compare:[NSNumber numberWithInt:0]] != NSOrderedSame) {
            //totalsaved =[totalsaved decimalNumberByAdding: [p.price decimalNumberBySubtracting:p.sale_price]];
            //total = [total decimalNumberByAdding:p.sale_price];
            [dic setObject:[p.sale_price stringValue] forKey:[NSString stringWithFormat:@"%@", p.product_id]];
        }
        else [dic setObject:[p.price stringValue] forKey:[NSString stringWithFormat:@"%@", p.product_id]];
    }
    
    NSMutableDictionary *json = [[NSMutableDictionary alloc] init];
    [json setObject:dic forKey:@"purchases"];
    [json setObject:self.config.currency forKey:@"currency"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jstr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
    [[Branch getInstance] userCompletedAction:@"purchase"];
    
    
    if (self.config.affiliate!= nil && self.config.deeplink_id != nil && ![self.config.deeplink_id isEqualToString:@"0"] && self.config.affiliate.hasAffiliate == 1){
        
        [AffiliateModule saveEvent:self.config.APP_UUID affiliate:self.config.deeplink_id event:@"purchase" json_data:jstr];
        
        
    }
    
    
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)startAnimating{
    [indicator startAnimating];
}

@end
