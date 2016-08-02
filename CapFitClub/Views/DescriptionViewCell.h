//
//  DescriptionViewCell.h
//  CapFitClub
//
//  Created by Sumit Sancheti on 29/02/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileViewCell.h"

@interface DescriptionViewCell : UITableViewCell

@property (nonatomic, unsafe_unretained) id <ProfileViewCellDelegate> profileCellDelegate;

- (void)setDescriptionText:(NSString *)descriptionText;

- (void)makeTextViewAsFirstResponder;
- (void)resignTextViewAsFirstResponder;
@end
