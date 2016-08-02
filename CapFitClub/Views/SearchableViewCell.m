//
//  SearchableViewCell.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 02/03/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "SearchableViewCell.h"

@interface SearchableViewCell()

@property (weak, nonatomic) IBOutlet UIView *backgroundCellView;
@property (weak, nonatomic) IBOutlet UISwitch *searchableSwitch;

- (IBAction)searchableValueChanged:(UISwitch *)sender;
@end

@implementation SearchableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundCellView.layer.cornerRadius = TEXTFIELD_CORNER_RADIUS;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setSearchableFlag:(BOOL)isSearchable {
    [self.searchableSwitch setOn:isSearchable];
}

- (IBAction)searchableValueChanged:(UISwitch *)sender {
    [self.searchableCellDelegate setIsSearchableFlag:[sender isOn]];
}
@end
