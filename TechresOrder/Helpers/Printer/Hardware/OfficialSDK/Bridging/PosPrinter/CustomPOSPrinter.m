//
//  CustomPOSPrinter.m
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 19/06/2024.
//

#import "POSPrinterSDK.h"
#import "CodePagePopView.h"
#import "PTable.h"
#import "CustomPOSPrinter.h"
#import "TECHRES_ORDER-Swift.h"
#define Language @"Language"
#define Cancel @"Cancel"
#define Simplified @"Simplified"
#define Traditional @"Traditional"
#define Korea @"Korea"
#define Japanese @"Japanese"
#define Codepage @"Codepage"



@implementation CustomPOSPrinter

// Declaring the static variable which will hold
// the shared instance of MyClass
static CustomPOSPrinter *shared = nil;

// Implementing the shared method
+ (CustomPOSPrinter *)shared{
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
    
    
    _ids = [[NSMutableArray alloc] init];
    
    _isPrintLive = YES;
    _wifiManager = [POSWIFIManager sharedInstance];
    _wifiManager.delegate = self;
    return self;
}


-(void)sendNotifiErr:(NSError *)error printer:(Printer*)printer{
   
    NSMutableDictionary *dictionary =  [[NSMutableDictionary alloc] init];
   
    // Set value for key i.e adding an entry
    NSMutableDictionary *identifier = [_ids lastObject];
    for (id obj in self.ids) {
        NSLog(@"remove element: %@", obj);
    }
    [_ids removeLastObject];
        
    [dictionary setValue:[identifier valueForKey:@"id"] forKey:@"id"];
    [dictionary setValue:error forKey:@"error"];
    [dictionary setValue:@(_printMode) forKey:PRINTER_NOTIFI.PRINT_MODE];
    [dictionary setValue:[NSNumber numberWithInteger:PRINTER_METHODPOSPrinter] forKey:PRINTER_NOTIFI.PRINTER_METHOD_KEY];
    [dictionary setValue:_printer forKey:@"printer"];
    

    if (_printMode == PRINT_FOREGROUND){
        [[NSNotificationCenter defaultCenter] postNotificationName:PRINTER_NOTIFI.CONNECT_FAIL object:dictionary];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:PRINTER_NOTIFI.BACKGROUND_CONNECT_FAIL object:dictionary];
    }
    
    [self wifiDisconnect];

}

 
-(void)wifiConnect:(Printer*)printer queuedItem:(NSDictionary*)queuedItem{
    
    _printer = printer;
    [_ids insertObject:queuedItem atIndex:0];
    NSLog(@"%@ - %@: %@ (%@)", printer.name,printer.printer_ip_address,@"wifi connect", _isPrintLive == YES ? @"print live" : @"print background");
    for (id obj in self.ids) {
        NSLog(@"add element: %@", obj);
    }
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
        
    }else if((_printer.connection_type != CONNECTION_TYPEWifi) && (_printer.connection_type != CONNECTION_TYPEBlueTooth)){
        
        sendError(@"Thiết bị đang sử dụng chỉ hỗ trợ đối với máy in rời");
        return;
        
    } else{
        
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
      
        case WIFI:
            [_wifiManager disconnect];
            break;
            
        default:
            break;
    }
}

-(void)printWithData:(NSData *)printData printedItems:(NSDictionary*)printedItems{
    
    [_ids insertObject:printedItems atIndex:0];
    
    NSLog(@"pos insertObject %ld",printedItems.count);
    
    switch (self.connectType) {
            
        case NONE:
            break;
            
        case WIFI:
            
            [_wifiManager writeCommandWithData:printData];
            break;
            
        default:
            break;
    }
    
}



-(void)printPicture:(UIImage *)image printedItems:(NSDictionary*)printedItems{
    NSMutableData *dataM = [NSMutableData dataWithData:[POSCommand initializePrinter]];
    [dataM appendData:[POSCommand selectAlignment:1]];
    [dataM appendData:[POSCommand printRasteBmpWithM:RasterNolmorWH andImage:image andType:Dithering]];
 
    if ([printedItems count] > 0){
        [dataM appendData:[POSCommand printAndFeedForwardWhitN:5]];
        [dataM appendData:[POSCommand selectCutPageModelAndCutpage:0]];
    }
    
    [self printWithData:dataM printedItems:printedItems];
}



#pragma mark - CodePageViewDelegate
- (void)codepageView:(nonnull CodePagePopView *)codepagePopView selectValue:(nonnull NSString *)selectValue {

}

#pragma mark - POSWIFIManagerDelegate
//connected success
- (void)POSwifiConnectedToHost:(NSString *)host port:(UInt16)port{
    
    NSMutableDictionary *dictionary =  [[NSMutableDictionary alloc] init];
   
    NSMutableDictionary *identifier = [_ids lastObject];
    
    [_ids removeAllObjects];
    
    [dictionary setValue:[identifier valueForKey:@"id"] forKey:@"id"];
    [dictionary setValue:_printer forKey:@"printer"];
    [dictionary setValue:@(_printMode) forKey:PRINTER_NOTIFI.PRINT_MODE];
    [dictionary setValue:[NSNumber numberWithInteger:PRINTER_METHODPOSPrinter] forKey:PRINTER_NOTIFI.PRINTER_METHOD_KEY];
    

    if (_printMode == PRINT_FOREGROUND){
        [[NSNotificationCenter defaultCenter] postNotificationName:PRINTER_NOTIFI.CONNECT_SUCCESS object:dictionary];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:PRINTER_NOTIFI.BACKGROUND_CONNECT_SUCCESS object:dictionary];
    }
 
}
/**
 * disconnect error
 */
