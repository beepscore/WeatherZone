//
//  WeatherZoneAppDelegate.h
//  WeatherZone
//
//  Created by Steve Baker on 11/19/09.
//  Copyright 2009 Beepscore LLC. All rights reserved.
//  Ref Hillegass Ch 28

#import <Cocoa/Cocoa.h>

@interface WeatherZoneAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
    
    NSXMLDocument *doc;
    NSArray *itemNodes;
    
    IBOutlet NSProgressIndicator *progress;
    IBOutlet NSTextField *searchField;
    IBOutlet NSTableView *tableView;
}

@property (assign) IBOutlet NSWindow *window;

- (IBAction)fetchBooks:(id)sender;

@end
