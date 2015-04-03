//
//  ViewController.m
//  mensajes
//
//  Created by Carlos Guerrero on 3/31/15.
//  Copyright (c) 2015 grupoonce. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    
    NSArray *_pickerData;
    UIColor *grayColor;
    UIColor *yellowColor;
}

@property (weak, nonatomic) IBOutlet UIView *signup;
@property (weak, nonatomic) IBOutlet UIView *login;
@property (weak, nonatomic) IBOutlet UIView *header;
@property (weak, nonatomic) IBOutlet UIView *selector;
@property (weak, nonatomic) IBOutlet UIPickerView *cities;
@property (weak, nonatomic) IBOutlet UISegmentedControl *viewSelector;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;

//Login items



//Signup items
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *signupItems;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self signup].hidden = NO;
    [self login].hidden = YES;
    _pickerData = @[@"Item 1", @"Item 2", @"Item 3", @"Item 4", @"Item 5", @"Item 6"];
    grayColor = [UIColor colorWithRed:0.651 green:0.651 blue:0.651 alpha:1];
    yellowColor = [UIColor colorWithRed:0.996 green:0.761 blue:0.133 alpha:1];

    self.cities.dataSource = self;
    self.cities.delegate = self;
    
    //Setting background color
    self.signup.backgroundColor = grayColor;
    self.login.backgroundColor = grayColor;
    self.header.backgroundColor = grayColor;
    self.selector.backgroundColor = grayColor;
    
    self.viewSelector.tintColor = yellowColor;
    
    
    
    for (UITextField *object in self.signupItems) {
        object.layer.cornerRadius = 4.0f;
        object.layer.masksToBounds= YES;
        object.layer.borderColor = [yellowColor CGColor];
        object.layer.borderWidth = 1.5f;
	}
    
    self.signupButton.backgroundColor = yellowColor;
    self.signupButton.layer.cornerRadius = 4.0f;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)changeView:(UISegmentedControl *)sender {

    switch (sender.selectedSegmentIndex)
    {
        case 0:
            self.signup.hidden = NO;
            self.login.hidden = YES;
            break;
        case 1:
            self.signup.hidden = YES;
            self.login.hidden = NO;
            break;
        default: 
            break; 
    }
}


// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerData[row];
}


@end
