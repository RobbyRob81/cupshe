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



@interface USAePayTransactionResponse : NSObject <USAePayISerializableObject>


@property (retain,nonatomic,getter=getAcsUrl) NSString* AcsUrl;

@property (retain,nonatomic,getter=getAuthAmount) NSNumber* AuthAmount;

@property (retain,nonatomic,getter=getAuthCode) NSString* AuthCode;

@property (retain,nonatomic,getter=getAvsResult) NSString* AvsResult;

@property (retain,nonatomic,getter=getAvsResultCode) NSString* AvsResultCode;

@property (retain,nonatomic,getter=getBatchNum) NSNumber* BatchNum;

@property (retain,nonatomic,getter=getBatchRefNum) NSNumber* BatchRefNum;

@property (retain,nonatomic,getter=getCardCodeResult) NSString* CardCodeResult;

@property (retain,nonatomic,getter=getCardCodeResultCode) NSString* CardCodeResultCode;

@property (retain,nonatomic,getter=getCardLevelResult) NSString* CardLevelResult;

@property (retain,nonatomic,getter=getCardLevelResultCode) NSString* CardLevelResultCode;

@property (retain,nonatomic,getter=getConversionRate) NSNumber* ConversionRate;

@property (retain,nonatomic,getter=getConvertedAmount) NSNumber* ConvertedAmount;

@property (retain,nonatomic,getter=getConvertedAmountCurrency) NSString* ConvertedAmountCurrency;

@property (retain,nonatomic,getter=getCustNum) NSNumber* CustNum;

@property (retain,nonatomic,getter=getError) NSString* Error;

@property (retain,nonatomic,getter=getErrorCode) NSNumber* ErrorCode;

@property (nonatomic,getter=getIsDuplicate) BOOL isDuplicate;

@property (retain,nonatomic,getter=getPayload) NSString* Payload;

@property (retain,nonatomic,getter=getRefNum) NSNumber* RefNum;

@property (retain,nonatomic,getter=getRemainingBalance) NSNumber* RemainingBalance;

@property (retain,nonatomic,getter=getResult) NSString* Result;

@property (retain,nonatomic,getter=getResultCode) NSString* ResultCode;

@property (retain,nonatomic,getter=getStatus) NSString* Status;

@property (retain,nonatomic,getter=getStatusCode) NSString* StatusCode;

@property (retain,nonatomic,getter=getVpasResultCode) NSString* VpasResultCode;

@property (retain,nonatomic,getter=getAny) NSMutableArray* any;
-(id)init;
-(id)initWithXml: (DDXMLElement*)__node __request:(USAePayRequestResultHandler*) __request;
+(USAePayTransactionResponse*) createWithXml:(DDXMLElement*)__node __request:(USAePayRequestResultHandler*) __request;
-(void) serialize:(DDXMLElement*)__parent __request:(USAePayRequestResultHandler*) __request;
@end