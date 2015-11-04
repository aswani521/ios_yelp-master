//
//  FiltersViewController.m
//  Yelp
//
//  Created by Aswani Nerella on 11/1/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import "FiltersViewController.h"
#import "SwitchCell.h"
#import "CheckCellTableViewCell.h"

@interface FiltersViewController ()<UITableViewDataSource,UITableViewDelegate,SwitchCellDelegate,CheckCellDelegate>

//Selected filters
@property (weak,readonly) NSDictionary* filters;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//all available categories
@property (nonatomic,strong) NSArray *categories;
@property (nonatomic,strong) NSArray *distances;
@property (nonatomic,strong) NSArray *sortFilters;
@property (nonatomic,strong) NSArray *deals;
@property (nonatomic,strong) NSMutableArray *availableFilters;
@property (nonatomic,strong) NSMutableArray *filterNames;


@property (nonatomic,strong) NSMutableSet *selectedCategories;
@property (nonatomic,strong) NSMutableArray *selectedSort;
@property (nonatomic,strong) NSMutableArray *selectedDistance;
@property (nonatomic,strong) NSMutableSet *selectedDeal;
@property BOOL offeringDeal;
@property (nonatomic, strong) NSArray *sections;

- (void)initCategories;
           
@end

@implementation FiltersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self) {
        self.selectedCategories = [NSMutableSet set];
        self.selectedSort = [NSMutableArray array];
        self.selectedDistance = [NSMutableArray array];
        self.selectedDeal = [NSMutableSet set];
        
        self.distances = [NSArray array];
        self.sortFilters = [NSArray array];
        self.deals = [NSArray array];
        self.availableFilters = [NSMutableArray array];
        [self initCategories];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Add bar button items: "Search" on the right and "Cancel" on the left
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Search" style:UIBarButtonItemStylePlain target:self action:@selector(onSearchButton)];
    
    //Set title for the navigation Bar
    self.title = @"Filters";
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SwitchCell" bundle:nil] forCellReuseIdentifier:@"SwitchCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CheckCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"CheckCell"];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4; //self.availableFilters.count;
    
}// Default is 1 if not implemented

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch(section) {
        case 0: return @"Deal";
        case 1: return @"Sort By";
        case 2: return @"Distance";
        case 3: return @"Categories";
        default: return @"";
            
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch(section) {
        case 0: return self.deals.count;
        case 1: return self.sortFilters.count;
        case 2: return self.distances.count;
        case 3: return self.categories.count;
        default: return 0;
            
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch(indexPath.section) {
        case 0: return [self getDealCell:indexPath.row];
        case 1: return [self getSortCell:indexPath.row];
        case 2: return [self getDistanceCell:indexPath.row];
        case 3: return [self getCategoryCell:indexPath.row];
        default: return nil;
    }
    
}

- (SwitchCell *)getDealCell: (NSInteger) row {
    SwitchCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
    
    cell.delegate = self;
    cell.on = NO; //[self.selectedSortList containsObject:self.availableFilters[1][row]];
    NSLog(@"title for Deal cell %@",self.availableFilters[0][row][@"name"]);
    cell.titleLabel.text = self.availableFilters[0][row][@"name"];
    return cell;
    
}

- (CheckCellTableViewCell *)getDistanceCell: (NSInteger) row {
    CheckCellTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckCell"];
    cell.CheckCellLabel.text = self.availableFilters[2][row][@"name"];
    //cell.isSelected =  [self.selectedDistance containsObject:self.availableFilters[2][row]];
//    [cell setOn:[self.selectedDistance containsObject:self.availableFilters[2][row]]];
    
    cell.delegate = self;
    //cell.on = NO; //[self.selectedSortList containsObject:self.availableFilters[1][row]];
    //NSLog(@"title for Distance cell %@",self.availableFilters[2][row][@"name"]);
    //cell.titleLabel.text = self.availableFilters[2][row][@"name"];
    return cell;
    
}

- (CheckCellTableViewCell *)getSortCell: (NSInteger) row {
    CheckCellTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckCell"];
    
    cell.delegate = self;
    //cell.isSelected = [self.selectedSort containsObject:self.availableFilters[1][row]];
//    [cell setOn:[self.selectedSort containsObject:self.availableFilters[1][row]]];
    NSLog(@"title for sort cell %@",self.availableFilters[1][row][@"name"]);
    cell.CheckCellLabel.text = self.availableFilters[1][row][@"name"];
    return cell;
    
}

- (SwitchCell *)getCategoryCell: (NSInteger) row {
    SwitchCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
    
    cell.delegate = self;
    cell.on = [self.selectedCategories containsObject:self.categories[row]];
    cell.titleLabel.text = self.categories[row][@"name"];
    return cell;
    
}


#pragma mark - SwitchCell methods
-(void)switchCell:(SwitchCell *)cell didUpdateValue:(BOOL)value {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    switch(indexPath.section) {
        case 0:
            if(value) {
                [self.selectedDeal addObject:self.categories[indexPath.row][@"code"]];
            }
            else{
                [self.selectedDeal removeObject:self.categories[indexPath.row][@"code"]];
            }
            break;
        case 3:
            if(value) {
                [self.selectedCategories addObject:self.categories[indexPath.row]];
            }
            else{
                [self.selectedCategories removeObject:self.categories[indexPath.row]];
            }
            break;
        default: break;
    }
    
         
}

#pragma mark - CheckCell
-(void)cellSelected:(CheckCellTableViewCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    switch(indexPath.section) {
        //Sortby
        case 1: [self.selectedSort addObject:self.availableFilters[1][indexPath.row][@"code"]];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [cell setOn:NO];
            break;
            
        //Distance
        case 2: [self.selectedDistance addObject:self.availableFilters[2][indexPath.row][@"code"]];
                [cell setOn:NO];
                break;
        default: break;
    }
   
}

#pragma mark - Private methods

- (NSDictionary *)filters {
    NSMutableDictionary *filters = [NSMutableDictionary dictionary];
    if(self.selectedCategories.count>0) {
        //Build a comma delimited list
        NSMutableArray *names = [NSMutableArray array];
        for(NSDictionary *category in self.selectedCategories) {
            
            //Use "code" instead of "name" since that's Yelp API friendly
            [names addObject:category[@"code"]];
        }
        NSString *categoryFilter = [names componentsJoinedByString:@","];
        [filters setObject:categoryFilter forKey:@"category_filter"];
    }
    
    if (self.selectedDeal.count>0) {
        [filters setObject:@1 forKey:@"offeringDeal"];
    }
    
    if (self.selectedSort.count>0) {
        [filters setObject:self.selectedSort forKey:@"sortMode"];
    } else {
        [filters setObject:self.sortFilters[0] forKey:@"sortMode"];
    }
    
    if (self.selectedDistance.count>0) {
        [filters setValue:self.selectedDistance forKey:@"radius"];
    }
    
    return filters;
    
}

-(void)onCancelButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)onSearchButton {
    [self.delegate filtersViewController:self didChangeFilters:self.filters];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)initCategories {
    self.deals = @[
                   @{@"name": @"Offering a Deal", @"code":@1}
                   ];
    
    
    
    self.sortFilters = @[
                         @{@"name": @"Best Match", @"code":@0, @"selected":@YES},
                         @{@"name": @"Distance", @"code":@1},
                         @{@"name": @"Rating", @"code":@2}
                         ];
    
    self.distances  = @[
                        @{@"name": @"Best Match", @"code":@"", @"selected":@YES},
                        @{@"name": @"2 Blocks", @"code":@158},
                        @{@"name": @"6 Blocks", @"code":@474},
                        @{@"name": @"1 Mile", @"code":@1609},
                        @{@"name": @"5 Miles", @"code":@8045}
                        ];
    
    self.categories = @[@{@"name": @"Afghan", @"code": @"afghani"},
                        @{@"name": @"African", @"code": @"african"},
                        @{@"name": @"American, New", @"code": @"newamerican"},
                        @{@"name": @"American, Traditional", @"code": @"tradamerican"},
                        @{@"name": @"Arabian", @"code": @"arabian"},
                        @{@"name": @"Argentine", @"code": @"argentine"},
                        @{@"name": @"Armenian", @"code": @"armenian"},
                        @{@"name": @"Asian Fusion", @"code": @"asianfusion"},
                        @{@"name": @"Asturian", @"code": @"asturian"},
                        @{@"name": @"Australian", @"code": @"australian"},
                        @{@"name": @"Austrian", @"code": @"austrian"},
                        @{@"name": @"Baguettes", @"code": @"baguettes"},
                        @{@"name": @"Bangladeshi", @"code": @"bangladeshi"},
                        @{@"name": @"Barbeque", @"code": @"bbq"},
                        @{@"name": @"Basque", @"code": @"basque"},
                        @{@"name": @"Bavarian", @"code": @"bavarian"},
                        @{@"name": @"Beer Garden", @"code": @"beergarden"},
                        @{@"name": @"Beer Hall", @"code": @"beerhall"},
                        @{@"name": @"Beisl", @"code": @"beisl"},
                        @{@"name": @"Belgian", @"code": @"belgian"},
                        @{@"name": @"Bistros", @"code": @"bistros"},
                        @{@"name": @"Black Sea", @"code": @"blacksea"},
                        @{@"name": @"Brasseries", @"code": @"brasseries"},
                        @{@"name": @"Brazilian", @"code": @"brazilian"},
                        @{@"name": @"Breakfast & Brunch", @"code": @"breakfast_brunch"},
                        @{@"name": @"British", @"code": @"british"},
                        @{@"name": @"Buffets", @"code": @"buffets"},
                        @{@"name": @"Bulgarian", @"code": @"bulgarian"},
                        @{@"name": @"Burgers", @"code": @"burgers"},
                        @{@"name": @"Burmese", @"code": @"burmese"},
                        @{@"name": @"Cafes", @"code": @"cafes"},
                        @{@"name": @"Cafeteria", @"code": @"cafeteria"},
                        @{@"name": @"Cajun/Creole", @"code": @"cajun"},
                        @{@"name": @"Cambodian", @"code": @"cambodian"},
                        @{@"name": @"Canadian", @"code": @"New)"},
                        @{@"name": @"Canteen", @"code": @"canteen"},
                        @{@"name": @"Caribbean", @"code": @"caribbean"},
                        @{@"name": @"Catalan", @"code": @"catalan"},
                        @{@"name": @"Chech", @"code": @"chech"},
                        @{@"name": @"Cheesesteaks", @"code": @"cheesesteaks"},
                        @{@"name": @"Chicken Shop", @"code": @"chickenshop"},
                        @{@"name": @"Chicken Wings", @"code": @"chicken_wings"},
                        @{@"name": @"Chilean", @"code": @"chilean"},
                        @{@"name": @"Chinese", @"code": @"chinese"},
                        @{@"name": @"Comfort Food", @"code": @"comfortfood"},
                        @{@"name": @"Corsican", @"code": @"corsican"},
                        @{@"name": @"Creperies", @"code": @"creperies"},
                        @{@"name": @"Cuban", @"code": @"cuban"},
                        @{@"name": @"Curry Sausage", @"code": @"currysausage"},
                        @{@"name": @"Cypriot", @"code": @"cypriot"},
                        @{@"name": @"Czech", @"code": @"czech"},
                        @{@"name": @"Czech/Slovakian", @"code": @"czechslovakian"},
                        @{@"name": @"Danish", @"code": @"danish"},
                        @{@"name": @"Delis", @"code": @"delis"},
                        @{@"name": @"Diners", @"code": @"diners"},
                        @{@"name": @"Dumplings", @"code": @"dumplings"},
                        @{@"name": @"Eastern European", @"code": @"eastern_european"},
                        @{@"name": @"Ethiopian", @"code": @"ethiopian"},
                        @{@"name": @"Fast Food", @"code": @"hotdogs"},
                        @{@"name": @"Filipino", @"code": @"filipino"},
                        @{@"name": @"Fish & Chips", @"code": @"fishnchips"},
                        @{@"name": @"Fondue", @"code": @"fondue"},
                        @{@"name": @"Food Court", @"code": @"food_court"},
                        @{@"name": @"Food Stands", @"code": @"foodstands"},
                        @{@"name": @"French", @"code": @"french"},
                        @{@"name": @"French Southwest", @"code": @"sud_ouest"},
                        @{@"name": @"Galician", @"code": @"galician"},
                        @{@"name": @"Gastropubs", @"code": @"gastropubs"},
                        @{@"name": @"Georgian", @"code": @"georgian"},
                        @{@"name": @"German", @"code": @"german"},
                        @{@"name": @"Giblets", @"code": @"giblets"},
                        @{@"name": @"Gluten-Free", @"code": @"gluten_free"},
                        @{@"name": @"Greek", @"code": @"greek"},
                        @{@"name": @"Halal", @"code": @"halal"},
                        @{@"name": @"Hawaiian", @"code": @"hawaiian"},
                        @{@"name": @"Heuriger", @"code": @"heuriger"},
                        @{@"name": @"Himalayan/Nepalese", @"code": @"himalayan"},
                        @{@"name": @"Hong Kong Style Cafe", @"code": @"hkcafe"},
                        @{@"name": @"Hot Dogs", @"code": @"hotdog"},
                        @{@"name": @"Hot Pot", @"code": @"hotpot"},
                        @{@"name": @"Hungarian", @"code": @"hungarian"},
                        @{@"name": @"Iberian", @"code": @"iberian"},
                        @{@"name": @"Indian", @"code": @"indpak"},
                        @{@"name": @"Indonesian", @"code": @"indonesian"},
                        @{@"name": @"International", @"code": @"international"},
                        @{@"name": @"Irish", @"code": @"irish"},
                        @{@"name": @"Island Pub", @"code": @"island_pub"},
                        @{@"name": @"Israeli", @"code": @"israeli"},
                        @{@"name": @"Italian", @"code": @"italian"},
                        @{@"name": @"Japanese", @"code": @"japanese"},
                        @{@"name": @"Jewish", @"code": @"jewish"},
                        @{@"name": @"Kebab", @"code": @"kebab"},
                        @{@"name": @"Korean", @"code": @"korean"},
                        @{@"name": @"Kosher", @"code": @"kosher"},
                        @{@"name": @"Kurdish", @"code": @"kurdish"},
                        @{@"name": @"Laos", @"code": @"laos"},
                        @{@"name": @"Laotian", @"code": @"laotian"},
                        @{@"name": @"Latin American", @"code": @"latin"},
                        @{@"name": @"Live/Raw Food", @"code": @"raw_food"},
                        @{@"name": @"Lyonnais", @"code": @"lyonnais"},
                        @{@"name": @"Malaysian", @"code": @"malaysian"},
                        @{@"name": @"Meatballs", @"code": @"meatballs"},
                        @{@"name": @"Mediterranean", @"code": @"mediterranean"},
                        @{@"name": @"Mexican", @"code": @"mexican"},
                        @{@"name": @"Middle Eastern", @"code": @"mideastern"},
                        @{@"name": @"Milk Bars", @"code": @"milkbars"},
                        @{@"name": @"Modern Australian", @"code": @"modern_australian"},
                        @{@"name": @"Modern European", @"code": @"modern_european"},
                        @{@"name": @"Mongolian", @"code": @"mongolian"},
                        @{@"name": @"Moroccan", @"code": @"moroccan"},
                        @{@"name": @"New Zealand", @"code": @"newzealand"},
                        @{@"name": @"Night Food", @"code": @"nightfood"},
                        @{@"name": @"Norcinerie", @"code": @"norcinerie"},
                        @{@"name": @"Open Sandwiches", @"code": @"opensandwiches"},
                        @{@"name": @"Oriental", @"code": @"oriental"},
                        @{@"name": @"Pakistani", @"code": @"pakistani"},
                        @{@"name": @"Parent Cafes", @"code": @"eltern_cafes"},
                        @{@"name": @"Parma", @"code": @"parma"},
                        @{@"name": @"Persian/Iranian", @"code": @"persian"},
                        @{@"name": @"Peruvian", @"code": @"peruvian"},
                        @{@"name": @"Pita", @"code": @"pita"},
                        @{@"name": @"Pizza", @"code": @"pizza"},
                        @{@"name": @"Polish", @"code": @"polish"},
                        @{@"name": @"Portuguese", @"code": @"portuguese"},
                        @{@"name": @"Potatoes", @"code": @"potatoes"},
                        @{@"name": @"Poutineries", @"code": @"poutineries"},
                        @{@"name": @"Pub Food", @"code": @"pubfood"},
                        @{@"name": @"Rice", @"code": @"riceshop"},
                        @{@"name": @"Romanian", @"code": @"romanian"},
                        @{@"name": @"Rotisserie Chicken", @"code": @"rotisserie_chicken"},
                        @{@"name": @"Rumanian", @"code": @"rumanian"},
                        @{@"name": @"Russian", @"code": @"russian"},
                        @{@"name": @"Salad", @"code": @"salad"},
                        @{@"name": @"Sandwiches", @"code": @"sandwiches"},
                        @{@"name": @"Scandinavian", @"code": @"scandinavian"},
                        @{@"name": @"Scottish", @"code": @"scottish"},
                        @{@"name": @"Seafood", @"code": @"seafood"},
                        @{@"name": @"Serbo Croatian", @"code": @"serbocroatian"},
                        @{@"name": @"Signature Cuisine", @"code": @"signature_cuisine"},
                        @{@"name": @"Singaporean", @"code": @"singaporean"},
                        @{@"name": @"Slovakian", @"code": @"slovakian"},
                        @{@"name": @"Soul Food", @"code": @"soulfood"},
                        @{@"name": @"Soup", @"code": @"soup"},
                        @{@"name": @"Southern", @"code": @"southern"},
                        @{@"name": @"Spanish", @"code": @"spanish"},
                        @{@"name": @"Steakhouses", @"code": @"steak"},
                        @{@"name": @"Sushi Bars", @"code": @"sushi"},
                        @{@"name": @"Swabian", @"code": @"swabian"},
                        @{@"name": @"Swedish", @"code": @"swedish"},
                        @{@"name": @"Swiss Food", @"code": @"swissfood"},
                        @{@"name": @"Tabernas", @"code": @"tabernas"},
                        @{@"name": @"Taiwanese", @"code": @"taiwanese"},
                        @{@"name": @"Tapas Bars", @"code": @"tapas"},
                        @{@"name": @"Tapas/Small Plates", @"code": @"tapasmallplates"},
                        @{@"name": @"Tex-Mex", @"code": @"tex-mex"},
                        @{@"name": @"Thai", @"code": @"thai"},
                        @{@"name": @"Traditional Norwegian", @"code": @"norwegian"},
                        @{@"name": @"Traditional Swedish", @"code": @"traditional_swedish"},
                        @{@"name": @"Trattorie", @"code": @"trattorie"},
                        @{@"name": @"Turkish", @"code": @"turkish"},
                        @{@"name": @"Ukrainian", @"code": @"ukrainian"},
                        @{@"name": @"Uzbek", @"code": @"uzbek"},
                        @{@"name": @"Vegan", @"code": @"vegan"},
                        @{@"name": @"Vegetarian", @"code": @"vegetarian"},
                        @{@"name": @"Venison", @"code": @"venison"},
                        @{@"name": @"Vietnamese", @"code": @"vietnamese"},
                        @{@"name": @"Wok", @"code": @"wok"},
                        @{@"name": @"Wraps", @"code": @"wraps"},
                        @{@"name": @"Yugoslav", @"code": @"yugoslav"}];
    
    [self.availableFilters addObject:self.deals];
    [self.availableFilters addObject:self.sortFilters];
    [self.availableFilters addObject:self.distances];
    [self.availableFilters addObject:self.categories];
    
    NSLog(@"availableFilters at index 1 title: %@", self.availableFilters[1][0][@"name"]);
    
    [self.filterNames addObject:@"Deals"];
    [self.filterNames addObject:@"Sort By"];
    [self.filterNames addObject:@"Distance"];
    [self.filterNames addObject:@"Categories"];
    
}


@end
