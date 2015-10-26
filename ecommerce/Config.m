//
//  Config.m
//  Ecommerce
//
//  Created by Hanqing Hu on 5/25/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import "Config.h"
#import "JSCustomBadge.h"

#import "SDWebImageDownloader.h"
#import "SDImageCache.h"
#import "Branch.h"
#import "ViewWithData.h"
#import "NSURLConnectionBlock.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@import ImageIO;
@implementation Config
@synthesize app_logo, API_ROOT, API_BUY;
- (id)init
{
    self = [super init];
    if (self){
        //self.APP_UUID = @"1D3A62C9-8AE6-0A0B-0464-680D780D61BA"; //smoke
        //self.APP_UUID = @"A090AEE6-140C-E0BE-95B9-F9821DEDF8DD"; //fenix
        //self.APP_UUID = @"487D3AF9-EC2C-C8C6-6BB8-39F686E33BEA";
        //self.APP_UUID = @"DBB28534-88B9-178C-EDD4-91D1278069BB";//moooh
        //self.APP_UUID = @"EA15A46D-150A-370B-F4E6-1AC6BE22C61A"; //andrea
        self.APP_UUID = @"5316205A-C6FF-B19A-6B76-7A71228FFD97";
        //self.APP_UUID = @"DDA";
        
        
        self.app_version = @"1";
        
        self.API_ROOT = @"https://www.twixxies.com/";
        self.API_PROMOTION = @"ecommerce/promotions";
        self.API_PRODUCT = @"ecommercenew/product";
        self.API_SINGLE_PRODUCT = @"ecommerce/singleProduct";
        self.API_PRODUCT_COUNT = @"ecommerce/productCount";
        self.API_SESSION_START=@"userappuser/sessionstart";
        self.API_LOG_IN = @"userappuser/login";
        self.API_SIGN_UP = @"userappuser/signup";
        self.API_SOCIAL_SIGN_UP = @"userappuser/socialSignUp";
        self.API_FORGET_PW = @"userappuser/forgetPassword";
        self.API_ADD_CART = @"userappuser/addtocart";
        self.API_DELETE_CART = @"userappuser/deletecart";
        self.API_GET_CART = @"userappuser/getcart";
        self.API_GUEST_GET_CART = @"userappuser/guestgetcart";
        self.API_GUEST_LOG_IN = @"userappuser/guestCheckoutLogin";
        self.API_GET_ORDER = @"userappuser/getorders";
        self.API_SHIPPING_AND_TAX = @"ecommerce/getShippingTax";
        self.API_BUY = @"userappuser/submitOrder";
        self.API_USER_SETTING=@"userappuser/usersetting";
        self.API_CHANGE_CARD=@"userappuser/changecard";
        self.API_POLICY=@"ecommerce/policy";
        self.API_LOAD_DEPARTMENT = @"ecommerce/department";
        self.API_LOAD_FILTER = @"ecommerce/productfilter";
        self.API_UPDATE_FILTER=@"ecommerce/productfilterupdate";
        self.API_GET_SEARCH_WORD=@"ecommerce/getsearchwords";
        self.API_PAYPAL_CHECK_PRICE = @"userappuser/paypalcheckprice";
        self.API_PAYPAL_PURCHASED = @"userappuser/paypalbuy";
        self.API_PAYPAL_CARD_PURCHASE=@"userappuser/paypalcardpurchase";
        self.API_BILLBOARD = @"ecommerce/billboards";
        self.API_SAVE_ADDRESS = @"userappuser/saveAddress";
        self.API_SHARING_TEXT = @"ecommerce/sharingText";
        self.API_CHECK_CART_NUM = @"userappuser/checkCartNumber";
        self.API_USER_ACTIVE_APP=@"userappuser/useractiveapp";
        self.API_PUSH_NOTIFICATION = @"ecommerce/getPushNotification";
        self.API_PUSH_NOTIFICATION_NUM = @"ecommerce/getPushNotificationCount";
        self.API_CHECK_FAV = @"userappuser/checkFav";
        self.API_ADD_EDIT_FAV = @"userappuser/addEditFav";
        self.API_GET_FAV = @"userappuser/getFav";
        self.API_GET_APP_PAYMENTMETHOD = @"ecommerce/getPaymentMethod";
        self.API_GET_USER_PAYMENTMETHOD = @"userappuser/getUserPaymentMethod";
        self.API_ADD_EDIT_USER_PAYMENTMETHOD = @"userappuser/addEditUserPaymentMethod";
        self.cart = [[NSMutableArray alloc] init];
        self.shipping = [[NSMutableArray alloc] init];
        //self.tax = [[NSMutableDictionary alloc] init];
        self.departments = [[NSMutableArray alloc] init];
        self.design = [[NSMutableDictionary alloc] init];
        self.sharingText = [[NSMutableDictionary alloc] init];
        self.device_token = @"";
        self.push_token = @"";
        self.refresh_cart = NO;
        self.cartnum = 0;
        self.ituneID = @"1018624570";
        //self.payment_method = @"";
        self.payment_method_option = @"";
        self.link_inventory = @"";
        self.use_facebook_login = YES;
        self.use_credit = NO;
        self.currency = @"USD";
        self.currency_symbol = @"$";
        self.language = @"EN";
        self.location = @"US";
        self.currency_rate = [NSDecimalNumber decimalNumberWithString:@"1"];
        
        self.countrytocode = [[NSMutableDictionary alloc] init];
        self.codetocountry = [[NSMutableDictionary alloc] init];
        self.wholesale = [[WholesaleModule alloc] init];
        
        self.guest_checkout = NO;
        self.cache = [[CachedDataModule alloc] init];
        
        NSLocale *locale = [NSLocale currentLocale];
        NSArray *countryArray = [NSLocale ISOCountryCodes];
        
        NSMutableArray *sortedCountryArray = [[NSMutableArray alloc] init];
        
        for (NSString *countryCode in countryArray) {
            
            NSString *displayNameString = [locale displayNameForKey:NSLocaleCountryCode value:countryCode];
            if (displayNameString != nil){
                [sortedCountryArray addObject:displayNameString];
                [self.countrytocode setObject:countryCode forKey:displayNameString];
                [self.codetocountry setObject:displayNameString forKeyedSubscript:countryCode];
            }
            
            
            
        }
        
        self.languagetocode = [[NSMutableDictionary alloc] init];
        self.codetolanguage = [[NSMutableDictionary alloc] init];
        NSArray *lanArray = [NSLocale ISOLanguageCodes];
        
        for (NSString *lancode in lanArray) {
            
            
            NSString *displayNameString = [locale displayNameForKey:NSLocaleLanguageCode value:lancode];
            if (displayNameString != nil){
                
                [self.languagetocode setObject:[lancode uppercaseString] forKey:displayNameString];
                [self.codetolanguage setObject:displayNameString forKey:[lancode uppercaseString]];
            }
            
            
            
        }
        
        
        [sortedCountryArray sortUsingSelector:@selector(localizedCompare:)];
        self.countries = sortedCountryArray;
        //[self.countries insertObject:@"Select Country" atIndex:0];
        //self.user_id = @"0";
        
        //self.navbar_color =  [UIColor whiteColor];
        //self.navbar_tint_color =  [UIColor colorWithRed:0.302 green:0.302 blue:0.318 alpha:1];
        self.app_template = @"Vargus White";
        CGRect screenBound = [[UIScreen mainScreen] bounds];
        CGSize screenSize = screenBound.size;
        self.screenWidth = screenSize.width;
        self.screenHeight = screenSize.height;
        
    }
    return self;
    
}

