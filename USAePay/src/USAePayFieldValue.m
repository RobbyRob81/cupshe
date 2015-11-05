//----------------------------------------------------
//
// Generated by www.easywsdl.com
// Version: 4.1.9.0
//
// Created by Quasar Development at 02-11-2015
//
//---------------------------------------------------


#import "USAePayHelper.h"
#import "USAePayFieldValue.h"


@implementation USAePayFieldValue
@synthesize Field;
@synthesize Value;
@synthesize any;

+ (USAePayFieldValue *)createWithXml:(DDXMLElement *)__node __request:(USAePayRequestResultHandler*) __request
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
                 if([__node.localName isEqualToString:@"Field"])
                 {
                     if([USAePayHelper isValue:__node name:@"Field"])
                     {
                         self.Field = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"Value"])
                 {
                     if([USAePayHelper isValue:__node name:@"Value"])
                     {
                         self.Value = [__node stringValue];
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

            
    DDXMLElement* __FieldItemElement=[__request writeElement:Field type:[NSString class] name:@"Field" URI:@"" parent:__parent skipNullProperty:NO];
    if(__FieldItemElement!=nil)
    {
        [__FieldItemElement setStringValue:self.Field];
    }
            
    DDXMLElement* __ValueItemElement=[__request writeElement:Value type:[NSString class] name:@"Value" URI:@"" parent:__parent skipNullProperty:NO];
    if(__ValueItemElement!=nil)
    {
        [__ValueItemElement setStringValue:self.Value];
    }
            
    for(DDXMLElement* elem in self.any)
    {
        [elem detach];
        [__parent addChild:elem];
    }


}
@end
