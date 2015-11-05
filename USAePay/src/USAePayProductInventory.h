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



@interface USAePayProductInventory : NSObject <USAePayISerializableObject>


@property (retain,nonatomic,getter=getInventoryLocation) NSString* InventoryLocation;

@property (retain,nonatomic,getter=getQtyOnHand) NSString* QtyOnHand;

@property (retain,nonatomic,getter=getQtyOnOrder) NSString* QtyOnOrder;

@property (retain,nonatomic,getter=getDateAvailable) NSString* DateAvailable;

@property (retain,nonatomic,getter=getAny) NSMutableArray* any;
-(id)init;
-(id)initWithXml: (DDXMLElement*)__node __request:(USAePayRequestResultHandler*) __request;
+(USAePayProductInventory*) createWithXml:(DDXMLElement*)__node __request:(USAePayRequestResultHandler*) __request;
-(void) serialize:(DDXMLElement*)__parent __request:(USAePayRequestResultHandler*) __request;
@end