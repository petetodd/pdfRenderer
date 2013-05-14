//
//  BGSDocumentCompany.h
//  BGS PDF templates
//
//  Created by Peter Todd on 13/05/2013.
//  Copyright (c) 2013 BrightGreenStar. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "BGSPropertyData.h"
//#import "BGSPropertyMetaData.h"
#import "BGSAddressData.h"
#import "UIImageExtras.h"
#import "BGSCompanyData.h"

#define COMPANY_EXTENSION @"icp"



@interface BGSDocumentCompany : UIDocument

@property BOOL debug;

//Internal reference number
@property (strong, nonatomic) NSString * companyDocID;

@property (strong, nonatomic) NSString *companyName;
@property (strong, nonatomic) NSString *companyStrapline;
@property (strong, nonatomic) UIImage *companyLogo;
// Address
@property (strong,nonatomic) BGSAddressData *companyAddress;

// Contact Details
@property (strong, nonatomic) NSString *companyMainContact;
@property (strong, nonatomic) NSString *companyTel;
@property (strong, nonatomic) NSString *companyMobile;
@property (strong, nonatomic) NSString *companyEmail;
@property (strong, nonatomic) NSString *companyWWW;


- (NSString *) description;






@end