-(void)save_default{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.email forKey:@"email"];
    [defaults setObject:self.token forKey:@"token"];
    [defaults setObject:self.language forKey:@"language"];
    [defaults setObject:self.location forKey:@"location"];
    [defaults setObject:self.currency forKey:@"currency"];
    [defaults synchronize];
}
-(void)load_default{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.email = [defaults objectForKey:@"email"];
    self.token = [defaults objectForKey:@"token"];
    self.language = [defaults objectForKey:@"language"];
    self.location = [defaults objectForKey:@"location"];
    self.currency = [defaults objectForKey:@"currency"];
    
    if (self.language != nil && self.language.length > 0){
        [self change_language:self.language];
    }
    [self.cache load_default];
}

-(void)user_info_from_dictionary:(NSDictionary *)dic{
    self.user_id = [dic objectForKey:@"user_id"];
    self.email = [dic objectForKey:@"email"];
    self.token = [dic objectForKey:@"access_token"];
    [self save_default];
    self.cartnum = [[dic objectForKey:@"cart_number"] intValue];
    self.name = [[dic objectForKey:@"name"] isKindOfClass:[NSString class]] ? [dic objectForKey:@"name"] : @"";
    self.address = [[dic objectForKey:@"address"] isKindOfClass:[NSString class]] ? [dic objectForKey:@"address"] : @"";
    self.city = [[dic objectForKey:@"city"] isKindOfClass:[NSString class]]? [dic objectForKey:@"city"] : @"";
    self.state = [[dic objectForKey:@"state"] isKindOfClass:[NSString class]]? [dic objectForKey:@"state"] :@"";
    self.zip = [[dic objectForKey:@"zip"] isKindOfClass:[NSString class]]? [dic objectForKey:@"zip"] : @"";
    self.country = [[dic objectForKey:@"country"] isKindOfClass:[NSString class]]? [dic objectForKey:@"country"] : @"";
    self.phone = [[dic objectForKey:@"phone"] isKindOfClass:[NSString class]]? [dic objectForKey:@"phone"] : @"";
    self.billingname = [[dic objectForKey:@"billingname"] isKindOfClass:[NSString class]] ? [dic objectForKey:@"billingname"] : @"";
    self.billingaddress = [[dic objectForKey:@"billingaddress"] isKindOfClass:[NSString class]] ? [dic objectForKey:@"billingaddress"] : @"";
    self.billingcity = [[dic objectForKey:@"billingcity"] isKindOfClass:[NSString class]]? [dic objectForKey:@"billingcity"] : @"";
    self.billingstate = [[dic objectForKey:@"billingstate"] isKindOfClass:[NSString class]]? [dic objectForKey:@"billingstate"] :@"";
    self.billingzip = [[dic objectForKey:@"billingzip"] isKindOfClass:[NSString class]]? [dic objectForKey:@"billingzip"] : @"";
    self.billingcountry = [[dic objectForKey:@"billingcountry"] isKindOfClass:[NSString class]]? [dic objectForKey:@"billingcountry"] : @"";
    self.stripeID = [[dic objectForKey:@"stripe_id"] isKindOfClass:[NSString class]]? [dic objectForKey:@"stripe_id"] :@"";
    self.stripeCard = [[dic objectForKey:@"stripe_card"] isKindOfClass:[NSString class]]? [dic objectForKey:@"stripe_card"] : @"";
    self.wholesale.wholesale_user_id = [dic objectForKey:@"wholesale_user_id"];
    self.wholesale.status = [[dic objectForKey:@"wholesale_status"] intValue];
}

