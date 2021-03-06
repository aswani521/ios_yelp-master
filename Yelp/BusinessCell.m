//
//  BusinessCell.m
//  Yelp
//
//  Created by Aswani Nerella on 11/1/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import "BusinessCell.h"
#import "UIImageView+AFNetworking.h"

@interface BusinessCell()
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImageView;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@end
@implementation BusinessCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setBusiness:(YelpBusiness *)business{
    _business = business;
    
    [self.thumbImageView setImageWithURL:self.business.imageUrl];
    self.nameLabel.text = self.business.name;
    [self.ratingImageView setImageWithURL:self.business.ratingImageUrl];
    self.ratingLabel.text = [NSString stringWithFormat:@"%@ Reviews",self.business.reviewCount];
    self.addressLabel.text = self.business.address;
    self.distanceLabel.text = [NSString stringWithFormat:@"%@", self.business.distance];
    self.categoryLabel.text = [NSString stringWithFormat:@"%@", self.business.categories];

}

@end
