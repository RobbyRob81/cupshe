//
//  Order.m
//  Ecommerce
//
//  Created by Hanqing Hu on 8/1/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import "Order.h"
#import "Cart.h"
@implementation Order

-(void)order_from_dictionary:(NSDictionary *)dic{
    self.order_id = [dic objectForKey:@"order_id"];
    self.receipient = [dic objectForKey:@"recipient"];
    self.address = [dic objectForKey:@"address"];
    self.city = [dic objectForKey:@"city"];
    self.state = [dic objectForKey:@"state"];
    self.zip = [dic objectForKey:@"zip"];
    self.country = [dic objectForKey:@"country"];
    self.shipping_id = [dic objectForKey:@"shipping_id"];
    self.shipping_name = [dic objectForKey:@"shipping_name"];
    self.timestamp = [dic objectForKey:@"timestamp"];
    self.shipping_date = [dic objectForKey:@"shipping_date"];
    self.return_date = [dic objectForKey:@"return_date"];
    self.total_product = [[dic objectForKey:@"total_product"] floatValue];
    self.total_shipping = [[dic objectForKey:@"total_shipping"] floatValue];
    self.total_tax = [[dic objectForKey:@"total_tax"] floatValue];
    self.status = [dic objectForKey:@"status"];
    self.items = [[NSMutableArray alloc] init];
    NSArray *i = [dic objectForKey:@"items"];
    for (NSDictionary *d in i){
        Cart *c = [[Cart alloc] init];
        [c cart_from_dictionary:d];
        [self.items addObject:c];
    }
}
@end
