//
//  TSCPrinter.m
//  TechresOrder
//
//  Created by Pham Khanh Huy on 15/06/2024.
//

#import <Foundation/Foundation.h>
#import "TECHRES_ORDER-Swift.h"
#import "TSCPrinterSDK.h"
#import "TSCPrinter.h"
#import "POSPrinter.h"

@implementation TSCPrinter

// Declaring the static variable which will hold
// the shared instance of MyClass
static TSCPrinter *shared = nil;

// Implementing the shared method
+ (TSCPrinter *)shared{
    // Checking if shared is nil (i.e.
    // the shared instance hasn't been created yet)
    if (shared == nil){
        // Creating a new instance of MyClass using
        // the superclass's allocWithZone method
        shared = [[super allocWithZone:NULL] init];
    }

    // Returning the shared instance
    return shared;
}

// Overriding the allocWithZone method to always
// return the shared instance
+ (id)allocWithZone:(NSZone *)zone{
    return [self shared];
}
 
// Overriding the copyWithZone method to always
// return the same instance (since this is a singleton)
- (id)copyWithZone:(NSZone *)zone{
    return self;
}
 
// Implementing the init method to initialize any
// instance variables (if needed)
- (id)init{
    self = [super init];
    if (self != nil){
        // Initialize instance variables here
    }

    _ids = [[NSMutableArray alloc] init];;
    _isPrintLive = YES;
//    _printer = [Printer new];
    
    _bleManager = [TSCBLEManager sharedInstance];
    _bleManager.delegate = self;
    
    _wifiManager = [TSCWIFIManager sharedInstance];
    _wifiManager.delegate = self;
    
    self.connectType = WIFI;
    
    return self;
}


-(void)sendNotifiErr:(NSError *)error printer:(Printer*)printer{

    NSMutableDictionary *dictionary =  [[NSMutableDictionary alloc] init];
   
    // Set value for key i.e adding an entry
    
    NSMutableDictionary *identifier = [_ids lastObject];
    [_ids removeAllObjects];
    
    [dictionary setValue:[identifier valueForKey:@"id"] forKey:@"id"];
    [dictionary setValue:error forKey:@"error"];
    [dictionary setValue:@(_printMode) forKey:PRINTER_NOTIFI.PRINT_MODE];
    [dictionary setValue:[NSNumber numberWithInteger:PRINTER_METHODTSCPrinter] forKey:PRINTER_NOTIFI.PRINTER_METHOD_KEY];
    [dictionary setValue:_printer forKey:@"printer"];

//    for (id obj in identifier) {
//        NSLog(@"remove element: %@", obj);
//    }
    
    if (_printMode == PRINT_FOREGROUND){
        [[NSNotificationCenter defaultCenter] postNotificationName:PRINTER_NOTIFI.CONNECT_FAIL object:dictionary];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:PRINTER_NOTIFI.BACKGROUND_CONNECT_FAIL object:dictionary];
    }
    

    [self wifiDisconnect];
    
}


