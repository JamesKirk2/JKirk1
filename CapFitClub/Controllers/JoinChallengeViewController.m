//
//  JoinChallengeViewController.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 03/02/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "JoinChallengeViewController.h"
#import "EntitiesFetcher.h"
#import "UIImage+Resize.h"
#import "SetActivityAndImageCell.h"
#import "ChallengeForJoiningViewController.h"
#import "SearchChallengeService.h"
#import "UIDevice+Size.h"

@interface JoinChallengeViewController ()<NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *noChallengeView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *profileUserName;
@property (weak, nonatomic) IBOutlet UIButton *btnNewChallenge;
@property (weak, nonatomic) IBOutlet UIButton *btnExistingChallenge;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnNewChallengeTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnExistingChallengeTopConstraint;

@property (weak, nonatomic) IBOutlet UIView *searchChallengeView;
@property (weak, nonatomic) IBOutlet UISearchBar *challengeSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *joinChallengeTableView;

@property (nonatomic, strong) NSArray *sectionIndexTitles;
@property (nonatomic, strong) SGTEntityManager *entityManager;
@property (nonatomic, strong) NSFetchedResultsController *challengesFetchController;
@property (nonatomic, strong) ProfileUser *profileUser;
@property (nonatomic, assign) BOOL isAlreadyFetched;

- (IBAction)setChallengeClicked:(id)sender;
- (IBAction)joinChallengeClicked:(id)sender;
@end

@implementation JoinChallengeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.entityManager = [[SGTEntityManager alloc] init];
    self.sectionIndexTitles = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self resetViews];
    [self initializingSearchBar];
    [self initializeFetchController];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [self fetchAllChallengesToJoin:refreshControl];
}

- (void)resetViews {
    [self.joinChallengeTableView setSectionIndexColor:[CommonFunctions getMainAppColor]];
    [self.joinChallengeTableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    
    [self.navigationItem setRightBarButtonItem:nil];
    
    [self.noChallengeView setHidden:YES];
    [self.searchChallengeView setHidden:NO];
    
    self.btnNewChallenge.layer.cornerRadius = 23.0;
    self.btnExistingChallenge.layer.cornerRadius = 23.0;
    
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.layer.cornerRadius = 75.0;
    self.profileImageView.layer.borderWidth = 5.0;
    self.profileImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    if (([UIDevice isIPhone4])) {
        self.btnNewChallengeTopConstraint.constant = 20.0;
        self.btnExistingChallengeTopConstraint.constant = 20.0;
    }
    else if (([UIDevice isIPhone5])) {
        self.btnNewChallengeTopConstraint.constant = 40.0;
        self.btnExistingChallengeTopConstraint.constant = 35.0;
    }
    else if (([UIDevice isIPhone6])) {
        self.btnNewChallengeTopConstraint.constant = 50.0;
        self.btnExistingChallengeTopConstraint.constant = 35.0;
    }
    
    self.profileUser = [CommonFunctions getLoggedInProfileUser:nil];
    
    NSString *firstName = [self.profileUser firstName];
    NSString *lastName = [self.profileUser lastName];
    NSString *userName = [NSString stringWithFormat:@"%@ %@", (firstName ? firstName : @""), (lastName ? lastName :@"")];
    [self.profileUserName setText:userName];
    
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.profileUser.profileImageURL] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    [self.profileImageView setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"profileMaskImage"] success:nil failure:nil];
}

