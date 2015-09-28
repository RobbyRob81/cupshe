//
//  ViewWithID.m
//  Ecommerce
//
//  Created by Hanqing Hu on 12/4/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import "ViewWithData.h"

@implementation ViewWithData

-(id)init{
    self = [super init];
    if (self){
        self.IDs = [[NSMutableDictionary alloc] init];
        self.subpages = [[NSMutableDictionary alloc] init];
    }
    return self;
}


@end

@implementation LabelWithData

@synthesize sharetext, shareimg, shareurl;

@end

@implementation ImageWithData

@synthesize initial_frame;

@end

@implementation ButtonWithData



@end