-(void)wifiConnect:(Printer*)printer Id:(NSDictionary*)Id{
    _printer = printer;
    [_ids insertObject:Id atIndex:0];
   
    NSLog(@"%@ - %@: %@ (%@)", printer.name,printer.printer_ip_address,@"wifi connect", _isPrintLive == YES ? @"print live" : @"print background");
//    for (id obj in self.ids) {
//        NSLog(@"add element: %@", obj);
//    }
    // Helper block for creating and sending error
    void (^sendError)(NSString*) = ^(NSString *msg) {
        NSError *err = [NSError
            errorWithDomain:[NSString stringWithFormat:@"%d", kCFStreamErrorDomainNetDB]
            code:8
            userInfo:@{ NSLocalizedDescriptionKey : [NSString stringWithFormat:@"%@: %@", printer.name, msg]}
        ];
        [self sendNotifiErr:err printer:_printer];
    };
    
    if ([_printer.printer_port length] == 0) {
        
        sendError(@"port is invalid");
        return;
        
    }else if ([_printer.printer_ip_address length] == 0){
        
        sendError(@"ip address is invalid");
        return;
        
    }else if ([_printer.printer_ip_address length] == 0 && [_printer.printer_port length] == 0){
        
        sendError(@"ip address and port are invalid");
        return;
        
    }else if(_printer.connection_type != CONNECTION_TYPEWifi){
        
        sendError(@"Thiết bị đang sử dụng chỉ hỗ trợ đối với máy in rời");
        return;
        
    }else{
    
        if (_wifiManager.isConnect) {
            [_wifiManager disconnect];
        }
        
        NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
        UInt16 portNumber = [[formatter numberFromString:_printer.printer_port] unsignedShortValue];
        
        [_wifiManager connectWithHost:_printer.printer_ip_address port:portNumber];
    }
}

- (void)wifiDisconnect{
    _printer = nil;
    switch (self.connectType) {
        case BT:
            [_bleManager disconnectRootPeripheral];
            break;
            
        case WIFI:
            [_wifiManager disconnect];
            break;
            
        default:
            break;
    }
}




-(void)printWithData:(NSMutableData *)printData ids:(NSDictionary*)ids{

    switch (self.connectType) {
        case NONE:
            break;
            
        case WIFI:
            [_wifiManager writeCommandWithData:printData];
            
            break;
            
        case BT:
            [_bleManager writeCommandWithData:printData writeCallBack:^(CBCharacteristic *characteristic, NSError *error) {
                if(!error) {
                    NSLog(@"send success");
                } else {
                    NSLog(@"error:%@",error);
                }
            }];
            break;
            
        default:
            break;
    }
    
}


-(void)printPicture:(UIImage *)image ids:(NSDictionary*)ids{
    [_ids insertObject:ids atIndex:0];
    NSMutableData *dataM = [[NSMutableData alloc] init];
    
    [dataM appendData:[TSCCommand cls]];
    [dataM appendData:[TSCCommand initialPrinter]];
    
    if (_printer.printer_paper_size == 60) {
        [dataM appendData:[TSCCommand sizeBymmWithWidth:60 andHeight:40]];
    }else if (_printer.printer_paper_size == 50) {
        [dataM appendData:[TSCCommand sizeBymmWithWidth:48 andHeight:30]];
    } else if (_printer.printer_paper_size == 40){
        [dataM appendData:[TSCCommand sizeBymmWithWidth:38 andHeight:30]];
    }else{
        [dataM appendData:[TSCCommand sizeBymmWithWidth:68 andHeight:20]];
    }
    
    [dataM appendData:[TSCCommand direction:_printer.direction]];
    [dataM appendData:[TSCCommand referenceWithX:0 andY:0]];
    [dataM appendData:[TSCCommand bitmapWithX:0 andY:0 andMode:0 andImage:image]];
    [dataM appendData:[TSCCommand print:1]];
    [_wifiManager writeCommandWithData:dataM];
}

- (void)printPictures:(NSArray<UIImage *> *)images withInfo:(NSDictionary *)info{
    [_ids insertObject:info atIndex:0];
    NSMutableData *dataM = [[NSMutableData alloc] init];
    
    [dataM appendData:[TSCCommand cls]];
//    [dataM appendData:[TSCCommand initialPrinter]];
    
    for (NSInteger i = 0; i < images.count; i++) {
        [dataM appendData:[TSCCommand cls]];
        UIImage *img = images[i];
          // Do something with each image
   
        if (_printer.printer_paper_size == 60) {

            [dataM appendData:[TSCCommand sizeBymmWithWidth:60 andHeight:40]];
            
        }else if (_printer.printer_paper_size == 50) {
            
            [dataM appendData:[TSCCommand sizeBymmWithWidth:48 andHeight:30]];
            
        } else if (_printer.printer_paper_size == 40){
         
            [dataM appendData:[TSCCommand sizeBymmWithWidth:38 andHeight:30]];
            
        }else{
            
            [dataM appendData:[TSCCommand sizeBymmWithWidth:68 andHeight:20]];
        }

        [dataM appendData:[TSCCommand direction:_printer.direction]];
        [dataM appendData:[TSCCommand referenceWithX:0 andY:0]];
        [dataM appendData:[TSCCommand bitmapWithX:0 andY:0 andMode:0 andImage:img]];
        [dataM appendData:[TSCCommand print:1]];
    }
    
    [_wifiManager writeCommandWithData:dataM];
}




