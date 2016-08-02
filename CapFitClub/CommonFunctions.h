//
//  CommonFunctions.h
//  CapFitClub
//
//  Created by Sumit Sancheti on 08/02/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ProfileUser.h"

@interface CommonFunctions : NSObject

+ ( UIStoryboard * _Nonnull )getStoryBoardWithName:(NSString * _Nonnull )name;
+ (CGFloat)screenHeight;
+ (UIColor * _Nonnull )getMainAppColor;

+ (UIAlertAction * _Nonnull )getCancelAlertAction:(void (^ __nullable)(UIAlertAction * _Nonnull action))handler;
+ (UIAlertAction * _Nonnull )getDismissAlertAction:(void (^ __nullable)(UIAlertAction * _Nonnull action))handler;
+ (UIAlertAction * _Nonnull )getYesAlertAction:(void (^ __nullable)(UIAlertAction * _Nonnull action))handler;
+ (UIAlertAction * _Nonnull )getNoAlertAction:(void (^ __nullable)(UIAlertAction * _Nonnull action))handler;

+ (UIBarButtonItem * _Nonnull )barButtonItemWithTitle:(NSString * _Nonnull )title target:(id _Nonnull )target selector:(SEL _Nonnull )selector;

+ (NSString * _Nonnull )formatDateFrom:(NSDate * _Nonnull )date;
+ (NSDate * _Nonnull )formatDateFromString:(NSString * _Nonnull )strDate;
+ (NSString * _Nonnull )formatDateForLogActivity:(NSDate * _Nonnull )date;

+ (NSDateComponents * _Nonnull )getDateComponentsFromEndDate:(NSDate * _Nonnull )date toStartDate:(NSDate * _Nonnull )date;
+ (CGFloat)heightWithWidthConstraint:(float)width ForString:(NSString * _Nonnull )str font:(UIFont * _Nonnull )font;

+ (NSString * _Nonnull )getNameForChallengeType:(NSNumber * _Nonnull )challengeType;
+ (ProfileUser * _Nonnull )getLoggedInProfileUser:(NSString * __nullable )loginId;
+ (BOOL)isUserProfileSetForUser:(ProfileUser * _Nonnull )profileUser;
@end
