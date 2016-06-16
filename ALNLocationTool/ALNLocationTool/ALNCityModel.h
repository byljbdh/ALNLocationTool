//
//  ALNCityModel.h
//
//  Created by 罗骏彬 on 15/11/17.
//

#import <Foundation/Foundation.h>

@interface ALNCityModel : NSObject
/**城市名称*/
@property (nonatomic,copy) NSString *city;
/**经度*/
@property (nonatomic,assign) double longitude;
/**纬度*/
@property (nonatomic,assign) double latitude;
- (instancetype)initWithCity:(NSString *)city longitude:(double)longitude latitude:(double)latitude;
+ (instancetype)cityModelWithCity:(NSString *)city longitude:(double)longitude latitude:(double)latitude;
@end
