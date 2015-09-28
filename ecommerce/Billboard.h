//
//  Billboard.h
//  Ecommerce
//
//  Created by Hanqing Hu on 1/6/15.
//  Copyright (c) 2015 Twixxies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Billboard : NSObject

@property (nonatomic, strong) NSString *billboard_id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *html;
@property (nonatomic, strong) NSString *preview_img;
@property (nonatomic, strong) NSString *background_img;
@property (nonatomic, strong) NSString *product_filter;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *module_type;
@property (nonatomic, strong) NSString *department_id;
@property (nonatomic, strong) UIColor *backcolor;
@property (nonatomic, strong) UIColor *preview_text_color;
@property int show_preview_text;
-(void)billboard_from_dictionary:(NSDictionary *)d;
@end
