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
#import "USAePayRequestResultHandler.h"
#import "DDXML.h"



@interface USAePayTransactionDetail : NSObject <USAePayISerializableObject>


@property (retain,nonatomic,getter=getAllowPartialAuth) NSNumber* AllowPartialAuth;

@property (retain,nonatomic,getter=getAmount) NSNumber* Amount;

@property (retain,nonatomic,getter=getClerk) NSString* Clerk;

@property (retain,nonatomic,getter=getCurrency) NSString* Currency;

@property (retain,nonatomic,getter=getDescription) NSString* Description;

@property (retain,nonatomic,getter=getComments) NSString* Comments;

@property (retain,nonatomic,getter=getDiscount) NSNumber* Discount;

@property (retain,nonatomic,getter=getInvoice) NSString* Invoice;

@property (retain,nonatomic,getter=getNonTax) NSNumber* NonTax;

@property (retain,nonatomic,getter=getOrderID) NSString* OrderID;

@property (retain,nonatomic,getter=getPONum) NSString* PONum;

@property (retain,nonatomic,getter=getShipping) NSNumber* Shipping;

@property (retain,nonatomic,getter=getSubtotal) NSNumber* Subtotal;

@property (retain,nonatomic,getter=getTable) NSString* Table;

@property (retain,nonatomic,getter=getTax) NSNumber* Tax;

@property (retain,nonatomic,getter=getTerminal) NSString* Terminal;

@property (retain,nonatomic,getter=getTip) NSNumber* Tip;

@property (retain,nonatomic,getter=getAny) NSMutableArray* any;
-(id)init;
-(id)initWithXml: (DDXMLElement*)__node __request:(USAePayRequestResultHandler*) __request;
+(USAePayTransactionDetail*) createWithXml:(DDXMLElement*)__node __request:(USAePayRequestResultHandler*) __request;
-(void) serialize:(DDXMLElement*)__parent __request:(USAePayRequestResultHandler*) __request;
@end