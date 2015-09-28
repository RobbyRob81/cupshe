//
//  CheckoutViewController.m
//  Ecommerce
//
//  Created by Hanqing Hu on 5/27/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import "CheckoutViewController.h"
#import "AddCardViewController.h"
#import "ShippingViewController.h"
#import "BillingAddressViewController.h"
#import "ShippingMethodViewController.h"
#import "NSURLConnectionWithTag.h"
#import "IonIcons.h"
#import "ionicons-codes.h"
#import "Design.h"
#import "Cart.h"
#import "STPView.h"
#import "PKCardNumber.h"
#import "PKCardType.h"
#import "NSURLConnectionBlock.h"
#import "Branch.h"
const int PURCHASE = 0;
@interface CheckoutViewController ()

@end

@implementation CheckoutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
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
    
    tableItem = [[NSMutableArray alloc] init];
    [tableItem addObject:[self.config localisedString:@"Add Card"]];
    [tableItem addObject:[self.config localisedString:@"Billing Address"]];
    [tableItem addObject:[self.config localisedString:@"Shipping Address"]];
    [tableItem addObject:[self.config localisedString:@"Shipping Method"]];
    [tableItem addObject:[self.config localisedString:@"Products Subtotal"]];
    [tableItem addObject:[self.config localisedString:@"Shipping Subtotal"]];
    [tableItem addObject:[self.config localisedString:@"Sale Tax Subtotal"]];
    if (self.config.use_credit) {
        [tableItem addObject:[self.config localisedString:@"Store Credit"]];
    }
    [tableItem addObject:[self.config localisedString:@"Total"]];
    [tableItem addObject:[self.config localisedString:@"Savings"]];
    
    
    submit_view = [[UIView alloc] init];
    submit_view.userInteractionEnabled = NO;
    submit_middle = [[UILabel alloc] init];
    submit_middle.userInteractionEnabled = NO;
    [submit addSubview:submit_view];
    [submit_view addSubview:submit_middle];
    [submit setTitle:[self.config localisedString:@"Submit Order"] forState:UIControlStateNormal];
    NSMutableDictionary *vs = [[NSMutableDictionary alloc] init];
    [vs setObject:submit forKey:@"main"];
    [vs setObject:submit_view forKey:@"checkout_view"];
    [vs setObject:submit_middle forKey:@"checkout_middle"];
    [Design checkout_btn:vs config:self.config];
    NSString *dstr = [[[[self.config.design objectForKey:@"components"] objectForKey:@"filter_page"] objectForKey:@"style"] objectForKey:@"apply-background"];
    [Design style:[[DOM alloc] initWithView:submit_view parent:nil] design:[[self.config.design objectForKey:@"design"] objectForKey:dstr] config:self.config];
    
    
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
    
    receivedData = [[NSMutableArray alloc] init];
    for (int i = 0; i < 5; i++){
        [receivedData addObject:[[NSMutableData alloc] init]];
    }
    
    if ([self.config.payment_method isEqualToString:@"Magento"] || [self.config.payment_method isEqualToString:@"AuthorizeNet"]){
        [submit addTarget:self action:@selector(buy:) forControlEvents:UIControlEventTouchUpInside];
    } else if ([self.config.payment_method isEqualToString:@"Stripe"]) {
        [submit addTarget:self action:@selector(stripe_buy:) forControlEvents:UIControlEventTouchUpInside];
    }  else if ([self.config.payment_method isEqualToString:@"Conekta"]) {
        [submit addTarget:self action:@selector(conekta_buy:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    
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
    
    
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.hidesWhenStopped = YES;
    indicator.frame = CGRectMake(self.config.screenWidth/2-indicator.frame.size.width/2, self.config.screenHeight/2-indicator.frame.size.height/2, indicator.frame.size.width, indicator.frame.size.height);
    [indicator stopAnimating];
    [self.view addSubview:indicator];
    
    
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)viewWillAppear:(BOOL)animated{
    [table reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0){
        return [self.config localisedString:@"Payment Info"];
    } else if (section == 1){
        return [self.config localisedString:@"Shipping Info"];
    } else if (section == 2) {
        return [self.config localisedString:@"Order Summary"];
    }
    return 0;
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
    /*if (indexPath.section == 2 && indexPath.row == 0){
        
        if (self.config.name != nil && self.config.name.length &&
            self.config.city != nil && self.config.city.length &&
            self.config.address != nil && self.config.address.length &&
            self.config.state != nil && self.config.state.length &&
            self.config.zip != nil && self.config.zip.length ){
            return 100;
        }
        
    }*/
    return table.rowHeight;
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    
    header.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f];;
    CGRect headerFrame = header.frame;
    header.textLabel.frame = headerFrame;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    
    if (section == 0){
        return 1;
    } else if (section == 1) return 2;
    else return tableItem.count - 4;
    
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self calculate_tax];
    shipping = [self.config.chosen_shipping claculate_shipping:self.config.cart totalprice:self.total];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *price = [[UILabel alloc] init];
    price.textColor = [UIColor grayColor];
    price.frame = CGRectMake(0, 0, self.config.screenWidth-10, tableView.rowHeight);
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
            //if (sel_method == 0)
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else if (self.config.stripeID != nil && self.config.stripeID.length > 0  ){
            cell = nil;
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
            cell.textLabel.text = [self.config localisedString:@"Credit Card"];
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"...%@",self.config.stripeCard];
            cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f];
            //if (sel_method == 0)
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
    }
    if (indexPath.section == 0 && indexPath.row == 1){
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
    if (indexPath.section == 1 && indexPath.row == 0){
        cell.textLabel.text = [self.config localisedString:@"Shipping Info"];
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
            title.text = [self.config localisedString:@"Shipping Info"];
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
    if (indexPath.section == 1 && indexPath.row == 1){
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
    if (indexPath.section == 2 && indexPath.row == 0){
        cell.textLabel.text = [NSString stringWithFormat:@"%@:", [self.config localisedString:@"Product Subtotal"]];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];
        price.frame = CGRectMake(0, 0, self.config.screenWidth-10, tableView.rowHeight);
        price.textAlignment = NSTextAlignmentRight;
        price.text =[NSString stringWithFormat:@"%@%0.2f", [self.config getCurrencySymbol],[self.total doubleValue]];
        price.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];
        [cell addSubview:price];
    }
    if (indexPath.section == 2 && indexPath.row == 1){
        NSString *ship = @"";
        if (self.config.chosen_shipping != nil){
            shipping = [self.config.chosen_shipping claculate_shipping:self.config.cart totalprice:self.total];
            if (shipping == nil) {
                
                ship = @"N/A";
            }
            else {
                
                ship = [NSString stringWithFormat:@"%@%0.2f", [self.config getCurrencySymbol], [shipping doubleValue]];
            }
            
            price.frame = CGRectMake(0, 0, self.config.screenWidth-10, tableView.rowHeight);
            price.textAlignment = NSTextAlignmentRight;
            price.text =ship;
            [cell addSubview:price];
        } else {
            price.text =[NSString stringWithFormat:@"%@0", [self.config getCurrencySymbol]];
            price.frame = CGRectMake(0, 0, self.config.screenWidth-10, tableView.rowHeight);
            price.textAlignment = NSTextAlignmentRight;
            [cell addSubview:price];
        }
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@:", [self.config localisedString:@"Shipping Subtotal"]];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];
        price.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];
        
    }
    if (indexPath.section == 2 && indexPath.row == 2){
        [self calculate_tax];
        cell.textLabel.text = [NSString stringWithFormat:@"%@:", [self.config localisedString:@"Tax Subtotal"]];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];
        //cell.textLabel.text = [NSString stringWithFormat:@"Tax:       $%@", [tax stringValue]];
        
        price.frame = CGRectMake(0, 0, self.config.screenWidth-10, tableView.rowHeight);
        price.textAlignment = NSTextAlignmentRight;
        price.text =[NSString stringWithFormat:@"%@%0.2f", [self.config getCurrencySymbol],[tax doubleValue]];
        price.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];
        [cell addSubview:price];
    }
    if (self.config.use_credit){
        if (indexPath.section == 2 && indexPath.row == 3){
            
            price.frame = CGRectMake(0, 0, self.config.screenWidth-10,tableView.rowHeight);
            price.textAlignment = NSTextAlignmentRight;
            cell.textLabel.text = [NSString stringWithFormat:@"%@:", [self.config localisedString:@"Store Credit"]];
            
            NSDecimalNumber *needtopay = [self.total  decimalNumberByAdding:tax] ;
            if (shipping != nil) needtopay = [[self.total decimalNumberByAdding:tax] decimalNumberByAdding:shipping];
            if ([self.config.store_credit compare:needtopay] == NSOrderedDescending || [self.config.store_credit compare:needtopay] == NSOrderedSame) {
                self.store_credit_used = [needtopay decimalNumberByAdding:[NSDecimalNumber zero]];
            } else {
                self.store_credit_used = self.config.store_credit;
            }
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];
            price.text =[NSString stringWithFormat:@"-%@%0.2f", [self.config getCurrencySymbol],[self.store_credit_used floatValue]];
            price.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];
            [cell addSubview:price];
            
        }
        if (indexPath.section == 2 && indexPath.row == 5){
            
            price.frame = CGRectMake(0, 0, self.config.screenWidth-10, tableView.rowHeight);
            price.textAlignment = NSTextAlignmentRight;
            
            if (shipping != nil) {
                cell.textLabel.text = [NSString stringWithFormat:@"%@:", [self.config localisedString:@"Total"]];
                price.text =[NSString stringWithFormat:@"%@%0.2f", [self.config getCurrencySymbol], [[[[self.total decimalNumberByAdding:tax] decimalNumberByAdding:shipping] decimalNumberBySubtracting:self.store_credit_used] floatValue]];
                price.font = [UIFont boldSystemFontOfSize:18];
                [cell addSubview:price];
            }
            else {
                cell.textLabel.text = [NSString stringWithFormat:@"%@:", [self.config localisedString:@"Total"]];
                price.text =[NSString stringWithFormat:@"%@%0.2f",[self.config getCurrencySymbol], [[[self.total  decimalNumberByAdding:tax] decimalNumberBySubtracting:self.store_credit_used] floatValue]];
                price.font = [UIFont boldSystemFontOfSize:18];
            }
            cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
            price.font = [UIFont boldSystemFontOfSize:18];
            [cell addSubview:price];
        }
        if (indexPath.section == 2 && indexPath.row == 4){
            if (self.totalsaved > 0) {
                cell.textLabel.text = [NSString stringWithFormat:@"%@:", [self.config localisedString:@"Total Savings"]];
                
                price.frame = CGRectMake(0, 0, self.config.screenWidth-10, tableView.rowHeight);
                price.textAlignment = NSTextAlignmentRight;
                
                //self.totalsaved = [self.totalsaved decimalNumberByAdding:self.store_credit_used];
                
                price.text =[NSString stringWithFormat:@"%@%0.2f", [self.config getCurrencySymbol],[[self.totalsaved decimalNumberByAdding:self.store_credit_used] doubleValue]];
                [cell addSubview:price];
            } else {
                cell.textLabel.text = @"";
            }
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];
            price.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];
        }
        
    } else {
        if (indexPath.section == 2 && indexPath.row == 4){
            
            price.frame = CGRectMake(0, 0, self.config.screenWidth-10, tableView.rowHeight);
            price.textAlignment = NSTextAlignmentRight;
            
            if (shipping != nil) {
                cell.textLabel.text = [NSString stringWithFormat:@"%@:", [self.config localisedString:@"Total"]];
                price.text =[NSString stringWithFormat:@"%@%0.2f", [self.config getCurrencySymbol],[[[self.total decimalNumberByAdding:tax] decimalNumberByAdding:shipping] floatValue]];
                [cell addSubview:price];
                price.font = [UIFont boldSystemFontOfSize:18];
            }
            else {
                cell.textLabel.text = [NSString stringWithFormat:@"%@:", [self.config localisedString:@"Total"]];
                price.text =[NSString stringWithFormat:@"%@%0.2f", [self.config getCurrencySymbol],[[self.total  decimalNumberByAdding:tax] floatValue]];
                price.font = [UIFont boldSystemFontOfSize:18];
            }
            cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
            price.font = [UIFont boldSystemFontOfSize:18];
            [cell addSubview:price];
        }
        if (indexPath.section == 2 && indexPath.row == 3){
            if (self.totalsaved > 0) {
                cell.textLabel.text = [NSString stringWithFormat:@"%@:", [self.config localisedString:@"Total Savings"]];
                
                price.frame = CGRectMake(0, 0, self.config.screenWidth-10, tableView.rowHeight);
                price.textAlignment = NSTextAlignmentRight;
                
                //self.totalsaved = [self.totalsaved decimalNumberByAdding:self.store_credit_used];
                
                price.text =[NSString stringWithFormat:@"%@%0.2f", [self.config getCurrencySymbol],[self.totalsaved doubleValue]];
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



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0){
        AddCardViewController *ac = [[AddCardViewController alloc] initWithNibName:@"AddCardViewController" bundle:nil];
        ac.config = self.config;
        [self.navigationController pushViewController:ac animated:YES];
        return;
    }
    if (indexPath.section == 0 && indexPath.row == 1){
        BillingAddressViewController *shipp = [[BillingAddressViewController alloc] initWithNibName:@"BillingAddressViewController" bundle:nil];
        shipp.config = self.config;
        [self.navigationController pushViewController:shipp animated:YES];
        return;
    }
    if (indexPath.section == 1 && indexPath.row == 0){
        ShippingViewController *shipp = [[ShippingViewController alloc] initWithNibName:@"ShippingViewController" bundle:nil];
        shipp.config = self.config;
        [self.navigationController pushViewController:shipp animated:YES];
        return;
    }
    if (indexPath.section == 1 && indexPath.row == 1){
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

-(void)calculate_tax{
    tax = [NSDecimalNumber decimalNumberWithString:@"0"];
    NSDecimalNumber *taxrate =[self.config.tax objectForKey:self.config.state];
    if (taxrate == nil) taxrate = [NSDecimalNumber decimalNumberWithString:@"0"];
    if (self.config.state != nil) tax = [taxrate decimalNumberByMultiplyingBy:self.total];
    
}

-(IBAction)buy:(id)sender{
    [NSThread detachNewThreadSelector:@selector(startAnimating) toTarget:self withObject:nil];
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
    /* if (self.config.billingname == nil || self.config.billingaddress == nil || self.config.billingstate == nil || self.config.billingzip == nil || self.config.billingcity == nil ||  self.config.billingname.length ==0 || self.config.billingaddress.length == 0 || self.config.billingstate.length == 0 || self.config.billingzip.length == 0 || self.config.billingcity.length == 0){
     title = [self.config localisedString:@"Billing address is incomplete."];
     error = YES;
     }*/
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
    
    PKCardType cardType = [[PKCardNumber cardNumberWithString:self.config.card.number] cardType];
    NSString *type = @"";
    if (cardType == PKCardTypeAmex) {
        type = @"AE";
    }
    if (cardType == PKCardTypeVisa) {
        type = @"VI";
    }
    if (cardType == PKCardTypeDinersClub) {
        type = @"DC";
    }
    if (cardType == PKCardTypeDiscover) {
        type = @"DS";
    }
    if (cardType == PKCardTypeMasterCard) {
        type = @"CA";
    }
    if (cardType == PKCardTypeJCB) {
        type = @"JC";
    }
    NSString *cardnum = self.config.card.number;
    if (cardnum == nil) cardnum = @"";
    
    NSString *wu = self.config.wholesale.wholesale_user_id;
    if (wu == nil) wu = @"";
    
    NSString *uid = self.config.user_id;
    if (self.config.user_id == nil) uid = @"";
    
    NSString *tuid = self.config.temp_user_id;
    if (self.config.temp_user_id == nil) tuid = @"";
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.config.cache.cart
                                                       options:0
                                                         error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *myRequestString = [NSString stringWithFormat:@"app_uuid=%@&user_id=%@&access_token=%@&temp_user_id=%@&name=%@&address=%@&city=%@&state=%@&zip=%@&country=%@&phone=%@&save_address=%d&billingname=%@&billingaddress=%@&billingcity=%@&billingstate=%@&billingzip=%@&billingcountry=%@&save_billing_address=%d&shipping_id=%@&card=%@&exp_month=%ld&exp_year=%ld&cvc=%@&cc_type=%@&total_paying=%@&use_store_credit=%d&wholesale_user_id=%@&payment_id=%@&location=%@&currency=%@&cached_data=%@", self.config.APP_UUID, uid, self.config.token, tuid, self.config.name, self.config.address, self.config.city, self.config.state, self.config.zip,self.config.country,self.config.phone, self.config.save_address,self.config.billingname, self.config.billingaddress, self.config.billingcity, self.config.billingstate, self.config.billingzip, self.config.billingcountry, self.config.save_billing_address,self.config.chosen_shipping.shipping_id, cardnum, (unsigned long)self.config.card.expMonth, (unsigned long)self.config.card.expYear, self.config.card.cvc, type,[totalp stringValue], use_credit, wu,self.config.stripeID, self.config.location, self.config.currency, jsonString];
    
    NSLog(myRequestString);
    
    // Create Data from request
    NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", self.config.API_ROOT, self.config.API_BUY]]];
    
    
    
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
    NSURLConnectionBlock *connection = [[NSURLConnectionBlock alloc] initWithRequest:request];
    connection.completion = ^(id obj, NSError *err) {
        
        if (!err) {
            //It's ok, do domething with the response data (obj)
            NSMutableData *data = (NSMutableData *)obj;
            
            NSString *myxml = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            NSLog(@"%@", myxml);
            NSDictionary *d = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            int success = [[d objectForKey:@"success"] intValue];
            if (success == 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[d objectForKey:@"message"] message:[self.config localisedString:@"Your card is not charged."] delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
                [alert show];
            } else if (success == -1) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Item price in your cart may have changed. Please refresh your cart."] message:[self.config localisedString:@"Your card is not charged."] delegate:self cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles:[self.config localisedString:@"Refresh"], nil];
                [alert show];
            } else {
                [self purchase_event];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Your order is submitted."] message:@"" delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
                [alert show];
                self.config.cartnum = 0;
                self.config.cartnum = 0;
                [self.config.cache clear];
                [self.config.cache save_default];

                [self.navigationController popToViewController:self.parent animated:YES];
            }
            
            
            
            
        } else {
            //There was an error
            
        }
        
    };
    [connection start];
    
    
}


-(IBAction)conekta_buy:(id)sender {
    
    [NSThread detachNewThreadSelector:@selector(startAnimating) toTarget:self withObject:nil];
    
    
    NSString *title = @"";
    NSString *message = @"";
    BOOL error = NO;
    if ((self.config.stripeToken == nil || self.config.stripeToken.length ==0) && (self.config.stripeID == nil || self.config.stripeID.length == 0)){
        title = [self.config localisedString:@"Credit card is required."];
        error = YES;
        
        if (tax == nil) tax = [[NSDecimalNumber alloc] initWithInt:0];
        NSDecimalNumber *needtopay = [self.total  decimalNumberByAdding:tax] ;
        if (shipping != nil) needtopay = [[self.total decimalNumberByAdding:tax] decimalNumberByAdding:shipping];
        if ([self.config.store_credit compare:needtopay] == NSOrderedDescending || [self.config.store_credit compare:needtopay] == NSOrderedSame) {
            error = NO;
        }
    }
    /* if (self.config.billingname == nil || self.config.billingaddress == nil || self.config.billingstate == nil || self.config.billingzip == nil || self.config.billingcity == nil ||  self.config.billingname.length ==0 || self.config.billingaddress.length == 0 || self.config.billingstate.length == 0 || self.config.billingzip.length == 0 || self.config.billingcity.length == 0){
     title = [self.config localisedString:@"Billing address is incomplete."];
     error = YES;
     }*/
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
        [indicator stopAnimating];
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
    
    PKCardType cardType = [[PKCardNumber cardNumberWithString:self.config.card.number] cardType];
    NSString *type = @"";
    if (cardType == PKCardTypeAmex) {
        type = @"AE";
    }
    if (cardType == PKCardTypeVisa) {
        type = @"VI";
    }
    if (cardType == PKCardTypeDinersClub) {
        type = @"DC";
    }
    if (cardType == PKCardTypeDiscover) {
        type = @"DS";
    }
    if (cardType == PKCardTypeMasterCard) {
        type = @"CA";
    }
    if (cardType == PKCardTypeJCB) {
        type = @"JC";
    }
    NSString *cardnum = self.config.card.number;
    if (cardnum == nil) cardnum = @"";
    
    
    NSString *key = @"key_EQ1KGexkyabn2yqGr7duUA";
    NSData *plain = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data64 = [plain base64EncodedDataWithOptions:0];
    
    NSString *key64 = [[NSString alloc] initWithData:data64 encoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:cardnum, @"number", self.config.billingname, @"name", self.config.card.cvc, @"cvc", [NSString stringWithFormat:@"%ld",self.config.card.expMonth], @"exp_month", [NSString stringWithFormat:@"%ld",self.config.card.expYear], @"exp_year", nil];
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
            NSString *token = [d objectForKey:@"id"];
            if (token == nil) token = @"";
            
            NSString *uid = self.config.user_id;
            if (self.config.user_id == nil) uid = @"";
            
            NSString *tuid = self.config.temp_user_id;
            if (self.config.temp_user_id == nil) tuid = @"";
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.config.cache.cart
                                                               options:0
                                                                 error:nil];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            NSString *myRequestString = [NSString stringWithFormat:@"app_uuid=%@&user_id=%@&access_token=%@&temp_user_id=%@&name=%@&address=%@&city=%@&state=%@&zip=%@&country=%@&save_address=%d&billingname=%@&billingaddress=%@&billingcity=%@&billingstate=%@&billingzip=%@&billingcountry=%@&save_billing_address=%d&shipping_id=%@&card=%@&exp_month=%ld&exp_year=%ld&cvc=%@&cc_type=%@&total_paying=%@&use_store_credit=%d&payment_id=%@&location=%@&currency=%@&cached_data=%@", self.config.APP_UUID, uid, self.config.token, tuid, self.config.name, self.config.address, self.config.city, self.config.state, self.config.zip,self.config.country, self.config.save_address,self.config.billingname, self.config.billingaddress, self.config.billingcity, self.config.billingstate, self.config.billingzip, self.config.billingcountry, self.config.save_billing_address,self.config.chosen_shipping.shipping_id, token, (unsigned long)self.config.card.expMonth, (unsigned long)self.config.card.expYear, self.config.card.cvc, type,[totalp stringValue], use_credit, self.config.stripeID, self.config.location, self.config.currency, jsonString];
            
            NSLog(myRequestString);
            
            // Create Data from request
            NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", self.config.API_ROOT, self.config.API_BUY]]];
            
            
            
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
            NSURLConnectionBlock *connection = [[NSURLConnectionBlock alloc] initWithRequest:request];
            connection.completion = ^(id obj, NSError *err) {
                
                if (!err) {
                    //It's ok, do domething with the response data (obj)
                    NSMutableData *data = (NSMutableData *)obj;
                    
                    NSString *myxml = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
                    NSLog(@"%@", myxml);
                    NSDictionary *d = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    int success = [[d objectForKey:@"success"] intValue];
                    if (success == 0) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[d objectForKey:@"message"] message:[self.config localisedString:@"Your card is not charged."] delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
                        [alert show];
                    } else if (success == -1) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Item price in your cart may have changed. Please refresh your cart."] message:[self.config localisedString:@"Your card is not charged."] delegate:self cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles:[self.config localisedString:@"Refresh"], nil];
                        [alert show];
                    } else {
                        [self purchase_event];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Your order is submitted."] message:@"" delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
                        [alert show];
                        self.config.cartnum = 0;
                        
                        [self.navigationController popToViewController:self.parent animated:YES];
                    }
                    
                    
                    [indicator stopAnimating];
                    
                    
                } else {
                    //There was an error
                    [indicator stopAnimating];
                }
                
            };
            [connection start];
            
            
            
            
        } else {
            //There was an error
            
            [indicator stopAnimating];
            
        }
        
    };
    [connection start];
    
    
}

