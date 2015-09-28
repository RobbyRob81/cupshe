//
//  AddCardViewController.m
//  Ecommerce
//
//  Created by Hanqing Hu on 5/27/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import "AddCardViewController.h"
#import "IonIcons.h"
#import "ionicons-codes.h"
#import "Design.h"
#import "NSURLConnectionBlock.h"
@interface AddCardViewController ()

@end

@implementation AddCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.enable_savecard = YES;
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
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 44)] ;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:17.3];
    
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor colorWithRed:0.302 green:0.302 blue:0.318 alpha:1]; // change this color
    self.navigationItem.titleView = label;
    label.text = [self.config localisedString:[self.config localisedString:@"Credit Card"]];
    //[label sizeToFit];
    [Design navigationbar_title:label config:self.config];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    // Setup save button
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
    
    UIBarButtonItem *barbtn2 = [[UIBarButtonItem alloc] initWithCustomView:cartbtn];
    
    
    self.navigationItem.rightBarButtonItem = barbtn2;
    
    
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
    
    savecardlabel.text = [self.config localisedString:@"Save Card"];
    
    
    // Setup checkout
    
    self.stripeView = [[STPView alloc] initWithFrame:CGRectMake(0,0,0,0) andKey:@"pk_live_Th8wG3VsSdRxIIu9lPyXjnPB"];
    self.stripeView.frame = CGRectMake(self.config.screenWidth/2-self.stripeView.paymentView.frame.size.width/2, 74, self.stripeView.paymentView.frame.size.width, self.stripeView.paymentView.frame.size.height);
    
    //self.stripeView = [[STPView alloc] initWithFrame:CGRectMake(15,74,290,55) andKey:@"pk_test_3R7Hgu5RkdgYT465twg7a3NX"];
    
    self.stripeView.delegate = self;
    
    [self.view addSubview:self.stripeView];
    
    if (!self.enable_savecard){
        savecard.hidden = YES;
        savecardlabel.hidden = YES;
    }
    
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
    
    STPCard *card = [[STPCard alloc] init];
    card.number = self.stripeView.paymentView.card.number;
    card.expMonth = self.stripeView.paymentView.card.expMonth;
    card.expYear = self.stripeView.paymentView.card.expYear;
    card.cvc = self.stripeView.paymentView.card.cvc;
    
    
    
    [Stripe createTokenWithCard:card completion:^(STPToken *token, NSError *error) {
        
        
        if (error) {
            [self hasError:error];
        } else {
            [self hasToken:token];
        }
    }];
    
     /*[card createToken:^(STPToken *token, NSError *error) {
    
     
     if (error) {
     [self hasError:error];
     } else {
     [self hasToken:token];
     }
     }];*/
    [indicator stopAnimating];
}

- (void)hasError:(NSError *)error
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Error"]
                                                      message:[error localizedDescription]
                                                     delegate:nil
                                            cancelButtonTitle:[self.config localisedString:@"OK"]
                                            otherButtonTitles:nil];
    [message show];
    
}

- (void)hasToken:(STPToken *)token
{
    //NSLog(@"Received token %@", token.tokenId);
    
    /*NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://example.com"]];
    request.HTTPMethod = @"POST";
    NSString *body     = [NSString stringWithFormat:@"stripeToken=%@", token.tokenId];
    request.HTTPBody   = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
     
     [NSURLConnection sendAsynchronousRequest:request
     queue:[NSOperationQueue mainQueue]
     completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
     [MBProgressHUD hideHUDForView:self.view animated:YES];
     
     //                               if (error) {
     //                                   [self hasError:error];
     //                               } else {
     [self.navigationController popViewControllerAnimated:YES];
     //                               }
     }];*/
    
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
    
    //NSMutableData *received = [receivedData objectAtIndex:CHANGE_CARD];
    //[received setLength:0];
    NSURLConnectionBlock *connection = [[NSURLConnectionBlock alloc] initWithRequest:request];
    connection.completion = ^(id obj, NSError *err) {
        
        if (!err) {
           
            
        } else {
            //There was an error
            
        }
        
    };
    
    if (self.config.save_card == 1) {
    [connection start];
    }
    
    
    self.config.stripeToken = token.tokenId;
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)savecard:(id)sender{
    self.config.save_card = 1;
}

-(void)threadStartanimating{
    [indicator startAnimating];
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
