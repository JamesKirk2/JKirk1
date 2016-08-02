//
//  ProfileViewController.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 02/02/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "ProfileViewController.h"
#import "UserProfileService.h"
#import "MBProgressHUD.h"
#import "ProfileImageViewCell.h"
#import "ProfileViewCell.h"
#import "RSKImageCropViewController.h"
#import "CustomPickerView.h"
#import "EntitiesFetcher.h"
#import "NSFileManager+FileHelper.h"
#import "LogoutService.h"

@interface ProfileViewController () <ProfileImageDelegate, ProfileViewCellDelegate, CustomPickerDelegate, RSKImageCropViewControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *profileTableView;
@property (weak, nonatomic) IBOutlet CustomPickerView *customDatePickerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *customPickerBottomConstraint;

@property (strong, nonatomic) UIAlertController *alertController;
@property (strong, nonatomic) NSIndexPath *currentRowIndexPath;
@property (strong, nonatomic) NSIndexPath *savedRowIndexPath;
@property (strong, nonatomic) UIImage *profileImage;

@property (assign, nonatomic) BOOL isProfileImageChanged;
@property (assign, nonatomic) BOOL isEditMode;
@property (assign, nonatomic) BOOL isAlreadyFetched;
@property (strong, nonatomic) ProfileUser *profileUser;
@property (nonatomic, strong) SGTEntityManager *entityManager;

- (IBAction)cancelClicked:(id)sender;
- (IBAction)saveClicked:(id)sender;
- (IBAction)logoutClicked:(id)sender;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.entityManager = [[SGTEntityManager alloc] init];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetTableViewHeight:) name:UIKeyboardDidHideNotification object:nil];
    
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationItem setHidesBackButton:YES];
    [self.customDatePickerView setCustomPickerDelegate:self];
    
    self.profileUser = [CommonFunctions getLoggedInProfileUser:nil];
    if (![CommonFunctions isUserProfileSetForUser:self.profileUser]) {
        self.isEditMode = YES;
    } else if (!self.isAlreadyFetched) {
        [self getUserProfile];
        self.isAlreadyFetched = YES;
    }
    [self initialize];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (void)initialize {
    
    if (self.isEditMode) {
        [self editClicked:nil];
    }
    else {
        [self.navigationItem setRightBarButtonItem:[CommonFunctions barButtonItemWithTitle:@"EDIT" target:self selector:@selector(editClicked:)]];
        [self.navigationItem setLeftBarButtonItem:[CommonFunctions barButtonItemWithTitle:@"Cancel" target:self selector:@selector(cancelClicked:)]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)editClicked:(id)sender {
    self.isEditMode = YES;
    [self.navigationItem setRightBarButtonItem:[CommonFunctions barButtonItemWithTitle:@"SAVE" target:self selector:@selector(saveClicked:)] animated:self.isEditMode];
    [self.profileTableView reloadData];
}

- (BOOL)isValidated {
    NSString *firstName = [self.profileUser firstName];
    if (!firstName || [firstName length] == 0) {
        [self showAlertWithMessage:@"Please enter your first name."];
        return NO;
    }
    
    NSString *lastName = [self.profileUser lastName];
    if (!lastName || [lastName length] == 0) {
        [self showAlertWithMessage:@"Please enter your last name."];
        return NO;
    }
    
    NSString *email = [self.profileUser emailAddress];
    if (!email || [email length] == 0) {
        [self showAlertWithMessage:@"Please enter your email address."];
        return NO;
    }
    
    NSString *gender = [self.profileUser gender];
    if (!gender || [gender length] == 0) {
        [self showAlertWithMessage:@"Please select your gender."];
        return NO;
    }
    
    NSDate *dateOfBirth = [self.profileUser dateOfBirth];
    if (!dateOfBirth || [dateOfBirth timeIntervalSinceNow] >= 0) {
        [self showAlertWithMessage:@"Please select a valid date of birth."];
        return NO;
    }
    
    return YES;
}

- (IBAction)saveClicked:(id)sender {
    
    if (![self isValidated]) return;
    
    NSDictionary *parameters = @{@"first_name":[self.profileUser firstName],
                                 @"last_name":[self.profileUser lastName],
                                 @"email":[self.profileUser emailAddress],
                                 @"gender":[self.profileUser gender],
                                 @"date_of_birth":[NSNumber numberWithLongLong:[[self.profileUser dateOfBirth] timeIntervalSince1970]]};
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (self.isProfileImageChanged) {
        UserProfileService *userProfileService = [[UserProfileService alloc] initWithUserId:[self.profileUser userId] andParameters:parameters];
        [userProfileService saveUserProfileForUser:^(ProfileUser *profileUser, NSError *error) {
        } failure:^(NSError *error) {
        }];
        
//        self.profileImage = [UIImage imageNamed:@"dummyImage"];
        NSData *imageData = [self compressImageBeforeSending:1.0];
        NSString *image = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        
        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
        NSDictionary *fileParameters = @{@"filename":[NSString stringWithFormat:@"%lld.jpg", (long long)timeInterval], @"file":image};
        UserProfileService *userImageProfileService = [[UserProfileService alloc] initWithParameters:fileParameters];
        [userImageProfileService saveUserProfileImage:^(ProfileUser *profileUser, NSError *error) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            [weakSelf showAlertWithMessage:[error localizedDescription]];
        }];
    } else {
        UserProfileService *userProfileService = [[UserProfileService alloc] initWithUserId:[self.profileUser userId] andParameters:parameters];
        [userProfileService saveUserProfileForUser:^(ProfileUser *profileUser, NSError *error) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            [weakSelf showAlertWithMessage:[error localizedDescription]];
        }];
    }
}

