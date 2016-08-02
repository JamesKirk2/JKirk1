//
//  ProfileViewCell.h
//  CapFitClub
//
//  Created by Sumit Sancheti on 10/02/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProfileViewCell;

@protocol ProfileViewCellDelegate <NSObject>

- (void)callBackForScollingCell:(UITableViewCell *)profileCell;
- (void)callBackForMakingNextCellAsFirstResponder:(UITableViewCell *)profileCell;

@optional
- (void)setValueForCell:(UITableViewCell *)cell withValue:(NSString *)strValue;
- (void)setGoalUnitForChallenge:(NSString *)goalUnit;
@end

@interface ProfileViewCell : UITableViewCell

@property (nonatomic, unsafe_unretained) id <ProfileViewCellDelegate> profileCellDelegate;

- (void)setHeadingText:(NSString *)heading;
- (void)setTextFieldPlaceholderText:(NSString *)text withTag:(NSInteger)tag;
- (void)setTextFieldText:(NSString *)text withReturnKey:(UIReturnKeyType) returnKeyType;
- (void)setPlaceHolderForButton:(NSString *)placeholder;
- (void)setButtonValue:(NSString *)text;

- (void)makeTextFieldAsFirstResponder;
- (void)resignTextFieldAsFirstResponder;
- (void)makeButtonAsFirstResponder;

@end
