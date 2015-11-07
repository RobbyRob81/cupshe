//
//  ProductVar.h
//  Ecommerce
//
//  Created by Hanqing Hu on 7/4/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductVar : NSObject

@property (nonatomic, strong) NSString *sku;
@property double price;
@property double sale_price;
@property (nonatomic, strong) NSString *sale_startdate;
@property (nonatomic, strong) NSString *sale_enddate;
@property double weight;
@property int stock;
@property (nonatomic, strong) NSString *product_var_id;
@property (nonatomic, strong) NSMutableDictionary *attributes;
@property (nonatomic, strong) NSMutableArray *images;


-(void)product_var_from_dictionary:(NSDictionary *)d;
@end
