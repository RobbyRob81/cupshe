//
//  Billboard.m
//  Ecommerce
//
//  Created by Hanqing Hu on 1/6/15.
//  Copyright (c) 2015 Twixxies. All rights reserved.
//

#import "Billboard.h"

@implementation Billboard

-(void)billboard_from_dictionary:(NSDictionary *)d{
    self.billboard_id = [d objectForKey:@"billboard_id"];
    self.department_id = [d objectForKey:@"department_id"];
    self.title = [d objectForKey:@"title"];
    self.desc = [d objectForKey:@"description"];
    self.html = [d objectForKey:@"html"];
    self.preview_img = [d objectForKey:@"preview_url"];
    self.background_img = [d objectForKey:@"background_url"];
    self.product_filter = [d objectForKey:@"product_filter"];
    self.type = [d objectForKey:@"type"];
    self.module_type = [d objectForKey:@"module_type"];
    if (![[d objectForKey:@"show_preview_text"] isKindOfClass:[NSNull class]])
    self.show_preview_text = [[d objectForKey:@"show_preview_text"] intValue];
    NSArray *c = [d objectForKey:@"background_color"];
    if ([c isKindOfClass:[NSNull class]] || c.count != 3){
        self.backcolor = [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:1];
    } else {
        float r = [[c objectAtIndex:0] floatValue];
        float g = [[c objectAtIndex:1] floatValue];
        float b = [[c objectAtIndex:2] floatValue];
        self.backcolor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
    }
    
    NSArray *tc = [d objectForKey:@"preview_text_color"];
    if ([tc isKindOfClass:[NSNull class]] || tc.count != 3){
        self.preview_text_color = [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:1];
    } else {
        float r = [[tc objectAtIndex:0] floatValue];
        float g = [[tc objectAtIndex:1] floatValue];
        float b = [[tc objectAtIndex:2] floatValue];
        self.preview_text_color = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
    }
    
}

@end
