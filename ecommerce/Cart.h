//
//  Cart.h
//  Ecommerce
//
//  Created by Hanqing Hu on 7/5/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cart : NSObject

@property (nonatomic, strong) NSString *cart_id;
@property (nonatomic, strong) NSString *product_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *brand;
@property (nonatomic, strong) NSString  *desc;
@property (nonatomic, strong) NSString *product_var_id;
@property (nonatomic, strong) NSString *sku;
@property int deleted;
@property NSDecimalNumber *price;
@property NSDecimalNumber *sale_price;
@property NSString *sale_start;
@property NSString *sale_end;
@property int stock;
@property float weight;
@property (nonatomic, strong) NSMutableDictionary *attributes;

@property int quantity;
@property double paid_price;
@property double original_price;
@property (nonatomic, strong) NSString *attr_string;

@property (nonatomic, strong) UIImage *itemImage;


-(void)cart_from_dictionary:(NSDictionary *)d;
@end
