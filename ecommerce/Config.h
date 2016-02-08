//
//  Config.h
//  Ecommerce
//
//  Created by Hanqing Hu on 5/25/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PKCard.h"
#import "Shipping.h"
#import "AffiliateModule.h"
#import "WholesaleModule.h"
#import "CachedDataModule.h"
#import "PaymentMethod.h"

@interface Config : NSObject

@property (nonatomic, strong) NSString *APP_UUID;
@property (nonatomic, strong) NSString *API_ROOT;
@property (nonatomic, strong) NSString *API_PROMOTION;
@property (nonatomic, strong) NSString *API_PRODUCT;
@property (nonatomic, strong) NSString *API_SINGLE_PRODUCT;
@property (nonatomic, strong) NSString *API_PRODUCT_COUNT;
@property (nonatomic, strong) NSString *API_SESSION_START;
@property (nonatomic, strong) NSString *API_LOG_IN;
@property (nonatomic, strong) NSString *API_SIGN_UP;
@property (nonatomic, strong) NSString *API_SOCIAL_SIGN_UP;
@property (nonatomic, strong) NSString *API_FORGET_PW;
@property (nonatomic, strong) NSString *API_ADD_CART;
@property (nonatomic, strong) NSString *API_DELETE_CART;
@property (nonatomic, strong) NSString *API_GET_CART;
@property (nonatomic, strong) NSString *API_GUEST_GET_CART;
@property (nonatomic, strong) NSString *API_GUEST_LOG_IN;
@property (nonatomic, strong) NSString *API_GET_ORDER;
@property (nonatomic, strong) NSString *API_SHIPPING_AND_TAX;
@property (nonatomic, strong) NSString *API_BUY;
@property (nonatomic, strong) NSString *API_USER_SETTING;
@property (nonatomic, strong) NSString *API_CHANGE_CARD;
@property (nonatomic, strong) NSString *API_POLICY;
@property (nonatomic, strong) NSString *API_LOAD_DEPARTMENT;
@property (nonatomic, strong) NSString *API_LOAD_FILTER;
@property (nonatomic, strong) NSString *API_UPDATE_FILTER;
@property (nonatomic, strong) NSString *API_GET_SEARCH_WORD;
@property (nonatomic, strong) NSString *API_PAYPAL_CHECK_PRICE;
@property (nonatomic, strong) NSString *API_PAYPAL_PURCHASED;
@property (nonatomic, strong) NSString *API_PAYPAL_CARD_PURCHASE;
@property (nonatomic, strong) NSString *API_BILLBOARD;
@property (nonatomic, strong) NSString *API_SAVE_ADDRESS;
@property (nonatomic, strong) NSString *API_SHARING_TEXT;
@property (nonatomic, strong) NSString *API_CHECK_CART_NUM;
@property (nonatomic, strong) NSString *API_USER_ACTIVE_APP;
@property (nonatomic, strong) NSString *API_PUSH_NOTIFICATION_NUM;
@property (nonatomic, strong) NSString *API_PUSH_NOTIFICATION;
@property (nonatomic, strong) NSString *API_CHECK_FAV;
@property (nonatomic, strong) NSString *API_ADD_EDIT_FAV;
@property (nonatomic, strong) NSString *API_GET_FAV;
@property (nonatomic, strong) NSString *API_GET_USER_PAYMENTMETHOD;
@property (nonatomic, strong) NSString *API_GET_APP_PAYMENTMETHOD;
@property (nonatomic, strong) NSString *API_ADD_EDIT_USER_PAYMENTMETHOD;
@property (nonatomic, strong) NSString *app_name;
@property (nonatomic, strong) NSString *app_email;
@property (nonatomic, strong) NSString *app_logo;
@property (nonatomic, strong) NSString *app_text_logo;
@property (nonatomic, strong) NSString *device_token;
@property (nonatomic, strong) NSString *push_token;
//@property (nonatomic, strong)NSString *payment_method;
@property (nonatomic, strong) NSString *payment_method_option;
@property (nonatomic, strong)NSString *link_inventory;
@property int paypal_live;
@property BOOL use_facebook_login;
@property (nonatomic, strong) NSMutableArray *departments;
@property (nonatomic, strong) NSMutableDictionary *design;
@property (nonatomic, strong) NSString *app_version;

//user related field
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSMutableArray *cart;


@property (nonatomic, strong) PKCard *card;
@property (nonatomic, strong) NSString *firstname;
@property (nonatomic, strong) NSString *lastname;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *zip;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *phone;

