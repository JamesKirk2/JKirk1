//
//  User.h
//  
//
//  Created by Sumit Sancheti on 04/02/16.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Activity, Challenge;

NS_ASSUME_NONNULL_BEGIN

@interface User : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
- (void)setAttributes:(NSDictionary *)attributes;
- (void)setattributesFromProfileUser:(ProfileUser *)profileUser;
@end

NS_ASSUME_NONNULL_END

#import "User+CoreDataProperties.h"
