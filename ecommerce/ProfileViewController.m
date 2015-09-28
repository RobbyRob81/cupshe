//
//  SettingsViewController.m
//  Ecommerce
//
//  Created by Hanqing Hu on 7/23/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import "ProfileViewController.h"
#import "SettingsTableViewCell.h"
#import "NSURLConnectionWithTag.h"
#import "IonIcons.h"
#import "ionicons-codes.h"
#import "Design.h"
@interface ProfileViewController ()

@end

@implementation ProfileViewController

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
    label.text = [self.config localisedString:@"Settings"];
    //[label sizeToFit];
    [Design navigationbar_title:label config:self.config];
    // Do any additional setup after loading the view from its nib.
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
    
    
    
    received = [[NSMutableData alloc] init];
    profile = [[NSMutableDictionary alloc] init];
    cache = [[NSMutableDictionary alloc] init];
    NSString *email = self.config.email;
    if (self.config.email == nil) email = @"";
    [profile setObject:email forKey:@"email"  ];
    [profile setObject:@"*****" forKey:@"password"  ];
    
    /*NSString *name = self.config.name;
    if (self.config.name == nil) name = @"";
    //[profile setObject:name forKey:@"name"];
    NSString *addr = self.config.address;
    if (self.config.address == nil) addr = @"";
    //[profile setObject:addr forKey:@"address"  ];
    NSString *city = self.config.city;
    if (self.config.city == nil) city = @"";
   // [profile setObject:city forKey:@"city"  ];
    NSString *state = self.config.state;
    if (self.config.state == nil) state = @"";
   // [profile setObject:state forKey:@"state"  ];
    NSString *country = self.config.country;
    if (self.config.country == nil) country = @"";
   // [profile setObject:country forKey:@"country"  ];
    NSString *zip = self.config.zip;
    if (self.config.zip == nil) zip = @"";
   //[profile setObject:zip forKey:@"zip"  ];
    states = [NSArray arrayWithObjects:@"Alabama", @"Alaska", @"Arizona", @"Arkansas", @"California", @"Colorado", @"Connecticut", @"Delaware", @"Florida", @"Georgia", @"Hawaii", @"Idaho", @"Illinois", @"Indiana", @"Iowa", @"Kansas", @"Kentucky", @"Louisiana", @"Maine", @"Maryland", @"Massachusetts", @"Michigan", @"Minnesota", @"Mississippi", @"Missouri", @"Montana", @"Nebraska", @"Nevada", @"New Hampshire", @"New Jersey", @"New Mexico", @"New York", @"North Carolina", @"North Dakota", @"Ohio", @"Oklahoma", @"Oregon", @"Pennsylvania", @"Rhode Island", @"South Carolina", @"South Dakota", @"Tennessee", @"Texas", @"Utah", @"Vermont", @"Virginia", @"Washington", @"West Virginia", @"Wisconsin", @"Wyoming", nil];*/
    
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    
    return [profile count];
    
    
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) return [self.config localisedString:@"Login Information"];
        return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    
    SettingsTableViewCell *cell = [[SettingsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0){
        cell.primaryLabel.text = [self.config localisedString:@"Email"];
        cell.primary_right.text = [profile objectForKey:@"email"];
        cell.rightBut.hidden = YES;
        cell.rightseg.hidden = YES;
    }if (indexPath.row == 1){
        cell.primaryLabel.text = [self.config localisedString:@"Password"];
        cell.primary_right.text = [profile objectForKey:@"password"];
        cell.rightBut.hidden = YES;
        cell.rightseg.hidden = YES;
    }/*if (indexPath.row == 2){
        cell.primaryLabel.text = @"Name";
        cell.primary_right.text = [profile objectForKey:@"name"];
        cell.rightBut.hidden = YES;
        cell.rightseg.hidden = YES;
    }if (indexPath.row == 3){
        cell.primaryLabel.text = @"Address";
        cell.primary_right.text = [profile objectForKey:@"address"];
        cell.rightBut.hidden = YES;
        cell.rightseg.hidden = YES;
    }if (indexPath.row == 4){
        cell.primaryLabel.text = @"City";
        cell.primary_right.text = [profile objectForKey:@"city"];
        cell.rightBut.hidden = YES;
        cell.rightseg.hidden = YES;
        
    }if (indexPath.row == 5){
        cell.primaryLabel.text = @"State";
        cell.primary_right.text = [profile objectForKey:@"state"];
        cell.rightBut.hidden = YES;
        cell.rightseg.hidden = YES;
        
    }if (indexPath.row == 6){
        cell.primaryLabel.text = @"Country";
        cell.primary_right.text = [self.config.codetocountry objectForKey:[profile objectForKey:@"country"]];
        cell.rightBut.hidden = YES;
        cell.rightseg.hidden = YES;
        
    }if (indexPath.row == 7){
        cell.primaryLabel.text = @"Zip";
        cell.primary_right.text = [profile objectForKey:@"zip"];
        cell.rightBut.hidden = YES;
        cell.rightseg.hidden = YES;
        
    }*/
    
    return cell;
    
    
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0){
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:[self.config localisedString:@"Change Email"] message:nil delegate:self cancelButtonTitle:[self.config localisedString:@"Cancel"] otherButtonTitles:[self.config localisedString:@"Save"], nil];
        av.alertViewStyle = UIAlertViewStylePlainTextInput;
        [av textFieldAtIndex:0].text = self.config.email;
        [av textFieldAtIndex:0].clearButtonMode = UITextFieldViewModeWhileEditing;
        av.tag = 1;
        [av show];
    }if (indexPath.row == 1){
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:[self.config localisedString:@"Change Password"] message:nil delegate:self cancelButtonTitle:[self.config localisedString:@"Cancel"] otherButtonTitles:[self.config localisedString:@"Save"], nil];
        av.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        [av textFieldAtIndex:0].placeholder = [self.config localisedString:@"Old Password"];
        [av textFieldAtIndex:1].placeholder = [self.config localisedString:@"New Password (At lease 5 characters)"];
        [av textFieldAtIndex:0].clearButtonMode = UITextFieldViewModeWhileEditing;
        [av textFieldAtIndex:1].clearButtonMode = UITextFieldViewModeWhileEditing;
        [av textFieldAtIndex:0].secureTextEntry = YES;
        [av textFieldAtIndex:0].secureTextEntry = YES;
        av.tag = 2;
        [av show];
    }/*if (indexPath.row == 2){
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Change Name" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        av.alertViewStyle = UIAlertViewStylePlainTextInput;
        [av textFieldAtIndex:0].text = self.config.name;
        [av textFieldAtIndex:0].clearButtonMode = UITextFieldViewModeWhileEditing;
        av.tag = 3;
        [av show];
    }if (indexPath.row == 3){
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Change Address" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        av.alertViewStyle = UIAlertViewStylePlainTextInput;
        [av textFieldAtIndex:0].text = self.config.address;
        [av textFieldAtIndex:0].clearButtonMode = UITextFieldViewModeWhileEditing;
        av.tag = 4;
        [av show];
    }if (indexPath.row == 4){
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Change City" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        av.alertViewStyle = UIAlertViewStylePlainTextInput;
        [av textFieldAtIndex:0].text = self.config.city;
        [av textFieldAtIndex:0].clearButtonMode = UITextFieldViewModeWhileEditing;
        av.tag = 5;
        [av show];
    }if (indexPath.row == 5){
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Select State" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        av.alertViewStyle = UIAlertViewStylePlainTextInput;
        [av textFieldAtIndex:0].text = self.config.state;
        [av textFieldAtIndex:0].clearButtonMode = UITextFieldViewModeWhileEditing;
        [av textFieldAtIndex:0].inputView = picker;
        //[av textFieldAtIndex:0].inputAccessoryView = picker_view;
        state_text = [av textFieldAtIndex:0];
        av.tag = 6;
        [av show];
    }
    if (indexPath.row == 6){
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Select Country" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        av.alertViewStyle = UIAlertViewStylePlainTextInput;
        [av textFieldAtIndex:0].text = [self.config.codetocountry objectForKey: self.config.country];
        [av textFieldAtIndex:0].clearButtonMode = UITextFieldViewModeWhileEditing;
        [av textFieldAtIndex:0].inputView = countrypicker;
        //[av textFieldAtIndex:0].inputAccessoryView = picker_view;
        country_text = [av textFieldAtIndex:0];
        av.tag = 7;
        [av show];
    }
    if (indexPath.row == 7){
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Change Zip" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        av.alertViewStyle = UIAlertViewStylePlainTextInput;
        [av textFieldAtIndex:0].text = self.config.zip;
        [av textFieldAtIndex:0].clearButtonMode = UITextFieldViewModeWhileEditing;
        [av textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
        av.tag = 8;
        [av show];
    }*/
    
}
/*-(IBAction)changegender:(id)sender{
    UISegmentedControl *sw = (UISegmentedControl *)sender;
    if (sw.selectedSegmentIndex == 0) {
        [self sendEdit:@"1" for_field:@"Gender" witholdpassword:@"" andnewpassword:@""];
        [profile setObject:@"1" forKey:@"gender"];
        [cache setObject:@"1" forKey:@"gender"];
    } else {
        [self sendEdit:@"2" for_field:@"Gender" witholdpassword:@"" andnewpassword:@""];
        [profile setObject:@"2" forKey:@"gender"];
        [cache setObject:@"2" forKey:@"gender"];
    }
    [table reloadData];
}
-(IBAction)changesub:(id)sender{
    UISwitch *sw = (UISwitch *)sender;
    if (sw.isOn) {
        [self sendEdit:@"1" for_field:@"Subscribe" witholdpassword:@"" andnewpassword:@""];
        [profile setObject:@"1" forKey:@"subscribe"];
        [cache setObject:@"1" forKey:@"subscribe"];
    } else {
        [self sendEdit:@"0" for_field:@"Subscribe" witholdpassword:@"" andnewpassword:@""];
        [profile setObject:@"0" forKey:@"subscribe"];
        [cache setObject:@"0" forKey:@"subscribe"];
    }
    [table reloadData];
}*/
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1){
        if (buttonIndex == 1){
            NSString *email = [alertView textFieldAtIndex:0].text;
            if (email == nil || email.length == 0){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Invalid Email"] message:nil delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
                alert.tag = -1;
                [alert show];
                return;
            }
            [self sendEdit:email for_field:@"email" witholdpassword:@"" andnewpassword:@""];
            [profile setObject:[self.config localisedString:@"Updating"] forKey:@"email"];
            [cache setObject:email forKey:@"email"];
            
        }
        
    }if (alertView.tag == 2){
        if (buttonIndex == 1){
            NSString *oldpass = [alertView textFieldAtIndex:0].text;
            NSString *newpass = [alertView textFieldAtIndex:1].text;
            if (oldpass == nil || oldpass.length < 5){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Invalid Old Password"] message:nil delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
                alert.tag = -1;
                [alert show];
                return;
            }
            if (newpass == nil || newpass.length < 5){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Invalid New Password"] message:nil delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
                alert.tag = -1;
                [alert show];
                return;
            }
            [self sendEdit:newpass for_field:@"password" witholdpassword:oldpass andnewpassword:newpass];
            [profile setObject:[self.config localisedString:@"Updating"] forKey:@"password"];
        }
        
    }/*if (alertView.tag == 3){
        if (buttonIndex == 1){
            NSString *name = [alertView textFieldAtIndex:0].text;
            if (name == nil || name.length == 0){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Name" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                alert.tag = -1;
                [alert show];
                return;
            }
            [self sendEdit:name for_field:@"name" witholdpassword:@"" andnewpassword:@""];
            [profile setObject:@"Updating" forKey:@"name"];
            [cache setObject:name forKey:@"name"];
        }
    }if (alertView.tag == 4){
        if (buttonIndex == 1){
            NSString *name = [alertView textFieldAtIndex:0].text;
            if (name == nil || name.length == 0){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Address" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                alert.tag = -1;
                [alert show];
                return;
            }
            [self sendEdit:name for_field:@"address" witholdpassword:@"" andnewpassword:@""];
            [profile setObject:@"Updating" forKey:@"address"];
            [cache setObject:name forKey:@"address"];
        }
    }if (alertView.tag == 5){
        if (buttonIndex == 1){
            NSString *name = [alertView textFieldAtIndex:0].text;
            if (name == nil || name.length == 0){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid City" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                alert.tag = -1;
                [alert show];
                return;
            }
            [self sendEdit:name for_field:@"city" witholdpassword:@"" andnewpassword:@""];
            [profile setObject:@"Updating" forKey:@"city"];
            [cache setObject:name forKey:@"city"];
        }
    }if (alertView.tag == 6){
        if (buttonIndex == 1){
            NSString *name = [alertView textFieldAtIndex:0].text;
            if (name == nil || name.length == 0){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid State" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                alert.tag = -1;
                [alert show];
                return;
            }
            [self sendEdit:name for_field:@"state" witholdpassword:@"" andnewpassword:@""];
            [profile setObject:@"Updating" forKey:@"state"];
            [cache setObject:name forKey:@"state"];
        }
    }if (alertView.tag == 7){
        if (buttonIndex == 1){
            NSString *name = [alertView textFieldAtIndex:0].text;
            name = [self.config.countrytocode objectForKey:name];
            if (name == nil || name.length == 0){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Country" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                alert.tag = -1;
                [alert show];
                return;
            }
            [self sendEdit:name for_field:@"country" witholdpassword:@"" andnewpassword:@""];
            [profile setObject:@"Updating" forKey:@"country"];
            [cache setObject:name forKey:@"country"];
        }
    }if (alertView.tag == 8){
        if (buttonIndex == 1){
            NSString *name = [alertView textFieldAtIndex:0].text;
            if (name == nil || name.length == 0){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Zip" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                alert.tag = -1;
                [alert show];
                return;
            }
            [self sendEdit:name for_field:@"zip" witholdpassword:@"" andnewpassword:@""];
            [profile setObject:@"Updating" forKey:@"zip"];
            [cache setObject:name forKey:@"zip"];
        }
    }*/
    [table reloadData];
}

