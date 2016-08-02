//
//  SelectChallengeCell.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 29/02/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "SelectChallengeCell.h"

@interface SelectChallengeCell()

@property (weak, nonatomic) IBOutlet UIImageView *cellChallengeImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblChallengeName;

@end

@implementation SelectChallengeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.backgroundColor = [UIColor colorWithRed:53.0/255.0 green:129.0/255.0 blue:187.0/255.0 alpha:1];
    }else {
        self.backgroundColor = [UIColor colorWithRed:35.0/255.0 green:114.0/255.0 blue:179.0/255.0 alpha:1];
    }
}

- (void)setChallengeName:(NSString *)challengeName {
    [self.lblChallengeName setText:challengeName];
}

- (void)setChallengeImage:(UIImage *)challengeImage {
    [self.cellChallengeImageView setImage:challengeImage];
}

@end
