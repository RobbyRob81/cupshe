//----------------------------------------------------
//
// Generated by www.easywsdl.com
// Version: 4.1.9.0
//
// Created by Quasar Development at 02-11-2015
//
//---------------------------------------------------


#import "USAePayHelper.h"
#import "USAePayRecurringBilling.h"


@implementation USAePayRecurringBilling
@synthesize Amount;
@synthesize Enabled;
@synthesize Expire;
@synthesize Next;
@synthesize NumLeft;
@synthesize Schedule;
@synthesize any;

+ (USAePayRecurringBilling *)createWithXml:(DDXMLElement *)__node __request:(USAePayRequestResultHandler*) __request
{
    if(__node == nil) { return nil; }
    return [[self alloc] initWithXml: __node __request:__request];
}

-(id)init {
    if ((self=[super init])) {
        self.Amount =[NSNumber numberWithInt:0];
        self.NumLeft =[NSNumber numberWithInt:0];
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
                 if([__node.localName isEqualToString:@"Amount"])
                 {
                     if([USAePayHelper isValue:__node name:@"Amount"])
                     {
                         self.Amount = [USAePayHelper getNumber:[__node stringValue]];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"Enabled"])
                 {
                     if([USAePayHelper isValue:__node name:@"Enabled"])
                     {
                         self.Enabled = [[__node stringValue] boolValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"Expire"])
                 {
                     if([USAePayHelper isValue:__node name:@"Expire"])
                     {
                         self.Expire = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"Next"])
                 {
                     if([USAePayHelper isValue:__node name:@"Next"])
                     {
                         self.Next = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"NumLeft"])
                 {
                     if([USAePayHelper isValue:__node name:@"NumLeft"])
                     {
                         self.NumLeft = [USAePayHelper getNumber:[__node stringValue]];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"Schedule"])
                 {
                     if([USAePayHelper isValue:__node name:@"Schedule"])
                     {
                         self.Schedule = [__node stringValue];
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

            
    DDXMLElement* __AmountItemElement=[__request writeElement:Amount type:[NSNumber class] name:@"Amount" URI:@"" parent:__parent skipNullProperty:NO];
    if(__AmountItemElement!=nil)
    {
        [__AmountItemElement setStringValue:[self.Amount stringValue]];
    }
            
    DDXMLElement* __EnabledItemElement=[__request writeElement:@"Enabled" URI:@"" parent:__parent];
    [__EnabledItemElement setStringValue:[USAePayHelper toBoolStringFromBool:self.Enabled]];
            
    DDXMLElement* __ExpireItemElement=[__request writeElement:Expire type:[NSString class] name:@"Expire" URI:@"" parent:__parent skipNullProperty:YES];
    if(__ExpireItemElement!=nil)
    {
        [__ExpireItemElement setStringValue:self.Expire];
    }
            
    DDXMLElement* __NextItemElement=[__request writeElement:Next type:[NSString class] name:@"Next" URI:@"" parent:__parent skipNullProperty:NO];
    if(__NextItemElement!=nil)
    {
        [__NextItemElement setStringValue:self.Next];
    }
            
    DDXMLElement* __NumLeftItemElement=[__request writeElement:NumLeft type:[NSNumber class] name:@"NumLeft" URI:@"" parent:__parent skipNullProperty:NO];
    if(__NumLeftItemElement!=nil)
    {
        [__NumLeftItemElement setStringValue:[self.NumLeft stringValue]];
    }
            
    DDXMLElement* __ScheduleItemElement=[__request writeElement:Schedule type:[NSString class] name:@"Schedule" URI:@"" parent:__parent skipNullProperty:NO];
    if(__ScheduleItemElement!=nil)
    {
        [__ScheduleItemElement setStringValue:self.Schedule];
    }
            
    for(DDXMLElement* elem in self.any)
    {
        [elem detach];
        [__parent addChild:elem];
    }


}
@end