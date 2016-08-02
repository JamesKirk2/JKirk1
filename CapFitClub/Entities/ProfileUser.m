//
//  ProfileUser.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 11/03/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "ProfileUser.h"

@implementation ProfileUser

// Insert code here to add functionality to your managed object subclass
- (void)setAttributes:(NSDictionary *)attributes {
    
    NSString *loginId = attributes[@"login_id"];
    if (loginId) {
        self.loginId = [[self checkIfNull:loginId] lowercaseString];
    }
    NSString *email = attributes[@"email"];
    if (email) {
        self.emailAddress = [self checkIfNull:email];
    }
    NSString *firstName = attributes[@"first_name"];
    if (firstName) {
        self.firstName = [self checkIfNull:firstName];
    }
    NSString *lastName = attributes[@"last_name"];
    if (lastName) {
        self.lastName = [self checkIfNull:lastName];
    }
    NSString *gender = attributes[@"gender"];
    if (gender) {
        self.gender = [self checkIfNull:gender];
    }
    NSString *profileImageURL = attributes[@"profile_image_url"];
    if (profileImageURL) {
        self.profileImageURL = [self checkIfNull:profileImageURL];
    }
    NSNumber *userId = attributes[@"user_id"];
    if (userId) {
        self.userId = [self checkIfNull:userId];
    }
    NSNumber *dateOfBirth = attributes[@"date_of_birth"];
    if (dateOfBirth) {
        long long dateInterval = [[self checkIfNull:dateOfBirth] longLongValue];
        self.dateOfBirth = [NSDate dateWithTimeIntervalSince1970:dateInterval];
    }
    NSNumber *fId = attributes[@"fid"];
    if (fId) {
//        self.fId = [self checkIfNull:fId];
    }
}

- (id)checkIfNull:(id)value {
    if (!value || [value isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return value;
}
@end
