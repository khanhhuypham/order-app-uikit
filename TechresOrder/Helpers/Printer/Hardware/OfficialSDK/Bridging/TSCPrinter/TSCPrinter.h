//
//  TSCPrinter.h
//  TechresOrder
//
//  Created by Pham Khanh Huy on 15/06/2024.
//


#import <Foundation/Foundation.h>
//#import "TSCPrinterSDK.h"
#import "CustomPOSPrinter.h"

@class Printer;

@interface TSCPrinter:NSObject <TSCBLEManagerDelegate, TSCWIFIManagerDelegate,NSCopying>

// Declaring the sharedInstance method which
// returns a MyClass instance
+ (TSCPrinter *)shared;


@property (nonatomic, readwrite) NSMutableArray* ids;

@property (nonatomic, readwrite) BOOL isPrintLive; //is app printing live or under background

@property (nonatomic, assign) PRINT_MODE_ printMode;

// connect type
@property (assign, nonatomic) ConnectType connectType;

// bluetooth manager
@property (strong, nonatomic) TSCBLEManager *bleManager;

// wifi manager
@property (strong, nonatomic) TSCWIFIManager *wifiManager;

@property (strong, nonatomic) Printer *printer;

-(instancetype)init;

-(void)wifiConnect:(Printer*)printer Id:(NSDictionary*)Id;

-(void)wifiDisconnect;

-(void)printWithData:(NSMutableData *)printData ids:(NSDictionary*)ids;

-(void)printPicture:(UIImage *)image ids:(NSDictionary*)ids;

- (void)printPictures:(NSArray<UIImage *> *)images withInfo:(NSDictionary *)info;

-(void)sendNotifiErr:(NSError *)error printer:(Printer*)printer;

-(void)checkConnection:(Printer*)printer;

@end


