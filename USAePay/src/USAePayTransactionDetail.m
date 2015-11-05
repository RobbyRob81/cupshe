//----------------------------------------------------
//
// Generated by www.easywsdl.com
// Version: 4.1.9.0
//
// Created by Quasar Development at 02-11-2015
//
//---------------------------------------------------


#import "USAePayHelper.h"
#import "USAePayTransactionDetail.h"


@implementation USAePayTransactionDetail
@synthesize AllowPartialAuth;
@synthesize Amount;
@synthesize Clerk;
@synthesize Currency;
@synthesize Description;
@synthesize Comments;
@synthesize Discount;
@synthesize Invoice;
@synthesize NonTax;
@synthesize OrderID;
@synthesize PONum;
@synthesize Shipping;
@synthesize Subtotal;
@synthesize Table;
@synthesize Tax;
@synthesize Terminal;
@synthesize Tip;
@synthesize any;

+ (USAePayTransactionDetail *)createWithXml:(DDXMLElement *)__node __request:(USAePayRequestResultHandler*) __request
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
                 if([__node.localName isEqualToString:@"AllowPartialAuth"])
                 {
                     if([USAePayHelper isValue:__node name:@"AllowPartialAuth"])
                     {
                         self.AllowPartialAuth = [[NSNumber alloc]initWithBool:[[__node stringValue] boolValue]];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"Amount"])
                 {
                     if([USAePayHelper isValue:__node name:@"Amount"])
                     {
                         self.Amount = [USAePayHelper getNumber:[__node stringValue]];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"Clerk"])
                 {
                     if([USAePayHelper isValue:__node name:@"Clerk"])
                     {
                         self.Clerk = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"Currency"])
                 {
                     if([USAePayHelper isValue:__node name:@"Currency"])
                     {
                         self.Currency = [__node stringValue];
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
                 if([__node.localName isEqualToString:@"Comments"])
                 {
                     if([USAePayHelper isValue:__node name:@"Comments"])
                     {
                         self.Comments = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"Discount"])
                 {
                     if([USAePayHelper isValue:__node name:@"Discount"])
                     {
                         self.Discount = [USAePayHelper getNumber:[__node stringValue]];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"Invoice"])
                 {
                     if([USAePayHelper isValue:__node name:@"Invoice"])
                     {
                         self.Invoice = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"NonTax"])
                 {
                     if([USAePayHelper isValue:__node name:@"NonTax"])
                     {
                         self.NonTax = [[NSNumber alloc]initWithBool:[[__node stringValue] boolValue]];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"OrderID"])
                 {
                     if([USAePayHelper isValue:__node name:@"OrderID"])
                     {
                         self.OrderID = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"PONum"])
                 {
                     if([USAePayHelper isValue:__node name:@"PONum"])
                     {
                         self.PONum = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"Shipping"])
                 {
                     if([USAePayHelper isValue:__node name:@"Shipping"])
                     {
                         self.Shipping = [USAePayHelper getNumber:[__node stringValue]];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"Subtotal"])
                 {
                     if([USAePayHelper isValue:__node name:@"Subtotal"])
                     {
                         self.Subtotal = [USAePayHelper getNumber:[__node stringValue]];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"Table"])
                 {
                     if([USAePayHelper isValue:__node name:@"Table"])
                     {
                         self.Table = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"Tax"])
                 {
                     if([USAePayHelper isValue:__node name:@"Tax"])
                     {
                         self.Tax = [USAePayHelper getNumber:[__node stringValue]];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"Terminal"])
                 {
                     if([USAePayHelper isValue:__node name:@"Terminal"])
                     {
                         self.Terminal = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"Tip"])
                 {
                     if([USAePayHelper isValue:__node name:@"Tip"])
                     {
                         self.Tip = [USAePayHelper getNumber:[__node stringValue]];
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

            
    DDXMLElement* __AllowPartialAuthItemElement=[__request writeElement:AllowPartialAuth type:[NSNumber class] name:@"AllowPartialAuth" URI:@"" parent:__parent skipNullProperty:YES];
    if(__AllowPartialAuthItemElement!=nil)
    {
        [__AllowPartialAuthItemElement setStringValue:[USAePayHelper toBoolStringFromNumber:self.AllowPartialAuth]];
    }
            
    DDXMLElement* __AmountItemElement=[__request writeElement:Amount type:[NSNumber class] name:@"Amount" URI:@"" parent:__parent skipNullProperty:YES];
    if(__AmountItemElement!=nil)
    {
        [__AmountItemElement setStringValue:[self.Amount stringValue]];
    }
            
    DDXMLElement* __ClerkItemElement=[__request writeElement:Clerk type:[NSString class] name:@"Clerk" URI:@"" parent:__parent skipNullProperty:YES];
    if(__ClerkItemElement!=nil)
    {
        [__ClerkItemElement setStringValue:self.Clerk];
    }
            
    DDXMLElement* __CurrencyItemElement=[__request writeElement:Currency type:[NSString class] name:@"Currency" URI:@"" parent:__parent skipNullProperty:YES];
    if(__CurrencyItemElement!=nil)
    {
        [__CurrencyItemElement setStringValue:self.Currency];
    }
            
    DDXMLElement* __DescriptionItemElement=[__request writeElement:Description type:[NSString class] name:@"Description" URI:@"" parent:__parent skipNullProperty:YES];
    if(__DescriptionItemElement!=nil)
    {
        [__DescriptionItemElement setStringValue:self.Description];
    }
            
    DDXMLElement* __CommentsItemElement=[__request writeElement:Comments type:[NSString class] name:@"Comments" URI:@"" parent:__parent skipNullProperty:YES];
    if(__CommentsItemElement!=nil)
    {
        [__CommentsItemElement setStringValue:self.Comments];
    }
            
    DDXMLElement* __DiscountItemElement=[__request writeElement:Discount type:[NSNumber class] name:@"Discount" URI:@"" parent:__parent skipNullProperty:YES];
    if(__DiscountItemElement!=nil)
    {
        [__DiscountItemElement setStringValue:[self.Discount stringValue]];
    }
            
    DDXMLElement* __InvoiceItemElement=[__request writeElement:Invoice type:[NSString class] name:@"Invoice" URI:@"" parent:__parent skipNullProperty:YES];
    if(__InvoiceItemElement!=nil)
    {
        [__InvoiceItemElement setStringValue:self.Invoice];
    }
            
    DDXMLElement* __NonTaxItemElement=[__request writeElement:NonTax type:[NSNumber class] name:@"NonTax" URI:@"" parent:__parent skipNullProperty:YES];
    if(__NonTaxItemElement!=nil)
    {
        [__NonTaxItemElement setStringValue:[USAePayHelper toBoolStringFromNumber:self.NonTax]];
    }
            
    DDXMLElement* __OrderIDItemElement=[__request writeElement:OrderID type:[NSString class] name:@"OrderID" URI:@"" parent:__parent skipNullProperty:YES];
    if(__OrderIDItemElement!=nil)
    {
        [__OrderIDItemElement setStringValue:self.OrderID];
    }
            
    DDXMLElement* __PONumItemElement=[__request writeElement:PONum type:[NSString class] name:@"PONum" URI:@"" parent:__parent skipNullProperty:YES];
    if(__PONumItemElement!=nil)
    {
        [__PONumItemElement setStringValue:self.PONum];
    }
            
    DDXMLElement* __ShippingItemElement=[__request writeElement:Shipping type:[NSNumber class] name:@"Shipping" URI:@"" parent:__parent skipNullProperty:YES];
    if(__ShippingItemElement!=nil)
    {
        [__ShippingItemElement setStringValue:[self.Shipping stringValue]];
    }
            
    DDXMLElement* __SubtotalItemElement=[__request writeElement:Subtotal type:[NSNumber class] name:@"Subtotal" URI:@"" parent:__parent skipNullProperty:YES];
    if(__SubtotalItemElement!=nil)
    {
        [__SubtotalItemElement setStringValue:[self.Subtotal stringValue]];
    }
            
    DDXMLElement* __TableItemElement=[__request writeElement:Table type:[NSString class] name:@"Table" URI:@"" parent:__parent skipNullProperty:YES];
    if(__TableItemElement!=nil)
    {
        [__TableItemElement setStringValue:self.Table];
    }
            
    DDXMLElement* __TaxItemElement=[__request writeElement:Tax type:[NSNumber class] name:@"Tax" URI:@"" parent:__parent skipNullProperty:YES];
    if(__TaxItemElement!=nil)
    {
        [__TaxItemElement setStringValue:[self.Tax stringValue]];
    }
            
    DDXMLElement* __TerminalItemElement=[__request writeElement:Terminal type:[NSString class] name:@"Terminal" URI:@"" parent:__parent skipNullProperty:YES];
    if(__TerminalItemElement!=nil)
    {
        [__TerminalItemElement setStringValue:self.Terminal];
    }
            
    DDXMLElement* __TipItemElement=[__request writeElement:Tip type:[NSNumber class] name:@"Tip" URI:@"" parent:__parent skipNullProperty:YES];
    if(__TipItemElement!=nil)
    {
        [__TipItemElement setStringValue:[self.Tip stringValue]];
    }
            
    for(DDXMLElement* elem in self.any)
    {
        [elem detach];
        [__parent addChild:elem];
    }


}
@end