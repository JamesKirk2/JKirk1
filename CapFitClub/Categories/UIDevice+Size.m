//
//  UIDevice+Size.m
//
//  Created by Sumit Sancheti on 6/3/14.
//  Copyright (c) 2014 Sogeti. All rights reserved.
//

#import "UIDevice+Size.h"

@implementation UIDevice (Size)

+ (BOOL)isIPhone4 {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    if (screenHeight == 480.0f) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)isIPhone5 {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    if (screenHeight == 568.0f) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)isIPhone6 {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    if (screenHeight > 568.0f) {
        return YES;
    } else {
        return NO;
    }
}

@end
