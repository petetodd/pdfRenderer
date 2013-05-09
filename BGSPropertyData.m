//
//  BGSPropertyData.m
//  Lets Inventory
//
//  Created by Peter Todd on 02/04/2013.
//  Copyright (c) 2013 BrightGreenStar. All rights reserved.
//

#import "BGSPropertyData.h"

@implementation BGSPropertyData


#pragma mark NSCoding
// Implement NSCoding to encode/decode to a buffer of data
#define kVersionKey @"Version"
#define kInternalID @"PropertyDocID"
#define kPropertyRef @"PropertyRef"

#define kPropertyDesc @"PropertyDesc"
#define kPropertyType @"PropertyType"
#define kPhotoKey1 @"Photo1"
#define kPhotoKey2 @"Photo2"
#define kPhotoKey3 @"Photo3"
#define kPhotoKey4 @"Photo4"
#define kPhotoKey5 @"Photo5"
#define kPhotoKey6 @"Photo6"


#define kPropertyPurchaseDate @"PropertyPurchaseDate"
#define kPropertyPurchasePrice @"PropertyPurchasePrice"
#define kPropertyPurchaseCurr @"PropertyPurchaseCurr"

#define kPropertyAddress @"PropertyAddress"
#define kPropertyStatus @"PropertyStatus"

#define kInventoryDate @"InventoryDate"
#define kPropertyBedrooms @"PropertyBedrooms"
#define kPropertyBathrooms @"PropertyBathrooms"
#define kPropertyReceptionRooms @"PropertyReceptionRooms"
#define kPropertyHeating @"PropertyHeating"
#define kPropertyGarage @"PropertyGarage"
#define kPropertyGarden @"PropertyGarden"
#define kPropertyGardens2 @"PropertyGardens2"







- (id)initWithPhoto:(UIImage *)photo {
    if ((self = [super init])) {
        self.propertyPhoto1 = photo;
    }
    return self;
}

- (id)initWithString:(NSString*)documentText{
    if ((self = [super init])) {
        self.propertyDescription = documentText;
    }
    return self;
}

- (id)initWithPhotoAndString:(UIImage *)photo documentText:(NSString*)documentText {
    if ((self = [super init])) {
        self.propertyPhoto1 = photo;
        self.propertyDescription = documentText;
        
    }
    return self;
}



- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInt:1 forKey:kVersionKey];
    // Encode the NString as NSData
    //the document object’s data is an NSString object, but UIDocument does not allow you to write strings directly to disk. So instead, you must package the string in a form that the document object can handle, namely an NSData object
   
    NSData *internalIdData = [self.propertyDocID
                            dataUsingEncoding:NSUTF8StringEncoding];
    [encoder encodeObject:internalIdData forKey:kInternalID];
    
    NSData *propertyRef = [self.propertyReference
                              dataUsingEncoding:NSUTF8StringEncoding];
    [encoder encodeObject:propertyRef forKey:kPropertyRef];

    // Property Description
    NSData *docData = [self.propertyDescription
                       dataUsingEncoding:NSUTF8StringEncoding];
    [encoder encodeObject:docData forKey:kPropertyDesc];
    // Also Encode a photo
    NSData * photoData1 = UIImagePNGRepresentation(self.propertyPhoto1);
    [encoder encodeObject:photoData1 forKey:kPhotoKey1];
    
    NSData * photoData2 = UIImagePNGRepresentation(self.propertyPhoto2);
    [encoder encodeObject:photoData2 forKey:kPhotoKey2];

    NSData * photoData3 = UIImagePNGRepresentation(self.propertyPhoto3);
    [encoder encodeObject:photoData3 forKey:kPhotoKey3];

    NSData * photoData4 = UIImagePNGRepresentation(self.propertyPhoto4);
    [encoder encodeObject:photoData4 forKey:kPhotoKey4];

    NSData * photoData5 = UIImagePNGRepresentation(self.propertyPhoto5);
    [encoder encodeObject:photoData5 forKey:kPhotoKey5];

    NSData * photoData6 = UIImagePNGRepresentation(self.propertyPhoto6);
    [encoder encodeObject:photoData6 forKey:kPhotoKey6];

    
    NSData *propertyTypeData = [self.propertyType
                                dataUsingEncoding:NSUTF8StringEncoding];
    [encoder encodeObject:propertyTypeData forKey:kPropertyType];
    
    // Purchase details
   
    NSData *purchaseDateData = [NSKeyedArchiver archivedDataWithRootObject:[self purchaseDate]];
    [encoder encodeObject:purchaseDateData forKey:kPropertyPurchaseDate];
    
    NSData *purchasePrice = [NSKeyedArchiver archivedDataWithRootObject:[self purchasePrice]];
    [encoder encodeObject:purchasePrice forKey:kPropertyPurchasePrice];
    
    NSData *purchaseCurr = [self.purchaseCurrency
                                   dataUsingEncoding:NSUTF8StringEncoding];
    [encoder encodeObject:purchaseCurr forKey:kPropertyPurchaseCurr];
    
    // Address
    
    NSData *propertyAddress = [NSKeyedArchiver archivedDataWithRootObject:[self propertyAddress]];
    [encoder encodeObject:propertyAddress forKey:kPropertyAddress];
    
    // Property status (e.g. rented, available etc)
    
    NSData *propertyStatus = [self.propertyStatus
                                   dataUsingEncoding:NSUTF8StringEncoding];
    [encoder encodeObject:propertyStatus forKey:kPropertyStatus];
    
    // Details    
    NSData *inventoryDateData = [NSKeyedArchiver archivedDataWithRootObject:[self inventoryDate]];
    [encoder encodeObject:inventoryDateData forKey:kInventoryDate];
    NSData *nbrBedrooms = [NSKeyedArchiver archivedDataWithRootObject:[self bedrooms]];
    [encoder encodeObject:nbrBedrooms forKey:kPropertyBedrooms];
    
    NSData *nbrBathrooms = [NSKeyedArchiver archivedDataWithRootObject:[self bathroom]];
    [encoder encodeObject:nbrBathrooms forKey:kPropertyBathrooms];
    
    NSData *nbrReceptionRooms = [NSKeyedArchiver archivedDataWithRootObject:[self receptionRooms]];
    [encoder encodeObject:nbrReceptionRooms forKey:kPropertyReceptionRooms];
    NSData *heatingType = [self.heatingType
                            dataUsingEncoding:NSUTF8StringEncoding];
    [encoder encodeObject:heatingType forKey:kPropertyHeating];
    
    NSData *garage = [NSKeyedArchiver archivedDataWithRootObject:[self garage]];
    [encoder encodeObject:garage forKey:kPropertyGarage];
    
    NSData *garden = [NSKeyedArchiver archivedDataWithRootObject:[self garden]];
    [encoder encodeObject:garden forKey:kPropertyGarden];
    
    NSData *nbrGardens = [NSKeyedArchiver archivedDataWithRootObject:[self garden2]];
    [encoder encodeObject:nbrGardens forKey:kPropertyGardens2];

}