#pragma mark - POSBLEManagerDelegate

//connect success
- (void)POSbleConnectPeripheral:(CBPeripheral *)peripheral {
  
}


// disconnect
- (void)POSbleDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
  
}

#pragma mark - POSWIFIManagerDelegate

//connected success
- (void)TSCwifiConnectedToHost:(NSString *)host port:(UInt16)port{

    NSMutableDictionary *dictionary =  [[NSMutableDictionary alloc] init];
   
    NSMutableDictionary *identifier = [_ids lastObject];
    [_ids removeAllObjects];
    [dictionary setValue:[identifier valueForKey:@"id"] forKey:@"id"];
    [dictionary setValue:_printer forKey:@"printer"];
    [dictionary setValue:@(_printMode) forKey:PRINTER_NOTIFI.PRINT_MODE];
    [dictionary setValue:[NSNumber numberWithInteger:PRINTER_METHODTSCPrinter] forKey:PRINTER_NOTIFI.PRINTER_METHOD_KEY];
    
    
    if (_printMode == PRINT_FOREGROUND){
        [[NSNotificationCenter defaultCenter] postNotificationName:PRINTER_NOTIFI.CONNECT_SUCCESS object:dictionary];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:PRINTER_NOTIFI.BACKGROUND_CONNECT_SUCCESS object:dictionary];
    }
    
 
}
/**
 * disconnect error
 */
- (void)TSCwifiDisconnectWithError:(NSError *)error;{
    
    if (_bleManager.isConnecting) {
        _connectType = BT;
    } else {
        _connectType = NONE;
    }
    
    if (error) {
        [self sendNotifiErr:error printer:_printer];
           
    }
    
}


/**
 * send data success
 * when our device send data successfully to printer the function below return  tag === 1000
 * when our device check status of  printer the function below return  tag === 1001
 * when our device print successfully, but the data sent to printer is not in correct format, then the function below return  tag === 0
 */
- (void)TSCwifiWriteValueWithTag:(long)tag{
        
    NSLog(@"tsc success %ld",tag);
    

    if (tag == 0){
        
        NSMutableDictionary *dictionary =  [[NSMutableDictionary alloc] init];
        
        NSMutableDictionary *identifier = [_ids lastObject];
        
        [_ids removeAllObjects];
        
        [dictionary setValue:[NSNumber numberWithInteger:PRINTER_METHODTSCPrinter] forKey:PRINTER_NOTIFI.PRINTER_METHOD_KEY];
        [dictionary setValue:[identifier valueForKey:@"id"] forKey:@"id"];
        [dictionary setValue:[identifier valueForKey:@"isLastItem"] forKey:@"isLastItem"];

        if (_printMode == PRINT_FOREGROUND){
            [[NSNotificationCenter defaultCenter] postNotificationName:PRINTER_NOTIFI.PRINT_SUCCESS object:dictionary];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:PRINTER_NOTIFI.BACKGROUND_PRINT_SUCCESS object:dictionary];
        }
        
    }else if (tag == 1001){
        
    }else{
        NSLog(@"Phạm Khánh huy tsc else");
    }
    
}

- (void)TSCwifiReceiveValueForData:(NSData *)data{

}

#pragma mark - Test Print


@end
