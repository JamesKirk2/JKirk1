//
//  Challenge.h
//  CapFitClub
//
//  Created by Sumit Sancheti on 11/03/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainChallenge.h"

@class LocalChallenge;
NS_ASSUME_NONNULL_BEGIN

@interface Challenge : MainChallenge

// Insert code here to declare functionality of your managed object subclass
- (void)setAttributesFromLocalChallenge:(LocalChallenge *)challenge;
@end

NS_ASSUME_NONNULL_END

#import "Challenge+CoreDataProperties.h"
