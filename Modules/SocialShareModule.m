//
//  SocialShareModule.m
//  Moooh
//
//  Created by Hanqing Hu on 4/13/15.
//  Copyright (c) 2015 Twixxies. All rights reserved.
//

#import "SocialShareModule.h"
#import "ViewWithData.h"
#import "NSString+FontAwesome.h"
#import "ionicons-codes.h"
#import "IonIcons.h"
#import "Design.h"
#import "DOM.h"
#import <Social/Social.h>

@implementation SocialShareModule

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)build_share_buttons{
    buttons = [[NSMutableArray alloc] init];
    
    label = [[UILabel alloc] init];
    label.text = [self.config localisedString:@"Share"];
    label.font = [UIFont boldSystemFontOfSize:18];
    label.textColor = [UIColor colorWithRed:41.0/255.0 green:39.0/255.0 blue:39.0/255.0 alpha:1];
    NSDictionary *design = [self.designs objectForKey:@"title"];
    [Design style:[[DOM alloc] initWithView:label parent:self] design:design config:self.config];
    [self addSubview:label];
    
    
    ButtonWithData *face = [[ButtonWithData alloc] init];
    face.item_id = @"facebook";
    face.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:23];
    [face setTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"fa-facebook"] forState:UIControlStateNormal];
    [face setTitleColor:label.textColor forState:UIControlStateNormal];
    
    UILabel *facecircle = [[UILabel alloc] init];
    facecircle.tag = 1;
    [face addSubview:facecircle];
    [self addSubview:face];
    [buttons addObject:face];
    
    ButtonWithData *twit = [[ButtonWithData alloc] init];
    twit.item_id = @"twitter";
    twit.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:23];
    [twit setTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"fa-twitter"] forState:UIControlStateNormal];
    [twit setTitleColor:label.textColor forState:UIControlStateNormal];
    
    UILabel *twitcircle = [[UILabel alloc] init];
    twitcircle.tag = 1;
    [twit addSubview:twitcircle];
    [self addSubview:twit];
    [buttons addObject:twit];
    
    ButtonWithData *mess = [[ButtonWithData alloc] init];
    mess.item_id = @"message";
    mess.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:23];
    [mess setTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"fa-comment"] forState:UIControlStateNormal];
    [mess setTitleColor:label.textColor forState:UIControlStateNormal];
    
    UILabel *messcircle = [[UILabel alloc] init];
    messcircle.tag = 1;
    [mess addSubview:messcircle];
    [self addSubview:mess];
    [buttons addObject:mess];
    
    ButtonWithData *mail = [[ButtonWithData alloc] init];
    mail.item_id = @"email";
    mail.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:23];
    [mail setTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"fa-envelope"] forState:UIControlStateNormal];
    [mail setTitleColor:label.textColor forState:UIControlStateNormal];
    
    UILabel *mailcircle = [[UILabel alloc] init];
    mailcircle.tag = 1;
    [mail addSubview:mailcircle];
    [self addSubview:mail];
    [buttons addObject:mail];
    
    

}


-(void)layout_view{
    label.frame = CGRectMake(0, 5, 100, 20);
    float width = 44;
    float fontsize = 23;
    
    if (self.button_width > 0) width = self.button_width;
    if (self.button_fontsize > 0) fontsize = self.button_fontsize;
    
    NSString *align = self.button_align;
    if (self.button_align == nil) align = @"left";
    long count = buttons.count;
    float space = 10;
    if ([align isEqualToString:@"center"]) space = (self.frame.size.width - count*width)/(count-1);
    
    
    NSDictionary *btnd = [self.designs objectForKey:@"button"];
    //NSDictionary *cird = [self.designs objectForKey:@"button_circle"];
    
    for (int i = 0 ; i < buttons.count;i++){
        ButtonWithData *b = (ButtonWithData *)[buttons objectAtIndex:i];
        if (self.button_fontsize > 0) b.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:fontsize];
         b.frame = CGRectMake(i*(width+space), label.frame.origin.y+label.frame.size.height+(self.frame.size.height-label.frame.origin.y-label.frame.size.height)/2-width/2, width, width);
        
        [Design style:[[DOM alloc] initWithView:b parent:self] design:btnd config:self.config];
        b.layer.cornerRadius = width/2;
        b.layer.borderWidth = 1;
        b.layer.borderColor = [b.titleLabel.textColor CGColor];
        /*UILabel *circle = (UILabel *)[b viewWithTag:1];
        circle.frame = CGRectMake(7, 7, 30, 30);
        circle.layer.cornerRadius = 30/2;
        circle.layer.borderColor = [b.titleLabel.textColor CGColor];
        circle.layer.borderWidth = 1;
        [Design style:[[DOM alloc] initWithView:circle parent:self] design:cird config:self.config];*/
    }
}

