//
//  WeatherZoneAppDelegate.m
//  WeatherZone
//
//  Created by Steve Baker on 11/19/09.
//  Copyright 2009 Beepscore LLC. All rights reserved.
//

#import "WeatherZoneAppDelegate.h"
#import "BSGlobalValues.h"

@implementation WeatherZoneAppDelegate

@synthesize window;
@synthesize idCode;

// designatedInitializer
- (id)init {
    
    self = [super init];
    if (self) {
        [self setIdCode:@"KSEA"];
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
}

- (NSString *)URLStringForWeatherUndergroundConditions {
    self.idCode = @"KBFI";
    return [NSString
            stringWithFormat:@"http://api.wunderground.com/auto/wui/geo/WXCurrentObXML/index.xml?query=%@",
            self.idCode];
}

- (NSURL *)URLForWeatherUndergroundConditions {
    return [NSURL URLWithString:self.URLStringForWeatherUndergroundConditions];
}


- (IBAction)fetchObservations:(id)sender {
    
    // Show the user that something is going on
    [progress startAnimation:nil];
    
    // Put together the request
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[self URLForWeatherUndergroundConditions]
                                                cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                            timeoutInterval:30];
    // Fetch the XML response    
    NSData *urlData;
    NSURLResponse *response;
    NSError *error;
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest
                                    returningResponse:&response
                                                error:&error];
    if (!urlData) {
        NSAlert *alert = [NSAlert alertWithError:error];
        [alert runModal];
        return;
    }
    
    // Parse the XML response
    [doc release];
    doc = [[NSXMLDocument alloc] initWithData:urlData 
                                      options:0 
                                        error:&error];
    
    DLog(@"doc = %@", doc);
    if (!doc) {
        NSAlert *alert = [NSAlert alertWithError:error];
        [alert runModal];
        return;
    }
    
    [itemNodes release];
    itemNodes = [[doc nodesForXPath:@"current_observations"
                              error:&error] retain];
    if(!itemNodes) {
        NSAlert *alert = [NSAlert alertWithError:error];
        [alert runModal];
        return;
    }
    
    // Update the interface
    [tableView reloadData];
    [progress stopAnimation:nil];                           
}

-(int)numberOfRowsInTableView:(NSTableView *)tv {
    
    return 0;
}

@end
