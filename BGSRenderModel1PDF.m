//
//  BGSRenderModel1PDF.m
//  BGS PDF templates
//
//  Created by Peter Todd on 08/05/2013.
//  Copyright (c) 2013 BrightGreenStar. All rights reserved.
//

#import "BGSRenderModel1PDF.h"

@implementation BGSRenderModel1PDF{
    NSMutableDictionary * _generalSummaryItems;
}

-(void)configureDataObjects{
    // Configure Details Items
    // An open doc should be passed to this class
    _generalSummaryItems = [[NSMutableDictionary alloc]init];
//    _generalSummaryItems = [self.doc generalSummaryItems];
}

- (NSURL*)drawReport:(NSString*)aFilename
//This creates a simple screen shot.  But, it will only print what is visible visible.
{
    // Creates a mutable data object for updating with binary data, like a byte array
    NSMutableData *pdfData = [NSMutableData data];
    
    // Create the PDF context using the default page size of 612 x 792.
    UIGraphicsBeginPDFContextToData(pdfData,CGRectZero, nil);
    
    // Mark the beginning of a new page.
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);
    
    // Get the graphics context.
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    [self reportTitle];
    [self reportSubTitle];
    
    // Put the text matrix into a known state. This ensures
    // that no old scaling factors are left in place.
    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
    
    // Core Text draws from the bottom-left corner up, so flip
    // the current transform prior to drawing the invoice line.
    // CGContextTranslateCTM(currentContext, 0, 90);
    // CGContextScaleCTM(currentContext, 1.0, -1.0);
    [self reportDetailLines];
    
    //create a final footer
    //  [self invoiceFooter:@"FINAL" pageNbr:1];
    
    
    
    
    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
    
    // Retrieves the temp directory for the app
    // We don't want to keep the document for longer than this session
    NSURL *tmpDirURL = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
    NSURL *fileURL = [[tmpDirURL URLByAppendingPathComponent:aFilename] URLByAppendingPathExtension:@"pdf"];
    NSLog(@"fileURL: %@", [fileURL path]);
    [self setFileToPrint:fileURL];
    NSLog(@"self.fileToPrint: %@", [self.fileToPrint path]);
    
    // instructs the mutable data object to write its context to a file on disk
    [pdfData writeToURL:self.fileToPrint atomically:YES];
    
    return self.fileToPrint;
    
}

/*
 Create a title including Inventory date, type, Tenants present, property
 */
- (void)reportTitle{
    //    NSString* textToDraw = @"Report: ";
    
    // Get the graphics context.
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    // Draw a rectangle outline
    CGContextBeginPath(currentContext);
    CGContextSetLineWidth(currentContext, 2.0);
    CGContextSetStrokeColorWithColor(currentContext, [UIColor lightGrayColor].CGColor);
    
    // Title box definition and draw
    self.frameRectTitle = CGRectMake(0, 0, 610, 90);
    
    CGContextMoveToPoint(currentContext, 0, 0);
    CGContextAddLineToPoint(currentContext, 610, 0);
    CGContextAddLineToPoint(currentContext, 610, self.frameRectTitle.size.height);
    CGContextAddLineToPoint(currentContext, 0, self.frameRectTitle.size.height);
    CGContextAddLineToPoint(currentContext, 0, 0);
    
    CGContextStrokePath(currentContext);
    
    
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, self.frameRectTitle);
    
    // Report Reference
    CGRect testRectTitleRef = CGRectMake(3, 22, 300, 22);
    NSString* reportRef = @"Report Reference: ";

    [self drawText:reportRef inFrame:testRectTitleRef formatOption:@"H1" ];
    
    // Report Date
    CGRect rectDateInv = CGRectMake(350, 22, 300, 22);
    NSString* reportDate = @"Report Date: ";
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd MMMM yyyy"];
    NSString *reportDateStr = [dateFormat stringFromDate:[NSDate date]];
    reportDate = [reportDate stringByAppendingString:reportDateStr];
    [self drawText:reportDate inFrame:rectDateInv formatOption:@"H1" ];
   
}

