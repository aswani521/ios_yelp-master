//
//  SwitchCell.h
//  Yelp
//
//  Created by Aswani Nerella on 11/1/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SwitchCell;

@protocol SwitchCellDelegate <NSObject>

- (void)switchCell: (SwitchCell *)cell didUpdateValue:(BOOL)value;

@end

@interface SwitchCell : UITableViewCell

@property (nonatomic,weak) id<SwitchCellDelegate> delegate;
@property (nonatomic,assign) BOOL on;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (void)setOn:(BOOL)on animated:(BOOL)animated;

@end
