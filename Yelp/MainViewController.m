//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpBusiness.h"
#import "YelpClient.h"
#import "BusinessCell.h"
#import "FiltersViewController.h"

@interface MainViewController ()<UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate>
- (void)fetchBusinessesWithQuery: (NSString *) query params: (NSDictionary *)params;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib: [UINib nibWithNibName:@"BusinessCell" bundle:nil] forCellReuseIdentifier:@"BusinessCell"];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 120;
    
    [self fetchBusinessesWithQuery:@"Restaurants" params:nil];
    
    self.title = @"Yelp";
    // Navigation Button
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Filters" style:UIBarButtonItemStylePlain target:self action:@selector(onFilterButtonPressed)];
    // UI Search Bar
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    self.navigationItem.titleView = searchBar;
}

- (void)fetchBusinessesWithQuery: (NSString *) query params: (NSDictionary *)params {
    NSNumber *sortMode = params[@"sortMode"][0];
    NSLog(@"query: %@ categories: %@, sortMode: %@, hasDeal: %@, radius: %@",query,params[@"category_filter"],sortMode,params[@"offeringDeal"],params[@"radius"][0]);
    
    [YelpBusiness searchWithTerm:query
                        sortMode:[sortMode integerValue]  //YelpSortModeBestMatched
                      categories:params[@"category_filter"]
                           deals:params[@"offeringDeal"]
                          radius:params[@"radius"][0]
                      completion:^(NSArray *businesses, NSError *error) {
                          for (YelpBusiness *business in businesses) {
                              NSLog(@"%@", business);
                          }
                          self.businesses = businesses;
                          [self.tableView reloadData];
                      }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

# pragma mark tableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.businesses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessCell"];
    cell.business = self.businesses[indexPath.row];
    return cell;
}

- (void)filtersViewController:(FiltersViewController *)filtersViewController didChangeFilters:(NSDictionary *)filters {
    NSLog(@"Fire a new network event: filters = %@", filters);
    [self fetchBusinessesWithQuery:@"Restaurants" params:filters];
}

#pragma mark - Private methods
- (void)onFilterButtonPressed {
    FiltersViewController *vc = [[FiltersViewController alloc]init];
    vc.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
    
}


@end
