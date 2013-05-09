//
//  BGSPropertyMetaData.h
//  Lets Inventory
//
//  Created by Peter Todd on 02/04/2013.
//  Copyright (c) 2013 BrightGreenStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BGSPropertyMetaData : NSObject <NSCoding>

// Images
@property (strong) UIImage * thumbnail1;
@property (strong) UIImage * thumbnail2;
@property (strong) UIImage * thumbnail3;
@property (strong) UIImage * thumbnail4;
@property (strong) UIImage * thumbnail5;
@property (strong) UIImage * thumbnail6;


//Internal reference number
@property (strong, nonatomic) NSString * propertyDocID;

// Client defined reference ID
@property (strong, nonatomic) NSString * propertyReference;

// Client defined reference ID
@property (strong, nonatomic) NSString * propertyStatus;


@end
