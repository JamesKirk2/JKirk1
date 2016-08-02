//
//  LogActivityViewController.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 03/02/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "LogActivityViewController.h"
#import "CommonFunctions.h"
#import "ChallengesViewCell.h"
#import "EntitiesFetcher.h"
#import "GetChallengesService.h"
#import "AddActivityViewController.h"

@interface LogActivityViewController ()<NSFetchedResultsControllerDelegate, ChallengesViewCellDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *logActivityTableView;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIButton *completedButton;

@property (nonatomic, strong) SGTEntityManager *entityManager;
@property (nonatomic, strong) NSFetchedResultsController *challengesFetchController;

@property (nonatomic, assign) BOOL isAlreadyFetched;

- (IBAction)completedChallengesClicked:(id)sender;
@end

@implementation LogActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.entityManager = [[SGTEntityManager alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!self.isAlreadyFetched){
        CGRect rect = self.completedButton.frame;
        self.completedButton.layer.cornerRadius = rect.size.height / 2;
        self.completedButton.layer.borderColor = [[UIColor colorWithRed:104.0/255.0 green:171.0/255.0 blue:248.0/255.0 alpha:1.0] CGColor];
        self.completedButton.layer.borderWidth = 1.0;
        
        [self initializeFetchController];
        self.isAlreadyFetched = YES;
    }
    [self.logActivityTableView reloadData];
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
    self.challengesFetchController = [entityFetcher getLogActivityChallengeFetchResultController];
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
            [weakSelf.logActivityTableView reloadData];
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
    [challengesViewCell setMainChallengeObject:challenge];
    [challengesViewCell setChallengesViewCellDelegate:self];
    [challengesViewCell refreshView];
    return challengesViewCell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 85.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *monthName = @"Pick a challenge you want to log against";
    
    CGRect rect = [UIScreen mainScreen].bounds;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, rect.size.width, 50.0)];
    [view setBackgroundColor:[CommonFunctions getMainAppColor]];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.0, 5.0, rect.size.width - 80.0, 50.0)];
    [headerLabel setTextColor:[UIColor colorWithRed:104.0/255.0 green:171.0/255.0 blue:248.0/255.0 alpha:1.0]];
    [headerLabel setNumberOfLines:0];
    [headerLabel setTextAlignment:NSTextAlignmentCenter];
    [headerLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
    [headerLabel setText:[monthName uppercaseString]];
    
    [view addSubview:headerLabel];
    return view;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    Challenge *challenge = [self.challengesFetchController objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"AddActivitySegue" sender:challenge];
}

#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.logActivityTableView reloadData];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(nullable NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(nullable NSIndexPath *)newIndexPath {
    if (indexPath && type == NSFetchedResultsChangeDelete) {
        
    }
    [self.logActivityTableView reloadData];
}

#pragma mark - SegueNavigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"AddActivitySegue"]) {
        Challenge *currentChallenge = (Challenge *)sender;
        
        AddActivityViewController *destinationVC = segue.destinationViewController;
        destinationVC.challenge = currentChallenge;
    }
}
@end
