//
//  SetChallengeViewController.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 02/02/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "SetChallengeViewController.h"
#import "SetActivityAndImageCell.h"
#import "ProfileViewCell.h"
#import "DescriptionViewCell.h"
#import "SetChallengeGoalViewCell.h"
#import "SearchableViewCell.h"
#import "Entitiesfetcher.h"
#import "CustomPickerView.h"
#import "SelectChallengeViewController.h"
#import "SetChallengeConfirmationViewController.h"
#import "CreateUpdateChallengeService.h"

@interface SetChallengeViewController ()<ProfileViewCellDelegate, CustomPickerDelegate, SearchableViewCellDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *setChallengeTableView;
@property (weak, nonatomic) IBOutlet CustomPickerView *customDatePickerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *customPickerBottomConstraint;

@property (strong, nonatomic) NSIndexPath *currentRowIndexPath;
@property (strong, nonatomic) NSIndexPath *savedRowIndexPath;

@property (nonatomic, strong) SGTEntityManager *entityManager;
@property (nonatomic, assign) BOOL canEditChallenge;

- (IBAction)startChallenge:(id)sender;
- (IBAction)saveChallenge:(id)sender;
@end

@implementation SetChallengeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.entityManager = [[SGTEntityManager alloc] init];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.canEditChallenge = YES;
    self.tableBottomConstraint.constant = (self.isEditMode ? 0 : -1) * TAB_BAR_HEIGHT;
    if ([self.challenge activities].count > 0) {
        [self setCanEditChallenge:NO];
    }
    
    if (self.isEditMode) {
        [self.navigationItem setRightBarButtonItem:[CommonFunctions barButtonItemWithTitle:@"SAVE" target:self selector:@selector(saveChallenge:)]];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetTableViewHeight:) name:UIKeyboardDidHideNotification object:nil];
    [self.customDatePickerView setCustomPickerDelegate:self];
    [self.setChallengeTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)validate {
    NSString *challengeName = [self.challenge challengeName];
    NSString *challengeDescription = [self.challenge challengeDescription];
    NSNumber *challengeGoal = [self.challenge challengeGoal];
    NSDate *endDate = [self.challenge endDate];
    
    if (!challengeName || [challengeName length] == 0) {
        [self showAlertWithMessage:@"Please enter a name for your challenge."];
        return NO;
    } else if (!challengeDescription || [challengeDescription length] == 0) {
        [self showAlertWithMessage:@"Please enter a description for your challenge."];
        return NO;
    } else if (!challengeGoal || [challengeGoal longLongValue] == 0) {
        [self showAlertWithMessage:@"Please set a goal for your challenge."];
        return NO;
    } else {
        if (!endDate) {
            [self showAlertWithMessage:@"Please select an end date for your challenge."];
            return NO;
        } else if ([endDate timeIntervalSinceDate:[NSDate date]] < 0) {
            [self showAlertWithMessage:@"Please select an end date grater than today."];
            return NO;
        }
    }
    return YES;
}

- (IBAction)startChallenge:(id)sender {
    [self createChallengeWithServiceURL:CREATE_CHALLENGE_URL];
}

- (IBAction)saveChallenge:(id)sender {
    if ([self.challenge activities].count > 0) {
        [self showAlertWithMessage:@"This challenge cannot be edited any more as logging against this challenge have been started."];
        return;
    }
    [self createChallengeWithServiceURL:UPDATE_CHALLENGE_URL];
}

- (void)createChallengeWithServiceURL:(NSString *)url {
    [self.view endEditing:YES];
    
    if (![self validate]) return;
    
    __weak typeof(self) weakSelf = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    CreateUpdateChallengeService *createChallengeService = [[CreateUpdateChallengeService alloc] initWithParameters:[self createPostBodyForChallenge:self.challenge] forURL:url];
    [createChallengeService createUpdateChallenge:^(NSNumber *challengeId) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (challengeId) {
            [weakSelf.challenge setChallengeId:challengeId];
            BOOL isUpdated = [weakSelf createChallenge:weakSelf.challenge];
            if (isUpdated) {
                [weakSelf performSegueWithIdentifier:@"showConfirmationScreen" sender:weakSelf.challenge];
            }
        }
        else {
            [weakSelf showAlertWithMessage:@"Challenge with specified details cannot be saved."];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [weakSelf showAlertWithMessage:[error localizedDescription]];
    }];
}

