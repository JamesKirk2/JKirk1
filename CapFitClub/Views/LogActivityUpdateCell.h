//
//  LogActivityUpdateCell.h
//  CapFitClub
//
//  Created by Sumit Sancheti on 28/03/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Activity.h"

@interface LogActivityUpdateCell : UITableViewCell

- (void)setLogActivity:(Activity *)activity WithGoalUnit:(NSString *)goalUnit;
@end
