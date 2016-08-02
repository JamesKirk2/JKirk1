//
//  DashboardViewController.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 10/02/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "DashboardViewController.h"
#import "ProfileImageViewCell.h"
#import "CountsViewCell.h"
#import "ChallengesViewCell.h"
#import "GetChallengesService.h"
#import "EntitiesFetcher.h"
#import "ChallengeDetailViewController.h"
#import "MBProgressHUD.h"
#import "ChallengeTypeService.h"
#import "LeaveDeleteChallengeService.h"
#import "GetBadgesService.h"

@interface DashboardViewController ()<NSFetchedResultsControllerDelegate, ChallengesViewCellDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *dashboardTableView;

@property (nonatomic, strong) NSArray *monthsArray;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) ProfileUser *profileUser;

@property (nonatomic, strong) SGTEntityManager *entityManager;
@property (nonatomic, strong) NSFetchedResultsController *challengesFetchController;
@property (nonatomic, strong) NSFetchedResultsController *badgesFetchController;

@property (nonatomic, assign) BOOL isAlreadyFetched;
@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.entityManager = [[SGTEntityManager alloc] init];
    self.monthsArray = @[@"January challenges",@"February challenges",@"March challenges",@"April challenges",@"May challenges",@"June challenges", @"July challenges", @"August challenges", @"September challenges", @"October challenges", @"November challenges", @"December challenges"];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(joinChallenge:) name:JOIN_CHALLENGE_NOTIFICATION object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.profileUser = [CommonFunctions getLoggedInProfileUser:nil];
    [[AppConstants sharedInstance] setIsUserLoggedIn:[self checkForExistingSession]];
    if (![[AppConstants sharedInstance] isUserLoggedIn]) {
        self.isAlreadyFetched = NO;
        [self performSelector:@selector(showLoginController) withObject:nil afterDelay:0.2];
    } else if (![CommonFunctions isUserProfileSetForUser:self.profileUser]) {
        [self performSegueWithIdentifier:@"ShowProfileViewController" sender:nil];
    } else if (!self.isAlreadyFetched){
        self.isAlreadyFetched = YES;
        [self initializeFetchController];
    }
    [self.dashboardTableView reloadData];
}

- (BOOL)checkForExistingSession {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults objectForKey:USER_SESSION_TOKEN];
    NSString *sessionName = [userDefaults objectForKey:USER_SESSION_NAME];
    NSString *sessionId = [userDefaults objectForKey:USER_SESSION_ID];
    
    if (token && sessionId && sessionName) {
        return YES;
    }
    return NO;
}

- (void)initializeFetchController {
    [self.entityManager deleteObjectsForName:@"Challenge"];
    
    EntitiesFetcher *entityFetcher = [[EntitiesFetcher alloc] initWithEntityManager:self.entityManager];
    self.challengesFetchController = [entityFetcher getChallengeFetchResultController];
    self.challengesFetchController.delegate = self;
    
    self.badgesFetchController = [entityFetcher getWonBadgesFetchResultController];
    self.badgesFetchController.delegate = self;
    
//    if ([self.challengesFetchController fetchedObjects].count <= 0) {
        [self fetchAllChallenges];
//    } 
}

- (void)fetchAllChallenges {
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    ChallengeTypeService *challengeTypeService = [[ChallengeTypeService alloc] init];
    [challengeTypeService getAllChallengeTypes:^(NSError *error) {
        
        GetChallengesService *getChallengesService = [[GetChallengesService alloc] initWithUserId:[self.profileUser userId]];
        [getChallengesService getAllChallenges:^(BOOL isChallengePresent) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            
            if (isChallengePresent) {
                [weakSelf.dashboardTableView reloadData];
            } else {
                [weakSelf.tabBarController setSelectedIndex:4];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            [weakSelf showAlertWithMessage:[error localizedDescription]];
        }];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf showAlertWithMessage:[error localizedDescription]];
    }];
    
    GetBadgesService *getBadgesService = [[GetBadgesService alloc] initWithUserId:[self.profileUser userId]];
    [getBadgesService getBadges:^(BOOL isUpdate, NSString *statusMessage) {
    } failure:^(NSError *error) {
    }];
}

