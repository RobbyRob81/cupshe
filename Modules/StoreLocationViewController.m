//
//  StoreLocationViewController.m
//  Ecommerce
//
//  Created by Han Hu on 8/28/15.
//  Copyright (c) 2015 Twixxies. All rights reserved.
//

#import "StoreLocationViewController.h"
#import "NSURLConnectionBlock.h"
#import "Design.h"
#import "ionicons-codes.h"
#import "IonIcons.h"
#import "PKRevealController.h"
const NSString *GET_STORE=@"ecommerce/getStoreLocation";
@interface StoreLocationViewController ()

@end

@implementation StoreLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 44)] ;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:17.3];
    
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor colorWithRed:0.302 green:0.302 blue:0.318 alpha:1]; // change this color
    self.navigationItem.titleView = label;
    label.text = [self.config localisedString:[self.config localisedString:@"Store Locations"]];
    //[label sizeToFit];
    [Design navigationbar_title:label config:self.config];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    // Setup save button
    
    
    
    UILabel *menubtn = [IonIcons labelWithIcon:icon_navicon_round size:34 color:[UIColor blackColor]];
    menubtn.frame = CGRectMake(0, 0, 60, 44);
    UITapGestureRecognizer *menutap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    [menubtn addGestureRecognizer:menutap];
    menubtn.userInteractionEnabled = YES;
    [Design navigationbar_ion_icon:menubtn config:self.config];
    [Design style:[[DOM alloc] initWithView:menubtn parent:nil] design:[[self.config.design objectForKey:@"design"] objectForKey:@"left_navigation_ion_icon"] config:self.config];
    
    UIBarButtonItem *barbtn = [[UIBarButtonItem alloc] initWithCustomView:menubtn];
    
    
    self.navigationItem.leftBarButtonItem = barbtn;
    
    
    
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.config.screenWidth, self.config.screenHeight-64)];
    table.separatorColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1];
    table.rowHeight = 80;
    table.dataSource = self;
    table.delegate = self;
    
    [self.view addSubview:table];
    
    
    
    [self getStores];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getStores{
    
    NSString *myRequestString = [NSString stringWithFormat:@"app_uuid=%@", self.config.APP_UUID];
    NSData *myRequestData2 = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request2 = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@",self.config.API_ROOT, GET_STORE]]];
    [request2 setHTTPMethod: @"POST"];
    [request2 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request2 setHTTPBody: myRequestData2];
    
    
    NSURLConnectionBlock *connection = [[NSURLConnectionBlock alloc] initWithRequest:request2];
    connection.completion = ^(id obj, NSError *err) {
        
        if (!err) {
            //It's ok, do domething with the response data (obj)
            NSMutableData *d = (NSMutableData *)obj;
            NSString *response = [[NSString alloc] initWithBytes:[d bytes] length:[d length] encoding:NSUTF8StringEncoding];
            NSLog(@"%@",response);
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            
            NSMutableArray *sts = [[NSMutableArray alloc] init];
            for (NSDictionary *d in [dic objectForKey:@"stores"]){
                StoreLocation *st = [[StoreLocation alloc] init];
                [st dictionary_to_store:d];
                [sts addObject:st];
            }
            
            stores = [sts sortedArrayUsingComparator:^NSComparisonResult(StoreLocation *a, StoreLocation *b) {
                return [a.city compare:b.city];
            }];
            [table reloadData];
            
        } else {
            //There was an error
            
        }
        
    };
    [connection start];
    
    /*
     StoreLocation *a = [[StoreLocation alloc] init];
     StoreLocation *b = [[StoreLocation alloc] init];
     StoreLocation *c = [[StoreLocation alloc] init];
     a.city = @"a";
     b.city = @"b";
     c.city = @"c";
     
     NSMutableArray *sts = [[NSMutableArray alloc] initWithObjects:c,a,b, nil];
     stores = [sts sortedArrayUsingComparator:^NSComparisonResult(StoreLocation *a, StoreLocation *b) {
     return [a.city compare:b.city];
     }];
     
     for (StoreLocation *s in stores){
     NSLog(@"%@", s.city);
     }*/
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return stores.count;
    
    
}
/*- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
 UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
 
 
 header.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f];;
 CGRect headerFrame = header.frame;
 header.textLabel.frame = headerFrame;
 
 }
 
 -(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
 return [sectionTitle objectAtIndex:section];
 }*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    StoreLocation *st = [stores objectAtIndex:indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *city = [[UILabel alloc] initWithFrame:CGRectMake(15, 17, self.config.screenWidth-50, 20)];
    city.font = [UIFont boldSystemFontOfSize:17.3];
    city.text = [NSString stringWithFormat:@"%@, %@", st.city, st.state];
    [cell addSubview:city];
    
    UILabel *addr = [[UILabel alloc] initWithFrame:CGRectMake(15, 39, self.config.screenWidth-50, 30)];
    //addr.contentInset = UIEdgeInsetsMake(-6, -4, 0, 0);
    addr.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.3f];
    addr.text = st.address;
    //addr.editable = NO;
    //addr.scrollEnabled = NO;
    // addr.userInteractionEnabled = NO;
    [cell addSubview:addr];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    StoreLocation *st = [stores objectAtIndex:indexPath.row];
    StoreLocationDetailViewController *de = [[StoreLocationDetailViewController alloc] init];
    de.config = self.config;
    de.store = st;
    [self.navigationController pushViewController:de animated:YES];
}


-(void)back{
    if (self.navigationController.revealController.focusedController == self.navigationController.revealController.leftViewController)
    {
        [self.navigationController.revealController showViewController:self.navigationController.revealController.frontViewController];
    }
    else
    {
        
        [self.navigationController.revealController showViewController:self.navigationController.revealController.leftViewController];
    }
}

@end

@implementation StoreLocationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 44)] ;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:17.3];
    
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor colorWithRed:0.302 green:0.302 blue:0.318 alpha:1]; // change this color
    self.navigationItem.titleView = label;
    label.text = self.store.name;
    //[label sizeToFit];
    [Design navigationbar_title:label config:self.config];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    // Setup save button
    
    
    
    UILabel *menubtn = [IonIcons labelWithIcon:icon_ios7_arrow_back size:22 color:[UIColor blackColor]];;
    menubtn.frame = CGRectMake(0, 0, 60, 44);
    // menubtn.font = [UIFont fontWithName:kFontAwesomeFamilyName size:22.f];
    // menubtn.text =[NSString fontAwesomeIconStringForIconIdentifier:@"fa-bars"];
    
    UITapGestureRecognizer *menutap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    [menubtn addGestureRecognizer:menutap];
    menubtn.userInteractionEnabled = YES;
    
    [Design navigationbar_ion_icon:menubtn config:self.config];
    [Design style:[[DOM alloc] initWithView:menubtn parent:nil] design:[[self.config.design objectForKey:@"design"] objectForKey:@"left_navigation_ion_icon"] config:self.config];
    
    
    UIBarButtonItem *barbtn = [[UIBarButtonItem alloc] initWithCustomView:menubtn];
    
    
    self.navigationItem.leftBarButtonItem = barbtn;
    
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.config.screenWidth, (self.config.screenHeight-64)/4)];
    
    UITextView *addr = [[UITextView alloc] initWithFrame:CGRectMake(10, 20, self.config.screenWidth-20, 0)];
    addr.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.3f];
    addr.text = [NSString stringWithFormat:@"%@\n%@ %@ %@, %@", self.store.address, self.store.city, self.store.state, self.store.country, self.store.zip];
    addr.editable = NO;
    addr.scrollEnabled = NO;
    addr.userInteractionEnabled = NO;
    
    CGFloat fixedWidth = addr.frame.size.width;
    CGSize newSize = [addr sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    
    addr.frame = CGRectMake(addr.frame.origin.x, addr.frame.origin.y, addr.frame.size.width, newSize.height);
    [scroll addSubview:addr];
    
    UITextView *desc = [[UITextView alloc] initWithFrame:CGRectMake(addr.frame.origin.x, addr.frame.origin.y+addr.frame.size.height, addr.frame.size.width, 0)];
    desc.font =[UIFont fontWithName:@"HelveticaNeue-Light" size:17.3f];
    desc.text = self.store.desc;
    desc.editable = NO;
    desc.scrollEnabled = NO;
    desc.userInteractionEnabled = NO;
    
    fixedWidth = desc.frame.size.width;
    newSize = [desc sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    
    desc.frame = CGRectMake(desc.frame.origin.x, desc.frame.origin.y, desc.frame.size.width, newSize.height);
    [scroll addSubview:desc];
    
    scroll.contentSize = CGSizeMake(self.config.screenWidth, desc.frame.origin.y+desc.frame.size.height);
    
    [self.view addSubview:scroll];
    
    
    UIView *phoneview = [[UIView alloc] initWithFrame:CGRectMake(0, scroll.frame.origin.y+scroll.frame.size.height, self.config.screenWidth, 50)];
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, phoneview.frame.size.width, 0.5);
    layer.backgroundColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
    [phoneview.layer addSublayer:layer];
    CALayer *layer2 = [CALayer layer];
    layer2.frame = CGRectMake(0, phoneview.frame.size.height-0.5, phoneview.frame.size.width, 0.5);
    layer2.backgroundColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
    [phoneview.layer addSublayer:layer2];
    
    UILabel *phonelabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, phoneview.frame.size.width-40, phoneview.frame.size.height)];
    phonelabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3];
    phonelabel.textColor = [UIColor colorWithRed:41.0/255.0 green:39/255.0 blue:39/255.0 alpha:1];
    phonelabel.text = self.store.phone;
    [phoneview addSubview:phonelabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(call)];
    phoneview.userInteractionEnabled = YES;
    [phoneview addGestureRecognizer:tap];
    
    [self.view addSubview:phoneview];
    
    
    map = [[MKMapView alloc] initWithFrame:CGRectMake(0, phoneview.frame.origin.y+phoneview.frame.size.height, self.config.screenWidth, self.config.screenHeight - phoneview.frame.origin.y-phoneview.frame.size.height)];
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = self.store.lat;
    zoomLocation.longitude= self.store.lng;
    
    SLAnnotation *sl = [[SLAnnotation alloc] init];
    sl.coordinate = zoomLocation;
    
    [map addAnnotation:sl];
    // 2
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 900, 900);
    
    // 3
    [map setRegion:viewRegion animated:YES];
    
    [self.view addSubview:map];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)call{
    
    NSString *num = [self.store.phone stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", num]]];
}


-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

@implementation StoreLocation

-(void)dictionary_to_store:(NSDictionary *)dic{
    self.name = [dic objectForKey:@"store_name"];
    self.address = [dic objectForKey:@"address"];
    self.city = [dic objectForKey:@"city"];
    self.state = [dic objectForKey:@"state"];
    self.country = [dic objectForKey:@"country"];
    self.zip = [dic objectForKey:@"zip"];
    self.phone = [dic objectForKey:@"phone"];
    self.desc = [dic objectForKey:@"description"];
    self.lat = [[dic objectForKey:@"latitude"] floatValue];
    self.lng = [[dic objectForKey:@"longitude"] floatValue];
}

@end


@implementation SLAnnotation



@end