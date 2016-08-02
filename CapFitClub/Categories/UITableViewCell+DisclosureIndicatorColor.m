//
//  UITableViewCell+DisclosureIndicatorColor.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 29/02/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "UITableViewCell+DisclosureIndicatorColor.h"

@implementation UITableViewCell (DisclosureIndicatorColor)

- (void)updateDisclosureIndicatorColorToTintColor {
    [self setDisclosureIndicatorColor:self.window.tintColor];
}

- (void)setDisclosureIndicatorColor:(UIColor *)color {
//    if (self.accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
        UIButton *arrowButton = [self arrowButton];
        UIImage *image = [arrowButton backgroundImageForState:UIControlStateNormal];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        arrowButton.tintColor = color;
        [arrowButton setBackgroundImage:image forState:UIControlStateNormal];
//    }
}

- (UIColor *)disclosureIndicatorColor {
    NSAssert(self.accessoryType == UITableViewCellAccessoryDisclosureIndicator,
             @"accessory type needs to be UITableViewCellAccessoryDisclosureIndicator");
    
    UIButton *arrowButton = [self arrowButton];
    return arrowButton.tintColor;
}

- (UIButton *)arrowButton {
    for (UIView *view in self.subviews)
        if ([view isKindOfClass:[UIButton class]])
            return (UIButton *)view;
    return nil;
}
@end
