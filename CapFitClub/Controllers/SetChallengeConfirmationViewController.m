//
//  SetChallengeConfirmationViewController.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 02/03/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "SetChallengeConfirmationViewController.h"
#import <MessageUI/MessageUI.h>
#import "MailComposerController.h"

@interface SetChallengeConfirmationViewController () <MailComposerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *inviteUsersBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *lblInvitationMessage;

- (IBAction)sendInvitation:(id)sender;
- (IBAction)goToHomeScreenForThisTab:(id)sender;
@end

@implementation SetChallengeConfirmationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationItem setTitle:[self.challenge challengeName]];
    
    NSString *challengeType = [[CommonFunctions getNameForChallengeType:[self.challenge challengeType]] lowercaseString];
    [self.backgroundImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"bg_%@", challengeType]]];
    self.inviteUsersBackgroundView.layer.cornerRadius = 40.0;
    self.inviteUsersBackgroundView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.inviteUsersBackgroundView.layer.borderWidth = 2.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendInvitation:(id)sender {
    if (![MFMailComposeViewController canSendMail]) {
        [self showAlertWithMessage:@"Mail cannot be sent. Please configure your Email before sending"];
        return;
    }
    MailComposerController *mailComposerController = [[MailComposerController alloc] init];
    [mailComposerController setMailComposerDelegate:self];
    [mailComposerController setSubjectAndBodyForChallenge:self.challenge];
    [self presentViewController:mailComposerController animated:YES completion:nil];
}

- (void)showAlertWithMessage:(NSString *)errorMessage {
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Login Failed !" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[CommonFunctions getDismissAlertAction:nil]];
    [self presentViewController:alertView animated:YES completion:nil];
}

- (IBAction)goToHomeScreenForThisTab:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - MailComposerControllerDelegate
- (void)isMailSent:(BOOL)mailSent {
    [self.inviteUsersBackgroundView setHidden:mailSent];
    if (mailSent) {
        [self.lblInvitationMessage setText:@"Your invitation has been sent to other team members"];
    } else {
        
    }
}
@end
