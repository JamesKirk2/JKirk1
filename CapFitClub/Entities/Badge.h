//
//  Badge.h
//  
//
//  Created by Sumit Sancheti on 04/02/16.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, BADGE_TYPE) {
    LOGGED_BADGE = 1,
    ACTIVITY_BADGE,
    CHALLENGE_BADGE,
    INVITED_USERS_BADGE
};

@interface Badge : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
- (void)setAttributes:(NSDictionary *)attributes forBadgeType:(NSString *)badgeType;
@end

NS_ASSUME_NONNULL_END

#import "Badge+CoreDataProperties.h"
