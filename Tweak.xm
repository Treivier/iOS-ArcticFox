//
//  Tweak.xm
//
//
//  Created by Julian Triveri on 8/11/17.
//

#include <notify.h>
#import <libactivator/libactivator.h>
#import <rocketbootstrap/rocketbootstrap.h>
#import "ActivatorAction.h"
#import "Interfaces.h"

#define IS_SPRINGBOARD [NSBundle.mainBundle.bundleIdentifier isEqual:@"com.apple.springboard"]

void resizeApplicationWindow(CFNotificationCenterRef center,
														 void *observer,
														 CFStringRef name,
														 const void *object,
														 CFDictionaryRef userInfo){
    
	NSString *applicationMessagingCenterName = [NSString stringWithFormat:@"%@ %@", @"trevir.arcticfox.xpm ", NSBundle.mainBundle.bundleIdentifier];
	CPDistributedMessagingCenter *applicationMessagingCenter = [CPDistributedMessagingCenter centerNamed:applicationMessagingCenterName];
	rocketbootstrap_distributedmessagingcenter_apply(applicationMessagingCenter);
	
	NSDictionary *reply = [applicationMessagingCenter sendMessageAndReceiveReplyName:@"trevir.arcticfox.xpm resizeApplicationWindow" userInfo:nil];
	[UIApplication.sharedApplication.keyWindow setFrame:CGRectMake(0,0,[[reply valueForKey:@"width"] doubleValue],[[reply valueForKey:@"height"] doubleValue])];
	[UIApplication.sharedApplication.statusBarWindow setFrame:CGRectMake(0,-100,0,0)];
    
    [UIApplication.sharedApplication setStatusBarOrientation:2 animation:1 duration:0];
    [UIApplication.sharedApplication setStatusBarOrientation:1 animation:1 duration:0];
}

%hook UIApplication
-(id)init{
	id toReturn = %orig;
	
	if(IS_SPRINGBOARD){
		[LAActivator.sharedInstance registerListener:[ActivatorAction new] forName:@"New Window"];
    
    }else{
		const char *messageName = [[NSString stringWithFormat:@"%@ %@", @"trevir.arcticfox.xpn resizeApplicationWindow ", NSBundle.mainBundle.bundleIdentifier] UTF8String];
		
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
																		NULL,
																		resizeApplicationWindow,
																		CFStringCreateWithCString(NULL, messageName, kCFStringEncodingMacRoman),
																		NULL,
																		CFNotificationSuspensionBehaviorDeliverImmediately);
	}
	
	return toReturn;
}

%end
