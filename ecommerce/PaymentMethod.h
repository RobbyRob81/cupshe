//
//  PaymentMethod.h
//  Ecommerce
//
//  Created by Han Hu on 9/10/15.
//  Copyright (c) 2015 Twixxies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PKCard.h"
#import "AuthNet.h"
@protocol UserPaymentMethodDelegate;
@class AppPaymentMethod;
@interface UserPaymentMethod : NSObject  <AuthNetDelegate> {
    NSDecimalNumber *product_total;
    NSDecimalNumber *tax_total;
    NSDecimalNumber *shipping_total;
    int payment_stage;
}
@property (nonatomic, strong) NSString *payment_method_id;
@property (nonatomic, strong) NSString *payment_method;
@property (nonatomic, strong) NSString *customer_id;
@property (nonatomic, strong) NSString *payment_token;
@property (nonatomic, strong) NSString *payment_gateway;
@property (nonatomic, strong) NSString *account_id;
@property (nonatomic, strong) NSString *billingfirstname;
@property (nonatomic, strong) NSString *billinglastname;
@property (nonatomic, strong) NSString *billingaddress;
@property (nonatomic, strong) NSString *billingcity;
@property (nonatomic, strong) NSString *billingstate;
@property (nonatomic, strong) NSString *billingzip;
@property (nonatomic, strong) NSString *billingcountry;
@property (nonatomic, strong) NSString *billingphone;
@property (nonatomic, strong) NSString *last4;
@property (nonatomic, strong) NSString *cardtype;
@property (nonatomic, strong) NSString *expmonth;
@property (nonatomic, strong) NSString *expyear;
@property (nonatomic, strong) NSString *cc;
@property (nonatomic, strong) NSString *cvc;
@property BOOL is_default;
@property BOOL is_saved;
@property (nonatomic, strong) PKCard *card;
@property (nonatomic, strong) AppPaymentMethod *appmethod;
@property BOOL handle_payment;
@property (nonatomic, strong) id<UserPaymentMethodDelegate> delegate;

-(void)dictionary_to_method:(NSDictionary *)d;
-(void)pay:(NSDecimalNumber *)product shipping:(NSDecimalNumber *)shipping tax:(NSDecimalNumber *)tax;

@end



@protocol UserPaymentMethodDelegate <NSObject>

-(void)pay_succeed:(NSMutableDictionary *)data;
-(void)pay_failed:(NSMutableDictionary *)data;
@end


@interface AppPaymentMethod : NSObject
@property (nonatomic, strong) NSString *payment_method_id;
@property (nonatomic, strong) NSString *payment_gateway;
@property (nonatomic, strong) NSString *payment_method;
@property (nonatomic, strong) NSString *api_userid;
@property (nonatomic, strong) NSString *api_token;
@property (nonatomic, strong) NSString *api_secret;
@property (nonatomic, strong) NSString *sandbox_api_userid;
@property (nonatomic, strong) NSString *sandbox_api_token;
@property (nonatomic, strong) NSString *sandbox_api_secret;
@property (nonatomic, strong) NSString *api_version;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *name;
@property int islive;

-(void)dictionary_to_method:(NSDictionary *)d;

@end
