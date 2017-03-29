//
//  AddressTool.h
//  123
//
//  Created by liman on 15/10/29.
//  Copyright © 2015年 liman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^SuccessBlock)(CLLocationDegrees latitude, CLLocationDegrees longitude);
typedef void(^FailureBlock)(NSString *errorDescription, NSError *error);

@interface LocationTool : NSObject <CLLocationManagerDelegate>

+ (LocationTool *)sharedInstance;

// 逆地理编码
@property (strong, nonatomic) CLGeocoder *myGeocoder;

// 定位
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (copy, nonatomic) SuccessBlock successBlock;
@property (copy, nonatomic) FailureBlock failureBlock;

/**
 *  根据经纬度得到具体地址
 */
- (void)getAddress_latitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude success:(void (^)(NSString *address))successBlock failure:(void (^)(NSError *error))failureBlock;

/**
 *  定位当前位置, 得到经纬度
 *
 *  @param continuousLocating 是否持续定位(否则一次定位)
 */
- (void)getCurrentLocation_continuousLocating:(BOOL)continuousLocating success:(void (^)(CLLocationDegrees latitude, CLLocationDegrees longitude))successBlock failure:(void (^)(NSString *errorDescription, NSError *error))failureBlock;

/**
 *  根据经纬度判断是国内还是国外 (港澳台取决于用的是高德还是tomtom)
 */
- (void)judgeWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude result:(void (^)(BOOL isChina))resultBlock;


//============================================= 以下是组合使用 ===========================================

/**
 *  定位当前位置, 得到具体地址
 *
 *  @param continuousLocating 是否持续定位(否则一次定位)
 */
- (void)getCurrentAddress_continuousLocating:(BOOL)continuousLocating success:(void (^)(NSString *address))successBlock failure:(void (^)(NSString *errorDescription, NSError *error))failureBlock;

/**
 *  判断当前位置是国内还是国外 (港澳台取决于用的是高德还是tomtom)
 *
 *  @param continuousLocating 是否持续定位(否则一次定位)
 */
- (void)judge_continuousLocating:(BOOL)continuousLocating result:(void (^)(BOOL isChina))resultBlock failure:(void (^)(NSString *errorDescription, NSError *error))failureBlock;

@end
