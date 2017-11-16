//  weibo: http://weibo.com/xiaoqing28
//  blog:  http://www.alonemonkey.com
//
//  ddXHQDylib.m
//  ddXHQDylib
//
//  Created by xhq on 2017/11/10.
//  Copyright (c) 2017年 xhq. All rights reserved.
//

#import "ddXHQDylib.h"
#import <CaptainHook/CaptainHook.h>
#import <UIKit/UIKit.h>
#import <Cycript/Cycript.h>

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------_____________-

#import "MenuWindow/WBAssistantManager.h"
#import "WIFI/WBWifiStore.h"
#import "WIFI/WBWifiModel.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "fishhook.h"
CFArrayRef (*oldCNCopySupportedInterfaces)();
//之前add 了,再次修改
CFDictionaryRef (*oldCNCopyCurrentNetworkInfo)(CFStringRef interfaceName);
Boolean (*oldSCNetworkReachabilityGetFlags)(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags *flags);

//我感觉这个函数没用,因为 CNCopySupportedInterfaces 这个函数得到的结果永远都是en0
CFArrayRef newCNCopySupportedInterfaces() {
    CFArrayRef result = NULL;
    
    WBWifiModel *wifi = [[WBWifiStore sharedStore] wifiHooked];
    
    if(wifi && wifi.interfaceName) {
        NSArray *array = [NSArray arrayWithObject:wifi.interfaceName];
        result = (CFArrayRef)CFRetain((__bridge CFArrayRef)(array));
    }
    
    if(!result) {
        result = oldCNCopySupportedInterfaces();
    }
    
    return result;
}

CFDictionaryRef newCNCopyCurrentNetworkInfo(CFStringRef interfaceName) {
    CFDictionaryRef result = NULL;
    
    WBWifiModel *wifi = [[WBWifiStore sharedStore] wifiHooked];
    NSLog(@"xhq12345执行了newCNCopyCurrentNetworkInfo  wifi.SSID: %@",wifi.SSID);
    if(wifi) {
        
        NSDictionary *dictionary = @{
                                     @"BSSID": (wifi.BSSID ? wifi.BSSID : @""),
                                     @"SSID": (wifi.SSID ? wifi.SSID : @""),
                                     @"SSIDDATA": (wifi.SSIDData ? wifi.SSIDData : @"")
                                     };
        result = (CFDictionaryRef)CFRetain((__bridge CFDictionaryRef)(dictionary));
    }
    
    if(!result) {
        result = oldCNCopyCurrentNetworkInfo(interfaceName);
    }
    
    return result;
}

Boolean newSCNetworkReachabilityGetFlags(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags *flags) {
    Boolean result = false;
    
    WBWifiModel *wifi = [[WBWifiStore sharedStore] wifiHooked];
    if(wifi && wifi.flags > 0) {
        result = true;
        *flags = wifi.flags;
    }
    
    if(!result) {
        result = oldSCNetworkReachabilityGetFlags(target, flags);
    }
    
    return result;
}
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




static __attribute__((constructor)) void entry(){
    NSLog(@"\n               🎉!!！congratulations!!！🎉\n👍----------------insert dylib success----------------👍");
    
    //---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    struct rebinding open_rebinding = { "CNCopyCurrentNetworkInfo", newCNCopyCurrentNetworkInfo, (void *)&oldCNCopyCurrentNetworkInfo};
    struct rebinding open_rebinding2 = { "CNCopySupportedInterfaces", newCNCopySupportedInterfaces, (void *)&oldCNCopySupportedInterfaces};
    struct rebinding open_rebinding3 = { "SCNetworkReachabilityGetFlags", newSCNetworkReachabilityGetFlags, (void *)&oldSCNetworkReachabilityGetFlags};


    // 将结构体包装成数组，并传入数组的大小，对原符号 open 进行重绑定
    rebind_symbols((struct rebinding[3]){open_rebinding,open_rebinding2,open_rebinding}, 3);
    
    
    
    //---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        CYListenServer(6666);
    }];
}

@interface CustomViewController

-(NSString*)getMyName;

@end

CHDeclareClass(CustomViewController)

CHOptimizedMethod(0, self, NSString*, CustomViewController,getMyName){
    //get origin value
    NSString* originName = CHSuper(0, CustomViewController, getMyName);
    
    NSLog(@"origin name is:%@",originName);
    
    //get property
    NSString* password = CHIvar(self,_password,__strong NSString*);
    
    NSLog(@"password is %@",password);
    
    //change the value
    return @"AloneMonkey";
    
}

CHConstructor{
    CHLoadLateClass(CustomViewController);
    CHClassHook(0, CustomViewController, getMyName);
}






