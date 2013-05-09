//
//  BGSInventoryData.m
//  Lets Inventory
//
//  Created by Peter Todd on 11/04/2013.
//  Copyright (c) 2013 BrightGreenStar. All rights reserved.
//

#import "BGSInventoryData.h"

@implementation BGSInventoryData

#pragma mark NSCoding
// Implement NSCoding to encode/decode to a buffer of data
#define kVersionKey @"Version"
#define kInternalID @"inventoryDocID"
#define kInventoryRef @"InventoryRef"
#define kPropertyRef @"PropertyDocID"
#define kPropertyName @"PropertyRef"

#define kPhotoKey1 @"Photo1"


#define kInventoryType @"InventoryType"

#define kGeneralSumDesc @"GeneralSummaryDesc"
#define kGeneralItemsDict @"GeneralSummaryItems"

#define kInventorystatus @"InventoryStatus"

#define kInventoryDueDate @"InventoryDueDate"
#define kInventoryScheduledDate @"InventoryScheduledDate"
#define kInventoryCompletedDate @"InventoryCompletedDate"

// Tenancy
#define kTenantPresent @"TenantPresent"
#define kTenancyStart @"TenancyStart"
#define kTenantEnd @"TenancyEnd"
#define kTenantNames @"TenantNames"

// Property address
#define kPropertyAddress @"PropertyAddress"


- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInt:1 forKey:kVersionKey];
    // Encode the NString as NSData
    //the document object’s data is an NSString object, but UIDocument does not allow you to write strings directly to disk. So instead, you must package the string in a form that the document object can handle, namely an NSData object
    
    NSData *internalIdData = [self.inventoryDocID
                              dataUsingEncoding:NSUTF8StringEncoding];
    [encoder encodeObject:internalIdData forKey:kInternalID];
    
    NSData *propertyIdData = [self.propertyDocID
                              dataUsingEncoding:NSUTF8StringEncoding];
    [encoder encodeObject:propertyIdData forKey:kPropertyRef];
    
    NSData *propertyNameData = [self.propertyReference
                           dataUsingEncoding:NSUTF8StringEncoding];
    [encoder encodeObject:propertyNameData forKey:kPropertyName];
    
    // Also Encode a photo
    NSData * photoData1 = UIImagePNGRepresentation(self.propertyPhoto1);
    [encoder encodeObject:photoData1 forKey:kPhotoKey1];

    NSData *inventoryRef = [self.inventoryReference
                           dataUsingEncoding:NSUTF8StringEncoding];
    [encoder encodeObject:inventoryRef forKey:kInventoryRef];
    
    NSData *inventoryType = [self.inventoryType
                            dataUsingEncoding:NSUTF8StringEncoding];
    [encoder encodeObject:inventoryType forKey:kInventoryType];


    // General Summary
    NSData *generalSumDesc = [self.generalSummaryDescription
                       dataUsingEncoding:NSUTF8StringEncoding];
    [encoder encodeObject:generalSumDesc forKey:kGeneralSumDesc];
    // Encode the NSMutDictionary
    NSData *generalSumItems = [NSKeyedArchiver archivedDataWithRootObject:[self generalSummaryItems]];
    [encoder encodeObject:generalSumItems forKey:kGeneralItemsDict];
    
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
    
    // Tenancy
    NSData *tenantPresentData= [self.tenantPresent
                             dataUsingEncoding:NSUTF8StringEncoding];
    [encoder encodeObject:tenantPresentData forKey:kTenantPresent];

    NSData *tenantNamesData= [self.tenantNames
                                dataUsingEncoding:NSUTF8StringEncoding];
    [encoder encodeObject:tenantNamesData forKey:kTenantNames];
    
    NSData *tenancyStartDate = [NSKeyedArchiver archivedDataWithRootObject:[self tenancyStart]];
    [encoder encodeObject:tenancyStartDate forKey:kTenancyStart];
    NSData *tenancyEndDate = [NSKeyedArchiver archivedDataWithRootObject:[self tenancyEnd]];
    [encoder encodeObject:tenancyEndDate forKey:kTenantEnd];

}


- (id)initWithCoder:(NSCoder *)decoder {
    [decoder decodeIntForKey:kVersionKey];
        
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
    
    // Images
    NSData * photoData = [decoder decodeObjectForKey:kPhotoKey1];
    UIImage * photo1 = [UIImage imageWithData:photoData];
    [self setPropertyPhoto1:photo1];

    
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
    
    // General Summary
    NSData *inventorySumDesc = [decoder decodeObjectForKey:kGeneralSumDesc];
    NSString *decodedSumDesc = [[NSString alloc]
                                     initWithData:inventorySumDesc
                                     encoding:NSUTF8StringEncoding];
    [self setGeneralSummaryDescription:decodedSumDesc];
    
    NSData *generalSumItems = [decoder decodeObjectForKey:kGeneralItemsDict];
    NSMutableDictionary *decodedGeneralSumItems = [NSKeyedUnarchiver unarchiveObjectWithData:generalSumItems];
    [self setGeneralSummaryItems:decodedGeneralSumItems];
    
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
    
    
    // Tenancy
    NSData *tenantPresentData = [decoder decodeObjectForKey:kTenantPresent];
    NSString *decodedTenantPresent = [[NSString alloc]
                                initWithData:tenantPresentData
                                encoding:NSUTF8StringEncoding];
    [self setTenantPresent:decodedTenantPresent];
    
    NSData *tenantNamesData = [decoder decodeObjectForKey:kTenantNames];
    NSString *decodedTenantNames = [[NSString alloc]
                                      initWithData:tenantNamesData
                                      encoding:NSUTF8StringEncoding];
    [self setTenantNames:decodedTenantNames];
    
    NSData *tenancyStartDateData = [decoder decodeObjectForKey:kTenancyStart];
    NSDate *tenancyStartDate = [NSKeyedUnarchiver unarchiveObjectWithData:tenancyStartDateData];
    [self setTenancyStart:tenancyStartDate];
    
    NSData *tenancyEndDateData = [decoder decodeObjectForKey:kTenantEnd];
    NSDate *tenancyEndDate = [NSKeyedUnarchiver unarchiveObjectWithData:tenancyEndDateData];
    [self setTenancyEnd:tenancyEndDate];

    
    return self;
}

@end
