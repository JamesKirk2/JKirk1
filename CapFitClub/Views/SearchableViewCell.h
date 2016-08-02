//
//  SearchableViewCell.h
//  CapFitClub
//
//  Created by Sumit Sancheti on 02/03/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchableViewCellDelegate <NSObject>

- (void)setIsSearchableFlag:(BOOL)isSearchable;
@end

@interface SearchableViewCell : UITableViewCell

@property (nonatomic, unsafe_unretained) id <SearchableViewCellDelegate> searchableCellDelegate;

- (void)setSearchableFlag:(BOOL)isSearchable;
@end
