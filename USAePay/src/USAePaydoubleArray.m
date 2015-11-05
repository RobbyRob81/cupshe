//----------------------------------------------------
//
// Generated by www.easywsdl.com
// Version: 4.1.9.0
//
// Created by Quasar Development at 02-11-2015
//
//---------------------------------------------------


#import "USAePayHelper.h"
#import "USAePaydoubleArray.h"


@implementation USAePaydoubleArray

@synthesize items;

+ (USAePaydoubleArray *)createWithXml:(DDXMLElement *)__node __request:(USAePayRequestResultHandler*) __request
{
    if(__node == nil) { return nil; }
    return [[self alloc] initWithXml: __node __request:__request];
}

-(id)init {
    if ((self=[super init])) {
        self.items = [NSMutableArray array];
    }
    return self;
}

- (id) initWithXml: (DDXMLElement*) __node __request:(USAePayRequestResultHandler*) __request {
    if(self = [self init])
    {
        NSArray* tempItems = [__node children];
        for(DDXMLElement* child in tempItems)
        {
            [self.items addObject:[USAePayHelper getNumber:[child stringValue]]];
        }

    }
    return self;
}

-(void) serialize:(DDXMLElement*)__parent __request:(USAePayRequestResultHandler*) __request
{
    for (NSNumber* item in self.items) {
        DDXMLElement* propertyElement=[__request writeElement:item type:[NSNumber class] name:@"double" URI:@"http://www.w3.org/2001/XMLSchema" parent:__parent skipNullProperty:NO];
        if(propertyElement!=nil)
        {
            [propertyElement setStringValue:[item stringValue]];
        }
    }
    [__request addAttribute:@"type" URI:@"http://www.w3.org/2001/XMLSchema" stringValue:@"xx2:doubleArray" element:__parent];
    [__request addAttribute:@"arrayType" URI:@"http://schemas.xmlsoap.org/soap/encoding/" stringValue:@"xx1:double[]" element:__parent];
    [__request addAttribute:@"xmlns:xx1" URI:@"" stringValue:@"http://www.w3.org/2001/XMLSchema" element:__parent];
    [__request addAttribute:@"xmlns:xx2" URI:@"" stringValue:@"urn:usaepay" element:__parent];
}

- (id) object {
	return self.items;
}

- (NSUInteger)count {
	return [self.items count];
}

- (NSNumber*)objectAtIndex:(NSUInteger)index {
	return [self.items objectAtIndex:index];
}

- (NSArray *)arrayByAddingObject:(NSNumber*)anObject {
	return [self.items arrayByAddingObject:anObject];
}
- (NSArray *)arrayByAddingObjectsFromArray:(NSArray *)otherArray {
	return [self.items arrayByAddingObjectsFromArray:otherArray];
}
- (NSString *)componentsJoinedByString:(NSString *)separator {
	return [self.items componentsJoinedByString: separator]; 
}
- (BOOL)containsObject:(NSNumber*)anObject {
	return [self.items containsObject:anObject];
}

- (NSString *)description {
	return [self.items description];
}

- (NSString *)descriptionWithLocale:(id)locale {
	return [self.items descriptionWithLocale:locale];
}

- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level {
	return [self.items descriptionWithLocale:locale indent:level];
}

- (id)firstObjectCommonWithArray:(NSArray *)otherArray {
	return [self.items firstObjectCommonWithArray:otherArray];
}

- (void)getObjects:(id __unsafe_unretained *)objects {
	return [self.items getObjects:objects];
}

- (void)getObjects:(id __unsafe_unretained *)objects range:(NSRange)range {
	return [self.items getObjects:objects range:range];
}

- (NSUInteger)indexOfObject:(NSNumber*)anObject {
	return [self.items indexOfObject:anObject];
}

- (NSUInteger)indexOfObject:(NSNumber*)anObject inRange:(NSRange)range {
	return [self.items indexOfObject:anObject inRange:range];
}

- (NSUInteger)indexOfObjectIdenticalTo:(NSNumber*)anObject {
	return [self.items indexOfObjectIdenticalTo:anObject];
}

- (NSUInteger)indexOfObjectIdenticalTo:(NSNumber*)anObject inRange:(NSRange)range {
	return [self.items indexOfObjectIdenticalTo:anObject inRange:range];
}

