//
//  SetChallengeViewController.h
//  CapFitClub
//
//  Created by Sumit Sancheti on 02/02/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Challenge.h"

@interface SetChallengeViewController : UIViewController

@property (strong, nonatomic) Challenge *challenge;
@property (assign, nonatomic) BOOL isEditMode;
@end

