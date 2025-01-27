//----------------------------------------------------
//
// Generated by www.easywsdl.com
// Version: 4.1.9.0
//
// Created by Quasar Development at 02-11-2015
//
//---------------------------------------------------


#import "USAePayHelper.h"
#import "USAePayProductInventory.h"


@implementation USAePayProductInventory
@synthesize InventoryLocation;
@synthesize QtyOnHand;
@synthesize QtyOnOrder;
@synthesize DateAvailable;
@synthesize any;

+ (USAePayProductInventory *)createWithXml:(DDXMLElement *)__node __request:(USAePayRequestResultHandler*) __request
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
                 if([__node.localName isEqualToString:@"InventoryLocation"])
                 {
                     if([USAePayHelper isValue:__node name:@"InventoryLocation"])
                     {
                         self.InventoryLocation = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"QtyOnHand"])
                 {
                     if([USAePayHelper isValue:__node name:@"QtyOnHand"])
                     {
                         self.QtyOnHand = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"QtyOnOrder"])
                 {
                     if([USAePayHelper isValue:__node name:@"QtyOnOrder"])
                     {
                         self.QtyOnOrder = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"DateAvailable"])
                 {
                     if([USAePayHelper isValue:__node name:@"DateAvailable"])
                     {
                         self.DateAvailable = [__node stringValue];
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

            
    DDXMLElement* __InventoryLocationItemElement=[__request writeElement:InventoryLocation type:[NSString class] name:@"InventoryLocation" URI:@"" parent:__parent skipNullProperty:YES];
    if(__InventoryLocationItemElement!=nil)
    {
        [__InventoryLocationItemElement setStringValue:self.InventoryLocation];
    }
            
    DDXMLElement* __QtyOnHandItemElement=[__request writeElement:QtyOnHand type:[NSString class] name:@"QtyOnHand" URI:@"" parent:__parent skipNullProperty:NO];
    if(__QtyOnHandItemElement!=nil)
    {
        [__QtyOnHandItemElement setStringValue:self.QtyOnHand];
    }
            
    DDXMLElement* __QtyOnOrderItemElement=[__request writeElement:QtyOnOrder type:[NSString class] name:@"QtyOnOrder" URI:@"" parent:__parent skipNullProperty:YES];
    if(__QtyOnOrderItemElement!=nil)
    {
        [__QtyOnOrderItemElement setStringValue:self.QtyOnOrder];
    }
            
    DDXMLElement* __DateAvailableItemElement=[__request writeElement:DateAvailable type:[NSString class] name:@"DateAvailable" URI:@"" parent:__parent skipNullProperty:YES];
    if(__DateAvailableItemElement!=nil)
    {
        [__DateAvailableItemElement setStringValue:self.DateAvailable];
    }
            
    for(DDXMLElement* elem in self.any)
    {
        [elem detach];
        [__parent addChild:elem];
    }


}
@end
