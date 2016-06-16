//
//  ALNCityModel.m
//
//  Created by 罗骏彬 on 15/11/17.
//

#import "ALNCityModel.h"

@implementation ALNCityModel
+ (instancetype)cityModelWithCity:(NSString *)city longitude:(double)longitude latitude:(double)latitude{
    ALNCityModel *model = [[ALNCityModel alloc]initWithCity:city longitude:longitude latitude:latitude];
    return model;
}
- (instancetype)initWithCity:(NSString *)city longitude:(double)longitude latitude:(double)latitude{
    if(self = [super init]){
        self.city = city;
        self.longitude = longitude;
        self.latitude = latitude;
    }
    return self;
}
- (NSString *)description{
    return [NSString stringWithFormat:@"cityName:%@,longitude:%f,latitude:%f",self.city,self.longitude,self.latitude];
}
@end
