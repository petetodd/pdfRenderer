//
//  BGSViewController.h
//  BGS PDF templates
//
//  Created by Peter Todd on 08/05/2013.
//  Copyright (c) 2013 BrightGreenStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGSDocumentProperty.h"
#import "BGSDocumentInventory.h"
#import "BGSDocumentCompany.h"
// Print and Email selector
#import "BGSOutputTVC.h"

// Renderers
#import "BGSRenderModel1PDF.h"

// Email
#import<MessageUI/MessageUI.h>


@interface BGSViewController : UIViewController <MFMailComposeViewControllerDelegate, BGSOutputTVCDelegate>


// Printing
@property (strong, nonatomic) UIPopoverController *popoverController2;
@property (strong, nonatomic) BGSOutputTVC *outputTVC;
@property (strong, nonatomic) NSURL *fileToPrint;
@property (strong, nonatomic) UIBarButtonItem *printButton;

// Document(s) to print
// docAsset contains header information that we want to print
@property (strong, nonatomic) BGSDocumentProperty * docAsset;
// docDetails contains multiple page detail information that we want to print including variable length text
@property (strong, nonatomic) BGSDocumentInventory * docDetail;
// docCompany holds the company data
@property (strong, nonatomic) BGSDocumentCompany * docCompany;



- (IBAction)outputAction:(id)sender;



@end
