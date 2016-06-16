//
//  ALNLocationManager.h
//
//  Created by 罗骏彬 on 15/12/11.
//
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class ALNLocationManager,ALNCityModel,CLPlacemark,CLLocation;
@protocol ALNLocationManagerDelegate;

@interface ALNLocationManager : NSObject
@property (nonatomic, weak) id<ALNLocationManagerDelegate> delegate;
+ (ALNLocationManager *)locationManager;
- (void)startLocate;
- (void)stopLocate;
- (CLPlacemark *)currentPlaceMark;
@end

@protocol ALNLocationManagerDelegate <NSObject>
- (void)locationManagerDidLocated:(ALNCityModel *)cityModel location:(CLLocation *)location success:(BOOL)success;
@end