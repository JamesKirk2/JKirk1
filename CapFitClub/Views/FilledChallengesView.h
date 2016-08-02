//
//  FilledChallengesView.h
//  CapFitClub
//
//  Created by Sumit Sancheti on 24/02/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainChallenge.h"
#import "User.h"

@class FilledChallengesView;
@protocol FilledChallengesViewDelegate <NSObject>

- (void)sendSelectedCell:(BOOL)isSelected;
- (void)deleteCell:(BOOL)isDelete;
@end

@interface FilledChallengesView : UIView

@property (nonatomic, unsafe_unretained) id <FilledChallengesViewDelegate> filledChallengesViewDelegate;

- (void)addGesture;
- (void)setMainChallengeObject:(MainChallenge *)challenge;
- (void)setUserObject:(User *)user;
- (void)refreshView;
- (void)hideDeleteButton;
@end
