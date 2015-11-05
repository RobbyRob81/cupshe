//----------------------------------------------------
//
// Generated by www.easywsdl.com
// Version: 4.1.9.0
//
// Created by Quasar Development at 02-11-2015
//
//---------------------------------------------------


#import "USAePayProductArray.h"
#import "USAePayHelper.h"
#import "USAePayProductSearchResult.h"


@implementation USAePayProductSearchResult
@synthesize Products;
@synthesize ProductsMatched;
@synthesize ProductsReturned;
@synthesize Limit;
@synthesize StartIndex;
@synthesize any;

+ (USAePayProductSearchResult *)createWithXml:(DDXMLElement *)__node __request:(USAePayRequestResultHandler*) __request
{
    if(__node == nil) { return nil; }
    return [[self alloc] initWithXml: __node __request:__request];
}

-(id)init {
    if ((self=[super init])) {
        self.Products =[[USAePayProductArray alloc]init];
        self.ProductsMatched =[NSNumber numberWithInt:0];
        self.ProductsReturned =[NSNumber numberWithInt:0];
        self.Limit =[NSNumber numberWithInt:0];
        self.StartIndex =[NSNumber numberWithInt:0];
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
                 if([__node.localName isEqualToString:@"Products"])
                 {
                     if([USAePayHelper isValue:__node name:@"Products"])
                     {
                         self.Products = (USAePayProductArray*)[__request createObject:__node type:[USAePayProductArray class]];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"ProductsMatched"])
                 {
                     if([USAePayHelper isValue:__node name:@"ProductsMatched"])
                     {
                         self.ProductsMatched = [USAePayHelper getNumber:[__node stringValue]];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"ProductsReturned"])
                 {
                     if([USAePayHelper isValue:__node name:@"ProductsReturned"])
                     {
                         self.ProductsReturned = [USAePayHelper getNumber:[__node stringValue]];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"Limit"])
                 {
                     if([USAePayHelper isValue:__node name:@"Limit"])
                     {
                         self.Limit = [USAePayHelper getNumber:[__node stringValue]];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"StartIndex"])
                 {
                     if([USAePayHelper isValue:__node name:@"StartIndex"])
                     {
                         self.StartIndex = [USAePayHelper getNumber:[__node stringValue]];
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

            
    DDXMLElement* __ProductsItemElement=[__request writeElement:Products type:[USAePayProductArray class] name:@"Products" URI:@"" parent:__parent skipNullProperty:NO];
    if(__ProductsItemElement!=nil)
    {
        [self.Products serialize:__ProductsItemElement __request: __request];
    }
            
    DDXMLElement* __ProductsMatchedItemElement=[__request writeElement:ProductsMatched type:[NSNumber class] name:@"ProductsMatched" URI:@"" parent:__parent skipNullProperty:NO];
    if(__ProductsMatchedItemElement!=nil)
    {
        [__ProductsMatchedItemElement setStringValue:[self.ProductsMatched stringValue]];
    }
            
    DDXMLElement* __ProductsReturnedItemElement=[__request writeElement:ProductsReturned type:[NSNumber class] name:@"ProductsReturned" URI:@"" parent:__parent skipNullProperty:NO];
    if(__ProductsReturnedItemElement!=nil)
    {
        [__ProductsReturnedItemElement setStringValue:[self.ProductsReturned stringValue]];
    }
            
    DDXMLElement* __LimitItemElement=[__request writeElement:Limit type:[NSNumber class] name:@"Limit" URI:@"" parent:__parent skipNullProperty:NO];
    if(__LimitItemElement!=nil)
    {
        [__LimitItemElement setStringValue:[self.Limit stringValue]];
    }
            
    DDXMLElement* __StartIndexItemElement=[__request writeElement:StartIndex type:[NSNumber class] name:@"StartIndex" URI:@"" parent:__parent skipNullProperty:NO];
    if(__StartIndexItemElement!=nil)
    {
        [__StartIndexItemElement setStringValue:[self.StartIndex stringValue]];
    }
            
    for(DDXMLElement* elem in self.any)
    {
        [elem detach];
        [__parent addChild:elem];
    }


}
@end