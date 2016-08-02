//
//  CompletedChallengesViewController.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 28/03/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "CompletedChallengesViewController.h"
#import "CommonFunctions.h"
#import "ChallengesViewCell.h"
#import "EntitiesFetcher.h"
#import "GetChallengesService.h"

@interface CompletedChallengesViewController ()<NSFetchedResultsControllerDelegate, ChallengesViewCellDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *completedChallengesTableView;

@property (nonatomic, strong) SGTEntityManager *entityManager;
@property (nonatomic, strong) NSFetchedResultsController *challengesFetchController;

@property (nonatomic, assign) BOOL isAlreadyFetched;
@end

@implementation CompletedChallengesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.entityManager = [[SGTEntityManager alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!self.isAlreadyFetched){
        [self initializeFetchController];
        self.isAlreadyFetched = YES;
    }
    [self.completedChallengesTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeFetchController {
    EntitiesFetcher *entityFetcher = [[EntitiesFetcher alloc] initWithEntityManager:self.entityManager];
    self.challengesFetchController = [entityFetcher getCompletedChallengeFetchResultController];
    self.challengesFetchController.delegate = self;
    
    if ([self.challengesFetchController fetchedObjects].count <= 0) {
        [self fetchAllChallenges];
    }
}

- (void)fetchAllChallenges {
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    ProfileUser *profileUser = [CommonFunctions getLoggedInProfileUser:nil];
    
    GetChallengesService *getChallengesService = [[GetChallengesService alloc] initWithUserId:[profileUser userId]];
    [getChallengesService getAllChallenges:^(BOOL isChallengePresent) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if (isChallengePresent) {
            [weakSelf.completedChallengesTableView reloadData];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf showAlertWithMessage:[error localizedDescription]];
    }];
}

- (void)showAlertWithMessage:(NSString *)errorMessage {
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Fit Club !" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[CommonFunctions getDismissAlertAction:nil]];
    [self presentViewController:alertView animated:YES completion:nil];
}

- (IBAction)completedChallengesClicked:(id)sender {
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ([self.challengesFetchController fetchedObjects].count);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChallengesViewCell *challengesViewCell = (ChallengesViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ChallengesViewCell" forIndexPath:indexPath];
    
    Challenge *challenge = [self.challengesFetchController objectAtIndexPath:indexPath];
    [challengesViewCell setCompletedChallengeObject:challenge];
    [challengesViewCell setChallengesViewCellDelegate:self];
    [challengesViewCell refreshView];
    return challengesViewCell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *monthName = @"Completed Challenges";
    
    CGRect rect = [UIScreen mainScreen].bounds;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, rect.size.width, 40.0)];
    [view setBackgroundColor:[CommonFunctions getMainAppColor]];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 15.0, rect.size.width, 20.0)];
    [headerLabel setTextColor:[UIColor colorWithRed:104.0/255.0 green:171.0/255.0 blue:248.0/255.0 alpha:1.0]];
    [headerLabel setNumberOfLines:0];
    [headerLabel setTextAlignment:NSTextAlignmentCenter];
    [headerLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
    [headerLabel setText:[monthName uppercaseString]];
    
    [view addSubview:headerLabel];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
}

#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.completedChallengesTableView reloadData];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(nullable NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(nullable NSIndexPath *)newIndexPath {
    if (indexPath && type == NSFetchedResultsChangeDelete) {
        
    }
    [self.completedChallengesTableView reloadData];
}

@end
