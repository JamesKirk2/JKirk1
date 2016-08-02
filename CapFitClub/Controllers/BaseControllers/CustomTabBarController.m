//
//  CustomTabBarController.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 11/02/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "CustomTabBarController.h"

@interface CustomTabBarController ()

@end

@implementation CustomTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:15.0/255.0 green:113.0/255.0 blue:183.0/255.0 alpha:1.0]];
//    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:15.0/255.0 green:113.0/255.0 blue:183.0/255.0 alpha:1.0]];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self customizeTabBarItems];
}

- (void)customizeTabBarItems {
    NSArray *tabBarItems = [self.tabBar items];
    
    UITabBarItem *tabBarItem = tabBarItems[0];
    [tabBarItem setImage:[[UIImage imageNamed:DASHBOARD_ITEM] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem setSelectedImage:[[UIImage imageNamed:DASHBOARD_SELECTED_ITEM] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    tabBarItem = tabBarItems[1];
    [tabBarItem setImage:[[UIImage imageNamed:LOG_ACTIVITY_ITEM] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem setSelectedImage:[[UIImage imageNamed:LOG_ACTIVITY_SELECTED_ITEM] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    tabBarItem = tabBarItems[2];
    [tabBarItem setImage:[[UIImage imageNamed:BADGE_ITEM] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem setSelectedImage:[[UIImage imageNamed:BADGE_SELECTED_ITEM] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    tabBarItem = tabBarItems[3];
    [tabBarItem setImage:[[UIImage imageNamed:SET_CHALLENGE_ITEM] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem setSelectedImage:[[UIImage imageNamed:SET_CHALLENGE_SELECTED_ITEM] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    tabBarItem = tabBarItems[4];
    [tabBarItem setImage:[[UIImage imageNamed:JOIN_CHALLENGE_ITEM] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem setSelectedImage:[[UIImage imageNamed:JOIN_CHALLENGE_SELECTED_ITEM] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [UITabBarItem.appearance setTitleTextAttributes:
     @{NSForegroundColorAttributeName : [UIColor whiteColor]}
                                           forState:UIControlStateNormal];
    
    // then if StateSelected should be different, you should add this code
    [UITabBarItem.appearance setTitleTextAttributes:
     @{NSForegroundColorAttributeName : [UIColor colorWithRed:17.0/255.0 green:199.0/255.0 blue:250.0/255.0 alpha:1.0]}
                                           forState:UIControlStateSelected];
}

- (void) addBlurEffect {
    // Add blur view
    UITabBar *newimageView = self.tabBar;
    CGRect bounds = newimageView.bounds;
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    
    
    //UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [newimageView addSubview:visualEffectView];
    //    [visualEffectView addSubview:vibrancyEffect];
    
    visualEffectView.frame = bounds;
    //    visualEffectView.alpha = 0.5;
    visualEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    
    
    //    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [newimageView sendSubviewToBack:visualEffectView];
    
    // Here you can add visual effects to any UIView control.
    // Replace custom view with navigation bar in above code to add effects to custom view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