- (id)initWithCoder:(NSCoder *)decoder {
    [decoder decodeIntForKey:kVersionKey];
    
    
    NSData *internalIdData = [decoder decodeObjectForKey:kInternalID];
    NSString *decodedinternalIdData = [[NSString alloc]
                                 initWithData:internalIdData
                                 encoding:NSUTF8StringEncoding];
    [self setPropertyDocID:decodedinternalIdData];
    
    NSData *propertyRef = [decoder decodeObjectForKey:kPropertyRef];
    NSString *decodedpropertyRef = [[NSString alloc]
                                       initWithData:propertyRef
                                       encoding:NSUTF8StringEncoding];
    [self setPropertyReference:decodedpropertyRef];
    
    // Property Description
    
    NSData *docData = [decoder decodeObjectForKey:kPropertyDesc];
    NSString *decodedDocData = [[NSString alloc]
                                    initWithData:docData
                                    encoding:NSUTF8StringEncoding];
    [self setPropertyDescription:decodedDocData];
    
    NSData *docType = [decoder decodeObjectForKey:kPropertyType];
    NSString *decodedDocType = [[NSString alloc]
                                initWithData:docType
                                encoding:NSUTF8StringEncoding];
    [self setPropertyType:decodedDocType];
    
    // Images
    NSData * photoData = [decoder decodeObjectForKey:kPhotoKey1];
    UIImage * photo1 = [UIImage imageWithData:photoData];
    [self setPropertyPhoto1:photo1];
    NSData * photoData2 = [decoder decodeObjectForKey:kPhotoKey2];
    UIImage * photo2 = [UIImage imageWithData:photoData2];
    [self setPropertyPhoto2:photo2];
    NSData * photoData3 = [decoder decodeObjectForKey:kPhotoKey3];
    UIImage * photo3 = [UIImage imageWithData:photoData3];
    [self setPropertyPhoto3:photo3];
    NSData * photoData4 = [decoder decodeObjectForKey:kPhotoKey4];
    UIImage * photo4 = [UIImage imageWithData:photoData4];
    [self setPropertyPhoto4:photo4];
    NSData * photoData5 = [decoder decodeObjectForKey:kPhotoKey5];
    UIImage * photo5 = [UIImage imageWithData:photoData5];
    [self setPropertyPhoto5:photo5];
    NSData * photoData6 = [decoder decodeObjectForKey:kPhotoKey6];
    UIImage * photo6 = [UIImage imageWithData:photoData6];
    [self setPropertyPhoto6:photo6];
    
    
    
    
    
    // Purchase details
    
    NSData *purchaseDateData = [decoder decodeObjectForKey:kPropertyPurchaseDate];
    NSDate *decodedPurchaseDateData = [NSKeyedUnarchiver unarchiveObjectWithData:purchaseDateData];
    [self setPurchaseDate:decodedPurchaseDateData];
    
    
    NSData *purchasePrice = [decoder decodeObjectForKey:kPropertyPurchasePrice];
    NSDecimalNumber *decodedPurchasePrice= [NSKeyedUnarchiver unarchiveObjectWithData:purchasePrice];
    [self setPurchasePrice:decodedPurchasePrice];
    
    NSData *purchaseCurr = [decoder decodeObjectForKey:kPropertyPurchaseCurr];
    NSString *decodedPurchaseCurr = [[NSString alloc]
                                initWithData:purchaseCurr
                                encoding:NSUTF8StringEncoding];
    [self setPurchaseCurrency:decodedPurchaseCurr];
    
    // Address
    NSData *propertyAddress = [decoder decodeObjectForKey:kPropertyAddress];
    BGSAddressData *decodedPropertyAddress = [NSKeyedUnarchiver unarchiveObjectWithData:propertyAddress];
    [self setPropertyAddress:decodedPropertyAddress];

    
    // Property status (e.g. rented, available etc)
    
    NSData *propertyStatus = [decoder decodeObjectForKey:kPropertyStatus];
    NSString *decodedPropertyStatus = [[NSString alloc]
                                     initWithData:propertyStatus
                                     encoding:NSUTF8StringEncoding];
    [self setPropertyStatus:decodedPropertyStatus];
    
    // Details

    NSData *inventoryDate = [decoder decodeObjectForKey:kInventoryDate];
    NSDate *decodedInventoryDate = [NSKeyedUnarchiver unarchiveObjectWithData:inventoryDate];
    [self setInventoryDate:decodedInventoryDate];
    NSData *nbrBedrooms = [decoder decodeObjectForKey:kPropertyBedrooms];
    NSNumber *decodednbrBedrooms = [NSKeyedUnarchiver unarchiveObjectWithData:nbrBedrooms];
    [self setBedrooms:decodednbrBedrooms];
    NSData *nbrBathrooms = [decoder decodeObjectForKey:kPropertyBathrooms];
    NSNumber *decodednbrBathrooms = [NSKeyedUnarchiver unarchiveObjectWithData:nbrBathrooms];
    [self setBathroom:decodednbrBathrooms];
    NSData *nbrRecpRooms = [decoder decodeObjectForKey:kPropertyReceptionRooms];
    NSNumber *decodednbrRecpRooms = [NSKeyedUnarchiver unarchiveObjectWithData:nbrRecpRooms];
    [self setReceptionRooms:decodednbrRecpRooms];
    
    NSData *heatingType = [decoder decodeObjectForKey:kPropertyHeating];
    NSString *decodedheatingType = [[NSString alloc]
                                       initWithData:heatingType
                                       encoding:NSUTF8StringEncoding];
    [self setHeatingType:decodedheatingType];
    NSData *garageData = [decoder decodeObjectForKey:kPropertyGarage];
    NSNumber *decodedGarage = [NSKeyedUnarchiver unarchiveObjectWithData:garageData];
    [self setGarage:decodedGarage];
    NSData *gardenData = [decoder decodeObjectForKey:kPropertyGarden];
    NSNumber *decodedGarden = [NSKeyedUnarchiver unarchiveObjectWithData:gardenData];
    [self setGarden:decodedGarden];
    
    NSData *nbrGardens2 = [decoder decodeObjectForKey:kPropertyGardens2];
    NSNumber *decodednbrGardens2 = [NSKeyedUnarchiver unarchiveObjectWithData:nbrGardens2];
    [self setGarden2:decodednbrGardens2];
    
    return [self initWithPhotoAndString:photo1 documentText:decodedDocData];


}


@end
