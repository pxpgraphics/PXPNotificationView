//
//  PXPNotificationView.m
//  PXPNotificationView
//
//  Created by Paris Pinkney on 9/30/14.
//  Copyright (c) 2014 PXPGraphics. All rights reserved.
//

#import <UIKit/UIKit.h>	

/**
 * A subclass of UIView which is used as a non-obtrusive action alert view on the top-most window of the application. Displays a title and message to give the user further information about the notification.
 *
 * @class PXPNotificationView
 */
@interface PXPNotificationView : UIView

@property (nonatomic, assign, getter = isTranslucent) BOOL translucent;
@property (nonatomic, copy) UIColor *textColor;

/**
 *  Initializes an 'PXPNotificationView' object with the specified title and message.
 *
 *  @param title   Title of the notification.
 *  @param message Message of the notification, limited to 2 lines.
 *
 *  @return The newly-initiated PXPNotificationView.
 */
- (instancetype)initWithTitle:(NSString *)title
					  message:(NSString *)message;

/**
 *  Initializes an 'PXPNotificationView' object with the specified title and message.
 *
 *  @param title		   Title of the notification.
 *  @param message		   Message of the notification, limited to 2 lines.
 *  @param backgroundColor Background color of the notification.
 *  @param textColor	   Text color of the notification view's labels.
 *
 *  @return The newly-initiated PXPNotificationView.
 */
- (instancetype)initWithTitle:(NSString *)title
					  message:(NSString *)message
			  backgroundColor:(UIColor *)backgroundColor
					textColor:(UIColor *)textColor;

/**
 *  Dismisses the notification view with the same animation that presented it initially.
 */
- (void)dismiss;

/**
 *  Dismisses the notification view with the same animation that presented it initially adjusted for a new delay interval (in seconds).
 *
 *  @param delay Delay interval (in seconds) for when the dismissing animation should begin.
 */
- (void)dismissAfterDelay:(NSTimeInterval)delay;

/**
 *  Dismisses the notification view with the same animation that presented it initially adjusted for a new delay interval (in seconds).
 *
 *  @param delay		  Delay interval (in seconds) for when the dismissing animation should begin.
 *  @param firstResponder First responder used to signal a view to become first responder once the notfication is dismissed.
 */
- (void)dismissAfterDelay:(NSTimeInterval)delay
		   firstResponder:(UIView *)firstResponder;

/**
 *  Shows the notification view with the default animation settings.
 */
- (void)show;

/**
 *  Dismisses all visible notification views.
 */
+ (void)dismissAllViews;

/**
 *  Shows a notification view with the default animation settings.
 */
+ (void)show;

/**
 *  Shows an 'PXPNotificationView' object with the specified title and message.
 *
 *  @param title   Title of the notification.
 *  @param message Message of the notification, limited to 2 lines.
 */
+ (void)showWithTitle:(NSString *)title
			  message:(NSString *)message;

/**
 *  Shows an 'PXPNotificationView' object with the specified title and message and sets the first responder to manager after dismissal.
 *
 *  @param title		  Title of the notification.
 *  @param message		  Message of the notification, limited to 2 lines.
 *  @param firstResponder First responder used to signal a view to become first responder once the notfication is dismissed.
 */
+ (void)showWithTitle:(NSString *)title
			  message:(NSString *)message
	   firstResponder:(UIView *)firstResponder;

/**
 *  Shows an 'PXPNotificationView' object with the specified title, message, background color, text color, and dismiss delay interval (in seconds).
 *
 *  @param title		   Title of the notification.
 *  @param message		   Message of the notification, limited to 2 lines.
 *  @param backgroundColor Background color of the notification.
 *  @param textColor	   Text color of the notification view's labels.
 *  @param dismissDelay	   Delay interval (in seconds) for when the dismissing animation should begin.
 */
+ (void)showWithTitle:(NSString *)title
			  message:(NSString *)message
	  backgroundColor:(UIColor *)backgroundColor
			textColor:(UIColor *)textColor
		 dismissDelay:(NSTimeInterval)dismissDelay;

@end
