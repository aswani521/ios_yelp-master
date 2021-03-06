//
//  FiltersViewController.h
//  Yelp
//
//  Created by Aswani Nerella on 11/1/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>


//Forward declaration of the class for the double references
//Delegate refers to the class and the class refers to the delegate
@class FiltersViewController;

@protocol FiltersViewControllerDelegate <NSObject>

- (void)filtersViewController: (FiltersViewController *) filtersViewController didChangeFilters:(NSDictionary *)filters;

@end

@interface FiltersViewController : UIViewController


@property (nonatomic,weak)id<FiltersViewControllerDelegate> delegate;

@end
