//
//  UINavigationController+TransparentNavigationBar.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 08/02/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "UINavigationController+TransparentNavigationBar.h"

@implementation UINavigationController (TransparentNavigationBar)

- (void)presentTransparentNavigationBar
{
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setTranslucent:YES];
    [self.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self setNavigationBarHidden:NO animated:YES];
}

- (void)hideTransparentNavigationBar
{
    [self setNavigationBarHidden:YES animated:NO];
    [self.navigationBar setBackgroundImage:[[UINavigationBar appearance] backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setTranslucent:[[UINavigationBar appearance] isTranslucent]];
    [self.navigationBar setShadowImage:[[UINavigationBar appearance] shadowImage]];
}

- (void)setBarColorAsTintColor:(UIColor *)tintColor {
    if ([self.view respondsToSelector:@selector(tintColor)]) {
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.0f/255.0f green:152.0f/255.0f blue:204.0f/255.0f alpha:1.0f]];
    }
}
@end