-(void)reportSubTitle{
    // Get the graphics context.
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    //Calculate the size of the subtitle frame
    NSString *subTitleString = @"A big chunk of text could go in here.";
    int yOffset = 26;
    int nbrOfLines = 1;
    // Subtitle section header
    //Property Reference
    CGRect rectSubtitleHeader = CGRectMake(3, (self.frameRectTitle.size.height + yOffset), 190, 22);
    NSString* subTitleHeaderString = @" General State of Item";
    [self drawText:subTitleHeaderString inFrame:rectSubtitleHeader formatOption:@"H1" ];
    yOffset = yOffset + 26;
 
    if (subTitleString.length >= 75){
        // There will be > 1 line.
        nbrOfLines = ((subTitleString.length + 75)/75);
        //nbrOfLines = 2;
        yOffset = yOffset + (20 * (nbrOfLines -1) );
    }else{
        // Detail is just one line.
        yOffset = yOffset + 18;
    }
    // Draw a rectangle outline
    CGContextBeginPath(currentContext);
    CGContextSetLineWidth(currentContext, 2.0);
    CGContextSetStrokeColorWithColor(currentContext, [UIColor lightGrayColor].CGColor);
    
    self.frameRectSubTitle = CGRectMake(0, self.frameRectTitle.size.height, 610, yOffset);
    CGContextMoveToPoint(currentContext, 0, self.frameRectSubTitle.origin.y);
    CGContextAddLineToPoint(currentContext, 0, (self.frameRectSubTitle.origin.y + self.frameRectSubTitle.size.height));
    CGContextAddLineToPoint(currentContext, 610, (self.frameRectSubTitle.origin.y + self.frameRectSubTitle.size.height));
    CGContextAddLineToPoint(currentContext, 610, self.frameRectSubTitle.origin.y);
    
    CGContextStrokePath(currentContext);
    
    // Draw the text
    
    CGRect rectTemp = CGRectMake(10, (self.frameRectTitle.size.height + yOffset), 590, (nbrOfLines * 22));
    [self drawText:subTitleString inFrame:rectTemp formatOption:Nil ];
    
    
}


-(void)reportDetailLines{
    // Get the graphics context.
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    // Draw a rectangle outline
    CGContextBeginPath(currentContext);
    CGContextSetLineWidth(currentContext, 2.0);
    CGContextSetStrokeColorWithColor(currentContext, [UIColor lightGrayColor].CGColor);
    
    self.frameRectLines = CGRectMake(0, (self.frameRectTitle.size.height + self.frameRectSubTitle.size.height), 610, 600);
    
    
    CGContextMoveToPoint(currentContext, 0, self.frameRectLines.origin.y);
    CGContextAddLineToPoint(currentContext, 0, (self.frameRectLines.origin.y + self.frameRectLines.size.height));
    CGContextAddLineToPoint(currentContext, 610, (self.frameRectLines.origin.y + self.frameRectLines.size.height));
    CGContextAddLineToPoint(currentContext, 610, self.frameRectLines.origin.y);
    
    CGContextStrokePath(currentContext);
}






-(void)reportFooter:(NSString*)footerType pageNbr:(int)pageNbrInv{
    // Get the graphics context.
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    // Draw a footer rectangle outline
    CGContextBeginPath(currentContext);
    CGContextSetLineWidth(currentContext, 2.0);
    CGContextSetStrokeColorWithColor(currentContext, [UIColor lightGrayColor].CGColor);
    
    self.frameRectFooter = CGRectMake(0, (self.frameRectTitle.size.height + self.frameRectLines.size.height), 610, 100);
    
    CGContextMoveToPoint(currentContext, 0, self.frameRectFooter.origin.y);
    CGContextAddLineToPoint(currentContext, 0, (self.frameRectFooter.origin.y + self.frameRectFooter.size.height));
    CGContextAddLineToPoint(currentContext, 610, (self.frameRectFooter.origin.y + self.frameRectFooter.size.height));
    CGContextAddLineToPoint(currentContext, 610, self.frameRectFooter.origin.y);
    
    CGContextStrokePath(currentContext);
    
    //   int yOffset = 20;
    CGRect rectTemp;
    NSString* rectTempContent;
    
    
    
    if ([footerType isEqualToString:@"MULTI"]){
        // Add the page number and text to show this is a multipage invoice
        rectTemp = CGRectMake(3,(self.frameRectFooter.origin.y + 50), 400, 22);
        rectTempContent = @"Report Continues on next page.";
        [self drawText:rectTempContent inFrame:rectTemp formatOption:nil ];
        rectTempContent = @"";
        
        rectTemp = CGRectMake(500, (self.frameRectFooter.origin.y + 70), 200, 22);
        rectTempContent = @"Page: ";
        NSString *stringPageNbr = [NSString stringWithFormat:@"%d", pageNbrInv];
        if(stringPageNbr){
            rectTempContent = [rectTempContent stringByAppendingString:stringPageNbr];
        }
        [self drawText:rectTempContent inFrame:rectTemp formatOption:nil ];
        
        rectTempContent = @"";
    }
    
    if ([footerType isEqualToString:@"FINAL"]){
        // Add the Notes and Invoice Totals
        // How many line do the notes Require?
        rectTempContent = @"SOME FOOTER STUFF";
        
        if (rectTempContent){
            rectTemp = CGRectMake(3,(self.frameRectFooter.origin.y + 90), 450, 90);
            [self drawText:rectTempContent inFrame:rectTemp formatOption:@"LineDesc" ];
            rectTempContent = @"";
        }
    }
}

