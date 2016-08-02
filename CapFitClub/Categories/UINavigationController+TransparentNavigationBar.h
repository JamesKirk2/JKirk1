//
//  UINavigationController+TransparentNavigationBar.h
//  CapFitClub
//
//  Created by Sumit Sancheti on 08/02/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (TransparentNavigationBar)

- (void)presentTransparentNavigationBar;
- (void)hideTransparentNavigationBar;

- (void)setBarColorAsTintColor:(UIColor *)tintColor;
@end
