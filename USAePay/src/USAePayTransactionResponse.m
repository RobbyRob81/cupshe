//----------------------------------------------------
//
// Generated by www.easywsdl.com
// Version: 4.1.9.0
//
// Created by Quasar Development at 02-11-2015
//
//---------------------------------------------------


#import "USAePayHelper.h"
#import "USAePayTransactionResponse.h"


@implementation USAePayTransactionResponse
@synthesize AcsUrl;
@synthesize AuthAmount;
@synthesize AuthCode;
@synthesize AvsResult;
@synthesize AvsResultCode;
@synthesize BatchNum;
@synthesize BatchRefNum;
@synthesize CardCodeResult;
@synthesize CardCodeResultCode;
@synthesize CardLevelResult;
@synthesize CardLevelResultCode;
@synthesize ConversionRate;
@synthesize ConvertedAmount;
@synthesize ConvertedAmountCurrency;
@synthesize CustNum;
@synthesize Error;
@synthesize ErrorCode;
@synthesize isDuplicate;
@synthesize Payload;
@synthesize RefNum;
@synthesize RemainingBalance;
@synthesize Result;
@synthesize ResultCode;
@synthesize Status;
@synthesize StatusCode;
@synthesize VpasResultCode;
@synthesize any;

+ (USAePayTransactionResponse *)createWithXml:(DDXMLElement *)__node __request:(USAePayRequestResultHandler*) __request
{
    if(__node == nil) { return nil; }
    return [[self alloc] initWithXml: __node __request:__request];
}

