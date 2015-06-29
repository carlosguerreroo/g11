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
#import <MessageUI/MessageUI.h>

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#define DegreesToRadians(x) ((x) * M_PI / 180.0)

@interface ChartDisplayerViewController () <MFMailComposeViewControllerDelegate> {

    PNPieChart *pieChart;
    PNBarChart *barChart;
    NSArray *colours;
    int charDisplayed;
    BOOL sendEmail;
    Firebase *ref;
    NSMutableDictionary *cities;
    NSString *selectedCity;
}
@end

NSString *const fireURLClosed = @"https://glaring-heat-1751.firebaseio.com/closed_conversations/";

@implementation ChartDisplayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    [self setupFirebase];
    sendEmail = NO;
    cities = [[NSMutableDictionary alloc] init];

}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupFirebase {


    ref = [[Firebase alloc] initWithUrl:fireURLClosed];
    
    [ref observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        // do some stuff once
        
        for (NSString *city in snapshot.value){
            
            for (NSString * client in snapshot.value[city]) {
                NSMutableString * info = [[NSMutableString alloc] init];
                [info appendString:[NSString stringWithFormat:@"-Ciudad: %@\n",city]];
                [info appendString:[NSString stringWithFormat:@"-Cliente: %@\n",client]];
                for (NSString *comment in snapshot.value[city][client]) {
                    [info appendString:[NSString stringWithFormat:@"--Area: %@\n",snapshot.value[city][client][comment][@"area"]]];
                    [info appendString:[NSString stringWithFormat:@"--Comentario de asesor: %@\n",snapshot.value[city][client][comment][@"comment"]]];
                }
                [cities setObject:info forKey:city];
            }
        }
        
    }];

}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear: animated];
    
    if (!sendEmail) {
        [pieChart removeFromSuperview];
        [barChart removeFromSuperview];
    }
    sendEmail = NO;
}

- (void)drawBarsChart:(NSMutableDictionary*)chartData{
    
    charDisplayed = 2;
    CGFloat height = [[UIScreen mainScreen] bounds].size.height;
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;

    barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(-width*.18, height*.3, height*.80, width*.80)];
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
    barChart.backgroundColor = [UIColor colorWithHexString: @"D6D6D6"];
    
    
    [UIView beginAnimations:@"rotate" context:nil];
    [UIView setAnimationDuration:0.0];
    barChart.transform = CGAffineTransformMakeRotation(DegreesToRadians(90));
    [UIView commitAnimations];
    
    [self.view  addSubview: barChart];


}
- (void)drawPieChart:(NSMutableDictionary*)chartData{

    charDisplayed = 1;
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
    pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(width * 0.10, height * 0.18, width * 0.80, width * 0.80) items:items];
    pieChart.descriptionTextColor = [UIColor colorWithHexString: @"FFEB3B"];
    pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:14.0];
    [pieChart strokeChart];
    pieChart.backgroundColor = [UIColor colorWithHexString: @"D6D6D6"];
    [self.view addSubview:pieChart];

}
- (IBAction)sendEmail:(id)sender {
    
    if ([MFMailComposeViewController canSendMail])
    {
        sendEmail = YES;
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
   
        mail.mailComposeDelegate = self;
        [mail setSubject:@"Mensajes asesores de conversaciones concluidas y gráficas"];
        [mail setMessageBody:[self emailBody] isHTML:NO];
        [mail setToRecipients:@[@""]];
        
        UIImage *picture = [self imageWithView:barChart];
        
        if (charDisplayed == 1) {
        
            picture = [self imageWithView:pieChart];
        } else {
            picture = [self imageWithView:barChart];

        }
        
        [mail addAttachmentData:UIImageJPEGRepresentation(picture, 1) mimeType:@"image/png" fileName:@"MyFile.png"];
        [self presentViewController:mail animated:YES completion:NULL];
        
    }
    else
    {
        NSLog(@"This device cannot send email");
    }

}

-(NSMutableString*) emailBody {

    if ([cities objectForKey:selectedCity]){
    
        return [cities objectForKey:selectedCity];
        
    }
    
    NSMutableString *body = [[NSMutableString alloc]init];
    
    for (NSString *key in cities){
        
        [body appendString:cities[key]];
    }
    
    return body;

}

- (void) setCity:(NSString*)city {

    selectedCity = city;
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}
@end
