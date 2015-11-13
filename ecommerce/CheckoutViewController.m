//
//  CheckoutViewController.m
//  Ecommerce
//
//  Created by Han Hu on 9/17/15.
//  Copyright (c) 2015 Twixxies. All rights reserved.
//

#import "CheckoutViewController.h"
#import "Design.h"
#import "ionicons-codes.h"
#import "IonIcons.h"
#import "PaymentMethodViewController.h"
#import "Cart.h"
#import "Branch.h"
#import "NSURLConnectionBlock.h"
#import "ShippingMethodViewController.h"
#import "ShippingViewController.h"
#import "ViewWithData.h"
@interface CheckoutViewController ()

@end

@implementation CheckoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
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
    
    
    submit = [[UIView alloc] initWithFrame:CGRectMake(0, self.config.screenHeight-64-51, self.config.screenWidth, 51)];
    UITapGestureRecognizer *submitorder = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(submit_order:)];
    submit.userInteractionEnabled = YES;
    [submit addGestureRecognizer:submitorder];
    submit_view = [[UIView alloc] init];
    submit_view.userInteractionEnabled = NO;
    submit_middle = [[UILabel alloc] init];
    submit_middle.userInteractionEnabled = NO;
    submit_middle.text = [self.config localisedString:@"Submit Order"];
    [submit addSubview:submit_view];
    [submit_view addSubview:submit_middle];
    [self.view addSubview:submit];
    
    NSMutableDictionary *applys = [[NSMutableDictionary alloc] init];
    [applys setObject:submit forKey:@"main"];
    [applys setObject:submit_view forKey:@"checkout_view"];
    [applys setObject:submit_middle forKey:@"checkout_middle"];
    [Design checkout_btn:applys config:self.config];
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
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.config.screenWidth, self.config.screenHeight-64-submit_view.frame.size.height) style:UITableViewStyleGrouped];
    table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    table.dataSource = self;
    table.delegate = self;
    table.bounces = YES;
    table.rowHeight = 57.3;
    [self.view addSubview:table];
    
    sections = [[NSMutableArray alloc] init];
    
    [sections addObject:@"Payment Method"];
    [sections addObject:@"Shipping Info"];
    [sections addObject:@"Order Summary"];
    
    titles = [[NSMutableDictionary alloc] init];
    [titles setObject:[NSArray arrayWithObjects:@"Payment Method", nil] forKey:[sections objectAtIndex:0]];
    [titles setObject:[NSArray arrayWithObjects:@"Shipping Address", @"Shipping Method", nil] forKey:[sections objectAtIndex:1]];
    NSMutableArray *summary =[NSMutableArray arrayWithObjects:@"Products Subtotal",@"Shipping Subtotal",@"Tax Subtotal",@"Savings", @"Total", nil];
    if (self.config.use_credit){
        [summary insertObject:@"Store Credit" atIndex:3];
    }
    [titles setObject:summary forKey:[sections objectAtIndex:2]];
    
    
    
    
    
    
    if (!self.config.use_credit) self.store_credit_used = [NSDecimalNumber zero];
    
    for (ShippingCountry *sc in self.config.shipping){
        if ([sc.code isEqualToString:self.config.country]){
            if (sc.shippings.count == 1){
                self.config.chosen_shipping = [sc.shippings objectAtIndex:0];
            }
        }
    }
    
    
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.hidesWhenStopped = YES;
    indicator.frame = CGRectMake(self.config.screenWidth/2-indicator.frame.size.width/2, self.config.screenHeight/2-indicator.frame.size.height/2, indicator.frame.size.width, indicator.frame.size.height);
    [indicator stopAnimating];
    [self.view addSubview:indicator];
    
    
    
    if (self.config.country == nil || self.config.country.length == 0)
        self.config.country = self.config.location;
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    //[indicator stopAnimating];
    [table reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return sections.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    return [self.config localisedString:[sections objectAtIndex:section]];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *sec = [sections objectAtIndex:indexPath.section];
    NSString *title = [[titles objectForKey:sec] objectAtIndex:indexPath.row];
    
    if ([title isEqualToString:@"Shipping Address"]){
        
        if (self.config.name != nil && self.config.name.length &&
            self.config.city != nil && self.config.city.length &&
            self.config.address != nil && self.config.address.length &&
            self.config.state != nil && self.config.state.length &&
            self.config.zip != nil && self.config.zip.length ){
            return 100;
        }
        
    }
    
    if ([title isEqualToString:@"Payment Method"]){
        if (self.config.selected_payment != nil) return 80;
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
    
    
    NSString *sec = [sections objectAtIndex:section];
    NSArray *t = [titles objectForKey:sec];
    
    return t.count;
    
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [self calculate_tax];
    shipping = [self.config.chosen_shipping claculate_shipping:self.config.cart totalprice:self.total];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *price = [[UILabel alloc] init];
    price.textColor = [UIColor grayColor];
    price.frame = CGRectMake(0, 0, self.config.screenWidth-10, tableView.rowHeight);
    
    NSString *sec = [sections objectAtIndex:indexPath.section];
    NSString *title = [[titles objectForKey:sec] objectAtIndex:indexPath.row];
    
    if ([title isEqualToString:@"Payment Method"]){
        cell.textLabel.text = [self.config localisedString:@"Select Payment Method"];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (self.config.selected_payment != nil){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            UserPaymentMethod *apm = self.config.selected_payment;
            
            ViewWithData *v = [[ViewWithData alloc] initWithFrame:CGRectMake(0,0, self.config.screenWidth-30, 80)];
            v.itemID = apm.payment_method_id;
            v.backgroundColor = [UIColor whiteColor];
            
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
            
            
            [v addSubview:ptitle];
            if (![apm.payment_gateway isEqualToString:@"Custom"]){
                if ([apm.payment_method isEqualToString:@"cc"] || [apm.payment_method isEqualToString:@"credit card"]){
                    NSString *deftstr =[NSString stringWithFormat:@"%@ **** %@", brand, apm.last4];
                    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]
                                                      initWithString:deftstr];
                    [str addAttribute:NSForegroundColorAttributeName
                                value:[UIColor colorWithRed:41.0/255.0 green:39.0/255.0 blue:39.0/255.0 alpha:1] range:NSMakeRange(0, deftstr.length)];
                    
                    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f] range:NSMakeRange(0, deftstr.length)];
                    
                    
                    
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
            
            [cell addSubview:v];
        }
        
    }
    if ([title isEqualToString:@"Shipping Address"]){
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
    
    if ([title isEqualToString:@"Shipping Method"]){
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
    if ([title isEqualToString:@"Products Subtotal"]){
        cell.textLabel.text = [NSString stringWithFormat:@"%@:", [self.config localisedString:@"Product Subtotal"]];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];
        price.frame = CGRectMake(0, 0, self.config.screenWidth-10, tableView.rowHeight);
        price.textAlignment = NSTextAlignmentRight;
        price.text =[NSString stringWithFormat:@"%@%0.2f", [self.config getCurrencySymbol],[self.total doubleValue]];
        price.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];
        [cell addSubview:price];
        
    }
    if ([title isEqualToString:@"Shipping Subtotal"]){
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
    if ([title isEqualToString:@"Tax Subtotal"]){
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
    if ([title isEqualToString:@"Store Credit"]){
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
    if ([title isEqualToString:@"Savings"]){
        cell.textLabel.text = [NSString stringWithFormat:@"%@:", [self.config localisedString:@"Total Savings"]];
        
        price.frame = CGRectMake(0, 0, self.config.screenWidth-10, tableView.rowHeight);
        price.textAlignment = NSTextAlignmentRight;
        
        //self.totalsaved = [self.totalsaved decimalNumberByAdding:self.store_credit_used];
        
        price.text =[NSString stringWithFormat:@"%@%0.2f", [self.config getCurrencySymbol],[[self.totalsaved decimalNumberByAdding:self.store_credit_used] doubleValue]];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];
        price.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];
        [cell addSubview:price];
    }
    if ([title isEqualToString:@"Total"]){
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
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *sec = [sections objectAtIndex:indexPath.section];
    NSString *title = [[titles objectForKey:sec] objectAtIndex:indexPath.row];
    
    if ([title isEqualToString:@"Payment Method"]){
        PaymentMethodViewController *pm = [[PaymentMethodViewController alloc] init];
        pm.config = self.config;
        pm.is_checkout = YES;
        pm.parent = self;
        [self.navigationController pushViewController:pm animated:YES];
    } else if ([title isEqualToString:@"Shipping Address"]){
        ShippingViewController *shipp = [[ShippingViewController alloc] initWithNibName:@"ShippingViewController" bundle:nil];
        shipp.config = self.config;
        [self.navigationController pushViewController:shipp animated:YES];
        return;
    } else if ([title isEqualToString:@"Shipping Method"]){
        ShippingMethodViewController *shipp = [[ShippingMethodViewController alloc] initWithNibName:@"ShippingMethodViewController" bundle:nil];
        shipp.config = self.config;
        shipp.totalprice = self.total;
        [self.navigationController pushViewController:shipp animated:YES];
        return;
    }
}

-(void)calculate_tax{
    tax = [NSDecimalNumber decimalNumberWithString:@"0"];
    for (ShippingCountry *sc in self.config.shipping){
        if ([sc.code isEqualToString:self.config.country]){
            tax = [sc.tax decimalNumberByMultiplyingBy:self.total];
            for (ShippingState *ss in sc.states){
                if ([[ss.name lowercaseString] isEqualToString:[self.config.state lowercaseString]] || [[ss.code lowercaseString] isEqualToString:[self.config.state lowercaseString]]){
                    tax = [tax decimalNumberByAdding: [ss.tax decimalNumberByMultiplyingBy:self.total]];
                }
            }
        }
        
    }
    //NSDecimalNumber *taxrate =[self.config.tax objectForKey:self.config.state];
    //if (taxrate == nil) taxrate = [NSDecimalNumber decimalNumberWithString:@"0"];
    //if (self.config.state != nil) tax = [taxrate decimalNumberByMultiplyingBy:self.total];
    
}

-(void)submit_order:(UITapGestureRecognizer *)ges{
    
    [NSThread detachNewThreadSelector:@selector(startAnimating) toTarget:self withObject:nil];
    NSString *title = @"";
    NSString *message = @"";
    BOOL error = NO;
    if (self.config.selected_payment == nil){
        title = [self.config localisedString:@"Payment method is required."];
        error = YES;
        NSDecimalNumber *needtopay = [self.total  decimalNumberByAdding:tax] ;
        if (shipping != nil) needtopay = [[self.total decimalNumberByAdding:tax] decimalNumberByAdding:shipping];
        if ([self.config.store_credit compare:needtopay] == NSOrderedDescending || [self.config.store_credit compare:needtopay] == NSOrderedSame) {
            error = NO;
        }
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
    
    if (self.config.selected_payment.handle_payment == YES){
        self.config.selected_payment.delegate = self;
        [self.config.selected_payment pay:self.total shipping:shipping tax:tax];
        return;
    }
    
    if ([self.config.selected_payment.appmethod.payment_flow isEqualToString:@"in app"]){
        [self in_app_payment:totalp currency:self.config.currency];
        return;
    }
    
    
    NSString *myRequestString = [NSString stringWithFormat:@"app_uuid=%@&user_id=%@&access_token=%@&temp_user_id=%@&name=%@&address=%@&city=%@&state=%@&zip=%@&country=%@&phone=%@&save_address=%d&shipping_id=%@&payment_method_id=%@&total_paying=%@&use_store_credit=%d&wholesale_user_id=%@&location=%@&currency=%@&cached_data=%@", self.config.APP_UUID, uid, self.config.token, tuid, self.config.name, self.config.address, self.config.city, self.config.state, self.config.zip,self.config.country,self.config.phone, self.config.save_address,self.config.chosen_shipping.shipping_id, self.config.selected_payment.payment_method_id,[totalp stringValue], use_credit, wu, self.config.location, self.config.currency, jsonString];
    
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
                NSString *message = [self.config localisedString:@"Payment Failed"];
                if (d != nil && [d objectForKey:@"message"] != nil && ![[d objectForKey:@"message"] isKindOfClass:[NSNull class]]) message = [d objectForKey:@"message"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message message:[self.config localisedString:@"Your card is not charged."] delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
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
        
        [indicator stopAnimating];
        
    };
    [connection start];
    
}

-(void)in_app_payment:(NSDecimalNumber *)total_paying currency:(NSString *)cur{
    
    if ([self.config.selected_payment.appmethod.payment_gateway isEqualToString:@"Paypal"] && [self.config.selected_payment.appmethod.payment_method isEqualToString:@"paypal"]){
        
        [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : self.config.selected_payment.appmethod.api_userid,  PayPalEnvironmentSandbox : self.config.selected_payment.appmethod.sandbox_api_userid}];
        
        if (self.config.selected_payment.appmethod.islive == 1){
            [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentProduction];
        } else {
            [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentSandbox];
        }
        
        
        
        PayPalPayment *payment = [[PayPalPayment alloc] init];
        
        // Amount, currency, and description
        payment.amount = total_paying;
        payment.currencyCode = cur;
        payment.shortDescription = @"CUPSHE App Purchase";
        payment.intent = PayPalPaymentIntentAuthorize;
        
        PayPalShippingAddress *sa = [[PayPalShippingAddress alloc] init];
        sa.recipientName = self.config.name;
        sa.city = self.config.city;
        sa.state = self.config.state;
        sa.postalCode = self.config.zip;
        sa.countryCode = self.config.country;
        sa.line1 = self.config.address;
        payment.shippingAddress = sa; // a previously-created PayPalShippingAddress object
        
        // Check whether payment is processable.
        if (!payment.processable) {
            // If, for example, the amount was negative or the shortDescription was empty, then
            // this payment would not be processable. You would want to handle that here.
        }
        
        PayPalConfiguration *pconfig = [[PayPalConfiguration alloc] init];
        
        
        //pconfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
        
        PayPalPaymentViewController *paymentViewController;
        paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                       configuration:pconfig
                                                                            delegate:self];
        
        // Present the PayPalPaymentViewController.
        [self presentViewController:paymentViewController animated:YES completion:nil];
        
    }
    
    
}


- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController
                 didCompletePayment:(PayPalPayment *)completedPayment {
    // Payment was processed successfully; send to server for verification and fulfillment.
    
    NSLog(@"%@", [[completedPayment.confirmation objectForKey:@"response"] objectForKey:@"authorization_id"]);
    
    [self capture_order:[[completedPayment.confirmation objectForKey:@"response"] objectForKey:@"authorization_id"]];
    // Dismiss the PayPalPaymentViewController.
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    // The payment was canceled; dismiss the PayPalPaymentViewController.
    
    [indicator stopAnimating];
    [self dismissViewControllerAnimated:YES completion:nil];
}





-(void)capture_order:(NSString *)token{
    
    [NSThread detachNewThreadSelector:@selector(startAnimating) toTarget:self withObject:nil];
    NSString *title = @"";
    NSString *message = @"";
    BOOL error = NO;
    if (self.config.selected_payment == nil){
        title = [self.config localisedString:@"Payment method is required."];
        error = YES;
        NSDecimalNumber *needtopay = [self.total  decimalNumberByAdding:tax] ;
        if (shipping != nil) needtopay = [[self.total decimalNumberByAdding:tax] decimalNumberByAdding:shipping];
        if ([self.config.store_credit compare:needtopay] == NSOrderedDescending || [self.config.store_credit compare:needtopay] == NSOrderedSame) {
            error = NO;
        }
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
    
    
    
    
    
    NSString *myRequestString = [NSString stringWithFormat:@"app_uuid=%@&user_id=%@&access_token=%@&temp_user_id=%@&name=%@&address=%@&city=%@&state=%@&zip=%@&country=%@&phone=%@&save_address=%d&shipping_id=%@&payment_method_id=%@&total_paying=%@&use_store_credit=%d&wholesale_user_id=%@&location=%@&currency=%@&cached_data=%@&capture_token=%@&is_capture=1", self.config.APP_UUID, uid, self.config.token, tuid, self.config.name, self.config.address, self.config.city, self.config.state, self.config.zip,self.config.country,self.config.phone, self.config.save_address,self.config.chosen_shipping.shipping_id, self.config.selected_payment.payment_method_id,[totalp stringValue], use_credit, wu, self.config.location, self.config.currency, jsonString, token];
    
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
                NSString *message = [self.config localisedString:@"Payment Failed"];
                if (d != nil && [d objectForKey:@"message"] != nil && ![[d objectForKey:@"message"] isKindOfClass:[NSNull class]]) message = [d objectForKey:@"message"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message message:[self.config localisedString:@"Your card is not charged."] delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
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
        
        [indicator stopAnimating];
        
    };
    [connection start];
    
}




-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
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

-(void)startAnimating{
    [indicator startAnimating];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
