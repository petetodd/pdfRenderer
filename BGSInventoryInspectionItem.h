//
//  BGSInventoryInspectionItem.h
//  Lets Inventory
//
//  Created by Peter Todd on 13/04/2013.
//  Copyright (c) 2013 BrightGreenStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BGSInventoryInspectionItem : NSObject<NSCoding>

@property (strong, nonatomic) NSString * sectionTitle;
@property (strong, nonatomic) NSString * itemDesc;
@property (strong, nonatomic) NSString * itemValue;
@property (strong, nonatomic) NSString * includeItem;


// Item Photos
@property (strong, nonatomic) UIImage *itemPhoto1;
@property (strong, nonatomic) UIImage *itemPhoto2;
@property (strong, nonatomic) UIImage *itemPhoto3;
@property (strong, nonatomic) UIImage *itemPhoto4;
@property (strong, nonatomic) UIImage *itemPhoto5;
@property (strong, nonatomic) UIImage *itemPhoto6;




@end
