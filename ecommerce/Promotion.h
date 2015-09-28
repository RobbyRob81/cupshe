//
//  Promotion.h
//  Ecommerce
//
//  Created by Hanqing Hu on 5/25/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Promotion : NSObject

@property (nonatomic, strong) NSString *promotion_id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *product_filter;
@property (nonatomic, strong) NSString *enddate;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *departmentid;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *module_type;
@property int show_preview_text;

-(void)promotion_from_dictionary:(NSDictionary *)d;
@end
