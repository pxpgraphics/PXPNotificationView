//
//  PXPNotificationView.m
//  PXPNotificationView
//
//  Created by Paris Pinkney on 9/30/14.
//  Copyright (c) 2014 PXPGraphics. All rights reserved.
//

#import "PXPNotificationView.h"

static NSString * const PXPNotificationViewAnimationDurationKey = @"PXPNotificationViewAnimationDurationKey";
static NSString * const PXPNotificationViewBeginDismissDelayKey = @"PXPNotificationViewBeginDismissDelayKey";
static NSString * const PXPNotificationViewEndDismissDelayKey = @"PXPNotificationViewEndDismissDelayKey";

static CGFloat const PXPNotificationViewHeight = 77.0f;
static CGFloat const PXPNotificationViewStatusBarHeight = 20.0f;

static NSTimeInterval const PXPNotificationViewAnimationDuration = 0.3;
static NSTimeInterval const PXPNotificationViewBeginDismissDelay = 5.0;
static NSTimeInterval const PXPNotificationViewEndDismissDelay = 0.0;

@interface PXPNotificationView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation PXPNotificationView

- (instancetype)init
{
	return [self initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, PXPNotificationViewHeight)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		self.frame = CGRectOffset(frame, 0.0f, frame.size.height * -1.0f);
		self.translatesAutoresizingMaskIntoConstraints = NO;

		_translucent = YES;
		_textColor = [UIColor whiteColor];

		_titleLabel = [[UILabel alloc] init];
		_titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
		_titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
		_titleLabel.textColor = _textColor;
		_titleLabel.textAlignment = NSTextAlignmentCenter;
		_titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
		[self addSubview:_titleLabel];

		_messageLabel = [[UILabel alloc] init];
		_messageLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
		_messageLabel.lineBreakMode = NSLineBreakByTruncatingTail;
		_messageLabel.numberOfLines = 2;
		_messageLabel.textColor = _textColor;
		_messageLabel.textAlignment = NSTextAlignmentCenter;
		_messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
		[self addSubview:_messageLabel];

		[self addGestureRecognizer:[[UITapGestureRecognizer alloc]
									initWithTarget:self
									action:@selector(dismiss:)]];

		[[NSNotificationCenter defaultCenter]
		 addObserver:self selector:@selector(statusBarOrientationDidChange:)
		 name:UIApplicationDidChangeStatusBarOrientationNotification
		 object:nil];
	}
	return self;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message
{
	self = [self init];
	if (self) {
		_titleLabel.text = title;
		_messageLabel.text = message;
	}
	return self;
}

