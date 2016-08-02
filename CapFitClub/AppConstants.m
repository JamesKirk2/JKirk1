//
//  AppConstants.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 09/02/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "AppConstants.h"

//NSString *const SERVICE_BASE_URL = @"http://10.76.116.5/";                                                                        //Local URL Bakkiyaraj
//NSString *const SERVICE_BASE_URL = @"http://10.100.141.73/be_healthy";                                                                        //Local URL Charu
//NSString *const SERVICE_BASE_URL = @"http://behealthyhr6frqzg5m.devcloud.acquia-sites.com/";        //Development URL
NSString *const SERVICE_BASE_URL = @"http://behealthysduu89hwzq.devcloud.acquia-sites.com/";   // Staging URL

NSString *const IS_USER_LOGGEDIN = @"IS_USER_LOGGEDIN";

NSString *const USER_LOGIN_ID = @"LoginId";
NSString *const USER_FIRST_NAME = @"First Name";
NSString *const USER_LAST_NAME = @"Last Name";
NSString *const USER_EMAILADDRESS = @"Email";
NSString *const USER_GENDER = @"Gender";
NSString *const USER_DATE_OF_BIRTH = @"Birth Date";
NSString *const USER_IMAGE_URL = @"IMAGE_URL";

NSString *const CHALLENGE_ID = @"challengeid";

CGFloat const KEYBOARD_HEIGHT = 210.0;
CGFloat const PROFILE_TABLE_BOTTOM_CONSTRAINT = 70.0;
CGFloat const TAB_BAR_HEIGHT = 49.0;
CGFloat const DEFAULT_FUTURE_DATE = 10*24*60*60;

CGFloat const HORIZONTAL_PADDING = 8.0;
CGFloat const VERTICAL_PADDING = 0.0;

CGFloat const TEXTFIELD_CORNER_RADIUS = 5.0;

NSString *const BADGE_ITEM = @"badgeItem";
NSString *const BADGE_SELECTED_ITEM = @"badgeSelectedItem";
NSString *const JOIN_CHALLENGE_ITEM = @"joinChallengeItem";
NSString *const JOIN_CHALLENGE_SELECTED_ITEM = @"joinChallengeSelectedItem";
NSString *const SET_CHALLENGE_ITEM = @"setChallengeItem";
NSString *const SET_CHALLENGE_SELECTED_ITEM = @"setChallengeSelectedItem";
NSString *const LOG_ACTIVITY_ITEM = @"logActivityItem";
NSString *const LOG_ACTIVITY_SELECTED_ITEM = @"logActivitySelectedItem";
NSString *const DASHBOARD_ITEM = @"dashboardItem";
NSString *const DASHBOARD_SELECTED_ITEM = @"dashboardSelectedItem";

NSString *const JOIN_CHALLENGE_NOTIFICATION = @"joinChallengeNotification";
NSString *const AUTHENTICATED_SOURCE_APP = @"com.apple.mobilemail";
NSString *const JOIN_CHALLENGE_ID = @"challengeId";

NSString *const CREATE_CHALLENGE_URL = @"fit_club/challenge/create";
NSString *const UPDATE_CHALLENGE_URL = @"fit_club/challenge/update";
NSString *const DELETE_CHALLENGE_URL = @"fit_club/challenge/delete";
NSString *const LEAVE_CHALLENGE_URL = @"fit_club/leavechallenges/leave";

NSString *const USER_SESSION_NAME = @"session_name";
NSString *const USER_SESSION_ID = @"sessid";
NSString *const USER_SESSION_TOKEN = @"token";

@implementation AppConstants

+ (AppConstants *)sharedInstance {
    static AppConstants *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[super allocWithZone:nil] init];
    });
    
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)ignore {
    return [self sharedInstance];
}

@end
