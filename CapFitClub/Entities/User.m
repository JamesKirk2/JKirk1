//
//  User.m
//  
//
//  Created by Sumit Sancheti on 04/02/16.
//
//

#import "User.h"
#import "Activity.h"
#import "Challenge.h"

@implementation User

// Insert code here to add functionality to your managed object subclass
- (void)setAttributes:(NSDictionary *)attributes {
    
    self.userId = [self checkIfNull:attributes[@"uid"]];
    self.firstName = [self checkIfNull:attributes[@"firstname"]];
    self.lastName = [self checkIfNull:attributes[@"lastname"]];
    self.profileImageURL = [self checkIfNull:attributes[@"profileimageurl"]];
}

- (void)setattributesFromProfileUser:(ProfileUser *)profileUser {
    self.userId = profileUser.userId;
    self.firstName = profileUser.firstName;
    self.lastName = profileUser.lastName;
    self.profileImageURL = profileUser.profileImageURL;
    
    NSString *email = [profileUser emailAddress];
    if (email) {
        self.emailAddress = email;
    }
}

- (id)checkIfNull:(id)value {
    if (!value || [value isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return value;
}
@end
