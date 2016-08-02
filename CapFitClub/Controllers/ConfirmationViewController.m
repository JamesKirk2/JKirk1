//
//  ConfirmationViewController.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 14/03/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "ConfirmationViewController.h"
#import "EntitiesFetcher.h"
#import "ChallengeType.h"

@interface ConfirmationViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *challengeImageView;
@property (strong, nonatomic) NSString *statusMessage;

- (void)setStatusMessageForAlert:(NSString *)statusMessage;
- (IBAction)goToHomeScreenForThisTab:(id)sender;
@end

@implementation ConfirmationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationItem setTitle:[self.challenge challengeName]];
    
    NSString *challengeType = [[CommonFunctions getNameForChallengeType:[self.challenge challengeType]] lowercaseString];
    NSString *imageName = [NSString stringWithFormat:@"bg_%@", challengeType];
    [self.backgroundImageView setImage:[UIImage imageNamed:imageName]];
    [self.challengeImageView setImage:[UIImage imageNamed:challengeType]];
}

- (void)viewDidAppear:(BOOL)animated {
    [self showAlertWithMessage:self.statusMessage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setStatusMessageForAlert:(NSString *)statusMessage {
    self.statusMessage = statusMessage;
}

- (void)showAlertWithMessage:(NSString *)errorMessage {
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Join Challenge !" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[CommonFunctions getDismissAlertAction:nil]];
    [self presentViewController:alertView animated:YES completion:nil];
}

- (IBAction)goToHomeScreenForThisTab:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
