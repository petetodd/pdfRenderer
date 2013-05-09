//
//  UIImageExtras.m
//  BattleMap
//
//  Created by Ray Wenderlich on 5/27/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//
// Ref: http://www.raywenderlich.com/12779/icloud-and-uidocument-beyond-the-basics-part-1


#import "UIImageExtras.h"

@implementation UIImage (Extras)

- (UIImage*)imageByBestFitForSize:(CGSize)targetSize {
    
	CGFloat aspectRatio = (float) self.size.width / (float) self.size.height;
	
	CGFloat targetHeight = targetSize.height;
	CGFloat scaledWidth = targetSize.height * aspectRatio;
	CGFloat targetWidth = (targetSize.width < scaledWidth) ? targetSize.width : scaledWidth;
	
	return [self imageByScalingAndCroppingForSize:CGSizeMake(targetWidth, targetHeight)];
	
}

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;        
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) 
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor) 
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = ceil(width * scaleFactor);
        scaledHeight = ceil(height * scaleFactor);
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5; 
        }
        else 
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }       
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) 
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

@end
