//
//  NSURLConnectionWithTag.h
//  Steel Fashion
//
//  Created by Hanqing Hu on 9/12/13.
//  Copyright (c) 2013 Steel Fashion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MultiPageView.h"
@interface NSURLConnectionWithTag : NSURLConnection

@property int tag;
@property (nonatomic, strong) NSString * uuid;
@property (nonatomic, strong) NSString *item_id;
@property int index;
@property (nonatomic, strong) MPPage *page;
@property (nonatomic, strong) NSMutableData *receivedData;


- (id)initWithRequest:(NSMutableURLRequest *)request delegate:(id)del tag:(int)t;
- (id)initWithRequest:(NSMutableURLRequest *)request delegate:(id)del tag:(int)t index:(int)index;
- (id)initWithRequest:(NSMutableURLRequest *)request delegate:(id)del tag:(int)t index:(int)index withid:(NSString*)uuid;
- (id)initWithRequest:(NSMutableURLRequest *)request delegate:(id)del tag:(int)t page:(MPPage *)page;
@end