- (instancetype)initWithTitle:(NSString *)title
					  message:(NSString *)message
			  backgroundColor:(UIColor *)backgroundColor
					textColor:(UIColor *)textColor
{
	self = [self init];
	if (self) {
		_titleLabel.text = title;
		_messageLabel.text = message;
		self.backgroundColor = backgroundColor ?: self.backgroundColor;
		_textColor = textColor ?: _textColor;
	}
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UIView

- (void)setupConstraints
{
	NSDictionary *viewInfo = @{ @"self" : self,
								@"titleLabel" : self.titleLabel,
								@"messageLabel" : self.messageLabel };

	CGFloat viewHeight = PXPNotificationViewHeight;
	CGFloat statusBarHeight = MIN([UIApplication sharedApplication].statusBarFrame.size.height,
								  [UIApplication sharedApplication].statusBarFrame.size.width);

	if (statusBarHeight == 0) {
		statusBarHeight = PXPNotificationViewStatusBarHeight;
	}

	CGFloat titleLabelHeight = [self.titleLabel.text sizeWithAttributes:@{ NSFontAttributeName: self.titleLabel.font }].height;
	CGFloat messageLabelHeight = [self.messageLabel.text sizeWithAttributes:@{ NSFontAttributeName: self.messageLabel.font }].height;

	CGSize screenSize = [UIScreen mainScreen].bounds.size;
	if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
		screenSize.width = MAX(screenSize.width, screenSize.height);
		screenSize.height = MIN(screenSize.height, screenSize.width);
	} else {
		screenSize.height = MAX(screenSize.width, screenSize.height);
		screenSize.width = MIN(screenSize.height, screenSize.width);
	}

	viewHeight += ((messageLabelHeight / self.messageLabel.font.pointSize) * (messageLabelHeight / 4.0f));

	self.titleLabel.preferredMaxLayoutWidth = screenSize.width;
	self.messageLabel.preferredMaxLayoutWidth = screenSize.width;

	NSDictionary *metrics = @{ @"height" : @(viewHeight),
							   @"width" : @(screenSize.width),
							   @"statusBarHeight" : @(statusBarHeight),
							   @"titleLabelHeight" : @(titleLabelHeight),
							   @"messageLabelHeight" : @(messageLabelHeight) };

	[self removeConstraints:self.constraints];

	// Notification view constraints.
	NSArray *hConstraints;
	hConstraints = [NSLayoutConstraint
					constraintsWithVisualFormat:@"H:[self(width)]"
					options:0 metrics:metrics views:viewInfo];

	NSArray *vConstraints;
	vConstraints = [NSLayoutConstraint
					constraintsWithVisualFormat:@"V:[self(height)]"
					options:0 metrics:metrics views:viewInfo];

	[self addConstraints:hConstraints];
	[self addConstraints:vConstraints];

	// Label constraints.
	NSArray *hTitleLabelConstraints, *vTitleLabelConstraints;
	hTitleLabelConstraints = [NSLayoutConstraint
							  constraintsWithVisualFormat:@"H:|-[titleLabel]-|"
							  options:0 metrics:metrics views:viewInfo];

	vTitleLabelConstraints = [NSLayoutConstraint
							  constraintsWithVisualFormat:@"V:|-statusBarHeight-[titleLabel(titleLabelHeight)][messageLabel]-|"
							  options:0 metrics:metrics views:viewInfo];

	NSArray *hMessageLabelConstraints, *vMessageLabelConstraints;
	hMessageLabelConstraints = [NSLayoutConstraint
								constraintsWithVisualFormat:@"H:|-[messageLabel]-|"
								options:0 metrics:metrics views:viewInfo];

	vMessageLabelConstraints = [NSLayoutConstraint
								constraintsWithVisualFormat:@"V:[messageLabel]"
								options:0 metrics:metrics views:viewInfo];

	[self addConstraints:hTitleLabelConstraints];
	[self addConstraints:vTitleLabelConstraints];
	[self addConstraints:hMessageLabelConstraints];
	[self addConstraints:vMessageLabelConstraints];

	[self setNeedsUpdateConstraints];
}

#pragma mark - Custom accessors

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
	[super setBackgroundColor:backgroundColor];

	[self setBackgroundColor:backgroundColor translucent:self.translucent];
}

- (void)setTranslucent:(BOOL)translucent
{
	_translucent = translucent;

	[self setBackgroundColor:self.backgroundColor translucent:translucent];
}

#pragma mark - Private methods

- (void)statusBarOrientationDidChange:(NSNotification *)notification
{
	[self setupConstraints];
	[self updateConstraintsIfNeeded];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor translucent:(BOOL)translucent
{
	if ([self.backgroundColor isEqual:backgroundColor] && self.translucent == translucent) {
		return;
	}

	UIColor *color = [UIColor blackColor];
	CGFloat finalAlpha = (translucent) ? 0.95f : 1.0f;
	CGFloat red, green, blue, alpha, white;
	if (CGColorGetNumberOfComponents(color.CGColor) == 2) {
		[self.backgroundColor getWhite:&white alpha:&alpha];
		self.backgroundColor = [UIColor colorWithWhite:white alpha:finalAlpha];
	} else {
		[color getRed:&red green:&green blue:&blue alpha:&alpha];
		self.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:finalAlpha];
	}
}

