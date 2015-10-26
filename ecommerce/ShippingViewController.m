//
//  ShippingViewController.m
//  Ecommerce
//
//  Created by Hanqing Hu on 5/27/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import "ShippingViewController.h"
#import "IonIcons.h"
#import "ionicons-codes.h"
#import "Design.h"
#import "AddressInfoTableViewCell.h"
#import "NSURLConnectionWithTag.h"
@interface ShippingViewController ()

@end

@implementation ShippingViewController

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
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 44)] ;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:17.3];
    
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor colorWithRed:0.302 green:0.302 blue:0.318 alpha:1]; // change this color
    self.navigationItem.titleView = label;
    label.text = [self.config localisedString:@"Shipping Info"];
    //[label sizeToFit];
    [Design navigationbar_title:label config:self.config];
    // Do any additional setup after loading the view from its nib.
    
    shipping_all_country = NO;
    NSMutableArray *s = [[NSMutableArray alloc] init];
    [s addObject:[self.config localisedString:@"Other (Please Type)"]];
    for (ShippingCountry *sc in self.config.shipping){
        if ([sc.code isEqualToString:self.config.location]){
            for (ShippingState *ss in sc.states){
                [s addObject:ss.name];
            }
        }
        if ([sc.code isEqualToString:@"*"]){
            shipping_all_country = YES;
        }
    }
    
    if ([self.config.location isEqualToString:@"US"]){
        states = [NSArray arrayWithObjects: [self.config localisedString:@"Other (Please Type)"],@"Alabama", @"Alaska", @"Arizona", @"Arkansas", @"California", @"Colorado", @"Connecticut", @"Delaware", @"Florida", @"Georgia", @"Hawaii", @"Idaho", @"Illinois", @"Indiana", @"Iowa", @"Kansas", @"Kentucky", @"Louisiana", @"Maine", @"Maryland", @"Massachusetts", @"Michigan", @"Minnesota", @"Mississippi", @"Missouri", @"Montana", @"Nebraska", @"Nevada", @"New Hampshire", @"New Jersey", @"New Mexico", @"New York", @"North Carolina", @"North Dakota", @"Ohio", @"Oklahoma", @"Oregon", @"Pennsylvania", @"Rhode Island", @"South Carolina", @"South Dakota", @"Tennessee", @"Texas", @"Utah", @"Vermont", @"Virginia", @"Washington", @"West Virginia", @"Wisconsin", @"Wyoming", nil];
    } else {
       
        states = s;
    }
    
    
    
    UIView *cartView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    cartView.userInteractionEnabled = YES;
    cartView.clipsToBounds = NO;
    
    UILabel *cartbtn = [[UILabel alloc] init];
    //cartbtn.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    cartbtn.text = [self.config localisedString:@"Save"];
    cartbtn.textAlignment = NSTextAlignmentRight;
    cartbtn.frame = CGRectMake(80-140, 0, 140, 44);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(save:)];
    [cartbtn addGestureRecognizer:tap];
    cartbtn.userInteractionEnabled = YES;
    [Design style:[[DOM alloc] initWithView:cartbtn parent:nil] design:[[self.config.design objectForKey:@"design"] objectForKey:@"navigation_icon"] config:self.config];
    [cartView addSubview:cartbtn];
    
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
    
    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.config.screenWidth, self.config.screenHeight)];
    scroll.contentSize = CGSizeMake(self.config.screenWidth, self.config.screenHeight+150);
    scroll.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:scroll belowSubview:indicator];
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.config.screenWidth, self.config.screenHeight) style:UITableViewStylePlain];
    table.separatorColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1];
    table.rowHeight = 57.3;
    table.delegate = self;
    table.dataSource = self;
    table.tag = -1;
    [scroll addSubview:table];
    
    
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
    
    if (self.is_setting){
        samerow = 0;
        saveasrow = -1;
        namerow = 1;
        addrrow = 2;
        cityrow = 3;
        staterow = 4;
        ziprow = 5;
        countryrow = 6;
        phonerow = 7;
    } else {
        samerow = 0;
        saveasrow = 1;
        namerow = 2;
        addrrow = 3;
        cityrow = 4;
        staterow = 5;
        ziprow = 6;
        countryrow = 7;
        phonerow = 8;
        
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (name != nil) [name resignFirstResponder];
    if (address != nil)[address resignFirstResponder];
    if (state != nil)[state resignFirstResponder];
    if (zip != nil)[zip resignFirstResponder];
    if (city != nil)[city resignFirstResponder];
    if (country != nil)[country resignFirstResponder];
    if (phone != nil)[phone resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == state) {
        state.inputView = statepicker;
        state.inputAccessoryView = picker_view;
        [statepicker selectRow:0 inComponent:0 animated:NO];
    }
    if (textField == country) {
        country.inputView = statepicker;
        country.inputAccessoryView = picker_view;
        [countrypicker selectRow:0 inComponent:0 animated:NO];
        //[scroll setContentOffset:CGPointMake(scroll.contentOffset.x, 0) animated:YES];
    }
    if (textField == phone) {
        //[scroll setContentOffset:CGPointMake(scroll.contentOffset.x, 0) animated:YES];
    }
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == country && scroll.contentOffset.y < 70){
        [scroll setContentOffset:CGPointMake(scroll.contentOffset.x, 70) animated:YES];
    }if (textField == phone && scroll.contentOffset.y < 140){
        [scroll setContentOffset:CGPointMake(scroll.contentOffset.x, 140) animated:YES];
    }
}


