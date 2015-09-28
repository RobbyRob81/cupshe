//
//  NSURLConnectionWithTag.m
//  Steel Fashion
//
//  Created by Hanqing Hu on 9/12/13.
//  Copyright (c) 2013 Steel Fashion. All rights reserved.
//

#import "NSURLConnectionWithTag.h"


@implementation NSURLConnectionWithTag
@synthesize tag, item_id;
- (id)initWithRequest:(NSMutableURLRequest *)request delegate:(id)del tag:(int)t
{
    self = [super initWithRequest:request delegate:del];
    if (self){
        self.tag = t;
        self.receivedData = [[NSMutableData alloc] init];
    }
    return self;
    
}

- (id)initWithRequest:(NSMutableURLRequest *)request delegate:(id)del tag:(int)t page:(MPPage *)page{
    self = [super initWithRequest:request delegate:del];
    if (self){
        self.tag = t;
        self.page = page;
         self.receivedData = [[NSMutableData alloc] init];
    }
    return self;
}



- (id)initWithRequest:(NSMutableURLRequest *)request delegate:(id)del tag:(int)t index:(int)index{
    self = [super initWithRequest:request delegate:del];
    if (self){
        self.tag = t;
        self.index = index;
         self.receivedData = [[NSMutableData alloc] init];
    }
    return self;
}

- (id)initWithRequest:(NSMutableURLRequest *)request delegate:(id)del tag:(int)t index:(int)index withid:(NSString *)uuid{
    self = [super initWithRequest:request delegate:del];
    if (self){
        self.tag = t;
        self.index = index;
        self.uuid = uuid;
         self.receivedData = [[NSMutableData alloc] init];
    }
    return self;
}
@end