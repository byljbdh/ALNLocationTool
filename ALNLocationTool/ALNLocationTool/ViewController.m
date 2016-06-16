//
//  ViewController.m
//  ALNLocationTool
//
//  Created by Avatar on 16/6/16.
//  Copyright © 2016年 ALN. All rights reserved.
//

#import "ViewController.h"
#import "ALNLocationManager.h"
#import "ALNCityModel.h"

@interface ViewController ()<ALNLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *cityLabel;
@property (nonatomic, strong) ALNLocationManager *manager;
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [ALNLocationManager locationManager];
    self.manager.delegate = self;
}
- (IBAction)start:(id)sender {
    [self.manager startLocate];
}
- (IBAction)stop:(id)sender {
    [self.manager stopLocate];
}
#pragma mark - ALNLocationManagerDelegate
- (void)locationManagerDidLocated:(ALNCityModel *)cityModel location:(CLLocation *)location success:(BOOL)success{
    self.cityLabel.text = cityModel.city;
}
@end
