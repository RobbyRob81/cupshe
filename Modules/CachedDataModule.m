//
//  CacheDataModule.m
//  Ecommerce
//
//  Created by Han Hu on 8/18/15.
//  Copyright (c) 2015 Twixxies. All rights reserved.
//

#import "CachedDataModule.h"

@implementation CachedDataModule


- (id)init
{
    self = [super init];
    if (self){
        self.cart = [[NSMutableArray alloc] init];
    }
    return self;
    
}

-(NSDictionary *)to_dictionary{
    NSMutableDictionary *d=  [[NSMutableDictionary alloc] init];
    [d setObject:self.cart forKey:@"cart"];
    return d;
}
-(NSString *)to_json{
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self to_dictionary]
                                                       options:0
                                                         error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}
-(void)clear{
    [self.cart removeAllObjects];
    [self save_default];
}

-(void)save_default{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self to_dictionary] forKey:@"cached_data"];
    [defaults synchronize];
}
-(void)load_default{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *d = [defaults objectForKey:@"cached_data"];
    self.cart = [d objectForKey:@"cart"];
    if (self.cart == nil) self.cart = [[NSMutableArray alloc] init];
}
@end