-(void)logout{
    self.user_id = @"";
    self.email = @"";
    self.token = @"";
    [self save_default];
    self.name =  @"";
    self.address =  @"";
    self.city =  @"";
    self.state = @"";
    self.zip =  @"";
    self.stripeID = @"";
    self.stripeCard =  @"";
    self.save_address=0;
    self.save_card=0;
    self.chosen_shipping = nil;
    self.card = nil;
    self.cartnum = 0;
    if (self.affiliate != nil){
        self.affiliate.aid = @"0";
    }
    [self.cart removeAllObjects];
    
    self.stripeToken = @"";
    
    //[FBSession.activeSession closeAndClearTokenInformation];
    [[[FBSDKLoginManager alloc] init] logOut];
    
    [[Branch getInstance] logout];
    
}

+ (NSString*)encodeURL:(NSString *)string
{
    NSString *newString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    if (newString)
    {
        return newString;
    }
    
    return @"";
}



-(void)add_badge:(UIView *)view withnumber:(int)number{
    
    UIView *v = [view viewWithTag:-11];
    if (number <= 0) {
        if (v == nil) {
        } else {
            [v removeFromSuperview];
            v = nil;
        }
    } else {
        if (v == nil) {
            JSCustomBadge *badge = [JSCustomBadge customBadgeWithString:[NSString stringWithFormat:@"%d", number]];
            badge.tag = -11;
            /* badge.badgeTextColor = [UIColor colorWithRed:0.231 green:0.349 blue:0.596 alpha:1];
             badge.badgeInsetColor = [UIColor whiteColor];
             badge.layer.borderColor =[[UIColor colorWithRed:0.231 green:0.349 blue:0.596 alpha:1] CGColor];
             badge.layer.borderWidth = 1;
             badge.layer.cornerRadius = 10;
             badge.clipsToBounds = NO;*/
            badge.frame = CGRectMake(view.frame.size.width-25, 4, 20, 20);
            
            [view addSubview:badge];
        } else {
            [v removeFromSuperview];
            v = nil;
            JSCustomBadge *badge = [JSCustomBadge customBadgeWithString:[NSString stringWithFormat:@"%d", number]];
            badge.tag = -11;
            
            badge.frame = CGRectMake(view.frame.size.width-25, 4, 20, 20);
            [view addSubview:badge];
        }
        
    }
}

