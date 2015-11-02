//
//  BusinessCell.h
//  Yelp
//
//  Created by Aswani Nerella on 11/1/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YelpBusiness.h"

@interface BusinessCell : UITableViewCell
@property (nonatomic, strong) YelpBusiness *business;
@end
