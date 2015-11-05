//----------------------------------------------------
//
// Generated by www.easywsdl.com
// Version: 4.1.9.0
//
// Created by Quasar Development at 02-11-2015
//
//---------------------------------------------------


#import <Foundation/Foundation.h>

@class USAePayHelper;
@class USAePayAddress;
@class USAePayFieldValueArray;
@class USAePayPaymentMethodArray;
#import "USAePayRequestResultHandler.h"
#import "DDXML.h"



@interface USAePayCustomerObject : NSObject <USAePayISerializableObject>


@property (retain,nonatomic,getter=getAmount) NSNumber* Amount;

@property (retain,nonatomic,getter=getBillingAddress) USAePayAddress* BillingAddress;

@property (retain,nonatomic,getter=getCreated) NSDate* Created;

@property (retain,nonatomic,getter=getCurrency) NSString* Currency;

@property (retain,nonatomic,getter=getCustNum) NSString* CustNum;

@property (retain,nonatomic,getter=getCustomData) NSString* CustomData;

@property (retain,nonatomic,getter=getCustomFields) USAePayFieldValueArray* CustomFields;

@property (retain,nonatomic,getter=getCustomerID) NSString* CustomerID;

@property (retain,nonatomic,getter=getDescription) NSString* Description;

@property (nonatomic,getter=getEnabled) BOOL Enabled;

@property (retain,nonatomic,getter=getFailures) NSNumber* Failures;

@property (retain,nonatomic,getter=getLookupCode) NSString* LookupCode;

@property (retain,nonatomic,getter=getModified) NSDate* Modified;

@property (retain,nonatomic,getter=getNext) NSString* Next;

@property (retain,nonatomic,getter=getNotes) NSString* Notes;

@property (retain,nonatomic,getter=getNumLeft) NSNumber* NumLeft;

@property (retain,nonatomic,getter=getOrderID) NSString* OrderID;

@property (retain,nonatomic,getter=getPaymentMethods) USAePayPaymentMethodArray* PaymentMethods;

@property (retain,nonatomic,getter=getPriceTier) NSString* PriceTier;

@property (retain,nonatomic,getter=getReceiptNote) NSString* ReceiptNote;

@property (retain,nonatomic,getter=getSchedule) NSString* Schedule;

@property (nonatomic,getter=getSendReceipt) BOOL SendReceipt;

@property (retain,nonatomic,getter=getSource) NSString* Source;

@property (retain,nonatomic,getter=getTax) NSNumber* Tax;

@property (retain,nonatomic,getter=getTaxClass) NSString* TaxClass;

@property (retain,nonatomic,getter=getUser) NSString* User;

@property (retain,nonatomic,getter=getURL) NSString* URL;

@property (retain,nonatomic,getter=getAny) NSMutableArray* any;
-(id)init;
-(id)initWithXml: (DDXMLElement*)__node __request:(USAePayRequestResultHandler*) __request;
+(USAePayCustomerObject*) createWithXml:(DDXMLElement*)__node __request:(USAePayRequestResultHandler*) __request;
-(void) serialize:(DDXMLElement*)__parent __request:(USAePayRequestResultHandler*) __request;
@end