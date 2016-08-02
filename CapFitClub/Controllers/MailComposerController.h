//
//  MailComposerController.h
//  CapFitClub
//
//  Created by Sumit Sancheti on 09/03/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import "Challenge.h"

@protocol MailComposerControllerDelegate <NSObject>

- (void)isMailSent:(BOOL)mailSent;
@end

@interface MailComposerController : MFMailComposeViewController<MFMailComposeViewControllerDelegate>

@property (nonatomic, unsafe_unretained) id <MailComposerControllerDelegate> mailComposerDelegate;

- (void)setSubjectAndBodyForChallenge:(Challenge *)challenge;
@end
