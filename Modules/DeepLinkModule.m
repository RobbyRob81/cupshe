//
//  DeepLinkModule.m
//  Moooh
//
//  Created by Hanqing Hu on 3/24/15.
//  Copyright (c) 2015 Twixxies. All rights reserved.
//

#import "DeepLinkModule.h"
#import "NSURLConnectionBlock.h"
#import "Config.h"
#import "Product.h"
#import "ProductDetailViewController.h"
#import "Design.h"
const NSString *DEEP_SINGLE_PRODUCT = @"https://www.twixxies.com/ecommerce/singleProduct";
@implementation DeepLinkModule

+(void)getPresentingControllerWithType:(NSString *)type item_id:(NSString *)iid config:(Config *)config completion:(void(^)(UIViewController *view, NSError *error))completion{
    
    if ([type isKindOfClass:[NSNull class]] || [iid isKindOfClass:[NSNull class]]){
        completion(nil, nil);
        return;
    }
    
    if (type ==nil || type.length == 0 || iid == nil || iid.length == 0 || [iid isEqualToString:@"0"]){
        completion(nil,nil);
        return;
    }
    
    if ([type isEqualToString:@"product"]){
        NSString *myRequestString = [NSString stringWithFormat:@"app_uuid=%@&product_id=%@&location=%@&currency=%@",config.APP_UUID, iid, config.location, config.currency];
        
        NSData *myRequestData2 = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
        NSMutableURLRequest *request2 = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@",DEEP_SINGLE_PRODUCT]]];
        [request2 setHTTPMethod: @"POST"];
        [request2 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
        [request2 setHTTPBody: myRequestData2];
        
        NSURLConnectionBlock *connection = [[NSURLConnectionBlock alloc] initWithRequest:request2];
        connection.completion = ^(id obj, NSError *err) {
            
            if (!err) {
                //It's ok, do domething with the response data (obj)
                NSMutableData *d = (NSMutableData *)obj;
                NSString *response = [[NSString alloc] initWithBytes:[d bytes] length:[d length] encoding:NSUTF8StringEncoding];
                NSLog(@"%@", response);
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
                
                int success = [[dic objectForKey:@"success"] intValue];
                
                if (success == 1){
                Product *p = [[Product alloc] init];
                [p product_from_dictionary:[dic objectForKey:@"product"]];
                
                ProductDetailViewController *pd = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:nil];
                pd.config = config;
                pd.product = p;
                pd.viewPresented = YES;
                
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:pd];
                 [Design navigationbar:nav.navigationBar config:config];
                completion(nav, nil);
                } else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[config localisedString:@"Item Not Available"] message:nil delegate:nil cancelButtonTitle:[config localisedString:@"Close"] otherButtonTitles: nil];
                    [alert show];
                }
                
                
                
            } else {
                //There was an error
                completion(nil, nil);
                
            }
            
        };
        [connection start];
    } 
    
}
@end
