//
//  ESBLEScanner.h
//  esmobile
//
//  Created by luzhenwen on 15/8/27.
//  Copyright (c) 2015年 excelsecu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "ZWCentralManager.h"

@class ZWBLEScannerObserver;


/*!
 @class
 @version 1.0
 @author  lzw
 @abstract BLE蓝牙扫描器。为了实现能同时使用靠近连接、扫码连接和扫描连接，创建了此类。
 @discussion 使用时创建对象，然后添加扫描观察者即可。用完必须删除观察者。
 */
@interface ZWBLEScanner : NSObject

@property(nonatomic, retain, readonly) ZWCentralManager *zwCentralManager;

-(CBCentralManager *)centralManager;

+ (instancetype)shareScanner;

-(void)addScanObserver:(ZWBLEScannerObserver *)obsr;
-(void)removeScanObserver:(ZWBLEScannerObserver *)obsr;

/*!
 @method
 @abstract 清空监听器列表，停止扫描
 */
-(void)clear;

-(void)startScan:(ZWBLEScannerObserver *)obr;
-(void)stopScan:(ZWBLEScannerObserver *)obr;
@end



/*!
 @protocol
 @abstract  BLE设备委托
 @author    陆振文
 */
@protocol ZWScannerDelegate <NSObject>

@optional
/*!
 @method
 @abstract BLE状态回调。可以通过此委托方法判断BLE是否可用（CBCentralManagerStateUnsupported）或者蓝牙是否打开等等！当ble状态在 CBCentralManagerStatePoweredOn 时才可以开始扫描.回调在主线程运行
 
 @param    central 中心管理器
 @see      CBCentralManagerState
 @see      ESBLEDeviceManager
 */
- (void)centralManagerDidUpdateState:(CBCentralManager*)central;

/*!
 @method
 @abstract 开始扫描，方法在主线程调用
 @param    mgr BLE设备管理器
 */
- (void)centralManagerDidStartDiscover:(CBCentralManager*)mgr;

/*!
 @method
 @abstract 停止扫描，方法在主线程调用
 @param    mgr BLE设备管理器
 */
- (void)centralManagerDidEndDiscover:(CBCentralManager*)mgr;

/*!
 @method
 @abstract 扫描超时，方法在主线程调用
 @param    mgr BLE设备管理器
 */
- (void)centralManagerDidTimeout:(CBCentralManager*)mgr;

@required
/*!
 @method
 @abstract 通知扫描到的BLE设备信息
 @param    peripheral            BLE设备对象
 @param    advertisementData     设备广播数据
 @param    RSSI                  设备信号强度
 */
- (void)didDiscoverPeripheral:(CBPeripheral*)peripheral advertisementData:(NSDictionary*)advertisementData RSSI:(NSNumber*)RSSI;

@end



@class ZWBLEScannerObserver;

typedef void(^ZWBLEScannerCallback)(ZWBLEScannerObserver *observer, CBCentralManager *mgr);
typedef void(^ZWBLEScannerDidDiscoverCallback)(ZWBLEScannerObserver *observer,CBPeripheral *p, NSDictionary *advertisementData, NSNumber *rssi);

@interface ZWBLEScannerObserver : NSObject <ZWScannerDelegate>

@property(assign , nonatomic) NSTimeInterval                    timeout;  // scanning timeout
@property(assign , nonatomic) id<ZWScannerDelegate>       outsideDelegate;
@property(assign , nonatomic) BOOL                              dispatchToMainQueue; // default to current queue
@property(retain , nonatomic) id                                userData;
@property(assign , nonatomic, readonly) ZWBLEScanner            *scanner;
@property(assign , nonatomic) BOOL                              allowDuplicatePeripheral;


@property(nonatomic, copy) ZWBLEScannerCallback managerDidUpdateState;
@property(nonatomic, copy) ZWBLEScannerCallback managerDidStartDiscover;
@property(nonatomic, copy) ZWBLEScannerCallback managerDidEndDiscover;
@property(nonatomic, copy) ZWBLEScannerCallback managerDidTimeout;

@property(nonatomic, copy) ZWBLEScannerDidDiscoverCallback managerPreparePeripheral;// 在调用managerDidDiscoverPeripheral前调用，非UI线程
@property(nonatomic, copy) ZWBLEScannerDidDiscoverCallback managerDidDiscoverPeripheral;

@end



@interface ZWScannerPeripheral : NSObject

@property(nonatomic, retain) CBPeripheral *peripheral;
@property(nonatomic, retain) NSDictionary *advertisementData;
@property(nonatomic, retain) NSNumber     *RSSI;

@end

