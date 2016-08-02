//
//  MailComposerController.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 09/03/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "MailComposerController.h"
#import "EntitiesFetcher.h"
#import "ProfileUser.h"

@interface MailComposerController ()

@end

@implementation MailComposerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationItem setTitle:@"Invite Others to Join"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setSubjectAndBodyForChallenge:(Challenge *)challenge {
    NSString *emailTitle = @"Join my Capgemini BeHealthy Challenge!";
    // Email Content
    NSString *messageBody = [NSString stringWithFormat:@"Hi,<br><br>Join my Capgemini BeHealthy Challenge!<br><br><b>Joining the Challenge</b><br>If you haven't already downloaded the app, <a href=\"https://i.diawi.com/RP11Gr \">Click here</a>.<br><br>If you already have the app on your device, <a href=\"openChallenge://com.capgemini.FitClub?cid=%@ \">Click here</a> to view the challenge and join!<br><br>Yours,<br><br>", [challenge challengeId]];
    
    ProfileUser *profileUser = [CommonFunctions getLoggedInProfileUser:nil];
    NSString *firstName = [profileUser firstName];
    NSString *lastName = [profileUser lastName];
    NSString *userName = [NSString stringWithFormat:@"%@ %@", (firstName ? firstName : @""), (lastName ? lastName :@"")];
    
    if (profileUser.firstName && profileUser.lastName) {
        messageBody = [NSString stringWithFormat:@"%@ %@", messageBody, userName];
    }
    
    [self initializeMFMailController];
    [self setMailComposeDelegate:self];
    [self setSubject:emailTitle];
    [self setMessageBody:messageBody isHTML:YES];
}

- (void)initializeMFMailController {
    [self.navigationItem setTitle:@"Invite Others to Join"];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[CommonFunctions getMainAppColor]}];
    [self.navigationBar setTranslucent:YES];
    [self.navigationBar setTintColor:[CommonFunctions getMainAppColor]];
    [self.view setBackgroundColor:[UIColor colorWithRed:231.0/255.0 green:241.0/255.0 blue:246.0/255.0 alpha:1.0]];
}

#pragma mark - MFMailComposeViewController
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    if (result == MFMailComposeResultSent) {
        [self.mailComposerDelegate isMailSent:YES];
    } else {
        [self.mailComposerDelegate isMailSent:NO];
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
