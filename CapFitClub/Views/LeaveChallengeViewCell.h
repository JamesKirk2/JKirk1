//
//  LeaveChallengeViewCell.h
//  CapFitClub
//
//  Created by Sumit Sancheti on 08/03/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeaveChallengeDelegate <NSObject>

- (void)leaveChallengeForUser;
@end

@interface LeaveChallengeViewCell : UITableViewCell

@property (nonatomic, unsafe_unretained) id <LeaveChallengeDelegate> leaveChallengeDelegate;
@end
