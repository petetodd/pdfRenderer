//
//  NSDate+FormattedStrings.m
//  PhotoCaptioner
//
//  Created by Ray Wenderlich on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
// Ref: http://www.raywenderlich.com/12779/icloud-and-uidocument-beyond-the-basics-part-1


#import "NSDate+FormattedStrings.h"

@implementation NSDate (FormattedStrings)

- (NSString *)mediumString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDoesRelativeDateFormatting:YES];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    return [dateFormatter stringFromDate:self];
}

@end