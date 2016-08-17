//
//  ESBLEScanner.m
//  esmobile
//
//  Created by luzhenwen on 15/8/27.
//  Copyright (c) 2015年 excelsecu. All rights reserved.
//

#import "ZWBLEScanner.h"

#if DEBUG 
#define TLog(...) NSLog(__VA_ARGS__)
#else
#define TLog(...)
#endif




static ZWBLEScanner *shareScanner = nil;

@interface ZWBLEScannerObserver ()

@property(assign , nonatomic) ZWBLEScanner *scanner;
@property(nonatomic, strong) dispatch_source_t source;

@end



/*!
 @class
 @version 1.0
 @author  lzw
 @abstract BLE蓝牙扫描器。为了实现能同时使用靠近连接、扫码连接和扫描连接，创建了此类。
 @discussion 使用时创建对象，然后添加扫描观察者即可。用完必须删除观察者。
 */
@interface ZWBLEScanner () <CBCentralManagerDelegate>

/*!
 @property
 @abstract 去重外设列表，对其操作必须锁住该对象
 */
@property(nonatomic, retain) NSMutableArray *peripherals;
/*!
 @property
 @abstract 去重观察者列表，对其操作必须锁住该对象
 */
@property(nonatomic, retain) NSMutableSet   *observers;
/*!
 @property
 @abstract 去重已启动扫描观察者列表，对其操作必须锁住该对象
 */
@property(nonatomic, retain) NSMutableSet   *startedObservers;
/*!
 @property
 @abstract 内部是否正在扫描
 */
@property(nonatomic, assign) BOOL            scanning;



@end

@implementation ZWBLEScanner

@synthesize peripherals;
@synthesize observers;
@synthesize startedObservers;
@synthesize zwCentralManager;

/********************  单例模式  ********************/

+(id)allocWithZone:(struct _NSZone *)zone{
    if (shareScanner==nil) {
        @synchronized(self){
            if (shareScanner==nil) {
                shareScanner=[super allocWithZone:zone];
            }
        }
    }
    
    return shareScanner;
}

-(id)copyWithZone:(NSZone *)zone{
    return self;
}


+(id)shareScanner{
    if (shareScanner==nil) {
        @synchronized(self) {// 类级锁
            if (shareScanner == nil) {// double check,防止多线程访问时重复创建对象
                shareScanner = [[ZWBLEScanner alloc] init];
            }
        }
    }
    return shareScanner;
}

/********************  单例模式结束  ********************/

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.peripherals = [NSMutableArray arrayWithCapacity:12];
        self.observers   = [NSMutableSet setWithCapacity:5];
        self.startedObservers   = [NSMutableSet setWithCapacity:5];
        self.scanning    = NO;
        zwCentralManager = [[ZWCentralManager alloc] init];
        [zwCentralManager addCentralManagerObserver:self];
    }
    return self;
}

-(oneway void)dealloc{
    [zwCentralManager removeCentralManagerObserver:self];
}


-(CBCentralManager *)centralManager{
    return zwCentralManager.centralManager;
}


-(void)addScanObserver:(ZWBLEScannerObserver *)obsr{
    if (!obsr) {
        return;
    }
    @synchronized(observers){
        
        if ([observers containsObject:obsr]) {
            return;
        }
        
        [self willAddObserver:obsr];
        
        [observers addObject:obsr];
        
        [self didAddObserver:obsr];
    }
}

-(void)removeScanObserver:(ZWBLEScannerObserver *)obsr{
    if (obsr) {
        @synchronized(observers){
            if (![observers containsObject:obsr]) {
                return;
            }
            
            [self willRemoveObserver:obsr];
            
            [observers removeObject:obsr];
            
            [self didRemoveObserver:obsr];
        }
    }
}