-(void)check_cart_with_view:(UIView *)view{
    if ((self.user_id == nil || self.user_id == 0 || self.user_id.length == 0) && self.guest_checkout) {
        self.cartnum = self.cache.cart.count;
        [self add_badge:view withnumber:self.cartnum];
        return;
    } else if ((self.user_id == nil || self.user_id == 0 || self.user_id.length == 0) && !self.guest_checkout) {
        return;
    }
    if (view == nil) view = self.temp_cartnum_view;
    [self change_active_app];
    NSString *myRequestString = [NSString stringWithFormat:@"app_uuid=%@&user_id=%@&token=%@&device_token=%@",  self.APP_UUID, self.user_id, self.token, self.device_token];
    NSData *myRequestData2 = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request2 = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@",self.API_ROOT, self.API_CHECK_CART_NUM]]];
    [request2 setHTTPMethod: @"POST"];
    [request2 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request2 setHTTPBody: myRequestData2];
    
    NSURLConnectionBlock *connection = [[NSURLConnectionBlock alloc] initWithRequest:request2];
    connection.completion = ^(id obj, NSError *err) {
        
        if (!err) {
            //It's ok, do domething with the response data (obj)
            NSMutableData *d = (NSMutableData *)obj;
            NSString *response = [[NSString alloc] initWithBytes:[d bytes] length:[d length] encoding:NSUTF8StringEncoding];
            NSLog(@"%@",response);
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            
            self.cartnum = [[dic objectForKey:@"cart_number"] intValue];
            [self add_badge:view withnumber:self.cartnum];
        } else {
            //There was an error
            NSLog(@"%@", err.description);
        }
        
    };
    [connection start];
}

+ (UIImage*)resizeImage:(UIImage*)image toFitInSize:(CGSize)toSize
{
    UIImage *result = image;
    CGSize sourceSize = image.size;
    CGSize targetSize = toSize;
    
    BOOL needsRedraw = NO;
    
    // Check if width of source image is greater than width of target image
    // Calculate the percentage of change in width required and update it in toSize accordingly.
    
    if (sourceSize.width > toSize.width) {
        
        CGFloat ratioChange = (sourceSize.width - toSize.width) * 100 / sourceSize.width;
        
        toSize.height = sourceSize.height - (sourceSize.height * ratioChange / 100);
        
        needsRedraw = YES;
    }
    
    // Now we need to make sure that if we chnage the height of image in same proportion
    // Calculate the percentage of change in width required and update it in target size variable.
    // Also we need to again change the height of the target image in the same proportion which we
    /// have calculated for the change.
    
    if (toSize.height < targetSize.height) {
        
        CGFloat ratioChange = (targetSize.height - toSize.height) * 100 / targetSize.height;
        
        toSize.height = targetSize.height;
        toSize.width = toSize.width + (toSize.width * ratioChange / 100);
        
        needsRedraw = YES;
    }
    
    // To redraw the image
    
    if (needsRedraw) {
        UIGraphicsBeginImageContext(toSize);
        [image drawInRect:CGRectMake(0.0, 0.0, toSize.width, toSize.height)];
        result = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    // Return the result
    
    return result;
}
+(void)getCachedImage:(NSString *)url toImageView:(UIImageView *)img trim:(BOOL)trim sizeMultiplyer:(int)multiplyer completion:(void(^)(UIImage *))completion{
    [[SDImageCache sharedImageCache] queryDiskCacheForKey:url done:^(UIImage *image, SDImageCacheType cacheType) {
        if (image != nil){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (trim){
                    CGSize newSize=CGSizeMake(image.size.width, image.size.height);
                    float ratio = img.frame.size.height/img.frame.size.width;
                    UIImage* newImage = image;
                    if (newSize.height/newSize.width < ratio){
                        
                        CGImageRef imageref = CGImageCreateWithImageInRect([image CGImage], CGRectMake(newSize.width/2-newSize.height/ratio/2, 0, newSize.height/ratio, newSize.height));
                        //[i drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
                        //UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
                        newImage = [UIImage imageWithCGImage:imageref];
                        CGImageRelease(imageref);
                    } else if (newSize.height/newSize.width > ratio) {
                        CGImageRef imageref = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, newSize.height/2-newSize.width*ratio/2, newSize.width, newSize.width*ratio));
                        //[i drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
                        //UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
                        newImage = [UIImage imageWithCGImage:imageref];
                        CGImageRelease(imageref);
                        
                    }
                    img.image = newImage;
                    completion(newImage);
                } else {
                    img.image = nil;
                    img.image = image;
                    completion(image);
                }
                
                
            });
            
            
        } else {
            
            completion(nil);
        }
    }];
    
    
}

