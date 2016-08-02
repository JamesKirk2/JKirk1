//
//  WonBadgeViewCell.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 10/05/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "WonBadgeViewCell.h"
#import "EntitiesFetcher.h"

@interface WonBadgeViewCell()

@property (weak, nonatomic) IBOutlet UILabel *challengeName;
@property (weak, nonatomic) IBOutlet UILabel *challengeStartDate;
@property (weak, nonatomic) IBOutlet UILabel *challengeEndDate;
@property (weak, nonatomic) IBOutlet UILabel *badgeName;
@property (weak, nonatomic) IBOutlet UIImageView *badgeImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progressActivityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *badgeGoal;

@property (strong, nonatomic) Badge *badge;
@property (strong, nonatomic) Challenge *challenge;
@property (strong, nonatomic) NSDictionary *goalUnitDict;
@end

@implementation WonBadgeViewCell

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
    
    NSString *definition = nil;
    if ([[self.badge badgeType] intValue] == LOGGED_BADGE) {
        definition = @"Challenges";
    } else if ([[self.badge badgeType] intValue] == INVITED_USERS_BADGE) {
        definition = @"Users";
    } else {
        definition = self.goalUnitDict[[[self.badge badgeGoalUnit] lowercaseString]];
    }
    
    if (!self.challenge || [self.challenge challengeId] != [self.badge challengeId]) {
        self.challenge = [self getChallengeFromChallengeId:[self.badge challengeId]];
    }
    [self.challengeName setText:[self.challenge challengeName]];
    [self.challengeStartDate setText:[CommonFunctions formatDateForLogActivity:[self.challenge startDate]]];
    [self.challengeEndDate setText:[CommonFunctions formatDateForLogActivity:[self.challenge endDate]]];
    
    [self.badgeGoal setText:[NSString stringWithFormat:@"%@ %@", [self.badge badgeGoal], definition]];
    [self.badgeName setText:[self.badge badgeName]];
    [self downloadUserImageWithURL:[self.badge badgeImageURL]];
}

- (Challenge *)getChallengeFromChallengeId:(NSNumber *)challengeId {
    if (!challengeId) {
        return nil;
    }
    EntitiesFetcher *entityFetcher = [[EntitiesFetcher alloc] init];
    return [entityFetcher fetchChallengeWithChallengeId:challengeId];
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
