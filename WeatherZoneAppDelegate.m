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

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
}

- (IBAction)fetchBooks:(id)sender {
    
    // Show the user that something is going on
    [progress startAnimation:nil];
    
    // Put together the request
    // See http://www.amazon.com/gp/aws/landing.html
    
    // Get the string and percent-escape for insertion into URL
    NSString *input = [searchField stringValue];
    NSString *searchString = 
     [input stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    DLog(@"searchString = %@", searchString);
    
    // Create the URL (Long string broken into several lines is OK)
    NSString *urlString = [NSString stringWithFormat:
                           @"http://ecs.amazonaws.com/onca/xml?"
                           @"Service=AWSECommerceService&"
                           @"AWSAccessKeyID=%@&"
                           @"Operation=ItemSearch&"
                           @"SearchIndex=Books&"
                           @"Keywords=%@&"
                           @"Version=2007-07-16",
                           searchString];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url
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
    itemNodes = [[doc nodesForXPath:@"ItemSearchResponse/Items/Item"
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
