//
//  ViewController.m
//  PXPNotificationViewSample
//
//  Created by Paris Pinkney on 10/5/14.
//  Copyright (c) 2014 PXPGraphics. All rights reserved.
//

#import "ViewController.h"
#import "PXPNotificationView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showNotificationView:)]];
}

- (void)showNotificationView:(id)sender
{
	static BOOL flag = NO;
	NSString *message;
	if (!flag) {
		flag = YES;
		message = @"A 2-lined message should describe what has happened to cause the notification to be presented.\nIf the message is too long, the label will truncate the tail by default.";
	} else {
		flag = NO;
		message = @"A 1-lined message should be short.";
	}
	[PXPNotificationView showWithTitle:@"This is a title for the notification view."
							   message:message
					   backgroundColor:[self randomColor]
							 textColor:[UIColor whiteColor]
						  dismissDelay:5.0];
}

- (UIColor *)randomColor
{
	CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
	CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
	CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
	return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1.0f];
}

@end
