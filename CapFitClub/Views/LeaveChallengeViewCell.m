//
//  LeaveChallengeViewCell.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 08/03/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "LeaveChallengeViewCell.h"

@interface LeaveChallengeViewCell()

- (IBAction)leaveChallengeClicked:(id)sender;
@end

@implementation LeaveChallengeViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)leaveChallengeClicked:(id)sender {
    [self.leaveChallengeDelegate leaveChallengeForUser];
}
@end
