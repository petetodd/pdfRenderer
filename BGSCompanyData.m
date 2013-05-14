//
//  BGSCompanyData.m
//  BGS PDF templates
//
//  Created by Peter Todd on 13/05/2013.
//  Copyright (c) 2013 BrightGreenStar. All rights reserved.
//

#import "BGSCompanyData.h"

@implementation BGSCompanyData

#pragma mark NSCoding
// Implement NSCoding to encode/decode to a buffer of data
#define kVersionKey @"Version"
#define kInternalID @"companyDocID"

#define kCompanyName @"CompanyName"
#define kCompanyStrapLine @"ComapnyStrapLine"
#define kCompanyLogo @"CompanyLogo"

#define kPropertyAddress @"CompanyAddress"

#define kCompanyMainContact @"CompanyMainContact"
#define kCompanyTel @"CompanyTel"
#define kCompanyMobile @"CompanyMobile"
#define kCompanyEmail @"CompanyEmail"
#define kCompanyWWW @"CompanyWWW"


- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInt:1 forKey:kVersionKey];
    // Encode the NString as NSData
    //the document object’s data is an NSString object, but UIDocument does not allow you to write strings directly to disk. So instead, you must package the string in a form that the document object can handle, namely an NSData object
    
    NSData *internalIdData = [self.companyDocID
                              dataUsingEncoding:NSUTF8StringEncoding];
    [encoder encodeObject:internalIdData forKey:kInternalID];
    
    NSData *companyName = [self.companyName
                              dataUsingEncoding:NSUTF8StringEncoding];
    [encoder encodeObject:companyName forKey:kCompanyName];
    
    NSData *companyStrapline = [self.companyStrapline
                                dataUsingEncoding:NSUTF8StringEncoding];
    [encoder encodeObject:companyStrapline forKey:kCompanyStrapLine];
    
    // Also Encode a photo
    NSData * companyLogo = UIImagePNGRepresentation(self.companyLogo);
    [encoder encodeObject:companyLogo forKey:kCompanyLogo];
    
    NSData *companyMainContact = [self.companyMainContact
                                dataUsingEncoding:NSUTF8StringEncoding];
    [encoder encodeObject:companyMainContact forKey:kCompanyMainContact];
    
    NSData *companyTel = [self.companyTel
                                  dataUsingEncoding:NSUTF8StringEncoding];
    [encoder encodeObject:companyTel forKey:kCompanyTel];
    
    NSData *companyMobile = [self.companyMobile
                                  dataUsingEncoding:NSUTF8StringEncoding];
    [encoder encodeObject:companyMobile forKey:kCompanyMobile];
    
    NSData *companyEmail = [self.companyEmail
                                  dataUsingEncoding:NSUTF8StringEncoding];
    [encoder encodeObject:companyEmail forKey:kCompanyEmail];
    
    NSData *companyWWW = [self.companyWWW
                            dataUsingEncoding:NSUTF8StringEncoding];
    [encoder encodeObject:companyWWW forKey:kCompanyWWW];
    
    
    // Address
    
    NSData *companyAddress = [NSKeyedArchiver archivedDataWithRootObject:[self companyAddress]];
    [encoder encodeObject:companyAddress forKey:kPropertyAddress];
}

- (id)initWithCoder:(NSCoder *)decoder {
    [decoder decodeIntForKey:kVersionKey];
    
    NSData *internalIdData = [decoder decodeObjectForKey:kInternalID];
    NSString *decodedinternalIdData = [[NSString alloc]
                                       initWithData:internalIdData
                                       encoding:NSUTF8StringEncoding];
    [self setCompanyDocID:decodedinternalIdData];
    
    NSData *companyName = [decoder decodeObjectForKey:kCompanyName];
    NSString *decodedCompanyName = [[NSString alloc]
                                   initWithData:companyName
                                   encoding:NSUTF8StringEncoding];
    [self setCompanyName:decodedCompanyName];
    
    NSData *companyStrapline = [decoder decodeObjectForKey:kCompanyStrapLine];
    NSString *decodedCompanyStrapline = [[NSString alloc]
                                    initWithData:companyStrapline
                                    encoding:NSUTF8StringEncoding];
    [self setCompanyStrapline:decodedCompanyStrapline];
    
    // Logo
    NSData * logoData = [decoder decodeObjectForKey:kCompanyLogo];
    UIImage * photo1 = [UIImage imageWithData:logoData];
    [self setCompanyLogo:photo1];
    
    // Address
    NSData *companyAddress = [decoder decodeObjectForKey:kPropertyAddress];
    BGSAddressData *decodedPropertyAddress = [NSKeyedUnarchiver unarchiveObjectWithData:companyAddress];
    [self setCompanyAddress:decodedPropertyAddress];
    
    
    NSData *companyMainContact = [decoder decodeObjectForKey:kCompanyMainContact];
    NSString *decodedCompanyMainContact = [[NSString alloc]
                                         initWithData:companyMainContact
                                         encoding:NSUTF8StringEncoding];
    [self setCompanyMainContact:decodedCompanyMainContact];

    NSData *companyTel = [decoder decodeObjectForKey:kCompanyTel];
    NSString *decodedCompanyTel = [[NSString alloc]
                                           initWithData:companyTel
                                           encoding:NSUTF8StringEncoding];
    [self setCompanyTel:decodedCompanyTel];
    
    NSData *companyMobile = [decoder decodeObjectForKey:kCompanyMobile];
    NSString *decodedCompanyMobile  = [[NSString alloc]
                                   initWithData:companyMobile
                                   encoding:NSUTF8StringEncoding];
    [self setCompanyMobile:decodedCompanyMobile];
    
    NSData *companyEmail = [decoder decodeObjectForKey:kCompanyEmail];
    NSString *decodedCompanyEmail  = [[NSString alloc]
                                       initWithData:companyEmail
                                       encoding:NSUTF8StringEncoding];
    [self setCompanyMobile:decodedCompanyEmail];
    
    NSData *companyWWW = [decoder decodeObjectForKey:kCompanyWWW];
    NSString *decodedCompanyWWW  = [[NSString alloc]
                                      initWithData:companyWWW
                                      encoding:NSUTF8StringEncoding];
    [self setCompanyWWW:decodedCompanyWWW];
    
    
    
    
    
    return self;  
}






@end
