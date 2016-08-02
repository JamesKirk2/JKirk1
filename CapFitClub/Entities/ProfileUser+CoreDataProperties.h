//
//  ProfileUser+CoreDataProperties.h
//  CapFitClub
//
//  Created by Sumit Sancheti on 31/03/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ProfileUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfileUser (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *dateOfBirth;
@property (nullable, nonatomic, retain) NSString *emailAddress;
@property (nullable, nonatomic, retain) NSString *firstName;
@property (nullable, nonatomic, retain) NSString *gender;
@property (nullable, nonatomic, retain) NSString *lastName;
@property (nullable, nonatomic, retain) NSString *profileImageURL;
@property (nullable, nonatomic, retain) NSNumber *userId;
@property (nullable, nonatomic, retain) NSString *loginId;

@end

NS_ASSUME_NONNULL_END
