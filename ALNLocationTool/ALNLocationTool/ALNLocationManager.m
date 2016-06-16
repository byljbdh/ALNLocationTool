//
//  ALNLocationManager.m
//
//  Created by 罗骏彬 on 15/12/11.
//

#import "ALNLocationManager.h"
#import "ALNCityModel.h"
#import <CoreLocation/CoreLocation.h>
#define moreThaniOS8 ([[[UIDevice currentDevice] systemVersion] integerValue] >= 8.0)

@interface ALNLocationManager()<CLLocationManagerDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) CLLocationManager *CLLM;
@property (nonatomic, strong) ALNCityModel *currentLocatedCityModel;
@property (nonatomic, strong) CLPlacemark *currentPlaceMark;
@property (nonatomic, assign,getter=hadUpdate) BOOL Updated;
@end

@implementation ALNLocationManager
static ALNLocationManager * locationManager = nil;
+ (ALNLocationManager *)locationManager
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        locationManager = [[self alloc] init];
        locationManager.CLLM = [[CLLocationManager alloc]init];
        locationManager.CLLM.delegate = locationManager;
        locationManager.CLLM.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.CLLM.distanceFilter = kCLDistanceFilterNone;
        
        if(moreThaniOS8) {
            [locationManager.CLLM requestWhenInUseAuthorization];
        }
    });
    return locationManager;
}
- (void)startLocate{
    self.Updated = NO;
    //定位管理器
    if ([CLLocationManager locationServicesEnabled]) {
        [self.CLLM startUpdatingLocation];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
    else{
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"未开启定位,无法获取位置信息" message:@"请在【设置-隐私-定位】中开启定位" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alert show];
    }
}
#pragma mark - CoreLocation 代理
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *location=[locations firstObject];//取出第一个位置
    CLLocationCoordinate2D coordinate=location.coordinate;//位置坐标
    NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f",coordinate.longitude,coordinate.latitude,location.altitude,location.course,location.speed);
    //根据经纬度判断当前的城市
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
   __block CLPlacemark *placemark;
    //根据经纬度反向地理编译出地址信息

    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *array, NSError *error){
      if(!self.hadUpdate) {
         if (array.count > 0){
             placemark = [array objectAtIndex:0];
             NSLog(@"%@",placemark);
             self.currentPlaceMark = placemark;
            
             //获取城市
            NSString *city = placemark.locality;
             if (!city) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 city = placemark.administrativeArea;
             }
             //得到当前定位到的城市
             self.currentLocatedCityModel = [ALNCityModel cityModelWithCity:city longitude:coordinate.longitude latitude:coordinate.latitude];
         }else if (error == nil && [array count] == 0){
              NSLog(@"No results were returned.");
         }
          else if (error != nil){
              NSLog(@"An error occurred = %@", error);
         }else{
              NSLog(@"%@",error);
         }
         //使用完即使关闭定位服务
         [self.CLLM stopUpdatingLocation];
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
         self.Updated = YES;
         //定位完毕返回城市模型
         if([self.delegate respondsToSelector:@selector(locationManagerDidLocated: location: success:)]){
             [self.delegate locationManagerDidLocated:self.currentLocatedCityModel location:location success:YES];
         }
      }
    }];
}
#pragma mark 定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error domain] == kCLErrorDomain){
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"未开启定位,无法获取位置信息" message:@"请在【设置-隐私-定位】中开启定位" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alert show];
    }
    [self.CLLM stopUpdatingLocation];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
     self.Updated = YES;
    //定位失败,调用代理方法
    if([self.delegate respondsToSelector:@selector(locationManagerDidLocated: location: success:)]){
        [self.delegate locationManagerDidLocated:nil location:nil success:NO];
    }
}

- (void)stopLocate{
    [self.CLLM stopUpdatingLocation];
    [self.CLLM stopMonitoringSignificantLocationChanges];
}
- (CLPlacemark *)get_PlaceMark{
    return self.currentPlaceMark;
}
@end
