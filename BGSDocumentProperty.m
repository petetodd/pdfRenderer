//
//  BGSDocumentProperty.m
//  Lets Inventory
//
//  Created by Peter Todd on 02/04/2013.
//  Copyright (c) 2013 BrightGreenStar. All rights reserved.
//

#import "BGSDocumentProperty.h"


#define METADATA_FILENAME   @"property.metadata"
#define DATA_FILENAME       @"property.data"

@interface BGSDocumentProperty ()
    @property (nonatomic, strong) BGSPropertyData * data;
    @property (nonatomic, strong) NSFileWrapper * fileWrapper;
@end



@implementation BGSDocumentProperty

- (void)encodeObject:(id<NSCoding>)object toWrappers:(NSMutableDictionary *)wrappers preferredFilename:(NSString *)preferredFilename {
    @autoreleasepool {
        NSMutableData * data = [NSMutableData data];
        NSKeyedArchiver * archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:object forKey:@"data"];
        [archiver finishEncoding];
        NSFileWrapper * wrapper = [[NSFileWrapper alloc] initRegularFileWithContents:data];
        [wrappers setObject:wrapper forKey:preferredFilename];
    }
}

- (id)contentsForType:(NSString *)typeName error:(NSError *__autoreleasing *)outError {
    
    if (self.metadata == nil || self.data == nil) {
        return nil;
    }
    
    NSMutableDictionary * wrappers = [NSMutableDictionary dictionary];
    [self encodeObject:self.metadata toWrappers:wrappers preferredFilename:METADATA_FILENAME];
    [self encodeObject:self.data toWrappers:wrappers preferredFilename:DATA_FILENAME];
    NSFileWrapper * fileWrapper = [[NSFileWrapper alloc] initDirectoryWithFileWrappers:wrappers];
    
    return fileWrapper;
}


#pragma mark - Read UIDocument from Disk

- (id)decodeObjectFromWrapperWithPreferredFilename:(NSString *)preferredFilename {
    if (self.debug) NSLog(@"DEBUG PTPDocumentClient decodeObjectFromWrapperWithPreferredFilename");
    
    NSFileWrapper * fileWrapper = [self.fileWrapper.fileWrappers objectForKey:preferredFilename];
    if (!fileWrapper) {
        if (self.debug) NSLog(@"Unexpected error: Couldn't find %@ in file wrapper!", preferredFilename);
        return nil;
    }
    
    NSData * data = [fileWrapper regularFileContents];
    NSKeyedUnarchiver * unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    return [unarchiver decodeObjectForKey:@"data"];
    
    
}


- (BGSPropertyMetaData *)metadata {
    if (self.debug) NSLog(@"DEBUG metadata");
    
    
    if (_metadata == nil) {
        if (self.fileWrapper != nil) {
            if (self.debug) NSLog(@"Loading metadata for %@...", self.fileURL);
            self.metadata = [self decodeObjectFromWrapperWithPreferredFilename:METADATA_FILENAME];
        } else {
            self.metadata = [[BGSPropertyMetaData alloc] init];
        }
    }else{
        if (self.debug) NSLog(@"DEBUG metadata is not Nil");
        
    }
    return _metadata;
}

- (BGSPropertyData *)data {
    if (self.debug) NSLog(@"DEBUG data");
    
    if (_data == nil) {
        if (self.fileWrapper != nil) {
            if (self.debug) NSLog(@"Loading document for %@...", self.fileURL);
            self.data = [self decodeObjectFromWrapperWithPreferredFilename:DATA_FILENAME];
        } else {
            self.data = [[BGSPropertyData alloc] init];
        }
    }
    return _data;
}

- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError {
    if (self.debug) NSLog(@"DEBUG loadFromContents");
    
    self.fileWrapper = (NSFileWrapper *) contents;
    
    // The rest will be lazy loaded...
    self.data = nil;
    self.metadata = nil;
    
    return YES;
    
}


- (NSString *) description {
    if (self.debug) NSLog(@"DEBUG description");
    
    return [[self.fileURL lastPathComponent] stringByDeletingPathExtension];
}

#pragma mark Accessors