-(void)sendEdit:(NSString *)edit for_field:(NSString *)field witholdpassword:(NSString *)old andnewpassword:(NSString *)pass{
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating) toTarget:self withObject:nil];
    

    
    NSString *myRequestString = [NSString stringWithFormat:@"user_id=%@&access_token=%@&app_uuid=%@&field_name=%@&field_value=%@&old_password=%@", self.config.user_id, self.config.token,self.config.APP_UUID,field, edit, old];
    
    NSLog(@"%@", myRequestString);
    // Create Data from request
    NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", self.config.API_ROOT, self.config.API_USER_SETTING]]];
    
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
    [received setLength:0];
    NSURLConnectionWithTag *urlConnection = [[NSURLConnectionWithTag alloc] initWithRequest:request delegate:self tag:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    @try {
        NSURLConnectionWithTag *conn = (NSURLConnectionWithTag *)connection;
        if (conn.tag == 0)
            [received appendData:data];
        
        
    }
    @catch (NSException *exception) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Cannot Connect to Internet"] message:@"" delegate:self cancelButtonTitle:[self.config localisedString:@"Cancel"] otherButtonTitles:nil];
        
        [alert show];
        
    }
    
    
    
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSURLConnectionWithTag *conn = (NSURLConnectionWithTag *)connection;
    //NSLog(@"%d", conn.tag);
    @try {
        if (conn.tag == 0){
             NSString *myxml = [[NSString alloc] initWithData:received encoding:NSASCIIStringEncoding];
             NSLog(@"%@", myxml);
            
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:received options:0 error:nil];
            NSString *field = [dic objectForKey:@"field"];
            int success = [[dic objectForKey:@"success"] intValue];
            
            
           /* if ([field isEqualToString:@"name"]){
                if (success == 1){
                    NSString *name = [cache objectForKey:@"name"];
                    [profile setObject:name forKey:@"name"];
                    self.config.name = name;
                } else {
                    NSString *error = [dic objectForKey:@"error"];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:error message:nil delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
                    alert.tag = -1;
                    [alert show];
                    [profile setObject:self.config.name forKey:field];
                    return;
                    
                }
            }if ([field isEqualToString:@"address"]){
                if (success == 1){
                    NSString *addr = [cache objectForKey:@"address"];
                    [profile setObject:addr forKey:@"address"];
                    self.config.address = addr;
                } else {
                    NSString *error = [dic objectForKey:@"error"];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:error message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    alert.tag = -1;
                    [alert show];
                    [profile setObject:self.config.address forKey:field];
                    return;
                    
                }
            }if ([field isEqualToString:@"city"]){
                if (success == 1){
                    NSString *city = [cache objectForKey:@"city"];
                    [profile setObject:city forKey:@"city"];
                    self.config.city = city;
                } else {
                    NSString *error = [dic objectForKey:@"error"];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:error message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    alert.tag = -1;
                    [alert show];
                    [profile setObject:self.config.city forKey:field];
                    return;
                    
                }
            }if ([field isEqualToString:@"state"]){
                if (success == 1){
                    NSString *state = [cache objectForKey:@"state"];
                    [profile setObject:state forKey:@"state"];
                    self.config.state = state;
                } else {
                    NSString *error = [dic objectForKey:@"error"];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:error message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    alert.tag = -1;
                    [alert show];
                    [profile setObject:self.config.state forKey:field];
                    return;
                    
                }
            }if ([field isEqualToString:@"country"]){
                if (success == 1){
                    NSString *country = [cache objectForKey:@"country"];
                    [profile setObject:country forKey:@"country"];
                    self.config.country = country;
                } else {
                    NSString *error = [dic objectForKey:@"error"];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:error message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    alert.tag = -1;
                    [alert show];
                    [profile setObject:self.config.country forKey:field];
                    return;
                    
                }
            }if ([field isEqualToString:@"zip"]){
                if (success == 1){
                    NSString *zip = [cache objectForKey:@"zip"];
                    [profile setObject:zip forKey:@"zip"];
                    self.config.zip = zip;
                } else {
                    NSString *error = [dic objectForKey:@"error"];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:error message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    alert.tag = -1;
                    [alert show];
                    [profile setObject:self.config.zip forKey:field];
                    return;
                    
                }
            }*/if ([field isEqualToString:@"email"]){
                if (success == 1){
                    NSString *email = [cache objectForKey:@"email"];
                    [profile setObject:email forKey:@"email"];
                    self.config.email = email;
                    [self.config save_default];
                } else {
                    NSString *error = [dic objectForKey:@"error"];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Email taken or invalid"] message:nil delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
                    alert.tag = -1;
                    [alert show];
                    [profile setObject:self.config.email forKey:field];
                    return;
                    
                }
            }if ([field isEqualToString:@"password"]){
                if (success == 1){
                    [profile setObject:[self.config localisedString:@"Updated"] forKey:@"password"];
                } else {
                    NSString *error = [dic objectForKey:@"error"];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Invalid Password"] message:nil delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
                    alert.tag = -1;
                    [alert show];
                    [profile setObject:[self.config localisedString:@"Update failed"] forKey:field];
                    return;
                }
            }
            
            [table reloadData];
            
            [indicator stopAnimating];
        }
    }
    @catch (NSException *exception) {
        
    }
    
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == picker){
        NSString *s = [states objectAtIndex:row];
        state_text.text = s;
    } else {
        country_text.text = [self.config.countries objectAtIndex:row];
    }
    //[state_text resignFirstResponder];
}



- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == picker)
    return [states objectAtIndex:row];
    else return [self.config.countries objectAtIndex:row];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == picker)
    return states.count;
    else return self.config.countries.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


-(void)threadStartAnimating{
    [indicator startAnimating];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
