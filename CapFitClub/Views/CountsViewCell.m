//
//  CountsViewCell.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 23/02/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "CountsViewCell.h"

@interface CountsViewCell()

@property (weak, nonatomic) IBOutlet UILabel *lblNoOfChallenges;
@property (weak, nonatomic) IBOutlet UILabel *lblNoOfBadges;

@end

@implementation CountsViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setNumberOfChallenges:(NSInteger)numberOfChallenges {
    [self.lblNoOfChallenges setFont:[UIFont fontWithName:@"PT Sans" size:24.0]];
    [self.lblNoOfChallenges setText:[NSString stringWithFormat:@"%ld", (long)numberOfChallenges]];
}

- (void)setNumberOfBadges:(NSInteger)numberOfBadges {
    [self.lblNoOfBadges setFont:[UIFont fontWithName:@"PT Sans" size:24.0]];
    [self.lblNoOfBadges setText:[NSString stringWithFormat:@"%ld", (long)numberOfBadges]];
}
@end