-(IBAction)stripe_buy:(id)sender{
    
    [NSThread detachNewThreadSelector:@selector(startAnimating) toTarget:self withObject:nil];
    
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
    if (self.config.name == nil || self.config.address == nil || self.config.state == nil || self.config.zip == nil || self.config.city == nil ||  self.config.name.length ==0 || self.config.address.length == 0 || self.config.state.length == 0 || self.config.zip.length == 0 || self.config.city.length == 0){
        title = [self.config localisedString:@"Shipping address is incomplete."];
        error = YES;
    }
    if (self.config.shipping.count > 0 && (self.config.chosen_shipping == nil || shipping == nil)){
        title = [self.config localisedString:@"Shipping method is required."];
        error = YES;
    }
    
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
    
    NSString *wu = self.config.wholesale.wholesale_user_id;
    if (wu == nil) wu = @"";
    
    NSString *uid = self.config.user_id;
    if (self.config.user_id == nil) uid = @"";
    
    NSString *tuid = self.config.temp_user_id;
    if (self.config.temp_user_id == nil) tuid = @"";
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.config.cache.cart
                                                       options:0
                                                         error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *myRequestString = [NSString stringWithFormat:@"app_uuid=%@&user_id=%@&access_token=%@&temp_user_id=%@&name=%@&address=%@&city=%@&state=%@&zip=%@&country=%@&phone=%@&save_address=%d&shipping_id=%@&card=%@&total_paying=%@&save_card=%d&save_card_number=%@&use_store_credit=%d&wholesale_user_id=%@&payment_id=%@&location=%@&currency=%@&cached_data=%@", self.config.APP_UUID, uid, self.config.token,tuid, self.config.name, self.config.address, self.config.city, self.config.state, self.config.zip, self.config.country, self.config.phone, self.config.save_address, self.config.chosen_shipping.shipping_id, stoken, [totalp stringValue], self.config.save_card,[self.config.card.number substringFromIndex:self.config.card.number.length-4], use_credit,wu,self.config.stripeID, self.config.location, self.config.currency, jsonString];
    
    NSLog(@"%@", myRequestString);
    // Create Data from request
    NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.config.API_ROOT, self.config.API_BUY]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    
    
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
    
    NSMutableData *received = [receivedData objectAtIndex:PURCHASE];
    [received setLength:0];
    NSURLConnectionWithTag *urlConnection = [[NSURLConnectionWithTag alloc] initWithRequest:request delegate:self tag:PURCHASE];
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
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Purchase failed."] message:@"" delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
        [alert show];
        
        [indicator stopAnimating];
        
        
    }
    
    
    
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [indicator stopAnimating];
    //loading = 0;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Purchase failed."] message:@"" delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
    [alert show];
    
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSURLConnectionWithTag *conn = (NSURLConnectionWithTag *)connection;
    NSMutableData *received = [receivedData objectAtIndex:conn.tag];
    
    @try {
        if (conn.tag == PURCHASE){
            NSString *myxml = [[NSString alloc] initWithData:received encoding:NSASCIIStringEncoding];
            NSLog(@"%@", myxml);
            NSDictionary *d = [NSJSONSerialization JSONObjectWithData:received options:0 error:nil];
            int success = [[d objectForKey:@"success"] intValue];
            if (success == 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[d objectForKey:@"message"] message:[self.config localisedString:@"Your card is not charged."] delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
                [alert show];
            } else if (success == -1) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Item price in your cart may have changed. Please refresh your cart."] message:[self.config localisedString:@"Your card is not charged."] delegate:self cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles:[self.config localisedString:@"Refresh"], nil];
                [alert show];
            } else {
                [self purchase_event];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Your order is submitted."] message:@"" delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
                [alert show];
                self.config.cartnum = 0;
                [self.config.cache clear];
                [self.config.cache save_default];
                
                [self.navigationController popToViewController:self.parent animated:YES];
            }
            
        }
    }
    @catch (NSException *exception) {
        //NSLog(exception.description);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Purchase failed."] message:@"" delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
        [alert show];
    }
    @finally {
        [indicator stopAnimating];
        //loading = 0;
        
        //searchBarState = 0;
    }
    
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


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
        self.config.refresh_cart = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)startAnimating{
    [indicator startAnimating];
}


@end
