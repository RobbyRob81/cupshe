//
//  Cart.m
//  Ecommerce
//
//  Created by Hanqing Hu on 7/5/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import "Cart.h"

@implementation Cart

-(void)cart_from_dictionary:(NSDictionary *)d{
    self.cart_id = [d objectForKey:@"cart_id"];
    self.product_id = [d objectForKey:@"product_id"];
    self.name = [d objectForKey:@"name"];
    self.brand = [d objectForKey:@"brand"];
    self.desc = [d objectForKey:@"description"];
    self.imageURL = [d objectForKey:@"image_url"];
    self.product_var_id = [d objectForKey:@"product_var_id"];
    NSString *del = [d objectForKey:@"deleted"];
    if ([del isKindOfClass:[NSNull class]]) {
        self.deleted = 1;
    } else {
        self.deleted = [del intValue];
    }
    self.sku = [d objectForKey:@"sku"];
    NSString *pr = [d objectForKey:@"price"];
    if ([pr isKindOfClass:[NSNull class]] || pr == nil){
        self.price = [NSDecimalNumber decimalNumberWithString:@"0"];
    } else {
        self.price = [NSDecimalNumber decimalNumberWithString:pr];
    }
    NSString *sp = [d objectForKey:@"sale_price"];
    if ([sp isKindOfClass:[NSNull class]] || sp==nil){
        self.sale_price = [NSDecimalNumber decimalNumberWithString:@"0"];
    } else {
        self.sale_price = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@", sp]];
    }
    self.paid_price = [[d objectForKey:@"paid_price"] doubleValue];
    self.sale_start = [d objectForKey:@"sale_start"];
    self.sale_end = [d objectForKey:@"sale_end"];
    NSString *st = [d objectForKey:@"stock"];
    if ([st isKindOfClass:[NSNull class]]){
        self.stock = 0;
    } else {
        self.stock = [st intValue];
    }
    //self.stock = [[d objectForKey:@"stock"] intValue];
    NSString *w = [d objectForKey:@"weight"];
    if ([w isKindOfClass:[NSNull class]]){
        self.weight = 0;
    } else self.weight = [w floatValue];
    NSString *quan = [d objectForKey:@"quantity"];
    if ([quan isKindOfClass:[NSNull class]]){
        self.quantity = 0;
    } else self.quantity = [quan intValue];
    self.attr_string = [d objectForKey:@"attribute_str"];
    
    NSArray *arr = [d objectForKey:@"attribute"];
    for (NSDictionary *a in arr){
        [self.attributes setObject:[a objectForKey:@"name"] forKey:[a objectForKey:@"value"]];
    }
    
}

-(NSMutableDictionary *)cart_to_dictionary{
    NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
    NSDate *now = [NSDate date];
    NSTimeInterval epoch = [now timeIntervalSince1970];
    [d setObject:[NSString stringWithFormat:@"%0.0f", epoch] forKey:@"cart_id"];
    if (self.product_id != nil){
        [d setObject:self.product_id forKey:@"product_id"];
    }
    if (self.name!= nil){
        [d setObject:self.name forKey:@"name"];
    }
    if (self.brand != nil) {
        [d setObject:self.brand forKey:@"brand"];
    }
    if (self.desc != nil) {
        [d setObject:self.desc forKey:@"description"];
    }
    if (self.imageURL != nil){
        [d setObject:self.imageURL forKey:@"image_url"];
    }
    if (self.product_var_id != nil){
        [d setObject:self.product_var_id forKey:@"product_var_id"];
    }
    [d setObject:[NSString stringWithFormat:@"%d", self.deleted] forKey:@"deleted"];
    if (self.sku != nil){
        [d setObject:self.sku forKey:@"sku"];
    }
    if (self.price != nil){
        [d setObject:[self.price stringValue] forKey:@"price"];
    }
    if (self.sale_price != nil){
        [d setObject:[self.sale_price stringValue] forKey:@"sale_price"];
    }
    [d setObject:[NSString stringWithFormat:@"%0.2f", self.paid_price] forKey:@"paid_price"];
    if (self.sale_start != nil){
        [d setObject:self.sale_start forKey:@"sale_start"];
    }
    if (self.sale_end != nil){
        [d setObject:self.sale_end forKey:@"sale_end"];
    }
    [d setObject:[NSString stringWithFormat:@"%d", self.stock] forKey:@"stock"];
    [d setObject:[NSString stringWithFormat:@"%f", self.weight] forKey:@"weight"];
    [d setObject:[NSString stringWithFormat:@"%d", self.quantity] forKey:@"quantity"];
    if (self.attr_string != nil){
        [d setObject:self.attr_string forKey:@"attribute_str"];
    }
    NSArray *attrkey = [self.attributes allKeys];
    NSMutableArray *attrs = [[NSMutableArray alloc] init];
    for (NSString *key in attrkey){
        NSDictionary *ad = [[NSDictionary alloc] initWithObjectsAndKeys:key, @"name", [self.attributes objectForKey:key], @"value", nil];
        [attrs addObject:ad];
        
    }
    [d setObject:attrs forKey:@"attribute"];
    
    
    return d;
}

@end