- (NSData *)compressImageBeforeSending:(CGFloat)compressionQuality {
    NSData *imageData = UIImageJPEGRepresentation(self.profileImage, compressionQuality);
    if (imageData.length > 4200000) {
        imageData = [self compressImageBeforeSending:(compressionQuality - 0.1)];
    }
    return imageData;
}

- (void)showAlertWithMessage:(NSString *)errorMessage {
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Fit Club !" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[CommonFunctions getCancelAlertAction:nil]];
    [self presentViewController:alertView animated:YES completion:nil];
}

- (IBAction)logoutClicked:(id)sender {
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Fit Club !" message:@"We recommend that you stay logged in to avoid having to re-enter your Safeword password next time. Do you still want to log out?" preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[CommonFunctions getYesAlertAction:^(UIAlertAction * _Nonnull action) {
        [[AppConstants sharedInstance] setIsUserLoggedIn:NO];
        [weakSelf resetUserSession];
        [weakSelf dismissViewControllerAnimated:YES completion:nil];

//        LogoutService *logoutService = [[LogoutService alloc] init];
//        [logoutService logoutUser:^(BOOL isUpdate, NSString *statusMessage) {
//        } failure:^(NSError *error) {
//        }];
    }]];
    [alertView addAction:[CommonFunctions getNoAlertAction:nil]];
    [self presentViewController:alertView animated:YES completion:nil];
}

- (void)resetUserSession {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:USER_SESSION_TOKEN];
    [userDefaults removeObjectForKey:USER_SESSION_NAME];
    [userDefaults removeObjectForKey:USER_SESSION_ID];
    [userDefaults synchronize];
}

- (void)setProfileUserWithValue:(NSString *)value forIndex:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case INDEX_FIRST_NAME:
            [self.profileUser setFirstName:value];
            break;
        case INDEX_LAST_NAME:
            [self.profileUser setLastName:value];
            break;
        case INDEX_EMAIL:
            [self.profileUser setEmailAddress:value];
            break;
        case INDEX_GENDER:
            [self.profileUser setGender:value];
            break;
        default:
            break;
    }
}

