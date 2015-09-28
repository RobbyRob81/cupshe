//
//  WholesaleModule.m
//  Ecommerce
//
//  Created by Han Hu on 8/8/15.
//  Copyright (c) 2015 Twixxies. All rights reserved.
//

#import "WholesaleModule.h"
#import "NSURLConnectionBlock.h"
#import "Config.h"
const NSString *WHO_GET_WHOLESALEUSER = @"https://www.twixxies.com/wholesaleapi/getWholesaleUser";
const NSString *WHO_GET_WHOLESALEAPP =@"https://www.twixxies.com/wholesaleapi/getWholesaleapp";


@implementation WholesaleModule

+(void)getWholesaleApp:(id)config completion:(void (^)(WholesaleModule *, NSError *))completion{
    Config *cf = (Config *)config;
    NSString *myRequestString = [NSString stringWithFormat:@"appkey=%@&location=%@&currency=%@", cf.APP_UUID, cf.location, cf.currency];
    NSData *myRequestData2 = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request2 = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@",WHO_GET_WHOLESALEAPP]]];
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
            
            WholesaleModule *wm = [[WholesaleModule alloc] init];
            wm.wholesale_app_id = [dic objectForKey:@"wholesale_app_id"];
            
            
            completion(wm, nil);
        } else {
            //There was an error
            completion(nil, nil);
        }
        
    };
    [connection start];
}

+(void)getWholesaleUserDetail:(id)config completion:(void (^)(WholesaleModule *, NSError *))completion{
    Config *cf = (Config *)config;
    NSString *myRequestString = [NSString stringWithFormat:@"appkey=%@&location=%@&currency=%@&user_id=%@&wholesale_user_id=%@", cf.APP_UUID, cf.location, cf.currency, cf.user_id, cf.wholesale.wholesale_user_id];
    NSData *myRequestData2 = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request2 = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@",WHO_GET_WHOLESALEUSER]]];
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
            
            WholesaleModule *wm = [[WholesaleModule alloc] init];
            wm.tier_id = [dic objectForKey:@"tier_id"];
            wm.tier_name = [dic objectForKey:@"tier_name"];
            wm.status = [dic objectForKey:@"status"];
            
            
            completion(wm, nil);
        } else {
            //There was an error
            completion(nil, nil);
        }
        
    };
    [connection start];
}

@end


@implementation WholesaleViewController



@end
