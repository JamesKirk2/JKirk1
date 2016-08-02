//
//  AFHTTPRequestSerializer+Headers.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 04/04/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "AFHTTPRequestSerializer+Headers.h"

@implementation AFHTTPRequestSerializer (Headers)

- (void)addTokenAndCookieHeader {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults objectForKey:USER_SESSION_TOKEN];
    NSString *sessionName = [userDefaults objectForKey:USER_SESSION_NAME];
    NSString *sessionId = [userDefaults objectForKey:USER_SESSION_ID];
    if (token && sessionId && sessionName) {
        NSString *cookie = [NSString stringWithFormat:@"%@=%@", sessionName, sessionId];
        [self setValue:token forHTTPHeaderField:@"X-CSRF-Token"];
        [self setValue:cookie forHTTPHeaderField:@"Cookie"];
    }
//    [self setAuthorizationHeaderFieldWithUsername:@"admin" password:@"admin"];
}
@end
