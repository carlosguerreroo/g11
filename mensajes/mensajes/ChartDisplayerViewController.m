//
//  ChartDisplayerViewController.m
//  Grupo Once
//
//  Created by Carlos Guerrero on 5/24/15.
//  Copyright (c) 2015 grupoonce. All rights reserved.
//

#import "ChartDisplayerViewController.h"
#import "PNChart.h"
#import "UIColor+Expanded.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ChartDisplayerViewController () {

    PNPieChart *pieChart;
    PNBarChart * barChart;
    NSArray *colours;
}

@end

@implementation ChartDisplayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear: animated];
    
    [pieChart removeFromSuperview];
    [barChart removeFromSuperview];
}

- (void)drawBarsChart:(NSMutableDictionary*)chartData{
    
    barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 135.0, SCREEN_WIDTH, 200.0)];
    barChart.backgroundColor = [UIColor clearColor];
    barChart.yLabelFormatter = ^(CGFloat yValue){
        CGFloat yValueParsed = yValue;
        NSString * labelText = [NSString stringWithFormat:@"%1.f",yValueParsed];
        return labelText;
    };
    barChart.labelMarginTop = 5.0;
    
    NSMutableArray *xValues = [[NSMutableArray alloc] init];
    NSMutableArray *yValues = [[NSMutableArray alloc] init];
    int max = INT_MIN;
    
    for (NSString* key in chartData) {
        NSLog(@"%@",key);
        
        if ([chartData[key] intValue] > max) {
            max = [chartData[key] intValue];
        }
        [xValues addObject:key];
        [yValues addObject:chartData[key]];
    }
    
    [barChart setXLabels:xValues];
    barChart.rotateForXAxisText = true ;
    
    barChart.yLabelSum=20;
    barChart.yMaxValue=max;
    
    [barChart setYValues:yValues];
    [barChart setStrokeColors:@[PNGreen]];
    [barChart strokeChart];
    
    [self.view addSubview: barChart];


}
- (void)drawPieChart:(NSMutableDictionary*)chartData{

    NSMutableArray *items = [[NSMutableArray alloc] init];

    colours = @[@"F44336", @"E91E63", @"9C27B0", @"3F51B5",
                @"CDDC39", @"00BCD4", @"009688", @"4CAF50",
                @"8BC34A", @"FF5722", @"FFEB3B"];
    int index = 0;
    for (NSString* key in chartData) {
    
        [items addObject:[PNPieChartDataItem dataItemWithValue:[[chartData objectForKey:key] intValue] color:[UIColor colorWithHexString:colours[index]] description:key]];
        index++;
    }
    
    CGFloat height = [[UIScreen mainScreen] bounds].size.height;
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(width * 0.10, height * 0.10, width * 0.80, width * 0.80) items:items];
    pieChart.descriptionTextColor = [UIColor colorWithHexString: @"FFEB3B"];
    pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:14.0];
    [pieChart strokeChart];
    [self.view addSubview:pieChart];

}
@end