-(void)willAddObserver:(ZWBLEScannerObserver *)obr{
    TLog(@"~%s",__FUNCTION__);
}
-(void)didAddObserver:(ZWBLEScannerObserver *)obr{
    TLog(@"~%s",__FUNCTION__);
    
    obr.scanner = self;
    
    // 手动抛一下状态回调，因为在创建的时候已经设置驱动层回调，那时系统会弹出开启蓝牙对话框（如果蓝牙尚未开启）。
    // 所以应该蓝牙状态会在addObserver之前已经出发，因此需要手动调用
    [obr centralManagerDidUpdateState:self.centralManager];
}
-(void)willRemoveObserver:(ZWBLEScannerObserver *)obr{
    TLog(@"~%s",__FUNCTION__);
    [self stopScan:obr];// 删除之前先stop
}
-(void)didRemoveObserver:(ZWBLEScannerObserver *)obr{
    
    TLog(@"~%s",__FUNCTION__);
    
    obr.scanner = nil;
}

-(void)nativeStartScan{
    if (self.scanning) {
        return;
    }
    if (self.centralManager.state == CBCentralManagerStatePoweredOff) {
        [self centralManagerDidUpdateState:self.centralManager];
        return;
    }
    self.scanning = YES;
    [self managerDidStartDiscover:self.centralManager];
    TLog(@"- %@->%@", NSStringFromClass([self class]) ,@"启动驱动扫描");
    [self.centralManager scanForPeripheralsWithServices:nil options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBCentralManagerScanOptionAllowDuplicatesKey]];

}

-(void)nativeStopScan{
    if (!self.scanning) {
        return;
    }
    self.scanning = NO;
    TLog(@"- %@->%@", NSStringFromClass([self class]) ,@"关闭驱动扫描");
    [self.centralManager stopScan];
    
    [self managerDidEndDiscover:self.centralManager];
}


-(void)startScan:(ZWBLEScannerObserver *)obr{
    
    @synchronized(observers){
        // 没add的Observer不能start
        if (![observers containsObject:obr]) {
            return;
        }
        @synchronized(startedObservers) {
            if ([startedObservers containsObject:obr]) {
                return;// 已启动
            }
            
            [startedObservers addObject:obr];
            
            if (self.scanning) { // 如果进来的时候已经开始了，就手动抛一下回调
                [obr centralManagerDidStartDiscover:self.centralManager];
            }
            
            // 此前必须锁住startedObservers
            @synchronized(peripherals){
                // 将已经扫到的设备抛给新来的观察者
                for (ZWScannerPeripheral *p in peripherals) {
                    [obr didDiscoverPeripheral:p.peripheral advertisementData:p.advertisementData RSSI:p.RSSI];
                }
            }
            
            if (startedObservers.count == 1) {
                // 第一个监听器，应该去启动扫描
                [self nativeStartScan];
            }
        }
    }
}

-(void)stopScan:(ZWBLEScannerObserver *)obr{
    @synchronized(observers) {
        if (![observers containsObject:obr]) {
            return;
        }
        
        @synchronized(startedObservers) {
            if (![startedObservers containsObject:obr]) {
                return;// 还没开始，无需stop
            }
            
            if (self.scanning) {
                // 如果还在扫，而观察者被停止了，就单独调用停止通知
                // 否则无需回调，因为尚未scanning，则表示还没调用start scan
                [obr centralManagerDidEndDiscover:self.centralManager];
                
                [startedObservers removeObject:obr];
                
                if (startedObservers.count < 1) {
                    // 清空了，应该停止扫描
                    TLog(@"- %@->%@", NSStringFromClass([self class]) ,@"关闭驱动扫描");
                    [self nativeStopScan];
                }
            }
        }
    }
}


#pragma mark CBCentralManager delegate methods

- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    TLog(@"~%s",__FUNCTION__);
    
    @synchronized(observers){
        for (ZWBLEScannerObserver *b in observers) {
            [b centralManagerDidUpdateState:central];
        }
    }
    
    if ([central state] == CBCentralManagerStatePoweredOn) {
        @synchronized(startedObservers) {
            if (startedObservers.count > 0) {
                // 开了蓝牙，启动扫描！
                [self nativeStartScan];
            }
        }
    }else if ([central state] == CBCentralManagerStatePoweredOff){
        [self nativeStopScan];
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI{
    
    BOOL duplicate = NO;
    
    @synchronized(startedObservers){
        
        @synchronized(peripherals){
            TLog(@"native found %@", [peripheral name]);
            
            ZWScannerPeripheral *sp = [[ZWScannerPeripheral alloc] init];
            sp.peripheral = peripheral;
            sp.advertisementData = advertisementData;
            sp.RSSI = RSSI;
            
            NSUInteger index = [peripherals indexOfObject:sp];
            if (index == NSNotFound) {
                [peripherals addObject:sp];
            }else{
                duplicate = YES;// 已经扫到过了
                [peripherals replaceObjectAtIndex:index withObject:sp];
            }
        }
        
        for (ZWBLEScannerObserver *b in startedObservers) {
            if (b.allowDuplicatePeripheral) {// 观察者接受重复的外设，把所有拿到的外设都通知外面
                [b didDiscoverPeripheral:peripheral advertisementData:advertisementData RSSI:RSSI];
            }else if (!duplicate){// 观察者不接受重复的设备，仅在第一次扫到的时候通知。
                [b didDiscoverPeripheral:peripheral advertisementData:advertisementData RSSI:RSSI];
            }
        }
    }
}

- (void)managerDidStartDiscover:(CBCentralManager *)mgr{
    self.scanning = YES;
    TLog(@"~%s",__FUNCTION__);
    @synchronized(peripherals){
        [peripherals removeAllObjects];
    }
    
    // 扫描器开始扫描，不管什么情况，都要通知观察者
    @synchronized(startedObservers){
        for (ZWBLEScannerObserver *b in startedObservers) {
            [b centralManagerDidStartDiscover:mgr];
        }
    }
}

- (void)managerDidEndDiscover:(CBCentralManager *)mgr{
    self.scanning = NO;
    TLog(@"~%s",__FUNCTION__);
    @synchronized(peripherals){
        [peripherals removeAllObjects];
    }
    
    // 扫描器停止扫描，不管什么情况，都要通知观察者
    @synchronized(startedObservers){
        for (ZWBLEScannerObserver *b in startedObservers) {
            [b centralManagerDidEndDiscover:mgr];
        }
        
        [startedObservers removeAllObjects];// 所有都停止了，停止后只能重新start
    }
}

-(void)clear{
    @synchronized(startedObservers){
        if (self.scanning) {
            for (ZWBLEScannerObserver *b in startedObservers) {
                [b centralManagerDidEndDiscover:self.centralManager];
            }
        }
        
        [startedObservers removeAllObjects];
        
        [self nativeStopScan];
    }
    
    @synchronized(observers) {
        [observers removeAllObjects];
    }
}

@end





@implementation ZWBLEScannerObserver

@synthesize timeout;
@synthesize outsideDelegate;
@synthesize dispatchToMainQueue;
@synthesize userData;

@synthesize allowDuplicatePeripheral;

@synthesize managerDidUpdateState;
@synthesize managerDidStartDiscover;
@synthesize managerDidEndDiscover;
@synthesize managerPreparePeripheral;
@synthesize managerDidDiscoverPeripheral;
@synthesize managerDidTimeout;

@synthesize source;



- (instancetype)init
{
    self = [super init];
    if (self) {
        self.timeout = 10; //默认是10秒
        self.dispatchToMainQueue = NO;//默认抛到当前线程
        self.allowDuplicatePeripheral = NO;//默认不接收重复设备
        self.source = NULL;
    }
    return self;
}



- (void)dealloc
{
    
    [self clearTimer];
    
}



-(void)clearTimer{
    if (self.source) {
        dispatch_source_cancel(self.source);
        
        self.source = NULL;
    }
}

-(void)startTimer{
    [self clearTimer];
    
    self.source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    
    dispatch_time_t delay = self.timeout * NSEC_PER_SEC;
    dispatch_source_set_timer(self.source, dispatch_time(DISPATCH_TIME_NOW, delay), delay, 0);
    
    __unsafe_unretained ZWBLEScannerObserver *myself = self;
    
    dispatch_source_set_event_handler(self.source, ^{
        [myself clearTimer];
        [myself scanDidTimeout:nil];
    });
    
    dispatch_resume(self.source);
    
    TLog(@"~%s",__FUNCTION__);
}

-(void)scanDidTimeout:(id)object{
    
    void (^invoker)(void) = ^{
        if (self.outsideDelegate && [self.outsideDelegate respondsToSelector:@selector(centralManagerDidTimeout:)]) {
            [self.outsideDelegate centralManagerDidTimeout:[[ZWBLEScanner shareScanner] centralManager]];
        }
        
        if (managerDidTimeout) {
            managerDidTimeout(self,[[ZWBLEScanner shareScanner] centralManager]);
        }
    };
    
    if (self.dispatchToMainQueue) {
        dispatch_async(dispatch_get_main_queue(), invoker);
    }else{
        invoker();
    }
    // 超时，从扫描器中删除。
    [self.scanner stopScan:self];
    TLog(@"~%s",__FUNCTION__);
}


#pragma mark ESBLEDeviceManager delegate methods
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
    TLog(@"~%s",__FUNCTION__);
    
    void (^invoker)(void) = ^{
        if (self.outsideDelegate && [self.outsideDelegate respondsToSelector:@selector(centralManagerDidUpdateState:)]) {
            [self.outsideDelegate centralManagerDidUpdateState:central];
        }
        
        if (managerDidUpdateState) {
            managerDidUpdateState(self,central);
        }
    };
    
    if (self.dispatchToMainQueue) {
        dispatch_async(dispatch_get_main_queue(), invoker);
    }else{
        invoker();
    }
}

