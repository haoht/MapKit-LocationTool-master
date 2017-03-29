//
//  AddressTool.m
//  123
//
//  Created by liman on 15/10/29.
//  Copyright © 2015年 liman. All rights reserved.
//

#import "LocationTool.h"

@implementation LocationTool

+ (LocationTool *)sharedInstance
{
    static LocationTool *__singletion = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        __singletion = [[self alloc] init];
        
    });
    
    return __singletion;
}

#pragma mark - public
/**
 *  根据经纬度得到具体地址
 */
- (void)getAddress_latitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude success:(void (^)(NSString *address))successBlock failure:(void (^)(NSError *error))failureBlock
{
    if (!_myGeocoder) {
        // 逆地理编码
        _myGeocoder = [[CLGeocoder alloc] init];
    }
    //------------------------------------------------------------------------------------------------
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    [_myGeocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (!error && [placemarks count] > 0)
        {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            
            
//            NSLog(@"Country = %@",placemark.country);
//            NSLog(@"Postal Code = %@",placemark.postalCode);
//            NSLog(@"Locality = %@",placemark.locality);
//            NSLog(@"name = %@",placemark.name);
//            NSLog(@"administrativeArea = %@",placemark.administrativeArea);
//            NSLog(@"subAdministrativeArea = %@",placemark.subAdministrativeArea);
//            NSLog(@"subLocality = %@",placemark.subLocality);
//            NSLog(@"thoroughfare = %@",placemark.thoroughfare);
//            NSLog(@"subThoroughfare = %@",placemark.subThoroughfare);
//            NSLog(@"inlandWater = %@",placemark.inlandWater);
//            NSLog(@"ocean = %@",placemark.ocean);
//            
//            NSLog(@"addressDictionary = %@", placemark.addressDictionary);
//            
//            NSLog(@"____________________%@", placemark);
            
            
            // formattedAddressLines:xx街道xx号, name:xx大厦, 也可能name:xx街道xx号
            NSString *formattedAddressLines = @"";
            if ([placemark.addressDictionary[@"FormattedAddressLines"] count] > 0) {
                formattedAddressLines = placemark.addressDictionary[@"FormattedAddressLines"][0];
            }
            
            NSString *name = @"";
            if (placemark.addressDictionary[@"Name"]) {
                name = placemark.addressDictionary[@"Name"];
            }
            
            if ([formattedAddressLines isEqualToString:name]) {
                name = @"";
            }
            
            successBlock([formattedAddressLines stringByAppendingString:name]);
        }
        else
        {
            failureBlock(error);
        }
    }];
}

/**
 *  定位当前位置, 得到经纬度
 *
 *  @param continuousLocating 是否持续定位(否则一次定位)
 */
- (void)getCurrentLocation_continuousLocating:(BOOL)continuousLocating success:(void (^)(CLLocationDegrees latitude, CLLocationDegrees longitude))successBlock failure:(void (^)(NSString *errorDescription, NSError *error))failureBlock
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    //------------------------------------------------------------------------------------------------
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        //设置定位权限 仅ios8有意义
        [_locationManager requestWhenInUseAuthorization];
    }
    
    if (![CLLocationManager locationServicesEnabled])
    {
        failureBlock(@"定位不可用", nil);
        return;
    }
    else
    {
        [_locationManager setDelegate:self];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];//精确度
        
        if (continuousLocating)
        {
            //持续定位
            [_locationManager startUpdatingLocation];
        }
        else
        {
            //一次定位
            [_locationManager requestLocation];
        }
    }
    
    
    _successBlock = successBlock;
    _failureBlock = failureBlock;
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        _failureBlock(@"用户禁用了此App定位功能", nil);
    }
    else
    {
        _failureBlock(nil, error);
    }
}

// 获取我的位置经纬度 (持续定位)
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    _successBlock(newLocation.coordinate.latitude, newLocation.coordinate.longitude);
}

// 获取我的位置经纬度 (一次定位)
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    if ([locations count] > 0)
    {
        CLLocation *location = locations[0];
        _successBlock(location.coordinate.latitude, location.coordinate.longitude);
    }
    else
    {
        _failureBlock(@"定位失败", nil);
    }
}

/**
 *  根据经纬度判断是国内还是国外 (港澳台取决于用的是高德还是tomtom)
 */
- (void)judgeWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude result:(void (^)(BOOL isChina))resultBlock
{
    if (!_myGeocoder) {
        // 逆地理编码
        _myGeocoder = [[CLGeocoder alloc] init];
    }
    //------------------------------------------------------------------------------------------------
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    [_myGeocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (!error && [placemarks count] > 0)
        {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            
            NSLog(@"addressDictionary = %@", placemark.addressDictionary);
            
            NSString *countryCode = placemark.addressDictionary[@"CountryCode"];
            if ([countryCode isEqualToString:@"CN"])
            {
                resultBlock(YES);
            }
            else
            {
                resultBlock(NO);
            }
        }
        else
        {
            resultBlock(NO);
        }
    }];
}


//============================================= 以下是组合使用 ===========================================

/**
 *  定位当前位置, 得到具体地址
 *
 *  @param continuousLocating 是否持续定位(否则一次定位)
 */
- (void)getCurrentAddress_continuousLocating:(BOOL)continuousLocating success:(void (^)(NSString *address))successBlock failure:(void (^)(NSString *errorDescription, NSError *error))failureBlock
{
    // 1.定位当前位置, 得到经纬度
    [self getCurrentLocation_continuousLocating:continuousLocating success:^(CLLocationDegrees latitude, CLLocationDegrees longitude) {
        
        // 2.根据经纬度得到具体地址
        [self getAddress_latitude:latitude longitude:longitude success:^(NSString *address) {
            
            successBlock(address);
            
        } failure:^(NSError *error) {
            failureBlock(nil, error);
        }];
        
    } failure:^(NSString *errorDescription, NSError *error) {
        failureBlock(errorDescription, error);
    }];
}

/**
 *  判断当前位置是国内还是国外 (港澳台取决于用的是高德还是tomtom)
 *
 *  @param continuousLocating 是否持续定位(否则一次定位)
 */
- (void)judge_continuousLocating:(BOOL)continuousLocating result:(void (^)(BOOL isChina))resultBlock failure:(void (^)(NSString *errorDescription, NSError *error))failureBlock
{
    // 1.定位当前位置, 得到经纬度
    [self getCurrentLocation_continuousLocating:continuousLocating success:^(CLLocationDegrees latitude, CLLocationDegrees longitude) {
        
        // 2.根据经纬度判断是国内还是国外
        [self judgeWithLatitude:latitude longitude:longitude result:^(BOOL isChina) {
            
            resultBlock(isChina);
        }];
        
    } failure:^(NSString *errorDescription, NSError *error) {
        failureBlock(errorDescription, error);
    }];
}

@end