- (BOOL)isEqualToArray:(NSArray *)otherArray {
	return [self.items isEqualToArray:otherArray];
}

- (NSNumber*)lastObject {
	return [self.items lastObject];
}

- (NSEnumerator *)objectEnumerator {
	return [self.items objectEnumerator];
}

- (NSEnumerator *)reverseObjectEnumerator {
	return [self.items reverseObjectEnumerator];
}

- (NSData *)sortedArrayHint {
	return [self.items sortedArrayHint];
}

- (NSArray *)sortedArrayUsingSelector:(SEL)comparator {
	return [self.items sortedArrayUsingSelector:comparator];
}

- (NSArray *)subarrayWithRange:(NSRange)range {
	return [self.items subarrayWithRange:range];
}

- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile{
	return [self.items writeToFile:path atomically:useAuxiliaryFile];
}

- (BOOL)writeToURL:(NSURL *)url atomically:(BOOL)atomically {
	return [self.items writeToURL:url atomically:atomically];
}

- (void)makeObjectsPerformSelector:(SEL)aSelector {
	return [self.items makeObjectsPerformSelector:aSelector];
}

- (void)makeObjectsPerformSelector:(SEL)aSelector withObject:(id)argument {
	return [self.items makeObjectsPerformSelector:aSelector withObject:argument];
}

- (NSArray *)objectsAtIndexes:(NSIndexSet *)indexes {
	return [self.items objectsAtIndexes:indexes];
}

- (void)addObject:(NSNumber*)anObject {
	return [self.items addObject:anObject];
}

- (void)insertObject:(NSNumber*)anObject atIndex:(NSUInteger)index {
	return [self.items insertObject:anObject atIndex:index];
}

- (void)removeLastObject {
	return [self.items removeLastObject];
}

- (void)removeObjectAtIndex:(NSUInteger)index {
	return [self.items removeObjectAtIndex:index];
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(NSNumber*)anObject {
	return [self.items replaceObjectAtIndex:index withObject:anObject];
}

- (void)addObjectsFromArray:(NSArray *)otherArray {
	return [self.items addObjectsFromArray:otherArray];
}

- (void)exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2 {
	return [self.items exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
}

- (void)removeAllObjects {
	return [self.items removeAllObjects];
}

- (void)removeObject:(NSNumber*)anObject inRange:(NSRange)range {
	return [self.items removeObject:anObject inRange:range];
}

- (void)removeObject:(NSNumber*)anObject {
	return [self.items removeObject:anObject];
}

- (void)removeObjectIdenticalTo:(NSNumber*)anObject inRange:(NSRange)range {
	return [self.items removeObjectIdenticalTo:anObject inRange:range];
}

- (void)removeObjectIdenticalTo:(NSNumber*)anObject {
	return [self.items removeObjectIdenticalTo:anObject];
}

- (void)removeObjectsInArray:(NSArray *)otherArray {
	return [self.items removeObjectsInArray:otherArray];
}

- (void)removeObjectsInRange:(NSRange)range {
	return [self.items removeObjectsInRange:range];
}

- (void)replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray *)otherArray range:(NSRange)otherRange {
	return [self.items replaceObjectsInRange:range withObjectsFromArray:otherArray range:otherRange];
}

- (void)replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray *)otherArray {
	return [self.items replaceObjectsInRange:range withObjectsFromArray:otherArray];
}

- (void)setArray:(NSArray *)otherArray {
	return [self.items setArray:otherArray];
}

- (void)sortUsingSelector:(SEL)comparator {
	return [self.items sortUsingSelector:comparator];
}

- (void)insertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexes {
	return [self.items insertObjects:objects atIndexes:indexes];
}

- (void)removeObjectsAtIndexes:(NSIndexSet *)indexes {
	return [self.items removeObjectsAtIndexes:indexes];
}

- (void)replaceObjectsAtIndexes:(NSIndexSet *)indexes withObjects:(NSArray *)objects {
	return [self.items replaceObjectsAtIndexes:indexes withObjects:objects];
}

