//
//  DOM.h
//  Ecommerce
//
//  Created by Hanqing Hu on 11/30/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DOM : NSObject

@property id view;
@property Class cla;
@property id parent;
@property Class parcla;
@property (nonatomic, strong) NSMutableArray *children;
@property (nonatomic, strong) NSArray *margin;
@property (nonatomic, strong) NSArray *padding;

- (id)initWithView:(id)v parent:(id)parent;

@end
