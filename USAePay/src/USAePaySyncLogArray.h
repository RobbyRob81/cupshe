//----------------------------------------------------
//
// Generated by www.easywsdl.com
// Version: 4.1.9.0
//
// Created by Quasar Development at 02-11-2015
//
//---------------------------------------------------


#import <Foundation/Foundation.h>

@class USAePaySyncLog;
#import "USAePayRequestResultHandler.h"
#import "DDXML.h"



@interface USAePaySyncLogArray : NSObject < NSCopying, NSMutableCopying, NSCoding, NSFastEnumeration>
    
@property (nonatomic, retain) NSMutableArray* items;

-(id)init;
-(id) initWithXml: (DDXMLElement*)__node __request:(USAePayRequestResultHandler*) __request;
+(USAePaySyncLogArray*) createWithXml:(DDXMLElement*)__node __request:(USAePayRequestResultHandler*) __request;
-(void) serialize:(DDXMLElement*)__parent __request:(USAePayRequestResultHandler*) __request;

- (NSUInteger)count;
- (USAePaySyncLog*)objectAtIndex:(NSUInteger)index;

- (NSArray *)arrayByAddingObject:(USAePaySyncLog*)anObject;
- (NSArray *)arrayByAddingObjectsFromArray:(NSArray *)otherArray;
- (NSString *)componentsJoinedByString:(NSString *)separator;
- (BOOL)containsObject:(USAePaySyncLog*)anObject;
- (NSString *)description;
- (NSString *)descriptionWithLocale:(id)locale;
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level;
- (id)firstObjectCommonWithArray:(NSArray *)otherArray;
- (void)getObjects:(id __unsafe_unretained *)objects;
- (void)getObjects:(id __unsafe_unretained *)objects range:(NSRange)range;
- (NSUInteger)indexOfObject:(USAePaySyncLog*)anObject;
- (NSUInteger)indexOfObject:(USAePaySyncLog*)anObject inRange:(NSRange)range;
- (NSUInteger)indexOfObjectIdenticalTo:(USAePaySyncLog*)anObject;
- (NSUInteger)indexOfObjectIdenticalTo:(USAePaySyncLog*)anObject inRange:(NSRange)range;
- (BOOL)isEqualToArray:(NSArray *)otherArray;
- (USAePaySyncLog*)lastObject;
- (NSEnumerator *)objectEnumerator;
- (NSEnumerator *)reverseObjectEnumerator;
- (NSData *)sortedArrayHint;
- (NSArray *)sortedArrayUsingFunction:(NSInteger (*)(USAePaySyncLog*, USAePaySyncLog*, void *))comparator context:(void *)context;
- (NSArray *)sortedArrayUsingFunction:(NSInteger (*)(USAePaySyncLog*, USAePaySyncLog*, void *))comparator context:(void *)context hint:(NSData *)hint;
- (NSArray *)sortedArrayUsingSelector:(SEL)comparator;
- (NSArray *)subarrayWithRange:(NSRange)range;
- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile;
- (BOOL)writeToURL:(NSURL *)url atomically:(BOOL)atomically;

- (void)makeObjectsPerformSelector:(SEL)aSelector;
- (void)makeObjectsPerformSelector:(SEL)aSelector withObject:(id)argument;

- (NSArray *)objectsAtIndexes:(NSIndexSet *)indexes;

+ (id)array;
+ (id)arrayWithObject:(USAePaySyncLog*)anObject;
+ (id)arrayWithObjects:(const USAePaySyncLog* *)objects count:(NSUInteger)cnt;
+ (id)arrayWithObjects:(USAePaySyncLog*)firstObj, ... NS_REQUIRES_NIL_TERMINATION;
+ (id)arrayWithArray:(NSArray *)array;

- (id)initWithObjects:(const USAePaySyncLog* *)objects count:(NSUInteger)cnt;
- (id)initWithObjects:(USAePaySyncLog*)firstObj, ... NS_REQUIRES_NIL_TERMINATION;
- (id)initWithArray:(NSArray *)array;
- (id)initWithArray:(NSArray *)array copyItems:(BOOL)flag AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER;

+ (id)arrayWithContentsOfFile:(NSString *)path;
+ (id)arrayWithContentsOfURL:(NSURL *)url;
- (id)initWithContentsOfFile:(NSString *)path;
- (id)initWithContentsOfURL:(NSURL *)url;

- (void)addObject:(USAePaySyncLog*)anObject;
- (void)insertObject:(USAePaySyncLog*)anObject atIndex:(NSUInteger)index;
- (void)removeLastObject;
- (void)removeObjectAtIndex:(NSUInteger)index;
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(USAePaySyncLog*)anObject;

- (void)addObjectsFromArray:(NSArray *)otherArray;
- (void)exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2;
- (void)removeAllObjects;
- (void)removeObject:(USAePaySyncLog*)anObject inRange:(NSRange)range;
- (void)removeObject:(USAePaySyncLog*)anObject;
- (void)removeObjectIdenticalTo:(id)anObject inRange:(NSRange)range;
- (void)removeObjectIdenticalTo:(id)anObject;
- (void)removeObjectsInArray:(NSArray *)otherArray;
- (void)removeObjectsInRange:(NSRange)range;
- (void)replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray *)otherArray range:(NSRange)otherRange;
- (void)replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray *)otherArray;
- (void)setArray:(NSArray *)otherArray;
- (void)sortUsingFunction:(NSInteger (*)(USAePaySyncLog*, USAePaySyncLog*, void *))compare context:(void *)context;
- (void)sortUsingSelector:(SEL)comparator;

- (void)insertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexes;
- (void)removeObjectsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectsAtIndexes:(NSIndexSet *)indexes withObjects:(NSArray *)objects;

+ (id)arrayWithCapacity:(NSUInteger)numItems;
- (id)initWithCapacity:(NSUInteger)numItems;

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained *)stackbuf count:(NSUInteger)len;

- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;

- (id)copyWithZone:(NSZone *)zone;
- (id)mutableCopyWithZone:(NSZone *)zone;
	
@end