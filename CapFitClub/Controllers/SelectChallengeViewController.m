//
//  SelectChallengeViewController.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 29/02/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "SelectChallengeViewController.h"
#import "UITableViewCell+DisclosureIndicatorColor.h"
#import "SelectChallengeCell.h"
#import "SetChallengeViewController.h"
#import "EntitiesFetcher.h"

@interface SelectChallengeViewController ()<NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) SGTEntityManager *entityManager;
@property (nonatomic, strong) NSFetchedResultsController *challengeTypesFetchController;
@end

@implementation SelectChallengeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.entityManager = [[SGTEntityManager alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self initializeFetchController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeFetchController {
    EntitiesFetcher *entityFetcher = [[EntitiesFetcher alloc] initWithEntityManager:self.entityManager];
    self.challengeTypesFetchController = [entityFetcher getChallengeTypeFetchResultController];
    self.challengeTypesFetchController.delegate = self;
    
    if ([self.challengeTypesFetchController fetchedObjects].count > 0) {
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.challengeTypesFetchController fetchedObjects] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectChallengeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectChallengeCell" forIndexPath:indexPath];
    
    ChallengeType *challengeType = [self.challengeTypesFetchController objectAtIndexPath:indexPath];
    
    if (self.isSegueCallingDisabled) {
        if ([self.challenge challengeType].longLongValue == [challengeType challengeType].longLongValue) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        } else {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
    }
    
    NSString *challengeName = [challengeType challengeName];
    [cell setChallengeImage:[UIImage imageNamed:[challengeName lowercaseString]]];
    [cell setChallengeName:challengeName];
    cell.disclosureIndicatorColor = [UIColor whiteColor] ;
    
    return cell;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    ChallengeType *challengeType = [self.challengeTypesFetchController objectAtIndexPath:indexPath];
    
    if (self.isSegueCallingDisabled) {
        [self.challenge setChallengeType:[challengeType challengeType]];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self performSegueWithIdentifier:@"showSetChallengeSegue" sender:challengeType];
    }
}

#pragma mark - SegueNavigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showSetChallengeSegue"]) {
        ChallengeType *challengeType = (ChallengeType *)sender;
        self.challenge = [self createLocalChallengeForChallengeType:challengeType];
        
        SetChallengeViewController *destinationVC = segue.destinationViewController;
        destinationVC.challenge = self.challenge;
    }
}

- (Challenge *)createLocalChallengeForChallengeType:(ChallengeType *)challengeType {
    ProfileUser *profileUser = [CommonFunctions getLoggedInProfileUser:nil];
    
    Challenge *challenge = [[Challenge alloc] initWithEntity:[self.entityManager entityForName:NSStringFromClass([Challenge class])] insertIntoManagedObjectContext:nil];
    [challenge setChallengeType:[challengeType challengeType]];
    [challenge setStartDate:[NSDate date]];
    [challenge setIsSearchable:[NSNumber numberWithBool:YES]];
    [challenge setAdminId:[profileUser userId]];
    
    return challenge;
}
@end
