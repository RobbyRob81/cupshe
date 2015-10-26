//
//  ShippingMethodViewController.m
//  Ecommerce
//
//  Created by Hanqing Hu on 7/14/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import "ShippingMethodViewController.h"
#import "ShippingMethodTableViewCell.h"
#import "Cart.h"
#import "IonIcons.h"
#import "ionicons-codes.h"
#import "Design.h"
#import "NSURLConnectionBlock.h"
@interface ShippingMethodViewController ()

@end

@implementation ShippingMethodViewController

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
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 44)] ;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:17.3];
    
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor colorWithRed:0.302 green:0.302 blue:0.318 alpha:1]; // change this color
    self.navigationItem.titleView = label;
    label.text = [self.config localisedString:@"Shipping Method"];
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
    
    table.separatorColor = [UIColor colorWithRed:157/255.0 green:157/255.0 blue:157/255.0 alpha:1];
    
    if (self.config.shipping.count == 0){
        [self load_shipping];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    if (self.config.country == nil || self.config.country.length == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Please provide shipping address"] message:@"" delegate:self cancelButtonTitle:[self.config localisedString:@"Back"] otherButtonTitles: nil];
        [alert show];
        return;
    } else {
        BOOL found = false;
        
        ShippingCountry *all = nil;
        for (ShippingCountry *sc in self.config.shipping){
            if ([sc.code isEqualToString:self.config.country]){
                shipping = sc.shippings;
                found = true;
            }
            if ([sc.code isEqualToString:@"*"]) {
                all = sc;
            }
        }
        if (!found && all!= nil){
            shipping = all.shippings;
        }
    }
    [table reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)load_shipping{
    if (self.config.shipping.count == 0){
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.frame = CGRectMake(self.config.screenWidth/2-indicator.frame.size.width/2, self.config.screenHeight/2-indicator.frame.size.height/2, indicator.frame.size.width, indicator.frame.size.height);
        indicator.hidesWhenStopped = YES;
        [indicator startAnimating];
        [self.view addSubview:indicator];
        
    NSString *myRequestString = [NSString stringWithFormat:@"app_uuid=%@&user_id=%@&token=%@&address=%@&city=%@&state=%@&zip=%@&country=%@&name=%@&phone=%@&location=%@&currency=%@", self.config.APP_UUID, self.config.user_id, self.config.token, self.config.address, self.config.city, self.config.state, self.config.zip, self.config.country, self.config.name, self.config.phone, self.config.location, self.config.currency];
    
    // Create Data from request
        NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", self.config.API_ROOT, self.config.API_SHIPPING_AND_TAX]]];
        
        
        
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
                if ([dic objectForKey:@"source"] != nil);
                {
                    if ([[dic objectForKey:@"source"] isEqualToString:@"magento"]){
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Please provide shipping address"] message:@"" delegate:self cancelButtonTitle:[self.config localisedString:@"Back"] otherButtonTitles: nil];
                        [alert show];
                        return;
                    }
                }
                NSArray *shipping = [dic objectForKey:@"shipping"];
                for (NSDictionary *d in shipping){
                    Shipping *s = [[Shipping alloc] init];
                    [s shipping_from_dictionary:d];
                    [self.config.shipping addObject:s];
                }
                
                [table reloadData];
                
                
            } else {
                //There was an error
                
            }
            [indicator stopAnimating];
        };
        [connection start];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    
    return shipping.count;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Shipping *s = [shipping objectAtIndex:indexPath.row];
    ShippingMethodTableViewCell *cell = [[ShippingMethodTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
   cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.primaryLabel.text = s.name;
    NSDecimalNumber *price = [s claculate_shipping:self.config.cart totalprice:self.totalprice];
    if (price == nil) cell.primary_right.text = @"N/A";
    else if ([price compare:[NSNumber numberWithInt:0]] == NSOrderedSame) cell.primary_right.text = [self.config localisedString:@"Free"];
    else cell.primary_right.text = [NSString stringWithFormat:@"%@%@", [self.config getCurrencySymbol], [price stringValue]];
    
    
    return cell;
   
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Shipping *s = [shipping objectAtIndex:indexPath.row];
    NSDecimalNumber * price = [s claculate_shipping:self.config.cart totalprice:self.totalprice];
    if (price == nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Shipping unavailable"] message:@"" delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
        [alert show];
    }
    else {
        self.config.chosen_shipping = s;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    
    return NO;
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
