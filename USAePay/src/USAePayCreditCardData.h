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



@interface USAePayCreditCardData : NSObject <USAePayISerializableObject>


@property (retain,nonatomic,getter=getAvsStreet) NSString* AvsStreet;

@property (retain,nonatomic,getter=getAvsZip) NSString* AvsZip;

@property (retain,nonatomic,getter=getCardCode) NSString* CardCode;

@property (retain,nonatomic,getter=getCardExpiration) NSString* CardExpiration;

@property (retain,nonatomic,getter=getCardNumber) NSString* CardNumber;

@property (retain,nonatomic,getter=getCardPresent) NSNumber* CardPresent;

@property (retain,nonatomic,getter=getCardType) NSString* CardType;

@property (retain,nonatomic,getter=getCAVV) NSString* CAVV;

@property (retain,nonatomic,getter=getDUKPT) NSString* DUKPT;

@property (retain,nonatomic,getter=getECI) NSNumber* ECI;

@property (retain,nonatomic,getter=getInternalCardAuth) NSNumber* InternalCardAuth;

@property (retain,nonatomic,getter=getMagStripe) NSString* MagStripe;

@property (retain,nonatomic,getter=getMagSupport) NSString* MagSupport;

@property (retain,nonatomic,getter=getPares) NSString* Pares;

@property (retain,nonatomic,getter=getSignature) NSString* Signature;

@property (retain,nonatomic,getter=getTermType) NSString* TermType;

@property (retain,nonatomic,getter=getXID) NSString* XID;

@property (retain,nonatomic,getter=getAny) NSMutableArray* any;
-(id)init;
-(id)initWithXml: (DDXMLElement*)__node __request:(USAePayRequestResultHandler*) __request;
+(USAePayCreditCardData*) createWithXml:(DDXMLElement*)__node __request:(USAePayRequestResultHandler*) __request;
-(void) serialize:(DDXMLElement*)__parent __request:(USAePayRequestResultHandler*) __request;
@end