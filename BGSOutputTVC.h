//
//  BGSOutputTVC.h
//  BGS PDF templates
//
//  Created by Peter Todd on 08/05/2013.
//  Copyright (c) 2013 BrightGreenStar. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol BGSOutputTVCDelegate <NSObject>
- (void)passSelectionMessage:(NSString *)delegateMessage;
- (NSURL*)preparePrintOutput:(NSString *)delegateMessage;
@end



@interface BGSOutputTVC : UITableViewController<UIPrintInteractionControllerDelegate>

@property int heightTable;
@property(strong, nonatomic) id <BGSOutputTVCDelegate> delegate;
@property (strong, nonatomic) NSURL *fileToPrint;
@property (strong, nonatomic) UINavigationController *myNav;

- (IBAction)cancelAction:(id)sender;



@end