+(void)loadImageURL:(NSString *)url toImageView:(UIImageView *)img withCacheKey:(NSString *)key trim:(BOOL)trim sizeMultiplyer:(int)multiplyer completion:(void(^)())completion{
    NSString *u = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //[[SDImageCache sharedImageCache] queryDiskCacheForKey:key done:^(UIImage *image, SDImageCacheType cacheType) {
    
    
    
    [[SDImageCache sharedImageCache] queryDiskCacheForKey:url done:^(UIImage *image, SDImageCacheType cacheType) {
        if (image != nil){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (trim){
                    CGSize newSize=CGSizeMake(image.size.width, image.size.height);
                    float ratio = img.frame.size.height/img.frame.size.width;
                    UIImage* newImage = image;
                    if (newSize.height/newSize.width < ratio){
                        
                        CGImageRef imageref = CGImageCreateWithImageInRect([image CGImage], CGRectMake(newSize.width/2-newSize.height/ratio/2, 0, newSize.height/ratio, newSize.height));
                        //[i drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
                        //UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
                        newImage = [UIImage imageWithCGImage:imageref];
                        CGImageRelease(imageref);
                    } else if (newSize.height/newSize.width > ratio) {
                        CGImageRef imageref = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, newSize.height/2-newSize.width*ratio/2, newSize.width, newSize.width*ratio));
                        //[i drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
                        //UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
                        newImage = [UIImage imageWithCGImage:imageref];
                        CGImageRelease(imageref);
                        
                    }
                    img.image = newImage;
                    completion();
                } else {
                    img.image = nil;
                    img.image = image;
                    completion();
                }
                
                
            });
            
            
        } else {
            
            [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString: u]
                                                                options:0
                                                               progress:^(NSInteger receivedSize, NSInteger expectedSize)
             {
                 // progression tracking code
             }
                                                              completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
             {
                 if (image && finished)
                 {
                     CGSize imgsize = CGSizeMake(image.size.width, image.size.height);
                     
                     
                     //UIImage *newImage = [Config imageWithImage:image scaledToSize:newSize];
                     
                     
                     
                     float frameRatio = img.frame.size.height/img.frame.size.width;
                     if (trim){
                         
                         
                         
                         if (imgsize.height/imgsize.width < frameRatio){
                             
                             CGImageRef imageref = CGImageCreateWithImageInRect([image CGImage], CGRectMake(imgsize.width/2-imgsize.height/frameRatio/2, 0, imgsize.height/frameRatio, imgsize.height));
                             //[i drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
                             //UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
                             image = [UIImage imageWithCGImage:imageref];
                             CGImageRelease(imageref);
                         } else if (imgsize.height/imgsize.width > frameRatio) {
                             CGImageRef imageref = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, imgsize.height/2-imgsize.width*frameRatio/2, imgsize.width, imgsize.width*frameRatio));
                             //[i drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
                             //UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
                             image = [UIImage imageWithCGImage:imageref];
                             CGImageRelease(imageref);
                             
                         }
                     }
                     CGSize newSize=CGSizeMake(image.size.width*multiplyer, image.size.height*multiplyer);
                     
                     if (!trim){
                         float ratio = image.size.height/image.size.width;
                         CGSize newSize=CGSizeMake(img.frame.size.width*multiplyer, img.frame.size.width*ratio*multiplyer);
                         if (frameRatio > ratio){
                             newSize = CGSizeMake(img.frame.size.height/ratio*multiplyer, img.frame.size.height);
                         }
                     }
                     
                     
                     
                     
                     
                     
                     UIGraphicsBeginImageContext(newSize);
                     [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
                     UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
                     UIGraphicsEndImageContext();
                     
                     
                     
                     
                     
                     
                     
                     
                     @autoreleasepool {
                         //[sharedImageCache setImage:newImage forEntity:col withFormatName:formatName completionBlock:completionBlock2];
                         
                         [[SDImageCache sharedImageCache] storeImage:image forKey:url];
                     }
                     
                     //[[SDImageCache sharedImageCache] storeImage:image forKey:url];
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     //[self forceImageDecompression:image];
                     //image = nil;
                     //data = nil;
                     // do something with image
                     dispatch_async(dispatch_get_main_queue(), ^{
                         img.image = nil;
                         img.image = newImage;
                         completion();
                     });
                 } else {
                     completion();
                 }
             }];
        }
    }];
    /*FICImageCacheCompletionBlock completionBlock = ^(id <FICEntity> entity, NSString *formatName, UIImage *image) {
     if (image != nil){
     
     dispatch_async(dispatch_get_main_queue(), ^{
     if (trim){
     CGSize newSize=CGSizeMake(image.size.width, image.size.height);
     float ratio = img.frame.size.height/img.frame.size.width;
     UIImage* newImage = image;
     if (newSize.height/newSize.width < ratio){
     
     CGImageRef imageref = CGImageCreateWithImageInRect([image CGImage], CGRectMake(newSize.width/2-newSize.height/ratio/2, 0, newSize.height/ratio, newSize.height));
     //[i drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
     //UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
     newImage = [UIImage imageWithCGImage:imageref];
     CGImageRelease(imageref);
     } else if (newSize.height/newSize.width > ratio) {
     CGImageRef imageref = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, newSize.height/2-newSize.width*ratio/2, newSize.width, newSize.width*ratio));
     //[i drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
     //UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
     newImage = [UIImage imageWithCGImage:imageref];
     CGImageRelease(imageref);
     
     }
     img.image = newImage;
     completion();
     } else {
     img.image = nil;
     img.image = image;
     completion();
     }
     
     });
     }
     };
     
     BOOL imageExists = [sharedImageCache retrieveImageForEntity:col withFormatName:formatName completionBlock:completionBlock];
     
     
     if (imageExists) return;*/
    
    // else{
    
    //  }
    
    
    //}];
    
    
}



