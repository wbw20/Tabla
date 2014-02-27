//
//  AppDelegate.m
//  Tabla
//
//  Created by William Wettersten on 1/31/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import "AppDelegate.h"
#import "WindowController.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification*)notification
{
	if (windowController == NULL)
		windowController = [[WindowController alloc] initWithWindowNibName:@"Root"];
	
	[windowController showWindow:self];
}

@end
