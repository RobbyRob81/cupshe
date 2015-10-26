//
//  UpdateCustomerPaymentProfileRequest.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/7/11.
//  Copyright 2011 none. All rights reserved.
//

#import "UpdateCustomerPaymentProfileRequest.h"
#import "NSString+stringWithXMLTag.h"

@implementation UpdateCustomerPaymentProfileRequest
@synthesize paymentProfile;
@synthesize validationMode;

+ (UpdateCustomerPaymentProfileRequest *) updateCustomerPaymentProfileRequest {
	UpdateCustomerPaymentProfileRequest *u = [[UpdateCustomerPaymentProfileRequest alloc] init];
	return u;
}

- (id) init {
    self = [super init];
	if (self) {
        self.paymentProfile = nil;
        self.validationMode = NONE_MODE;
	}
	return self;
}

- (void) dealloc {
    self.paymentProfile = nil;
    
}

- (NSString *) description {
	NSString *output = [NSString stringWithFormat:@""
						"UpdateCustomerPaymentProfileRequest.anetApiRequest = %@\n"
                        "UpdateCustomerPaymentProfileRequest.paymentProfile = %@\n"
                        "UpdateCustomerPaymentProfileRequest.validationMode = %@\n",
						super.anetApiRequest,
                        (self.paymentProfile?[self.paymentProfile description]:@""),
                        [ValidationModes getValidationMode:self.validationMode]];
	return output;
}

- (NSString *) stringOfXMLRequest {
	NSString *s = [NSString stringWithFormat:@""
				   @"<?xml version=\"1.0\" encoding=\"utf-8\"?>" 
				   @"<updateCustomerPaymentProfileRequest xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns=\"AnetApi/xml/v1/schema/AnetApiSchema.xsd\">"
						@"%@"
                        @"<customerProfileId>%@</customerProfileId>"
                        @"%@"  //paymentProfile
                        @"<validationMode>%@</validationMode>"  //validationMode
				   @"</updateCustomerPaymentProfileRequest>",
				   [super.anetApiRequest stringOfXMLRequest],
                   self.customerProfileId,
                   [self.paymentProfile stringOfXMLRequest],
                   [ValidationModes getValidationMode:self.validationMode]];
    
	return s;
}

@end
