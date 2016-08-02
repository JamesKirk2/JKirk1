//
//  SetChallengeGoalViewCell.h
//  CapFitClub
//
//  Created by Sumit Sancheti on 01/03/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileViewCell.h"

@interface SetChallengeGoalViewCell : UITableViewCell

@property (nonatomic, unsafe_unretained) id <ProfileViewCellDelegate> profileCellDelegate;

- (void)setSegmentWithItems:(NSArray *)items;
- (void)setGoal:(NSNumber *)goal withGoalUnit:(NSString *)goalUnit;
@end
