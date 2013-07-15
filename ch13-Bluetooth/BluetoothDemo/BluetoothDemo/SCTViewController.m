//
//  SCTViewController.m
//  BluetoothDemo
//
//  Created by Mugunth on 14/7/13.
//  Copyright (c) 2013 Steinlogic Consulting and Training Pte Ltd. All rights reserved.
//

#import "SCTViewController.h"

@import CoreBluetooth;

@interface SCTViewController () <CBCentralManagerDelegate, CBPeripheralDelegate>
@property (strong, nonatomic) CBCentralManager *centralManager;
@property (strong, nonatomic) NSMutableArray *peripherals;
@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (nonatomic, weak) IBOutlet UILabel *temperatureLabel;
@end

@implementation SCTViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.temperatureLabel.text = @"";
  self.peripherals = [NSMutableArray array];
  self.centralManager = [[CBCentralManager alloc] initWithDelegate:self
                                                             queue:nil
                                                           options:nil];
  
  // You should always scan for the exact peripheral that you are interested in.
  // Scanning by passing nil as the first parameter is going to be slow and return all peripherals around you.
  // However, the hardware must also send the peripheral identifer in the advertisement packet.
  // Since the TI sensor tag doesn't send it, we are forced to scan for all peripherals and use other hacks to find out which one is really the sensor tag.

  if(self.centralManager.state == CBCentralManagerStatePoweredOff) {
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Bluetooth Turned Off", @"")
                                message:NSLocalizedString(@"Turn on bluetooth and try again", @"")
                               delegate:self
                      cancelButtonTitle:NSLocalizedString(@"Dismiss", @"")
                      otherButtonTitles: nil] show];
    
  } else if(self.centralManager.state == CBCentralManagerStateUnsupported) {
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Bluetooth LE not available on this device", @"")
                                message:NSLocalizedString(@"This is not a iPhone 4S+ device", @"")
                               delegate:self
                      cancelButtonTitle:NSLocalizedString(@"Dismiss", @"")
                      otherButtonTitles: nil] show];
    
  } else if(self.centralManager.state == CBCentralManagerStatePoweredOn) {
    
    [self.centralManager scanForPeripheralsWithServices:nil
                                                options:nil];
  }
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
  
  if(central.state == CBCentralManagerStatePoweredOn) {

    [self.centralManager scanForPeripheralsWithServices:nil
                                                options:nil];
  } else if(self.centralManager.state == CBCentralManagerStatePoweredOff) {
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Bluetooth Turned Off", @"")
                                message:NSLocalizedString(@"Turn on bluetooth and try again", @"")
                               delegate:self
                      cancelButtonTitle:NSLocalizedString(@"Dismiss", @"")
                      otherButtonTitles: nil] show];
    
  } else if(self.centralManager.state == CBCentralManagerStateUnsupported) {
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Bluetooth LE not available on this device", @"")
                                message:NSLocalizedString(@"This is not a iPhone 4S+ device", @"")
                               delegate:self
                      cancelButtonTitle:NSLocalizedString(@"Dismiss", @"")
                      otherButtonTitles: nil] show];
    
  }
}


- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI {
  
  // optionally stop scanning for more peripherals
  // [self.centralManager stopScan];
  if(![self.peripherals containsObject:peripheral]) {
    
    self.statusLabel.text = NSLocalizedString(@"Connecting to Peripheral", @"");
    peripheral.delegate = self;
    [self.peripherals addObject:peripheral];
    [self.centralManager connectPeripheral:peripheral options:nil];
  }
}

-(void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
  
  self.statusLabel.text = NSLocalizedString(@"Discovering services…", @"");
  [peripheral discoverServices:nil];
}

-(void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
  
  self.statusLabel.text = NSLocalizedString(@"Discovering characteristics…", @"");
  
  __block BOOL found = NO;
  [peripheral.services enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    CBService *service = obj;
    
    if([service.UUID isEqual:[CBUUID UUIDWithString:@"F000AA00-0451-4000-B000-000000000000"]]) {
      [peripheral discoverCharacteristics:nil forService:service];
      found = YES;
    }
  }];
  
  if(!found)
    self.statusLabel.text = NSLocalizedString(@"This is not a Sensor Tag", @"");
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
  
  self.statusLabel.text = NSLocalizedString(@"Reading temperature…", @"");

  [service.characteristics enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    
    CBCharacteristic *ch = obj;
    if([ch.UUID isEqual:[CBUUID UUIDWithString:@"F000AA02-0451-4000-B000-000000000000"]]) {
      uint8_t data = 0x01;
      [peripheral writeValue:[NSData dataWithBytes:&data length:1]
           forCharacteristic:ch
                        type:CBCharacteristicWriteWithResponse];
    }
    
    if([ch.UUID isEqual:[CBUUID UUIDWithString:@"F000AA01-0451-4000-B000-000000000000"]]) {

      [peripheral setNotifyValue:YES forCharacteristic:ch];
    }
  }];
}

-(float) temperatureFromData:(NSData *)data {
  
  char scratchVal[data.length];
  int16_t ambTemp;
  [data getBytes:&scratchVal length:data.length];
  ambTemp = ((scratchVal[2] & 0xff)| ((scratchVal[3] << 8) & 0xff00));
  
  return (float)((float)ambTemp / (float)128);
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
  
  float temp = [self temperatureFromData:characteristic.value];
  self.statusLabel.text = NSLocalizedString(@"Room temperature", @"");
  self.temperatureLabel.text = [NSString stringWithFormat:@"%.1f°C", temp];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
