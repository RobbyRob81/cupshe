//
//  NSURLConnectionBlock.h
//  Moooh
//
//  Created by Hanqing Hu on 3/21/15.
//  Copyright (c) 2015 Twixxies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLConnectionBlock : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate> {
    NSURLConnection * internalConnection;
    NSMutableData * container;
}

-(id)initWithRequest:(NSURLRequest *)req;

@property (nonatomic,copy)NSURLConnection * internalConnection;
@property (nonatomic,copy)NSURLRequest *request;
@property (nonatomic,copy)void (^completion) (id obj, NSError * err);


-(void)start;

@end