-(void)share_action_target:(id)target action:(SEL)selector{
    for (ButtonWithData *b in buttons){
        [b addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    }
}
+(NSString *)check_share_type:(id)sender{
    ButtonWithData *btn = (ButtonWithData *)sender;
    if (btn.item_id == nil) return @"";
    return btn.item_id;
    
}
+(BOOL)check_share_available_with_sender:(id)sender withConfig:(Config *)config{
    ButtonWithData *btn = (ButtonWithData *)sender;
    if (btn.item_id == nil) return NO;
    if ([btn.item_id isEqualToString:@"facebook"]){
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
        {
            return YES;
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:[config localisedString:@"Sorry"]
                                      message:[config localisedString:@"You can't post to facebook right now, make sure your device has an internet connection and you have at least one Facebook account setup in your phone Settings."]
                                      delegate:self
                                      cancelButtonTitle:[config localisedString:@"Close"]
                                      otherButtonTitles:nil];
            [alertView show];
            return NO;
            
        }
    } else if ([btn.item_id isEqualToString:@"twitter"]){
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            return YES;
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:[config localisedString:@"Sorry"]
                                      message:[config localisedString:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup in your phone Settings."]
                                      delegate:self
                                      cancelButtonTitle:[config localisedString:@"Close"]
                                      otherButtonTitles:nil];
            [alertView show];
            return NO;
        }
    } else if ([btn.item_id isEqualToString:@"email"] || [btn.item_id isEqualToString:@"message"]){
        return YES;
    } else return NO;
}
-(void)present_sharing_dialog_with_message:(NSString *)message image:(UIImage *)img imageurl:(NSString *)imageurl url:(NSString *)url action_sender:(id)sender action_parent:(UIViewController *)parent{
    ButtonWithData *btn = (ButtonWithData *)sender;
    if (btn.item_id == nil) return;
    if ([btn.item_id isEqualToString:@"facebook"]){
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
        {
            SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            /*[tweetSheet setInitialText:message];*/
            if (img != nil){
                [tweetSheet addImage:img];
            }
            [tweetSheet addURL:[NSURL URLWithString:url]];
            [parent presentViewController:tweetSheet animated:YES completion:nil];
        }
        /*NSLog(@"%@", url);
        NSURL *rl = [NSURL URLWithString:url];
        FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
        content.contentTitle = self.config.app_name;
        content.contentURL = rl;
        content.contentDescription = message;
        if (imageurl != nil) content.imageURL = [NSURL URLWithString:imageurl];
        
        FBSDKShareDialog *dialog = [FBSDKShareDialog new];
        dialog.delegate = self;
        //[dialog setMode:FBSDKShareDialogModeBrowser];
        [dialog setShareContent:content];
        [dialog setFromViewController:self.parent];
        [dialog show];*/
        
        
    }
    else  if ([btn.item_id isEqualToString:@"twitter"]){
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            [tweetSheet setInitialText:message];
            if (img != nil) {
                [tweetSheet addImage:img];
            }
            [tweetSheet addURL:[NSURL URLWithString:url]];
            [parent presentViewController:tweetSheet animated:YES completion:nil];
        }
        
    }
    else  if ([btn.item_id isEqualToString:@"email"]){
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        
        mailCont.mailComposeDelegate = self;
        
        [mailCont setSubject:@""];
        [mailCont setToRecipients:nil];
        [mailCont setMessageBody:[NSString stringWithFormat:@"%@ %@", message, url] isHTML:NO];
        if (img != nil) {
            NSData *imageData = UIImagePNGRepresentation(img);
            [mailCont addAttachmentData:imageData mimeType:@"image/png" fileName:@"product"];
        }
        
        [parent presentViewController:mailCont animated:YES completion:nil];
    }
    else  if ([btn.item_id isEqualToString:@"message"]){
        MFMessageComposeViewController *mailCont = [[MFMessageComposeViewController alloc] init];
        
        mailCont.messageComposeDelegate = self;
        
        mailCont.body = [NSString stringWithFormat:@"%@ %@", message, url];
        if (img != nil) {
            NSData *imageData = UIImagePNGRepresentation(img);
            [mailCont addAttachmentData:imageData typeIdentifier:@"public.data" filename:@"product.png"];
        }
        
        [parent presentViewController:mailCont animated:YES completion:nil];
    }
}



- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [controller dismissViewControllerAnimated:YES completion:nil ];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [controller dismissViewControllerAnimated:YES completion:nil ];
}

@end