-(IBAction)samesel:(id)sender {
    UISwitch *sw = (UISwitch *)sender;
    if (!sw.isOn) return;
    
    if (self.config.selected_payment == nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"No billing address found"] message:nil delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    // self.config.name = self.config.billingname;
    name.text = [NSString stringWithFormat:@"%@ %@", self.config.selected_payment.billingfirstname, self.config.selected_payment.billinglastname];
    // self.config.address=self.config.billingaddress;
    address.text = self.config.selected_payment.billingaddress;
    // self.config.city = self.config.billingcity;
    city.text = self.config.selected_payment.billingcity;
    // self.config.state=self.config.billingstate;
    state.text = self.config.selected_payment.billingstate;
    //  self.config.zip=self.config.billingzip;
    zip.text = self.config.selected_payment.billingzip;
    //self.config.country = self.config.billingcountry;
    country.text = [self.config.codetocountry objectForKey:self.config.selected_payment.billingcountry];
    
    
    
}

-(IBAction)save:(id)sender{
    if (name.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Name is required."] message:nil delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if (address.text.length == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Address is required."] message:nil delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
        [alert show];
        return;
    }
    if (state.text.length == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"State is required."] message:nil delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
        [alert show];
        return;
    }
    if (city.text.length == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"City is required."] message:nil delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
        [alert show];
        return;
    }
    if (zip.text.length == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Zip is required."] message:nil delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
        [alert show];
        return;
    }
    if (country.text.length == 0 && [self.config.countrytocode objectForKey:country.text] == nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Country is required."] message:nil delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
        [alert show];
        return;
    }
    int countryfound = 0;
    int statefound = 0;
    
    for (ShippingCountry *sc in self.config.shipping){
        if ([sc.code isEqualToString:[self.config.countrytocode objectForKey:country.text]]){
            countryfound = 1;
            for (ShippingState *ss in sc.states){
                if ([[ss.name lowercaseString] isEqualToString:[state.text lowercaseString]] || [[ss.code lowercaseString] isEqualToString:[state.text lowercaseString]]){
                    statefound = 1;
                }
            }
        }
        if ([sc.code isEqualToString:@"*"]){
            countryfound = 1;
        }
    }
    if (countryfound == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Shipping country is not supported."] message:nil delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
        [alert show];
        return;
    }
    if (statefound == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Shipping state is not valid."] message:nil delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    
    
    self.config.name = name.text;
    self.config.state = state.text;
    self.config.city = city.text;
    self.config.address = address.text;
    self.config.zip = zip.text;
    self.config.country = [self.config.countrytocode objectForKey:country.text];
    
    self.config.phone = phone.text;
    if (save.isOn || self.is_setting ){
        self.config.save_address = 1;
        [self save_address];
    } else self.config.save_address = 0;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)save_address{
    NSString *myRequestString = [NSString stringWithFormat:@"app_uuid=%@&user_id=%@&access_token=%@&name=%@&address=%@&city=%@&state=%@&country=%@&zip=%@&phone=%@&address_type=%@", self.config.APP_UUID, self.config.user_id, self.config.token, self.config.name, self.config.address, self.config.city, self.config.state, self.config.country, self.config.zip, self.config.phone, @"shipping"];
    
    // Create Data from request
    NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", self.config.API_ROOT, self.config.API_SAVE_ADDRESS]]];
    
    
    
    // set Request Type
    [request setHTTPMethod: @"POST"];
    // Set content-type
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    // Set Request Body
    [request setHTTPBody: myRequestData];
    
    NSURLConnectionWithTag *urlConnection = [[NSURLConnectionWithTag alloc] initWithRequest:request delegate:self tag:1];
}

-(IBAction)cancel:(id)sender {
    [state resignFirstResponder];
    [country resignFirstResponder];
}

