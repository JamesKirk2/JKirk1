//
//  SetActivityAndImageCell.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 29/02/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "SetActivityAndImageCell.h"

@interface SetActivityAndImageCell()

@property (weak, nonatomic) IBOutlet UIView *backgroundViewForCell;
@property (weak, nonatomic) IBOutlet UIImageView *challengeImage;
@property (weak, nonatomic) IBOutlet UILabel *lblChallengeName;
@property (weak, nonatomic) IBOutlet UIImageView *forwardArrow;

@property (weak, nonatomic) IBOutlet UIView *seprator1;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UIView *seprator2;
@end

@implementation SetActivityAndImageCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundViewForCell.layer.cornerRadius = TEXTFIELD_CORNER_RADIUS;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setChallengeType:(NSString *)challengeType  {
    if (!challengeType) {
        challengeType = @"Others";
    }
    [self.seprator1 setHidden:YES];
    [self.logoImage setHidden:YES];
    [self.seprator2 setHidden:YES];
    [self.backgroundViewForCell setHidden:NO];
    [self.lblChallengeName setHidden:NO];
    [self.challengeImage setHidden:NO];
    [self.forwardArrow setHidden:NO];
    
    [self.lblChallengeName setText:challengeType];
    [self.challengeImage setImage:[UIImage imageNamed:[challengeType lowercaseString]]];
}

- (void)setJoinChallengeName:(NSString *)challengeName withType:(NSString *)challengeType {
    if (!challengeName) {
        challengeName = @"Others";
    }
    [self.seprator1 setHidden:YES];
    [self.logoImage setHidden:YES];
    [self.seprator2 setHidden:YES];
    [self.backgroundViewForCell setHidden:NO];
    [self.lblChallengeName setHidden:NO];
    [self.challengeImage setHidden:NO];
    [self.forwardArrow setHidden:NO];
    
    [self.lblChallengeName setText:challengeName];
    NSString *imageName = [[NSString stringWithFormat:@"blue_%@", challengeType] lowercaseString];
    [self.challengeImage setImage:[UIImage imageNamed:imageName]];
}

- (void)setLogoImage {
    [self.seprator1 setHidden:NO];
    [self.logoImage setHidden:NO];
    [self.seprator2 setHidden:NO];
    [self.backgroundViewForCell setHidden:YES];
    [self.lblChallengeName setHidden:YES];
    [self.challengeImage setHidden:YES];
    [self.forwardArrow setHidden:YES];
    
    [self.logoImage setImage:[UIImage imageNamed:@"navBeHealthy"]];
}
@end
