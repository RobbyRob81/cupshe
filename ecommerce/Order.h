//
//  Order.h
//  Ecommerce
//
//  Created by Hanqing Hu on 8/1/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Order : NSObject

@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, strong) NSString *receipient;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *zip;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *shipping_id;
@property (nonatomic, strong) NSString *shipping_name;
@property (nonatomic, strong) NSString *timestamp;
@property (nonatomic, strong) NSString *shipping_date;
@property (nonatomic, strong) NSString *return_date;
@property float total_product;
@property float total_shipping;
@property float total_tax;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, strong) NSMutableArray *items;

-(void)order_from_dictionary:(NSDictionary *)dic;
@end