- (NSString *)propertyDocID {
    if (self.debug) NSLog(@"DEBUG propertyDocID");
    
    return self.data.propertyDocID;
}
- (void)setPropertyDocID:(NSString *)propertyDocID {
    if (self.debug) NSLog(@"DEBUG setDocumentText");
    
    
    if ([self.data.propertyDocID isEqual:propertyDocID]) return;
    
    // NSString * oldData = self.data.propertyDocID;
    self.data.propertyDocID = propertyDocID;
    self.metadata.propertyDocID = [self.data propertyDocID];

    
    //[self.undoManager setActionName:@"Internal ID Change"];
    //[self.undoManager registerUndoWithTarget:self selector:@selector(setPropertyDocID:) object:oldData];
}

- (NSString *)propertyReference {
    if (self.debug) NSLog(@"DEBUG propertyReference");
    
    return self.data.propertyReference;
}
- (void)setPropertyReference:(NSString *)propertyReference {
    if (self.debug) NSLog(@"DEBUG setDocumentText");
    
    
    if ([self.data.propertyReference isEqual:propertyReference]) return;
    
    NSString * oldData = self.data.propertyReference;
    self.data.propertyReference = propertyReference;
    self.metadata.propertyReference = [self.data propertyReference];

    
    [self.undoManager setActionName:@"Reference Change"];
    [self.undoManager registerUndoWithTarget:self selector:@selector(setPropertyReference:) object:oldData];
}

- (NSString *)propertyDescription {
    if (self.debug) NSLog(@"DEBUG documentText");
    
    return self.data.propertyDescription;
}
- (void)setPropertyDescription:(NSString *)propertyDescription {
    if (self.debug) NSLog(@"DEBUG setDocumentText");
    
    
    if ([self.data.propertyDescription isEqual:propertyDescription]) return;
    
    // NSString * oldData = self.data.propertyDescription;
    self.data.propertyDescription = propertyDescription;

    //[self.undoManager setActionName:@"Property Description Change"];
    //[self.undoManager registerUndoWithTarget:self selector:@selector(setPropertyDescription:) object:oldData];
}

- (NSString *)propertyType {
    if (self.debug) NSLog(@"DEBUG propertyType");
    
    return self.data.propertyType;
}
- (void)setPropertyType:(NSString *)propertyType {
    if (self.debug) NSLog(@"DEBUG setDocumentText");
    
    
    if ([self.data.propertyType isEqual:propertyType]) return;
    
    // NSString * oldData = self.data.propertyType;
    self.data.propertyType = propertyType;
    
    //[self.undoManager setActionName:@"Property Type Change"];
    //[self.undoManager registerUndoWithTarget:self selector:@selector(setPropertyType:) object:oldData];
}

// Images
- (UIImage *)propertyPhoto1 {
    return self.data.propertyPhoto1;
}
- (UIImage *)propertyPhoto2 {
    return self.data.propertyPhoto2;
}
- (UIImage *)propertyPhoto3 {
    return self.data.propertyPhoto3;
}
- (UIImage *)propertyPhoto4 {
    return self.data.propertyPhoto4;
}
- (UIImage *)propertyPhoto5 {
    return self.data.propertyPhoto5;
}
- (UIImage *)propertyPhoto6 {
    return self.data.propertyPhoto6;
}


- (void)setPropertyPhoto1:(UIImage *)propertyPhoto1 {
    
    if ([self.data.propertyPhoto1 isEqual:propertyPhoto1]) return;
    
    // UIImage * oldPhoto = self.data.propertyPhoto1;
    self.data.propertyPhoto1 = propertyPhoto1;
    self.metadata.thumbnail1 = [self.data.propertyPhoto1 imageByScalingAndCroppingForSize:CGSizeMake(145, 145)];
    
    //[self.undoManager setActionName:@"Image 1 Change"];
    //[self.undoManager registerUndoWithTarget:self selector:@selector(setPropertyPhoto1:) object:oldPhoto];
}


- (void)setPropertyPhoto2:(UIImage *)propertyPhoto2 {
    
    if ([self.data.propertyPhoto2 isEqual:propertyPhoto2]) return;
    
    // UIImage * oldPhoto = self.data.propertyPhoto2;
    self.data.propertyPhoto2 = propertyPhoto2;
    self.metadata.thumbnail2 = [self.data.propertyPhoto2 imageByScalingAndCroppingForSize:CGSizeMake(145, 145)];
    
    //[self.undoManager setActionName:@"Image 2 Change"];
    //[self.undoManager registerUndoWithTarget:self selector:@selector(setPropertyPhoto2:) object:oldPhoto];
}

