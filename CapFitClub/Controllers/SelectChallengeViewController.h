//
//  SelectChallengeViewController.h
//  CapFitClub
//
//  Created by Sumit Sancheti on 29/02/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Challenge.h"

@interface SelectChallengeViewController : UITableViewController

@property (assign, nonatomic) BOOL isSegueCallingDisabled;
@property (strong, nonatomic) Challenge *challenge;
@end
