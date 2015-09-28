//
//  CacheDataModule.h
//  Ecommerce
//
//  Created by Han Hu on 8/18/15.
//  Copyright (c) 2015 Twixxies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CachedDataModule : NSObject

@property (nonatomic, strong) NSMutableArray *cart;


-(void)save_default;
-(void)load_default;
-(void)clear;
-(NSString *)to_json;
-(NSDictionary *)to_dictionary;
@end
