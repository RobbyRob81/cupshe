//
//  NSURLConnectionBlock.m
//  Moooh
//
//  Created by Hanqing Hu on 3/21/15.
//  Copyright (c) 2015 Twixxies. All rights reserved.
//

#import "NSURLConnectionBlock.h"

@implementation NSURLConnectionBlock
@synthesize request,completion,internalConnection;

-(id)initWithRequest:(NSURLRequest *)req {
    self = [super init];
    if (self) {
        [self setRequest:req];
    }
    return self;
}

-(void)start {
    
    container = [[NSMutableData alloc]init];
    
    internalConnection = [[NSURLConnection alloc]initWithRequest:[self request] delegate:self startImmediately:YES];
    
    
}


#pragma mark NSURLConnectionDelegate methods

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [container appendData:data];
    
}

//If finish, return the data and the error nil
-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    if([self completion])
        [self completion](container,nil);
    
    
    
}

//If fail, return nil and an error
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    if([self completion])
        [self completion](nil,error);
    
    
    
}


@end
