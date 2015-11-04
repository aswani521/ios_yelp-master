//
//  CheckCellTableViewCell.h
//  Yelp
//
//  Created by Aswani Nerella on 11/2/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CheckCellTableViewCell;

@protocol CheckCellDelegate <NSObject>

- (void)cellSelected:(CheckCellTableViewCell *)cell;

@end

@interface CheckCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *CheckCellLabel;
@property (nonatomic, assign) BOOL isOn;
@property (nonatomic, weak) id<CheckCellDelegate> delegate;
-(void)setOn:(BOOL)isSelected;
@end
