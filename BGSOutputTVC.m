//
//  BGSOutputTVC.m
//  BGS PDF templates
//
//  Created by Peter Todd on 08/05/2013.
//  Copyright (c) 2013 BrightGreenStar. All rights reserved.
//

#import "BGSOutputTVC.h"

@interface BGSOutputTVC ()

@end

@implementation BGSOutputTVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    // Set the size of the popup that will display TV
    [self setHeightTable:145];
    // [self.navigationController.navigationItem setTitle:@"Save and Output"];
    //    [self setMyNav:[self navigationController]];
}

- (void)viewWillAppear:(BOOL)animated{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row == 0){
        cell.textLabel.text = @"Email Document";
        cell.imageView.image = [UIImage imageNamed:@"mail50.png"];
        //   cell.detailTextLabel.text = @"Email document";
    }
    
    if (indexPath.row == 1){
        cell.textLabel.text = @"Print Document";
        cell.imageView.image = [UIImage imageNamed:@"print50.png"];
        
        //   cell.detailTextLabel.text = @"Print Doc";
        //   [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
    }
    
    
    
    
    
    /*
     static NSString *CellIdentifier = @"Cell";
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
     */
    // Configure the cell...
    
    return cell;
}


#pragma mark - Table view delegate



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0){
        [self.delegate passSelectionMessage:@"EMAIL"];
    }
    
    if (indexPath.row == 1){
        [self setFileToPrint:[self.delegate preparePrintOutput:@"PRINT"]];
        
        if([self fileToPrint]){
            //   [self.navigationController pushViewController:[self printInteractionControllerParentViewController:[self printContent]] animated:YES];
            void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
                if (!completed && error) {
                    //              NSLog(@"DEBUG FAILED! due to error in domain %@ with error code %u", error.domain, error.code);
                }
            };
            
            //      [printController presentAnimated:YES completionHandler:completionHandler];
            
            
            // Not valid on iPhone
            //  [[self printContent] presentAnimated:YES completionHandler:completionHandler];
            
            // so try this -
            [[self printContent] presentFromRect:[self.view frame] inView:self.view animated:NO completionHandler:completionHandler];
            
        }else{
            // Do nothing - earlier alerts will inform user.  If we include a new alert here the user will be presented with multiple alerts
        }
        
    }
    
    
}




- (UIPrintInteractionController *)printContent {
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    if  (pic && [UIPrintInteractionController canPrintURL:[self fileToPrint]]) {
        pic.delegate = self;
        
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        printInfo.jobName = @"DemoPrint";;
        printInfo.duplex = UIPrintInfoDuplexLongEdge;
        pic.printInfo = printInfo;
        pic.showsPageRange = YES;
        pic.printingItem = self.fileToPrint;
    }
    return pic;
}

- (UIViewController *)printInteractionControllerParentViewController:(UIPrintInteractionController *)printInteractionController{
    return self.navigationController;
}



- (IBAction)cancelAction:(id)sender {
    [self.delegate passSelectionMessage:@"CANCEL"];
    
}

@end
