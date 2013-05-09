//
//  BGSInventoryMetaData.h
//  Lets Inventory
//
//  Created by Peter Todd on 11/04/2013.
//  Copyright (c) 2013 BrightGreenStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BGSInventoryMetaData : NSObject<NSCoding>

//Internal Inventory reference number
@property (strong, nonatomic) NSString * inventoryDocID;

//Internal Property reference number
@property (strong, nonatomic) NSString * propertyDocID;

// Client defined Inventory reference ID
@property (strong, nonatomic) NSString * inventoryReference;
@property (strong, nonatomic) NSString * propertyReference;

// What type of inventory  Check In / Check Out / Interim
@property (strong, nonatomic) NSString * inventoryType;

// Inventory status
@property (strong, nonatomic) NSString * inventoryStatus;

// Inventory Dates
@property (strong, nonatomic) NSDate * inventoryDueDate;
@property (strong, nonatomic) NSDate * inventoryScheduledDate;
@property (strong, nonatomic) NSDate * inventoryCompletedDate;

// Images
@property (strong) UIImage * thumbnail1;

@end