- (void) createNewPage{
    // Mark the beginning of a new page.
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);
    // Get the graphics context.
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    // Invoice Header rectange
    // Draw a rectangle outline
    CGContextBeginPath(currentContext);
    CGContextSetLineWidth(currentContext, 2.0);
    CGContextSetStrokeColorWithColor(currentContext, [UIColor lightGrayColor].CGColor);
    
    // CGRect frameRectTitle;
    self.frameRectTitle = CGRectMake(0, 0, 610, 50);
    /*
     if (self.includeSupplerDetails){
     self.frameRectTitle = CGRectMake(0, 0, 610, 90);
     }else{
     self.frameRectTitle = CGRectMake(0, 0, 610, 50);
     }
     */
    CGContextMoveToPoint(currentContext, 0, 0);
    CGContextAddLineToPoint(currentContext, 610, 0);
    CGContextAddLineToPoint(currentContext, 610, self.frameRectTitle.size.height);
    CGContextAddLineToPoint(currentContext, 0, self.frameRectTitle.size.height);
    CGContextAddLineToPoint(currentContext, 0, 0);
    
    
    CGContextStrokePath(currentContext);
    
    CGRect testRectTitleRef = CGRectMake(3, 22, 300, 22);
    NSString* reportRef = @"Report Ref: ";

    [self drawText:reportRef inFrame:testRectTitleRef formatOption:@"H1" ];
    
    CGRect rectDateInv = CGRectMake(350, 22, 300, 22);
    
    NSString* reportDate = @"Report Date: ";
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd MMMM yyyy"];
    NSString *reportDateStr = [dateFormat stringFromDate:[NSDate date]];
    reportDate = [reportDate stringByAppendingString:reportDateStr];
    [self drawText:reportDate inFrame:rectDateInv formatOption:@"H1" ];
    
    
    
    CGRect rectDateDue = CGRectMake(350, 40, 300, 22);
    NSString* invoiceDateDue = @"Test 1: ";
    
    [self drawText:invoiceDateDue inFrame:rectDateDue formatOption:@"H1" ];
    
    
    
    // Invoice Line rectange
    CGContextBeginPath(currentContext);
    CGContextSetLineWidth(currentContext, 2.0);
    CGContextSetStrokeColorWithColor(currentContext, [UIColor lightGrayColor].CGColor);
    
    self.frameRectLines = CGRectMake(0, self.frameRectTitle.size.height, 610, 600);
    
    
    CGContextMoveToPoint(currentContext, 0, self.frameRectLines.origin.y);
    CGContextAddLineToPoint(currentContext, 0, (self.frameRectLines.origin.y + self.frameRectLines.size.height));
    CGContextAddLineToPoint(currentContext, 610, (self.frameRectLines.origin.y + self.frameRectLines.size.height));
    CGContextAddLineToPoint(currentContext, 610, self.frameRectLines.origin.y);
    
    CGContextStrokePath(currentContext);
    
}

