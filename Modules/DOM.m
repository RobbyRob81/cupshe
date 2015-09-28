//
//  DOM.m
//  Ecommerce
//
//  Created by Hanqing Hu on 11/30/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import "DOM.h"

@implementation DOM

- (id)initWithView:(id)v parent:(id)parent;
{
    self = [super init];
    if (self){
        self.view = v;
        self.parent = parent;
    }
    return self;
    
}

@end
