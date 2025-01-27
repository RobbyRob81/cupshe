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
@class USAePayTransactionObjectArray;
#import "USAePayRequestResultHandler.h"
#import "DDXML.h"



@interface USAePayTransactionSearchResult : NSObject <USAePayISerializableObject>


@property (retain,nonatomic,getter=getAuthOnlyAmount) NSNumber* AuthOnlyAmount;

@property (retain,nonatomic,getter=getAuthOnlyCount) NSNumber* AuthOnlyCount;

@property (retain,nonatomic,getter=getCreditsAmount) NSNumber* CreditsAmount;

@property (retain,nonatomic,getter=getCreditsCount) NSNumber* CreditsCount;

@property (retain,nonatomic,getter=getDeclinesAmount) NSNumber* DeclinesAmount;

@property (retain,nonatomic,getter=getDeclinesCount) NSNumber* DeclinesCount;

@property (retain,nonatomic,getter=getErrorsAmount) NSNumber* ErrorsAmount;

@property (retain,nonatomic,getter=getErrorsCount) NSNumber* ErrorsCount;

@property (retain,nonatomic,getter=getLimit) NSNumber* Limit;

@property (retain,nonatomic,getter=getSalesAmount) NSNumber* SalesAmount;

@property (retain,nonatomic,getter=getSalesCount) NSNumber* SalesCount;

@property (retain,nonatomic,getter=getStartIndex) NSNumber* StartIndex;

@property (retain,nonatomic,getter=getTransactions) USAePayTransactionObjectArray* Transactions;

@property (retain,nonatomic,getter=getTransactionsMatched) NSNumber* TransactionsMatched;

@property (retain,nonatomic,getter=getTransactionsReturned) NSNumber* TransactionsReturned;

@property (retain,nonatomic,getter=getVoidsAmount) NSNumber* VoidsAmount;

@property (retain,nonatomic,getter=getVoidsCount) NSNumber* VoidsCount;

@property (retain,nonatomic,getter=getAny) NSMutableArray* any;
-(id)init;
-(id)initWithXml: (DDXMLElement*)__node __request:(USAePayRequestResultHandler*) __request;
+(USAePayTransactionSearchResult*) createWithXml:(DDXMLElement*)__node __request:(USAePayRequestResultHandler*) __request;
-(void) serialize:(DDXMLElement*)__parent __request:(USAePayRequestResultHandler*) __request;
@end