- (void)centralManagerDidStartDiscover:(CBCentralManager *)mgr{
    
    TLog(@"~%s",__FUNCTION__);
    
    void (^invoker)(void) = ^{
        if (self.outsideDelegate && [self.outsideDelegate respondsToSelector:@selector(centralManagerDidStartDiscover:)]) {
            [self.outsideDelegate centralManagerDidStartDiscover:mgr];
        }
        
        if (managerDidStartDiscover) {
            managerDidStartDiscover(self,mgr);
        }
    };
    
    if (self.dispatchToMainQueue) {
        dispatch_async(dispatch_get_main_queue(), invoker);
    }else{
        invoker();
    }
    
    // 启动定时器
    [self startTimer];
}

- (void)centralManagerDidEndDiscover:(CBCentralManager *)  mgr{
    
    TLog(@"~%s",__FUNCTION__);
    
    
    // 清空定时器
    [self clearTimer];
    
    void (^invoker)(void) = ^{
        if (self.outsideDelegate && [self.outsideDelegate respondsToSelector:@selector(centralManagerDidEndDiscover:)]) {
            [self.outsideDelegate centralManagerDidEndDiscover:mgr];
        }
        
        if (managerDidEndDiscover) {
            managerDidEndDiscover(self,mgr);
        }
    };
    
    if (self.dispatchToMainQueue) {
        dispatch_async(dispatch_get_main_queue(), invoker);
    }else{
        invoker();
    }
}
- (void) didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *) advertisementData RSSI:(NSNumber *)RSSI{
    
    if (managerPreparePeripheral) {
        managerPreparePeripheral(self,peripheral,advertisementData,RSSI);
    }
    
    void (^invoker)(void) = ^{
        if (self.outsideDelegate && [self.outsideDelegate respondsToSelector:@selector(didDiscoverPeripheral:advertisementData:RSSI:)]) {
            [self.outsideDelegate didDiscoverPeripheral:peripheral advertisementData:advertisementData RSSI:RSSI];
        }
        
        if (managerDidDiscoverPeripheral) {
            managerDidDiscoverPeripheral(self,peripheral,advertisementData,RSSI);
        }
    };
    
    if (self.dispatchToMainQueue) {
        dispatch_async(dispatch_get_main_queue(), invoker);
    }else{
        invoker();
    }
}

@end







@implementation ZWScannerPeripheral

@synthesize peripheral;
@synthesize advertisementData;
@synthesize RSSI;

-(BOOL)isEqual:(id)object{
    if (object == self) {
        return YES;
    } else if ([object isKindOfClass:[self class]]) {
        return [self.peripheral isEqual:((ZWScannerPeripheral *)object).peripheral];
    }
    return NO;
}

- (NSUInteger)hash
{
    return [self.peripheral hash];
}

@end

