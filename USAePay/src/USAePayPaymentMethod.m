//----------------------------------------------------
//
// Generated by www.easywsdl.com
// Version: 4.1.9.0
//
// Created by Quasar Development at 02-11-2015
//
//---------------------------------------------------


#import "USAePayHelper.h"
#import "USAePayPaymentMethod.h"


@implementation USAePayPaymentMethod
@synthesize MethodType;
@synthesize MethodID;
@synthesize MethodName;
@synthesize SecondarySort;
@synthesize Created;
@synthesize Modified;
@synthesize Account;
@synthesize AccountType;
@synthesize DriversLicense;
@synthesize DriversLicenseState;
@synthesize RecordType;
@synthesize Routing;
@synthesize AvsStreet;
@synthesize AvsZip;
@synthesize CardCode;
@synthesize CardExpiration;
@synthesize CardNumber;
@synthesize CardType;
@synthesize Balance;
@synthesize MaxBalance;
@synthesize AutoReload;
@synthesize ReloadSchedule;
@synthesize ReloadThreshold;
@synthesize ReloadAmount;
@synthesize ReloadMethodID;
@synthesize any;

+ (USAePayPaymentMethod *)createWithXml:(DDXMLElement *)__node __request:(USAePayRequestResultHandler*) __request
{
    if(__node == nil) { return nil; }
    return [[self alloc] initWithXml: __node __request:__request];
}

