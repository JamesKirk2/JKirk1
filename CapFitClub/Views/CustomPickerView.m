//
//  CustomPickerView.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 15/02/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "CustomPickerView.h"
#import "CommonFunctions.h"

@interface CustomPickerView()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (strong, nonatomic) NSString *selectedValue;
@property (strong, nonatomic) NSArray *pickerArray;

- (IBAction)nextClicked:(id)sender;
- (IBAction)doneClicked:(id)sender;
- (IBAction)valueChangedClicked:(id)sender;
@end

@implementation CustomPickerView

- (void)initNormalPicker:(PICKER_TYPE)pickeType withValue:(NSString *)value {
    [self.datePickerView setHidden:((pickeType == kDATE_PICKER) ? NO : YES)];
    [self.pickerView setHidden:((pickeType == kNORMAL_PICKER) ? NO : YES)];
    [self.pickerView setShowsSelectionIndicator:((pickeType == kNORMAL_PICKER) ? NO : YES)];
    self.pickerArray = @[@"Male", @"Female"];
    
    if (![self.pickerView isHidden]) {
        [self.nextButton setHidden:NO];
        if (!value) {
            value = self.pickerArray[0];
        }
        [self.pickerView selectRow:[self.pickerArray indexOfObject:value] inComponent:0 animated:YES];
    }

    self.selectedValue = value;
    [self.customPickerDelegate normalPickerValueChangedClicked:self.selectedValue];
}

- (void)initDatePicker:(PICKER_TYPE)pickeType withValue:(NSDate *)value {
    [self.datePickerView setHidden:((pickeType == kDATE_PICKER) ? NO : YES)];
    [self.pickerView setHidden:((pickeType == kNORMAL_PICKER) ? NO : YES)];
    [self.pickerView setShowsSelectionIndicator:((pickeType == kNORMAL_PICKER) ? NO : YES)];
    
    if (![self.datePickerView isHidden]) {
        [self.nextButton setHidden:YES];
        if (!value) {
            value = [NSDate date];
        }
        [self.datePickerView setDate:value];
    }
    
    [self.customPickerDelegate datePickerValueChangedClicked:value];
}

- (void)setDatePickerMinDate:(NSDate *)date {
    [self.datePickerView setMinimumDate:date];
}

- (IBAction)nextClicked:(id)sender {
    if (![self.datePickerView isHidden]) {
        self.selectedValue = [CommonFunctions formatDateFrom:[self.datePickerView date]];
    }
    [self.customPickerDelegate nextClicked:self.selectedValue];
}

- (IBAction)doneClicked:(id)sender {
    if (![self.datePickerView isHidden]) {
        self.selectedValue = [CommonFunctions formatDateFrom:[self.datePickerView date]];
    }
    [self.customPickerDelegate doneClicked];
}

- (IBAction)valueChangedClicked:(id)sender {
    if (![self.datePickerView isHidden]) {
        [self.customPickerDelegate datePickerValueChangedClicked:[self.datePickerView date]];
    }
}

#pragma mark - UIPickerViewDataSource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.pickerArray count];
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.pickerArray[row];
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedValue = self.pickerArray[row];
    [self.customPickerDelegate normalPickerValueChangedClicked:self.selectedValue];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 44.0;
}
@end
