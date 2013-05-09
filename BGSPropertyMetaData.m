//
//  BGSPropertyMetaData.m
//  Lets Inventory
//
//  Created by Peter Todd on 02/04/2013.
//  Copyright (c) 2013 BrightGreenStar. All rights reserved.
//

#import "BGSPropertyMetaData.h"

@implementation BGSPropertyMetaData

#pragma mark NSCoding
// Implement NSCoding to encode/decode to a buffer of data
#define kVersionKey @"Version"

#define kInternalID @"PropertyDocID"
#define kPropertyRef @"PropertyRef"
#define kPropertyStatus @"PropertyStatus"
#define kThumbnailKey1 @"Photo1"
#define kThumbnailKey2 @"Photo2"
#define kThumbnailKey3 @"Photo3"
#define kThumbnailKey4 @"Photo4"
#define kThumbnailKey5 @"Photo5"
#define kThumbnailKey6 @"Photo6"




- (id)initWithThumbnail:(UIImage *)thumbnail {
    if ((self = [super init])) {
        self.thumbnail1 = thumbnail;
        //       self.clientFullName = @"TODO Client Name initWithThumbnail";
    }
    return self;
}

- (id)init {
    return [self initWithThumbnail:nil];
}



- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInt:1 forKey:kVersionKey];
    // Thumbnails
    NSData * thumbnailData1 = UIImagePNGRepresentation(self.thumbnail1);
    [encoder encodeObject:thumbnailData1 forKey:kThumbnailKey1];
    
    NSData * thumbnailData2 = UIImagePNGRepresentation(self.thumbnail2);
    [encoder encodeObject:thumbnailData2 forKey:kThumbnailKey2];
    
    NSData * thumbnailData3 = UIImagePNGRepresentation(self.thumbnail3);
    [encoder encodeObject:thumbnailData3 forKey:kThumbnailKey3];
    
    NSData * thumbnailData4 = UIImagePNGRepresentation(self.thumbnail4);
    [encoder encodeObject:thumbnailData4 forKey:kThumbnailKey4];
    
    NSData * thumbnailData5 = UIImagePNGRepresentation(self.thumbnail5);
    [encoder encodeObject:thumbnailData5 forKey:kThumbnailKey5];
    
    NSData * thumbnailData6 = UIImagePNGRepresentation(self.thumbnail6);
    [encoder encodeObject:thumbnailData6 forKey:kThumbnailKey6];
    

    NSData *propertyDocIDData = [self.propertyDocID
                               dataUsingEncoding:NSUTF8StringEncoding];
    [encoder encodeObject:propertyDocIDData forKey:kInternalID];
    
    NSData *propertyReferenceData = [self.propertyReference
                                 dataUsingEncoding:NSUTF8StringEncoding];
    [encoder encodeObject:propertyReferenceData forKey:kPropertyRef];
    
    NSData *propertyStatusData = [self.propertyStatus
                                     dataUsingEncoding:NSUTF8StringEncoding];
    [encoder encodeObject:propertyStatusData forKey:kPropertyStatus];
}

- (id)initWithCoder:(NSCoder *)decoder {
    [decoder decodeIntForKey:kVersionKey];
    NSData * thumbnailData1 = [decoder decodeObjectForKey:kThumbnailKey1];
    UIImage * thumbnail1 = [UIImage imageWithData:thumbnailData1];
    [self setThumbnail1:thumbnail1];
    
    NSData * thumbnailData2 = [decoder decodeObjectForKey:kThumbnailKey2];
    [self setThumbnail2:[UIImage imageWithData:thumbnailData2]];
    
    NSData * thumbnailData3 = [decoder decodeObjectForKey:kThumbnailKey3];
    [self setThumbnail3:[UIImage imageWithData:thumbnailData3]];
    
    NSData * thumbnailData4 = [decoder decodeObjectForKey:kThumbnailKey4];
    [self setThumbnail4:[UIImage imageWithData:thumbnailData4]];
    
    NSData * thumbnailData5 = [decoder decodeObjectForKey:kThumbnailKey5];
    [self setThumbnail5:[UIImage imageWithData:thumbnailData5]];
    
    NSData * thumbnailData6 = [decoder decodeObjectForKey:kThumbnailKey6];
    [self setThumbnail6:[UIImage imageWithData:thumbnailData6]];

    
    NSData *propertyDocIDData = [decoder decodeObjectForKey:kInternalID];
    NSString *decodedDocID = [[NSString alloc]
                                    initWithData:propertyDocIDData
                                    encoding:NSUTF8StringEncoding];
    [self setPropertyDocID:decodedDocID];
    
    NSData *propertyReferenceData = [decoder decodeObjectForKey:kPropertyRef];
    NSString *decodedPropertyReference = [[NSString alloc]
                              initWithData:propertyReferenceData
                              encoding:NSUTF8StringEncoding];
    [self setPropertyReference:decodedPropertyReference];
    
    NSData *propertyStatusData = [decoder decodeObjectForKey:kPropertyStatus];
    NSString *decodedPropertyStatusData = [[NSString alloc]
                                          initWithData:propertyStatusData
                                          encoding:NSUTF8StringEncoding];
    [self setPropertyStatus:decodedPropertyStatusData];

    
    return [self initWithThumbnail:thumbnail1];

    
}




@end
