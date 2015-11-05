//----------------------------------------------------
//
// Generated by www.easywsdl.com
// Version: 4.1.9.0
//
// Created by Quasar Development at 02-11-2015
//
//---------------------------------------------------


#import "USAePayCurrencyObjectArray.h"
#import "USAePayHelper.h"
#import "USAePayAccountDetails.h"


@implementation USAePayAccountDetails
@synthesize CardholderAuthentication;
@synthesize CheckPlatform;
@synthesize CreditCardPlatform;
@synthesize DebitCardSupport;
@synthesize DirectPayPlatform;
@synthesize Industry;
@synthesize SupportedCurrencies;
@synthesize any;

+ (USAePayAccountDetails *)createWithXml:(DDXMLElement *)__node __request:(USAePayRequestResultHandler*) __request
{
    if(__node == nil) { return nil; }
    return [[self alloc] initWithXml: __node __request:__request];
}

-(id)init {
    if ((self=[super init])) {
        self.SupportedCurrencies =[[USAePayCurrencyObjectArray alloc]init];
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
                 if([__node.localName isEqualToString:@"CardholderAuthentication"])
                 {
                     if([USAePayHelper isValue:__node name:@"CardholderAuthentication"])
                     {
                         self.CardholderAuthentication = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"CheckPlatform"])
                 {
                     if([USAePayHelper isValue:__node name:@"CheckPlatform"])
                     {
                         self.CheckPlatform = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"CreditCardPlatform"])
                 {
                     if([USAePayHelper isValue:__node name:@"CreditCardPlatform"])
                     {
                         self.CreditCardPlatform = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"DebitCardSupport"])
                 {
                     if([USAePayHelper isValue:__node name:@"DebitCardSupport"])
                     {
                         self.DebitCardSupport = [[__node stringValue] boolValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"DirectPayPlatform"])
                 {
                     if([USAePayHelper isValue:__node name:@"DirectPayPlatform"])
                     {
                         self.DirectPayPlatform = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"Industry"])
                 {
                     if([USAePayHelper isValue:__node name:@"Industry"])
                     {
                         self.Industry = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"SupportedCurrencies"])
                 {
                     if([USAePayHelper isValue:__node name:@"SupportedCurrencies"])
                     {
                         self.SupportedCurrencies = (USAePayCurrencyObjectArray*)[__request createObject:__node type:[USAePayCurrencyObjectArray class]];
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

            
    DDXMLElement* __CardholderAuthenticationItemElement=[__request writeElement:CardholderAuthentication type:[NSString class] name:@"CardholderAuthentication" URI:@"" parent:__parent skipNullProperty:NO];
    if(__CardholderAuthenticationItemElement!=nil)
    {
        [__CardholderAuthenticationItemElement setStringValue:self.CardholderAuthentication];
    }
            
    DDXMLElement* __CheckPlatformItemElement=[__request writeElement:CheckPlatform type:[NSString class] name:@"CheckPlatform" URI:@"" parent:__parent skipNullProperty:NO];
    if(__CheckPlatformItemElement!=nil)
    {
        [__CheckPlatformItemElement setStringValue:self.CheckPlatform];
    }
            
    DDXMLElement* __CreditCardPlatformItemElement=[__request writeElement:CreditCardPlatform type:[NSString class] name:@"CreditCardPlatform" URI:@"" parent:__parent skipNullProperty:NO];
    if(__CreditCardPlatformItemElement!=nil)
    {
        [__CreditCardPlatformItemElement setStringValue:self.CreditCardPlatform];
    }
            
    DDXMLElement* __DebitCardSupportItemElement=[__request writeElement:@"DebitCardSupport" URI:@"" parent:__parent];
    [__DebitCardSupportItemElement setStringValue:[USAePayHelper toBoolStringFromBool:self.DebitCardSupport]];
            
    DDXMLElement* __DirectPayPlatformItemElement=[__request writeElement:DirectPayPlatform type:[NSString class] name:@"DirectPayPlatform" URI:@"" parent:__parent skipNullProperty:NO];
    if(__DirectPayPlatformItemElement!=nil)
    {
        [__DirectPayPlatformItemElement setStringValue:self.DirectPayPlatform];
    }
            
    DDXMLElement* __IndustryItemElement=[__request writeElement:Industry type:[NSString class] name:@"Industry" URI:@"" parent:__parent skipNullProperty:NO];
    if(__IndustryItemElement!=nil)
    {
        [__IndustryItemElement setStringValue:self.Industry];
    }
            
    DDXMLElement* __SupportedCurrenciesItemElement=[__request writeElement:SupportedCurrencies type:[USAePayCurrencyObjectArray class] name:@"SupportedCurrencies" URI:@"" parent:__parent skipNullProperty:NO];
    if(__SupportedCurrenciesItemElement!=nil)
    {
        [self.SupportedCurrencies serialize:__SupportedCurrenciesItemElement __request: __request];
    }
            
    for(DDXMLElement* elem in self.any)
    {
        [elem detach];
        [__parent addChild:elem];
    }


}
@end