//
//  ProductVar.m
//  Ecommerce
//
//  Created by Hanqing Hu on 7/4/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import "ProductVar.h"

@implementation ProductVar

-(void)product_var_from_dictionary:(NSDictionary *)d{
    
    self.product_var_id = [d objectForKey:@"product_var_id"];
    self.price = [[d objectForKey:@"price"] doubleValue];
    self.sale_price = [[d objectForKey:@"sale_price"] doubleValue];
    self.sale_startdate = [d objectForKey:@"sale_startdate"];
    self.sale_enddate = [d objectForKey:@"sale_enddate"];
    self.stock = [[d objectForKey:@"stock"] intValue];
    self.weight = [[d objectForKey:@"weight"] doubleValue];
    self.sku = [d objectForKey:@"sku"];
    self.attributes = [[NSMutableDictionary alloc] init];
    NSArray *attr = [d objectForKey:@"attributes"];
    for (NSDictionary *d in attr){
        NSString *name  = [d objectForKey:@"name"];
        NSString *value = [d objectForKey:@"value"];
        [self.attributes setObject:value forKey:name];
    }
    
}


@end
