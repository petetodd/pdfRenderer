//
//  BGSInventoryMetaData.m
//  Lets Inventory
//
//  Created by Peter Todd on 11/04/2013.
//  Copyright (c) 2013 BrightGreenStar. All rights reserved.
//

#import "BGSInventoryMetaData.h"

@implementation BGSInventoryMetaData

#pragma mark NSCoding
// Implement NSCoding to encode/decode to a buffer of data
#define kVersionKey @"Version"
#define kInternalID @"inventoryDocID"
#define kInventoryRef @"InventoryRef"
#define kPropertyRef @"PropertyDocID"
#define kPropertyName @"PropertyRef"

#define kThumbnailKey1 @"Photo1"


#define kInventoryType @"InventoryType"

#define kInventorystatus @"InventoryStatus"

#define kInventoryDueDate @"InventoryDueDate"
#define kInventoryScheduledDate @"InventoryScheduledDate"
#define kInventoryCompletedDate @"InventoryCompletedDate"


- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInt:1 forKey:kVersionKey];
    // Encode  as NSData
    //
    NSData * thumbnailData1 = UIImagePNGRepresentation(self.thumbnail1);
    [encoder encodeObject:thumbnailData1 forKey:kThumbnailKey1];
    
    
    NSData *internalIdData = [self.inventoryDocID
                              dataUsingEncoding:NSUTF8StringEncoding];
    [encoder encodeObject:internalIdData forKey:kInternalID];
    
    NSData *propertyIdData = [self.propertyDocID
                              dataUsingEncoding:NSUTF8StringEncoding];
    [encoder encodeObject:propertyIdData forKey:kPropertyRef];
    
    NSData *propertyNameData = [self.propertyReference
                                dataUsingEncoding:NSUTF8StringEncoding];
    [encoder encodeObject:propertyNameData forKey:kPropertyName];

    
    NSData *inventoryRef = [self.inventoryReference
                            dataUsingEncoding:NSUTF8StringEncoding];
    [encoder encodeObject:inventoryRef forKey:kInventoryRef];
    
    NSData *inventoryType = [self.inventoryType
                             dataUsingEncoding:NSUTF8StringEncoding];
    [encoder encodeObject:inventoryType forKey:kInventoryType];
    
    // Status
    NSData *inventoryStatusData = [self.inventoryStatus
                                   dataUsingEncoding:NSUTF8StringEncoding];
    [encoder encodeObject:inventoryStatusData forKey:kInventorystatus];
    
    // Dates
    NSData *inventoryDueDateData = [NSKeyedArchiver archivedDataWithRootObject:[self inventoryDueDate]];
    [encoder encodeObject:inventoryDueDateData forKey:kInventoryDueDate];
    NSData *inventoryScheduledDateData = [NSKeyedArchiver archivedDataWithRootObject:[self inventoryScheduledDate]];
    [encoder encodeObject:inventoryScheduledDateData forKey:kInventoryScheduledDate];
    NSData *inventoryCompletedDateData = [NSKeyedArchiver archivedDataWithRootObject:[self inventoryCompletedDate]];
    [encoder encodeObject:inventoryCompletedDateData forKey:kInventoryCompletedDate];

    
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    [decoder decodeIntForKey:kVersionKey];
    
    NSData * thumbnailData1 = [decoder decodeObjectForKey:kThumbnailKey1];
    UIImage * thumbnail1 = [UIImage imageWithData:thumbnailData1];
    [self setThumbnail1:thumbnail1];
    
    NSData *internalIdData = [decoder decodeObjectForKey:kInternalID];
    NSString *decodedinternalIdData = [[NSString alloc]
                                       initWithData:internalIdData
                                       encoding:NSUTF8StringEncoding];
    [self setInventoryDocID:decodedinternalIdData];
    
    NSData *propertyIdData = [decoder decodeObjectForKey:kPropertyRef];
    NSString *decodedpropertyID = [[NSString alloc]
                                   initWithData:propertyIdData
                                   encoding:NSUTF8StringEncoding];
    [self setPropertyDocID:decodedpropertyID];
    
    NSData *propertyNameData = [decoder decodeObjectForKey:kPropertyName];
    NSString *decodedPropertyName = [[NSString alloc]
                                     initWithData:propertyNameData
                                     encoding:NSUTF8StringEncoding];
    [self setPropertyReference:decodedPropertyName];
    
    NSData *inventoryRefData = [decoder decodeObjectForKey:kInventoryRef];
    NSString *decodedinventoryRef = [[NSString alloc]
                                     initWithData:inventoryRefData
                                     encoding:NSUTF8StringEncoding];
    [self setInventoryReference:decodedinventoryRef];
    
    NSData *inventoryTypeData = [decoder decodeObjectForKey:kInventoryType];
    NSString *decodedInventoryTypeData = [[NSString alloc]
                                          initWithData:inventoryTypeData
                                          encoding:NSUTF8StringEncoding];
    [self setInventoryType:decodedInventoryTypeData];
    
    // Status
    NSData *inventoryStatusData = [decoder decodeObjectForKey:kInventorystatus];
    NSString *decodedStatus = [[NSString alloc]
                               initWithData:inventoryStatusData
                               encoding:NSUTF8StringEncoding];
    [self setInventoryStatus:decodedStatus];
    
    //Dates
    NSData *inventoryDueDateData = [decoder decodeObjectForKey:kInventoryDueDate];
    NSDate *decodedDueDate = [NSKeyedUnarchiver unarchiveObjectWithData:inventoryDueDateData];
    [self setInventoryDueDate:decodedDueDate];
    NSData *inventoryScheduledDateData = [decoder decodeObjectForKey:kInventoryScheduledDate];
    NSDate *decodedScheduledDate = [NSKeyedUnarchiver unarchiveObjectWithData:inventoryScheduledDateData];
    [self setInventoryScheduledDate:decodedScheduledDate];
    NSData *inventoryCompletedDateData = [decoder decodeObjectForKey:kInventoryCompletedDate];
    NSDate *decodedCompletedDate = [NSKeyedUnarchiver unarchiveObjectWithData:inventoryCompletedDateData];
    [self setInventoryCompletedDate:decodedCompletedDate];
    

    return self;
}

@end
