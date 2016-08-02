//
//  FilledChallengesView.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 24/02/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "FilledChallengesView.h"
#import "UIImage+Resize.h"
#import "EntitiesFetcher.h"
#import "ChallengeType.h"

@interface FilledChallengesView()

@property (weak, nonatomic) IBOutlet UILabel *lblChallengeName;
@property (weak, nonatomic) IBOutlet UIImageView *challengeImageView;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteBtnWidthConstraint;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progressActivityIndicator;

@property (strong, nonatomic) MainChallenge *challenge;
@property (strong, nonatomic) User *user;
@property (assign, nonatomic) long long completedQuantity;

- (IBAction)deleteClicked:(id)sender;
@end

@implementation FilledChallengesView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef cont = UIGraphicsGetCurrentContext();
    
    if ([[self.challenge endDate] timeIntervalSince1970] < [[NSDate date] timeIntervalSince1970]) {
        if (self.user && [self.user.completedQuantity longLongValue] < [self.challenge.challengeGoal longLongValue]) {
            CGContextSetRGBFillColor(cont, 207.0/255.0, 85.0/255.0, 87.0/255.0, 1.0);
        } else if ([self.challenge.completedQuantity longLongValue] < [self.challenge.challengeGoal longLongValue]) {
            CGContextSetRGBFillColor(cont, 207.0/255.0, 85.0/255.0, 87.0/255.0, 1.0);
        } else {
            CGContextSetRGBFillColor(cont, 90.0/255.0, 190.0/255.0, 111.0/255.0, 1.0);
        }
    } else {
        CGContextSetRGBFillColor(cont, 90.0/255.0, 190.0/255.0, 111.0/255.0, 1.0);
    }
    
    long long total = [self.challenge.challengeGoal longLongValue];
    CGFloat width = ((self.completedQuantity * self.frame.size.width) / total);
    CGContextFillRect(cont, CGRectMake(0.0, 0.0, width, self.frame.size.height));
}

- (void)addGesture {
    UISwipeGestureRecognizer *leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showOrHideButton:)];
    [leftSwipeGesture setNumberOfTouchesRequired:1];
    [leftSwipeGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self addGestureRecognizer:leftSwipeGesture];
    
    UISwipeGestureRecognizer *rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showOrHideButton:)];
    [rightSwipeGesture setNumberOfTouchesRequired:1];
    [rightSwipeGesture setDirection:UISwipeGestureRecognizerDirectionRight];
    [self addGestureRecognizer:rightSwipeGesture];
}

- (void)showOrHideButton:(UISwipeGestureRecognizer *)swipeGesture {
    switch (swipeGesture.direction) {
        case UISwipeGestureRecognizerDirectionRight:
            [self viewDeleteButtonWithWidth:0];
            [self.filledChallengesViewDelegate sendSelectedCell:NO];
            break;
        case UISwipeGestureRecognizerDirectionLeft:
            [self viewDeleteButtonWithWidth:54];
            [self.filledChallengesViewDelegate sendSelectedCell:YES];
            break;
        default:
            break;
    }
}

- (void)viewDeleteButtonWithWidth:(CGFloat)width {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.deleteBtnWidthConstraint.constant = width;
        
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

- (IBAction)deleteClicked:(id)sender {
    [self.filledChallengesViewDelegate deleteCell:YES];
}

- (void)setMainChallengeObject:(MainChallenge *)challenge {
    self.completedQuantity = 0;
    self.challenge = challenge;
}

- (void)setUserObject:(User *)user {
    CGFloat kPhotoDiameter = self.challengeImageView.frame.size.width;
    self.challengeImageView.layer.masksToBounds = YES;
    self.challengeImageView.layer.cornerRadius = kPhotoDiameter / 2;
    
    self.completedQuantity = 0;
    self.user = user;
}

- (void)refreshView {
    if (!self.user) {
        [self.lblChallengeName setText:self.challenge.challengeName];
        [self.challengeImageView setImage:[UIImage imageNamed:[[CommonFunctions getNameForChallengeType:self.challenge.challengeType] lowercaseString]]];
        
        NSArray *usersArray = [[self.challenge users] array];
        [usersArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            User *user = (User *)obj;
            self.completedQuantity += [user.completedQuantity longLongValue];
        }];
    } else {
        NSString *firstName = [self.user firstName];
        NSString *lastName = [self.user lastName];
        NSString *userName = [NSString stringWithFormat:@"%@ %@", (firstName ? firstName : @""), (lastName ? lastName :@"")];
        [self.lblChallengeName setText:userName];
        
        [self downloadUserImageWithURL:[self.user profileImageURL]];
        self.completedQuantity = [self.user.completedQuantity longLongValue];
    }
    
    [self setNeedsDisplay];
}

- (void)downloadUserImageWithURL:(NSString *)profileImageURL {
    [self.progressActivityIndicator stopAnimating];
    if (profileImageURL && [profileImageURL length] > 0) {
        NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:profileImageURL] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
        
        [self.progressActivityIndicator startAnimating];
        __weak typeof(self) weakSelf = self;
        [self.challengeImageView setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"profileImage"] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
            [weakSelf.progressActivityIndicator stopAnimating];
            [weakSelf.challengeImageView setImage:image];
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError *error) {
            [weakSelf.progressActivityIndicator stopAnimating];
        }];
    }
}

- (void)hideDeleteButton {
    [self viewDeleteButtonWithWidth:0];
}
@end
