//
//  BGSDocumentInventory.m
//  Lets Inventory
//
//  Created by Peter Todd on 11/04/2013.
//  Copyright (c) 2013 BrightGreenStar. All rights reserved.
//

#import "BGSDocumentInventory.h"

#define METADATA_FILENAME   @"inventory.metadata"
#define DATA_FILENAME       @"inventory.data"

@interface BGSDocumentInventory ()
    @property (nonatomic, strong) BGSInventoryData * data;
    @property (nonatomic, strong) NSFileWrapper * fileWrapper;
@end



@implementation BGSDocumentInventory

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
    if (self.debug) NSLog(@"DEBUG BGSDocumentInventory decodeObjectFromWrapperWithPreferredFilename");
    
    NSFileWrapper * fileWrapper = [self.fileWrapper.fileWrappers objectForKey:preferredFilename];
    if (!fileWrapper) {
        if (self.debug) NSLog(@"Unexpected error: Couldn't find %@ in file wrapper!", preferredFilename);
        return nil;
    }
    
    NSData * data = [fileWrapper regularFileContents];
    NSKeyedUnarchiver * unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    return [unarchiver decodeObjectForKey:@"data"];
    
}


- (BGSInventoryMetaData *)metadata {
    if (self.debug) NSLog(@"DEBUG BGSInventoryMetaData");
    
    
    if (_metadata == nil) {
        if (self.fileWrapper != nil) {
            if (self.debug) NSLog(@"Loading metadata for %@...", self.fileURL);
            self.metadata = [self decodeObjectFromWrapperWithPreferredFilename:METADATA_FILENAME];
        } else {
            self.metadata = [[BGSInventoryMetaData alloc] init];
        }
    }else{
        if (self.debug) NSLog(@"DEBUG BGSInventoryMetaData is not Nil");
        
    }
    return _metadata;
}

- (BGSInventoryData *)data {
    if (self.debug) NSLog(@"DEBUG BGSInventoryData");
    
    if (_data == nil) {
        if (self.fileWrapper != nil) {
            if (self.debug) NSLog(@"Loading document for %@...", self.fileURL);
            self.data = [self decodeObjectFromWrapperWithPreferredFilename:DATA_FILENAME];
        } else {
            self.data = [[BGSInventoryData alloc] init];
        }
    }
    return _data;
}

- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError {
    if (self.debug) NSLog(@"DEBUG BGSDocumentInventory loadFromContents");
    
    self.fileWrapper = (NSFileWrapper *) contents;
    
    // The rest will be lazy loaded...
    self.data = nil;
    self.metadata = nil;
    
    return YES;
}

- (NSString *) description {
    return [[self.fileURL lastPathComponent] stringByDeletingPathExtension];
}

#pragma mark Accessors

- (NSString *)inventoryDocID {
    return self.data.inventoryDocID;
}
- (void)setInventoryDocID:(NSString *)inventoryDocID{
    if ([self.data.inventoryDocID isEqual:inventoryDocID]) return;
    self.data.inventoryDocID = inventoryDocID;
    self.metadata.inventoryDocID = [self.data inventoryDocID];
}

- (NSString *)propertyDocID {    
    return self.data.propertyDocID;
}
- (void)setPropertyDocID:(NSString *)propertyDocID {
    if ([self.data.propertyDocID isEqual:propertyDocID]) return;    
    self.data.propertyDocID = propertyDocID;
    self.metadata.propertyDocID = [self.data propertyDocID];
}


- (NSString *)propertyReference {
    return self.data.propertyReference;
}
- (void)setPropertyReference:(NSString *)propertyReference{
    if ([self.data.propertyReference isEqual:propertyReference]) return;
    self.data.propertyReference = propertyReference;
    self.metadata.propertyReference = [self.data propertyReference];
}


- (NSString *)inventoryReference {    
    return self.data.inventoryReference;
}
- (void)setInventoryReference:(NSString *)inventoryReference{    
    if ([self.data.inventoryReference isEqual:inventoryReference]) return;
    
    NSString * oldData = self.data.inventoryReference;
    self.data.inventoryReference = inventoryReference;
    self.metadata.inventoryReference = [self.data inventoryReference];    
    
    [self.undoManager setActionName:@"InventoryReference Change"];
    [self.undoManager registerUndoWithTarget:self selector:@selector(setInventoryReference::) object:oldData];
}