- (void)setPropertyPhoto3:(UIImage *)propertyPhoto3 {
    
    if ([self.data.propertyPhoto3 isEqual:propertyPhoto3]) return;
    
    // UIImage * oldPhoto = self.data.propertyPhoto3;
    self.data.propertyPhoto3 = propertyPhoto3;
    self.metadata.thumbnail3 = [self.data.propertyPhoto3 imageByScalingAndCroppingForSize:CGSizeMake(145, 145)];
    
    //[self.undoManager setActionName:@"Image 3 Change"];
    //[self.undoManager registerUndoWithTarget:self selector:@selector(setPropertyPhoto3:) object:oldPhoto];
}

- (void)setPropertyPhoto4:(UIImage *)propertyPhoto4 {
    
    if ([self.data.propertyPhoto4 isEqual:propertyPhoto4]) return;
    
    // UIImage * oldPhoto = self.data.propertyPhoto4;
    self.data.propertyPhoto4 = propertyPhoto4;
    self.metadata.thumbnail4 = [self.data.propertyPhoto4 imageByScalingAndCroppingForSize:CGSizeMake(145, 145)];
    
    //[self.undoManager setActionName:@"Image 4 Change"];
    //[self.undoManager registerUndoWithTarget:self selector:@selector(setPropertyPhoto4:) object:oldPhoto];
}

- (void)setPropertyPhoto5:(UIImage *)propertyPhoto5 {
    
    if ([self.data.propertyPhoto5 isEqual:propertyPhoto5]) return;
    
    // UIImage * oldPhoto = self.data.propertyPhoto5;
    self.data.propertyPhoto5 = propertyPhoto5;
    self.metadata.thumbnail5 = [self.data.propertyPhoto5 imageByScalingAndCroppingForSize:CGSizeMake(145, 145)];
    
    //[self.undoManager setActionName:@"Image 5 Change"];
    //[self.undoManager registerUndoWithTarget:self selector:@selector(setPropertyPhoto5:) object:oldPhoto];
}

- (void)setPropertyPhoto6:(UIImage *)propertyPhoto6 {
    
    if ([self.data.propertyPhoto6 isEqual:propertyPhoto6]) return;
    
    // UIImage * oldPhoto = self.data.propertyPhoto6;
    self.data.propertyPhoto6 = propertyPhoto6;
    self.metadata.thumbnail6 = [self.data.propertyPhoto6 imageByScalingAndCroppingForSize:CGSizeMake(145, 145)];
    
    //[self.undoManager setActionName:@"Image 6 Change"];
    //[self.undoManager registerUndoWithTarget:self selector:@selector(setPropertyPhoto6:) object:oldPhoto];
}





// Purchase details

- (NSDate *)purchaseDate {
    if (self.debug) NSLog(@"DEBUG purchaseDate");
    
    return self.data.purchaseDate;
}
- (void)setPurchaseDate:(NSDate *)purchaseDate {
    if (self.debug) NSLog(@"DEBUG setDocumentText");
    
    
    if ([self.data.purchaseDate isEqual:purchaseDate]) return;
    
    // NSDate * oldData = self.data.purchaseDate;
    self.data.purchaseDate = purchaseDate;
    
    //[self.undoManager setActionName:@"Purchase Date Change"];
    //[self.undoManager registerUndoWithTarget:self selector:@selector(setPurchaseDate:) object:oldData];
}

- (NSDecimalNumber *)purchasePrice {
    if (self.debug) NSLog(@"DEBUG purchaseDate");
    
    return self.data.purchasePrice;
}
- (void)setPurchasePrice:(NSDecimalNumber *)purchasePrice {
    if (self.debug) NSLog(@"DEBUG setDocumentText");
    
    
    if ([self.data.purchasePrice isEqual:purchasePrice]) return;
    
    // NSDecimalNumber * oldData = self.data.purchasePrice;
    self.data.purchasePrice = purchasePrice;
    
    //[self.undoManager setActionName:@"Purchase Price Change"];
    //[self.undoManager registerUndoWithTarget:self selector:@selector(setPurchasePrice:) object:oldData];
}

