//
//  Product.h
//  Ecommerce
//
//  Created by Hanqing Hu on 5/25/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

@property (nonatomic, strong) NSString *product_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *unassigned_images;
@property (nonatomic, strong) NSString *third_party_id;
@property (nonatomic, strong) NSString *brand;
@property (nonatomic, strong) NSString  *desc;

@property (nonatomic, strong) NSMutableArray *variations;
@property (nonatomic, strong) UIImage *itemImage;

@property (nonatomic, strong) NSString *cart_id;
@property (nonatomic, strong) NSString *fav_id;
@property (nonatomic, strong) NSString *selected_var;
@property (nonatomic, strong) NSString *selected_var_name;
@property int total_stock;
@property int deleted;
@property int detail_loaded;
-(void)product_from_dictionary:(NSDictionary *)d;


-(Product *)copy_product;
@end
