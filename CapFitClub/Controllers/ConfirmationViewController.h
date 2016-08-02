//
//  ConfirmationViewController.h
//  CapFitClub
//
//  Created by Sumit Sancheti on 14/03/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Challenge.h"

@interface ConfirmationViewController : UIViewController

@property (weak, nonatomic) Challenge *challenge;

- (void)setStatusMessageForAlert:(NSString *)statusMessage;
@end
