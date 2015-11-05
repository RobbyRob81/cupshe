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



@interface USAePayFieldValue : NSObject <USAePayISerializableObject>


@property (retain,nonatomic,getter=getField) NSString* Field;

@property (retain,nonatomic,getter=getValue) NSString* Value;

@property (retain,nonatomic,getter=getAny) NSMutableArray* any;
-(id)init;
-(id)initWithXml: (DDXMLElement*)__node __request:(USAePayRequestResultHandler*) __request;
+(USAePayFieldValue*) createWithXml:(DDXMLElement*)__node __request:(USAePayRequestResultHandler*) __request;
-(void) serialize:(DDXMLElement*)__parent __request:(USAePayRequestResultHandler*) __request;
@end