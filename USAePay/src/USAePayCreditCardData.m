//----------------------------------------------------
//
// Generated by www.easywsdl.com
// Version: 4.1.9.0
//
// Created by Quasar Development at 02-11-2015
//
//---------------------------------------------------


#import "USAePayHelper.h"
#import "USAePayCreditCardData.h"


@implementation USAePayCreditCardData
@synthesize AvsStreet;
@synthesize AvsZip;
@synthesize CardCode;
@synthesize CardExpiration;
@synthesize CardNumber;
@synthesize CardPresent;
@synthesize CardType;
@synthesize CAVV;
@synthesize DUKPT;
@synthesize ECI;
@synthesize InternalCardAuth;
@synthesize MagStripe;
@synthesize MagSupport;
@synthesize Pares;
@synthesize Signature;
@synthesize TermType;
@synthesize XID;
@synthesize any;

+ (USAePayCreditCardData *)createWithXml:(DDXMLElement *)__node __request:(USAePayRequestResultHandler*) __request
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
                 if([__node.localName isEqualToString:@"AvsStreet"])
                 {
                     if([USAePayHelper isValue:__node name:@"AvsStreet"])
                     {
                         self.AvsStreet = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"AvsZip"])
                 {
                     if([USAePayHelper isValue:__node name:@"AvsZip"])
                     {
                         self.AvsZip = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"CardCode"])
                 {
                     if([USAePayHelper isValue:__node name:@"CardCode"])
                     {
                         self.CardCode = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"CardExpiration"])
                 {
                     if([USAePayHelper isValue:__node name:@"CardExpiration"])
                     {
                         self.CardExpiration = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"CardNumber"])
                 {
                     if([USAePayHelper isValue:__node name:@"CardNumber"])
                     {
                         self.CardNumber = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"CardPresent"])
                 {
                     if([USAePayHelper isValue:__node name:@"CardPresent"])
                     {
                         self.CardPresent = [[NSNumber alloc]initWithBool:[[__node stringValue] boolValue]];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"CardType"])
                 {
                     if([USAePayHelper isValue:__node name:@"CardType"])
                     {
                         self.CardType = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"CAVV"])
                 {
                     if([USAePayHelper isValue:__node name:@"CAVV"])
                     {
                         self.CAVV = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"DUKPT"])
                 {
                     if([USAePayHelper isValue:__node name:@"DUKPT"])
                     {
                         self.DUKPT = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"ECI"])
                 {
                     if([USAePayHelper isValue:__node name:@"ECI"])
                     {
                         self.ECI = [USAePayHelper getNumber:[__node stringValue]];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"InternalCardAuth"])
                 {
                     if([USAePayHelper isValue:__node name:@"InternalCardAuth"])
                     {
                         self.InternalCardAuth = [[NSNumber alloc]initWithBool:[[__node stringValue] boolValue]];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"MagStripe"])
                 {
                     if([USAePayHelper isValue:__node name:@"MagStripe"])
                     {
                         self.MagStripe = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"MagSupport"])
                 {
                     if([USAePayHelper isValue:__node name:@"MagSupport"])
                     {
                         self.MagSupport = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"Pares"])
                 {
                     if([USAePayHelper isValue:__node name:@"Pares"])
                     {
                         self.Pares = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"Signature"])
                 {
                     if([USAePayHelper isValue:__node name:@"Signature"])
                     {
                         self.Signature = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"TermType"])
                 {
                     if([USAePayHelper isValue:__node name:@"TermType"])
                     {
                         self.TermType = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"XID"])
                 {
                     if([USAePayHelper isValue:__node name:@"XID"])
                     {
                         self.XID = [__node stringValue];
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

            
    DDXMLElement* __AvsStreetItemElement=[__request writeElement:AvsStreet type:[NSString class] name:@"AvsStreet" URI:@"" parent:__parent skipNullProperty:YES];
    if(__AvsStreetItemElement!=nil)
    {
        [__AvsStreetItemElement setStringValue:self.AvsStreet];
    }
            
    DDXMLElement* __AvsZipItemElement=[__request writeElement:AvsZip type:[NSString class] name:@"AvsZip" URI:@"" parent:__parent skipNullProperty:YES];
    if(__AvsZipItemElement!=nil)
    {
        [__AvsZipItemElement setStringValue:self.AvsZip];
    }
            
    DDXMLElement* __CardCodeItemElement=[__request writeElement:CardCode type:[NSString class] name:@"CardCode" URI:@"" parent:__parent skipNullProperty:YES];
    if(__CardCodeItemElement!=nil)
    {
        [__CardCodeItemElement setStringValue:self.CardCode];
    }
            
    DDXMLElement* __CardExpirationItemElement=[__request writeElement:CardExpiration type:[NSString class] name:@"CardExpiration" URI:@"" parent:__parent skipNullProperty:YES];
    if(__CardExpirationItemElement!=nil)
    {
        [__CardExpirationItemElement setStringValue:self.CardExpiration];
    }
            
    DDXMLElement* __CardNumberItemElement=[__request writeElement:CardNumber type:[NSString class] name:@"CardNumber" URI:@"" parent:__parent skipNullProperty:YES];
    if(__CardNumberItemElement!=nil)
    {
        [__CardNumberItemElement setStringValue:self.CardNumber];
    }
            
    DDXMLElement* __CardPresentItemElement=[__request writeElement:CardPresent type:[NSNumber class] name:@"CardPresent" URI:@"" parent:__parent skipNullProperty:YES];
    if(__CardPresentItemElement!=nil)
    {
        [__CardPresentItemElement setStringValue:[USAePayHelper toBoolStringFromNumber:self.CardPresent]];
    }
            
    DDXMLElement* __CardTypeItemElement=[__request writeElement:CardType type:[NSString class] name:@"CardType" URI:@"" parent:__parent skipNullProperty:YES];
    if(__CardTypeItemElement!=nil)
    {
        [__CardTypeItemElement setStringValue:self.CardType];
    }
            
    DDXMLElement* __CAVVItemElement=[__request writeElement:CAVV type:[NSString class] name:@"CAVV" URI:@"" parent:__parent skipNullProperty:YES];
    if(__CAVVItemElement!=nil)
    {
        [__CAVVItemElement setStringValue:self.CAVV];
    }
            
    DDXMLElement* __DUKPTItemElement=[__request writeElement:DUKPT type:[NSString class] name:@"DUKPT" URI:@"" parent:__parent skipNullProperty:YES];
    if(__DUKPTItemElement!=nil)
    {
        [__DUKPTItemElement setStringValue:self.DUKPT];
    }
            
    DDXMLElement* __ECIItemElement=[__request writeElement:ECI type:[NSNumber class] name:@"ECI" URI:@"" parent:__parent skipNullProperty:YES];
    if(__ECIItemElement!=nil)
    {
        [__ECIItemElement setStringValue:[self.ECI stringValue]];
    }
            
    DDXMLElement* __InternalCardAuthItemElement=[__request writeElement:InternalCardAuth type:[NSNumber class] name:@"InternalCardAuth" URI:@"" parent:__parent skipNullProperty:YES];
    if(__InternalCardAuthItemElement!=nil)
    {
        [__InternalCardAuthItemElement setStringValue:[USAePayHelper toBoolStringFromNumber:self.InternalCardAuth]];
    }
            
    DDXMLElement* __MagStripeItemElement=[__request writeElement:MagStripe type:[NSString class] name:@"MagStripe" URI:@"" parent:__parent skipNullProperty:YES];
    if(__MagStripeItemElement!=nil)
    {
        [__MagStripeItemElement setStringValue:self.MagStripe];
    }
            
    DDXMLElement* __MagSupportItemElement=[__request writeElement:MagSupport type:[NSString class] name:@"MagSupport" URI:@"" parent:__parent skipNullProperty:YES];
    if(__MagSupportItemElement!=nil)
    {
        [__MagSupportItemElement setStringValue:self.MagSupport];
    }
            
    DDXMLElement* __ParesItemElement=[__request writeElement:Pares type:[NSString class] name:@"Pares" URI:@"" parent:__parent skipNullProperty:YES];
    if(__ParesItemElement!=nil)
    {
        [__ParesItemElement setStringValue:self.Pares];
    }
            
    DDXMLElement* __SignatureItemElement=[__request writeElement:Signature type:[NSString class] name:@"Signature" URI:@"" parent:__parent skipNullProperty:YES];
    if(__SignatureItemElement!=nil)
    {
        [__SignatureItemElement setStringValue:self.Signature];
    }
            
    DDXMLElement* __TermTypeItemElement=[__request writeElement:TermType type:[NSString class] name:@"TermType" URI:@"" parent:__parent skipNullProperty:YES];
    if(__TermTypeItemElement!=nil)
    {
        [__TermTypeItemElement setStringValue:self.TermType];
    }
            
    DDXMLElement* __XIDItemElement=[__request writeElement:XID type:[NSString class] name:@"XID" URI:@"" parent:__parent skipNullProperty:YES];
    if(__XIDItemElement!=nil)
    {
        [__XIDItemElement setStringValue:self.XID];
    }
            
    for(DDXMLElement* elem in self.any)
    {
        [elem detach];
        [__parent addChild:elem];
    }


}
@end
