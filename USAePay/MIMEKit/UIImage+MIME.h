//
//  UIImage+MIME.h
//
//  Created by Jeff Hay on 4/2/12.
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

#if (TARGET_IPHONE_SIMULATOR) || (TARGET_OS_IPHONE)
#import <UIKit/UIKit.h>
#import "PKMIMEMessage.h"

/**
 * Category that adds MIME PNG and JPEG support to the UIImage class
 *
 **/
@interface UIImage (MIME)

/** @name Class Methods */

/**
 * Crete a UIImage from the given MIME data
 *
 * Attempts to create a UIImage from the given MIME data.  If _imgData_ has a media type of `image/`, decodes the MIME data and attempts to
 * interpret it as an image; otherwise returns `nil`.
 *
 * Can parse all image formats recognized by [UIImage imageWithData:].  Returns `nil` on any parsing error.
 * 
 * \sa [UIImage imageWithData]
 * \sa imageWithMIMEData:ignoreMediaType:
 * \returns Image decoded from the MIME data, or `nil`
 **/
+(UIImage *) imageWithMIMEData:(PKMIMEData *)imgData;

/**
 * Crete a UIImage from the given MIME data, optionally ignoring the MIME media type
 *
 * Attempts to create a UIImage from the given MIME data.  If _imgData_ has a media type of `image/`, or if _ignoreMediaType_ is YES,
 * decodes the MIME data and attempts to interpret it as an image; otherwise returns `nil`.
 *
 * Can parse all image formats recognized by [UIImage imageWithData:].  Returns `nil` on any parsing error.
 *
 * \sa [UIImage imageWithData]
 * \sa imageWithMIMEData:
 * \returns Image decoded from the MIME data, or `nil`
 **/
+(UIImage *) imageWithMIMEData:(PKMIMEData *)imgData ignoreMediaType:(BOOL)force;

/**
 * Create a MIME data object for the given image file
 *
 * Attempts to create a MIME representation of the given image file:
 *
 * - If _fileName_ ends in `.png`, attempts to read the file and encode it in a MIME data stream with a contentType of `image/png`.  
 *
 * - If _fileName_ ends in `.jpg` or `.jpeg`, attemtps to read the file and encode it in a MIME data stream with a contentType of `image/jpeg` 
 * (and a compression quality of 1.0).  
 *
 * In all cases, if the MIME data is successfully created, a `name` parameter is added to the `contentType` indicating the original filename (minus
 * any path information).  The MIME data's `transferEncoding` is set to `MIMETransferEncodingBase64`.
 *
 * \return MIME data representation of the image file, or `nil`
 **/
+(PKMIMEData *) MIMEDataForImageWithFilename:(NSString *)fileName;

/**
 * Create a MIME message for the given image file
 *
 * Makes a full MIME message from the result of `[UIImage MIMEDataForImageWithFilename:fileName]`.
 *
 * \return MIME message containing the image file, or `nil`
 **/
+(PKMIMEMessage *) MIMEMessageForImgeWithFileName:(NSString *)fileName;

/** @name Instance Methods */

/**
 * Retreive MIME data for the PNG representation of the receiver
 *
 * Converts the receiver to a PNG image and creates a MIME data object with a media type of `image/png` from the resulting byte stream.
 *
 * \returns A valid MIME data object representation of the receiver
 **/
-(PKMIMEData *) pngMIMEdata;

/**
 * Retreive MIME data for the JPEG representation of the receiver
 *
 * Converts the receiver to a JPEG image with the specified _compressionQuality_ and creates a MIME data object with a media 
 * type of `image/jpeg` from the resulting byte stream.
 *
 * \returns A valid MIME data object representation of the receiver
 **/
-(PKMIMEData *) jpgMIMEdataWithCompressionQuality:(CGFloat) compressionQuality;

@end
#endif