- (void)getUserProfile {
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    UserProfileService *userProfileService = [[UserProfileService alloc] initWithUserId:[self.profileUser userId]];
    [userProfileService getUserProfileForUser:^(ProfileUser *profileUser, NSError *error) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf.profileTableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf showAlertWithMessage:[error localizedDescription]];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 0) {
        ProfileImageViewCell *imageViewCell = (ProfileImageViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ProfileImageViewCell" forIndexPath:indexPath];
        [imageViewCell setProfileImageDelegate:self];
        [imageViewCell setUserData:self.profileUser withImage:self.profileImage];
        [imageViewCell setUserInteractionEnabled:self.isEditMode];
        return imageViewCell;
    } else {
        ProfileViewCell *profileViewCell = (ProfileViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ProfileViewCell" forIndexPath:indexPath];
        [profileViewCell setProfileCellDelegate:self];
        [profileViewCell setUserInteractionEnabled:self.isEditMode];
        
        switch (indexPath.row) {
            case INDEX_FIRST_NAME:
                [profileViewCell setHeadingText:[NSString stringWithFormat:@"%@", USER_FIRST_NAME]];
                [profileViewCell setTextFieldPlaceholderText:[NSString stringWithFormat:@"<%@>", USER_FIRST_NAME] withTag:INDEX_FIRST_NAME];
                [profileViewCell setTextFieldText:self.profileUser.firstName withReturnKey:UIReturnKeyNext];
                break;
            case INDEX_LAST_NAME:
                [profileViewCell setHeadingText:[NSString stringWithFormat:@"%@", USER_LAST_NAME]];
                [profileViewCell setTextFieldPlaceholderText:[NSString stringWithFormat:@"<%@>", USER_LAST_NAME] withTag:INDEX_LAST_NAME];
                [profileViewCell setTextFieldText:self.profileUser.lastName withReturnKey:UIReturnKeyNext];
                break;
            case INDEX_EMAIL:
                [profileViewCell setHeadingText:[NSString stringWithFormat:@"%@", USER_EMAILADDRESS]];
                [profileViewCell setTextFieldPlaceholderText:[NSString stringWithFormat:@"<%@>", USER_EMAILADDRESS] withTag:INDEX_EMAIL];
                [profileViewCell setTextFieldText:self.profileUser.emailAddress withReturnKey:UIReturnKeyNext];
                break;
            case INDEX_GENDER:
                [profileViewCell setHeadingText:[NSString stringWithFormat:@"%@", USER_GENDER]];
                if (self.profileUser.gender) {
                    [profileViewCell setButtonValue:[NSString stringWithFormat:@"%@", self.profileUser.gender]];
                } else {
                    [profileViewCell setPlaceHolderForButton:[[NSString stringWithFormat:@"<%@>", USER_GENDER] lowercaseString]];
                }
                break;
            case INDEX_DATE_OF_BIRTH:
                [profileViewCell setHeadingText:[NSString stringWithFormat:@"%@", USER_DATE_OF_BIRTH]];
                if (self.profileUser.dateOfBirth) {
                    [profileViewCell setButtonValue:[NSString stringWithFormat:@"%@", [CommonFunctions formatDateFrom:self.profileUser.dateOfBirth]]];
                } else {
                    [profileViewCell setPlaceHolderForButton:[[NSString stringWithFormat:@"<%@>", USER_DATE_OF_BIRTH] lowercaseString]];
                }
                break;
            default:
                break;
        }
        return profileViewCell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ((indexPath.row == 0) ? 186.0 : 44.0);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - ProfileImageDelegate
- (void)currentProfileImage:(UIImage *)profileImage {
    self.profileImage = profileImage;
    [self.profileTableView reloadData];
}

- (void)cameraClicked {
     self.alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [self.alertController addAction:[self photoGalleryAction]];
    [self.alertController addAction:[self photoFromCameraAction]];
    [self.alertController addAction:[CommonFunctions getCancelAlertAction:nil]];
    [self presentViewController:self.alertController animated:YES completion:nil];
}

- (UIAlertAction *)photoGalleryAction {
    __weak typeof(self) weakSelf = self;
    return [UIAlertAction actionWithTitle:@"Choose from phone" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.delegate = weakSelf;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }];
}

- (UIAlertAction *)photoFromCameraAction {
    __weak typeof(self) weakSelf = self;
    return [UIAlertAction actionWithTitle:@"Take a photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.delegate = weakSelf;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }];
}

#pragma mark - ProfileViewCellDelegate
- (void)callBackForScollingCell:(ProfileViewCell *)profileCell {
    NSIndexPath *indexPath = [self.profileTableView indexPathForCell:profileCell];
    
    
    if (indexPath.row == INDEX_GENDER || indexPath.row == INDEX_DATE_OF_BIRTH) {
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
            self.tableBottomConstraint.constant = KEYBOARD_HEIGHT;
        } completion:^(BOOL finished) {
            [self.profileTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }];
    }
}

- (void) openCustomPicker:(NSIndexPath *)indexPath {
    if (indexPath.row == 4) {
        [self.customDatePickerView initNormalPicker:kNORMAL_PICKER withValue:self.profileUser.gender];
    }
    else {
        [self.customDatePickerView initDatePicker:kDATE_PICKER withValue:self.profileUser.dateOfBirth];
    }
    
    self.tableBottomConstraint.constant = KEYBOARD_HEIGHT + 20.0;
    self.customPickerBottomConstraint.constant = 0.0;
    [self.customDatePickerView setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.customDatePickerView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.profileTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }];
}

- (void)callBackForMakingNextCellAsFirstResponder:(ProfileViewCell *)profileCell {
    NSIndexPath *indexPath = [self.profileTableView indexPathForCell:profileCell];
    
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:(indexPath.row +1) inSection:indexPath.section];
    ProfileViewCell *profileViewCell = [self.profileTableView cellForRowAtIndexPath:newIndexPath];
    
    if (indexPath.row == INDEX_FIRST_NAME || indexPath.row == INDEX_LAST_NAME) {
        [profileViewCell makeTextFieldAsFirstResponder];
    }
    else {
        self.currentRowIndexPath = nil;
        [profileCell resignTextFieldAsFirstResponder];
        [profileViewCell makeButtonAsFirstResponder];
    }
}

