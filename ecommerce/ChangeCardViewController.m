//
//  ChangeCardViewController.m
//  Ecommerce
//
//  Created by Hanqing Hu on 7/31/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import "ChangeCardViewController.h"
#import "NSURLConnectionWithTag.h"
#import "IonIcons.h"
#import "ionicons-codes.h"
#import "Design.h"
const int CHANGE_CARD = 1;
@interface ChangeCardViewController ()

@end

@implementation ChangeCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    receivedData = [[NSMutableArray alloc] initWithObjects:[[NSMutableData alloc] init], [[NSMutableData alloc] init],[[NSMutableData alloc] init],nil];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 44)] ;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:17.3];
    
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor colorWithRed:0.302 green:0.302 blue:0.318 alpha:1]; // change this color
    self.navigationItem.titleView = label;
    label.text = [self.config localisedString:@"Credit Card"];
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
    
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    // Setup save button
    UILabel *cartbtn = [[UILabel alloc] init];
    //cartbtn.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    cartbtn.text = [self.config localisedString:@"Save"];
    cartbtn.textAlignment = NSTextAlignmentRight;
    cartbtn.frame = CGRectMake(0, 0, 60, 44);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(save:)];
    [cartbtn addGestureRecognizer:tap];
    cartbtn.userInteractionEnabled = YES;
    UIBarButtonItem *menuBtn2 = [[UIBarButtonItem alloc] initWithCustomView:cartbtn];
    self.navigationItem.rightBarButtonItem = menuBtn2;
    [Design style:[[DOM alloc] initWithView:cartbtn parent:nil] design:[[self.config.design objectForKey:@"design"] objectForKey:@"navigation_icon"] config:self.config];
    
    
    // Setup checkout
    self.stripeView = [[STPView alloc] initWithFrame:CGRectMake(0,0,0,0) andKey:@"pk_live_Th8wG3VsSdRxIIu9lPyXjnPB"];
    self.stripeView.frame = CGRectMake(self.config.screenWidth/2-self.stripeView.paymentView.frame.size.width/2, 74, self.stripeView.paymentView.frame.size.width, self.stripeView.paymentView.frame.size.height);
    //self.stripeView = [[STPView alloc] initWithFrame:CGRectMake(15,74,290,55) andKey:@"pk_test_3R7Hgu5RkdgYT465twg7a3NX"];
    
    self.stripeView.delegate = self;
    
    [self.view addSubview:self.stripeView];
    
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)stripeView:(STPView *)view withCard:(PKCard *)card isValid:(BOOL)valid
{
    // Enable save button if the Checkout is valid
    self.navigationItem.rightBarButtonItem.enabled = valid;
    // saveBtn.enabled = valid;
    
    self.config.card = card;;
    
}

- (IBAction)save:(id)sender
{
    [NSThread detachNewThreadSelector:@selector(threadStartanimating) toTarget:self withObject:nil];
    
    [self.stripeView createToken:^(STPToken *token, NSError *error) {
        
        
        if (error) {
            [self hasError:error];
        } else {
            [self hasToken:token];
        }
    }];
    [indicator stopAnimating];
}

- (void)hasError:(NSError *)error
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Error"]
                                                      message:[error localizedDescription]
                                                     delegate:nil
                                            cancelButtonTitle:[self.config localisedString:@"Close"]
                                            otherButtonTitles:nil];
    [message show];
    
}

- (void)hasToken:(STPToken *)token
{
    //NSLog(@"Received token %@", token.tokenId);
    
    PKCardType cardType = [[PKCardNumber cardNumberWithString:self.config.card.number] cardType];
    NSString *type = @"";
    if (cardType == PKCardTypeAmex) {
        type = @"amex";
    }
    if (cardType == PKCardTypeVisa) {
        type = @"visa";
    }
    if (cardType == PKCardTypeDinersClub) {
        type = @"DC";
    }
    if (cardType == PKCardTypeDiscover) {
        type = @"discover";
    }
    if (cardType == PKCardTypeMasterCard) {
        type = @"mastercard";
    }
    if (cardType == PKCardTypeJCB) {
        type = @"JC";
    }

    
    NSString *myRequestString = [NSString stringWithFormat:@"app_uuid=%@&user_id=%@&access_token=%@&card=%@&save_card_number=%@&exp_month=%ld&exp_year=%ld&cvc=%@&type=%@", self.config.APP_UUID, self.config.user_id, self.config.token, token.tokenId , self.config.card.number, self.config.card.expMonth, self.config.card.expYear, self.config.card.cvc, type];
    
    NSLog(@"%@", myRequestString);
    // Create Data from request
    NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", self.config.API_ROOT, self.config.API_CHANGE_CARD]]];
    
    
    
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
    
    NSMutableData *received = [receivedData objectAtIndex:CHANGE_CARD];
    [received setLength:0];
    NSURLConnectionWithTag *urlConnection = [[NSURLConnectionWithTag alloc] initWithRequest:request delegate:self tag:CHANGE_CARD];
    
}

-(IBAction)savecard:(id)sender{
    self.config.save_card = 1;
}

-(void)threadStartanimating{
    [indicator startAnimating];
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
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Failed to Add Credit Card"] message:@"" delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
        [alert show];
        
        // [indicator stopAnimating];
        
        
    }
    
    
    
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    //[indicator stopAnimating];
    //loading = 0;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Failed to Add Credit Card"] message:@"" delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
    [alert show];
    
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSURLConnectionWithTag *conn = (NSURLConnectionWithTag *)connection;
    NSMutableData *received = [receivedData objectAtIndex:conn.tag];
    
    @try {
        if (conn.tag == CHANGE_CARD){
            NSString *myxml = [[NSString alloc] initWithData:received encoding:NSASCIIStringEncoding];
            NSLog(@"%@", myxml);
            NSDictionary *d = [NSJSONSerialization JSONObjectWithData:received options:0 error:nil];
            int success = [[d objectForKey:@"success"] intValue];
            if (success != 1) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Failed to Add Credit Card"] message:@"" delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
                [alert show];
            } else {
                self.config.stripeCard=[d objectForKey:@"card_number"];
                self.config.stripeID = [d objectForKey:@"id"];
                self.config.stripeToken = [d objectForKey:@"token"];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }
        
        
        
        
        
        
    }
    @catch (NSException *exception) {
        //NSLog(exception.description);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Failed to Add Credit Card"] message:@"" delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
        [alert show];
    }
    @finally {
        //[indicator stopAnimating];
        //loading = 0;
        
        //searchBarState = 0;
    }
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
