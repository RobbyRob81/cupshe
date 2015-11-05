//
//  NSString+GUID.h
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


/**
 * Category on NSString to support Global Unique Identifiers
 *
 * _NSString+GUID_ provides an Objective-C interface to Core Framework's UUID functions.
 * 
 * **From the Core Framework documentation:**
 *
 * UUIDs (Universally Unique Identifiers), also known as GUIDs (Globally Unique Identifiers) or IIDs (Interface Identifiers), 
 * are 128-bit values guaranteed to be unique. A UUID is made unique over both space and time by combining a value unique to the 
 * computer on which it was generated—usually the Ethernet hardware address—and a value representing the number of 100-nanosecond 
 * intervals since October 15, 1582 at 00:00:00.
 *
 * The standard format for UUIDs represented in ASCII is a string punctuated by hyphens, for example `68753A44-4D6F-1226-9C60-0050E4C00067`. 
 * The hex representation looks, as you might expect, like a list of numerical values preceded by `0x`. For example, `0xD7`, `0x36`, `0x95`,
 * `0x0A`, `0x4D`, `0x6E`, `0x12`, `0x26`, `0x80`, `0x3A`, `0x00`, `0x50`, `0xE4`, `0xC0`, `0x00`, `0x67`. 
 *
 * Because a UUID is expressed simply as an array of bytes, there are no endianness considerations for different platforms.
 *
 **/
#import <Foundation/Foundation.h>

@interface NSString (GUID)

/**
 * Create a string representation of the given GIUD
 *
 * Creates a string representation in the standard hypen-seperated-hex-values syntax for UUIDs.
 *
 * \param guidData 128-bit GUID (for instance, as generated by `[NSData+GUID]newGUID`
 * \returns NSString representation of the GUID or `nil` on conversin error
 **/
+(NSString *) stringWithGUID:(NSData *)guidData;

/**
 * Create a string representation of a new Globally Unique Identifier
 *
 * Calls Core Framework's `CFUUIDGetUUIDBytes()` function to generate a 128-bit Globally Unique Identifier
 * and then returns the string representation given by stringWithGUID:
 *
 * \return NSString instance containing a 128-bit GUID
 **/
+(NSString *) stringWithNewGUID;

@end
