//
//  BGSDocumentCompany.m
//  BGS PDF templates
//
//  Created by Peter Todd on 13/05/2013.
//  Copyright (c) 2013 BrightGreenStar. All rights reserved.
//

#import "BGSDocumentCompany.h"

#define DATA_FILENAME       @"inventory.data"

@interface BGSDocumentCompany ()
    @property (nonatomic, strong) BGSCompanyData * data;
    @property (nonatomic, strong) NSFileWrapper * fileWrapper;
@end

@implementation BGSDocumentCompany

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
    
    if (self.data == nil) {
        return nil;
    }
    
    NSMutableDictionary * wrappers = [NSMutableDictionary dictionary];
    [self encodeObject:self.data toWrappers:wrappers preferredFilename:DATA_FILENAME];
    NSFileWrapper * fileWrapper = [[NSFileWrapper alloc] initDirectoryWithFileWrappers:wrappers];
    
    return fileWrapper;
}

#pragma mark - Read UIDocument from Disk

- (id)decodeObjectFromWrapperWithPreferredFilename:(NSString *)preferredFilename {    
    NSFileWrapper * fileWrapper = [self.fileWrapper.fileWrappers objectForKey:preferredFilename];
    if (!fileWrapper) {
        if (self.debug) NSLog(@"Unexpected error: Couldn't find %@ in file wrapper!", preferredFilename);
        return nil;
    }
    
    NSData * data = [fileWrapper regularFileContents];
    NSKeyedUnarchiver * unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    return [unarchiver decodeObjectForKey:@"data"];
    
    
}



- (BGSCompanyData *)data {    
    if (_data == nil) {
        if (self.fileWrapper != nil) {
            if (self.debug) NSLog(@"Loading document for %@...", self.fileURL);
            self.data = [self decodeObjectFromWrapperWithPreferredFilename:DATA_FILENAME];
        } else {
            self.data = [[BGSCompanyData alloc] init];
        }
    }
    return _data;
}

- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError {
    self.fileWrapper = (NSFileWrapper *) contents;
    
    // The rest will be lazy loaded...
    self.data = nil;
    
    return YES;
    
}


- (NSString *) description {

    return [[self.fileURL lastPathComponent] stringByDeletingPathExtension];
}


#pragma mark Accessors

- (NSString *)companyDocID {    
    return self.data.companyDocID;
}
- (void)setCompanyDocID:(NSString *)companyDocID {
    if (self.debug) NSLog(@"DEBUG setDocumentText");
    
    
    if ([self.data.companyDocID isEqual:companyDocID]) return;
    
    // NSString * oldData = self.data.propertyDocID;
    self.data.companyDocID = companyDocID;
}

- (NSString *)companyName {    
    return self.data.companyName;
}
- (void)setCompanyName:(NSString *)companyName {
    if ([self.data.companyName isEqual:companyName]) return;
    
    NSString * oldData = self.data.companyName;
    self.data.companyName = companyName;    
    
    [self.undoManager setActionName:@"Company Name Change"];
    [self.undoManager registerUndoWithTarget:self selector:@selector(setPropertyReference:) object:oldData];
}

- (NSString *)companyStrapline {    
    return self.data.companyStrapline;
}
- (void)setCompanyStrapline:(NSString *)companyStrapline {
    
    if ([self.data.companyStrapline isEqual:companyStrapline]) return;    
    self.data.companyStrapline = companyStrapline;
    
}

// Logo
- (UIImage *)companyLogo {
    return self.data.companyLogo;
}

- (void)setCompanyLogo:(UIImage *)companyLogo {
    
    if ([self.data.companyLogo isEqual:companyLogo]) return;
    
    // UIImage * oldPhoto = self.data.propertyPhoto1;
    self.data.companyLogo = companyLogo;
}

// Address

- (BGSAddressData *)companyAddress {    
    return self.data.companyAddress;
}
- (void)setCompanyAddress:(BGSAddressData *)companyAddress {    
    if ([self.data.companyAddress isEqual:companyAddress]) return;
    
    // BGSAddressData * oldData = self.data.propertyAddress;
    self.data.companyAddress = companyAddress;
}

// Contact Details
- (NSString *)companyMainContact {
    return self.data.companyMainContact;
}
- (void)setCompanyMainContact:(NSString *)companyMainContact {
    
    if ([self.data.companyMainContact isEqual:companyMainContact]) return;
    self.data.companyMainContact = companyMainContact;
    
}

- (NSString *)companyTel {
    return self.data.companyTel;
}
- (void)setCompanyTel:(NSString *)companyTel {
    
    if ([self.data.companyTel isEqual:companyTel]) return;
    self.data.companyTel = companyTel;
}

- (NSString *)companyMobile {
    return self.data.companyMobile;
}
- (void)setCompanyMobile:(NSString *)companyMobile {
    
    if ([self.data.companyMobile isEqual:companyMobile]) return;
    self.data.companyMobile = companyMobile;
}

- (NSString *)companyEmail {
    return self.data.companyEmail;
}
- (void)setCompanyEmail:(NSString *)companyEmail {
    
    if ([self.data.companyEmail isEqual:companyEmail]) return;
    self.data.companyEmail = companyEmail;
}

- (NSString *)companyWWW {
    return self.data.companyWWW;
}
- (void)setCompanyWWW:(NSString *)companyWWW{
    
    if ([self.data.companyWWW isEqual:companyWWW]) return;
    self.data.companyWWW = companyWWW;
}



@end
