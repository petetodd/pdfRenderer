//
//  BGSAddressData.m
//  Lets Inventory
//
//  Created by Peter Todd on 02/04/2013.
//  Copyright (c) 2013 BrightGreenStar. All rights reserved.
//

#import "BGSAddressData.h"

@implementation BGSAddressData

#pragma mark NSCoding
// Implement NSCoding to encode/decode to a buffer of data
#define kVersionKey @"Version"
#define kAddress1 @"Address1"
#define kAddress2 @"Address2"
#define kAddress3 @"Address3"
#define kAddress4 @"Address4"
#define kAddress5 @"Address5"
#define kAddress6 @"Address6"
#define kAddress7 @"Address7"
#define kAddress8 @"Address8"


- (id)initWithString:(NSString*)documentText{  
    if ((self = [super init])) {
        self.address1_number = documentText;
    }
    return self;
}




- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInt:1 forKey:kVersionKey];
    // Encode the NString as NSData
    
    NSData *address1 = [self.address1_number
                           dataUsingEncoding:NSUTF8StringEncoding];
    [encoder encodeObject:address1 forKey:kAddress1];
    NSData *address2 = [self.address2_street
                        dataUsingEncoding:NSUTF8StringEncoding];
    [encoder encodeObject:address2 forKey:kAddress2];
    NSData *address3 = [self.address3_city
                        dataUsingEncoding:NSUTF8StringEncoding];
    [encoder encodeObject:address3 forKey:kAddress3];
    NSData *address4 = [self.address4_county
                        dataUsingEncoding:NSUTF8StringEncoding];
    [encoder encodeObject:address4 forKey:kAddress4];
    NSData *address5 = [self.address5_state
                        dataUsingEncoding:NSUTF8StringEncoding];
    [encoder encodeObject:address5 forKey:kAddress5];
    NSData *address6 = [self.address6_zipcode
                        dataUsingEncoding:NSUTF8StringEncoding];
    [encoder encodeObject:address6 forKey:kAddress6];
    NSData *address7 = [self.address7
                        dataUsingEncoding:NSUTF8StringEncoding];
    [encoder encodeObject:address7 forKey:kAddress7];
    NSData *address8 = [self.address8
                        dataUsingEncoding:NSUTF8StringEncoding];
    [encoder encodeObject:address8 forKey:kAddress8];
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    [decoder decodeIntForKey:kVersionKey];
    
    NSData *addressData1 = [decoder decodeObjectForKey:kAddress1];
    NSString *decodedAddressData1 = [[NSString alloc]
                                    initWithData:addressData1
                                    encoding:NSUTF8StringEncoding];
    [self setAddress1_number:decodedAddressData1];
    
    NSData *addressData2 = [decoder decodeObjectForKey:kAddress2];
    NSString *decodedAddressData2 = [[NSString alloc]
                                     initWithData:addressData2
                                     encoding:NSUTF8StringEncoding];
    [self setAddress2_street:decodedAddressData2];
    
    NSData *addressData3 = [decoder decodeObjectForKey:kAddress3];
    NSString *decodedAddressData3 = [[NSString alloc]
                                     initWithData:addressData3
                                     encoding:NSUTF8StringEncoding];
    [self setAddress3_city:decodedAddressData3];
    
    NSData *addressData4 = [decoder decodeObjectForKey:kAddress4];
    NSString *decodedAddressData4 = [[NSString alloc]
                                     initWithData:addressData4
                                     encoding:NSUTF8StringEncoding];
    [self setAddress4_county:decodedAddressData4];
    
    NSData *addressData5 = [decoder decodeObjectForKey:kAddress5];
    NSString *decodedAddressData5 = [[NSString alloc]
                                     initWithData:addressData5
                                     encoding:NSUTF8StringEncoding];
    [self setAddress5_state:decodedAddressData5];
    
    NSData *addressData6 = [decoder decodeObjectForKey:kAddress6];
    NSString *decodedAddressData6 = [[NSString alloc]
                                     initWithData:addressData6
                                     encoding:NSUTF8StringEncoding];
    [self setAddress6_zipcode:decodedAddressData6];
    
    NSData *addressData7 = [decoder decodeObjectForKey:kAddress7];
    NSString *decodedAddressData7 = [[NSString alloc]
                                     initWithData:addressData7
                                     encoding:NSUTF8StringEncoding];
    [self setAddress7:decodedAddressData7];
    
    NSData *addressData8 = [decoder decodeObjectForKey:kAddress8];
    NSString *decodedAddressData8 = [[NSString alloc]
                                     initWithData:addressData8
                                     encoding:NSUTF8StringEncoding];
    [self setAddress8:decodedAddressData8];
    
    return [self initWithString:decodedAddressData1];

}



- (NSString*) fullPropertyAddress{
    
    NSString* fullAddress = @"";
    if ([self.address1_number length] > 0){
        fullAddress = [fullAddress stringByAppendingString: [self address1_number]];
    }
    if ([self.address2_street length] > 0){
        fullAddress = [fullAddress stringByAppendingString:@", "];
        fullAddress = [fullAddress stringByAppendingString: [self address2_street]];
    }
    if ([self.address3_city length] > 0){
        fullAddress = [fullAddress stringByAppendingString:@", "];
        fullAddress = [fullAddress stringByAppendingString: [self address3_city]];
    }
    if ([self.address4_county length] > 0){
        fullAddress = [fullAddress stringByAppendingString:@", "];
        fullAddress = [fullAddress stringByAppendingString: [self address4_county]];
    }
    if ([self.address5_state length] > 0){
        fullAddress = [fullAddress stringByAppendingString:@", "];
        fullAddress = [fullAddress stringByAppendingString: [self address5_state]];
    }
    if ([self.address6_zipcode length] > 0){
        fullAddress = [fullAddress stringByAppendingString:@", "];
        fullAddress = [fullAddress stringByAppendingString: [self address6_zipcode]];
    }
    if ([self.address7 length] > 0){
        fullAddress = [fullAddress stringByAppendingString:@", "];
        fullAddress = [fullAddress stringByAppendingString: [self address7]];
    }
    if ([self.address8 length] > 0){
        fullAddress = [fullAddress stringByAppendingString:@", "];
        fullAddress = [fullAddress stringByAppendingString: [self address8]];
    }
    return fullAddress;       
}


@end
