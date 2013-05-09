//
//  BGSRenderModel1PDF.h
//  BGS PDF templates
//
//  Created by Peter Todd on 08/05/2013.
//  Copyright (c) 2013 BrightGreenStar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "BGSDocumentProperty.h"
#import "BGSDocumentInventory.h"

@interface BGSRenderModel1PDF : NSObject

- (NSURL*)drawReport:(NSString*)aFilename;

@property (strong, nonatomic) NSURL *fileToPrint;
// docAsset contains header information that we want to print
@property (strong, nonatomic) BGSDocumentProperty * docAsset;
// docDetails contains multiple page detail information that we want to print including variable length text
@property (strong, nonatomic) BGSDocumentInventory * docDetail;


@property CGRect framePage;


@property CGRect frameRectTitle;
@property CGRect frameRectSubTitle;

@property CGRect frameRectLines;
@property CGRect frameRectFooter;

-(void)configureDataObjects;

@end