-(void)drawText:(NSString*)textToDraw inFrame:(CGRect)frameRect formatOption:(NSString*)formatString
{
    if (!textToDraw){
        return;
    }
    //    CFStringRef stringRef = (__bridge CFStringRef)textToDraw;
    NSAttributedString *stringToDraw;
    
    //Formating
    if ([formatString isEqualToString:@"H1"]){
        UIColor *textColor = [UIColor blueColor];
        CGColorRef color = textColor.CGColor;
        CTFontRef font = CTFontCreateWithName((CFStringRef) @"HelveticaNeue-Bold", 14.0, NULL);
        CTTextAlignment theAlignment = kCTLeftTextAlignment;
        
        CFIndex theNumberOfSettings = 1;
        CTParagraphStyleSetting theSettings[1] =
        {
            { kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment),
                &theAlignment }
        };
        
        CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(theSettings, theNumberOfSettings);
        
        NSDictionary *attributesDict = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)(font), (NSString *)kCTFontAttributeName,
                                        color, (NSString *)kCTForegroundColorAttributeName,
                                        paragraphStyle, (NSString *) kCTParagraphStyleAttributeName,
                                        nil];
        
        stringToDraw = [[NSAttributedString alloc] initWithString:textToDraw attributes:attributesDict];
    } else if ([formatString isEqualToString:@"H2"]){
        UIColor *textColor = [UIColor blueColor];
        CGColorRef color = textColor.CGColor;
        CTFontRef font = CTFontCreateWithName((CFStringRef) @"HelveticaNeue", 16.0, NULL);
        CTTextAlignment theAlignment = kCTLeftTextAlignment;
        
        CFIndex theNumberOfSettings = 1;
        CTParagraphStyleSetting theSettings[1] =
        {
            { kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment),
                &theAlignment }
        };
        
        CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(theSettings, theNumberOfSettings);
        
        NSDictionary *attributesDict = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)(font), (NSString *)kCTFontAttributeName,
                                        color, (NSString *)kCTForegroundColorAttributeName,
                                        paragraphStyle, (NSString *) kCTParagraphStyleAttributeName,
                                        nil];
        
        stringToDraw = [[NSAttributedString alloc] initWithString:textToDraw attributes:attributesDict];
    } else if ([formatString isEqualToString:@"H3"]){
        UIColor *textColor = [UIColor blackColor];
        CGColorRef color = textColor.CGColor;
        CTFontRef font = CTFontCreateWithName((CFStringRef) @"HelveticaNeue-Regular", 13.0, NULL);
        CTTextAlignment theAlignment = kCTLeftTextAlignment;
        
        CFIndex theNumberOfSettings = 1;
        CTParagraphStyleSetting theSettings[1] =
        {
            { kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment),
                &theAlignment }
        };
        
        CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(theSettings, theNumberOfSettings);
        
        NSDictionary *attributesDict = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)(font), (NSString *)kCTFontAttributeName,
                                        color, (NSString *)kCTForegroundColorAttributeName,
                                        paragraphStyle, (NSString *) kCTParagraphStyleAttributeName,
                                        nil];
        
        stringToDraw = [[NSAttributedString alloc] initWithString:textToDraw attributes:attributesDict];
    } else if ([formatString isEqualToString:@"LineDesc"]){
        UIColor *textColor = [UIColor blackColor];
        CGColorRef color = textColor.CGColor;
        CTFontRef font = CTFontCreateWithName((CFStringRef) @"HelveticaNeue-Italic", 13.0, NULL);
        CTTextAlignment theAlignment = kCTLeftTextAlignment;
        
        CFIndex theNumberOfSettings = 1;
        CTParagraphStyleSetting theSettings[1] =
        {
            { kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment),
                &theAlignment }
        };
        
        CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(theSettings, theNumberOfSettings);
        
        NSDictionary *attributesDict = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)(font), (NSString *)kCTFontAttributeName,
                                        color, (NSString *)kCTForegroundColorAttributeName,
                                        paragraphStyle, (NSString *) kCTParagraphStyleAttributeName,
                                        nil];
        
        stringToDraw = [[NSAttributedString alloc] initWithString:textToDraw attributes:attributesDict];
    }else if ([formatString isEqualToString:@"GrossAmount"]){
        UIColor *textColor = [UIColor blackColor];
        CGColorRef color = textColor.CGColor;
        CTFontRef font = CTFontCreateWithName((CFStringRef) @"HelveticaNeue-Bold", 14.0, NULL);
        CTTextAlignment theAlignment = kCTLeftTextAlignment;
        
        CFIndex theNumberOfSettings = 1;
        CTParagraphStyleSetting theSettings[1] =
        {
            { kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment),
                &theAlignment }
        };
        
        CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(theSettings, theNumberOfSettings);
        
        NSDictionary *attributesDict = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)(font), (NSString *)kCTFontAttributeName,
                                        color, (NSString *)kCTForegroundColorAttributeName,
                                        paragraphStyle, (NSString *) kCTParagraphStyleAttributeName,
                                        nil];
        
        stringToDraw = [[NSAttributedString alloc] initWithString:textToDraw attributes:attributesDict];
    }else if ([formatString isEqualToString:@"RightAlign"]){
        UIColor *textColor = [UIColor blackColor];
        CGColorRef color = textColor.CGColor;
        CTFontRef font = CTFontCreateWithName((CFStringRef) @"HelveticaNeue-Bold", 13.0, NULL);
        CTTextAlignment theAlignment = kCTRightTextAlignment;
        
        CFIndex theNumberOfSettings = 1;
        CTParagraphStyleSetting theSettings[1] =
        {
            { kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment),
                &theAlignment }
        };
        
        CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(theSettings, theNumberOfSettings);
        
        NSDictionary *attributesDict = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)(font), (NSString *)kCTFontAttributeName,
                                        color, (NSString *)kCTForegroundColorAttributeName,
                                        paragraphStyle, (NSString *) kCTParagraphStyleAttributeName,
                                        nil];
        
        stringToDraw = [[NSAttributedString alloc] initWithString:textToDraw attributes:attributesDict];
    }else if ([formatString isEqualToString:@"RightAlign_GROSS"]){
        UIColor *textColor = [UIColor blackColor];
        CGColorRef color = textColor.CGColor;
        CTFontRef font = CTFontCreateWithName((CFStringRef) @"HelveticaNeue-Bold", 14.0, NULL);
        CTTextAlignment theAlignment = kCTRightTextAlignment;
        
        CFIndex theNumberOfSettings = 1;
        CTParagraphStyleSetting theSettings[1] =
        {
            { kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment),
                &theAlignment }
        };
        
        CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(theSettings, theNumberOfSettings);
        
        NSDictionary *attributesDict = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)(font), (NSString *)kCTFontAttributeName,
                                        color, (NSString *)kCTForegroundColorAttributeName,
                                        paragraphStyle, (NSString *) kCTParagraphStyleAttributeName,
                                        nil];
        
        stringToDraw = [[NSAttributedString alloc] initWithString:textToDraw attributes:attributesDict];
    }else{
        UIColor *textColor = [UIColor blackColor];
        CGColorRef color = textColor.CGColor;
        CTFontRef font = CTFontCreateWithName((CFStringRef) @"HelveticaNeue", 14.0, NULL);
        CTTextAlignment theAlignment = kCTLeftTextAlignment;
        
        CFIndex theNumberOfSettings = 1;
        CTParagraphStyleSetting theSettings[1] =
        {
            { kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment),
                &theAlignment }
        };
        
        CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(theSettings, theNumberOfSettings);
        
        NSDictionary *attributesDict = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)(font), (NSString *)kCTFontAttributeName,
                                        color, (NSString *)kCTForegroundColorAttributeName,
                                        paragraphStyle, (NSString *) kCTParagraphStyleAttributeName,
                                        nil];
        
        stringToDraw = [[NSAttributedString alloc] initWithString:textToDraw attributes:attributesDict];
    }
    
    
    
    // End Formating
    
    
    // Prepare the text using a Core Text Framesetter.
    //  CFAttributedStringRef currentText = CFAttributedStringCreate(NULL, stringRef, NULL);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)(stringToDraw));
    
    
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, frameRect);
    
    // Get the frame that will do the rendering.
    CFRange currentRange = CFRangeMake(0, 0);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);
    
    // Get the graphics context.
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    
    // Put the text matrix into a known state. This ensures
    // that no old scaling factors are left in place.
    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
    
    // Core Text draws from the bottom-left corner up, so flip
    // the current transform prior to drawing.
    // CGContextTranslateCTM(currentContext, 0, 90);
    // CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    CGContextTranslateCTM(currentContext, 0, frameRect.origin.y*2);
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    // Draw the frame.
    CTFrameDraw(frameRef, currentContext);
    
    
    // Add these two lines to reverse the earlier transformation.
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    CGContextTranslateCTM(currentContext, 0, (-1)*frameRect.origin.y*2);
    
    CFRelease(frameRef);
    //    CFRelease(stringRef);
    CFRelease(framesetter);
}




- (NSString *) dateToFormattedString:(NSDate*)inDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@" MMM dd yyyy"];
    return [dateFormatter stringFromDate:inDate];
}

- (NSString *) floatToString:(float) val
{
    NSString *ret = [NSString stringWithFormat:@"%.2f", val];
    int index = (int)[ret length] - 1;
    BOOL trim = FALSE;
    while (
           (
            [ret characterAtIndex:index] == '.')
           &&
           index > 0)
    {
        index--;
        trim = TRUE;
    }
    if (trim)
        ret = [ret substringToIndex: index +1];
    return ret;
}

-(void)drawLineFromPoint:(CGPoint)from toPoint:(CGPoint)to
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 2.0);
    
    // CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    UIColor *textColor = [UIColor redColor];
    CGColorRef color = textColor.CGColor;
    
    CGContextSetStrokeColorWithColor(context, color);
    
    
    CGContextMoveToPoint(context, from.x, from.y);
    CGContextAddLineToPoint(context, to.x, to.y);
    
    CGContextStrokePath(context);
    //    CGColorSpaceRelease(colorspace);
    CGColorRelease(color);
    
}




@end
