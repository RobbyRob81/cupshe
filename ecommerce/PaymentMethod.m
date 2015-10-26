//
//  PaymentMethod.m
//  Ecommerce
//
//  Created by Han Hu on 9/10/15.
//  Copyright (c) 2015 Twixxies. All rights reserved.
//

#import "PaymentMethod.h"



@implementation UserPaymentMethod

- (id)init
{
    self = [super init];
    if (self){
        self.customer_id = @"";
        self.payment_gateway = @"";
        self.payment_token = @"";
        self.payment_method_id = @"";
        self.payment_method = @"";
        self.account_id = @"";
        self.last4 = @"";
        self.cardtype = @"";
        self.account_id = @"";
        self.expmonth = @"";
        self.expyear = @"";
        self.billingfirstname = @"";
        self.billinglastname = @"";
        self.billingaddress = @"";
        self.billingcity = @"";
        self.billingstate = @"";
        self.billingzip = @"";
        self.billingcountry = @"";
        self.is_default = 0;
        
        self.cc = @"";
        self.cvc = @"";
        self.handle_payment = false;
        payment_stage = 0;
    }
    return self;
    
}

-(void)dictionary_to_method:(NSDictionary *)d{
    self.payment_method_id = [d objectForKey:@"payment_method_id"];
    self.customer_id = [d objectForKey:@"payment_customer_id"];
    self.payment_gateway = [d objectForKey:@"payment_gateway"];
    self.payment_token = [d objectForKey:@"payment_method_token"];
    self.payment_method = [d objectForKey:@"payment_method"];
    self.account_id = [d objectForKey:@"account_id"];
    self.last4 = [d objectForKey:@"last4"];
    self.cardtype = [d objectForKey:@"card_type"];
    self.expmonth = [d objectForKey:@"exp_month"];
    self.expyear = [d objectForKey:@"exp_year"];
    self.billingfirstname = [d objectForKey:@"billing_firstname"];
    self.billinglastname = [d objectForKey:@"billing_lastname"];
    self.billingaddress = [d objectForKey:@"billing_address"];
    self.billingcity = [d objectForKey:@"billing_city"];
    self.billingstate = [d objectForKey:@"billing_state"];
    self.billingzip = [d objectForKey:@"billing_zip"];
    self.billingcountry = [d objectForKey:@"billing_country"];
    self.is_default = [[d objectForKey:@"is_default"] intValue];
    self.appmethod = [[AppPaymentMethod alloc] init];
    [self.appmethod dictionary_to_method:[d objectForKey:@"app_payment_method"]];
}



-(void)pay:(NSDecimalNumber *)product shipping:(NSDecimalNumber *)shipping tax:(NSDecimalNumber *)tax{
    if ([self.payment_gateway isEqualToString:@"AuthorizeNet"] && [self.payment_method isEqualToString:@"credit card"]){
        
        if (self.appmethod.islive == 0) {
            [AuthNet authNetWithEnvironment:ENV_TEST];
        } else {
            [AuthNet authNetWithEnvironment:ENV_LIVE];
        }
        
        
        product_total = product;
        shipping_total = shipping;
        tax_total = tax;
        
        AuthNet *an = [AuthNet getInstance];
        [an setDelegate:self];
        
        CreditCardType *creditCardType = [CreditCardType creditCardType];
        creditCardType.cardNumber = self.cc;
        creditCardType.cardCode = self.cvc;
        creditCardType.expirationDate = [NSString stringWithFormat:@"%@-%@", self.expyear, self.expmonth];
        
        PaymentType *paymentType = [PaymentType paymentType];
        paymentType.creditCard = creditCardType;
        
        ExtendedAmountType *extendedAmountTypeTax = [ExtendedAmountType extendedAmountType];
        extendedAmountTypeTax.amount = [NSString stringWithFormat:@"%0.2f", [tax floatValue]];
        extendedAmountTypeTax.name = @"Tax";
        
        ExtendedAmountType *extendedAmountTypeShipping = [ExtendedAmountType extendedAmountType];
        extendedAmountTypeShipping.amount = [NSString stringWithFormat:@"%0.2f", [shipping floatValue]];
        extendedAmountTypeShipping.name = @"Shipping";
        
        
        TransactionRequestType *requestType = [TransactionRequestType transactionRequest];
        //requestType.lineItems = [NSArray arrayWithObject:lineItem];
        requestType.amount = [NSString stringWithFormat:@"%0.2f", [product floatValue]];
        requestType.payment = paymentType;
        requestType.tax = extendedAmountTypeTax;
        requestType.shipping = extendedAmountTypeShipping;
        
        
        
        CreateTransactionRequest *request = [CreateTransactionRequest createTransactionRequest];
        request.transactionRequest = requestType;
        request.transactionType = AUTH_ONLY;
        
        
        
        
        NSString *appid = self.appmethod.api_userid;
        NSString *appkey = self.appmethod.api_token;
        if (self.appmethod.islive == 0){
            appid = self.appmethod.sandbox_api_userid;
            appkey = self.appmethod.sandbox_api_token;
        }
        request.anetApiRequest.merchantAuthentication.name = appid;
        request.anetApiRequest.merchantAuthentication.transactionKey = appkey;
        
        
        [an authorizeWithRequest:request];
        
    }
}


