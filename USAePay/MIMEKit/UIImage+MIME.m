//
//  UIImage+MIME.m
//
//  Created by Jeff Hay on 4/2/12.
//  Copyright (c) 2012 Portable Knowledge, LLC. All rights reserved.
//

#import "UIImage+MIME.h"
#import <UIKit/UIKit.h>
#import "PKMIMEData.h"
#import "PKMIMEMessage.h"

@implementation UIImage (MIME)

#pragma mark - Class Methods

+(UIImage *) imageWithMIMEData:(PKMIMEData *)imgData ignoreMediaType:(BOOL)force
{
    if (force || imgData.contentType.isImage)
    {
        UIImage *img = [UIImage imageWithData:imgData.data];
        return img;
    }
    
    return nil;
}

+(UIImage *) imageWithMIMEData:(PKMIMEData *)imgData
{
    return [self imageWithMIMEData:imgData ignoreMediaType:NO];
}

+(PKMIMEData *) MIMEDataForImageWithFilename:(NSString *)fileName
{
    NSString *format = nil;
    NSString *fileType = [[fileName pathExtension] lowercaseString];
    if ([fileType isEqualToString:@"png"])
        format = @"png";
    else if ([fileType isEqualToString:@"jpg"] || [fileType isEqualToString:@"jpeg"])
        format = @"jpeg";

    // If we don't know what file type this is, abort
    if (format == nil)
        return nil;
    
    PKMIMEData *imgData = [PKMIMEData dataFromData:[NSData dataWithContentsOfFile:fileName] andHeaders:nil];    
    imgData.contentType = [PKContentType contentTypeFromString:[NSString stringWithFormat:@"image/%@; name=%@", format, [fileName lastPathComponent]]];
    imgData.transferEncoding = MIMETransferEncodingStyleBase64;
    
    return imgData;
}

+(PKMIMEMessage *) MIMEMessageForImgeWithFileName:(NSString *)fileName
{
    PKMIMEData *imgData = [self MIMEDataForImageWithFilename:fileName];
    return [PKMIMEMessage messageWithData:imgData];
}

#pragma mark - Instance Methods

-(PKMIMEData *) pngMIMEdata
{
    PKMIMEData *imgData = [PKMIMEData dataFromData:UIImagePNGRepresentation(self) andHeaders:nil];
    imgData.contentType = [PKContentType contentTypeFromString:[NSString stringWithFormat:@"image/png"]];
    return imgData;
}

-(PKMIMEData *) jpgMIMEdataWithCompressionQuality:(CGFloat) compressionQuality
{
    PKMIMEData *imgData = [PKMIMEData dataFromData:UIImageJPEGRepresentation(self, compressionQuality) andHeaders:nil];
    imgData.contentType = [PKContentType contentTypeFromString:[NSString stringWithFormat:@"image/jpeg"]];
    return imgData;    
}

@end
