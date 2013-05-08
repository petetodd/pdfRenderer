//
//  BGSRenderModel1PDF.h
//  BGS PDF templates
//
//  Created by Peter Todd on 08/05/2013.
//  Copyright (c) 2013 BrightGreenStar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@interface BGSRenderModel1PDF : NSObject

- (NSURL*)drawReport:(NSString*)aFilename;

@property (strong, nonatomic) NSURL *fileToPrint;
@property (strong, nonatomic) UIDocument * docAsset;
@property (strong, nonatomic) UIDocument * doc;



@property CGRect frameRectTitle;
@property CGRect frameRectSubTitle;

@property CGRect frameRectLines;
@property CGRect frameRectFooter;

-(void)configureDataObjects;

@end
