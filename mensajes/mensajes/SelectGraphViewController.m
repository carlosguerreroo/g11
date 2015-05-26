//
//  SelectGraphViewController.m
//  Grupo Once
//
//  Created by Carlos Guerrero on 5/24/15.
//  Copyright (c) 2015 grupoonce. All rights reserved.
//

#import "SelectGraphViewController.h"
#import "ChartDisplayerViewController.h"

@interface SelectGraphViewController () <UITableViewDelegate, UITableViewDataSource> {

    NSMutableArray *cities;
    NSMutableArray *citiesChart;
    Firebase *ref;
    ChartDisplayerViewController *chartDisplayerViewController;
    NSMutableDictionary *globalChart;

}
@property (weak, nonatomic) IBOutlet UITableView *table;

@end

NSString *const fireURLChart = @"https://glaring-heat-1751.firebaseio.com/charts/";


@implementation SelectGraphViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    cities = [[NSMutableArray alloc] init];
    citiesChart = [[NSMutableArray alloc] init];
    globalChart = [[NSMutableDictionary alloc] init];
    [cities addObject:@"Gráfica General"];
    ref = [[Firebase alloc] initWithUrl: fireURLChart];
    [self setupFirebase];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) setupFirebase {
    
    [ref observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        for (NSString *key in snapshot.value){
            
            for (NSString *dataChart in snapshot.value[key]){
                
                [citiesChart addObject:snapshot.value[key]];
                if ([globalChart objectForKey:dataChart]){
                    
                    NSNumber *newValue =  snapshot.value[key][dataChart];
                    NSNumber *value = [globalChart objectForKey:dataChart];
                    NSNumber *sum = [NSNumber numberWithInt:([newValue intValue] + [value intValue])];

                    [globalChart setObject:sum forKey:dataChart];

                } else {
                    NSNumber *newValue =  snapshot.value[key][dataChart];
                    [globalChart setObject:newValue forKey:dataChart];
                }
            }
            
            [cities addObject:key];
            [_table reloadData];
        }
    
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [cities count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CityCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [cities objectAtIndex:indexPath.row];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if (chartDisplayerViewController == nil) {
        chartDisplayerViewController = (ChartDisplayerViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ChartDisplayerViewController"];
        
    }
    
    if (indexPath.row == 0) {
        [chartDisplayerViewController drawPieChart:globalChart];

    } else {
        [chartDisplayerViewController drawBarsChart:citiesChart[indexPath.row-1]];
    }
    [chartDisplayerViewController setCity:[cities objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController: chartDisplayerViewController animated: YES];
}


@end
