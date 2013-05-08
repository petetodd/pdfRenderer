//
//  BGSViewController.h
//  BGS PDF templates
//
//  Created by Peter Todd on 08/05/2013.
//  Copyright (c) 2013 BrightGreenStar. All rights reserved.
//

#import <UIKit/UIKit.h>
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
// @property (strong, nonatomic) BGSDocumentInventory * doc;
// For demo use a plain UIDoc
@property (strong, nonatomic) UIDocument * doc;
@property (strong, nonatomic) UIDocument * docAsset;


- (IBAction)outputAction:(id)sender;



@end