+(void)syncLoadImageURL:(NSString *)url toImageView:(UIImageView *)img withCacheKey:(NSString *)key trim:(BOOL)trim sizeMultiplyer:(int)multiplyer completion:(void(^)())completion{
    
    
    NSString *u = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //[[SDImageCache sharedImageCache] queryDiskCacheForKey:key done:^(UIImage *image, SDImageCacheType cacheType) {
    NSURL* addr = [NSURL URLWithString:u];
    
    
    
    
    CGFloat maxw = img.frame.size.width;// whatever;
    CGFloat maxh = img.frame.size.height;// whatever;
    
    CGImageSourceRef src = CGImageSourceCreateWithURL((__bridge CFURLRef)addr, nil);
    
    
    // if at double resolution, double the thumbnail size and use double-resolution image
    CGFloat scale = 1;
    if ([[UIScreen mainScreen] scale] > 1.0) {
        scale = 2;
        maxw *= 2;
        maxh *= 2;
    }
    
    // load the image at the desired size
    NSDictionary* d = @{
                        (id)kCGImageSourceShouldAllowFloat: (id)kCFBooleanTrue,
                        (id)kCGImageSourceCreateThumbnailWithTransform: (id)kCFBooleanTrue,
                        (id)kCGImageSourceCreateThumbnailFromImageAlways: (id)kCFBooleanTrue,
                        (id)kCGImageSourceThumbnailMaxPixelSize: @((int)(maxw > maxh ? maxw : maxh))
                        };
    CGImageRef imref = CGImageSourceCreateThumbnailAtIndex(src, 0, (__bridge CFDictionaryRef)d);
    
    CGImageRef imref2 = CGImageSourceCreateThumbnailAtIndex(src, 0, (__bridge CFDictionaryRef)d);
    
    @autoreleasepool {
        __block UIImage* im2 = [UIImage imageWithCGImage:imref2 scale:scale orientation:UIImageOrientationUp];
        
        [[SDImageCache sharedImageCache] storeImage:im2 forKey:url];
        im2 = nil;
        
    }
    if (NULL != imref2)
        CFRelease(imref2);
    
    
    if (NULL != src)
        CFRelease(src);
    __block UIImage* im = [UIImage imageWithCGImage:imref scale:scale orientation:UIImageOrientationUp];
    
    if (NULL != imref)
        CFRelease(imref);
    
    
    
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        img.image = nil;
        img.image = im;
        
        
        
        im = nil;
        
        
        completion();
        
    });
    
    
    /*FICImageCacheCompletionBlock completionBlock = ^(id <FICEntity> entity, NSString *formatName, UIImage *image) {
     if (image != nil){
     
     dispatch_async(dispatch_get_main_queue(), ^{
     if (trim){
     CGSize newSize=CGSizeMake(image.size.width, image.size.height);
     float ratio = img.frame.size.height/img.frame.size.width;
     UIImage* newImage = image;
     if (newSize.height/newSize.width < ratio){
     
     CGImageRef imageref = CGImageCreateWithImageInRect([image CGImage], CGRectMake(newSize.width/2-newSize.height/ratio/2, 0, newSize.height/ratio, newSize.height));
     //[i drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
     //UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
     newImage = [UIImage imageWithCGImage:imageref];
     CGImageRelease(imageref);
     } else if (newSize.height/newSize.width > ratio) {
     CGImageRef imageref = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, newSize.height/2-newSize.width*ratio/2, newSize.width, newSize.width*ratio));
     //[i drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
     //UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
     newImage = [UIImage imageWithCGImage:imageref];
     CGImageRelease(imageref);
     
     }
     img.image = newImage;
     completion();
     } else {
     img.image = nil;
     img.image = image;
     completion();
     }
     
     });
     }
     };
     
     BOOL imageExists = [sharedImageCache retrieveImageForEntity:col withFormatName:formatName completionBlock:completionBlock];
     
     
     if (imageExists) return;*/
    
    
    
    
    /*
     // else{
     [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString: u]
     options:0
     progress:^(NSInteger receivedSize, NSInteger expectedSize)
     {
     // progression tracking code
     }
     completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
     {
     if (image && finished)
     {
     CGSize imgsize = CGSizeMake(image.size.width, image.size.height);
     
     
     //UIImage *newImage = [Config imageWithImage:image scaledToSize:newSize];
     
     
     
     float frameRatio = img.frame.size.height/img.frame.size.width;
     if (trim){
     
     
     
     if (imgsize.height/imgsize.width < frameRatio){
     
     CGImageRef imageref = CGImageCreateWithImageInRect([image CGImage], CGRectMake(imgsize.width/2-imgsize.height/frameRatio/2, 0, imgsize.height/frameRatio, imgsize.height));
     //[i drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
     //UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
     image = [UIImage imageWithCGImage:imageref];
     CGImageRelease(imageref);
     } else if (imgsize.height/imgsize.width > frameRatio) {
     CGImageRef imageref = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, imgsize.height/2-imgsize.width*frameRatio/2, imgsize.width, imgsize.width*frameRatio));
     //[i drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
     //UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
     image = [UIImage imageWithCGImage:imageref];
     CGImageRelease(imageref);
     
     }
     }
     CGSize newSize=CGSizeMake(image.size.width*multiplyer, image.size.height*multiplyer);
     
     if (!trim){
     float ratio = image.size.height/image.size.width;
     CGSize newSize=CGSizeMake(img.frame.size.width*multiplyer, img.frame.size.width*ratio*multiplyer);
     if (frameRatio > ratio){
     newSize = CGSizeMake(img.frame.size.height/ratio*multiplyer, img.frame.size.height);
     }
     }
     
     
     
     
     
     
     UIGraphicsBeginImageContext(newSize);
     [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
     UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     
     
     
     
     
     
     
     
     
     @autoreleasepool {
     //[sharedImageCache setImage:newImage forEntity:col withFormatName:formatName completionBlock:completionBlock2];
     
     [[SDImageCache sharedImageCache] storeImage:image forKey:url];
     }
     
     //[[SDImageCache sharedImageCache] storeImage:image forKey:url];
     
     
     
     
     
     
     
     
     
     
     
     //[self forceImageDecompression:image];
     //image = nil;
     //data = nil;
     // do something with image
     dispatch_async(dispatch_get_main_queue(), ^{
     img.image = nil;
     img.image = newImage;
     completion();
     });
     } else {
     completion();
     }
     }];*/
    
    
}


