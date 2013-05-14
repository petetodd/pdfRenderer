//
//  BGSRenderModel2.h
//  BGS PDF templates
//
//  Created by Peter Todd on 14/05/2013.
//  Copyright (c) 2013 BrightGreenStar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

#import "BGSDocumentCompany.h"
#import "BGSDocumentInventory.h"
#import "BGSDocumentProperty.h"

@interface BGSRenderModel2 : NSObject

// Called using DrawReport
- (NSURL*)drawReport:(NSString*)aFilename;


// Page Size selection width height
// US Letter  612 * 792
// ISO A4 595 * 842
@property (strong, nonatomic) NSString *pageSize;

// Outline Frame
@property CGRect framePage;



//Docs to hold data to be printed
// docAsset contains header information that we want to print
@property (strong, nonatomic) BGSDocumentProperty * docAsset;
// docDetails contains multiple page detail information that we want to print including variable length text
@property (strong, nonatomic) BGSDocumentInventory * docDetail;
// docCompany holds the company data
@property (strong, nonatomic) BGSDocumentCompany * docCompany;

// Configure the data objects
-(void)configureDataObjects;


@end