- (void)initializingSearchBar {
    UIColor* frameColor = [UIColor colorWithRed:231.0/255.0 green:241.0/255.0 blue:246.0/255.0 alpha:1.0];
    UIColor* backgroundColor = [UIColor colorWithRed:188.0/255.0 green:215.0/255.0 blue:233.0/255.0 alpha:1.0];
    
    UIImage* clearImg = [UIImage imageWithColor:frameColor andHeight:32.0f];
    UIImage* coloredImg = [UIImage imageWithColor:backgroundColor andHeight:32.0f];
    
    [[UISearchBar appearance] setBackgroundImage:clearImg];
    [[UISearchBar appearance] setSearchFieldBackgroundImage:coloredImg forState:UIControlStateNormal];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:15], NSForegroundColorAttributeName:[CommonFunctions getMainAppColor]}];
    [[UILabel appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[CommonFunctions getMainAppColor]];
    
    [self.challengeSearchBar setImage:[UIImage imageNamed:@"search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    UITextField *txfSearchField = [self.challengeSearchBar valueForKey:@"_searchField"];
    
    UIImage *clearImage = [[UIImage imageNamed:@"clear"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIButton *clearButton = [txfSearchField valueForKey:@"_clearButton"];
    [clearButton setImage:clearImage forState:UIControlStateNormal];
    [clearButton setImage:clearImage forState:UIControlStateSelected];
    
    txfSearchField.layer.cornerRadius = TEXTFIELD_CORNER_RADIUS;
}

- (void)initializeFetchController {
    if (!self.isAlreadyFetched) {
        [self.entityManager deleteObjectsForName:@"LocalChallenge"];
        self.isAlreadyFetched = YES;
    }
    
    EntitiesFetcher *entityFetcher = [[EntitiesFetcher alloc] initWithEntityManager:self.entityManager];
    
    self.challengesFetchController = [entityFetcher getLocalChallengeFetchResultController];
    self.challengesFetchController.delegate = self;
    
    NSString *challengeId = [[NSUserDefaults standardUserDefaults] objectForKey:JOIN_CHALLENGE_ID];
    if (challengeId) {
        [self fetchChallengeToJoinWithChallengeId:challengeId];
    } else {
        UIRefreshControl* refreshControl = [[UIRefreshControl alloc] init];
        [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
        [self.joinChallengeTableView addSubview:refreshControl];
        
        EntitiesFetcher *entityFetcher = [[EntitiesFetcher alloc] initWithEntityManager:self.entityManager];
        if ([entityFetcher isChallengesPresent]) {
            if ([self.challengesFetchController fetchedObjects].count <= 0) {
                [self fetchAllChallengesToJoin:nil];
            } else {
                [self.joinChallengeTableView reloadData];
            }
        } else {
            [self.noChallengeView setHidden:NO];
            [self.searchChallengeView setHidden:YES];
        }
    }
}

- (void)fetchAllChallengesToJoin:(UIRefreshControl *)refreshControl {
    __weak typeof(self) weakSelf = self;
    if (!refreshControl) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    SearchChallengeService *challengesService = [[SearchChallengeService alloc] initWithUserId:[self.profileUser userId]];
    [challengesService searchChallenges:^(BOOL isChallengePresent) {
        [refreshControl endRefreshing];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if (isChallengePresent) {
            [weakSelf.joinChallengeTableView reloadData];
        }
    } failure:^(NSError *error) {
        [refreshControl endRefreshing];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf showAlertWithMessage:[error localizedDescription]];
    }];
}

- (void)fetchChallengeToJoinWithChallengeId:(NSString *)challengeId {
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    SearchChallengeService *challengesService = [[SearchChallengeService alloc] initWithChallengeId:challengeId];
    [challengesService searchChallenges:^(BOOL isChallengePresent) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if (isChallengePresent) {
            [weakSelf.joinChallengeTableView reloadData];
        } 
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf showAlertWithMessage:[error localizedDescription]];
    }];
}

- (void)showAlertWithMessage:(NSString *)errorMessage {
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Fit Club !" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[CommonFunctions getCancelAlertAction:nil]];
    [self presentViewController:alertView animated:YES completion:nil];
}

- (IBAction)setChallengeClicked:(id)sender {
    [self.tabBarController setSelectedIndex:3];
    
    [self.noChallengeView setHidden:YES];
    [self.searchChallengeView setHidden:NO];
}

- (IBAction)joinChallengeClicked:(id)sender {
    [self.noChallengeView setHidden:YES];
    [self.searchChallengeView setHidden:NO];
    
    [self fetchAllChallengesToJoin:nil];
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return ([[self.challengesFetchController sections] count]);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray <id<NSFetchedResultsSectionInfo>>*array = [self.challengesFetchController sections];
    id <NSFetchedResultsSectionInfo> sectionInfo = array[section];
    return ([sectionInfo numberOfObjects]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SetActivityAndImageCell *setActivityAndImageCell = (SetActivityAndImageCell *)[tableView dequeueReusableCellWithIdentifier:@"SetActivityAndImageCell" forIndexPath:indexPath];
    
    LocalChallenge *challenge = [self.challengesFetchController objectAtIndexPath:indexPath];
    [setActivityAndImageCell setJoinChallengeName:[challenge challengeName] withType:[CommonFunctions getNameForChallengeType:[challenge challengeType]]];
    return setActivityAndImageCell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.sectionIndexTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
//    NSArray <id<NSFetchedResultsSectionInfo>>*array = [self.challengesFetchController sections];
//    __block NSInteger sectionIndex = 0;
//    [array enumerateObjectsUsingBlock:^(id<NSFetchedResultsSectionInfo>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        id <NSFetchedResultsSectionInfo> sectionInfo = obj;
//        if ([[sectionInfo indexTitle] isEqualToString:title]) {
//            sectionIndex = idx;
//            *stop = YES;
//        }
//    }];
//    return sectionIndex;
    return index;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray <id<NSFetchedResultsSectionInfo>>*array = [self.challengesFetchController sections];
    id <NSFetchedResultsSectionInfo> sectionInfo = array[section];
    
    NSString *sectionName = [sectionInfo name];
    
    CGRect rect = [UIScreen mainScreen].bounds;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, rect.size.width, 30.0)];
    [view setBackgroundColor:[UIColor whiteColor]];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, rect.size.width - 20.0, 30.0)];
    [headerLabel setTextColor:[UIColor colorWithRed:15.0/255.0 green:113.0/255.0 blue:183.0/255.0 alpha:1.0]];
    [headerLabel setBackgroundColor:[UIColor whiteColor]];
    [headerLabel setTextAlignment:NSTextAlignmentLeft];
    [headerLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
    [headerLabel setText:[sectionName uppercaseString]];
    
    [view addSubview:headerLabel];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    LocalChallenge *localChallenge = [self.challengesFetchController objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"showChallengeForJoining" sender:localChallenge];
}

#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.joinChallengeTableView reloadData];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(nullable NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(nullable NSIndexPath *)newIndexPath {
    [self.joinChallengeTableView reloadData];
}

#pragma mark - SegueNavigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showChallengeForJoining"]) {
        LocalChallenge *localChallenge = (LocalChallenge *)sender;
        
        ChallengeForJoiningViewController *destinationVC = segue.destinationViewController;
        destinationVC.localChallenge = localChallenge;
        [destinationVC setTitle:[localChallenge challengeName]];
    }
}
@end
