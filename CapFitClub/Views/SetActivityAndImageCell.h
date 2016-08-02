//
//  SetActivityAndImageCell.h
//  CapFitClub
//
//  Created by Sumit Sancheti on 29/02/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetActivityAndImageCell : UITableViewCell

- (void)setChallengeType:(NSString *)challengeType;
- (void)setLogoImage;
- (void)setJoinChallengeName:(NSString *)challengeName withType:(NSString *)challengeType;
@end