- (NSDictionary *)createPostBodyForChallenge:(Challenge *)challenge {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{@"name":[challenge challengeName],
                                                                                      @"description":[challenge challengeDescription],
                                                                                      @"type":[challenge challengeType],
                                                                                      @"goal":[challenge challengeGoal],
                                                                                      @"goal_unit":[challenge challengeGoalUnit],
                                                                                      @"startDate":[NSNumber numberWithLongLong:[[challenge startDate] timeIntervalSince1970]],
                                                                                      @"endDate":[NSNumber numberWithLongLong:[[challenge endDate] timeIntervalSince1970]],
                                                                                      @"isSearchable":[challenge isSearchable],
                                                                                      @"adminId":[challenge adminId]}];
    if ([challenge challengeId]) {
        [parameters setObject:[challenge challengeId] forKey:@"challengeId"];
    }
    
    return parameters;
}

- (BOOL)createChallenge:(Challenge *)challenge {
    EntitiesFetcher *entityFetcher = [[EntitiesFetcher alloc] initWithEntityManager:self.entityManager];
        
    Challenge *existingChallenge = [entityFetcher fetchChallengeWithChallengeId:challenge.challengeId];
    if (!existingChallenge) {
        [self.entityManager insertEntity:challenge];
        
        ProfileUser *profileUser = [CommonFunctions getLoggedInProfileUser:nil];
        
        if (profileUser) {
            User *user = [self.entityManager insertEntityWithName:NSStringFromClass([User class])];
            [user setattributesFromProfileUser:profileUser];
            
            [challenge setUsers:[NSOrderedSet orderedSetWithObject:user]];
        }
    }
    [existingChallenge setSectionIdentifierForChallenge:nil];
    NSError *error;
    return [self.entityManager save:&error];
}

- (void)showAlertWithMessage:(NSString *)errorMessage {
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Set Challenge !" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[CommonFunctions getDismissAlertAction:nil]];
    [self presentViewController:alertView animated:YES completion:nil];
}

