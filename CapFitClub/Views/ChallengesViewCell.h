//
//  ChallengesViewCell.h
//  CapFitClub
//
//  Created by Sumit Sancheti on 23/02/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilledChallengesView.h"

@class ChallengesViewCell;
@protocol ChallengesViewCellDelegate <NSObject>

@optional
- (void)sendSelectedCell:(ChallengesViewCell *)cell;
- (void)deleteSelectedCell:(ChallengesViewCell *)cell;

@end

@interface ChallengesViewCell : UITableViewCell

@property (nonatomic, unsafe_unretained) id <ChallengesViewCellDelegate> challengesViewCellDelegate;

- (void)addGesture;
- (void)setMainChallengeObject:(MainChallenge *)challenge;
- (void)setCompletedChallengeObject:(MainChallenge *)challenge;
- (void)setUserObject:(User *)user;
- (void)refreshView;
- (void)hideDeleteButton;
@end
