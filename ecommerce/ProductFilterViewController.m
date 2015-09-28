//
//  ProductFilterViewController.m
//  Ecommerce
//
//  Created by Hanqing Hu on 8/14/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import "ProductFilterViewController.h"
#import "ProductViewController.h"
#import "NSURLConnectionWithTag.h"
#import "Design.h"
#import "ionicons-codes.h"
#import "IonIcons.h"
const int UPDATE_FILTER = 1;
@interface ProductFilterViewController ()

@end

@implementation ProductFilterViewController
@synthesize table;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    table.backgroundView = nil;
    table.backgroundColor = [UIColor clearColor];
    selattr = [[NSMutableArray alloc] init];
    
    cat = [[NSMutableArray alloc] init];
    
    NSDictionary *d = [[[self.config.design objectForKey:@"components"] objectForKey:@"filter_page"] objectForKey:@"style"];
    design = [[ProductFilterDesign alloc] init];
    design.active_sel_but = [[self.config.design objectForKey:@"design"] objectForKey:[d objectForKey:@"active-select-button"]];
    design.select_but = [[self.config.design objectForKey:@"design"] objectForKey:[d objectForKey:@"select-button"]];
    design.filter_checkmark = [[self.config.design objectForKey:@"design"] objectForKey:[d objectForKey:@"filter-checkmark"]];
    design.apply_background = [[self.config.design objectForKey:@"design"] objectForKey:[d objectForKey:@"apply-background"]];
    
    ProductViewController *par = (ProductViewController *)self.parent;
    cat = par.category;
    rank = par.rank;
    selattr = par.attribute;
    
    //CGRect frame = CGRectMake(8, 133, self.config.screenWidth-16, 1);
    //separator.frame = frame;
    //separator.frame = CGRectMake(filterseg.frame.origin.x, separator.frame.origin.y, filterseg.frame.size.width, 1);
    // CALayer *layer = [CALayer layer];
    //layer.frame = CGRectMake(0, 0, separator.frame.size.width, 0.5);
    //layer.backgroundColor = [[UIColor colorWithRed:53/255.0 green:53/255.0 blue:53/255.0 alpha:1] CGColor];
    //[separator.layer addSublayer:layer];
    
    separator.layer.borderColor = [[UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1] CGColor];
    separator.layer.borderWidth = 0.5;
    
    rankfeature.titleLabel.font = [IonIcons fontWithSize:18];
    rankhigh.titleLabel.font = [IonIcons fontWithSize:18];
    ranklow.titleLabel.font = [IonIcons fontWithSize:18];
    if ([rank isEqualToString:@"featured"]){
        [rankfeature setTitle:icon_record forState:UIControlStateNormal];
        [Design style:[[DOM alloc] initWithView:rankfeature parent:nil] design:design.active_sel_but config:self.config];
        [rankhigh setTitle:icon_ios7_circle_outline forState:UIControlStateNormal];
        [Design style:[[DOM alloc] initWithView:rankhigh parent:nil] design:design.select_but config:self.config];
        [ranklow setTitle:icon_ios7_circle_outline forState:UIControlStateNormal];
        [Design style:[[DOM alloc] initWithView:ranklow parent:nil] design:design.select_but config:self.config];
        
        rank = @"featured";
    } else if ([rank isEqualToString:@"low"]){
        [rankfeature setTitle:icon_ios7_circle_outline forState:UIControlStateNormal];
        [Design style:[[DOM alloc] initWithView:rankfeature parent:nil] design:design.select_but config:self.config];
        [rankhigh setTitle:icon_ios7_circle_outline forState:UIControlStateNormal];
        [Design style:[[DOM alloc] initWithView:rankhigh parent:nil] design:design.select_but config:self.config];
        [ranklow setTitle:icon_record forState:UIControlStateNormal];
        [Design style:[[DOM alloc] initWithView:ranklow parent:nil] design:design.active_sel_but config:self.config];
        
        rank = @"low";
    } else if ([rank isEqualToString:@"high"]){
        [rankfeature setTitle:icon_ios7_circle_outline forState:UIControlStateNormal];
        [Design style:[[DOM alloc] initWithView:rankfeature parent:nil] design:design.select_but config:self.config];
        [rankhigh setTitle:icon_record forState:UIControlStateNormal];
        [Design style:[[DOM alloc] initWithView:rankhigh parent:nil] design:design.active_sel_but config:self.config];
        [ranklow setTitle:icon_ios7_circle_outline forState:UIControlStateNormal];
        [Design style:[[DOM alloc] initWithView:ranklow parent:nil] design:design.select_but config:self.config];
        rank = @"high";
    }
    
    [cancel setTitle:[self.config localisedString:@"Cancel"] forState:UIControlStateNormal];
    [clear setTitle:[self.config localisedString:@"Clear"] forState:UIControlStateNormal];
    titleLabel.text = [self.config localisedString:@"Filter"];
    featuredLabel.text = [self.config localisedString:@"Featured"];
    lowhighLabel.text = [self.config localisedString:@"Low Price"];
    highlowLabel.text = [self.config localisedString:@"High Price"];
    
    
    sorted_filter_keys = [[self.filters allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    
    for (int i = 0; i < [sorted_filter_keys count]; i++){
        
        if (i < 2) {
            [filterseg setTitle:[sorted_filter_keys objectAtIndex:i] forSegmentAtIndex:i];
            if (i == 0){
                active_filter = [self.filters objectForKey:[sorted_filter_keys objectAtIndex:i]];
                NSString *title = [filterseg titleForSegmentAtIndex:filterseg.selectedSegmentIndex];
                NSString *section =[[active_filter allKeys] objectAtIndex:0];
                if ([section isEqualToString:self.config.APP_UUID]){
                    lastchange = self.config.APP_UUID;
                } else {
                    lastchange = title;
                }
            }
        } else {
            [filterseg insertSegmentWithTitle:[sorted_filter_keys objectAtIndex:i]  atIndex:i animated:NO];
        }
    }
    if ([[self.filters allKeys] count] < 2){
        filterseg.hidden = YES;
    }
    
    receivedData = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < 5; i++){
        NSMutableData *rec = [[NSMutableData alloc] init];
        [receivedData addObject:rec];
    }
    
    
    NSMutableDictionary *vs = [[NSMutableDictionary alloc] init];
    
    
    UIView *submit_view = [[UIView alloc] init];
    submit_view.userInteractionEnabled = NO;
    UILabel *submit_middle = [[UILabel alloc] init];
    submit_middle.userInteractionEnabled = NO;
    submit_middle.text = [self.config localisedString:@"APPLY"];
    [apply addSubview:submit_view];
    [submit_view addSubview:submit_middle];
    
    NSMutableDictionary *applys = [[NSMutableDictionary alloc] init];
    [applys setObject:apply forKey:@"main"];
    [applys setObject:submit_view forKey:@"checkout_view"];
    [applys setObject:submit_middle forKey:@"checkout_middle"];
    [Design checkout_btn:applys config:self.config];
    [Design style:[[DOM alloc] initWithView:submit_view parent:nil] design:design.apply_background config:self.config];
    
    
    NSDictionary *ds = [self.config.design objectForKey:@"design"];
    NSDictionary *dt = [ds objectForKey:@"navigation_title"];
    NSDictionary *dbar = [ds objectForKey:@"navigation_bar"];
    NSDictionary *dicon = [ds objectForKey:@"navigation_icon"];
    //[vs setObject:cancel forKey:@"cancel_btn"];
    // [vs setObject:clear forKey:@"clear_btn"];
    // [vs setObject:titleBar forKey:@"title_label"];
    
    titleBar.frame = CGRectMake(0, 20, self.config.screenWidth, 44);
    titleBar2.frame = CGRectMake(0, 0, self.config.screenWidth, 44);
    
    [Design style:[[DOM alloc] initWithView:titleLabel parent:nil] design:dt config:self.config];
    [Design style:[[DOM alloc] initWithView:titleBar parent:nil] design:dbar config:self.config];
    [Design style:[[DOM alloc] initWithView:titleBar2 parent:nil] design:dbar config:self.config];
    [Design style:[[DOM alloc] initWithView:cancel parent:nil] design:dicon config:self.config];
    [Design style:[[DOM alloc] initWithView:clear parent:nil] design:dicon config:self.config];
    //[Design product_filter:vs config:self.config];
    
    
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [UIView setAnimationsEnabled:YES];
    [table reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)rankchange:(id)sender{
    ProductViewController *par = (ProductViewController *)self.parent;
    //rankfeature.alpha = 1;
    //ranklow.alpha=1;
    // rankhigh.alpha=1;
    if (sender==rankfeature){
        
        [rankfeature setTitle:icon_record forState:UIControlStateNormal];
        [Design style:[[DOM alloc] initWithView:rankfeature parent:nil] design:design.active_sel_but config:self.config];
        [rankhigh setTitle:icon_ios7_circle_outline forState:UIControlStateNormal];
        [Design style:[[DOM alloc] initWithView:rankhigh parent:nil] design:design.select_but config:self.config];
        [ranklow setTitle:icon_ios7_circle_outline forState:UIControlStateNormal];
        [Design style:[[DOM alloc] initWithView:ranklow parent:nil] design:design.select_but config:self.config];
        rank = @"featured";
    } else if (sender == ranklow){
        
        [rankfeature setTitle:icon_ios7_circle_outline forState:UIControlStateNormal];
        [Design style:[[DOM alloc] initWithView:rankfeature parent:nil] design:design.select_but config:self.config];
        [rankhigh setTitle:icon_ios7_circle_outline forState:UIControlStateNormal];
        [Design style:[[DOM alloc] initWithView:rankhigh parent:nil] design:design.select_but config:self.config];
        [ranklow setTitle:icon_record forState:UIControlStateNormal];
        [Design style:[[DOM alloc] initWithView:ranklow parent:nil] design:design.active_sel_but config:self.config];
        rank = @"low";
    } else if (sender == rankhigh){
        [rankfeature setTitle:icon_ios7_circle_outline forState:UIControlStateNormal];
        [Design style:[[DOM alloc] initWithView:rankfeature parent:nil] design:design.select_but config:self.config];
        [rankhigh setTitle:icon_record forState:UIControlStateNormal];
        [Design style:[[DOM alloc] initWithView:rankhigh parent:nil] design:design.active_sel_but config:self.config];
        [ranklow setTitle:icon_ios7_circle_outline forState:UIControlStateNormal];
        [Design style:[[DOM alloc] initWithView:ranklow parent:nil] design:design.select_but config:self.config];
        rank = @"high";
    }
    par.rank = rank;
    // [par load_product:0];
    // [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)cancel:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)apply:(id)sender{
    ProductViewController *par = (ProductViewController *)self.parent;
    par.category = cat;
    par.attribute = selattr;
    par.rank = rank;
    [par load_product:0];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)clear:(id)sender{
    [cat removeAllObjects];
    [selattr removeAllObjects];
    //[filterseg select:0];
    [table reloadData];
}
-(IBAction)filter_change:(id)sender {
    int seg = (int)filterseg.selectedSegmentIndex;
    NSString *title = [filterseg titleForSegmentAtIndex:filterseg.selectedSegmentIndex];
    //[self update_filter:title];
    active_filter = [self.filters objectForKey:[sorted_filter_keys objectAtIndex:seg]];
    NSString *section =[[active_filter allKeys] objectAtIndex:0];
    
    if (updatefilters == nil) {
        updatefilters = [[NSMutableArray alloc] init];
    }
    if ([section isEqualToString:self.config.APP_UUID]){
        [self update_filter:self.config.APP_UUID lastchange:lastchange];
        lastchange = self.config.APP_UUID;
    } else {
        [self update_filter:title lastchange:lastchange];
        lastchange = title;
    }
    
    [table reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    
    return [[active_filter allKeys] count];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if ([[active_filter allKeys] count] <= 1) return @"";
    else {
        NSString *title =[[active_filter allKeys] objectAtIndex:section];
        
        return title;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    
    //return self.category.count;
    
    //NSSortDescriptor *lastDescriptor =
    //[[NSSortDescriptor alloc] initWithKey:@"value" ascending:NO selector:@selector(localizedCaseInsensitiveCompare:)];
    
    NSArray *attr = [active_filter objectForKey:[[active_filter allKeys] objectAtIndex:section]];
    
    //NSArray *descriptors = [NSArray arrayWithObjects:lastDescriptor, nil];
    //NSArray *sortedArray = [attr sortedArrayUsingDescriptors:descriptors];
    
    
    return attr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *segtitle = [filterseg titleForSegmentAtIndex:filterseg.selectedSegmentIndex];
    NSString *section =[[active_filter allKeys] objectAtIndex:[indexPath section]];
    NSArray *attr = [active_filter objectForKey:[[active_filter allKeys] objectAtIndex:[indexPath section]]];
    NSString *value = @"";
    if (![[attr objectAtIndex:indexPath.row] isKindOfClass:[NSString class]]){
        value = [NSString stringWithString:[[attr objectAtIndex:indexPath.row] stringValue]];
    } else {
        value = [NSString stringWithString:[attr objectAtIndex:indexPath.row]];
    }
    
    
    
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:value];
    cell.textLabel.text = value;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    BOOL checked = NO;
    
    if ([section isEqualToString:self.config.APP_UUID]) {
        for (int i = 0 ; i <cat.count;i++){
            if ([[cat objectAtIndex:i] isEqualToString:value]){
                //cell.accessoryType = UITableViewCellAccessoryCheckmark;
                checked = YES;
            }
        }
        if (updatefilters != nil){
            BOOL found = NO;
            for (NSString *s in updatefilters){
                if ([s isEqualToString:value]){
                    found = YES;
                }
            }
            if (!found) {
                //cell.userInteractionEnabled = NO;
                cell.textLabel.textColor = [UIColor lightGrayColor];
            }
        }
    } else if ([segtitle isEqualToString:@"Size"]) {
        for (int i = 0 ; i <selattr.count;i++){
            NSDictionary *d = [selattr objectAtIndex:i];
            NSString *v = [d objectForKey:@"value"];
            NSString *sizecat = [d objectForKey:@"category"];
            if ([v isEqualToString:value] /*&& [sizecat isEqualToString:section]*/){ //uncomment this if want to separate size by category
                
                checked = YES;
            }
            
        }
        if (updatefilters != nil){
            BOOL found = NO;
            for (NSDictionary *d in updatefilters){
                NSString *s = [d objectForKey:@"value"];
                NSString *c = [d objectForKey:@"category"];
                if ([s isEqualToString:value] /*&& [c isEqualToString:section]*/){ //uncomment this if want to separate size by category
                    found = YES;
                }
            }
            if (!found) {
                //cell.userInteractionEnabled = NO;
                cell.textLabel.textColor = [UIColor lightGrayColor];
            }
        }
        
    } else {
        for (int i = 0 ; i <selattr.count;i++){
            NSDictionary *d = [selattr objectAtIndex:i];
            NSString *v = [d objectForKey:@"value"];
            NSString *attrname = [d objectForKey:@"name"];
            if ([v isEqualToString:value] && [attrname isEqualToString:segtitle]){
                //cell.accessoryType = UITableViewCellAccessoryCheckmark;
                checked = YES;
            }
        }
        if (updatefilters != nil){
            BOOL found = NO;
            for (NSDictionary *d in updatefilters){
                NSString *s = [d objectForKey:@"value"];
                if ([s isEqualToString:value]){
                    found = YES;
                }
            }
            if (!found) {
                //cell.userInteractionEnabled = NO;
                cell.textLabel.textColor = [UIColor lightGrayColor];
            }
        }
    }
    
    if (updatefilters != nil){
        
    }
    
    if (checked){
        cell.tag = 1;
        UILabel *check = [[UILabel alloc] initWithFrame:CGRectMake(self.config.screenWidth-44, 0, 44, 44)];
        check.textAlignment = NSTextAlignmentCenter;
        check.tag = 99;
        check.font = [IonIcons fontWithSize:16];
        check.text = icon_checkmark;
        [Design style:[[DOM alloc] initWithView:check parent:cell] design:design.filter_checkmark config:self.config];
        
        [cell addSubview:check];
    }
    else {
        cell.tag = 0;
        UILabel *l = (UILabel *)[cell viewWithTag:99];
        if (l != nil){
            [l removeFromSuperview];
            l = nil;
        }
    }
    
    return cell;
    
    
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *segtitle = [filterseg titleForSegmentAtIndex:filterseg.selectedSegmentIndex];
    NSString *section =[[active_filter allKeys] objectAtIndex:[indexPath section]];
    NSArray *attr = [active_filter objectForKey:[[active_filter allKeys] objectAtIndex:[indexPath section]]];
    NSString *value = [NSString stringWithString:[attr objectAtIndex:indexPath.row]];
    
    UITableViewCell *cell = [table cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell.tag == 0){
        //cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.tag = 1;
        UILabel *check = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width-44, 0, 44, 44)];
        check.textAlignment = NSTextAlignmentCenter;
        check.tag = 99;
        check.font = [IonIcons fontWithSize:16];
        check.text = icon_checkmark;
        [Design style:[[DOM alloc] initWithView:check parent:cell] design:design.filter_checkmark config:self.config];
        [cell addSubview:check];
        if ([section isEqualToString:self.config.APP_UUID]) {
            [cat addObject:value];
        } /*else if ([segtitle isEqualToString:@"Size"]) {
           NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
           [d setValue:value forKey:@"value"];
           [d setValue:section forKey:@"category"];
           [d setValue:@"Size" forKey:@"name"];
           [selattr addObject:d];
           }*/ else {
               NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
               [d setValue:value forKey:@"value"];
               [d setValue:segtitle forKey:@"name"];
               [selattr addObject:d];
           }
        
    } else {
        //cell.accessoryType = UITableViewCellAccessoryNone;
        cell.tag = 0;
        UILabel *l = (UILabel *)[cell viewWithTag:99];
        if (l != nil){
            [l removeFromSuperview];
            l = nil;
        }
        if ([section isEqualToString:self.config.APP_UUID]) {
            for (int i = 0 ; i <cat.count;i++){
                if ([[cat objectAtIndex:i] isEqualToString:value]){
                    [cat removeObjectAtIndex:i];
                }
            }
            lastchange = section;
        } /*else if ([segtitle isEqualToString:@"Size"]) {
           for (int i = 0 ; i <selattr.count;i++){
           NSDictionary *d = [selattr objectAtIndex:i];
           NSString *value = [d objectForKey:@"value"];
           NSString *sizecat = [d objectForKey:@"category"];
           if ([value isEqualToString:value] && [sizecat isEqualToString:section]){
           [selattr removeObjectAtIndex:i];
           }
           }
           
           }*/ else {
               for (int i = 0 ; i <selattr.count;i++){
                   NSDictionary *d = [selattr objectAtIndex:i];
                   NSString *value = [d objectForKey:@"value"];
                   NSString *attrname = [d objectForKey:@"name"];
                   if ([value isEqualToString:value] && [attrname isEqualToString:segtitle]){
                       [selattr removeObjectAtIndex:i];
                   }
               }
           }
    }
    
    /*ProductViewController *par = (ProductViewController *)self.parent;
     if ([section isEqualToString:self.config.APP_UUID]) {
     if ([cat isEqualToString:[attr objectAtIndex:indexPath.row]]){
     cat = @"";
     } else {
     cat = [attr objectAtIndex:indexPath.row];
     }
     } else {
     
     if ([selattr objectForKey:segtitle] != nil){
     if ([value isEqualToString:[selattr objectForKey:segtitle]]){
     [selattr removeObjectForKey:segtitle];
     if ([segtitle isEqualToString:@"Size"]){
     cat=@"";
     }
     } else {
     [selattr setObject:value forKey:segtitle];
     if ([segtitle isEqualToString:@"Size"]){
     cat=section;
     }
     }
     } else {
     [selattr setObject:value forKey:segtitle];
     if ([segtitle isEqualToString:@"Size"]){
     cat=section;
     }
     }
     }*/
    
    
    //[table reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // If row is deleted, remove it from the list.
    
}


