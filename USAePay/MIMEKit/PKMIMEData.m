//
//  PKMIMEData.m
//
//  Created by Jeff Hay on 3/27/12.
//  Copyright (c) 2012 Portable Knowledge, LLC. All rights reserved.
//
// Portable Knowledge Open Source Component License - Version 1.0 - April 13th, 2012
// 
// Permission is hereby granted, free of charge, to any person or organization`
// obtaining a copy of the software and accompanying documentation covered by
// this license (the "Software") to use, reproduce, display, distribute,
// execute, and transmit the Software, and to prepare derivative works of the
// Software, and to permit third-parties to whom the Software is furnished to
// do so, all subject to the following:
// 
// The copyright notices in the Software and this entire statement, including
// the above license grant, this restriction and the following disclaimer,
// must be included in all copies of the Software, in whole or in part, and
// all derivative works of the Software, unless such copies or derivative
// works are solely in the form of machine-executable object code generated by
// a source language processor.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
// SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
// FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
// ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.  IN NO CASE DOES THE USE OF THIS SOFTWARE EXPRESS
// OR IMPLY ANY PARTNERSHIP OR COOPERATION WITH THE AUTHORS OR COPYRIGHT HOLDERS
// OF THIS SOFTWARE.


#import "PKMIMEData.h"

#import "PKContentType.h"
#import "NSDictionary+CaseInsensitiveKeys.h"

@implementation PKMIMEData

@synthesize transferEncoding = _transferEncoding;
@synthesize contentType = _contentType;
@synthesize headers = _headers;
@dynamic contentID;

#pragma mark - Lifecycle

