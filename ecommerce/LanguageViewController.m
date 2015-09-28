//
//  LanguageViewController.m
//  Moooh
//
//  Created by Hanqing Hu on 4/10/15.
//  Copyright (c) 2015 Twixxies. All rights reserved.
//

#import "LanguageViewController.h"
#import "PromotionViewController.h"
#import "PKRevealController.h"
#import "Design.h"
#import "ionicons-codes.h"
#import "IonIcons.h"
#import "MainViewController.h"
@interface LanguageViewController ()

@end

@implementation LanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 44)] ;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:17.3];
    
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor colorWithRed:0.302 green:0.302 blue:0.318 alpha:1]; // change this color
    self.navigationItem.titleView = label;
    label.text = [self.config localisedString:@"Regions"];
    //[label sizeToFit];
    [Design navigationbar_title:label config:self.config];
    // Do any additional setup after loading the view from its nib.
    
    
    
    
    
    
    
    menubtn = [IonIcons labelWithIcon:icon_ios7_arrow_back size:28 color:[UIColor blackColor]];
    menubtn.frame = CGRectMake(0, 0, 60, 44);
    UITapGestureRecognizer *menutap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    [menubtn addGestureRecognizer:menutap];
    menubtn.userInteractionEnabled = YES;
    [Design navigationbar_ion_icon:menubtn config:self.config];
    [Design style:[[DOM alloc] initWithView:menubtn parent:nil] design:[[self.config.design objectForKey:@"design"] objectForKey:@"left_navigation_ion_icon"] config:self.config];
    
    UIBarButtonItem *barbtn = [[UIBarButtonItem alloc] initWithCustomView:menubtn];
    
    if (!self.first){
        self.navigationItem.leftBarButtonItem = barbtn;
    } else {
        UILabel *cartbtn = [[UILabel alloc] init];
        cartbtn.text = [self.config localisedString:@"Done"];
        cartbtn.textAlignment = NSTextAlignmentRight;
        cartbtn.frame = CGRectMake(0, 0, 60, 44);
        [Design navigationbar_ion_icon:cartbtn config:self.config];
        [Design style:[[DOM alloc] initWithView:cartbtn parent:nil] design:[[self.config.design objectForKey:@"design"] objectForKey:@"navigation_icon"] config:self.config];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(next:)];
        [cartbtn addGestureRecognizer:tap];
        cartbtn.userInteractionEnabled = YES;
        
        
        UIBarButtonItem *menuBtn2 = [[UIBarButtonItem alloc] initWithCustomView:cartbtn];
        
        
        self.navigationItem.rightBarButtonItem = menuBtn2;
    }
    
    
    
    
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.config.screenWidth, self.config.screenHeight-64) style:UITableViewStyleGrouped];
    table.separatorColor = [UIColor colorWithRed:173/255.0 green:173/255.0 blue:173/255.0 alpha:1];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    
    
    hiddenText = [[UITextField alloc] init];
    hiddenText.userInteractionEnabled = YES;
    [self.view addSubview:hiddenText];
    UIView *access = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.config.screenWidth, 40)];
    access.backgroundColor = [UIColor whiteColor];
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, self.config.screenWidth, 0.5);
    layer.backgroundColor = [[UIColor colorWithRed:196.0/255.0 green:196.0/255.0 blue:196.0/255.0 alpha:1] CGColor];
    [access.layer addSublayer:layer];
    
    UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 100, 30)];
    cancel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [cancel setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [cancel setTitle:[self.config localisedString:@"Cancel"] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [access addSubview:cancel];
    picker = [[UIPickerView alloc] init];
    picker.delegate = self;
    picker.dataSource = self;
    hiddenText.inputView = picker;
    
    UIButton *select = [[UIButton alloc] initWithFrame:CGRectMake(self.config.screenWidth-110, 5, 100, 30)];
    select.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [select setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [select setTitle:[self.config localisedString:@"Select"] forState:UIControlStateNormal];
    [select addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
    [access addSubview:select];
    hiddenText.inputAccessoryView = access;
    
    
    NSArray *c = [self.config.available_locations allKeys];
    NSMutableArray *unsorted = [[NSMutableArray alloc] init];
    applocations = [[NSMutableDictionary alloc] init];
    for (NSString *str in c){
        NSString *cname = [self.config.codetocountry objectForKey:str];
        NSDictionary *languages = [self.config.available_locations objectForKey:str];
        AppLocation *al = [[AppLocation alloc] init];
        al.location = cname;
        al.languages = languages;
        al.country_code = str;
        
        if (cname != nil){
            [applocations setObject:al forKey:cname];
            [unsorted addObject:cname];
        }
    }
    
    countries = [unsorted sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    /*sectionTitles = [[NSMutableArray alloc] init];
     
     NSArray *countries = [self.config.available_locations allKeys];
     NSArray *sorted = [countries sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
     
     
     
     sectionContents = [[NSMutableDictionary alloc] init];
     for (NSString *s in sorted){
     NSString *cname = [self.config.codetocountry objectForKey:s];
     NSDictionary *languages = [self.config.available_locations objectForKey:s];
     AppLocation *al = [[AppLocation alloc] init];
     al.location = cname;
     al.languages = languages;
     unichar b = [cname characterAtIndex:0];
     NSString *bstr = [cname substringToIndex:1];
     
     NSMutableArray *arr = [sectionContents objectForKey:bstr];
     
     if (arr == nil){
     arr = [[NSMutableArray alloc] init];
     [sectionContents setObject:arr forKey:bstr];
     }
     
     [arr addObject:al];
     
     
     
     
     }
     
     sectionTitles = [[sectionContents allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];*/
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)back{
    /*if (self.navigationController.revealController.focusedController == self.navigationController.revealController.leftViewController)
     {
     [self.navigationController.revealController showViewController:self.navigationController.revealController.frontViewController];
     }
     else
     {
     
     [self.navigationController.revealController showViewController:self.navigationController.revealController.leftViewController];
     }*/
    [self.navigationController popViewControllerAnimated:YES];
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
    
    buttons = [[NSMutableArray alloc] init];
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    if (section == 0) return 1;
    else return countries.count;
    
    
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    //return [sectionTitle objectAtIndex:section];
    if (section == 0) return  [self.config localisedString:@"Current Region"];
    else return [self.config localisedString:@"Select Region"];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0){
        /*for (NSString *c in countries){
         if ([c isEqualToString:self.config.location]){
         AppLocation *al = [applocations objectForKey:c];
         NSArray *a = [al.languages allKeys];
         for (NSString *lan in a){
         if ([lan isEqualToString:self.config.language]){
         cell.textLabel.text = c;
         }
         }
         }
         }*/
        NSLog(@"%@", self.config.location);
        cell.textLabel.text = [self.config.codetocountry objectForKey:self.config.location];
        UITextField *lan = [[UITextField alloc] initWithFrame:CGRectMake(self.config.screenWidth-100, 0, 90, 44)];
        lan.textAlignment = NSTextAlignmentRight;
        lan.textColor = [UIColor lightGrayColor];
        lan.font = [UIFont systemFontOfSize:14];
        NSLog(@"%@", self.config.location);
        lan.text = [self.config.codetolanguage objectForKey:self.config.language];
        [cell addSubview:lan];
        
    }
    
    if (indexPath.section == 1){
        
        cell.textLabel.text = [countries objectAtIndex:indexPath.row];
        cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, self.config.screenWidth+66, cell.frame.size.height);
        cell.tag = indexPath.row;
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(self.config.screenWidth, 0, 66, cell.frame.size.height)];
        btn.backgroundColor = menubtn.textColor;
        [btn setTitle:[self.config localisedString:@"Select"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(lan_sel:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = indexPath.row;
        [buttons addObject:btn];
        [cell addSubview:btn];
    }
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section != 1) return;
    
    [hiddenText resignFirstResponder];
    
    for (UIButton *btn in buttons){
        
        if (btn.tag == indexPath.row ){
            if (btn.frame.origin.x < self.config.screenWidth) continue;
            [UIView animateWithDuration:0.2f
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 btn.frame = CGRectMake(btn.frame.origin.x-66, btn.frame.origin.y, btn.frame.size.width, btn.frame.size.height);
                             }
                             completion:^(BOOL finished){
                             }];
        } else  {
            [UIView animateWithDuration:0.2f
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 btn.frame = CGRectMake(self.config.screenWidth, btn.frame.origin.y, btn.frame.size.width, btn.frame.size.height);
                             }
                             completion:^(BOOL finished){
                             }];
        }
    }
    
    
    
    
    
    
}


-(IBAction)lan_sel:(id)sender{
    
    UIButton *btn = (UIButton *)sender;
    
    
    [hiddenText resignFirstResponder];
    NSString *country = [countries objectAtIndex:btn.tag];
    
    AppLocation *al = [applocations objectForKey:country];
    NSArray *a = [al.languages allKeys];
    
    if (a.count > 1){
        sel_loc = al;
        [picker reloadAllComponents];
        [hiddenText becomeFirstResponder];
    } else if (a.count == 1){
        sel_loc = al;
        NSArray *arr = [sel_loc.languages allKeys];
        NSString *sel = [arr objectAtIndex:0];
        NSString *lan = [self.config.codetolanguage objectForKey:sel];
        
        if (lan == nil || lan.length == 0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Invalid Language"] message:nil delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        [self.config change_language:sel];
        
        self.config.language = sel;
        self.config.location = sel_loc.country_code;
        
        
        NSArray *curarr = [[[self.config.available_locations objectForKey:self.config.location] objectForKey:self.config.language] allKeys];
        
        if (curarr.count > 0) self.config.currency = [curarr objectAtIndex:0];
        
        [self.config save_default];
        
        MainViewController *main = (MainViewController *)self.navigationController.revealController.presentingViewController;
        main.reload = YES;
        [self.navigationController.revealController dismissViewControllerAnimated:NO completion:^{
            
        }];
        [hiddenText resignFirstResponder];
    }
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}



- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray *arr = [sel_loc.languages allKeys];
    NSString *lan = [arr objectAtIndex:row] ;
    NSString *str = [self.config.codetolanguage objectForKey:lan];
    return str;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *arr = [sel_loc.languages allKeys];
    return arr.count;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(IBAction)cancel:(id)sender{
    [hiddenText resignFirstResponder];
}

-(IBAction)select:(id)sender{
    NSArray *arr = [sel_loc.languages allKeys];
    NSString *sel = [arr objectAtIndex:[picker selectedRowInComponent:0]];
    NSString *lan = [self.config.codetolanguage objectForKey:sel];
    
    if (lan == nil || lan.length == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Invalid Language"] message:nil delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    [self.config change_language:sel];
    
    self.config.language = sel;
    self.config.location = sel_loc.country_code;
    
    
    NSArray *curarr = [[[self.config.available_locations objectForKey:self.config.country] objectForKey:self.config.language] allKeys];
    
    if (curarr.count > 0) self.config.currency = [curarr objectAtIndex:0];
    
    [self.config save_default];
    
    NSLog(@"%@", self.navigationController.revealController.presentingViewController.description);
    MainViewController *main = (MainViewController *)self.navigationController.revealController.presentingViewController;
    main.reload = YES;
    [self.navigationController.revealController dismissViewControllerAnimated:NO completion:^{
        
    }];
    [hiddenText resignFirstResponder];
    self.first = NO;
}

-(void)next:(UITapGestureRecognizer *)ges{
    PromotionViewController *index =  [[PromotionViewController alloc] initWithNibName:@"PromotionViewController" bundle:nil];
    
    index.config = self.config;
    
    UINavigationController *frontViewController = [[UINavigationController alloc] initWithRootViewController:index];
    
    [Design navigationbar:frontViewController.navigationBar config:self.config];
    
    //[frontViewController setNavigationBarHidden:YES];
    [self.navigationController.revealController setFrontViewController:frontViewController];
    [self.navigationController.revealController showViewController:self.revealController.frontViewController];
    self.first = NO;
}

@end


@implementation AppLocation



@end
