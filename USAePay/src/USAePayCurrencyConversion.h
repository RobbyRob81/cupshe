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



@interface USAePayCurrencyConversion : NSObject <USAePayISerializableObject>


@property (retain,nonatomic,getter=getAmount) NSNumber* Amount;

@property (retain,nonatomic,getter=getCurrency) NSString* Currency;

@property (retain,nonatomic,getter=getFromAmount) NSNumber* FromAmount;

@property (retain,nonatomic,getter=getFromCurrency) NSString* FromCurrency;

@property (retain,nonatomic,getter=getRate) NSNumber* Rate;

@property (retain,nonatomic,getter=getAny) NSMutableArray* any;
-(id)init;
-(id)initWithXml: (DDXMLElement*)__node __request:(USAePayRequestResultHandler*) __request;
+(USAePayCurrencyConversion*) createWithXml:(DDXMLElement*)__node __request:(USAePayRequestResultHandler*) __request;
-(void) serialize:(DDXMLElement*)__parent __request:(USAePayRequestResultHandler*) __request;
@end