-(IBAction)done:(id)sender{
    if ([state isFirstResponder]){
        if ([statepicker selectedRowInComponent:0] > 0){
            NSString *s = [states objectAtIndex:[statepicker selectedRowInComponent:0]];
            state.text = s;
            [state resignFirstResponder];
        } else if ([statepicker selectedRowInComponent:0] == 0){
            [state resignFirstResponder];
            state.inputView = nil;
            state.inputAccessoryView = nil;
            [state becomeFirstResponder];
        }
    } else if ([country isFirstResponder]){
        if (shipping_all_country) {
        NSString *s = [self.config.countries objectAtIndex:[countrypicker selectedRowInComponent:0]];
        country.text = s;
        } else {
            ShippingCountry *sc = [self.config.shipping objectAtIndex:[countrypicker selectedRowInComponent:0]];
            country.text = sc.name;
        }
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
    if (pickerView == statepicker) return [states objectAtIndex:row];
    else if (pickerView == countrypicker){
        if (shipping_all_country) return [self.config.countries objectAtIndex:row];
        else {
            ShippingCountry *sc = [self.config.shipping objectAtIndex:row];
            return sc.name;
        }
    } else return @"";
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == statepicker) return states.count;
    else if (pickerView == countrypicker){
        if (shipping_all_country)return self.config.countries.count;
        else return self.config.shipping.count;
    }
    else return  0;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    if (self.is_setting)
        return 8;
    else return 9;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AddressInfoTableViewCell *cell = [[AddressInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] ;
    cell.sw.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == samerow){
        cell.bigTitle.text = [self.config localisedString:@"Same as Billing Address?"];
        cell.value.hidden = YES;
        [cell.sw addTarget:self action:@selector(samesel:) forControlEvents:UIControlEventValueChanged];
        [cell.sw setOn:NO];
        cell.sw.hidden = NO;
    }if (indexPath.row == saveasrow){
        cell.bigTitle.text = [self.config localisedString:@"Save as Default"];
        cell.value.hidden = YES;
        [cell.sw setOn:NO];
        save = cell.sw;
        cell.sw.hidden = NO;
    }if (indexPath.row == namerow){
        cell.smallTitle.text =[NSString stringWithFormat:@"%@", [self.config localisedString:@"Name"]];
        cell.value.delegate = self;
        if (cell.value.text.length == 0)
            cell.value.text = self.config.name;
        name = cell.value;
        cell.sw.hidden = YES;
    }if (indexPath.row == addrrow){
        cell.smallTitle.text = [self.config localisedString:@"Address"];
        cell.value.delegate = self;
        if (cell.value.text.length == 0)
            cell.value.text = self.config.address;
        address = cell.value;
        cell.sw.hidden = YES;
    }if (indexPath.row == cityrow){
        cell.smallTitle.text = [self.config localisedString:@"City"];
        cell.value.delegate = self;
        if (cell.value.text.length == 0)
            cell.value.text = self.config.city;
        city = cell.value;
        cell.sw.hidden = YES;
    }if (indexPath.row == staterow){
        cell.smallTitle.text = [self.config localisedString:@"State"];
        cell.value.delegate = self;
        if (cell.value.text.length == 0)
            cell.value.text = self.config.state;
        state = cell.value;
        state.inputView = statepicker;
        state.inputAccessoryView = picker_view;
        cell.sw.hidden = YES;
        
    }if (indexPath.row == ziprow){
        cell.smallTitle.text = [self.config localisedString:@"Zip"];
        cell.value.delegate = self;
        if (cell.value.text.length == 0)
            cell.value.text = self.config.zip;
        zip = cell.value;
        zip.keyboardType = UIKeyboardTypeDecimalPad;
        cell.sw.hidden = YES;
        
    }if (indexPath.row == countryrow){
        cell.smallTitle.text = [self.config localisedString:@"Country"];
        cell.value.delegate = self;
        if (cell.value.text.length == 0)
            cell.value.text = [self.config.codetocountry objectForKey:self.config.country];
        country = cell.value;
        country.inputView = countrypicker;
        country.inputAccessoryView = picker_view;
        cell.sw.hidden = YES;
        
    }if (indexPath.row == phonerow){
        cell.smallTitle.text = [self.config localisedString:@"Phone"];
        cell.value.delegate = self;
        if (cell.value.text.length == 0)
            cell.value.text = self.config.phone;
        phone = cell.value;
        phone.keyboardType = UIKeyboardTypeDecimalPad;
        cell.sw.hidden = YES;
        
        if (tableView.tag == -1){
            tableView.contentSize = CGSizeMake(tableView.contentSize.width, tableView.contentSize.height+200);
            tableView.tag = -2;
        }
        
    }
    
    
    
    
    return cell;
    
    
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

-(void)back{
    /* self.config.name = name.text;
     self.config.state = state.text;
     self.config.city = city.text;
     self.config.address = address.text;
     self.config.zip = zip.text;
     self.config.country = [self.config.countrytocode objectForKey:country.text];
     if (sw.isOn){
     self.config.save_address = 1;
     } else self.config.save_address = 0;*/
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)indicatorStart{
    [indicator startAnimating];
}

@end