- (NSString *)inventoryType {
    return self.data.inventoryType;
}
-(void)setInventoryType:(NSString *)inventoryType{
    if ([self.data.inventoryType isEqual:inventoryType]) return;
    self.data.inventoryType = inventoryType;
    self.metadata.inventoryType = [self.data inventoryType];
}




- (NSString *)inventoryStatus {
    return self.data.inventoryStatus;
}
- (void)setInventoryStatus:(NSString *)inventoryStatus{
    if ([self.data.inventoryStatus isEqual:inventoryStatus]) return;
    self.data.inventoryStatus = inventoryStatus;
    self.metadata.inventoryStatus = [self.data inventoryStatus];
}

- (NSDate *)inventoryDueDate {
    return self.data.inventoryDueDate;
}
- (void)setInventoryDueDate:(NSDate *)inventoryDueDate{
    if ([self.data.inventoryDueDate isEqual:inventoryDueDate]) return;
    self.data.inventoryDueDate = inventoryDueDate;
    self.metadata.inventoryDueDate = [self.data inventoryDueDate];
}
- (NSDate *)inventoryScheduledDate {
    return self.data.inventoryScheduledDate;
}
- (void)setInventoryScheduledDate:(NSDate *)inventoryScheduledDate{
    if ([self.data.inventoryScheduledDate isEqual:inventoryScheduledDate]) return;
    self.data.inventoryScheduledDate = inventoryScheduledDate;
    self.metadata.inventoryScheduledDate = [self.data inventoryScheduledDate];
}
- (NSDate *)inventoryCompletedDate {
    return self.data.inventoryCompletedDate;
}
- (void)setInventoryCompletedDate:(NSDate *)inventoryCompletedDate{
    if ([self.data.inventoryCompletedDate isEqual:inventoryCompletedDate]) return;
    self.data.inventoryCompletedDate = inventoryCompletedDate;
    self.metadata.inventoryCompletedDate = [self.data inventoryCompletedDate];
}




- (NSString *)tenantPresent {
    return self.data.tenantPresent;
}
- (void)setTenantPresent:(NSString *)tenantPresent{
    if ([self.data.tenantPresent isEqual:tenantPresent]) return;
    self.data.tenantPresent = tenantPresent;
}

- (NSString *)tenantNames {
    return self.data.tenantNames;
}
- (void)setTenantNames:(NSString *)tenantNames{
    if ([self.data.tenantNames isEqual:tenantNames]) return;
    self.data.tenantNames = tenantNames;
}

- (NSDate *)tenancyStart{
    return self.data.tenancyStart;
}
-(void)setTenancyStart:(NSDate *)tenancyStart{
    if ([self.data.tenancyStart isEqual:tenancyStart]) return;
    self.data.tenancyStart = tenancyStart;
}

- (NSDate *)tenancyEnd{
    return self.data.tenancyEnd;
}
-(void)setTenancyEnd:(NSDate *)tenancyEnd{
    if ([self.data.tenancyEnd isEqual:tenancyEnd]) return;
    self.data.tenancyEnd = tenancyEnd;
}

// General Summary Description
- (NSString *)generalSummaryDescription {
    return self.data.generalSummaryDescription;
}
- (void)setGeneralSummaryDescription:(NSString *)generalSummaryDescription{
    if ([self.data.generalSummaryDescription isEqual:generalSummaryDescription]) return;
    self.data.generalSummaryDescription = generalSummaryDescription;
}

// General Summary Items
-(NSMutableDictionary*)generalSummaryItems{
    return self.data.generalSummaryItems;
}

- (void) setGeneralSummaryItems:(NSMutableDictionary *)generalSummaryItems{
    if ([self.data.generalSummaryItems isEqual:generalSummaryItems]) return;
    self.data.generalSummaryItems = generalSummaryItems;
}





@end
