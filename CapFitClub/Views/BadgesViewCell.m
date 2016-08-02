//
//  BadgesViewCell.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 11/04/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "BadgesViewCell.h"
#import "BadgeBaseBackgroundView.h"

@interface BadgesViewCell()

@property (weak, nonatomic) IBOutlet BadgeBaseBackgroundView *badgeBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *badgeName;
@property (weak, nonatomic) IBOutlet UILabel *badgeGoal;
@property (weak, nonatomic) IBOutlet UIImageView *badgeImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progressActivityIndicator;

@property (strong, nonatomic) Badge *badge;
@property (strong, nonatomic) NSDictionary *goalUnitDict;
@end

@implementation BadgesViewCell

- (void)awakeFromNib {
    // Initialization code
    if (!self.goalUnitDict) {
        self.goalUnitDict = @{@"distance":@"Miles", @"time":@"Mins", @"steps":@"Steps", @"floors":@"Floors", @"calories":@"Calories", @"storeys":@"Storeys", @"height":@"Meters"};
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBadgeObject:(Badge *)badge {
    self.badge = badge;
    [self.badgeBackgroundView setBadgeObject:self.badge];
    
    NSString *definition = nil;
    if ([[self.badge badgeType] intValue] == LOGGED_BADGE) {
        definition = @"Challenges";
    } else if ([[self.badge badgeType] intValue] == INVITED_USERS_BADGE) {
        definition = @"Users";
    } else {
        definition = self.goalUnitDict[[[self.badge badgeGoalUnit] lowercaseString]];
    }
    [self.badgeName setText:[self.badge badgeName]];
    [self.badgeGoal setText:[NSString stringWithFormat:@"%@ %@", [self.badge badgeGoal], definition]];
    [self downloadUserImageWithURL:[self.badge badgeImageURL]];
//    [self.badgeBackgroundView setNeedsDisplay];
}

- (void)downloadUserImageWithURL:(NSString *)profileImageURL {
    [self.progressActivityIndicator stopAnimating];
    if (profileImageURL && [profileImageURL length] > 0) {
        NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:profileImageURL] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
        
        [self.progressActivityIndicator startAnimating];
        __weak typeof(self) weakSelf = self;
        [self.badgeImageView setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"badgeBase"] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
            [weakSelf.progressActivityIndicator stopAnimating];
            [weakSelf.badgeImageView setImage:image];
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError *error) {
            [weakSelf.progressActivityIndicator stopAnimating];
        }];
    }
}

@end
