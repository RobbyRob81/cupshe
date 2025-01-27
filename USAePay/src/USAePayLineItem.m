//----------------------------------------------------
//
// Generated by www.easywsdl.com
// Version: 4.1.9.0
//
// Created by Quasar Development at 02-11-2015
//
//---------------------------------------------------


#import "USAePayHelper.h"
#import "USAePayLineItem.h"


@implementation USAePayLineItem
@synthesize ProductRefNum;
@synthesize SKU;
@synthesize ProductName;
@synthesize Description;
@synthesize UnitPrice;
@synthesize Qty;
@synthesize Taxable;
@synthesize any;

+ (USAePayLineItem *)createWithXml:(DDXMLElement *)__node __request:(USAePayRequestResultHandler*) __request
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
                 if([__node.localName isEqualToString:@"ProductRefNum"])
                 {
                     if([USAePayHelper isValue:__node name:@"ProductRefNum"])
                     {
                         self.ProductRefNum = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"SKU"])
                 {
                     if([USAePayHelper isValue:__node name:@"SKU"])
                     {
                         self.SKU = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"ProductName"])
                 {
                     if([USAePayHelper isValue:__node name:@"ProductName"])
                     {
                         self.ProductName = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"Description"])
                 {
                     if([USAePayHelper isValue:__node name:@"Description"])
                     {
                         self.Description = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"UnitPrice"])
                 {
                     if([USAePayHelper isValue:__node name:@"UnitPrice"])
                     {
                         self.UnitPrice = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"Qty"])
                 {
                     if([USAePayHelper isValue:__node name:@"Qty"])
                     {
                         self.Qty = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"Taxable"])
                 {
                     if([USAePayHelper isValue:__node name:@"Taxable"])
                     {
                         self.Taxable = [[NSNumber alloc]initWithBool:[[__node stringValue] boolValue]];
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

            
    DDXMLElement* __ProductRefNumItemElement=[__request writeElement:ProductRefNum type:[NSString class] name:@"ProductRefNum" URI:@"" parent:__parent skipNullProperty:YES];
    if(__ProductRefNumItemElement!=nil)
    {
        [__ProductRefNumItemElement setStringValue:self.ProductRefNum];
    }
            
    DDXMLElement* __SKUItemElement=[__request writeElement:SKU type:[NSString class] name:@"SKU" URI:@"" parent:__parent skipNullProperty:YES];
    if(__SKUItemElement!=nil)
    {
        [__SKUItemElement setStringValue:self.SKU];
    }
            
    DDXMLElement* __ProductNameItemElement=[__request writeElement:ProductName type:[NSString class] name:@"ProductName" URI:@"" parent:__parent skipNullProperty:YES];
    if(__ProductNameItemElement!=nil)
    {
        [__ProductNameItemElement setStringValue:self.ProductName];
    }
            
    DDXMLElement* __DescriptionItemElement=[__request writeElement:Description type:[NSString class] name:@"Description" URI:@"" parent:__parent skipNullProperty:YES];
    if(__DescriptionItemElement!=nil)
    {
        [__DescriptionItemElement setStringValue:self.Description];
    }
            
    DDXMLElement* __UnitPriceItemElement=[__request writeElement:UnitPrice type:[NSString class] name:@"UnitPrice" URI:@"" parent:__parent skipNullProperty:NO];
    if(__UnitPriceItemElement!=nil)
    {
        [__UnitPriceItemElement setStringValue:self.UnitPrice];
    }
            
    DDXMLElement* __QtyItemElement=[__request writeElement:Qty type:[NSString class] name:@"Qty" URI:@"" parent:__parent skipNullProperty:NO];
    if(__QtyItemElement!=nil)
    {
        [__QtyItemElement setStringValue:self.Qty];
    }
            
    DDXMLElement* __TaxableItemElement=[__request writeElement:Taxable type:[NSNumber class] name:@"Taxable" URI:@"" parent:__parent skipNullProperty:YES];
    if(__TaxableItemElement!=nil)
    {
        [__TaxableItemElement setStringValue:[USAePayHelper toBoolStringFromNumber:self.Taxable]];
    }
            
    for(DDXMLElement* elem in self.any)
    {
        [elem detach];
        [__parent addChild:elem];
    }


}
@end
