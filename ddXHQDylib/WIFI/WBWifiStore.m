//
//  WBWifiStore.m
//  DingTalkAssistant
//
//  Created by buginux on 2017/7/29.
//  Copyright © 2017年 buginux. All rights reserved.
//

#import "WBWifiStore.h"
#import "WBWifiModel.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <netdb.h>
#import "ddXHQDylib.h"

static NSString * const kWifiHookedKey = @"WifiHookedKey";
static NSString * const kHistoryWifiKey = @"HistoryWifiKey";

@implementation WBWifiStore

+ (instancetype)sharedStore {
    static WBWifiStore *store = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        store = [[[self class] alloc] init];
    });
    return store;
}

- (instancetype)init {
    if (self = [super init]) {
        _currentWifiList = [[NSMutableArray alloc] init];
        _historyWifiList = [[NSMutableArray alloc] init];
    }
//    NSLog(@"%xhq12345执行了");
    return self;
}

- (void)fetchCurrentWifi {
    [self.currentWifiList removeAllObjects];
    
    CFArrayRef arrayRef = CNCopySupportedInterfaces();
    NSArray *interfaces = (__bridge NSArray *)(arrayRef);
    
    if ([interfaces count] > 0) {
        NSString *interfaceName = [interfaces firstObject];
        
        CFDictionaryRef info = oldCNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceName);
        NSDictionary *dictionary = (__bridge NSDictionary *)(info);
        
        if (dictionary) {
            WBWifiModel *wifi = [[WBWifiModel alloc] initWithInterfaceName:interfaceName dictionary:dictionary];
            wifi.flags = [self fetchCurrentNetworkStatus];//看不懂
            [self.currentWifiList addObject:wifi];
        }
    }
}

- (void)fetchHistoryWifi {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kHistoryWifiKey];
    
    if ([data length] > 0) {
        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        if ([array count] > 0) {
            NSMutableArray *copyArray = [[NSMutableArray alloc] initWithArray:array];
            self.historyWifiList = copyArray;
        }
    }
}

- (void)appendHistoryWifi:(WBWifiModel *)wifi {
    if (![self.historyWifiList containsObject:wifi]) {
        [self.historyWifiList addObject:wifi];
    }
}

- (void)saveHistoryWifi {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.historyWifiList];
    
    if (data) {
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kHistoryWifiKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (SCNetworkReachabilityFlags)fetchCurrentNetworkStatus {
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags) {
        NSLog(@"Error. Could not receover network reachability flags.");
        return 0;
    }
    
    return flags;
}
//把wifi存到NSDF里,key是kWifiHookedKey
- (void)hookWifi:(WBWifiModel *)wifi {
    if (!wifi) {
        return;
    }
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:wifi];
    
    if ([data length] > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kWifiHookedKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self fetchCurrentWifi];//把当前的wifi放在数组里
    }
}


- (WBWifiModel *)wifiHooked {
    WBWifiModel *wifi = nil;
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kWifiHookedKey];
    if ([data length] > 0) {
        wifi = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    return wifi;
}

@end
