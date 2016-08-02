//
//  CustomPickerView.h
//  CapFitClub
//
//  Created by Sumit Sancheti on 15/02/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kDATE_PICKER = 0,
    kNORMAL_PICKER
}PICKER_TYPE;

@protocol CustomPickerDelegate <NSObject>

- (void)doneClicked;

@optional
- (void)normalPickerValueChangedClicked:(NSString *)value;
- (void)datePickerValueChangedClicked:(NSDate *)value;
- (void)nextClicked:(NSString *)strValue;

@end

@interface CustomPickerView : UIView

@property (nonatomic, unsafe_unretained) id <CustomPickerDelegate> customPickerDelegate;

- (void)initNormalPicker:(PICKER_TYPE)pickeType withValue:(NSString *)value;
- (void)initDatePicker:(PICKER_TYPE)pickeType withValue:(NSDate *)value;
- (void)setDatePickerMinDate:(NSDate *)date;
@end
