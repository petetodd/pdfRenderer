//
//  BGSAddressData.h
//  Lets Inventory
//
//  Created by Peter Todd on 02/04/2013.
//  Copyright (c) 2013 BrightGreenStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BGSAddressData : NSObject  <NSCoding>

// Address
@property (strong) NSString * address1_number;
@property (strong) NSString * address2_street;
@property (strong) NSString * address3_city;
@property (strong) NSString * address4_county;
@property (strong) NSString * address5_state;
@property (strong) NSString * address6_zipcode;
@property (strong) NSString * address7;
@property (strong) NSString * address8;


- (NSString*) fullPropertyAddress;

@end
