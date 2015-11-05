//----------------------------------------------------
//
// Generated by www.easywsdl.com
// Version: 4.1.9.0
//
// Created by Quasar Development at 02-11-2015
//
//---------------------------------------------------


#import <Foundation/Foundation.h>

#import "USAePayRequestResultHandler.h"
#import "DDXML.h"



@interface USAePayLineItem : NSObject <USAePayISerializableObject>


@property (retain,nonatomic,getter=getProductRefNum) NSString* ProductRefNum;

@property (retain,nonatomic,getter=getSKU) NSString* SKU;

@property (retain,nonatomic,getter=getProductName) NSString* ProductName;

@property (retain,nonatomic,getter=getDescription) NSString* Description;

@property (retain,nonatomic,getter=getUnitPrice) NSString* UnitPrice;

@property (retain,nonatomic,getter=getQty) NSString* Qty;

@property (retain,nonatomic,getter=getTaxable) NSNumber* Taxable;

@property (retain,nonatomic,getter=getAny) NSMutableArray* any;
-(id)init;
-(id)initWithXml: (DDXMLElement*)__node __request:(USAePayRequestResultHandler*) __request;
+(USAePayLineItem*) createWithXml:(DDXMLElement*)__node __request:(USAePayRequestResultHandler*) __request;
-(void) serialize:(DDXMLElement*)__parent __request:(USAePayRequestResultHandler*) __request;
@end