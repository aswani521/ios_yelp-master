//
//  CheckCellTableViewCell.m
//  Yelp
//
//  Created by Aswani Nerella on 11/2/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import "CheckCellTableViewCell.h"

@implementation CheckCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected) {
        [self.delegate cellSelected:self];
    }
}

- (void)setOn:(BOOL)isSelected {
    _isOn = !_isOn;
    self.accessoryType = _isOn ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
}


@end