- (void)setChallengeWithValue:(NSString *)value forIndex:(NSInteger)index {
    switch (index) {
        case 0:
            [self.challenge setChallengeName:value];
            break;
        case 1:
            [self.challenge setChallengeDescription:value];
            break;
        case 2:
            [self.challenge setChallengeGoal:[NSNumber numberWithLongLong:[value longLongValue]]];
            break;
        default:
            break;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        ProfileViewCell *profileViewCell = (ProfileViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ProfileViewCell" forIndexPath:indexPath];
        [profileViewCell setProfileCellDelegate:self];
        [profileViewCell setTextFieldPlaceholderText:[NSString stringWithFormat:@"<%@>", @"enter challenge name"] withTag:INDEX_FIRST_NAME];
        [profileViewCell setTextFieldText:[self.challenge challengeName] withReturnKey:UIReturnKeyNext];
        [profileViewCell setUserInteractionEnabled:self.canEditChallenge];
        return profileViewCell;
    } else if (indexPath.row == 1) {
        DescriptionViewCell *descriptionCell = (DescriptionViewCell *)[tableView dequeueReusableCellWithIdentifier:@"DescriptionViewCell" forIndexPath:indexPath];
        [descriptionCell setProfileCellDelegate:self];
        [descriptionCell setDescriptionText:[self.challenge challengeDescription]];
        [descriptionCell setUserInteractionEnabled:self.canEditChallenge];
        return descriptionCell;
    } else if (indexPath.row == 2) {
        SetActivityAndImageCell *activityAndImageCell = (SetActivityAndImageCell *)[tableView dequeueReusableCellWithIdentifier:@"SetActivityImageAndCell" forIndexPath:indexPath];
        [activityAndImageCell setChallengeType:[CommonFunctions getNameForChallengeType:[self.challenge challengeType]]];
        [activityAndImageCell setUserInteractionEnabled:self.canEditChallenge];
        return activityAndImageCell;
    } else if (indexPath.row == 3) {
        SetActivityAndImageCell *activityAndImageCell = (SetActivityAndImageCell *)[tableView dequeueReusableCellWithIdentifier:@"SetActivityImageAndCell" forIndexPath:indexPath];
        [activityAndImageCell setLogoImage];
        return activityAndImageCell;
    } else if (indexPath.row == 4) {
        SetChallengeGoalViewCell *setChallengeGoalCell = (SetChallengeGoalViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SetChallengeGoalViewCell" forIndexPath:indexPath];
        [setChallengeGoalCell setProfileCellDelegate:self];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ChallengesGoal" ofType:@"plist"];
        NSDictionary *challengeGoals = [[NSDictionary alloc] initWithContentsOfFile:filePath];
        [setChallengeGoalCell setSegmentWithItems:[challengeGoals objectForKey:[[CommonFunctions getNameForChallengeType:[self.challenge challengeType]] lowercaseString]]];
        [setChallengeGoalCell setGoal:[self.challenge challengeGoal] withGoalUnit:[self.challenge challengeGoalUnit]];
        [setChallengeGoalCell setUserInteractionEnabled:self.canEditChallenge];
        return setChallengeGoalCell;
    } else if (indexPath.row == 5) {
        ProfileViewCell *pickDateCell = (ProfileViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PickDateCell" forIndexPath:indexPath];
        [pickDateCell setProfileCellDelegate:self];
        [pickDateCell setButtonValue:[NSString stringWithFormat:@"%@", @"Select End date"]];
        if ([self.challenge endDate]) {
            [pickDateCell setButtonValue:[NSString stringWithFormat:@"%@", [CommonFunctions formatDateFrom:[self.challenge endDate]]]];
        }
        [pickDateCell setUserInteractionEnabled:self.canEditChallenge];
        return pickDateCell;
    } else {
        SearchableViewCell *searchableViewCell = (SearchableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SearchableViewCell" forIndexPath:indexPath];
        [searchableViewCell setSearchableCellDelegate:self];
        [searchableViewCell setSearchableFlag:[[self.challenge isSearchable] boolValue]];
        [searchableViewCell setUserInteractionEnabled:self.canEditChallenge];
        return searchableViewCell;
    }
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ((indexPath.row == 1) ? 120.0 : (indexPath.row == 4) ? 125.0 : ((indexPath.row == 6) ? 115.0 : 60.0));
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row == 2) {
        [self performSegueWithIdentifier:@"showSelectChallengeSegue" sender:self];
    }
}

#pragma mark - SegueNavigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showSelectChallengeSegue"]) {
        SelectChallengeViewController *selectChallengeController = (SelectChallengeViewController *) segue.destinationViewController;
        [selectChallengeController setIsSegueCallingDisabled:YES];
        [selectChallengeController setChallenge:self.challenge];
    } else if([segue.identifier isEqualToString:@"showConfirmationScreen"]) {
        Challenge *challenge = (Challenge *)sender;
        SetChallengeConfirmationViewController *startChallengeController = (SetChallengeConfirmationViewController *) segue.destinationViewController;
        [startChallengeController setChallenge:challenge];
    }
}

#pragma mark - ProfileViewCellDelegate
- (void)callBackForScollingCell:(UITableViewCell *)profileCell {
    NSIndexPath *indexPath = [self.setChallengeTableView indexPathForCell:profileCell];
    
    if (indexPath.row == 5) {
        [self.view endEditing:YES];
        self.currentRowIndexPath = nil;
        self.savedRowIndexPath = indexPath;
        [self performSelector:@selector(openCustomPicker:) withObject:indexPath afterDelay:0.0];
    }
    else {
        [self resettingCustomPickerView];
        
        self.currentRowIndexPath = indexPath;
        self.savedRowIndexPath = indexPath;
        [UIView animateWithDuration:0.5 animations:^{
            self.tableBottomConstraint.constant = KEYBOARD_HEIGHT + ((self.isEditMode ? -1 : -2) * TAB_BAR_HEIGHT);
        } completion:^(BOOL finished) {
            [self.setChallengeTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }];
    }
}

- (void) openCustomPicker:(NSIndexPath *)indexPath {
    if (indexPath.row == 5) {
        NSDate *endDate = [self.challenge endDate];
        [self.customDatePickerView initDatePicker:kDATE_PICKER withValue:endDate];
        [self.customDatePickerView setDatePickerMinDate:[NSDate date]];
    }
    
    self.tableBottomConstraint.constant = KEYBOARD_HEIGHT + ((self.isEditMode ? 0 : -1) * TAB_BAR_HEIGHT);
    self.customPickerBottomConstraint.constant = TAB_BAR_HEIGHT;
    [self.customDatePickerView setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.setChallengeTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }];
}

- (void)callBackForMakingNextCellAsFirstResponder:(UITableViewCell *)profileCell {
    
    DescriptionViewCell *descriptionViewCell = nil;
    NSIndexPath *indexPath = [self.setChallengeTableView indexPathForCell:profileCell];
    
    if ([profileCell isKindOfClass:[ProfileViewCell class]]) {
         if (indexPath) {
            NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:(indexPath.row +1) inSection:indexPath.section];
            descriptionViewCell = [self.setChallengeTableView cellForRowAtIndexPath:newIndexPath];
            [descriptionViewCell makeTextViewAsFirstResponder];
        }
    } else if ([profileCell isKindOfClass:[DescriptionViewCell class]]) {
        descriptionViewCell = [self.setChallengeTableView cellForRowAtIndexPath:indexPath];
        [descriptionViewCell resignTextViewAsFirstResponder];
        [self callBackForHidingKeyboard:nil];
    }
}

