//
//  Challenge+CoreDataProperties.h
//  CapFitClub
//
//  Created by Sumit Sancheti on 11/03/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Challenge.h"

NS_ASSUME_NONNULL_BEGIN

@interface Challenge (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *sectionIdentifierForChallenge;

@end

NS_ASSUME_NONNULL_END
