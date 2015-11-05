//----------------------------------------------------
//
// Generated by www.easywsdl.com
// Version: 4.1.9.0
//
// Created by Quasar Development at 02-11-2015
//
//---------------------------------------------------


#import "USAePayHelper.h"
#import "USAePayReceipt.h"


@implementation USAePayReceipt
@synthesize ReceiptRefNum;
@synthesize Name;
@synthesize Subject;
@synthesize FromEmail;
@synthesize Target;
@synthesize ContentType;
@synthesize TemplateHTML;
@synthesize TemplateText;
@synthesize any;

+ (USAePayReceipt *)createWithXml:(DDXMLElement *)__node __request:(USAePayRequestResultHandler*) __request
{
    if(__node == nil) { return nil; }
    return [[self alloc] initWithXml: __node __request:__request];
}

-(id)init {
    if ((self=[super init])) {
        self.any =[NSMutableArray array];
    }
    return self;
}

- (id) initWithXml: (DDXMLElement*) __node __request:(USAePayRequestResultHandler*) __request{
    if(self = [self init])
    {
        DDXMLNode* node=__node;
        for(int i=0;i< node.childCount;i++)
        {
            DDXMLNode* node=[__node childAtIndex:i];
            if(node.kind==DDXMLElementKind)
            {
                DDXMLElement* __node=(DDXMLElement*)node;
                 if([__node.localName isEqualToString:@"ReceiptRefNum"])
                 {
                     if([USAePayHelper isValue:__node name:@"ReceiptRefNum"])
                     {
                         self.ReceiptRefNum = [USAePayHelper getNumber:[__node stringValue]];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"Name"])
                 {
                     if([USAePayHelper isValue:__node name:@"Name"])
                     {
                         self.Name = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"Subject"])
                 {
                     if([USAePayHelper isValue:__node name:@"Subject"])
                     {
                         self.Subject = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"FromEmail"])
                 {
                     if([USAePayHelper isValue:__node name:@"FromEmail"])
                     {
                         self.FromEmail = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"Target"])
                 {
                     if([USAePayHelper isValue:__node name:@"Target"])
                     {
                         self.Target = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"ContentType"])
                 {
                     if([USAePayHelper isValue:__node name:@"ContentType"])
                     {
                         self.ContentType = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"TemplateHTML"])
                 {
                     if([USAePayHelper isValue:__node name:@"TemplateHTML"])
                     {
                         self.TemplateHTML = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"TemplateText"])
                 {
                     if([USAePayHelper isValue:__node name:@"TemplateText"])
                     {
                         self.TemplateText = [__node stringValue];
                     }
                     continue;
                 }
               [self.any addObject:__node];
            }
         }
    }
    return self;
}

-(void) serialize:(DDXMLElement*)__parent __request:(USAePayRequestResultHandler*) __request
{

            
    DDXMLElement* __ReceiptRefNumItemElement=[__request writeElement:ReceiptRefNum type:[NSNumber class] name:@"ReceiptRefNum" URI:@"" parent:__parent skipNullProperty:YES];
    if(__ReceiptRefNumItemElement!=nil)
    {
        [__ReceiptRefNumItemElement setStringValue:[self.ReceiptRefNum stringValue]];
    }
            
    DDXMLElement* __NameItemElement=[__request writeElement:Name type:[NSString class] name:@"Name" URI:@"" parent:__parent skipNullProperty:NO];
    if(__NameItemElement!=nil)
    {
        [__NameItemElement setStringValue:self.Name];
    }
            
    DDXMLElement* __SubjectItemElement=[__request writeElement:Subject type:[NSString class] name:@"Subject" URI:@"" parent:__parent skipNullProperty:YES];
    if(__SubjectItemElement!=nil)
    {
        [__SubjectItemElement setStringValue:self.Subject];
    }
            
    DDXMLElement* __FromEmailItemElement=[__request writeElement:FromEmail type:[NSString class] name:@"FromEmail" URI:@"" parent:__parent skipNullProperty:YES];
    if(__FromEmailItemElement!=nil)
    {
        [__FromEmailItemElement setStringValue:self.FromEmail];
    }
            
    DDXMLElement* __TargetItemElement=[__request writeElement:Target type:[NSString class] name:@"Target" URI:@"" parent:__parent skipNullProperty:NO];
    if(__TargetItemElement!=nil)
    {
        [__TargetItemElement setStringValue:self.Target];
    }
            
    DDXMLElement* __ContentTypeItemElement=[__request writeElement:ContentType type:[NSString class] name:@"ContentType" URI:@"" parent:__parent skipNullProperty:NO];
    if(__ContentTypeItemElement!=nil)
    {
        [__ContentTypeItemElement setStringValue:self.ContentType];
    }
            
    DDXMLElement* __TemplateHTMLItemElement=[__request writeElement:TemplateHTML type:[NSString class] name:@"TemplateHTML" URI:@"" parent:__parent skipNullProperty:YES];
    if(__TemplateHTMLItemElement!=nil)
    {
        [__TemplateHTMLItemElement setStringValue:self.TemplateHTML];
    }
            
    DDXMLElement* __TemplateTextItemElement=[__request writeElement:TemplateText type:[NSString class] name:@"TemplateText" URI:@"" parent:__parent skipNullProperty:YES];
    if(__TemplateTextItemElement!=nil)
    {
        [__TemplateTextItemElement setStringValue:self.TemplateText];
    }
            
    for(DDXMLElement* elem in self.any)
    {
        [elem detach];
        [__parent addChild:elem];
    }


}
@end