- (id)initWithCapacity:(NSUInteger)numItems {
	self = [self init];
	if(self) {
		self.items = [[NSMutableArray alloc] initWithCapacity:numItems];
	}
	return self;
}

+ (id)array {
	return [[ USAePaydoubleArray alloc] init];
}

+ (id)arrayWithObject:(NSNumber*)anObject {
	return [[ USAePaydoubleArray alloc] initWithObjects:anObject, nil];
}

+ (id)arrayWithObjects:(const NSNumber* *)objects count:(NSUInteger)cnt {
	return [[ USAePaydoubleArray alloc] initWithObjects:objects count:cnt];
}

+ (id)arrayWithObjects:(NSNumber*)firstObj, ... {
	USAePaydoubleArray* a = [ USAePaydoubleArray array];
	id eachObject;
	va_list argumentList;
	if (firstObj) {
		[a.items addObject: firstObj];
		va_start(argumentList, firstObj);
		while ((eachObject = va_arg(argumentList, id))) {
			[a.items addObject: eachObject];
		}
		va_end(argumentList);
	}
	return a;
}

- (id)initWithObjects:(NSNumber*)firstObj, ... {
	if(self = [self init]) {
		id eachObject;
		va_list argumentList;
		if (firstObj) {
			[self.items addObject: firstObj];
			va_start(argumentList, firstObj);
			while ((eachObject = va_arg(argumentList, id))) {
				[self.items addObject: eachObject];
			}
			va_end(argumentList);
		}
	}
	return self;
}

+ (id)arrayWithArray:(NSArray *)array {
	return [[ USAePaydoubleArray alloc] initWithArray:array];
}

+ (id)arrayWithContentsOfFile:(NSString *)path {
	return [[ USAePaydoubleArray alloc] initWithContentsOfFile:path];
}

+ (id)arrayWithContentsOfURL:(NSURL *)url {
	return [[ USAePaydoubleArray alloc] initWithContentsOfURL:url];
}

+ (id)arrayWithCapacity:(NSUInteger)numItems {
	return [[ USAePaydoubleArray alloc] initWithCapacity:numItems];
}

- (id)initWithObjects:(const NSNumber* *)objects count:(NSUInteger)cnt {
	self = [self init];
	if(self) {
		self.items = [[NSMutableArray alloc] initWithObjects:objects count:cnt];
	}
	return self;
}

- (id)initWithArray:(NSArray *)array {
	self = [self init];
	if(self) {
		self.items = [[NSMutableArray alloc] initWithArray:array];
	}
	return self;
}

- (id)initWithArray:(NSArray *)array copyItems:(BOOL)flag {
	self = [self init];
	if(self) {
		self.items = [[NSMutableArray alloc] initWithArray:array copyItems:flag];
	}
	return self;
}

- (id)initWithContentsOfFile:(NSString *)path {
	self = [self init];
	if(self) {
		self.items = [[NSMutableArray alloc] initWithContentsOfFile:path];
	}
	return self;
}

- (id)initWithContentsOfURL:(NSURL *)url {
	self = [self init];
	if(self) {
		self.items = [[NSMutableArray alloc] initWithContentsOfURL:url];
	}
	return self;
}

- (NSArray *)sortedArrayUsingFunction:(NSInteger (*)(NSNumber*, NSNumber*, void *))comparator context:(void *)context {
	return [self.items sortedArrayUsingFunction:comparator context:context];
}

- (NSArray *)sortedArrayUsingFunction:(NSInteger (*)(NSNumber*, NSNumber*, void *))comparator context:(void *)context hint:(NSData *)hint {
	return [self.items sortedArrayUsingFunction:comparator context:context hint:hint];
}

- (void)sortUsingFunction:(NSInteger (*)(NSNumber*, NSNumber*, void *))compare context:(void *)context {
	return [self.items sortUsingFunction:compare context:context];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained *)stackbuf count:(NSUInteger)len {
	return [self.items countByEnumeratingWithState:state objects:stackbuf count:len];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[self.items encodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [self init];
	if(self) {
		self.items = [[NSMutableArray alloc] initWithCoder:aDecoder];
	}
	return self;
}

- (id)copyWithZone:(NSZone *)zone {
	return [self.items copyWithZone:zone];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
	return [self.items mutableCopyWithZone:zone];
}
@end
