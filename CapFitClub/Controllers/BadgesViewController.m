//
//  BadgesViewController.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 10/02/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "BadgesViewController.h"
#import "BadgesViewCell.h"
#import "WonBadgeViewCell.h"
#import "EntitiesFetcher.h"
#import "GetBadgesService.h"

@interface BadgesViewController ()<UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *backgroundSegmentView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *goalSegmentControl;
@property (weak, nonatomic) IBOutlet UITableView *badgesTableView;

@property (nonatomic, strong) SGTEntityManager *entityManager;
@property (strong, nonatomic) NSFetchedResultsController *badgesResultController;
@property (assign, nonatomic) BOOL isAlreadyFetched;
@end

@implementation BadgesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.entityManager = [[SGTEntityManager alloc] init];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.goalSegmentControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateNormal];
    [self.goalSegmentControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:5.0/255.0 green:86.0/255.0 blue:144.0/255.0 alpha:1.0]} forState:UIControlStateSelected];
    
    [self.goalSegmentControl setBackgroundImage:[UIImage imageNamed:@"transparentNavBar"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.goalSegmentControl setBackgroundImage:[UIImage imageNamed:@"segmentBackground"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    self.backgroundSegmentView.layer.cornerRadius = TEXTFIELD_CORNER_RADIUS;
    self.backgroundSegmentView.layer.borderColor = [[[UIColor alloc] initWithWhite:1.0 alpha:0.2] CGColor];
    self.backgroundSegmentView.layer.borderWidth = 1.0;
    
    [self initializeFetchController];
    if ([self.goalSegmentControl selectedSegmentIndex] == 0) {
        self.badgesResultController = [self getCurrentBadges];
    } else {
        self.badgesResultController = [self getWonBadges];
    }
    [self.badgesResultController setDelegate:self];
}

- (NSFetchedResultsController *)getCurrentBadges {
    EntitiesFetcher *entityFetcher = [[EntitiesFetcher alloc] initWithEntityManager:self.entityManager];
    return [entityFetcher getProgressBadgesFetchResultController];
}

- (NSFetchedResultsController *)getWonBadges {
    EntitiesFetcher *entityFetcher = [[EntitiesFetcher alloc] initWithEntityManager:self.entityManager];
    return [entityFetcher getWonBadgesFetchResultController];
}

- (void)initializeFetchController {    
    if (![self isAlreadyFetched]) {
        SGTEntityManager *entityManager = [[SGTEntityManager alloc] init];
        [entityManager deleteObjectsForName:@"Badge"];
        [self fetchAllBadges];
        self.isAlreadyFetched = YES;
    }
}

- (void)fetchAllBadges {
    __weak typeof(self) weakSelf = self;
    ProfileUser *profileUser = [CommonFunctions getLoggedInProfileUser:nil];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    GetBadgesService *getBadgesService = [[GetBadgesService alloc] initWithUserId:[profileUser userId]];
    [getBadgesService getBadges:^(BOOL isUpdate, NSString *statusMessage) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if (isUpdate) {
            [weakSelf.badgesTableView reloadData];
        } else {
            [weakSelf showAlertWithMessage:statusMessage];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return ([[self.badgesResultController sections] count]);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.badgesResultController fetchedObjects] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Badge *badge = [self.badgesResultController objectAtIndexPath:indexPath];
    if (badge && [[badge challengeId] longLongValue] > 0) {
        WonBadgeViewCell *badgeViewCell = (WonBadgeViewCell *)[tableView dequeueReusableCellWithIdentifier:@"WonBadgeViewCell" forIndexPath:indexPath];
        
        [badgeViewCell setBadgeObject:badge];
        return badgeViewCell;
    } else {
        BadgesViewCell *badgeViewCell = (BadgesViewCell *)[tableView dequeueReusableCellWithIdentifier:@"BadgesViewCell" forIndexPath:indexPath];
        
        [badgeViewCell setBadgeObject:badge];
        return badgeViewCell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if ([self.goalSegmentControl selectedSegmentIndex] == 0) {
//        return 70.0;
//    }
    Badge *badge = [self.badgesResultController objectAtIndexPath:indexPath];
    if (badge && [[badge challengeId] longLongValue] > 0) {
        return 340.0;
    }
    return 300.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.badgesTableView reloadData];
}

#pragma mark - UISegmentControlDelegate
- (IBAction)valueChanged:(id)sender {
    UISegmentedControl *segmentControl = (UISegmentedControl *)sender;
    if ([segmentControl selectedSegmentIndex] == 0) {
        self.badgesResultController = [self getCurrentBadges];
    } else {
        self.badgesResultController = [self getWonBadges];
    }
    [self.badgesResultController setDelegate:self];
    [self.badgesTableView reloadData];
}

@end
