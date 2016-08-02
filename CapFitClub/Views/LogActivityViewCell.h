//
//  LogActivityViewCell.h
//  CapFitClub
//
//  Created by Sumit Sancheti on 28/03/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Challenge.h"
#import "ProfileViewCell.h"

@protocol LogActivityViewCellDelegate <NSObject>

- (void)setValueForCell:(UITableViewCell *)cell withValue:(NSString *)strValue;
@end

@interface LogActivityViewCell : UITableViewCell

@property (nonatomic, unsafe_unretained) id <ProfileViewCellDelegate> profileCellDelegate;

- (void)setCurrentChallenge:(Challenge *)challenge;
- (void)setChallengeTypeImage:(UIImage *)image;
@end
