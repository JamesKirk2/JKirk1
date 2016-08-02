//
//  BadgeBaseBackgroundView.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 10/05/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "BadgeBaseBackgroundView.h"

@interface BadgeBaseBackgroundView()

@property (strong, nonatomic) Badge *badge;
@end

@implementation BadgeBaseBackgroundView

- (void)setBadgeObject:(Badge *)badge {
    self.badge = badge;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef cont = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(cont, 90.0/255.0, 190.0/255.0, 111.0/255.0, 1.0);
    
    long long total = [self.badge.badgeGoal longLongValue];
    CGFloat height = (([self.badge.badgeCompletedValue longLongValue] * self.frame.size.height) / total);
    CGContextFillRect(cont, CGRectMake(0.0, self.frame.size.height - height, self.frame.size.width, height));
}

@end
