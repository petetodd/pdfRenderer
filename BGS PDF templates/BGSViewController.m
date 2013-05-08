//
//  BGSViewController.m
//  BGS PDF templates
//
//  Created by Peter Todd on 08/05/2013.
//  Copyright (c) 2013 BrightGreenStar. All rights reserved.
/*
 This app contains simple email/print PDF templates that I use and adapt in my code.
 You can use this
 
 */
 
#import "BGSViewController.h"

@interface BGSViewController ()

@end

@implementation BGSViewController{
    // Flag to stop return to a master listing when changes are saved prior to printing
    // - specific feature to some of my apps (can ignore if not relevant)
    BOOL _printModeEngaged;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([[segue identifier] isEqualToString:@"Report Output"]) {
        BGSOutputTVC *destVC = [segue destinationViewController];
        destVC.delegate = self;
    }
}


#pragma mark Output Delegate.

- (void)passSelectionMessage:(NSString *)delegateMessage{
    if ([delegateMessage isEqualToString:@"EMAIL"]){
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            [self.popoverController2 dismissPopoverAnimated:YES];
        }else{
            //  Set the flag to stop return to master when detail is saved before printing - only needed on non-iPad
            _printModeEngaged = YES;
            [self dismissViewControllerAnimated:(NO) completion:nil];
        }
        
        [self showEmail];
        
    }
    if ([delegateMessage isEqualToString:@"PRINT"]){
        //    [self.popoverController2 setContentViewController:[self printContent]];
    }
    
    if ([delegateMessage isEqualToString:@"CANCEL"]){
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            [self.popoverController2 dismissPopoverAnimated:YES];
        }else{
            //  Set the flag to stop return to master when detail is saved before printing - only needed on non-iPad
            _printModeEngaged = YES;
            [self dismissViewControllerAnimated:(NO) completion:nil];
        }
    }
}

- (NSURL*)preparePrintOutput:(NSString *)delegateMessage{
    if ([self printOutputAction]){
        return self.fileToPrint;
    }
    return nil;
    
}

- (void)showEmail {
    [self showEmailAction];
    
}

- (void) showEmailAction{
    if ([self printOutputAction]){
        // Email Subject
        NSString *emailTitle = @"Demo Output Title";
        
        // Email Content
        NSString *messageBody = @"Demo Output Message:";
        
        // To address
        NSArray *toRecipents = nil;
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        [mc setToRecipients:toRecipents];
        NSData* theFile = [NSData dataWithContentsOfURL:self.fileToPrint];
        [mc addAttachmentData:theFile mimeType:@"application/pdf" fileName:@"output.PDF"];
        
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];
    }
}


- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            //           NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            //            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            //            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            //           NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}



#pragma mark - Create Printfile for email and output
// Hide nav bar save when editing lines

- (BOOL)printOutputAction{

    // For demo no document is required.  
/*
    if(![self doc]){
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc]
                       initWithTitle: @"No Document Selected" message:@"Select a Document to Print or Email." delegate: nil cancelButtonTitle: @"Ok" otherButtonTitles: nil];
        [alertDialog show];
        return NO;
    }
 */
    
    BGSRenderModel1PDF *reportRender = [[BGSRenderModel1PDF alloc]init];
    
    //  [self createPDFfromUIView:[self scrollView] saveToDocumentsWithFileName:@"outputFile"];
    [reportRender setDoc:[self doc]];
    if ([self docAsset]){
        [reportRender setDocAsset:[self docAsset]];
    }else{
        [reportRender setDocAsset:Nil];
    }
    [reportRender configureDataObjects];
    
    
    [self setFileToPrint:[reportRender drawReport:@"outputFile"]];
    return YES;
}




#pragma mark - Button Action

- (IBAction)outputAction:(id)sender {
    [self performSegueWithIdentifier:@"Report Output" sender:self];
}
@end
