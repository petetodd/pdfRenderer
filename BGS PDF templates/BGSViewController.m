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

@interface BGSViewController (){
    NSURL * _localRoot;

}

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
    // Clear existing docs - if they exist
    [self deleteExistingDocs];
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
    
 //   BGSRenderModel1PDF *reportRender = [[BGSRenderModel1PDF alloc]init];
    BGSRenderModel2 *reportRender =[[BGSRenderModel2 alloc]init];
    
    
    //  [self createPDFfromUIView:[self scrollView] saveToDocumentsWithFileName:@"outputFile"];
    [reportRender setDocDetail:[self docDetail]];
    if ([self docAsset]){
        [reportRender setDocAsset:[self docAsset]];
    }else{
        [reportRender setDocAsset:Nil];
    }
    if ([self docCompany]){
        [reportRender setDocCompany:[self docCompany]];
    }else{
        [reportRender setDocCompany:Nil];
    }
    
    
    [reportRender configureDataObjects];
    
    
    [self setFileToPrint:[reportRender drawReport:@"outputFile"]];
    return YES;
}


#pragma mark - Delete and Create Docs for testing
// The demo app uses local directory.  Live apps usually implement iCloud
- (NSURL *)localRoot {
    if (_localRoot != nil) {
        return _localRoot;
    }
    
    NSArray * paths = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    _localRoot = [paths objectAtIndex:0];
    return _localRoot;
}

// Add at end of "File management methods" section
- (void)deleteDoc:(NSURL *)docURL {
    // Wrap in file coordinator
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        NSError* error = nil;
        
        NSFileCoordinator* fileCoordinator = [[NSFileCoordinator alloc] initWithFilePresenter:nil];
        [fileCoordinator coordinateWritingItemAtURL:docURL
                                            options:NSFileCoordinatorWritingForDeleting
                                              error:&error
                                         byAccessor:^(NSURL* writingURL) {
                                             if (error != nil) {
                                                 NSLog(@"DEBUG Deleting Error with %@! %@", docURL, error);
                                                 return;
                                             }
                                             NSLog(@"DEBUG Deleting Got writingURL: %@", writingURL);
                                             // Simple delete
                                             NSFileManager* fileManager = [[NSFileManager alloc] init];
                                             [fileManager removeItemAtURL:docURL error:nil];
                                         }];
    });
}

- (void)deleteExistingDocs{
    // Property
    NSString *docFilename = [NSString stringWithFormat:@"PropertyDemoDoc.%@",PROPERTY_EXTENSION];
    NSURL * fileURL = [self.localRoot URLByAppendingPathComponent:docFilename];
    // If the doc exists remove it
    [self deleteDoc:fileURL];
    
    // Detail
    docFilename = [NSString stringWithFormat:@"DetailDemoDoc.%@",INVENTORY_EXTENSION];
    fileURL = [self.localRoot URLByAppendingPathComponent:docFilename];
    // If the doc exists remove it
    [self deleteDoc:fileURL];
    
    // Company
    docFilename = [NSString stringWithFormat:@"CompanyDemoDoc.%@",COMPANY_EXTENSION];
    fileURL = [self.localRoot URLByAppendingPathComponent:docFilename];
    // If the doc exists remove it
    [self deleteDoc:fileURL];
    

}