-(void)update_filter:(NSString *)attrname lastchange:(NSString *)last{
    [updatefilters removeAllObjects];
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating) toTarget:self withObject:nil];
    table.userInteractionEnabled = NO;
    filterseg.userInteractionEnabled = NO;
    ProductViewController *par = (ProductViewController *)self.parent;
    NSString *f = par.filter;
    if (par.filter == nil) f = @"";
    NSString *st = par.searchTerm;
    if (par.searchTerm == nil) st = @"";
    
    NSMutableString *catjson = [[NSMutableString alloc] initWithFormat:@"{\"categories\":["];
    for (int i = 0 ; i < cat.count;i++){
        if (i > 0) [catjson appendString:@","];
        
        NSString *catstr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                 NULL,
                                                                                                 (__bridge CFStringRef) [cat objectAtIndex:i],
                                                                                                 NULL,
                                                                                                 CFSTR("!*'();:@&=+$,/?%#[]\" "),
                                                                                                 kCFStringEncodingUTF8));
        [catjson appendFormat:@"\"%@\"", catstr];
        
    }
    [catjson appendString:@"]}"];
    //construct attribute string
    NSMutableString *attrjson = [[NSMutableString alloc] initWithFormat:@"{\"attributes\":["];
    for (int i = 0 ; i < selattr.count; i++){
        NSDictionary *d = [selattr objectAtIndex:i];
        NSString *name = [d objectForKey:@"name"];
        NSString *value = [d objectForKey:@"value"];
        NSString *cate = [d objectForKey:@"category"];
        
        NSString *namestr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                  NULL,
                                                                                                  (__bridge CFStringRef) name,
                                                                                                  NULL,
                                                                                                  CFSTR("!*'();:@&=+$,/?%#[]\" "),
                                                                                                  kCFStringEncodingUTF8));
        NSString *valuestr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                   NULL,
                                                                                                   (__bridge CFStringRef) value,
                                                                                                   NULL,
                                                                                                   CFSTR("!*'();:@&=+$,/?%#[]\" "),
                                                                                                   kCFStringEncodingUTF8));
        NSString *catestr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                  NULL,
                                                                                                  (__bridge CFStringRef) cate,
                                                                                                  NULL,
                                                                                                  CFSTR("!*'();:@&=+$,/?%#[]\" "),
                                                                                                  kCFStringEncodingUTF8));
        if (i > 0) [attrjson appendString:@","];
        [attrjson appendFormat:@"{\"name\":\"%@\",\"value\":\"%@\",\"category\":\"%@\"}",namestr, valuestr, catestr];
    }
    [attrjson appendString:@"]}"];
    
    NSString *myRequestString = [NSString stringWithFormat:@"app_uuid=%@&filter=%@&search_terms=%@&category=%@&attributes=%@&selected_attr=%@&department_id=%@", self.config.APP_UUID, f, st, catjson, attrjson, attrname, par.departmentid];
    
    NSLog(@"%@", myRequestString);
    
    // Create Data from request
    NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", self.config.API_ROOT, self.config.API_UPDATE_FILTER]]];
    
    // set Request Type
    [request setHTTPMethod: @"POST"];
    // Set content-type
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    // Set Request Body
    [request setHTTPBody: myRequestData];
    
    // Now send a request and get Response
    // NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
    // Log Response
    // NSString *response = [[NSString alloc] initWithBytes:[returnData bytes] length:[returnData length] encoding:NSUTF8StringEncoding];
    // NSLog(@"%@",response);
    NSMutableData *received = [receivedData objectAtIndex:UPDATE_FILTER];
    [received setLength:0];
    NSURLConnectionWithTag *urlConnection = [[NSURLConnectionWithTag alloc] initWithRequest:request delegate:self tag:UPDATE_FILTER];
}