+(UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSize:(CGSize)newSize
{
    CGFloat targetWidth = newSize.width;
    CGFloat targetHeight = newSize.height;
    
    CGImageRef imageRef = [sourceImage CGImage];
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
    if (bitmapInfo == kCGImageAlphaNone) {
        bitmapInfo = kCGImageAlphaNoneSkipLast;
    }
    
    CGContextRef bitmap;
    
    if (sourceImage.imageOrientation == UIImageOrientationUp ||  sourceImage.imageOrientation == UIImageOrientationDown) {
        bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    } else {
        bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    }
    
    if (sourceImage.imageOrientation == UIImageOrientationLeft) {
        CGContextRotateCTM (bitmap, M_PI_2); // + 90 degrees
        CGContextTranslateCTM (bitmap, 0, -targetHeight);
        
    } else if (sourceImage.imageOrientation == UIImageOrientationRight) {
        CGContextRotateCTM (bitmap, -M_PI_2); // - 90 degrees
        CGContextTranslateCTM (bitmap, -targetWidth, 0);
        
    } else if (sourceImage.imageOrientation == UIImageOrientationUp) {
        // NOTHING
    } else if (sourceImage.imageOrientation == UIImageOrientationDown) {
        CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
        CGContextRotateCTM (bitmap, -M_PI); // - 180 degrees
    }
    
    CGContextDrawImage(bitmap, CGRectMake(0, 0, targetWidth, targetHeight), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return newImage;
}
-(NSString *)getCurrencySymbol{
    if (self.currency_symbol == nil || self.currency_symbol.length == 0) return @"$";
    else return self.currency_symbol;
}

-(void)change_active_app{
    NSString *myRequestString = [NSString stringWithFormat:@"app_uuid=%@&user_id=%d&token=%@&device_token=%@&push_token=%@",  self.APP_UUID, [self.user_id intValue], self.token, self.device_token, self.push_token];
    NSLog(@"%@", myRequestString);
    NSData *myRequestData2 = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request2 = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@",self.API_ROOT, self.API_USER_ACTIVE_APP]]];
    [request2 setHTTPMethod: @"POST"];
    [request2 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request2 setHTTPBody: myRequestData2];
    
    NSURLConnectionBlock *connection = [[NSURLConnectionBlock alloc] initWithRequest:request2];
    connection.completion = ^(id obj, NSError *err) {
        NSMutableData *d = (NSMutableData *)obj;
        NSString *response = [[NSString alloc] initWithBytes:[d bytes] length:[d length] encoding:NSUTF8StringEncoding];
        NSLog(@"%@",response);
        
        
    };
    [connection start];
}

-(void)change_language:(NSString *)key{
    NSString *path= [[NSBundle mainBundle] pathForResource:[key lowercaseString] ofType:@"lproj"];
    self.languageBundle = [NSBundle bundleWithPath:path];
    //[[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:[key lowercaseString], @"en", nil] forKey:@"AppleLanguages"];
    
}

-(NSString*)localisedString:(NSString *)key{
    NSLog(@"%@", self.languageBundle.description);
    if (self.languageBundle == nil) return NSLocalizedString(key, @"");
    else return [self.languageBundle localizedStringForKey:key value:@"" table:nil];
}


/*-(void)build_template:(NSString *) template{
 if ([template isEqualToString:@"Vargus White"]){
 [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
 self.navbar_bg_color = [UIColor whiteColor];
 self.navbar_icon_color =[UIColor colorWithRed:88/225.0 green:88/225.0 blue:88/225.0 alpha:1];
 self.navbar_icon_size = 28;
 self.promo_;
 }
 
 }*/

-(UIStatusBarStyle)set_status_bar{
    NSDictionary *nav_bar = [[self.design objectForKey:@"design"] objectForKey:@"navigation_bar"];
    if ([nav_bar objectForKey:@"status-bar"] != nil){
        if ([[nav_bar objectForKey:@"status-bar"] isEqualToString:@"light"]) {
            return UIStatusBarStyleLightContent;
        } else return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

@end