- (void)createtNewDocs
{
    NSLog(@"DEBUG createtNewDocs");

    NSString *docFilename = [NSString stringWithFormat:@"PropertyDemoDoc.%@",PROPERTY_EXTENSION];
    NSURL * fileURL = [self.localRoot URLByAppendingPathComponent:docFilename];
    // If the doc exists remove it

    // Create new document and save to the filename
    BGSDocumentProperty * doc = [[BGSDocumentProperty alloc] initWithFileURL:fileURL];
    doc.debug = NO;
    [doc setPropertyReference:@"NEW PROPERTY"];
    [doc setPropertyDocID:[[fileURL lastPathComponent] stringByDeletingPathExtension]];
    [doc setPropertyPhoto1:[UIImage imageNamed:@"demo1.png"]];
    [doc setPropertyPhoto2:[UIImage imageNamed:@"demo2.png"]];
    [doc setPropertyPhoto3:[UIImage imageNamed:@"demo3.png"]];
    [doc setPropertyPhoto4:[UIImage imageNamed:@"demo4.png"]];
    [doc setPropertyPhoto5:[UIImage imageNamed:@"demo5.png"]];
    [doc setPropertyPhoto6:[UIImage imageNamed:@"demo6.png"]];
    
    BGSAddressData *testAddress = [[BGSAddressData alloc]init];
    [testAddress setAddress1_number:@"Ostia Antica"];
    [testAddress setAddress2_street:@"717 Via dei Romagnoli"];
    [testAddress setAddress3_city:@"Rome"];
    [testAddress setAddress5_state:@"Italy"];
    [doc setPropertyAddress:testAddress];

    
    
    
    [doc saveToURL:fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
        
        if (!success) {
            NSLog(@"Failed to create file at %@", fileURL);
            return;
        }
        NSLog(@"File created at %@", fileURL);
        // Add on the main thread and perform the segue
        self.docAsset = doc;
        NSLog(@"DEBUG doc PropertyReference %@", [doc propertyReference]);
        NSLog(@"DEBUG self.docAsset1 PropertyReference %@", [self.docAsset propertyReference]);
        // Now create the detail and then Segue
        [self createtNewDetailDoc];
        [self createtNewCompanyDoc];
    }];
}

- (void)createtNewDetailDoc
{
    NSLog(@"DEBUG createtNewDetailDoc");
    NSString *docFilename = [NSString stringWithFormat:@"DetailDemoDoc.%@",INVENTORY_EXTENSION];
    NSURL * fileURL = [self.localRoot URLByAppendingPathComponent:docFilename];
    // If the doc exists remove it
    
    // Create new document and save to the filename
    BGSDocumentInventory * doc = [[BGSDocumentInventory alloc] initWithFileURL:fileURL];
    doc.debug = NO;
    [doc setInventoryReference:@"NEW INVENTORY"];
    [doc setInventoryType:@"Test PDF generation and Email Attachment Functions"];
    [doc setInventoryDocID:[[fileURL lastPathComponent] stringByDeletingPathExtension]];
    [doc saveToURL:fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
        if (!success) {
            NSLog(@"Failed to create file at %@", fileURL);
            return;
        }
        NSLog(@"File created at %@", fileURL);
        // Add on the main thread and perform the segue
        self.docDetail = doc;
        NSLog(@"DEBUG inventoryReference %@", [self.docDetail inventoryReference]);
        // Segue will not run until document creation complete
  //      [self performSegueWithIdentifier:@"Report Output" sender:self];
    }];
}

- (void)createtNewCompanyDoc
{
    NSLog(@"DEBUG createtNewCompanyDoc");
    NSString *docFilename = [NSString stringWithFormat:@"CompanyDemoDoc.%@",COMPANY_EXTENSION];
    NSURL * fileURL = [self.localRoot URLByAppendingPathComponent:docFilename];
    // If the doc exists remove it
    
    // Create new document and save to the filename
    BGSDocumentCompany * doc = [[BGSDocumentCompany alloc] initWithFileURL:fileURL];
    doc.debug = NO;
    [doc setCompanyWWW:@"www.petertodd.com"];
    [doc setCompanyEmail:@"peter@petertodd.com"];
    [doc setCompanyName:@"Bright Green Star"];
    [doc setCompanyStrapline:@"Will work for Fish"];
    [doc setCompanyLogo:[UIImage imageNamed:@"demo_logo_header.png"]];
    BGSAddressData *testAddress = [[BGSAddressData alloc]init];
    [testAddress setAddress1_number:@"Ostia Antica"];
    [testAddress setAddress2_street:@"717 Via dei Romagnoli"];
    [testAddress setAddress3_city:@"Rome"];
    [testAddress setAddress5_state:@"Italy"];
    [doc setCompanyAddress:testAddress];
    [doc saveToURL:fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
        if (!success) {
            NSLog(@"Failed to create file at %@", fileURL);
            return;
        }
        NSLog(@"File created at %@", fileURL);
        // Add on the main thread and perform the segue
        self.docCompany = doc;
        NSLog(@"DEBUG inventoryReference %@", [self.docDetail inventoryReference]);
        // Segue will not run until document creation complete
        [self performSegueWithIdentifier:@"Report Output" sender:self];
    }];
}


#pragma mark - Button Action

- (IBAction)outputAction:(id)sender {
    [self createtNewDocs];
}
@end
