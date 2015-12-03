//
//  Shipping.m
//  Ecommerce
//
//  Created by Hanqing Hu on 7/13/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import "Shipping.h"
#import "Cart.h"

@implementation ShippingCountry

-(void)shipping_country_from_dictionary:(NSDictionary *)d{
    self.name = [d objectForKey:@"country"];
    self.code = [d objectForKey:@"country_code"];
    self.tax = [NSDecimalNumber decimalNumberWithString:[d objectForKey:@"tax"]];
    self.states = [[NSMutableArray alloc] init];
    NSArray *states = [d objectForKey:@"states"];
    for (NSDictionary *dic in states){
        ShippingState *ss = [[ShippingState alloc] init];
        [ss shipping_state_from_dictionary:dic];
        [self.states addObject:ss];
    }
    self.shippings = [[NSMutableArray alloc] init];
    NSArray *ship = [d objectForKey:@"shippings"];
    for (NSDictionary *dic in ship){
        Shipping *s = [[Shipping alloc] init];
        [s shipping_from_dictionary:dic];
        [self.shippings addObject:s];
    }
    
}

-(NSDecimalNumber *)claculate_shipping:(NSArray *)cart totalprice:(NSDecimalNumber *)total{
    return [[NSDecimalNumber alloc] initWithInt:0];
}

@end


@implementation ShippingState

-(void)shipping_state_from_dictionary:(NSDictionary *)d{
    self.name = [d objectForKey:@"state"];
    self.code = [d objectForKey:@"code"];
    self.tax = [NSDecimalNumber decimalNumberWithString:[d objectForKey:@"tax"]];
    
}

@end


@implementation Shipping

-(void) shipping_from_dictionary:(NSDictionary *)d{
    self.shipping_id = [d objectForKey:@"shipping_id"];
    self.type = [d objectForKey:@"type"];
    self.name = [d objectForKey:@"name"];
    self.base_price = [NSDecimalNumber decimalNumberWithString:[d objectForKey:@"base"]] ;
    self.additional_price = [NSDecimalNumber decimalNumberWithString:[d objectForKey:@"additional"]];
    self.free_threshold = [NSDecimalNumber decimalNumberWithString:[d objectForKey:@"free"]];
    self.weights = [[NSMutableArray alloc] init];
    if ([self.type isEqualToString:@"2"]){
        NSDictionary *wd = [d objectForKey:@"weight_range"];
        NSArray *ws = [wd objectForKey:@"weights"];
        for (NSDictionary *dic in ws){
            ShippingWeight *sw = [[ShippingWeight alloc] init];
            [sw weight_from_dictionary:dic];
            [self.weights addObject:sw];
        }
    }
}

-(NSDecimalNumber *)claculate_shipping:(NSArray *)cart totalprice:(NSDecimalNumber *)total{
    if ([self.type isEqualToString:@"1"]){
        if ([total compare:self.free_threshold]== NSOrderedDescending && ![self.free_threshold isEqualToNumber:[NSNumber numberWithInt:0]]) {
            
            return [NSDecimalNumber decimalNumberWithString:@"0"];
        } else {
            NSDecimalNumber *totalp = self.base_price;
            totalp =[totalp decimalNumberByAdding:[self.additional_price decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%ld",(cart.count-1)]]]];
            return totalp;
        }
        
    } else if ([self.type isEqualToString:@"2"]){
        float totalweight = 0;
        for (Cart *c in cart){
            totalweight+= c.weight;
        }
        
        BOOL found = NO;
        for (ShippingWeight *sw in self.weights){
            if (sw.low <= totalweight && (sw.high > totalweight || sw.high == 0)){
                if (sw.name != nil && sw.name.length > 0)
                    self.name = sw.name;
                return sw.cost;
                
                
            }
        }
        return  [NSDecimalNumber decimalNumberWithString:@"0"];
        
    } else {
        return nil;
    }
}
@end

@implementation ShippingWeight

-(void)weight_from_dictionary:(NSDictionary *)d{
    self.low = [[d objectForKey:@"low"] doubleValue];
    self.high = [[d objectForKey:@"high"] doubleValue];
    NSString *cost = [NSString stringWithFormat:@"%@", [d objectForKey:@"cost"]];
    self.cost = [NSDecimalNumber decimalNumberWithString:cost] ;
    self.name = [d objectForKey:@"name"];
    
}



@end
