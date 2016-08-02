//
//  ChallengeForJoiningViewController.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 10/03/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "ChallengeForJoiningViewController.h"
#import "SetActivityAndImageCell.h"
#import "DescriptionViewCell.h"
#import "ChallengesViewCell.h"
#import "ConfirmationViewController.h"
#import "Entitiesfetcher.h"
#import "ChallengeType.h"
#import "JoinChallengeService.h"

@interface ChallengeForJoiningViewController ()

@property (weak, nonatomic) IBOutlet UITableView *joinChallengeTableView;

@property (strong, nonatomic) NSNumber *challengeId;
@property (strong, nonatomic) SGTEntityManager *entityManager;
@end

@implementation ChallengeForJoiningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.entityManager = [[SGTEntityManager alloc] init];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (User *)getUserWithUserId:(NSNumber *)userId {
    NSArray *array = [[self.localChallenge users] array];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.userId == %@", userId];
    NSArray *usersArray = [array filteredArrayUsingPredicate:predicate];
    
    if ([usersArray count] > 0) {
        return (usersArray[0]);
    }
    return nil;
}

- (NSString *)getAdminForChallenge {
    User *user = [self getUserWithUserId:[self.localChallenge adminId]];
    if (user) {
        NSString *firstName = [user firstName];
        NSString *lastName = [user lastName];
        return [NSString stringWithFormat:@"%@ %@", (firstName ? firstName : @""), (lastName ? lastName :@"")];
    }
    return @"";
}

- (IBAction)joinClicked:(id)sender {
    ProfileUser *profileUser = [CommonFunctions getLoggedInProfileUser:nil];
    User *user = [self getUserWithUserId:[profileUser userId]];
    
    if (user) {
        [self showAlertWithMessage:@"You have already joined the challenge."];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self) weakSelf = self;
    
    JoinChallengeService *joinChallengeService = [[JoinChallengeService alloc] initWithChallengeId:[self.localChallenge challengeId] andUserId:[profileUser userId]];
    [joinChallengeService joinChallengeForUser:^(NSNumber *challengeId, NSString *statusMessage) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (challengeId) {
            weakSelf.challengeId = challengeId;
            [weakSelf performSegueWithIdentifier:@"JoinConfirmationSegue" sender:statusMessage];
        } else {
            [weakSelf showAlertWithMessage:statusMessage];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [weakSelf showAlertWithMessage:[error localizedDescription]];
    }];
}

- (void)showAlertWithMessage:(NSString *)errorMessage {
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Join Challenge !" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[CommonFunctions getDismissAlertAction:nil]];
    [self presentViewController:alertView animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        return 3;
    }
    return [self.localChallenge users].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            SetActivityAndImageCell *setActivityAndImageCell = (SetActivityAndImageCell *)[tableView dequeueReusableCellWithIdentifier:@"SetActivityAndImageCell" forIndexPath:indexPath];
            
            [setActivityAndImageCell setChallengeType:[CommonFunctions getNameForChallengeType:[self.localChallenge challengeType]]];
            return setActivityAndImageCell;
        } else if (indexPath.row == 1) {
            DescriptionViewCell *descriptionViewCell = (DescriptionViewCell *)[tableView dequeueReusableCellWithIdentifier:@"DescriptionViewCell" forIndexPath:indexPath];
            
            [descriptionViewCell setDescriptionText:[self.localChallenge challengeDescription]];
            return descriptionViewCell;
        } else {
            SetActivityAndImageCell *setActivityAndImageCell = (SetActivityAndImageCell *)[tableView dequeueReusableCellWithIdentifier:@"SetActivityAndImageCell" forIndexPath:indexPath];
            
            [setActivityAndImageCell setLogoImage];
            return setActivityAndImageCell;
        }
    } else if (indexPath.section == 1) {
        ProfileViewCell *profileViewCell = (ProfileViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ProfileViewCell" forIndexPath:indexPath];
        
        switch (indexPath.row) {
            case 0:
                [profileViewCell setHeadingText:[NSString stringWithFormat:@"%@", @"Admin"]];
                [profileViewCell setTextFieldText:[self getAdminForChallenge] withReturnKey:UIReturnKeyNext];
                break;
            case 1:
                [profileViewCell setHeadingText:[NSString stringWithFormat:@"%@", @"Goal"]];
                [profileViewCell setTextFieldText:[self.localChallenge.challengeGoal stringValue] withReturnKey:UIReturnKeyNext];
                break;
            case 2:
                [profileViewCell setHeadingText:[NSString stringWithFormat:@"%@", @"End Date"]];
                [profileViewCell setTextFieldText:[CommonFunctions formatDateFrom:self.localChallenge.endDate] withReturnKey:UIReturnKeyDone];
                break;
            default:
                break;
        }
        return profileViewCell;
    } else {
        ChallengesViewCell *challengeViewCell = (ChallengesViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ChallengesViewCell" forIndexPath:indexPath];
        
        NSInteger index = indexPath.row;
        User *user = [[self.localChallenge users] objectAtIndex:index];
        [challengeViewCell setMainChallengeObject:self.localChallenge];
        [challengeViewCell setUserObject:user];
        [challengeViewCell refreshView];
        return challengeViewCell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.0;
    }
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            CGRect rect = [UIScreen mainScreen].bounds;
            CGFloat labelHeight = [CommonFunctions heightWithWidthConstraint:rect.size.width - 36.0 ForString:[self.localChallenge challengeDescription] font:[UIFont systemFontOfSize:18.0]];
            return labelHeight;
        } else if (indexPath. row == 2) return 44.0;
        return 60.0;
    } else if (indexPath.section == 1) return 44.0;
    return 60.0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    if (section == 0) {
        return nil;
    }
    
    NSString *sectionName = @"Your Goal";
    if (section == 2) {
        sectionName = @"Participants";
    }
    
    CGRect rect = [UIScreen mainScreen].bounds;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, rect.size.width, 40.0)];
    [view setBackgroundColor:[CommonFunctions getMainAppColor]];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 10.0, rect.size.width - 20.0, 30.0)];
    [headerLabel setTextColor:[UIColor colorWithRed:104.0/255.0 green:171.0/255.0 blue:248.0/255.0 alpha:1.0]];
    [headerLabel setBackgroundColor:[UIColor clearColor]];
    [headerLabel setTextAlignment:NSTextAlignmentCenter];
    [headerLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
    [headerLabel setText:[sectionName uppercaseString]];
    
    [view addSubview:headerLabel];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - SegueNavigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"JoinConfirmationSegue"]) {
        NSString *alertMessage = (NSString *)sender;
        
        EntitiesFetcher *entitiesFetcher = [[EntitiesFetcher alloc] initWithEntityManager:self.entityManager];
        
        ConfirmationViewController *destinationVC = segue.destinationViewController;
        [destinationVC setChallenge:[entitiesFetcher fetchChallengeWithChallengeId:[self challengeId]]];
        [destinationVC setStatusMessageForAlert:alertMessage];
    }
}

@end