-(id)init {
    if ((self=[super init])) {
        self.SecondarySort =[NSNumber numberWithInt:0];
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
                 if([__node.localName isEqualToString:@"MethodType"])
                 {
                     if([USAePayHelper isValue:__node name:@"MethodType"])
                     {
                         self.MethodType = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"MethodID"])
                 {
                     if([USAePayHelper isValue:__node name:@"MethodID"])
                     {
                         self.MethodID = [USAePayHelper getNumber:[__node stringValue]];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"MethodName"])
                 {
                     if([USAePayHelper isValue:__node name:@"MethodName"])
                     {
                         self.MethodName = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"SecondarySort"])
                 {
                     if([USAePayHelper isValue:__node name:@"SecondarySort"])
                     {
                         self.SecondarySort = [USAePayHelper getNumber:[__node stringValue]];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"Created"])
                 {
                     if([USAePayHelper isValue:__node name:@"Created"])
                     {
                         self.Created = [USAePayHelper getDate:[__node stringValue]];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"Modified"])
                 {
                     if([USAePayHelper isValue:__node name:@"Modified"])
                     {
                         self.Modified = [USAePayHelper getDate:[__node stringValue]];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"Account"])
                 {
                     if([USAePayHelper isValue:__node name:@"Account"])
                     {
                         self.Account = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"AccountType"])
                 {
                     if([USAePayHelper isValue:__node name:@"AccountType"])
                     {
                         self.AccountType = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"DriversLicense"])
                 {
                     if([USAePayHelper isValue:__node name:@"DriversLicense"])
                     {
                         self.DriversLicense = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"DriversLicenseState"])
                 {
                     if([USAePayHelper isValue:__node name:@"DriversLicenseState"])
                     {
                         self.DriversLicenseState = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"RecordType"])
                 {
                     if([USAePayHelper isValue:__node name:@"RecordType"])
                     {
                         self.RecordType = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"Routing"])
                 {
                     if([USAePayHelper isValue:__node name:@"Routing"])
                     {
                         self.Routing = [__node stringValue];
                     }
                     continue;
                 }
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
                 if([__node.localName isEqualToString:@"CardType"])
                 {
                     if([USAePayHelper isValue:__node name:@"CardType"])
                     {
                         self.CardType = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"Balance"])
                 {
                     if([USAePayHelper isValue:__node name:@"Balance"])
                     {
                         self.Balance = [USAePayHelper getNumber:[__node stringValue]];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"MaxBalance"])
                 {
                     if([USAePayHelper isValue:__node name:@"MaxBalance"])
                     {
                         self.MaxBalance = [USAePayHelper getNumber:[__node stringValue]];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"AutoReload"])
                 {
                     if([USAePayHelper isValue:__node name:@"AutoReload"])
                     {
                         self.AutoReload = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"ReloadSchedule"])
                 {
                     if([USAePayHelper isValue:__node name:@"ReloadSchedule"])
                     {
                         self.ReloadSchedule = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"ReloadThreshold"])
                 {
                     if([USAePayHelper isValue:__node name:@"ReloadThreshold"])
                     {
                         self.ReloadThreshold = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"ReloadAmount"])
                 {
                     if([USAePayHelper isValue:__node name:@"ReloadAmount"])
                     {
                         self.ReloadAmount = [__node stringValue];
                     }
                     continue;
                 }
                 if([__node.localName isEqualToString:@"ReloadMethodID"])
                 {
                     if([USAePayHelper isValue:__node name:@"ReloadMethodID"])
                     {
                         self.ReloadMethodID = [USAePayHelper getNumber:[__node stringValue]];
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

            
    DDXMLElement* __MethodTypeItemElement=[__request writeElement:MethodType type:[NSString class] name:@"MethodType" URI:@"" parent:__parent skipNullProperty:YES];
    if(__MethodTypeItemElement!=nil)
    {
        [__MethodTypeItemElement setStringValue:self.MethodType];
    }
            
    DDXMLElement* __MethodIDItemElement=[__request writeElement:MethodID type:[NSNumber class] name:@"MethodID" URI:@"" parent:__parent skipNullProperty:YES];
    if(__MethodIDItemElement!=nil)
    {
        [__MethodIDItemElement setStringValue:[self.MethodID stringValue]];
    }
            
    DDXMLElement* __MethodNameItemElement=[__request writeElement:MethodName type:[NSString class] name:@"MethodName" URI:@"" parent:__parent skipNullProperty:NO];
    if(__MethodNameItemElement!=nil)
    {
        [__MethodNameItemElement setStringValue:self.MethodName];
    }
            
    DDXMLElement* __SecondarySortItemElement=[__request writeElement:SecondarySort type:[NSNumber class] name:@"SecondarySort" URI:@"" parent:__parent skipNullProperty:NO];
    if(__SecondarySortItemElement!=nil)
    {
        [__SecondarySortItemElement setStringValue:[self.SecondarySort stringValue]];
    }
            
    DDXMLElement* __CreatedItemElement=[__request writeElement:Created type:[NSDate class] name:@"Created" URI:@"" parent:__parent skipNullProperty:YES];
    if(__CreatedItemElement!=nil)
    {
        [__CreatedItemElement setStringValue:[USAePayHelper getStringFromDateTime:self.Created]];
    }
            
    DDXMLElement* __ModifiedItemElement=[__request writeElement:Modified type:[NSDate class] name:@"Modified" URI:@"" parent:__parent skipNullProperty:YES];
    if(__ModifiedItemElement!=nil)
    {
        [__ModifiedItemElement setStringValue:[USAePayHelper getStringFromDateTime:self.Modified]];
    }
            
    DDXMLElement* __AccountItemElement=[__request writeElement:Account type:[NSString class] name:@"Account" URI:@"" parent:__parent skipNullProperty:YES];
    if(__AccountItemElement!=nil)
    {
        [__AccountItemElement setStringValue:self.Account];
    }
            
    DDXMLElement* __AccountTypeItemElement=[__request writeElement:AccountType type:[NSString class] name:@"AccountType" URI:@"" parent:__parent skipNullProperty:YES];
    if(__AccountTypeItemElement!=nil)
    {
        [__AccountTypeItemElement setStringValue:self.AccountType];
    }
            
    DDXMLElement* __DriversLicenseItemElement=[__request writeElement:DriversLicense type:[NSString class] name:@"DriversLicense" URI:@"" parent:__parent skipNullProperty:YES];
    if(__DriversLicenseItemElement!=nil)
    {
        [__DriversLicenseItemElement setStringValue:self.DriversLicense];
    }
            
    DDXMLElement* __DriversLicenseStateItemElement=[__request writeElement:DriversLicenseState type:[NSString class] name:@"DriversLicenseState" URI:@"" parent:__parent skipNullProperty:YES];
    if(__DriversLicenseStateItemElement!=nil)
    {
        [__DriversLicenseStateItemElement setStringValue:self.DriversLicenseState];
    }
            
    DDXMLElement* __RecordTypeItemElement=[__request writeElement:RecordType type:[NSString class] name:@"RecordType" URI:@"" parent:__parent skipNullProperty:YES];
    if(__RecordTypeItemElement!=nil)
    {
        [__RecordTypeItemElement setStringValue:self.RecordType];
    }
            
    DDXMLElement* __RoutingItemElement=[__request writeElement:Routing type:[NSString class] name:@"Routing" URI:@"" parent:__parent skipNullProperty:YES];
    if(__RoutingItemElement!=nil)
    {
        [__RoutingItemElement setStringValue:self.Routing];
    }
            
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
            
    DDXMLElement* __CardTypeItemElement=[__request writeElement:CardType type:[NSString class] name:@"CardType" URI:@"" parent:__parent skipNullProperty:YES];
    if(__CardTypeItemElement!=nil)
    {
        [__CardTypeItemElement setStringValue:self.CardType];
    }
            
    DDXMLElement* __BalanceItemElement=[__request writeElement:Balance type:[NSNumber class] name:@"Balance" URI:@"" parent:__parent skipNullProperty:YES];
    if(__BalanceItemElement!=nil)
    {
        [__BalanceItemElement setStringValue:[self.Balance stringValue]];
    }
            
    DDXMLElement* __MaxBalanceItemElement=[__request writeElement:MaxBalance type:[NSNumber class] name:@"MaxBalance" URI:@"" parent:__parent skipNullProperty:YES];
    if(__MaxBalanceItemElement!=nil)
    {
        [__MaxBalanceItemElement setStringValue:[self.MaxBalance stringValue]];
    }
            
    DDXMLElement* __AutoReloadItemElement=[__request writeElement:AutoReload type:[NSString class] name:@"AutoReload" URI:@"" parent:__parent skipNullProperty:YES];
    if(__AutoReloadItemElement!=nil)
    {
        [__AutoReloadItemElement setStringValue:self.AutoReload];
    }
            
    DDXMLElement* __ReloadScheduleItemElement=[__request writeElement:ReloadSchedule type:[NSString class] name:@"ReloadSchedule" URI:@"" parent:__parent skipNullProperty:YES];
    if(__ReloadScheduleItemElement!=nil)
    {
        [__ReloadScheduleItemElement setStringValue:self.ReloadSchedule];
    }
            
    DDXMLElement* __ReloadThresholdItemElement=[__request writeElement:ReloadThreshold type:[NSString class] name:@"ReloadThreshold" URI:@"" parent:__parent skipNullProperty:YES];
    if(__ReloadThresholdItemElement!=nil)
    {
        [__ReloadThresholdItemElement setStringValue:self.ReloadThreshold];
    }
            
    DDXMLElement* __ReloadAmountItemElement=[__request writeElement:ReloadAmount type:[NSString class] name:@"ReloadAmount" URI:@"" parent:__parent skipNullProperty:YES];
    if(__ReloadAmountItemElement!=nil)
    {
        [__ReloadAmountItemElement setStringValue:self.ReloadAmount];
    }
            
    DDXMLElement* __ReloadMethodIDItemElement=[__request writeElement:ReloadMethodID type:[NSNumber class] name:@"ReloadMethodID" URI:@"" parent:__parent skipNullProperty:YES];
    if(__ReloadMethodIDItemElement!=nil)
    {
        [__ReloadMethodIDItemElement setStringValue:[self.ReloadMethodID stringValue]];
    }
            
    for(DDXMLElement* elem in self.any)
    {
        [elem detach];
        [__parent addChild:elem];
    }


}
@end