@property (nonatomic, strong) NSString *billingname;
@property (nonatomic, strong) NSString *billingaddress;
@property (nonatomic, strong) NSString *billingcity;
@property (nonatomic, strong) NSString *billingstate;
@property (nonatomic, strong) NSString *billingzip;
@property (nonatomic, strong) NSString *billingcountry;

@property (nonatomic, strong) NSMutableArray *countries;
@property(nonatomic, strong) NSMutableDictionary *countrytocode;
@property (nonatomic, strong) NSMutableDictionary *codetocountry;
@property (nonatomic, strong) NSMutableDictionary *languagetocode;
@property (nonatomic, strong) NSMutableDictionary *codetolanguage;

@property int save_billing_address;
@property int save_address;
@property int save_card;
@property (nonatomic, strong) Shipping *chosen_shipping;
@property (nonatomic, strong) NSString *stripeToken;
@property (nonatomic, strong) NSString *stripeID;
@property (nonatomic, strong) NSString *stripeCard;
@property BOOL refresh_cart; //whether to refresh user's cart
@property int cartnum; //control badge number
@property UIView *temp_cartnum_view;
@property NSDecimalNumber *store_credit;
@property BOOL use_credit;
@property (nonatomic, strong) NSDictionary *coupon;

//app info
@property (nonatomic, strong) NSMutableArray *shipping;
//@property (nonatomic, strong) NSMutableDictionary *tax;
@property (nonatomic, strong) NSString *returnPolicy;
@property (nonatomic, strong) NSString *privacyPolicy;
@property (nonatomic, strong) NSString *contact;
@property (nonatomic, strong) NSString *ituneID;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong) NSString *currency_symbol;
@property (nonatomic, strong) NSString *language;
@property NSDecimalNumber *currency_rate;
@property (nonatomic, strong) NSDictionary *available_locations;
@property (nonatomic, strong) NSMutableDictionary *sharingText;
@property (nonatomic, strong) AffiliateModule *affiliate;

//app deep link
@property (nonatomic, strong) NSString *deeplink_id;
@property (nonatomic, strong) NSString *deeplink_item_id;
@property (nonatomic, strong) NSString *deeplink_type;

//app design
@property float screenWidth;
@property float screenHeight;
@property (nonatomic, strong) NSString *app_template;



//app api keys
@property (nonatomic, strong) NSDictionary *api_keys;


//app languages
@property (nonatomic, strong) NSBundle *languageBundle;


//app payment
@property (nonatomic,strong) NSString *payment_key;
@property (nonatomic, strong) NSString *payment_secret;

//wholesale
@property (nonatomic, strong) WholesaleModule *wholesale;

//guest checkout
@property BOOL guest_checkout;
@property (nonatomic, strong) CachedDataModule *cache;
@property (nonatomic, strong) NSString *temp_user_id;
@property (nonatomic, strong) NSString *temp_email;


//new payment method
@property (nonatomic, strong) UserPaymentMethod *selected_payment;
@property (nonatomic, strong) NSMutableArray *user_payment_methods;

-(void)load_default;
-(void)save_default;
-(void)logout;
-(void)user_info_from_dictionary:(NSDictionary *)dic;
-(void)add_badge:(UIView *)view withnumber:(int)number;
-(void)check_cart_with_view:(UIView *)view;
+(void)log_activity:(NSString *)activity withID:(NSString *)iid;
+(void)getCachedImage:(NSString *)url toImageView:(UIImageView *)img trim:(BOOL)trim sizeMultiplyer:(int)multiplyer completion:(void(^)(UIImage *))completion;
+(void)loadImageURL:(NSString *)url toImageView:(UIImageView *)img withCacheKey:(NSString *)key trim:(BOOL)trim sizeMultiplyer:(int)multiplyer completion:(void(^)())completion;
+(void)syncLoadImageURL:(NSString *)url toImageView:(UIImageView *)img withCacheKey:(NSString *)key trim:(BOOL)trim sizeMultiplyer:(int)multiplyer completion:(void(^)())completion;
+(UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSize:(CGSize)newSize;
+(UIImage*)resizeImage:(UIImage*)image toFitInSize:(CGSize)toSize;
-(NSString *)getCurrencySymbol;
-(void)change_active_app;
-(void)change_language:(NSString *)key;
-(NSString*)localisedString:(NSString *)key;
@end
