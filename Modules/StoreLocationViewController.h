//
//  StoreLocationViewController.h
//  Ecommerce
//
//  Created by Han Hu on 8/28/15.
//  Copyright (c) 2015 Twixxies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import <Mapkit/Mapkit.h>
@class StoreLocation;
@interface StoreLocationViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    UITableView *table;
    NSArray *stores;
}
@property (nonatomic, strong) Config *config;

@end


@interface StoreLocationDetailViewController : UIViewController  {
    MKMapView *map;
}
@property (nonatomic, strong) Config *config;
@property (nonatomic, strong) StoreLocation *store;
@end

@interface StoreLocation : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *sid;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *zip;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *desc;
@property float lat;
@property float lng;

-(void)dictionary_to_store:(NSDictionary *)dic;


@end


@interface SLAnnotation : NSObject <MKAnnotation> {
   // CLLocationCoordinate2D coordinate;
}

@property (nonatomic) CLLocationCoordinate2D coordinate;

@end
