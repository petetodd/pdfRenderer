//
//  BGSPropertyData.h
//  Lets Inventory
//
//  Created by Peter Todd on 02/04/2013.
//  Copyright (c) 2013 BrightGreenStar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGSAddressData.h"

@interface BGSPropertyData : NSObject <NSCoding>

//Internal reference number
@property (strong, nonatomic) NSString * propertyDocID;

// Client defined reference ID
@property (strong, nonatomic) NSString * propertyReference;

// Prperty Description
@property (strong, nonatomic) NSString *propertyDescription;
@property (strong, nonatomic) UIImage *propertyPhoto1;
@property (strong, nonatomic) UIImage *propertyPhoto2;
@property (strong, nonatomic) UIImage *propertyPhoto3;
@property (strong, nonatomic) UIImage *propertyPhoto4;
@property (strong, nonatomic) UIImage *propertyPhoto5;
@property (strong, nonatomic) UIImage *propertyPhoto6;


// Purchase details
@property (strong, nonatomic) NSDate * purchaseDate;
@property (strong, nonatomic) NSDecimalNumber * purchasePrice;
@property (strong, nonatomic) NSString * purchaseCurrency;

// Address
@property (strong,nonatomic) BGSAddressData *propertyAddress;

// Property status (Inventory due etc)
@property (strong, nonatomic) NSString * propertyStatus;

// Inventory due
@property (strong, nonatomic) NSDate * inventoryDate;

// Details:
@property (strong, nonatomic) NSString *propertyType;
@property (strong, nonatomic) NSNumber *bedrooms;
@property (strong, nonatomic) NSNumber *bathroom;
@property (strong, nonatomic) NSNumber *receptionRooms;
@property (strong, nonatomic) NSString *heatingType;
@property (strong, nonatomic) NSNumber *garage;
@property (strong, nonatomic) NSNumber *garden;
@property (strong, nonatomic) NSNumber *garden2;



@end
