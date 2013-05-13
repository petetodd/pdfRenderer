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
    int _yOffSetPage1Header;
    int _yOffSetPage1Footer;
    int _yOffSet;

}

-(void)configureDataObjects{
    // Configure Details Items
    // An open doc should be passed to this class
    _generalSummaryItems = [[NSMutableDictionary alloc]init];
//    _generalSummaryItems = [self.doc generalSummaryItems];
}

- (NSURL*)drawReport:(NSString*)aFilename
{
    // Creates a mutable data object for updating with binary data
    NSMutableData *pdfData = [NSMutableData data];
    
    // Create the PDF context using the default page size of 612 x 792.
    UIGraphicsBeginPDFContextToData(pdfData,CGRectZero, nil);
    
    // Mark the beginning of a new page.
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);
    
    // Get the graphics context.
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    [self page1Setup];

    // Put the text matrix into a known state. This ensures
    // that no old scaling factors are left in place.
    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
    

    
    
    
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

- (void)page1Setup{
    // Add a frame around the page
    [self pageFrame];
    
    // Add a title section at the top of Page 1 - this will be used for logos
    [self page1Title];

    // Add a page 1 footer
    [self page1Footer];
    
    
    // Populate the Page 1 center frame (area between header and footer)
    [self page1Body];
    
    
}

// Create a page frame - setting the line width color etc.

- (void)pageFrame{
    // Get the graphics context.
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    // Set the frame line thickness and color
    CGContextBeginPath(currentContext);
    CGContextSetLineWidth(currentContext, 0.5);
    CGContextSetStrokeColorWithColor(currentContext, [UIColor lightGrayColor].CGColor);
    // Create the frame rect - 5 pixel margin
    self.framePage = CGRectMake(5, 5, 607, 787);
    // Draw the rectangle
    CGContextMoveToPoint(currentContext, self.framePage.origin.x, self.framePage.origin.y);
    CGContextAddLineToPoint(currentContext, self.framePage.size.width, self.framePage.origin.y);
    CGContextAddLineToPoint(currentContext, self.framePage.size.width, self.framePage.size.height);
    CGContextAddLineToPoint(currentContext, self.framePage.origin.x, self.framePage.size.height);
    CGContextAddLineToPoint(currentContext, self.framePage.origin.x,self.framePage.origin.y);
    // CGContextStrokePath also clears path after drawing
    CGContextStrokePath(currentContext);   
}

// Create a page 1 title frame
// This will be a fixed area used for logos and company info
- (void)page1Title{
    // Set the height of the image area
    _yOffSetPage1Header = 150;
    // Get the graphics context.
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    // Set the frame line thickness and color
    CGContextBeginPath(currentContext);
    CGContextSetLineWidth(currentContext, 0.5);
    CGContextSetStrokeColorWithColor(currentContext, [UIColor lightGrayColor].CGColor);
    // Create the frame rect - 5 pixel margin
    // Draw a line
    CGContextMoveToPoint(currentContext, self.framePage.origin.x, (self.framePage.origin.y + _yOffSetPage1Header));
    CGContextAddLineToPoint(currentContext, self.framePage.size.width, (self.framePage.origin.y + _yOffSetPage1Header));
    // CGContextStrokePath also clears path after drawing
    CGContextStrokePath(currentContext);
}

// Create a page 1 footer frame
// This will be a fixed area used for further details : contact email, www etc.
- (void)page1Footer{
    // Set the height of the image area
    _yOffSetPage1Footer = 150;
    // Get the graphics context.
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    // Set the frame line thickness and color
    CGContextBeginPath(currentContext);
    CGContextSetLineWidth(currentContext, 0.5);
    CGContextSetStrokeColorWithColor(currentContext, [UIColor greenColor].CGColor);
    // Create the frame rect - 5 pixel margin
    // Draw a line
    CGContextMoveToPoint(currentContext, self.framePage.origin.x, (self.framePage.origin.y +  self.framePage.size.height - _yOffSetPage1Footer));
    CGContextAddLineToPoint(currentContext, self.framePage.size.width, (self.framePage.origin.y +  self.framePage.size.height - _yOffSetPage1Footer));
    // CGContextStrokePath also clears path after drawing
    CGContextStrokePath(currentContext);
}

- (void)page1Body{
    // Report Reference
    CGRect rectTitleRef = CGRectMake((self.framePage.origin.x +3),(self.framePage.origin.y + _yOffSetPage1Header + 25), 300, 22);
    NSString* reportRef = @"Report Reference: ";
    if([self.docAsset  propertyReference]){
        reportRef = [reportRef stringByAppendingString:[self.docAsset  propertyReference]];
    }
    [self drawText:reportRef inFrame:rectTitleRef formatOption:@"H1" ];
    
    // Report Detail Reference
    CGRect rectDetailRef = CGRectMake((self.framePage.origin.x +3),(rectTitleRef.origin.y + 25), 300, 22);
    NSString* detailRef = @"Report Detail Ref: ";
    if([self.docDetail  inventoryReference]){
        detailRef = [detailRef stringByAppendingString:[self.docDetail  inventoryReference]];
    }
    [self drawText:detailRef inFrame:rectDetailRef formatOption:@"H1" ];
    
    // Report Date
    _yOffSetPage1Header = _yOffSetPage1Header + 25;
    CGRect rectDateReport = CGRectMake((self.framePage.origin.x +403),(self.framePage.origin.y + _yOffSetPage1Header), 200, 22);
    
    NSString* reportDate = @"Report Date: ";
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd MMMM yyyy"];
    NSString *reportDateStr = [dateFormat stringFromDate:[NSDate date]];
    reportDate = [reportDate stringByAppendingString:reportDateStr];
    [self drawText:reportDate inFrame:rectDateReport formatOption:@"H1" ];
    
    // Report Page 1 Body Photo.
    // Create a 300 * 300 box
    int photoBoxX = (self.framePage.size.width - 300) /2;
    _yOffSetPage1Header = _yOffSetPage1Header + 50;

    CGRect rectPage1MainPhoto = CGRectMake(photoBoxX,(self.framePage.origin.y + _yOffSetPage1Header), 300, 300);
    UIImage *photo1;
    if([self.docAsset  propertyPhoto1]){
        photo1 = [self.docAsset  propertyPhoto1];
    }else{
        // Default image
        photo1 = [UIImage imageNamed:@"defaultPhoto1.png"];
    }
    [self drawPhotoInRect:rectPage1MainPhoto drawPhoto:photo1];
    


    
    
}

- (void)drawPhotoInRect:(CGRect)photoRect drawPhoto:(UIImage*)photoToDraw{
    
  //  UIImageView *iv; // your image view
    CGSize imageSize = photoToDraw.size;
    CGFloat imageScale = fminf(photoRect.size.width/imageSize.width, photoRect.size.height/imageSize.height);
    CGSize scaledImageSize = CGSizeMake(imageSize.width*imageScale, imageSize.height*imageScale);
    // The scaling should ensure the image does not fall outside the bounding CGRECT
    float revisedXOrigin = photoRect.origin.x + ((scaledImageSize.width - photoRect.size.width)/2);
    float revisedYOrigin = photoRect.origin.y - ((scaledImageSize.height - photoRect.size.height)/2);

    CGRect imageFrame = CGRectMake(revisedXOrigin, revisedYOrigin, scaledImageSize.width, scaledImageSize.height);

    
    [photoToDraw drawInRect:imageFrame];
  
    
}





#pragma mark - 
#pragma mark DRAW TEXT
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


#pragma mark -
#pragma mark Utilities
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






@end
