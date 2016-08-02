//
//  ProfileImageViewCell.h
//  CapFitClub
//
//  Created by Sumit Sancheti on 10/02/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileUser.h"

@protocol ProfileImageDelegate <NSObject>

- (void)cameraClicked;
@optional
- (void)currentProfileImage:(UIImage *)profileImage;
@end

@interface ProfileImageViewCell : UITableViewCell

@property(nonatomic, unsafe_unretained) id <ProfileImageDelegate> profileImageDelegate;

- (void)setUserData:(ProfileUser *)profileUser withImage:(UIImage *)image;
@end
