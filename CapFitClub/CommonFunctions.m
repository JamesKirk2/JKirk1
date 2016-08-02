//
//  CommonFunctions.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 08/02/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "CommonFunctions.h"
#import "EntitiesFetcher.h"
#import "ChallengeType.h"

@implementation CommonFunctions

+ (UIStoryboard *)getStoryBoardWithName:(NSString *)name {
    return ((UIStoryboard *)[UIStoryboard storyboardWithName:name bundle:nil]);
}

+ (CGFloat)screenHeight {
    return ([UIScreen mainScreen].bounds.size.height);
}

+ (UIColor *)getMainAppColor {
    return ([UIColor colorWithRed:15.0/255.0 green:113.0/255.0 blue:183.0/255.0 alpha:1.0]);
}

+ (UIAlertAction *)getCancelAlertAction:(void (^ __nullable)(UIAlertAction *action))handler {
    return [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:handler];
}

+ (UIAlertAction *)getDismissAlertAction:(void (^ __nullable)(UIAlertAction *action))handler {
    return [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDestructive handler:handler];
}

+ (UIAlertAction *)getYesAlertAction:(void (^ __nullable)(UIAlertAction *action))handler {
    return [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:handler];
}

+ (UIAlertAction *)getNoAlertAction:(void (^ __nullable)(UIAlertAction *action))handler {
    return [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:handler];
}

+ (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)title target:(id)target selector:(SEL)selector {
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:selector];
    return barButtonItem;
}

+ (NSString *)formatDateFrom:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MMM yyyy"];
    
    if (date) {
        return [formatter stringFromDate:date];
    }
    return [formatter stringFromDate:[NSDate dateWithTimeInterval:DEFAULT_FUTURE_DATE sinceDate:[NSDate date]]];
}

+ (NSDate *)formatDateFromString:(NSString *)strDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MMM yyyy"];
    
    return [formatter dateFromString:strDate];
}

+ (NSString *)formatDateForLogActivity:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM.yyyy"];
    
    if (date) {
        return [formatter stringFromDate:date];
    }
    return [formatter stringFromDate:[NSDate date]];
}

+ (NSDateComponents *)getDateComponentsFromEndDate:(NSDate *)endDate toStartDate:(NSDate *)startDate {
    if (!endDate) {
        endDate = [NSDate date];
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitDay | NSCalendarUnitHour) fromDate:startDate toDate:endDate options:NSCalendarWrapComponents];
    
    return components;
}

+ (CGFloat)heightWithWidthConstraint:(float)width ForString:(NSString *)str font:(UIFont *)font {
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:@{
                                              NSFontAttributeName : font
                                              }
                                    context:nil].size;
    
    return  (size.height + 20.0f);
}

+ (NSString *)getNameForChallengeType:(NSNumber *)challengeType {
    EntitiesFetcher *entityFetcher = [[EntitiesFetcher alloc] init];
    ChallengeType *challenge = [entityFetcher fetchChallengeTypeWithType:challengeType];
    
    return [challenge challengeName];
}

+ (ProfileUser *)getLoggedInProfileUser:(NSString *)loginId {
    if (!loginId) {
        loginId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_LOGIN_ID];
    }
    
    EntitiesFetcher *entityFetcher = [[EntitiesFetcher alloc] init];
    ProfileUser *profileUser = [entityFetcher fetchProfileUserWithLoginId:loginId];
    
    return profileUser;
}

+ (BOOL)isUserProfileSetForUser:(ProfileUser *)profileUser {
    if (!profileUser.firstName || !profileUser.lastName || !profileUser.emailAddress || !profileUser.gender || !profileUser.dateOfBirth) {
        return NO;
    }
    return YES;
}
@end