-(id)init {
    if ((self=[super init])) {
        self.AuthAmount =[NSNumber numberWithInt:0];
        self.BatchNum =[NSNumber numberWithInt:0];
        self.BatchRefNum =[NSNumber numberWithInt:0];
        self.ConversionRate =[NSNumber numberWithInt:0];
        self.ConvertedAmount =[NSNumber numberWithInt:0];
        self.CustNum =[NSNumber numberWithInt:0];
        self.ErrorCode =[NSNumber numberWithInt:0];
        self.RefNum =[NSNumber numberWithInt:0];
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
                 if([__node.localName isEqualToString:@"AcsUrl"])
                 {
                     if([USAePayHelper isValue:__node name:@"AcsUrl"])
                     {
                         self.AcsUrl = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"AuthAmount"])
                 {
                     if([USAePayHelper isValue:__node name:@"AuthAmount"])
                     {
                         self.AuthAmount = [USAePayHelper getNumber:[__node stringValue]];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"AuthCode"])
                 {
                     if([USAePayHelper isValue:__node name:@"AuthCode"])
                     {
                         self.AuthCode = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"AvsResult"])
                 {
                     if([USAePayHelper isValue:__node name:@"AvsResult"])
                     {
                         self.AvsResult = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"AvsResultCode"])
                 {
                     if([USAePayHelper isValue:__node name:@"AvsResultCode"])
                     {
                         self.AvsResultCode = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"BatchNum"])
                 {
                     if([USAePayHelper isValue:__node name:@"BatchNum"])
                     {
                         self.BatchNum = [USAePayHelper getNumber:[__node stringValue]];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"BatchRefNum"])
                 {
                     if([USAePayHelper isValue:__node name:@"BatchRefNum"])
                     {
                         self.BatchRefNum = [USAePayHelper getNumber:[__node stringValue]];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"CardCodeResult"])
                 {
                     if([USAePayHelper isValue:__node name:@"CardCodeResult"])
                     {
                         self.CardCodeResult = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"CardCodeResultCode"])
                 {
                     if([USAePayHelper isValue:__node name:@"CardCodeResultCode"])
                     {
                         self.CardCodeResultCode = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"CardLevelResult"])
                 {
                     if([USAePayHelper isValue:__node name:@"CardLevelResult"])
                     {
                         self.CardLevelResult = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"CardLevelResultCode"])
                 {
                     if([USAePayHelper isValue:__node name:@"CardLevelResultCode"])
                     {
                         self.CardLevelResultCode = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"ConversionRate"])
                 {
                     if([USAePayHelper isValue:__node name:@"ConversionRate"])
                     {
                         self.ConversionRate = [USAePayHelper getNumber:[__node stringValue]];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"ConvertedAmount"])
                 {
                     if([USAePayHelper isValue:__node name:@"ConvertedAmount"])
                     {
                         self.ConvertedAmount = [USAePayHelper getNumber:[__node stringValue]];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"ConvertedAmountCurrency"])
                 {
                     if([USAePayHelper isValue:__node name:@"ConvertedAmountCurrency"])
                     {
                         self.ConvertedAmountCurrency = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"CustNum"])
                 {
                     if([USAePayHelper isValue:__node name:@"CustNum"])
                     {
                         self.CustNum = [USAePayHelper getNumber:[__node stringValue]];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"Error"])
                 {
                     if([USAePayHelper isValue:__node name:@"Error"])
                     {
                         self.Error = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"ErrorCode"])
                 {
                     if([USAePayHelper isValue:__node name:@"ErrorCode"])
                     {
                         self.ErrorCode = [USAePayHelper getNumber:[__node stringValue]];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"isDuplicate"])
                 {
                     if([USAePayHelper isValue:__node name:@"isDuplicate"])
                     {
                         self.isDuplicate = [[__node stringValue] boolValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"Payload"])
                 {
                     if([USAePayHelper isValue:__node name:@"Payload"])
                     {
                         self.Payload = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"RefNum"])
                 {
                     if([USAePayHelper isValue:__node name:@"RefNum"])
                     {
                         self.RefNum = [USAePayHelper getNumber:[__node stringValue]];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"RemainingBalance"])
                 {
                     if([USAePayHelper isValue:__node name:@"RemainingBalance"])
                     {
                         self.RemainingBalance = [USAePayHelper getNumber:[__node stringValue]];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"Result"])
                 {
                     if([USAePayHelper isValue:__node name:@"Result"])
                     {
                         self.Result = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"ResultCode"])
                 {
                     if([USAePayHelper isValue:__node name:@"ResultCode"])
                     {
                         self.ResultCode = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"Status"])
                 {
                     if([USAePayHelper isValue:__node name:@"Status"])
                     {
                         self.Status = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"StatusCode"])
                 {
                     if([USAePayHelper isValue:__node name:@"StatusCode"])
                     {
                         self.StatusCode = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"VpasResultCode"])
                 {
                     if([USAePayHelper isValue:__node name:@"VpasResultCode"])
                     {
                         self.VpasResultCode = [__node stringValue];
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

            
    DDXMLElement* __AcsUrlItemElement=[__request writeElement:AcsUrl type:[NSString class] name:@"AcsUrl" URI:@"" parent:__parent skipNullProperty:NO];
    if(__AcsUrlItemElement!=nil)
    {
        [__AcsUrlItemElement setStringValue:self.AcsUrl];
    }
            
    DDXMLElement* __AuthAmountItemElement=[__request writeElement:AuthAmount type:[NSNumber class] name:@"AuthAmount" URI:@"" parent:__parent skipNullProperty:NO];
    if(__AuthAmountItemElement!=nil)
    {
        [__AuthAmountItemElement setStringValue:[self.AuthAmount stringValue]];
    }
            
    DDXMLElement* __AuthCodeItemElement=[__request writeElement:AuthCode type:[NSString class] name:@"AuthCode" URI:@"" parent:__parent skipNullProperty:NO];
    if(__AuthCodeItemElement!=nil)
    {
        [__AuthCodeItemElement setStringValue:self.AuthCode];
    }
            
    DDXMLElement* __AvsResultItemElement=[__request writeElement:AvsResult type:[NSString class] name:@"AvsResult" URI:@"" parent:__parent skipNullProperty:NO];
    if(__AvsResultItemElement!=nil)
    {
        [__AvsResultItemElement setStringValue:self.AvsResult];
    }
            
    DDXMLElement* __AvsResultCodeItemElement=[__request writeElement:AvsResultCode type:[NSString class] name:@"AvsResultCode" URI:@"" parent:__parent skipNullProperty:NO];
    if(__AvsResultCodeItemElement!=nil)
    {
        [__AvsResultCodeItemElement setStringValue:self.AvsResultCode];
    }
            
    DDXMLElement* __BatchNumItemElement=[__request writeElement:BatchNum type:[NSNumber class] name:@"BatchNum" URI:@"" parent:__parent skipNullProperty:NO];
    if(__BatchNumItemElement!=nil)
    {
        [__BatchNumItemElement setStringValue:[self.BatchNum stringValue]];
    }
            
    DDXMLElement* __BatchRefNumItemElement=[__request writeElement:BatchRefNum type:[NSNumber class] name:@"BatchRefNum" URI:@"" parent:__parent skipNullProperty:NO];
    if(__BatchRefNumItemElement!=nil)
    {
        [__BatchRefNumItemElement setStringValue:[self.BatchRefNum stringValue]];
    }
            
    DDXMLElement* __CardCodeResultItemElement=[__request writeElement:CardCodeResult type:[NSString class] name:@"CardCodeResult" URI:@"" parent:__parent skipNullProperty:NO];
    if(__CardCodeResultItemElement!=nil)
    {
        [__CardCodeResultItemElement setStringValue:self.CardCodeResult];
    }
            
    DDXMLElement* __CardCodeResultCodeItemElement=[__request writeElement:CardCodeResultCode type:[NSString class] name:@"CardCodeResultCode" URI:@"" parent:__parent skipNullProperty:NO];
    if(__CardCodeResultCodeItemElement!=nil)
    {
        [__CardCodeResultCodeItemElement setStringValue:self.CardCodeResultCode];
    }
            
    DDXMLElement* __CardLevelResultItemElement=[__request writeElement:CardLevelResult type:[NSString class] name:@"CardLevelResult" URI:@"" parent:__parent skipNullProperty:NO];
    if(__CardLevelResultItemElement!=nil)
    {
        [__CardLevelResultItemElement setStringValue:self.CardLevelResult];
    }
            
    DDXMLElement* __CardLevelResultCodeItemElement=[__request writeElement:CardLevelResultCode type:[NSString class] name:@"CardLevelResultCode" URI:@"" parent:__parent skipNullProperty:NO];
    if(__CardLevelResultCodeItemElement!=nil)
    {
        [__CardLevelResultCodeItemElement setStringValue:self.CardLevelResultCode];
    }
            
    DDXMLElement* __ConversionRateItemElement=[__request writeElement:ConversionRate type:[NSNumber class] name:@"ConversionRate" URI:@"" parent:__parent skipNullProperty:NO];
    if(__ConversionRateItemElement!=nil)
    {
        [__ConversionRateItemElement setStringValue:[self.ConversionRate stringValue]];
    }
            
    DDXMLElement* __ConvertedAmountItemElement=[__request writeElement:ConvertedAmount type:[NSNumber class] name:@"ConvertedAmount" URI:@"" parent:__parent skipNullProperty:NO];
    if(__ConvertedAmountItemElement!=nil)
    {
        [__ConvertedAmountItemElement setStringValue:[self.ConvertedAmount stringValue]];
    }
            
    DDXMLElement* __ConvertedAmountCurrencyItemElement=[__request writeElement:ConvertedAmountCurrency type:[NSString class] name:@"ConvertedAmountCurrency" URI:@"" parent:__parent skipNullProperty:NO];
    if(__ConvertedAmountCurrencyItemElement!=nil)
    {
        [__ConvertedAmountCurrencyItemElement setStringValue:self.ConvertedAmountCurrency];
    }
            
    DDXMLElement* __CustNumItemElement=[__request writeElement:CustNum type:[NSNumber class] name:@"CustNum" URI:@"" parent:__parent skipNullProperty:NO];
    if(__CustNumItemElement!=nil)
    {
        [__CustNumItemElement setStringValue:[self.CustNum stringValue]];
    }
            
    DDXMLElement* __ErrorItemElement=[__request writeElement:Error type:[NSString class] name:@"Error" URI:@"" parent:__parent skipNullProperty:NO];
    if(__ErrorItemElement!=nil)
    {
        [__ErrorItemElement setStringValue:self.Error];
    }
            
    DDXMLElement* __ErrorCodeItemElement=[__request writeElement:ErrorCode type:[NSNumber class] name:@"ErrorCode" URI:@"" parent:__parent skipNullProperty:NO];
    if(__ErrorCodeItemElement!=nil)
    {
        [__ErrorCodeItemElement setStringValue:[self.ErrorCode stringValue]];
    }
            
    DDXMLElement* __isDuplicateItemElement=[__request writeElement:@"isDuplicate" URI:@"" parent:__parent];
    [__isDuplicateItemElement setStringValue:[USAePayHelper toBoolStringFromBool:self.isDuplicate]];
            
    DDXMLElement* __PayloadItemElement=[__request writeElement:Payload type:[NSString class] name:@"Payload" URI:@"" parent:__parent skipNullProperty:NO];
    if(__PayloadItemElement!=nil)
    {
        [__PayloadItemElement setStringValue:self.Payload];
    }
            
    DDXMLElement* __RefNumItemElement=[__request writeElement:RefNum type:[NSNumber class] name:@"RefNum" URI:@"" parent:__parent skipNullProperty:NO];
    if(__RefNumItemElement!=nil)
    {
        [__RefNumItemElement setStringValue:[self.RefNum stringValue]];
    }
            
    DDXMLElement* __RemainingBalanceItemElement=[__request writeElement:RemainingBalance type:[NSNumber class] name:@"RemainingBalance" URI:@"" parent:__parent skipNullProperty:YES];
    if(__RemainingBalanceItemElement!=nil)
    {
        [__RemainingBalanceItemElement setStringValue:[self.RemainingBalance stringValue]];
    }
            
    DDXMLElement* __ResultItemElement=[__request writeElement:Result type:[NSString class] name:@"Result" URI:@"" parent:__parent skipNullProperty:NO];
    if(__ResultItemElement!=nil)
    {
        [__ResultItemElement setStringValue:self.Result];
    }
            
    DDXMLElement* __ResultCodeItemElement=[__request writeElement:ResultCode type:[NSString class] name:@"ResultCode" URI:@"" parent:__parent skipNullProperty:NO];
    if(__ResultCodeItemElement!=nil)
    {
        [__ResultCodeItemElement setStringValue:self.ResultCode];
    }
            
    DDXMLElement* __StatusItemElement=[__request writeElement:Status type:[NSString class] name:@"Status" URI:@"" parent:__parent skipNullProperty:NO];
    if(__StatusItemElement!=nil)
    {
        [__StatusItemElement setStringValue:self.Status];
    }
            
    DDXMLElement* __StatusCodeItemElement=[__request writeElement:StatusCode type:[NSString class] name:@"StatusCode" URI:@"" parent:__parent skipNullProperty:NO];
    if(__StatusCodeItemElement!=nil)
    {
        [__StatusCodeItemElement setStringValue:self.StatusCode];
    }
            
    DDXMLElement* __VpasResultCodeItemElement=[__request writeElement:VpasResultCode type:[NSString class] name:@"VpasResultCode" URI:@"" parent:__parent skipNullProperty:NO];
    if(__VpasResultCodeItemElement!=nil)
    {
        [__VpasResultCodeItemElement setStringValue:self.VpasResultCode];
    }
            
    for(DDXMLElement* elem in self.any)
    {
        [elem detach];
        [__parent addChild:elem];
    }


}
@end