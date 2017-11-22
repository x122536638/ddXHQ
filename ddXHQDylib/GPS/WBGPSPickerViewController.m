//
//  WBGPSPickerViewController.m
//  DingTalkAssistant
//
//  Created by buginux on 2017/7/28.
//  Copyright © 2017年 buginux. All rights reserved.
//

#import "WBGPSPickerViewController.h"
#import "DingtalkPluginConfig.h"
#import "MapViewController.h"
@interface WBGPSPickerViewController ()
@property (nonatomic,strong) UITextField *lonTF;
@property (nonatomic ,strong) UITextField *latTF;
@property (nonatomic,strong) MapViewController *mapVC;
@end

@implementation WBGPSPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     _mapVC = [[MapViewController alloc]init];
    self.title = @"GPS 设置";
    
 
    
    _lonTF = [[UITextField alloc]initWithFrame:CGRectMake(80, 150, 200, 50)];
    _lonTF.placeholder = @"请输入经度";
    _lonTF.keyboardType = UIKeyboardTypeNumberPad;
    _latTF = [[UITextField alloc]initWithFrame:CGRectMake(80, 250, 200, 50)];
    _latTF.placeholder = @"请输入纬度";
    _latTF.keyboardType = UIKeyboardTypeNumberPad;
    __weak typeof(self) weakSelf  = self;
    _mapVC.block = ^(double longitude, double latitude) {
        weakSelf.lonTF.text =[NSString stringWithFormat:@"%f",longitude];
        weakSelf.latTF.text = [NSString stringWithFormat:@"%f",latitude];
    };
    
    
    NSNumber *numberLAT = [[NSUserDefaults standardUserDefaults]  objectForKey:@"lat_xhq"];
    NSNumber *numberLON    = [[NSUserDefaults standardUserDefaults]  objectForKey:@"lon_xhq"];
    if ([numberLAT doubleValue] || [numberLON doubleValue]) {
        _lonTF.placeholder = [NSString stringWithFormat:@"%lf",[numberLON doubleValue]];
         _latTF.placeholder = [NSString stringWithFormat:@"%lf",[numberLAT doubleValue]];
    }else{
        
    }
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(120, 320, 200, 50)];
    [button setTitle:@"修改" forState:(UIControlStateNormal)];
    button.titleLabel.backgroundColor = [UIColor blueColor];
    [button addTarget:self action:@selector(changeGPS:) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(10, 320, 150, 50)];
    [button2 setTitle:@"删除GPS定位" forState:(UIControlStateNormal)];
    button2.titleLabel.backgroundColor = [UIColor blueColor];
    [button2 addTarget:self action:@selector(delGPS:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *mapBT = [[UIButton alloc]initWithFrame:CGRectMake(80, 390, 200, 50)];
    mapBT.backgroundColor = [UIColor blueColor];
    [mapBT setTitle:@"前往地图拾取坐标" forState:(UIControlStateNormal)];
    [mapBT addTarget:self action:@selector(pushToMapVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mapBT];
    [self.view addSubview:_lonTF];
    [self.view addSubview:_latTF];
    [self.view addSubview:button];
      [self.view addSubview:button2];
    
}

-(void)delGPS:(id)x{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"lat_xhq"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"lon_xhq"];
    
    [[NSUserDefaults standardUserDefaults]  synchronize];
    [pluginConfig setLocation:CLLocationCoordinate2DMake(0,0)];
    UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"删除成功" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
      [alerVC addAction:okAction];
      [self presentViewController:alerVC animated:NO completion:nil];
    
    
}
-(void)changeGPS:(UIButton *)sender{
    double lat  = [_latTF.text doubleValue];
    double lon = [_lonTF.text doubleValue];
    [pluginConfig setLocation:CLLocationCoordinate2DMake(lat,lon)];
    UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"成功" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alerVC addAction:okAction];
    
//    xhqxhq
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:lat] forKey:@"lat_xhq"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:lon] forKey:@"lon_xhq"];

    [[NSUserDefaults standardUserDefaults]  synchronize];
    
    
    [self presentViewController:alerVC animated:NO completion:nil];
}
-(void)pushToMapVC:(UIButton *)sender{
  
    [self.navigationController pushViewController:_mapVC animated:YES ];
}
@end
