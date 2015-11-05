//----------------------------------------------------
//
// Generated by www.easywsdl.com
// Version: 4.1.9.0
//
// Created by Quasar Development at 02-11-2015
//
//---------------------------------------------------


#import <Foundation/Foundation.h>

@class USAePayAddress;
@class USAePayCheckData;
@class USAePayCheckTrace;
@class USAePayCreditCardData;
@class USAePayFieldValueArray;
@class USAePayTransactionDetail;
@class USAePayLineItemArray;
@class USAePayTransactionResponse;
#import "USAePayRequestResultHandler.h"
#import "DDXML.h"



@interface USAePayTransactionObject : NSObject <USAePayISerializableObject>


@property (retain,nonatomic,getter=getAccountHolder) NSString* AccountHolder;

@property (retain,nonatomic,getter=getBillingAddress) USAePayAddress* BillingAddress;

@property (retain,nonatomic,getter=getCheckData) USAePayCheckData* CheckData;

@property (retain,nonatomic,getter=getCheckTrace) USAePayCheckTrace* CheckTrace;

@property (retain,nonatomic,getter=getClientIP) NSString* ClientIP;

@property (retain,nonatomic,getter=getCreditCardData) USAePayCreditCardData* CreditCardData;

@property (retain,nonatomic,getter=getCustomerID) NSString* CustomerID;

@property (retain,nonatomic,getter=getCustomFields) USAePayFieldValueArray* CustomFields;

@property (retain,nonatomic,getter=getDateTime) NSString* DateTime;

@property (retain,nonatomic,getter=getDetails) USAePayTransactionDetail* Details;

@property (retain,nonatomic,getter=getLineItems) USAePayLineItemArray* LineItems;

@property (retain,nonatomic,getter=getResponse) USAePayTransactionResponse* Response;

@property (retain,nonatomic,getter=getServerIP) NSString* ServerIP;

@property (retain,nonatomic,getter=getShippingAddress) USAePayAddress* ShippingAddress;

@property (retain,nonatomic,getter=getSource) NSString* Source;

@property (retain,nonatomic,getter=getStatus) NSString* Status;

@property (retain,nonatomic,getter=getTransactionType) NSString* TransactionType;

@property (retain,nonatomic,getter=getUser) NSString* User;

@property (retain,nonatomic,getter=getAny) NSMutableArray* any;
-(id)init;
-(id)initWithXml: (DDXMLElement*)__node __request:(USAePayRequestResultHandler*) __request;
+(USAePayTransactionObject*) createWithXml:(DDXMLElement*)__node __request:(USAePayRequestResultHandler*) __request;
-(void) serialize:(DDXMLElement*)__parent __request:(USAePayRequestResultHandler*) __request;
@end