- (void)setValueForCell:(UITableViewCell *)cell withValue:(NSString *)strValue {
    if ([cell isKindOfClass:[ProfileViewCell class]]) {
        [self setChallengeWithValue:strValue forIndex:0];
    } else if ([cell isKindOfClass:[DescriptionViewCell class]]) {
        [self setChallengeWithValue:strValue forIndex:1];
    } else if ([cell isKindOfClass:[SetChallengeGoalViewCell class]]) {
        [self setChallengeWithValue:strValue forIndex:2];
    }
}

- (void)callBackForHidingKeyboard:(ProfileViewCell *)profileCell {
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardDidHideNotification object:nil];
}

- (void)resetTableViewHeight:(NSNotification *)notification {
    if (notification && self.currentRowIndexPath) {
        [UIView animateWithDuration:0.5 animations:^{
            self.tableBottomConstraint.constant = (self.isEditMode ? 0 : -1) * TAB_BAR_HEIGHT;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)setGoalUnitForChallenge:(NSString *)goalUnit {
    [self.challenge setChallengeGoalUnit:goalUnit];
}

#pragma mark - SearchableViewCellDelegate
- (void)setIsSearchableFlag:(BOOL)isSearchable {
    [self.challenge setIsSearchable:[NSNumber numberWithBool:isSearchable]];
}

#pragma mark - CustomPickerDelegate
- (void)datePickerValueChangedClicked:(NSDate *)value {
    NSString *selectedValue = [CommonFunctions formatDateFrom:value];
    ProfileViewCell *profileViewCell1 = [self.setChallengeTableView cellForRowAtIndexPath:self.savedRowIndexPath];
    [profileViewCell1 setButtonValue:selectedValue];
    
    [self.challenge setEndDate:value];
}

- (void)doneClicked {
    self.tableBottomConstraint.constant = (self.isEditMode ? 0 : -1) * TAB_BAR_HEIGHT;
    [self.setChallengeTableView setNeedsUpdateConstraints];
    
    [self resettingCustomPickerView];
}

- (void)resettingCustomPickerView {
    self.customPickerBottomConstraint.constant = self.customDatePickerView.frame.size.height * -1;
    [self.customDatePickerView setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.customDatePickerView layoutIfNeeded];
        [self.setChallengeTableView layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}
@end