- (void)showAlertWithMessage:(NSString *)errorMessage {
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Fit Club !" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[CommonFunctions getDismissAlertAction:nil]];
    [self presentViewController:alertView animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showLoginController {
    UIStoryboard *storyboard = [CommonFunctions getStoryBoardWithName:@"Main"];
    UINavigationController *loginController = [storyboard
                                               instantiateViewControllerWithIdentifier:@"loginController"];

    [self presentViewController:loginController animated:YES completion:nil];
}

- (void)joinChallenge:(NSNotification *)notification {
    [self.tabBarController setSelectedIndex:4];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return ([[self.challengesFetchController sections] count] + 1);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else {
        NSArray <id<NSFetchedResultsSectionInfo>>*array = [self.challengesFetchController sections];
        id <NSFetchedResultsSectionInfo> sectionInfo = array[section-1];
        return ([sectionInfo numberOfObjects]);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if(indexPath.row == 0) {
            ProfileImageViewCell *imageViewCell = (ProfileImageViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ProfileImageViewCell" forIndexPath:indexPath];
            [imageViewCell setUserData:self.profileUser withImage:nil];
            return imageViewCell;
        } else {
            CountsViewCell *countsViewCell = (CountsViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CountsViewCell" forIndexPath:indexPath];
            [countsViewCell setNumberOfBadges:[[self.badgesFetchController fetchedObjects] count]];
            NSArray <id<NSFetchedResultsSectionInfo>>*array = [self.challengesFetchController sections];
            if ([array count] > 0) {
                id <NSFetchedResultsSectionInfo> sectionInfo = array[indexPath.section];
                [countsViewCell setNumberOfChallenges:[sectionInfo numberOfObjects]];
            }
            
            return countsViewCell;
        }
    } else {
        ChallengesViewCell *challengesViewCell = (ChallengesViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ChallengesViewCell" forIndexPath:indexPath];
        
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - 1];
        Challenge *challenge = [self.challengesFetchController objectAtIndexPath:newIndexPath];
        [challengesViewCell addGesture];
        [challengesViewCell setMainChallengeObject:challenge];
        [challengesViewCell setChallengesViewCellDelegate:self];
        [challengesViewCell refreshView];
        return challengesViewCell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (section == 0) ? 0 : 30.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return ((indexPath.row == 0) ? 212.0 : 60.0);
    }
    return 60.0;
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    } else {
        NSArray <id<NSFetchedResultsSectionInfo>>*array = [self.challengesFetchController sections];
        id <NSFetchedResultsSectionInfo> sectionInfo = array[section-1];
        
        NSString *monthName = [sectionInfo name];        
        CGRect rect = [UIScreen mainScreen].bounds;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, rect.size.width, 30.0)];
        [view setBackgroundColor:[CommonFunctions getMainAppColor]];
        
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 10.0, rect.size.width, 20.0)];
        [headerLabel setTextColor:[UIColor colorWithRed:104.0/255.0 green:171.0/255.0 blue:248.0/255.0 alpha:1.0]];
        [headerLabel setTextAlignment:NSTextAlignmentCenter];
        [headerLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
        [headerLabel setText:[monthName uppercaseString]];
        
        [view addSubview:headerLabel];
        return view;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (self.selectedIndexPath) {
        ChallengesViewCell *challengesViewCell = [self.dashboardTableView cellForRowAtIndexPath:self.selectedIndexPath];
        [challengesViewCell hideDeleteButton];
        self.selectedIndexPath = nil;
    } else if(indexPath.section > 0) {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - 1];
        Challenge *challenge = [self.challengesFetchController objectAtIndexPath:newIndexPath];
        [self performSegueWithIdentifier:@"showChallengeDetail" sender:challenge];
    }
}

#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
//    [self.dashboardTableView reloadData];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(nullable NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(nullable NSIndexPath *)newIndexPath {
    if (indexPath && type == NSFetchedResultsChangeDelete) {
        
    }
    [self.dashboardTableView reloadData];
}

#pragma mark - ChallengesViewCellDelegate
- (void)sendSelectedCell:(ChallengesViewCell *)cell {
    if (self.selectedIndexPath) {
        ChallengesViewCell *challengesViewCell = [self.dashboardTableView cellForRowAtIndexPath:self.selectedIndexPath];
        [challengesViewCell hideDeleteButton];
    }
    if (!cell) {
        self.selectedIndexPath = nil;
    } else {
        NSIndexPath *indexPath = [self.dashboardTableView indexPathForCell:cell];
        self.selectedIndexPath = indexPath;
    }
}

- (void)deleteSelectedCell:(ChallengesViewCell *)cell {
    if (self.selectedIndexPath) {
        [cell hideDeleteButton];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.selectedIndexPath.row inSection:self.selectedIndexPath.section-1];
        Challenge *challenge = [self.challengesFetchController objectAtIndexPath:indexPath];
        
        if ([self.profileUser.userId longLongValue] == [challenge.adminId longLongValue]) {
            [self showAlertForConfirmationWithMessage:@"Do you want to delete this challenge?"];
        } else {
            [self showAlertWithMessage:@"You have not created this challenge so you do not have the permission to delete this challenge."];
        }
    }
}

- (void)showAlertForConfirmationWithMessage:(NSString *)errorMessage {
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Fit Club !" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[CommonFunctions getYesAlertAction:^(UIAlertAction * _Nonnull action) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:weakSelf.selectedIndexPath.row inSection:weakSelf.selectedIndexPath.section-1];
        Challenge *challenge = [weakSelf.challengesFetchController objectAtIndexPath:indexPath];
        
        [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
        LeaveDeleteChallengeService *deleteChallengeService = [[LeaveDeleteChallengeService alloc] initWithChallengeId:[challenge challengeId] andUserId:[weakSelf.profileUser userId] forURL:DELETE_CHALLENGE_URL];
        [deleteChallengeService deleteChallenge:^(BOOL isUpdated, NSString *message) {
            
            weakSelf.selectedIndexPath = nil;
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            [weakSelf showAlertWithMessage:message];
        } failure:^(NSError *error) {
            weakSelf.selectedIndexPath = nil;
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            [weakSelf showAlertWithMessage:[error localizedDescription]];
        }];
    }]];
    [alertView addAction:[CommonFunctions getNoAlertAction:^(UIAlertAction * _Nonnull action) {
        weakSelf.selectedIndexPath = nil;
    }]];
    [self presentViewController:alertView animated:YES completion:nil];
}

#pragma mark - SegueNavigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showChallengeDetail"]) {
        ChallengeDetailViewController *destinationVC = segue.destinationViewController;
        destinationVC.challenge = (Challenge *)sender;
    }
}

@end
