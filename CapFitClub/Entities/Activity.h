//
//  Activity.h
//  
//
//  Created by Sumit Sancheti on 04/02/16.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Challenge, User;

NS_ASSUME_NONNULL_BEGIN

@interface Activity : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
- (void)setAttributes:(NSDictionary *)attributes;
@end

NS_ASSUME_NONNULL_END

#import "Activity+CoreDataProperties.h"
