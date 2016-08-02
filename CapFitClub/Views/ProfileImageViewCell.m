//
//  ProfileImageViewCell.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 10/02/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "ProfileImageViewCell.h"
#import "NSFileManager+FileHelper.h"

@interface ProfileImageViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *profileBoundaryImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *cameraImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progressIndicatorView;

- (IBAction)cameraClicked:(id)sender;
@end

@implementation ProfileImageViewCell

- (void)awakeFromNib {
    // Initialization code
    CGFloat kPhotoDiameter = self.profileImageView.frame.size.width;
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.layer.cornerRadius = kPhotoDiameter / 2;
    self.profileImageView.layer.borderWidth = 5.0;
    self.profileImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUserName:(NSString *)userName {
    [self.lblUserName setText:userName];
}

- (void)setUserData:(ProfileUser *)profileUser withImage:(UIImage *)image {
    [self.progressIndicatorView stopAnimating];
    if (!image) {
        NSString *imageURL = [profileUser profileImageURL];
        if (imageURL && [imageURL length] > 0) {
            [self.progressIndicatorView startAnimating];
            NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:imageURL] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
            
            __weak typeof(self) weakSelf = self;
            [self.profileImageView setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"profileMaskImage"] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                [weakSelf.progressIndicatorView stopAnimating];
                [weakSelf.profileImageView setImage:image];
                [weakSelf.profileImageDelegate currentProfileImage:image];
            } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                [weakSelf.progressIndicatorView stopAnimating];
            }];
        }
    } else {
        [self.profileImageView setImage:image];
    }
    
    if (profileUser) {
        NSString *firstName = [profileUser firstName];
        NSString *lastName = [profileUser lastName];
        NSString *userName = [NSString stringWithFormat:@"%@ %@", (firstName ? firstName : @""), (lastName ? lastName :@"")];
        [self setUserName:userName];
    }
}

- (IBAction)cameraClicked:(id)sender {
    [self.profileImageDelegate cameraClicked];
}
@end
