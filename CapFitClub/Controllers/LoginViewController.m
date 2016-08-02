//
//  LoginViewController.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 08/02/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "LoginViewController.h"
#import <MessageUI/MessageUI.h>
#import "LoginService.h"
#import "ProfileViewController.h"
#import "UIDevice+Size.h"
#import "CustomTextField.h"
#import "UserProfileService.h"
#import "EntitiesFetcher.h"
#import "CustomAlertViewController.h"

@interface LoginViewController () <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet CustomTextField *txtUserName;
@property (weak, nonatomic) IBOutlet CustomTextField *txtPassword;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *corporateTextTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *appLogoTopConstraint;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    self.txtUserName.layer.cornerRadius = TEXTFIELD_CORNER_RADIUS;
    self.txtPassword.layer.cornerRadius = TEXTFIELD_CORNER_RADIUS;
    
    if (([UIDevice isIPhone4])) {
        self.appLogoTopConstraint.constant = 20.0;
        self.corporateTextTopConstraint.constant = 10.0;
    }
    else if (([UIDevice isIPhone5])) {
        self.appLogoTopConstraint.constant = 49.0;
        self.corporateTextTopConstraint.constant = 23.0;
    }
    else if (([UIDevice isIPhone6])) {
        self.appLogoTopConstraint.constant = 74.0;
        self.corporateTextTopConstraint.constant = 55.0;
    }
    [self.txtUserName becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.txtUserName]) {
        [self.txtPassword becomeFirstResponder];
    }
    else if ([textField isEqual:self.txtPassword]) {
        [self sendLoginRequest];
    }
    return YES;
}

- (BOOL)validate {
    NSString *userName = [self.txtUserName text];
    NSString *password = [self.txtPassword text];
    
    if (!userName || [userName length] == 0) {
        [self showAlertWithMessage:@"Please enter your username."];
        return NO;
    } else if ([userName containsString:@" "]) {
        [self showAlertWithMessage:@"Your username should not contain spaces."];
        return NO;
    } else if (!password || [password length] == 0) {
        [self showAlertWithMessage:@"Please enter your password."];
        return NO;
    } else if ([password containsString:@" "]) {
        [self showAlertWithMessage:@"Your password should not contain spaces."];
        return NO;
    }
    return YES;
}

#pragma mark - ServiceCalls
- (void)sendLoginRequest {
    if (![self validate]) return;
    
    SGTEntityManager *entityManager = [[SGTEntityManager alloc] init];
    [entityManager deleteObjectsForName:@"Challenge"];
    [entityManager deleteObjectsForName:@"LocalChallenge"];
    [entityManager deleteObjectsForName:@"ProfileUser"];
    [entityManager deleteObjectsForName:@"Badge"];
    
    NSString *userName = [self.txtUserName text];
    NSString *password = [self.txtPassword text];
    
    NSDictionary *parameters = @{@"username":userName, @"password":password};
    
    [self.txtPassword resignFirstResponder];
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    LoginService *loginService = [[LoginService alloc] initWithParameters:parameters];
    [loginService getAppAuthentication:^(ProfileUser *profileUser) {
        
        [[AppConstants sharedInstance] setIsUserLoggedIn:YES];
        [weakSelf checkIfProfileNeedsToBeSetForProfileUser:profileUser];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[AppConstants sharedInstance] setIsUserLoggedIn:NO];
        
        [weakSelf showAlertWithMessage:[error localizedDescription]];
    } ];
}

- (void)checkIfProfileNeedsToBeSetForProfileUser:(ProfileUser *)profileUser {
    __weak typeof(self) weakSelf = self;
    
    if (!profileUser.dateOfBirth || !profileUser.gender) {
        [weakSelf performSegueWithIdentifier:@"ProfileViewSegue" sender:nil];
#if DEBUG
        NSLog(@"Set User Profile Now");
#endif
    } else {
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)showAlertWithMessage:(NSString *)errorMessage {
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Login Failed !" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[CommonFunctions getCancelAlertAction:nil]];
    [self presentViewController:alertView animated:YES completion:nil];
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ProfileViewSegue"]) {
//        ProfileViewController *profileViewController = segue.destinationViewController;
//        [profileViewController setIsFirstTimeUser:YES];
    }
}


@end
