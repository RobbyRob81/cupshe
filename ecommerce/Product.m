//
//  Product.m
//  Ecommerce
//
//  Created by Hanqing Hu on 5/25/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import "Product.h"
#import "ProductVar.h"
@implementation Product


-(void)product_from_dictionary:(NSDictionary *)d{
    self.product_id = [d objectForKey:@"product_id"];
    self.name = [[d objectForKey:@"name"]  stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.imageURL = [d objectForKey:@"image_url"];
    if ([d objectForKey:@"images"] != nil && ![[d objectForKey:@"images"] isKindOfClass:[NSNull class]]){
        self.images = [d objectForKey:@"images"];
    } else self.images = [[NSMutableArray alloc] init];
    
    if ([d objectForKey:@"unassigned_images"] != nil && ![[d objectForKey:@"unassigned_images"] isKindOfClass:[NSNull class]]){
        self.unassigned_images = [d objectForKey:@"unassigned_images"];
    } else self.unassigned_images = [[NSMutableArray alloc] init];
    
    
    self.brand = [[d objectForKey:@"brand"]  stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.desc = [d objectForKey:@"description"];
    self.total_stock = [[d objectForKey:@"total_stock"] intValue];
    self.third_party_id = [d objectForKey:@"third_party_id"];
    self.fav_id = [d objectForKey:@"fav_id"];
    //self.remoteimg_URL = [d objectForKey:@"remote_img"];
    //self.price = [[d objectForKey:@"price"] doubleValue];
    //self.sale_price = [[d objectForKey:@"sale_price"] doubleValue];
    //self.sale_startdate = [d objectForKey:@"sale_startdate"];
    //self.sale_enddate = [d objectForKey:@"sale_enddate"];
    self.variations = [[NSMutableArray alloc] init];
    NSArray *vars = [d objectForKey:@"variations"];
    for (NSDictionary *d in vars){
        ProductVar *pv = [[ProductVar alloc] init];
        [pv product_var_from_dictionary:d];
        [self.variations addObject:pv];
    }
    
}



-(Product *)copy_product{
    Product *other = [[Product alloc] init];
    other.product_id = self.product_id;
    other.name = self.name;
    other.imageURL = self.imageURL;
    other.brand = self.brand;
    other.desc = self.desc;
    //other.price = self.price;
    //other.sale_price = self.sale_price;
    //other.sale_startdate = self.sale_startdate;
    //other.sale_enddate = self.sale_enddate;
    other.variations = [NSArray arrayWithArray:self.variations];
    return other;
}
@end