- (void)setValueForCell:(UITableViewCell *)cell withValue:(NSString *)strValue {
    [self setProfileUserWithValue:strValue forIndex:self.savedRowIndexPath];
}

//- (void)callBackForHidingKeyboard:(ProfileViewCell *)profileCell {
//    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardDidHideNotification object:nil];
//}

- (void)resetTableViewHeight:(NSNotification *)notification {
    if (notification && self.currentRowIndexPath) {
        [UIView animateWithDuration:0.5 animations:^{
            self.tableBottomConstraint.constant = PROFILE_TABLE_BOTTOM_CONSTRAINT;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
        }];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //You can retrieve the actual UIImage
    UIImage *photo = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:photo cropMode:RSKImageCropModeCircle];
        imageCropVC.delegate = self;
        [self presentViewController:imageCropVC animated:YES completion:nil];
    }];
}

#pragma mark - RSKImageCropViewControllerDelegate
- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect {
    
    NSString *profileImagePath = [[NSFileManager defaultManager] thumbnailFilePath:[self.profileUser.profileImageURL lastPathComponent]];
    NSData *imageData = UIImagePNGRepresentation(croppedImage);
    [[NSFileManager defaultManager] appendData:imageData toFileAtPath:profileImagePath];
    self.profileImage = croppedImage;
    self.isProfileImageChanged = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.profileTableView reloadData];
}

#pragma mark - CustomPickerDelegate
- (void)normalPickerValueChangedClicked:(NSString *)value {
    ProfileViewCell *profileViewCell1 = [self.profileTableView cellForRowAtIndexPath:self.savedRowIndexPath];
    [profileViewCell1 setButtonValue:value];
    [self setProfileUserWithValue:value forIndex:self.savedRowIndexPath];
}

- (void)datePickerValueChangedClicked:(NSDate *)value {
    NSString *selectedValue = [CommonFunctions formatDateFrom:value];
    ProfileViewCell *profileViewCell1 = [self.profileTableView cellForRowAtIndexPath:self.savedRowIndexPath];
    [profileViewCell1 setButtonValue:selectedValue];
    [self.profileUser setDateOfBirth:value];
}

- (void)nextClicked:(NSString *)strValue {
    ProfileViewCell *profileViewCell1 = [self.profileTableView cellForRowAtIndexPath:self.savedRowIndexPath];
    [profileViewCell1 setButtonValue:strValue];
    
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:(self.savedRowIndexPath.row +1) inSection:self.savedRowIndexPath.section];
    ProfileViewCell *profileViewCell2 = [self.profileTableView cellForRowAtIndexPath:newIndexPath];
    [profileViewCell2 makeButtonAsFirstResponder];
}

- (void)doneClicked {
    self.tableBottomConstraint.constant = PROFILE_TABLE_BOTTOM_CONSTRAINT;
    [self.profileTableView setNeedsUpdateConstraints];
    
    [self resettingCustomPickerView];
}

- (void)resettingCustomPickerView {
    self.customPickerBottomConstraint.constant = self.customDatePickerView.frame.size.height * -1;
    [self.customDatePickerView setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.customDatePickerView layoutIfNeeded];
        [self.profileTableView layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}


@end
