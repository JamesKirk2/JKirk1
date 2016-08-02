//
//  AppConstants.h
//  CapFitClub
//
//  Created by Sumit Sancheti on 09/02/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PROFILETABLEINDEXES) {
    INDEX_FIRST_NAME = 1,
    INDEX_LAST_NAME,
    INDEX_EMAIL,
    INDEX_GENDER,
    INDEX_DATE_OF_BIRTH
};

typedef NS_ENUM(NSInteger, CHALLENGES) {
    CHALLENGE_CLIMBING = 1,
    CHALLENGE_CYCLING,
    CHALLENGE_RUNNING,
    CHALLENGE_SWIMMING,
    CHALLENGE_WALKING,
    CHALLENGE_OTHERS
};

extern NSString *const SERVICE_BASE_URL;
extern NSString *const IS_USER_LOGGEDIN;

extern NSString *const USER_EMAIL_ID;
extern NSString *const USER_PASSWORD;

extern NSString *const USER_LOGIN_ID;
extern NSString *const USER_FIRST_NAME;
extern NSString *const USER_LAST_NAME;
extern NSString *const USER_EMAILADDRESS;
extern NSString *const USER_GENDER;
extern NSString *const USER_DATE_OF_BIRTH;
extern NSString *const USER_IMAGE_URL;

extern NSString *const CHALLENGE_NAME;
extern NSString *const CHALLENGE_DESCRIPTION;
extern NSString *const CHALLENGE_ID;

extern CGFloat const KEYBOARD_HEIGHT;
extern CGFloat const PROFILE_TABLE_BOTTOM_CONSTRAINT;
extern CGFloat const TAB_BAR_HEIGHT;
extern CGFloat const DEFAULT_FUTURE_DATE;

extern CGFloat const HORIZONTAL_PADDING;
extern CGFloat const VERTICAL_PADDING;

extern CGFloat const TEXTFIELD_CORNER_RADIUS;

extern NSString *const BADGE_ITEM;
extern NSString *const BADGE_SELECTED_ITEM;

extern NSString *const JOIN_CHALLENGE_ITEM;
extern NSString *const JOIN_CHALLENGE_SELECTED_ITEM;

extern NSString *const SET_CHALLENGE_ITEM;
extern NSString *const SET_CHALLENGE_SELECTED_ITEM;

extern NSString *const LOG_ACTIVITY_ITEM;
extern NSString *const LOG_ACTIVITY_SELECTED_ITEM;

extern NSString *const DASHBOARD_ITEM;
extern NSString *const DASHBOARD_SELECTED_ITEM;

extern NSString *const JOIN_CHALLENGE_NOTIFICATION;
extern NSString *const AUTHENTICATED_SOURCE_APP;
extern NSString *const JOIN_CHALLENGE_ID;

extern NSString *const CREATE_CHALLENGE_URL;
extern NSString *const UPDATE_CHALLENGE_URL;
extern NSString *const DELETE_CHALLENGE_URL;
extern NSString *const LEAVE_CHALLENGE_URL;

extern NSString *const USER_SESSION_NAME;
extern NSString *const USER_SESSION_ID;
extern NSString *const USER_SESSION_TOKEN;

@interface AppConstants : NSObject

@property (nonatomic, assign) BOOL isUserLoggedIn;

+ (AppConstants *)sharedInstance;
@end
