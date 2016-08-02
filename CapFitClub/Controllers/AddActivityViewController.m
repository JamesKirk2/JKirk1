//
//  AddActivityViewController.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 28/03/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "AddActivityViewController.h"
#import "EntitiesFetcher.h"
#import "ChallengeType.h"
#import "LogActivityViewCell.h"
#import "LogActivityUpdateCell.h"
#import "UpdateLogActivityService.h"

@interface AddActivityViewController ()<UITableViewDataSource, UITableViewDelegate, ProfileViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *addActivityTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBottomConstraint;

@property (strong, nonatomic) NSNumber *targetValue;

- (IBAction)updateChallengeClicked:(id)sender;
@end

@implementation AddActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationItem setTitle:[CommonFunctions getNameForChallengeType:[self.challenge challengeType]]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetTableViewHeight:) name:UIKeyboardDidHideNotification object:nil];
    [self.addActivityTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showAlertWithMessage:(NSString *)errorMessage handler:(void (^ __nullable)(UIAlertAction *action))handler {
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Fit Club !" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[CommonFunctions getDismissAlertAction:handler]];
    [self presentViewController:alertView animated:YES completion:nil];
}

- (IBAction)updateChallengeClicked:(id)sender {
    __weak typeof(self) weakSelf = self;
    
    if ([self.targetValue longLongValue] <= 0) {
        [self showAlertWithMessage:@"Please enter value which you have completed for today." handler:nil];
        return;
    }
    ProfileUser *user = [CommonFunctions getLoggedInProfileUser:nil];
    NSDictionary *parameters = @{@"userId":[user userId],
                                                          @"challengeId":[self.challenge challengeId],
                                                          @"completedvalue":self.targetValue,
                                                          @"date":[NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970]]};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    UpdateLogActivityService *logActivityService = [[UpdateLogActivityService alloc] initWithParameters:parameters];
    [logActivityService updateActivityForChallenge:^(BOOL isUpdated, NSString *message) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [weakSelf.addActivityTableView reloadData];
        [weakSelf showAlertWithMessage:message handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }];
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [weakSelf showAlertWithMessage:[error localizedDescription] handler:nil];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (1 + [self.challenge activities].count);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        LogActivityViewCell *logActivityViewCell = (LogActivityViewCell *)[tableView dequeueReusableCellWithIdentifier:@"LogActivityViewCell" forIndexPath:indexPath];
        
        [logActivityViewCell setChallengeTypeImage:[UIImage imageNamed:[[CommonFunctions getNameForChallengeType:[self.challenge challengeType]] lowercaseString]]];
        [logActivityViewCell setCurrentChallenge:self.challenge];
        [logActivityViewCell setProfileCellDelegate:self];
        return logActivityViewCell;
    } else {
        Activity *activity = [[self.challenge activities] objectAtIndex:indexPath.row - 1];
        LogActivityUpdateCell *logActivityUpdateCell = (LogActivityUpdateCell *)[tableView dequeueReusableCellWithIdentifier:@"LogActivityUpdateCell" forIndexPath:indexPath];
        [logActivityUpdateCell setLogActivity:activity WithGoalUnit:[self.challenge challengeGoalUnit]];
        return logActivityUpdateCell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != 0) return 44.0;
    return 400.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - ProfileViewCellDelegate
- (void)callBackForScollingCell:(ProfileViewCell *)profileCell {
    NSIndexPath *indexPath = [self.addActivityTableView indexPathForCell:profileCell];
    
    
    [UIView animateWithDuration:0.5 animations:^{
        self.tableBottomConstraint.constant = KEYBOARD_HEIGHT;
    } completion:^(BOOL finished) {
        [self.addActivityTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }];
}

- (void)callBackForMakingNextCellAsFirstResponder:(UITableViewCell *)profileCell {
    
}

- (void)setValueForCell:(UITableViewCell *)cell withValue:(NSString *)strValue {
    [self setTargetValue:[NSNumber numberWithLongLong:[strValue longLongValue]]];
}

- (void)resetTableViewHeight:(NSNotification *)notification {
    [UIView animateWithDuration:0.5 animations:^{
        self.tableBottomConstraint.constant = 0;;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}
@end