-(id) init
{
    if ((self = [super init]) != nil)
    {
        _data = nil;
        _contentID = nil;
        _transferEncoding = MIMETransferEncodingStyleBinary;
        _contentType = [[PKContentType alloc] init];
        _headers = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    return self;
}

-(id) initWithData:(NSData *)data format:(NSStringEncoding)dataEncoding transferEncoding:(MIMETransferEncodingStyle)transferEncoding contentID:(NSString *)contentID
{
    if ((self = [self init]) != nil)
    {
        _data = [[NSData alloc] initWithData:[data decodeFromStyle:transferEncoding]];
        _transferEncoding = transferEncoding;
        _contentType.charSetEncoding = dataEncoding;
        self.contentID = contentID;
    }
    return self;    
}

-(id) initWithData:(NSData *)data format:(NSStringEncoding)dataEncoding transferEncoding:(MIMETransferEncodingStyle)transferEncoding
{
    return [self initWithData:data format:dataEncoding transferEncoding:transferEncoding contentID:nil];
}

-(id) initWithData:(NSData *)data transferEncoding:(MIMETransferEncodingStyle)transferEncoding
{
    return [self initWithData:data format:NSUTF8StringEncoding transferEncoding:transferEncoding contentID:nil];
}

-(id) initWithData:(NSData *)data format:(NSStringEncoding)dataEncoding contentID:(NSString *)contentID
{
    return [self initWithData:data format:dataEncoding transferEncoding:MIMETransferEncodingStyleBinary contentID:contentID];
}

-(id) initWithData:(NSData *)data format:(NSStringEncoding)dataEncoding
{
    return [self initWithData:data format:dataEncoding transferEncoding:MIMETransferEncodingStyleBinary contentID:nil];
}

-(id) initWithData:(NSData *)data contentID:(NSString *)contentID
{
    return [self initWithData:data format:NSUTF8StringEncoding transferEncoding:MIMETransferEncodingStyleBinary contentID:contentID];    
}

-(id) initWithData:(NSData *)data
{
    return [self initWithData:data format:NSUTF8StringEncoding transferEncoding:MIMETransferEncodingStyleBinary contentID:nil];
}

-(id) initWithString:(NSString *)string usingEncoding:(MIMETransferEncodingStyle)encoding withContentID:(NSString *)contentID
{
    return [self initWithData:[string dataUsingEncoding:NSUTF8StringEncoding] format:NSUTF8StringEncoding transferEncoding:encoding contentID:contentID];
}

-(id) initWithString:(NSString *)string usingEncoding:(MIMETransferEncodingStyle)encoding
{
    return [self initWithData:[string dataUsingEncoding:NSUTF8StringEncoding] format:NSUTF8StringEncoding transferEncoding:encoding contentID:nil];
}

-(id) initWithString:(NSString *)string
{
    return [self initWithData:[string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES] 
                       format:NSUTF8StringEncoding transferEncoding:MIMETransferEncodingStyleBinary contentID:nil];
}

+(PKMIMEData *) dataWithHeaders:(NSDictionary *)headers
{
    PKMIMEData *mimeData = [[PKMIMEData alloc] init];
    [mimeData setHeadersFromDictionary:headers];
    return mimeData;    
}

+(PKMIMEData *) dataFromData:(NSData *)data andHeaders:(NSDictionary *)headers
{
    PKMIMEData *mimeData = [[PKMIMEData alloc] init];
    [mimeData setHeadersFromDictionary:headers];
    [mimeData setData:data];
    return mimeData;
}

+(PKMIMEData *) dataFromData:(NSData *)data withContentType:(PKContentType *)contentType
{
    PKMIMEData *mimeData = [[PKMIMEData alloc] init];
    mimeData.contentType = contentType;
    [mimeData setData:data];
    
    return mimeData;
    
}

+(PKMIMEData *) dataFromData:(NSData *)data withContentType:(PKContentType *)contentType andContentID:(NSString *)contentID
{
    PKMIMEData *mimeData = [self dataFromData:data withContentType:contentType];
    mimeData.contentID = contentID;
    return mimeData;
}

+(NSMutableDictionary *) headersFromStrings:(NSString *)headerString
{
    NSArray *headerLines = [headerString componentsSeparatedByString:@"\r\n"];
    NSMutableDictionary *headers = [[NSMutableDictionary alloc] initWithCapacity:headerLines.count];
    for (NSString *header in headerLines)
    {
        NSString *name =header;
        NSString *val =  nil;
        NSRange range=  [header rangeOfString:@":"];
        if(range.location!=NSNotFound)
        {
            name = [[header substringToIndex:range.location] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            val = [[header substringFromIndex:range.location+1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
        
        [headers setValue:val forKey:name];
    }
    return headers;
}

+(PKMIMEData *) dataFromStringWithHeaders:(NSString *)dataString
{
    // Find the null line that seperates the headers from the data
    NSRange Seperator = [dataString rangeOfString:@"\r\n\r\n"];
    
    NSData *data = nil;
    NSDictionary *headers = nil;
    if (Seperator.location == NSNotFound)
    {
        data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    }
    else
    {
        // Seperate Headers and Data
        data = [[dataString substringFromIndex:(Seperator.location + Seperator.length)] dataUsingEncoding:NSUTF8StringEncoding];
        headers = [PKMIMEData headersFromStrings:[dataString substringToIndex:Seperator.location]];
    }
    
    return [self dataFromData:data andHeaders:headers];
}


#pragma mark - Accessors

-(NSString *) contentID
{
    return _contentID;
}

-(void) setContentID:(NSString *)contentID
{
    if ([contentID hasPrefix:@"<"] && [contentID hasSuffix:@">"])
    {
        NSRange idRange;
        idRange.location = 1;
        idRange.length = contentID.length - 2;
        _contentID = [[contentID substringWithRange:idRange] copy];
    }
    else
        _contentID = [contentID copy];
}

-(void) setHeadersFromDictionary:(NSDictionary *)headers
{
    [self clearHeaders];
    
    id ContentType = [headers valueForCaseInsensitiveKey:@"Content-Type"];
    if ((ContentType != nil) && ([ContentType isKindOfClass:[NSString class]]))
    {
        _contentType = [[PKContentType alloc] initWithString:ContentType];
    }
    
    id ContentID = [headers valueForCaseInsensitiveKey:@"Content-ID"];
    if ((ContentID != nil) && ([ContentType isKindOfClass:[NSString class]]))
    {
        if([ContentID hasPrefix:@"<"])
        {
            
            ContentID=[ContentID substringWithRange:NSMakeRange(1, [ContentID length]-2)];
        }
        self.contentID = ContentID;
    }
    
    id ContentTransferEncoding = [headers valueForCaseInsensitiveKey:@"Content-Transfer-Encoding"];
    if ((ContentTransferEncoding != nil) && ([ContentTransferEncoding isKindOfClass:[NSString class]]))
        self.transferEncoding = [NSData transferEncodingStyleFromString:ContentTransferEncoding];
    
    [self addHeaders:headers];
}

-(void) addHeaders:(NSDictionary *)headers
{
    for (id key in headers.allKeys)
    {
        id val = [headers objectForKey:key];
        if ([key isKindOfClass:[NSString class]] && [val isKindOfClass:[NSString class]])
            [_headers setValue:val forKey:[key lowercaseString]];
    }
}

-(NSString *) headerWithName:(NSString *)name
{
    id val = [_headers valueForCaseInsensitiveKey:name];
    if ([val isKindOfClass:[NSString class]])
        return val;
    else return nil;
}

-(void) removeHeaderWithName:(NSString *)name
{
    [_headers removeObjectForKeyCaseInsensitiveKey:name];
}

-(void) clearHeaders
{
    [_headers removeAllObjects];
}

-(NSString *) headerStringsWithNewlineSequence:(NSString *)newLine
{
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:3];
    
    // Add in our caculated header values
    [string appendFormat:@"Content-Type: %@%@", _contentType.string, newLine];
    if ([_data length] > 0)
        [string appendFormat:@"Content-Length: %lu%@", (unsigned long)[self.data length], newLine];
    if ([_contentID length] > 0)
        [string appendFormat:@"Content-ID: <%@>%@", _contentID, newLine];
    if (_transferEncoding != MIMETransferEncodingStyleOther)
        [string appendFormat:@"Content-Transfer-Encoding: %@%@", [NSData stringForTransferEncodingStyle:_transferEncoding], newLine];
    
    // Remove calculated headers from our custom header list, if they are present
    // (we remove them here rather than in addHeaders: because they could be added externally via the headers property)
    [self removeHeaderWithName:@"Content-Type"];
    [self removeHeaderWithName:@"Content-Length"];
    if ([_contentID length] > 0)
        [self removeHeaderWithName:@"Content-ID"];
    if (_transferEncoding != MIMETransferEncodingStyleOther)
        [self removeHeaderWithName:@"Content-Transfer-Encoding"];
    
    // Add custom headers
    for (id key in _headers.allKeys)
    {
        id val = [_headers objectForKey:key];
        if ([key isKindOfClass:[NSString class]] && [val isKindOfClass:[NSString class]])
            [string appendFormat:@"%@: %@%@", key, val, newLine];
    }
    
    // Return MIME headers
    return [NSString stringWithString:string];
}

-(NSString *) headerStrings
{
    return [self headerStringsWithNewlineSequence:@"\r\n"];
}

-(NSString *) headerStringsForDisplay
{
    return [self headerStringsWithNewlineSequence:@"\n"];    
}

#pragma mark - Data Handling

-(NSData *) data
{
    return [_data encodeToStyle:_transferEncoding];
}

-(NSData *) rawData
{
    return _data;
}

-(void) setData:(NSData *)data format:(NSStringEncoding)format transferEncoding:(MIMETransferEncodingStyle)encoding
{
    _data = [[data decodeFromStyle:encoding] copy];
    _transferEncoding = encoding;
    _contentType.charSetEncoding = format;
    return;
}

-(void) setData:(NSData *)data
{
    [self setData:data format:_contentType.charSetEncoding transferEncoding:_transferEncoding];
}

-(NSString *) dataString
{
    NSData *data = self.data;
	return [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:_contentType.charSetEncoding];
}

-(NSString *) rawDataString
{
    NSData *data = self.rawData;
	return [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:_contentType.charSetEncoding];
}

@end
