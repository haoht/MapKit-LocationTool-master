//
//  ViewController.m
//  根据指定经纬度确定位置
//
//  Created by liman on 15/10/29.
//  Copyright © 2015年 liman. All rights reserved.
//

#import "ViewController.h"
#import "LocationTool.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self test];  // 根据经纬度得到具体地址
    [self test2]; // 定位当前位置, 得到经纬度
    [self test3]; // 根据经纬度判断是国内还是国外
    
    // =============== 以下是组合使用 ===============
    
    [self test4]; // 定位当前位置, 得到具体地址
    [self test5]; // 判断当前位置是国内还是国外
}

- (void)test
{
    // 根据经纬度得到具体地址
    [[LocationTool sharedInstance] getAddress_latitude:22.5368957 longitude:113.9495183 success:^(NSString *address) {
        
        [[[UIAlertView alloc] initWithTitle:@"" message:address delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
        
    } failure:^(NSError *error) {
        
        [[[UIAlertView alloc] initWithTitle:@"" message:error.localizedDescription delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
    }];
}

- (void)test2
{
    // 定位当前位置, 得到经纬度
    [[LocationTool sharedInstance] getCurrentLocation_continuousLocating:NO success:^(CLLocationDegrees latitude, CLLocationDegrees longitude) {
        
        [[[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%f %f", latitude, longitude] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
        
    } failure:^(NSString *errorDescription, NSError *error) {
        
        if (errorDescription)
        {
            [[[UIAlertView alloc] initWithTitle:@"" message:errorDescription delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"" message:error.localizedDescription delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
        }
    }];
}

- (void)test3
{
    // 根据经纬度判断是国内还是国外 (港澳台取决于用的是高德还是tomtom)
    [[LocationTool sharedInstance] judgeWithLatitude:22.5368957 longitude:113.9495183 result:^(BOOL isChina) {
        
        if (isChina)
        {
            [[[UIAlertView alloc] initWithTitle:@"" message:@"china" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"" message:@"not china" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
        }
    }];
}

- (void)test4
{
    // 定位当前位置, 得到具体地址
    [[LocationTool sharedInstance] getCurrentAddress_continuousLocating:NO success:^(NSString *address) {
        
        [[[UIAlertView alloc] initWithTitle:@"" message:address delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
        
    } failure:^(NSString *errorDescription, NSError *error) {
        
        if (errorDescription)
        {
            [[[UIAlertView alloc] initWithTitle:@"" message:errorDescription delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"" message:error.localizedDescription delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
        }
    }];
}

- (void)test5
{
    // 判断当前位置是国内还是国外 (港澳台取决于用的是高德还是tomtom)
    [[LocationTool sharedInstance] judge_continuousLocating:NO result:^(BOOL isChina) {
        
        if (isChina)
        {
            [[[UIAlertView alloc] initWithTitle:@"" message:@"china" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"" message:@"not china" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
        }
        
    } failure:^(NSString *errorDescription, NSError *error) {
        
        if (errorDescription)
        {
            [[[UIAlertView alloc] initWithTitle:@"" message:errorDescription delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"" message:error.localizedDescription delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
        }
    }];
}

@end
