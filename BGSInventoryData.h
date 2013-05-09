//
//  BGSInventoryData.h
//  Lets Inventory
//
//  Created by Peter Todd on 11/04/2013.
//  Copyright (c) 2013 BrightGreenStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BGSInventoryData : NSObject<NSCoding>

//Internal reference number
@property (strong, nonatomic) NSString * propertyDocID;

@property (strong, nonatomic) NSString * inventoryDocID;

// Image of selected property for inventory
@property (strong, nonatomic) UIImage *propertyPhoto1;


// Client defined reference ID
@property (strong, nonatomic) NSString * inventoryReference;
@property (strong, nonatomic) NSString * propertyReference;


// What type of inventory  Check In / Check Out / Interim
@property (strong, nonatomic) NSString * inventoryType;


// General Summary - an NSMutableDictionary of key pairs
@property (strong, nonatomic) NSMutableDictionary *generalSummaryItems;
@property (strong, nonatomic) NSString *generalSummaryDescription;


// Inventory Status - OPEN / COMPLETE
@property (strong, nonatomic) NSString * inventoryStatus;

// Tenant present during inventory? YES / NO
@property (strong, nonatomic) NSString * tenantPresent;

// Tenancy details
@property (strong, nonatomic) NSDate * tenancyStart;
@property (strong, nonatomic) NSDate * tenancyEnd;
@property (strong, nonatomic) NSString * tenantNames;


// Inventory Dates
@property (strong, nonatomic) NSDate * inventoryDueDate;
@property (strong, nonatomic) NSDate * inventoryScheduledDate;
@property (strong, nonatomic) NSDate * inventoryCompletedDate;


@end
