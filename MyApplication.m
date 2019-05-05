//
//  MyApplication.m
//  RecreatingNSApplication
//
//  Created by Matt Gallagher on 17/01/09.
//  Copyright 2009 Matt Gallagher. All rights reserved.
//
//  Permission is given to use this source code file without charge in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#import "MyApplication.h"

int MyApplicationMain(int argc, const char **argv)
{
	@autoreleasepool {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    Class principalClass =
      NSClassFromString([infoDictionary objectForKey:@"NSPrincipalClass"]);
    NSApplication *applicationObject = [principalClass sharedApplication];

    NSString *mainNibName = [infoDictionary objectForKey:@"NSMainNibFile"];
    NSNib *mainNib = [[NSNib alloc] initWithNibNamed:mainNibName bundle:[NSBundle mainBundle]];
    [mainNib instantiateWithOwner:applicationObject topLevelObjects:nil];

    if ([applicationObject respondsToSelector:@selector(run)])
    {
      [applicationObject
        performSelectorOnMainThread:@selector(run)
        withObject:nil
        waitUntilDone:YES];
    }
  }
	
	return 0;
}

@implementation MyApplication

- (void)run
{
//	[self finishLaunching];
	[[NSNotificationCenter defaultCenter]
		postNotificationName:NSApplicationWillFinishLaunchingNotification
		object:NSApp];
	[[NSNotificationCenter defaultCenter]
		postNotificationName:NSApplicationDidFinishLaunchingNotification
		object:NSApp];
	
	shouldKeepRunning = YES;
	do
	{
		NSEvent *event =
			[self
				nextEventMatchingMask:NSEventMaskAny
				untilDate:[NSDate distantFuture]
				inMode:NSDefaultRunLoopMode
				dequeue:YES];
		
		[self sendEvent:event];
		[self updateWindows];
	} while (shouldKeepRunning);
}

- (void)terminate:(id)sender
{
	shouldKeepRunning = NO;
}

@end

