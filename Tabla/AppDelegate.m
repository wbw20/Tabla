//
//  AppDelegate.m
//  Tabla
//
//  Created by William Wettersten on 1/31/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import "AppDelegate.h"
#import "WindowController.h"
#import "SerialDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification*)notification
{
    SerialDelegate *serial = [[SerialDelegate alloc] init];
    
    [serial listen];
    
	if (windowController == NULL)
		windowController = [[WindowController alloc] initWithWindowNibName:@"Radial"];
	
	[windowController showWindow:self];
}

@end
