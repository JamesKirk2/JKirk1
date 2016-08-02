//
//  UITableViewCell+DisclosureIndicatorColor.h
//  CapFitClub
//
//  Created by Sumit Sancheti on 29/02/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (DisclosureIndicatorColor)

@property (nonatomic, strong) UIColor *disclosureIndicatorColor;

- (void)updateDisclosureIndicatorColorToTintColor;
@end