- (NSString *)purchaseCurrency {
    if (self.debug) NSLog(@"DEBUG purchaseCurrency");
    
    return self.data.purchaseCurrency;
}
- (void)setPurchaseCurrency:(NSString *)purchaseCurrency {
    if (self.debug) NSLog(@"DEBUG setDocumentText");
    
    
    if ([self.data.purchaseCurrency isEqual:purchaseCurrency]) return;
    
    // NSString * oldData = self.data.purchaseCurrency;
    self.data.purchaseCurrency = purchaseCurrency;
    
    //[self.undoManager setActionName:@"Purchase Currency Change"];
    //[self.undoManager registerUndoWithTarget:self selector:@selector(setPurchaseCurrency:) object:oldData];
}

// Address

- (BGSAddressData *)propertyAddress {
    if (self.debug) NSLog(@"DEBUG propertyAddress");
    
    return self.data.propertyAddress;
}
- (void)setPropertyAddress:(BGSAddressData *)propertyAddress {
    if (self.debug) NSLog(@"DEBUG propertyAddress");
    
    
    if ([self.data.propertyAddress isEqual:propertyAddress]) return;
    
    // BGSAddressData * oldData = self.data.propertyAddress;
    self.data.propertyAddress = propertyAddress;
    
    //[self.undoManager setActionName:@"Property Address Change"];
    //[self.undoManager registerUndoWithTarget:self selector:@selector(setPropertyAddress:) object:oldData];
}


// Property status (e.g. rented, available etc)

- (NSString *)propertyStatus {
    return self.data.propertyStatus;
}

- (void)setPropertyStatus:(NSString *)propertyStatus {
    
    if ([self.data.propertyStatus isEqual:propertyStatus]) return;
    
    // NSString * oldData = self.data.propertyStatus;
    self.data.propertyStatus = propertyStatus;
    self.metadata.propertyStatus = [self.data propertyStatus];
    
    //[self.undoManager setActionName:@"Status Change"];
    //[self.undoManager registerUndoWithTarget:self selector:@selector(setPropertyStatus:) object:oldData];
}

//Bedrooms

- (NSDate *)inventoryDate {    
    return self.data.inventoryDate;
}
- (void)setInventoryDate:(NSDate *)inventoryDate {
    if ([self.data.inventoryDate isEqual:inventoryDate]) return;
    self.data.inventoryDate = inventoryDate;
}


- (NSNumber *)bedrooms {
    return self.data.bedrooms;
}

- (void)setBedrooms:(NSNumber *)bedrooms{
    if ([self.data.bedrooms isEqual:bedrooms]) return;
    self.data.bedrooms = bedrooms;    
}

- (NSNumber *)bathroom {
    return self.data.bathroom;
}

- (void)setBathroom:(NSNumber *)bathroom{
    if ([self.data.bathroom isEqual:bathroom]) return;
    self.data.bathroom = bathroom;
}

- (NSNumber *)receptionRooms {
    return self.data.receptionRooms;
}

- (void)setReceptionRooms:(NSNumber *)receptionRooms{
    if ([self.data.receptionRooms isEqual:receptionRooms]) return;
    self.data.receptionRooms = receptionRooms;
}

- (NSString *)heatingType {
    return self.data.heatingType;
}

- (void)setHeatingType:(NSString *)heatingType {
    
    if ([self.data.heatingType isEqual:heatingType]) return;
    
    self.data.heatingType = heatingType;
    self.metadata.propertyStatus = [self.data propertyStatus];
}

- (NSNumber *)garage {
    return self.data.garage;
}

- (void)setGarage:(NSNumber *)garage{
    if ([self.data.garage isEqual:garage]) return;
    self.data.garage = garage;
}

- (NSNumber *)garden {
    return self.data.garden;
}

- (void)setGarden:(NSNumber *)garden{
    if ([self.data.garden isEqual:garden]) return;
    self.data.garden = garden;
}

- (NSNumber *)garden2 {
    return self.data.garden2;
}

- (void)setGarden2:(NSNumber *)garden2{
    if ([self.data.garden2 isEqual:garden2]) return;
    self.data.garden2 = garden2;
}




@end
