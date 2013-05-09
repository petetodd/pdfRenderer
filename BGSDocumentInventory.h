//
//  BGSDocumentInventory.h
//  Lets Inventory
//
//  Created by Peter Todd on 11/04/2013.
//  Copyright (c) 2013 BrightGreenStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGSInventoryMetaData.h"
#import "BGSInventoryData.h"

#define INVENTORY_EXTENSION @"ixp"


@interface BGSDocumentInventory : UIDocument
@property BOOL debug;

//Internal reference number
@property (strong, nonatomic) NSString * propertyDocID;
@property (strong, nonatomic) NSString * inventoryDocID;

// Client defined reference ID
@property (strong, nonatomic) NSString * inventoryReference;
@property (strong, nonatomic) NSString * propertyReference;




// What type of inventory  Check In / Check Out / Interim
@property (strong, nonatomic) NSString * inventoryType;



// General Summary - an NSMutableDictionary of key pairs
@property (strong, nonatomic) NSMutableDictionary *generalSummaryItems;
@property (strong, nonatomic) NSString *generalSummaryDescription;

// Inventory Status
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

// Metadata
// This ia accessed directly as app will not directly update so no undo functinality required
@property (nonatomic, strong) BGSInventoryMetaData * metadata;


- (NSString *) description;


@end
