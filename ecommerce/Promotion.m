//
//  Promotion.m
//  Ecommerce
//
//  Created by Hanqing Hu on 5/25/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import "Promotion.h"

@implementation Promotion


-(void)promotion_from_dictionary:(NSDictionary *)d{
    self.promotion_id = [d objectForKey:@"promotion_id"];
    self.title = [d objectForKey:@"title"];
    self.product_filter = [d objectForKey:@"product_filter"];
    self.enddate = [d objectForKey:@"end_date"];
    self.imageURL = [d objectForKey:@"image_url"];
    self.departmentid = [d objectForKey:@"department_id"];
    self.category = [d objectForKey:@"category"];
    self.type = [d objectForKey:@"type"];
    self.module_type = [d objectForKey:@"module_type"];
    if (![[d objectForKey:@"show_preview_text"] isKindOfClass:[NSNull class]])
    self.show_preview_text = [[d objectForKey:@"show_preview_text"] intValue];
    
}
@end