/*-(void)update_filter:(NSString *)attrname lastchange:(NSString *)last{
 //[updatefilters removeAllObjects];
 [NSThread detachNewThreadSelector:@selector(threadStartAnimating) toTarget:self withObject:nil];
 table.userInteractionEnabled = NO;
 filterseg.userInteractionEnabled = NO;
 ProductViewController *par = (ProductViewController *)self.parent;
 NSString *f = par.filter;
 if (par.filter == nil) f = @"";
 NSString *st = par.searchTerm;
 if (par.searchTerm == nil) st = @"";
 //construct category json
 NSMutableString *json = [[NSMutableString alloc] init];
 if ([last isEqualToString:self.config.APP_UUID]){
 [json appendString:@"{\"categories\":["];
 for (int i = 0 ; i < cat.count;i++){
 if (i > 0) [json appendString:@","];
 [json appendFormat:@"\"%@\"",[cat objectAtIndex:i]];
 
 }
 [json appendString:@"]}"];
 } else {
 [json appendString:@"{\"attributes\":["];
 int count = 0;
 for (int i = 0 ; i < selattr.count;i++){
 NSDictionary *d = [selattr objectAtIndex:i];
 if ([[d objectForKey:@"name"] isEqualToString:last]){
 if (count > 0) [json appendString:@","];
 NSString *name = [d objectForKey:@"name"];
 NSString *value = [d objectForKey:@"value"];
 NSString *cate = [d objectForKey:@"category"];
 [json appendFormat:@"{\"name\":\"%@\",\"value\":\"%@\",\"category\":\"%@\"}",name, value, cate];
 count++;
 }
 
 }
 [json appendString:@"]}"];
 }
 
 
 NSString *myRequestString = [NSString stringWithFormat:@"app_uuid=%@&filter=%@&search_terms=%@&department_id=%@&editted_attr=%@&selected_attr=%@&attributes=%@", self.config.APP_UUID, f, st, par.departmentid,last, attrname, json];
 
 NSLog(@"%@", myRequestString);
 
 // Create Data from request
 NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
 NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", self.config.API_ROOT, self.config.API_UPDATE_FILTER]]];
 
 // set Request Type
 [request setHTTPMethod: @"POST"];
 // Set content-type
 [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
 // Set Request Body
 [request setHTTPBody: myRequestData];
 
 // Now send a request and get Response
 // NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
 // Log Response
 // NSString *response = [[NSString alloc] initWithBytes:[returnData bytes] length:[returnData length] encoding:NSUTF8StringEncoding];
 // NSLog(@"%@",response);
 NSMutableData *received = [receivedData objectAtIndex:UPDATE_FILTER];
 [received setLength:0];
 NSURLConnectionWithTag *urlConnection = [[NSURLConnectionWithTag alloc] initWithRequest:request delegate:self tag:UPDATE_FILTER];
 }*/

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    @try {
        NSURLConnectionWithTag *conn = (NSURLConnectionWithTag *)connection;
        NSMutableData *received = [receivedData objectAtIndex:conn.tag];
        [received appendData:data];
        
    }
    @catch (NSException *exception) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Something went wrong..." message:@"Please try again" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        
        [alert show];
        
        [indicator stopAnimating];
        table.userInteractionEnabled = YES;
        filterseg.userInteractionEnabled = YES;
        
    }
    
    
    
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [indicator stopAnimating];
    table.userInteractionEnabled = YES;
    filterseg.userInteractionEnabled = YES;
    [indicator stopAnimating];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSURLConnectionWithTag *conn = (NSURLConnectionWithTag *)connection;
    NSMutableData *received = [receivedData objectAtIndex:conn.tag];
    
    @try {
        if (conn.tag == UPDATE_FILTER){
            [updatefilters removeAllObjects];
            NSString *myxml = [[NSString alloc] initWithData:received encoding:NSASCIIStringEncoding];
            NSLog(@"%@", myxml);
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:received options:0 error:nil];
            NSString *sel = [dic objectForKey:@"selected_attr"];
            NSArray *attrs = [dic objectForKey:@"updated_filter"];
            NSString *segtitle = [filterseg titleForSegmentAtIndex:filterseg.selectedSegmentIndex];
            if ([sel isEqualToString:self.config.APP_UUID]) {
                //[updatefilters addObjectsFromArray:attrs];
                // [table reloadData];
            } else {
                
            }
            [updatefilters addObjectsFromArray:attrs];
            [table reloadData];
            
            
            
        }
        
        
    }
    @catch (NSException *exception) {
        //NSLog(exception.description);
        [indicator stopAnimating];
    }
    @finally {
        
        //loading = 0;
        table.userInteractionEnabled = YES;
        filterseg.userInteractionEnabled = YES;
        [indicator stopAnimating];
        //searchBarState = 0;
    }
    
}


-(void)threadStartAnimating{
    [indicator startAnimating];
}

@end



@implementation ProductFilterDesign



@end
