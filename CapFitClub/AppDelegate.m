//
//  AppDelegate.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 02/02/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self setUpCoreDataStack];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if ([[url scheme] isEqualToString:@"openchallenge"]) {
        NSString *query = [url query];
        NSDictionary *keyValueDict = [self parseQueryString:query];
        NSLog(@"%@", [keyValueDict description]);
        
        NSString *challengeId = keyValueDict[@"cid"];
        if (challengeId) {
            [[NSUserDefaults standardUserDefaults] setObject:challengeId forKey:JOIN_CHALLENGE_ID];
            [[NSNotificationCenter defaultCenter] postNotificationName:JOIN_CHALLENGE_NOTIFICATION object:challengeId];
        }
        return YES;
    }
    
    return NO;
};

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation {
    if ([[url scheme] isEqualToString:@"openchallenge"]) {
        NSString *query = [url query];
        NSDictionary *keyValueDict = [self parseQueryString:query];
        NSLog(@"%@", [keyValueDict description]);
        
        NSString *challengeId = keyValueDict[@"cid"];
        if (challengeId) {
            [[NSUserDefaults standardUserDefaults] setObject:challengeId forKey:JOIN_CHALLENGE_ID];
            [[NSNotificationCenter defaultCenter] postNotificationName:JOIN_CHALLENGE_NOTIFICATION object:challengeId];
        }
         return YES;
    }
    return NO;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    NSString *sourceApp = options[UIApplicationOpenURLOptionsSourceApplicationKey];
    if ([[url scheme] isEqualToString:@"openchallenge"] && [sourceApp isEqualToString:AUTHENTICATED_SOURCE_APP]) {
        NSString *query = [url query];
        NSDictionary *keyValueDict = [self parseQueryString:query];
        NSLog(@"%@", [keyValueDict description]);
        
        NSString *challengeId = keyValueDict[@"cid"];
        if (challengeId) {
            [[NSUserDefaults standardUserDefaults] setObject:challengeId forKey:JOIN_CHALLENGE_ID];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self performSelector:@selector(postNotification:) withObject:challengeId afterDelay:0.5];
        }
        
         return YES;
    }
    return NO;
}

- (void)postNotification:(NSString *)challengeId {
    [[NSNotificationCenter defaultCenter] postNotificationName:JOIN_CHALLENGE_NOTIFICATION object:challengeId];
}

- (NSDictionary *)parseQueryString:(NSString *)query {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dict setObject:val forKey:key];
    }
    return dict;
}

#pragma mark - CoreDataStack
- (void)setUpCoreDataStack {
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:((NSString*)kCFBundleNameKey)];
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CapFitClubModel" withExtension:@"momd"];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:appName];
    [SGTEntityManager initializeWithModelURL:modelURL storeURL:storeURL];
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