- (void)paymentSucceeded:(CreateTransactionResponse*)response {
    NSLog(response.transactionResponse.transId);
    if (payment_stage == 0) {
        payment_stage = 1;
        
        if (self.appmethod.islive == 0) {
            [AuthNet authNetWithEnvironment:ENV_TEST];
        } else {
            [AuthNet authNetWithEnvironment:ENV_LIVE];
        }
        AuthNet *an = [AuthNet getInstance];
        an.delegate = self;
        
        NSString *transid = response.transactionResponse.transId;
        
        CreditCardType *creditCardType = [CreditCardType creditCardType];
        creditCardType.cardNumber = self.cc;
        creditCardType.cardCode = self.cvc;
        creditCardType.expirationDate = [NSString stringWithFormat:@"%4d-%2d", [self.expyear intValue], [self.expmonth intValue]];
        
        PaymentType *paymentType = [PaymentType paymentType];
        paymentType.creditCard = creditCardType;
        
        ExtendedAmountType *extendedAmountTypeTax = [ExtendedAmountType extendedAmountType];
        extendedAmountTypeTax.amount = [NSString stringWithFormat:@"%0.2f", [tax_total floatValue]];
        extendedAmountTypeTax.name = @"Tax";
        
        ExtendedAmountType *extendedAmountTypeShipping = [ExtendedAmountType extendedAmountType];
        extendedAmountTypeShipping.amount = [NSString stringWithFormat:@"%0.2f", [shipping_total floatValue]];
        extendedAmountTypeShipping.name = @"Shipping";
        
        
        TransactionRequestType *requestType = [TransactionRequestType transactionRequest];
        //requestType.lineItems = [NSArray arrayWithObject:lineItem];
        requestType.amount = [NSString stringWithFormat:@"%0.2f", [product_total floatValue]];
        requestType.payment = paymentType;
        requestType.tax = extendedAmountTypeTax;
        requestType.shipping = extendedAmountTypeShipping;
        requestType.refTransId = transid;
        requestType.authCode = response.transactionResponse.authCode;
        
        CreateTransactionRequest *request = [CreateTransactionRequest createTransactionRequest];
        request.transactionRequest = requestType;
        request.transactionType = CAPTURE_ONLY;
        
        NSString *appid = self.appmethod.api_userid;
        NSString *appkey = self.appmethod.api_token;
        if (self.appmethod.islive == 0){
            appid = self.appmethod.sandbox_api_userid;
            appkey = self.appmethod.sandbox_api_token;
        }
        request.anetApiRequest.merchantAuthentication.name = appid;
        request.anetApiRequest.merchantAuthentication.transactionKey = appkey;
        
        [an captureOnlyWithRequest:request];
    } else {
        NSLog(response.transactionResponse.transId);
        [self.delegate pay_succeed:[NSMutableDictionary dictionaryWithObjectsAndKeys:response.transactionResponse.transId, @"transaction id", nil]];
    }
    
}

- (void)paymentCanceled {
    
    [self.delegate pay_failed:nil];
    
    
}

-(void) requestFailed:(AuthNetResponse *)response {
    
    [self.delegate pay_failed:nil];
}

- (void) connectionFailed:(AuthNetResponse *)response {
    
    [self.delegate pay_failed:nil];
}




@end


@implementation AppPaymentMethod

-(void)dictionary_to_method:(NSDictionary *)d{
    self.payment_method_id = [d objectForKey:@"payment_method_id"];
    self.payment_gateway = [d objectForKey:@"payment_gateway"];
    self.payment_method = [d objectForKey:@"payment_method"];
    self.api_userid = [d objectForKey:@"api_userid"];
    self.api_token = [d objectForKey:@"api_token"];
    self.api_secret = [d objectForKey:@"api_secret"];
    self.sandbox_api_userid = [d objectForKey:@"sandbox_api_userid"];
    self.sandbox_api_token = [d objectForKey:@"sandbox_api_token"];
    self.sandbox_api_secret = [d objectForKey:@"sandbox_api_secret"];
    self.api_version = [d objectForKey:@"api_version"];
    self.desc = [d objectForKey:@"description"];
    self.islive = [[d objectForKey:@"isLive"] intValue];
}

@end