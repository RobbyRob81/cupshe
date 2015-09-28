//
//  Shipping.h
//  Ecommerce
//
//  Created by Hanqing Hu on 7/13/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Shipping : NSObject

@property (nonatomic, strong) NSString *shipping_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *type;
@property NSDecimalNumber *base_price;
@property NSDecimalNumber *additional_price;
@property NSDecimalNumber *free_threshold;
@property (nonatomic, strong) NSMutableArray *weights;

-(void)shipping_from_dictionary:(NSDictionary *)d;
-(NSDecimalNumber *)claculate_shipping:(NSArray *)cart totalprice:(NSDecimalNumber *)total;
@end


@interface ShippingWeight : NSObject
@property  float low;
@property float high;
@property (nonatomic, strong) NSDecimalNumber *cost;

-(void)weight_from_dictionary:(NSDictionary *)d;

@end