//
//  LoginService.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 11/02/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "LoginService.h"
#import "SharedSessionManager.h"
#import "EntitiesFetcher.h"
#import "AFHTTPRequestSerializer+Headers.h"

@interface LoginService()

@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

@property (nonatomic, strong) SGTEntityManager *entityManager;
@end

@implementation LoginService

- (id)initWithParameters:(NSDictionary *)parameters {
    if((self = [super init])) {
        self.request = [[SharedSessionManager sharedInstance].requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:@"connect/user/login" relativeToURL:[SharedSessionManager sharedInstance].baseURL] absoluteString] parameters:parameters error:nil];
        self.entityManager = [[SGTEntityManager alloc] init];
    }
    return self;
}

- (void)getAppAuthentication:(LoginServiceSuccessCompletionBlock)success failure:(LoginServiceFailureCompletionBlock)failure {
    self.dataTask = [[SharedSessionManager sharedInstance] dataTaskWithRequest:_request completionHandler:^(NSURLResponse *__unused response, id responseObject, NSError *error) {
        
//        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"login" ofType:@"json"];
//        responseObject = [[NSData alloc] initWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:&error];
        if(!error) {
#if DEBUG
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"Response: %@", responseString);
#endif
            AFJSONResponseSerializer *jsonSerializer = [AFJSONResponseSerializer serializer];
            id JSON = [jsonSerializer responseObjectForResponse:response data:responseObject error:nil];
            
//            id JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
            NSDictionary *userDict = JSON[@"user"];
            NSString *sessionName = JSON[USER_SESSION_NAME];
            NSString *sessionId = JSON[USER_SESSION_ID];
            NSString *token = JSON[USER_SESSION_TOKEN];
            if (userDict) {
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:sessionName forKey:USER_SESSION_NAME];
                [userDefaults setObject:sessionId forKey:USER_SESSION_ID];
                [userDefaults setObject:token forKey:USER_SESSION_TOKEN];
                [userDefaults synchronize];
                
                [[SharedSessionManager sharedInstance].requestSerializer addTokenAndCookieHeader];
                ProfileUser *profileUser = [self getProfileUserWithProfileDict:userDict];
                success(profileUser);
            }
            else {
                NSString *message = JSON[@"message"];
                error = [NSError errorWithDomain:@"Login Error !" code:404 userInfo:@{NSLocalizedDescriptionKey:message}];
                failure(error);
            }
        }
        else {
            failure(error);
        }
    }];
    [_dataTask resume];
}

- (ProfileUser *)getProfileUserWithProfileDict:(NSDictionary *)userProfile {
    NSString *loginId = [userProfile objectForKey:@"login_id"];
    ProfileUser *profileUser = [CommonFunctions getLoggedInProfileUser:loginId];
    if (!profileUser) {
        profileUser = [self.entityManager insertEntityWithName:NSStringFromClass([ProfileUser class])];
    }
    if (userProfile) {
        [profileUser setAttributes:userProfile];
    }
    
    NSError *error = nil;
    if ([self.entityManager save:&error]) {
        [[NSUserDefaults standardUserDefaults] setObject:[loginId lowercaseString] forKey:USER_LOGIN_ID];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return profileUser;
    } else {
#if DEBUG
        NSLog(@"Create profile user: %@", [error localizedDescription]);
#endif
    }
    return nil;
}
@end
