//
//  ChartDisplayerViewController.h
//  Grupo Once
//
//  Created by Carlos Guerrero on 5/24/15.
//  Copyright (c) 2015 grupoonce. All rights reserved.
//

#import "ViewController.h"

@interface ChartDisplayerViewController : ViewController


- (void)drawPieChart:(NSMutableDictionary*)chartData;
- (void)drawBarsChart:(NSMutableDictionary*)chartData;
@end
