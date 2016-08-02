//
//  ChallengeDetailViewController.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 03/03/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "ChallengeDetailViewController.h"
#import "SetActivityAndImageCell.h"
#import "CircularProgressViewCell.h"
#import "ChallengesViewCell.h"
#import "DescriptionViewCell.h"
#import "SetChallengeViewController.h"
#import "LeaveChallengeViewCell.h"
#import "EntitiesFetcher.h"
#import "LeaveDeleteChallengeService.h"

#define DEFAULT_ROWS         3
#define DEFAULT_SECTION     2
@interface ChallengeDetailViewController ()<UITableViewDataSource, UITableViewDelegate, LeaveChallengeDelegate>

@property (weak, nonatomic) IBOutlet UITableView *challengeDetailTableView;

- (IBAction)editClicked:(id)sender;
@end

@implementation ChallengeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationItem setTitle:[self.challenge challengeName]];
    [self.challengeDetailTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)editClicked:(id)sender {
    if ([self.challenge activities].count > 0) {
        [self showAlertWithMessage:@"This challenge cannot be edited any more as logging against this challenge have been started."];
        return;
    }
    [self performSegueWithIdentifier:@"showSetChallengeSegue" sender:self.challenge];
}

- (void)showAlertWithMessage:(NSString *)errorMessage {
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Edit Challenge !" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[CommonFunctions getDismissAlertAction:nil]];
    [self presentViewController:alertView animated:YES completion:nil];
}

- (void)showAlertWithMessage:(NSString *)errorMessage handler:(void (^ __nullable)(UIAlertAction *action))handler {
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Leave Challenge !" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[CommonFunctions getDismissAlertAction:handler]];
    [self presentViewController:alertView animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.challenge users].count > 0) {
        return (DEFAULT_SECTION + 1);
    }
    else return DEFAULT_SECTION;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger sections = [tableView numberOfSections];
    if (section == (sections - 1)) {
        return 1;
    } if (section == 0) {
        return DEFAULT_ROWS;
    }
    else {
        return [[self.challenge users] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger sections = [tableView numberOfSections];
    if (indexPath.section == (sections - 1)) {
        LeaveChallengeViewCell *leaveChallengeCell = (LeaveChallengeViewCell *)[tableView dequeueReusableCellWithIdentifier:@"LeaveChallengeViewCell" forIndexPath:indexPath];
        [leaveChallengeCell setLeaveChallengeDelegate:self];
        return leaveChallengeCell;
    }
    else if (indexPath.section == 0) {
        if(indexPath.row == 0) {
            SetActivityAndImageCell *imageViewCell = (SetActivityAndImageCell *)[tableView dequeueReusableCellWithIdentifier:@"SetActivityImageCell" forIndexPath:indexPath];
            [imageViewCell setChallengeType:[CommonFunctions getNameForChallengeType:[self.challenge challengeType]]];
            return imageViewCell;
        } else if(indexPath.row == 1) {
            CircularProgressViewCell *progressViewCell = (CircularProgressViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CircularProgressCell" forIndexPath:indexPath];
            
            [progressViewCell setChallenge:self.challenge];
            return progressViewCell;
        } else {
            DescriptionViewCell *descriptionViewCell = (DescriptionViewCell *)[tableView dequeueReusableCellWithIdentifier:@"DescriptionViewCell" forIndexPath:indexPath];
            
            [descriptionViewCell setDescriptionText:[self.challenge challengeDescription]];
            return descriptionViewCell;
        }
    }
    else {
        ChallengesViewCell *challengeViewCell = (ChallengesViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ChallengesViewCell" forIndexPath:indexPath];
        
        NSInteger index = indexPath.row;
        User *user = [[self.challenge users] objectAtIndex:index];
        [challengeViewCell setMainChallengeObject:self.challenge];
        [challengeViewCell setUserObject:user];
        [challengeViewCell refreshView];
        return challengeViewCell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSInteger sections = [tableView numberOfSections];
    if (section == (sections - 1) || section == 0) {
        return 0.0;
    } else {
        return 30.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger sections = [tableView numberOfSections];
    if (indexPath.section == (sections - 1)) {
        return 60.0;
    }
    else if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            CGRect rect = [UIScreen mainScreen].bounds;
            CGFloat labelHeight = [CommonFunctions heightWithWidthConstraint:rect.size.width - 36.0 ForString:[self.challenge challengeDescription] font:[UIFont systemFontOfSize:18.0]];
            return labelHeight;
        }
        return ((indexPath.row == 1) ? 170.0 : 60.0);
    }
    
    return 80.0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSInteger sections = [tableView numberOfSections];
    if (section == (sections - 1) || section == 0) {
        return nil;
    }
    else {
        NSString *monthName = @"Participants";
        
        CGRect rect = [UIScreen mainScreen].bounds;
        
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, rect.size.width, 30.0)];
        [headerLabel setTextColor:[UIColor colorWithRed:104.0/255.0 green:171.0/255.0 blue:248.0/255.0 alpha:1.0]];
        [headerLabel setBackgroundColor:[CommonFunctions getMainAppColor]];
        [headerLabel setTextAlignment:NSTextAlignmentCenter];
        [headerLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
        [headerLabel setText:[monthName uppercaseString]];
        
        return headerLabel;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - SegueNavigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showSetChallengeSegue"]) {
        Challenge *currentChallenge = (Challenge *)sender;
        
        SetChallengeViewController *destinationVC = segue.destinationViewController;
        destinationVC.challenge = currentChallenge;
        destinationVC.isEditMode = YES;
    }
}

#pragma mark - LeaveChallengeDelegate
- (void)leaveChallengeForUser {
    ProfileUser *profileUser = [CommonFunctions getLoggedInProfileUser:nil];
    
    if ([[profileUser userId] longLongValue] == [[self.challenge adminId] longLongValue]) {
        [self showAlertWithMessage:@"You cannot leave this challenge, since you are the admin for this challenge." handler:nil];
    } else {
        [self showAlertForConfirmationWithMessage:@"Do you want to leave this challenge?"];
    }
}

- (void)showAlertForConfirmationWithMessage:(NSString *)errorMessage {
    __weak typeof(self) weak = self;
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Fit Club !" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[CommonFunctions getYesAlertAction:^(UIAlertAction * _Nonnull action) {
        __weak typeof(ChallengeDetailViewController *) weakSelf = weak;
        ProfileUser *profileUser = [CommonFunctions getLoggedInProfileUser:nil];
        [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
        LeaveDeleteChallengeService *leaveChallengeService = [[LeaveDeleteChallengeService alloc] initWithChallengeId:[self.challenge challengeId] andUserId:[profileUser userId] forURL:LEAVE_CHALLENGE_URL];
        [leaveChallengeService leaveChallenge:^(BOOL isUpdated, NSString *message) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            if (isUpdated) {
                [weakSelf showAlertWithMessage:message handler:^(UIAlertAction * _Nonnull action) {
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                }];
            } else {
                [weakSelf showAlertWithMessage:message handler:nil];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            [weakSelf showAlertWithMessage:[error localizedDescription] handler:nil];
        }];
    }]];
    [alertView addAction:[CommonFunctions getNoAlertAction:nil]];
    [self presentViewController:alertView animated:YES completion:nil];
}

@end