- (void)dismiss:(id)sender
{
	CGRect frame = self.frame;
	frame.origin.y -= frame.size.height;

	NSTimeInterval duration, delay;
	if ([sender isKindOfClass:[NSNotification class]]) {
		NSNotification *notification = (NSNotification *)sender;
		NSDictionary *userInfo = [notification userInfo];
		duration = [userInfo[PXPNotificationViewAnimationDurationKey] doubleValue];
		delay = [userInfo[PXPNotificationViewEndDismissDelayKey] doubleValue];
	} else if ([sender isKindOfClass:[UITapGestureRecognizer class]]) {
		__unused UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer *)sender;
		// TODO: Handle UITapGestureRecognizer to change focus for multiple (stacked) notifications.
		//		 Possibly in a mutable array handle show the view hierarchy of all visible notifications.
		duration = PXPNotificationViewAnimationDuration;
		delay = PXPNotificationViewEndDismissDelay;
	} else {
		duration = PXPNotificationViewAnimationDuration;
		delay = PXPNotificationViewEndDismissDelay;
	}

	[UIView animateWithDuration:duration
						  delay:delay
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 self.frame = frame;
					 } completion:^(BOOL finished) {
						 [self removeFromSuperview];
					 }];
}

#pragma mark - Public methods

- (void)dismiss
{
	[self dismiss:nil];
}

- (void)dismissAfterDelay:(NSTimeInterval)delay
{
	NSDictionary *userInfo = @{ PXPNotificationViewEndDismissDelayKey : @(delay) };
	NSNotification *notification = [[NSNotification alloc] initWithName:nil object:self userInfo:userInfo];
	[self dismiss:notification];
}

- (void)dismissAfterDelay:(NSTimeInterval)delay
		   firstResponder:(UIView *)firstResponder
{
	[firstResponder becomeFirstResponder];
	[self dismissAfterDelay:delay];
}

- (void)show
{
	if (!self.superview) {
		UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
		[window addSubview:self];
//		[self setNeedsUpdateConstraints];
		[self setupConstraints];
	}

	CGRect frame = self.frame;
	frame.origin.y = 0.0f;

	[UIView animateWithDuration:PXPNotificationViewAnimationDuration
						  delay:PXPNotificationViewEndDismissDelay
						options:UIViewAnimationOptionCurveEaseInOut
					 animations:^{
							self.frame = frame;
						} completion:nil];
}

#pragma mark - Public class methods

+ (void)dismissAllViews
{
	UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
	for (UIView *subview in window.subviews) {
		if ([subview isKindOfClass:[PXPNotificationView class]]) {
			PXPNotificationView *notificationView = (PXPNotificationView *)subview;
			[notificationView removeFromSuperview];
			notificationView = nil;
		}
	}
}

+ (void)show
{
	[[self class] showWithTitle:nil
						message:nil];
}

+ (void)showWithTitle:(NSString *)title
			  message:(NSString *)message
{
	[[self class] showWithTitle:title
						message:message
				backgroundColor:nil
					  textColor:nil
				   dismissDelay:PXPNotificationViewBeginDismissDelay];
}

+ (void)showWithTitle:(NSString *)title
			  message:(NSString *)message
	   firstResponder:(UIView *)firstResponder
{
	[firstResponder becomeFirstResponder];
	[[self class] showWithTitle:title
						message:message
				backgroundColor:nil
					  textColor:nil
				   dismissDelay:PXPNotificationViewBeginDismissDelay];
}

+ (void)showWithTitle:(NSString *)title
			  message:(NSString *)message
	  backgroundColor:(UIColor *)backgroundColor
			textColor:(UIColor *)textColor
		 dismissDelay:(NSTimeInterval)dismissDelay
{
	[[self class] dismissAllViews];
	PXPNotificationView *notificationView = [[PXPNotificationView alloc]
											 initWithTitle:title
											 message:message
											 backgroundColor:backgroundColor
											 textColor:textColor];

	[NSTimer scheduledTimerWithTimeInterval:dismissDelay
									 target:notificationView
								   selector:@selector(dismiss:)
								   userInfo:nil repeats:NO];
	[notificationView show];
}

@end