- (void)POSwifiDisconnectWithError:(NSError *)error{
    /*
        code 51: Network is unreachable && Error in connect() function
        code 3: Attempt to connect to host timed out
     */
    if (error) {
        [self sendNotifiErr:error printer:_printer];
        
    }

}


/**
 * send data success
 * when our device send data successfully to printer the function below return  tag === 1000
 * when our device check status of  printer the function below return  tag === 1001
 */
- (void)POSwifiWriteValueWithTag:(long)tag{

    NSLog(@"pos success %ld",tag);
    
    if (tag == 1000){
        
        NSMutableDictionary *dictionary =  [[NSMutableDictionary alloc] init];
        
        NSMutableArray *printedItem = [_ids lastObject];
        
        NSLog(@"pos insertObject %@",_ids);
        
        [_ids removeLastObject];
        

        if (printedItem.count > 0) {
            [dictionary setValue:[printedItem valueForKey:@"id"] forKey:@"id"];
            [dictionary setValue:@(_printMode) forKey:PRINTER_NOTIFI.PRINT_MODE];
            [dictionary setValue:[NSNumber numberWithInteger:PRINTER_METHODPOSPrinter] forKey:PRINTER_NOTIFI.PRINTER_METHOD_KEY];
            [dictionary setValue:[printedItem valueForKey:@"isLastItem"] forKey:@"isLastItem"];
        }
        

        if (_printMode == PRINT_FOREGROUND){
            [[NSNotificationCenter defaultCenter] postNotificationName:PRINTER_NOTIFI.PRINT_SUCCESS object:dictionary];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:PRINTER_NOTIFI.BACKGROUND_PRINT_SUCCESS object:dictionary];
        }
        

    }else if (tag == 1001){
        
    }else{
        NSLog(@"Phạm Khánh huy pos print fail because we send incorrect format of data");
    }
    
}



/**
 * receive printer data
 */
- (void)POSwifiReceiveValueForData:(NSData *)data{
    NSLog(@"receive data");
    __weak typeof(self) weakSelf = self;
    [weakSelf getStatusWithData:data];
    NSLog(@"Phạm Khánh huy pos error");
}


// check status
- (void)checkPOSPrinterStatus{
    __weak typeof(self) weakSelf = self;
    
    if ([_wifiManager printerIsConnect]) {
      
        [_wifiManager printerStatus:^(NSData *status) {
            [weakSelf getStatusWithData:status];
        }];
        
    }else{
        NSLog(@"Pham khanh huy: data is returned from printer");
    }

}







- (void)getStatusWithData:(NSData *)responseData {
    
    if (responseData.length == 0) return;
    
    if (responseData.length == 1) {
        const Byte *byte = (Byte *)[responseData bytes];
        unsigned status = byte[0];
        
        NSMutableDictionary *dictionary =  [[NSMutableDictionary alloc] init];
    
        if (status == 0x12) {
            NSLog(@"print success");
            return;
        } else if (status == 0x16) {
      
            NSError *err = [NSError
                            errorWithDomain:@"pham khanh huy"
                            code:0
                            userInfo:@{NSLocalizedDescriptionKey:@"Nắp máy in đang mở"}
            ];
            
            [dictionary setValue:err forKey:@"error"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:_isPrintLive ? PRINTER_NOTIFI.PRINT_FAIL : PRINTER_NOTIFI.BACKGROUND_PRINT_FAIL object:dictionary];
        } else if (status == 0x32) {
           
            NSError *err = [NSError
                            errorWithDomain:@"Pham khanh huy"
                            code:0
                            userInfo:@{NSLocalizedDescriptionKey:@"Máy in hết giấy"}
            ];
            
            [dictionary setValue:err forKey:@"error"];
            [[NSNotificationCenter defaultCenter] postNotificationName:_isPrintLive ? PRINTER_NOTIFI.PRINT_FAIL : PRINTER_NOTIFI.BACKGROUND_PRINT_FAIL object:dictionary];
        } else if (status == 0x36) {
            
            NSError *err = [NSError
                            errorWithDomain:@"Pham khanh huy"
                            code:100
                            userInfo:@{NSLocalizedDescriptionKey:@"Nắp máy in đang mở &dx"}
            ];
            
            [dictionary setValue:err forKey:@"error"];
            [[NSNotificationCenter defaultCenter] postNotificationName:_isPrintLive ? PRINTER_NOTIFI.PRINT_FAIL : PRINTER_NOTIFI.BACKGROUND_PRINT_FAIL object:dictionary];
        } else {
           
            NSError *err = [NSError
                            errorWithDomain:@"some_domain"
                            code:100
                            userInfo:@{NSLocalizedDescriptionKey:@"unknown error"}
            ];
            
            [dictionary setValue:err forKey:@"error"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:_isPrintLive ? PRINTER_NOTIFI.PRINT_FAIL : PRINTER_NOTIFI.BACKGROUND_PRINT_FAIL object:dictionary];
            
        }
    }
}


#pragma mark - Test Print

@end
