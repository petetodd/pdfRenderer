//
//  BGSInventoryInspectionItem.m
//  Lets Inventory
//
//  Created by Peter Todd on 13/04/2013.
//  Copyright (c) 2013 BrightGreenStar. All rights reserved.
//

#import "BGSInventoryInspectionItem.h"



@implementation BGSInventoryInspectionItem

#define kVersionKey @"Version"

#define kSectionTitle @"SectionTitle"
#define kItemDesc @"ItemDesc"
#define kItemValue @"ItemValue"
#define kIncludeItem @"IncludeItem"
#define kPhotoKey1 @"Photo1"
#define kPhotoKey2 @"Photo2"
#define kPhotoKey3 @"Photo3"
#define kPhotoKey4 @"Photo4"
#define kPhotoKey5 @"Photo5"
#define kPhotoKey6 @"Photo6"


- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInt:1 forKey:kVersionKey];
    // Encode the NString as NSData
    //the document object’s data is an NSString object, but UIDocument does not allow you to write strings directly to disk. So instead, you must package the string in a form that the document object can handle, namely an NSData object
    
    NSData *sectionTitleData = [self.sectionTitle
                              dataUsingEncoding:NSUTF8StringEncoding];
    [encoder encodeObject:sectionTitleData forKey:kSectionTitle];
    
    NSData *itemDescData = [self.itemDesc
                              dataUsingEncoding:NSUTF8StringEncoding];
    [encoder encodeObject:itemDescData forKey:kItemDesc];
    
    NSData *itemValueData = [self.itemValue
                            dataUsingEncoding:NSUTF8StringEncoding];
    [encoder encodeObject:itemValueData forKey:kItemValue];
    
    NSData *includeItemData = [self.includeItem
                             dataUsingEncoding:NSUTF8StringEncoding];
    [encoder encodeObject:includeItemData forKey:kIncludeItem];
    
    NSData * photoData1 = UIImagePNGRepresentation(self.itemPhoto1);
    [encoder encodeObject:photoData1 forKey:kPhotoKey1];
    NSData * photoData2 = UIImagePNGRepresentation(self.itemPhoto2);
    [encoder encodeObject:photoData2 forKey:kPhotoKey2];
    NSData * photoData3 = UIImagePNGRepresentation(self.itemPhoto3);
    [encoder encodeObject:photoData3 forKey:kPhotoKey3];
    NSData * photoData4 = UIImagePNGRepresentation(self.itemPhoto4);
    [encoder encodeObject:photoData4 forKey:kPhotoKey4];
    NSData * photoData5 = UIImagePNGRepresentation(self.itemPhoto5);
    [encoder encodeObject:photoData5 forKey:kPhotoKey5];
    NSData * photoData6 = UIImagePNGRepresentation(self.itemPhoto6);
    [encoder encodeObject:photoData6 forKey:kPhotoKey6];

}

- (id)initWithCoder:(NSCoder *)decoder {
    [decoder decodeIntForKey:kVersionKey];
    
    NSData *sectionTitleData = [decoder decodeObjectForKey:kSectionTitle];
    NSString *decodedsectionTitleData = [[NSString alloc]
                                       initWithData:sectionTitleData
                                       encoding:NSUTF8StringEncoding];
    [self setSectionTitle:decodedsectionTitleData];
    
    NSData *itemDescData = [decoder decodeObjectForKey:kItemDesc];
    NSString *decodeditemDescData = [[NSString alloc]
                                         initWithData:itemDescData
                                         encoding:NSUTF8StringEncoding];
    [self setItemDesc:decodeditemDescData];
    
    NSData *itemValueData = [decoder decodeObjectForKey:kItemValue];
    NSString *decodeditemValueData = [[NSString alloc]
                                     initWithData:itemValueData
                                     encoding:NSUTF8StringEncoding];
    [self setItemValue:decodeditemValueData];
    
    NSData *includeItemData = [decoder decodeObjectForKey:kIncludeItem];
    NSString *decodedincludeItemData = [[NSString alloc]
                                      initWithData:includeItemData
                                      encoding:NSUTF8StringEncoding];
    [self setIncludeItem:decodedincludeItemData];
    
    // Images
   
    NSData * photoData1 = [decoder decodeObjectForKey:kPhotoKey1];
    UIImage * photo1 = [UIImage imageWithData:photoData1];
    [self setItemPhoto1:photo1];
    
    
    NSData * photoData2 = [decoder decodeObjectForKey:kPhotoKey2];
    UIImage * photo2 = [UIImage imageWithData:photoData2];
    [self setItemPhoto2:photo2];
    NSData * photoData3 = [decoder decodeObjectForKey:kPhotoKey3];
    UIImage * photo3 = [UIImage imageWithData:photoData3];
    [self setItemPhoto3:photo3];
    NSData * photoData4 = [decoder decodeObjectForKey:kPhotoKey4];
    UIImage * photo4 = [UIImage imageWithData:photoData4];
    [self setItemPhoto4:photo4];
    NSData * photoData5 = [decoder decodeObjectForKey:kPhotoKey5];
    UIImage * photo5 = [UIImage imageWithData:photoData5];
    [self setItemPhoto5:photo5];
    NSData * photoData6 = [decoder decodeObjectForKey:kPhotoKey6];
    UIImage * photo6 = [UIImage imageWithData:photoData6];
    [self setItemPhoto6:photo6];

    
    return self;
}




@end
