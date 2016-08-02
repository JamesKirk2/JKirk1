//
//  CustomTextField.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 23/02/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + HORIZONTAL_PADDING, bounds.origin.y + VERTICAL_PADDING, bounds.size.width - HORIZONTAL_PADDING*3, bounds.size.height - VERTICAL_PADDING*2);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

@end
