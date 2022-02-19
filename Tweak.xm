//
//	Tweak.xm
//	Vinyl
//
//	Created by Lightmann during COVID-19
//

#import "Tweak.h"

#define playerHeight 132.5
#define artworkSize 120

#pragma mark iOS12

%group Tweak_12
// transparency, corner radius, and new player height
%hook SBDashBoardAdjunctItemView
-(void)_updateSizeToMimic{
	%orig;

	PLPlatterView *platterView = MSHookIvar<PLPlatterView *>(self, "_platterView");

	[platterView.mainOverlayView setAlpha:transparencyLevel/100];
	[platterView.backgroundMaterialView setAlpha:transparencyLevel/100];
	[platterView.backgroundView setAlpha:transparencyLevel/100];

	[platterView.mainOverlayView.layer setMasksToBounds:YES];
	[platterView.mainOverlayView.layer setCornerRadius:cornerRadius];
	[platterView.backgroundMaterialView.layer setCornerRadius:cornerRadius];
	[platterView.backgroundView.layer setCornerRadius:cornerRadius];
}

// thanks Xyaman for this method
-(CGSize)intrinsicContentSize{
	CGSize orig = %orig;
	return CGSizeMake(orig.width, playerHeight);
}
%end


// controls
%hook MediaControlsTransportStackView
// positioning
-(void)setFrame:(CGRect)frame{
	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if([controller.delegate isKindOfClass:%c(SBDashBoardMediaControlsViewController)]){
		CGRect reference = CGRectMake(artworkSize-(controlSpacing/2), 0, self.superview.frame.size.width-artworkSize+controlSpacing, frame.size.height-20); // make frame for remaining 2/3 of player (excluding artwork (artworkSizexartworkSize))
		%orig(CGRectMake(frame.origin.x, frame.origin.y, reference.size.width*1.25, reference.size.height));  // change size of controls
		[self setCenter:CGPointMake(CGRectGetMidX(reference), self.frame.size.height/2)]; // set the center of the controls in the reference rect
		[self setClipsToBounds:YES];
	}
	else{
		%orig;
	}
}

// coloring
-(void)_updateButtonBlendMode:(id)arg1 {
	%orig;

	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if([controller.delegate isKindOfClass:%c(SBDashBoardMediaControlsViewController)] && textcolor < 2){
		if(self.leftButton.layer.filters.count) self.leftButton.layer.filters = nil;
		[self.leftButton setTintColor:[UIColor colorWithWhite:textcolor alpha:1]];

		if(self.middleButton.layer.filters.count) self.middleButton.layer.filters = nil;
		[self.middleButton setTintColor:[UIColor colorWithWhite:textcolor alpha:1]];

		if(self.rightButton.layer.filters.count) self.rightButton.layer.filters = nil;
		[self.rightButton setTintColor:[UIColor colorWithWhite:textcolor alpha:1]];
	}
}
%end


// prevent control stack from clipping
%hook MediaControlsParentContainerView
-(void)setFrame:(CGRect)frame{
	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if([controller.delegate isKindOfClass:%c(SBDashBoardMediaControlsViewController)]){
		%orig(CGRectMake(frame.origin.x, frame.origin.y-5, frame.size.width, frame.size.height));
	}
	else{
		%orig;
	}
}
%end


// progress bar
%hook MediaControlsTimeControl
// positioning
-(void)setFrame:(CGRect)frame{
	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if([controller.delegate isKindOfClass:%c(SBDashBoardMediaControlsViewController)]){
		%orig(CGRectMake(63, 25, (self.superview.frame.size.width-126), 54));
		// since it's centered and we're flipping it, nothing needs to be done for RTL
	}
	else{
		%orig;
	}
}

// hide knob and duration labels
-(void)_updateTimeControl{
	%orig;

	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if([controller.delegate isKindOfClass:%c(SBDashBoardMediaControlsViewController)]){
		[self.knobView setHidden:YES];
		[self.elapsedTimeLabel setHidden:YES];
		[self.remainingTimeLabel setHidden:YES];
	}
}

// coloring
-(void)_updateStyle{
	%orig;

	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if([controller.delegate isKindOfClass:%c(SBDashBoardMediaControlsViewController)] && textcolor < 2){
		[self.elapsedTrack setBackgroundColor:[UIColor colorWithWhite:textcolor alpha:1]];
	}
}

// hide and RTL support
-(void)setTimeControlOnScreen:(BOOL)arg1{
	%orig;

	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if([controller.delegate isKindOfClass:%c(SBDashBoardMediaControlsViewController)]){
		if(configuration == 0 || configuration == 2){
			[self setHidden:YES];
		}
		else{
			[self setHidden:NO];

			// RTL support
			if([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft){
				// rotate 180 degrees about the origin (to make it start on the right side)
				self.transform = CGAffineTransformRotate(self.transform, M_PI);
			}
		}
	}
}
%end


// volume bar
%hook MediaControlsVolumeContainerView
// positioning
- (void)setFrame:(CGRect)frame{
	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if([controller.delegate isKindOfClass:%c(SBDashBoardMediaControlsViewController)]){
		%orig(CGRectMake(frame.origin.x+36, frame.origin.y-225, (self.superview.frame.size.width-(self.frame.origin.x*2)),frame.size.height));

		// RTL support
		if([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft){
			%orig(CGRectMake(frame.origin.x+30, frame.origin.y-225, (self.superview.frame.size.width-(self.frame.origin.x*2)+6),frame.size.height));
		}
	}
	else{
		%orig;
	}
}

// hide stuff + coloring
-(void)_updateVolumeCapabilities{
	%orig;

	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if([controller.delegate isKindOfClass:%c(SBDashBoardMediaControlsViewController)]){
		if(configuration == 0 || configuration == 1){
			[self setHidden:YES];
		}
		else{
			[self setHidden:NO];

			self.volumeSlider.minimumValueImage = nil;
			self.volumeSlider.maximumValueImage = nil;
			[self.volumeSlider.thumbView setHidden:YES]; // knob

			if(textcolor < 2){
				[self.volumeSlider setMinimumTrackTintColor:[UIColor colorWithWhite:textcolor alpha:1]];
			}
		}
	}
}
%end


// get highres artwork -- taken from Litten's Lobelias (https://github.com/schneelittchen/Lobelias)
%hook SBMediaController
-(void)setNowPlayingInfo:(id)arg1{
	%orig;

	MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information){
		if (information){
			NSDictionary* dict = (__bridge NSDictionary *)information;
			highresImage = [UIImage imageWithData:[dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtworkData]];
		}
	});
}
%end


// add higher res artwork image to now-enlarged imageview
%hook MRPlatterViewController
-(void)_updateOnScreenForStyle:(long long)arg1{
	%orig;

	if([self.label isEqualToString:@"MRPlatter-CoverSheet"] && highresImage) {
		[self.nowPlayingHeaderView.artworkView setImage:highresImage];
	}
}
%end


%hook MediaControlsHeaderView
// positioning
-(void)setFrame:(CGRect)frame{
	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if([controller respondsToSelector:@selector(delegate)] && [controller.delegate isKindOfClass:%c(SBDashBoardMediaControlsViewController)]){
		%orig(CGRectMake(frame.origin.x+(self.artworkView.frame.size.width/2.5), frame.origin.y-10, frame.size.width, frame.size.height));

			// RTL support
			if([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft){
				%orig(CGRectMake((self.artworkView.frame.size.width/2)-frame.origin.x, frame.origin.y-10, frame.size.width, frame.size.height));
			}
	}
	else{
		%orig;
	}
}

// artwork positioning stuff
-(void)layoutSubviews{
	%orig;

	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if([controller respondsToSelector:@selector(delegate)] && [controller.delegate isKindOfClass:%c(SBDashBoardMediaControlsViewController)]){
		[self.artworkView setFrame:CGRectMake(self.artworkView.frame.origin.x-64, self.artworkView.frame.origin.y-8, artworkSize, artworkSize)];

		[self.artworkBackground setFrame:self.artworkView.frame];

		[self.placeholderArtworkView setFrame:CGRectMake(self.placeholderArtworkView.frame.origin.x, self.placeholderArtworkView.frame.origin.y, 60, 60)];
		[self.placeholderArtworkView setCenter:self.artworkBackground.center];

		[self.shadow setFrame:self.placeholderArtworkView.frame];

		[self.launchNowPlayingAppButton setFrame:self.artworkView.frame];

		if(showConnectButton){
			CGRect frame = self.routingButton.frame;
			CGRect frame2 = self.routeLabel.frame;

			// RTL support
			if([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft){
				[self.routingButton setFrame:CGRectMake(frame2.size.width-2, frame2.origin.y-12.5, frame.size.width, frame.size.height)];
			}
			else{
				[self.routingButton setFrame:CGRectMake((frame2.origin.x-13.5), (frame2.origin.y-12), frame.size.width, frame.size.height)];
				[self.routeLabel setFrame:CGRectMake(frame2.origin.x+13.5, frame2.origin.y, frame2.size.width, frame2.size.height)];
			}
		}

		// RTL support
		if([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft){
			[self.artworkView setFrame:CGRectMake((-self.superview.frame.size.width)+self.artworkView.frame.origin.x+68, self.artworkView.frame.origin.y, artworkSize, artworkSize)];
			[self.artworkBackground setFrame:self.artworkView.frame];
			[self.placeholderArtworkView setFrame:CGRectMake(self.placeholderArtworkView.frame.origin.x, self.placeholderArtworkView.frame.origin.y, 60, 60)];
			[self.placeholderArtworkView setCenter:self.artworkBackground.center];
			[self.shadow setFrame:self.placeholderArtworkView.frame];
			[self.launchNowPlayingAppButton setFrame:self.artworkView.frame];
		}
	}
}

// coloring + other small things
-(void)_updateStyle{
	%orig;

	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if([controller respondsToSelector:@selector(delegate)] && [controller.delegate isKindOfClass:%c(SBDashBoardMediaControlsViewController)]){
		// 13 is default for player and 5 is default for artwork, so we need to cover the difference
		[self.artworkView.layer setCornerRadius:cornerRadius-8];
		[self.artworkBackground.layer setCornerRadius:cornerRadius-8];
		[self.placeholderArtworkView.layer setCornerRadius:cornerRadius-8];

		// No scale property, so have to manually transform the CALayer
		self.routingButton.packageView.layer.transform = CATransform3DMakeScale(.325, .325, 1);

		if(textcolor < 2){
			if(self.routeLabel.layer.filters.count) self.routeLabel.layer.filters = nil;
			if(self.routeLabel.titleLabel.layer.filters.count) self.routeLabel.titleLabel.layer.filters = nil;
			[self.routeLabel setTextColor:[UIColor colorWithWhite:textcolor alpha:0.9]];
			[self.routeLabel.titleLabel setTextColor:[UIColor colorWithWhite:textcolor alpha:0.9]];

			if(MSHookIvar<UILabel*>(self, "_secondaryLabel").layer.filters.count) MSHookIvar<UILabel*>(self, "_secondaryLabel").layer.filters = nil;
			[MSHookIvar<UILabel*>(self, "_secondaryLabel") setTextColor:[UIColor colorWithWhite:textcolor alpha:0.9]];

			[self.primaryLabel setTextColor:[UIColor colorWithWhite:textcolor alpha:0.9]];

			[MSHookIvar<CALayer*>(self.routingButton.packageView, "_packageLayer") setBackgroundColor:[UIColor colorWithWhite:textcolor alpha:1].CGColor];
			[MSHookIvar<CALayer*>(self.routingButton.packageView, "_packageLayer") setCornerRadius:18];
		}

		[self.routingButton setHidden:!showConnectButton];
		[self.routeLabel setForcesUppercaseText:!stndRouteLabel];
	}
}
%end

// end of iOS 12 group

%end

#pragma mark iOS13

%group Tweak_13
// transparency, corner radius, and new player height
%hook CSAdjunctItemView
-(void)_updateSizeToMimic{
	%orig;

	PLPlatterView *platterView = MSHookIvar<PLPlatterView *>(self, "_platterView");
	[platterView.backgroundView setAlpha:transparencyLevel/100];
	[platterView.backgroundView.layer setCornerRadius:cornerRadius];
}

-(CGSize)intrinsicContentSize{
	CGSize orig = %orig;
	return CGSizeMake(orig.width, playerHeight);
}
%end


// controls
%hook MediaControlsTransportStackView
// positioning
-(void)setFrame:(CGRect)frame{
	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if([controller.delegate isKindOfClass:%c(CSMediaControlsViewController)]){
		CGRect reference = CGRectMake(artworkSize-(controlSpacing/2), 0, self.superview.frame.size.width-artworkSize+controlSpacing, frame.size.height-20); // make frame for remaining 2/3 of player (excluding artwork (artworkSizexartworkSize))
		%orig(CGRectMake(frame.origin.x, frame.origin.y, reference.size.width*1.25, reference.size.height));  // change size of controls
		[self setCenter:CGPointMake(CGRectGetMidX(reference), self.frame.size.height/2)]; // set the center of the controls in the reference rect
		[self setClipsToBounds:YES];
	}
	else{
		%orig;
	}
}

// coloring
-(void)_updateVisualStylingForButtons{
	%orig;

	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if([controller.delegate isKindOfClass:%c(CSMediaControlsViewController)] && textcolor < 2){
		if(self.leftButton.imageView.layer.filters.count) self.leftButton.imageView.layer.filters = nil;
		[self.leftButton.imageView setTintColor:[UIColor colorWithWhite:textcolor alpha:1]];

		if(self.middleButton.imageView.layer.filters.count) self.middleButton.imageView.layer.filters = nil;
		[self.middleButton.imageView setTintColor:[UIColor colorWithWhite:textcolor alpha:1]];

		if(self.rightButton.imageView.layer.filters.count) self.rightButton.imageView.layer.filters = nil;
		[self.rightButton.imageView setTintColor:[UIColor colorWithWhite:textcolor alpha:1]];
	}
}
%end


// prevent control stack from clipping
%hook MediaControlsParentContainerView
-(void)setFrame:(CGRect)frame{
	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if([controller.delegate isKindOfClass:%c(CSMediaControlsViewController)]){
		%orig(CGRectMake(frame.origin.x, frame.origin.y-5, frame.size.width, frame.size.height));
	}
	else{
		%orig;
	}
}
%end


// progress bar
%hook MediaControlsTimeControl
// positioning
-(void)setFrame:(CGRect)frame{
	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if([controller.delegate isKindOfClass:%c(CSMediaControlsViewController)]){
		%orig(CGRectMake(63, 25, (self.superview.frame.size.width-126), 54));
		// since it's centered and we're flipping it, nothing needs to be done for RTL
	}
	else{
		%orig;
	}
}

// hide knob and duration labels
-(void)updateSliderConstraint{
	%orig;

	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if([controller.delegate isKindOfClass:%c(CSMediaControlsViewController)]){
		[self.knobView setHidden:YES];
		[self.elapsedTimeLabel setHidden:YES];
		[self.remainingTimeLabel setHidden:YES];
	}
}

// coloring
-(void)_updateStyle{
	%orig;

	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if([controller.delegate isKindOfClass:%c(CSMediaControlsViewController)] && textcolor < 2){
		[self.elapsedTrack setBackgroundColor:[UIColor colorWithWhite:textcolor alpha:1]];
	}
}

// hide and RTL support
-(void)setTimeControlOnScreen:(BOOL)arg1{
	%orig;

	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if([controller.delegate isKindOfClass:%c(CSMediaControlsViewController)]){
		if(configuration == 0 || configuration == 2){
			[self setHidden:YES];
		}
		else{
			[self setHidden:NO];

			// RTL support
			if([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft){
				// rotate 180 degrees about the origin (to make it start on the right side)
				self.transform = CGAffineTransformRotate(self.transform, M_PI);
			}
		}
	}
}
%end


// volume bar
%hook MediaControlsVolumeContainerView
// all the things -- positioning + hide stuff + coloring
-(void)_updateVolumeCapabilities{
	%orig;

	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if([controller.delegate isKindOfClass:%c(CSMediaControlsViewController)]){
		if(configuration == 0 || configuration == 1){
			[self setHidden:YES];
		}
		else{
			[self setHidden:NO];

			[self setTranslatesAutoresizingMaskIntoConstraints:NO];
			[self.heightAnchor constraintEqualToConstant:64].active = true;
			[self.widthAnchor constraintEqualToConstant:(self.superview.frame.size.width-104)].active = true;
			[self.leftAnchor constraintEqualToAnchor:self.superview.leftAnchor constant:52].active = true;
			[self.topAnchor constraintEqualToAnchor:self.superview.topAnchor constant:-(self.frame.origin.x/2)-5.5].active = true;

			self.volumeSlider.minimumValueImage = nil;
			self.volumeSlider.maximumValueImage = nil;
			[self.volumeSlider.thumbView setHidden:YES]; // knob

			if(textcolor < 2){
				[self.volumeSlider setMinimumTrackTintColor:[UIColor colorWithWhite:textcolor alpha:1]];
			}
		}
	}
}
%end


%hook SBMediaController
-(void)setNowPlayingInfo:(id)arg1{
	%orig;

	MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information){
		if (information){
			NSDictionary* dict = (__bridge NSDictionary *)information;
			highresImage = [UIImage imageWithData:[dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtworkData]];
		}
	});
}
%end


// add higher res artwork image to now-enlarged imageview
%hook MRPlatterViewController
-(void)_updateOnScreenForStyle:(long long)arg1{
	%orig;

	if([self.label isEqualToString:@"MRPlatter-CoverSheet"] && highresImage) {
		[self.nowPlayingHeaderView.artworkView setImage:highresImage];
	}
}
%end


%hook MediaControlsHeaderView
// positioning
-(void)setFrame:(CGRect)frame{
	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if([controller respondsToSelector:@selector(delegate)] && [controller.delegate isKindOfClass:%c(CSMediaControlsViewController)]){
		%orig(CGRectMake(frame.origin.x+(self.artworkView.frame.size.width/2.5), frame.origin.y-10, frame.size.width, frame.size.height));

			// RTL support
			if([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft){
				%orig(CGRectMake((self.artworkView.frame.size.width/2)-frame.origin.x, frame.origin.y-10, frame.size.width, frame.size.height));
			}
	}
	else{
		%orig;
	}
}

// artwork positioning stuff
-(void)layoutSubviews{
	%orig;

	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if([controller respondsToSelector:@selector(delegate)] && [controller.delegate isKindOfClass:%c(CSMediaControlsViewController)]){
		// for some reason using constraints here instead of rects works on iOS 13.4+, but not on versions <13.4. Rects it is then . . .
		[self.artworkView setFrame:CGRectMake(self.artworkView.frame.origin.x-64, self.artworkView.frame.origin.y-8, artworkSize, artworkSize)];

		[self.artworkBackground setFrame:self.artworkView.frame];

		[self.placeholderArtworkView setFrame:CGRectMake(self.placeholderArtworkView.frame.origin.x, self.placeholderArtworkView.frame.origin.y, 60, 60)];
		[self.placeholderArtworkView setCenter:self.artworkBackground.center];

		[self.shadow setFrame:self.placeholderArtworkView.frame];

		[self.launchNowPlayingAppButton setFrame:self.artworkView.frame];

		if(showConnectButton){
			CGRect frame = self.routingButton.frame;
			CGRect frame2 = self.routeLabel.frame;

			// RTL support
			if([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft){
				[self.routingButton setFrame:CGRectMake(frame2.size.width-2, frame2.origin.y-12.5, frame.size.width, frame.size.height)];
			}
			else{
				[self.routingButton setFrame:CGRectMake((frame2.origin.x-13.5), (frame2.origin.y-12), frame.size.width, frame.size.height)];
				[self.routeLabel setFrame:CGRectMake(frame2.origin.x+13.5, frame2.origin.y, frame2.size.width, frame2.size.height)];
			}
		}

		// RTL support
		if([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft){
			[self.artworkView setFrame:CGRectMake(-(self.superview.frame.size.width), self.artworkView.frame.origin.y, artworkSize, artworkSize)];
			[self.artworkBackground setFrame:self.artworkView.frame];
			[self.placeholderArtworkView setFrame:CGRectMake(self.placeholderArtworkView.frame.origin.x, self.placeholderArtworkView.frame.origin.y, 60, 60)];
			[self.placeholderArtworkView setCenter:self.artworkBackground.center];
			[self.shadow setFrame:self.placeholderArtworkView.frame];
		}
	}
}

// coloring + other small things
-(void)_updateStyle{
	%orig;

	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if([controller respondsToSelector:@selector(delegate)] && [controller.delegate isKindOfClass:%c(CSMediaControlsViewController)]){
		// 13 is default for player and 5 is default for artwork, so we need to cover the difference
		[self.artworkView.layer setCornerRadius:cornerRadius-8];
		[self.artworkBackground.layer setCornerRadius:cornerRadius-8];
		[self.placeholderArtworkView.layer setCornerRadius:cornerRadius-8];

		[self.routingButton.packageView setScale:.325];

		if(textcolor < 2){
			if(self.routeLabel.layer.filters.count) self.routeLabel.layer.filters = nil;
			if(self.routeLabel.titleLabel.layer.filters.count) self.routeLabel.titleLabel.layer.filters = nil;
			[self.routeLabel setTextColor:[UIColor colorWithWhite:textcolor alpha:0.9]];
			[self.routeLabel.titleLabel setTextColor:[UIColor colorWithWhite:textcolor alpha:0.9]];

			if(MSHookIvar<UILabel*>(self, "_secondaryLabel").layer.filters.count) MSHookIvar<UILabel*>(self, "_secondaryLabel").layer.filters = nil;
			[MSHookIvar<UILabel*>(self, "_secondaryLabel") setTextColor:[UIColor colorWithWhite:textcolor alpha:0.9]];

			[self.primaryLabel setTextColor:[UIColor colorWithWhite:textcolor alpha:0.9]];

			[self.routingButton setOverrideUserInterfaceStyle:(textcolor+1)];
		}

		[self.routingButton setHidden:!showConnectButton];
		[self.routeLabel setForcesUppercaseText:!stndRouteLabel];
	}
}
%end

// end of iOS 13 group

%end

#pragma mark iOS14

%group Tweak_14
// transparency, corner radius, and new player height
%hook CSAdjunctItemView
-(void)_updateSizeToMimic{
	%orig;

	PLPlatterView *platterView = MSHookIvar<PLPlatterView *>(self, "_platterView");
	[platterView.backgroundView setAlpha:transparencyLevel/100];
	[platterView.backgroundView.layer setCornerRadius:cornerRadius];
}

-(CGSize)intrinsicContentSize{
	CGSize orig = %orig;
	return CGSizeMake(orig.width, playerHeight);
}
%end


// controls
%hook MRUNowPlayingTransportControlsView
// positioning
-(void)setFrame:(CGRect)frame{
	MRUNowPlayingViewController *controller = (MRUNowPlayingViewController *)[self _viewControllerForAncestor];
	if([controller respondsToSelector:@selector(context)] && controller.context == 2){
		CGFloat height = frame.size.height-10;
		CGFloat width = (artworkSize*2)+controlSpacing+height;

		[self setTranslatesAutoresizingMaskIntoConstraints:NO];
		[self.widthAnchor constraintEqualToConstant:width].active = YES;
		[self.heightAnchor constraintEqualToConstant:height].active = YES;
		[self.centerXAnchor constraintEqualToAnchor:self.superview.centerXAnchor constant:(width/5)-(controlSpacing/6)+10].active = YES;
		[self.topAnchor constraintEqualToAnchor:self.superview.topAnchor constant:(playerHeight-(height*1.43))].active = YES;

		[self setClipsToBounds:YES];
	}
	else{
		%orig;
	}
}

// coloring
-(void)didMoveToWindow{
	%orig;

	MRUNowPlayingViewController *controller = (MRUNowPlayingViewController *)[self _viewControllerForAncestor];
	if([controller respondsToSelector:@selector(context)] && controller.context == 2 && textcolor < 2){
		[self.leftButton setStylingProvider:nil];
		[self.middleButton setStylingProvider:nil];
		[self.rightButton setStylingProvider:nil];

		if(self.leftButton.imageView.layer.filters.count) self.leftButton.imageView.layer.filters = nil;
		[self.leftButton.imageView setTintColor:[UIColor colorWithWhite:textcolor alpha:1]];

		if(self.middleButton.imageView.layer.filters.count) self.middleButton.imageView.layer.filters = nil;
		[self.middleButton.imageView setTintColor:[UIColor colorWithWhite:textcolor alpha:1]];

		if(self.rightButton.imageView.layer.filters.count) self.rightButton.imageView.layer.filters = nil;
		[self.rightButton.imageView setTintColor:[UIColor colorWithWhite:textcolor alpha:1]];
	}
}
%end


// progress bar
%hook MRUNowPlayingTimeControlsView
// positioning
-(void)setFrame:(CGRect)frame{
	MRUNowPlayingViewController *controller = (MRUNowPlayingViewController *)[self _viewControllerForAncestor];
	if([controller respondsToSelector:@selector(context)] && controller.context == 2){
		CGFloat width = frame.size.width-((frame.origin.x+45)*2);
		CGFloat height = frame.size.height/2;

		[self setTranslatesAutoresizingMaskIntoConstraints:NO];
		[self.widthAnchor constraintEqualToConstant:width].active = YES;
		[self.heightAnchor constraintEqualToConstant:height].active = YES;
		[self.centerXAnchor constraintEqualToAnchor:self.superview.centerXAnchor].active = YES;
		[self.bottomAnchor constraintEqualToAnchor:self.superview.topAnchor constant:(playerHeight+(height/2.25))].active = YES;
	}
	else{
		%orig;
	}
}

// coloring + hide knob and duration labels
-(void)updateVisibility{
	%orig;

	MRUNowPlayingViewController *controller = (MRUNowPlayingViewController *)[self _viewControllerForAncestor];
	if([controller respondsToSelector:@selector(context)] && controller.context == 2){
		[self.knobView setHidden:YES];
		[self.elapsedTimeLabel setHidden:YES];
		[self.remainingTimeLabel setHidden:YES];

		if(textcolor < 2){
			[self.elapsedTrack setBackgroundColor:[UIColor colorWithWhite:textcolor alpha:1]];
		}
	}
}

// hide and RTL support
-(void)setOnScreen:(BOOL)arg1{
	%orig;

	MRUNowPlayingViewController *controller = (MRUNowPlayingViewController *)[self _viewControllerForAncestor];
	if([controller respondsToSelector:@selector(context)] && controller.context == 2){
		if(configuration == 0 || configuration == 2){
			[self setHidden:YES];
		}
		else{
			[self setHidden:NO];

			// RTL support
			if([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft){
				// rotate 180 degrees about the origin (i.e., start on the right side)
				self.transform = CGAffineTransformRotate(self.transform, M_PI);
			}
		}
	}
}
%end


// this view acts as a touch reciever for all controls
// we need to adjust its bounds to include the volume bar so touch input is properly registered
%hook MRUNowPlayingControlsView
-(void)setFrame:(CGRect)frame{
	MRUNowPlayingViewController *controller = (MRUNowPlayingViewController *)[self _viewControllerForAncestor];
	if([controller respondsToSelector:@selector(context)] && controller.context == 2){
		[self setTranslatesAutoresizingMaskIntoConstraints:NO];
		[self.widthAnchor constraintEqualToConstant:frame.size.width].active = YES;
		[self.heightAnchor constraintEqualToConstant:frame.size.height].active = YES;
		[self.centerXAnchor constraintEqualToAnchor:self.superview.centerXAnchor].active = YES;
		[self.topAnchor constraintEqualToAnchor:self.superview.topAnchor].active = YES;
	}
	else{
		%orig;
	}
}
%end


// volume bar
%hook MRUNowPlayingVolumeControlsView
// positioning
-(void)setFrame:(CGRect)frame{
	MRUNowPlayingViewController *controller = (MRUNowPlayingViewController *)[self _viewControllerForAncestor];
	if([controller respondsToSelector:@selector(context)] && controller.context == 2){
		CGFloat width = frame.size.width-((frame.origin.x+45)*2);
		CGFloat height = frame.size.height/2;

		[self setTranslatesAutoresizingMaskIntoConstraints:NO];
		[self.widthAnchor constraintEqualToConstant:width].active = YES;
		[self.heightAnchor constraintEqualToConstant:height].active = YES;
		[self.centerXAnchor constraintEqualToAnchor:self.superview.centerXAnchor].active = YES;
		[self.topAnchor constraintEqualToAnchor:self.superview.topAnchor constant:-(height/2.25)].active = YES;
	}
	else{
		%orig;
	}
}

// hide stuff + coloring
-(void)updateVolumeCapabilities{
	%orig;

	MRUNowPlayingViewController *controller = (MRUNowPlayingViewController *)[self _viewControllerForAncestor];
	if([controller respondsToSelector:@selector(context)] && controller.context == 2){
		if(configuration == 0 || configuration == 1){
			[self setHidden:YES];
		}
		else{
			[self setHidden:NO];

			self.slider.minimumValueImage = nil;
			self.slider.maximumValueImage = nil;
			[self.slider.thumbView setHidden:YES]; // knob
			[self.slider.growingThumbView setHidden:YES]; // knob

			if(textcolor < 2){
				[self.slider setMinimumTrackTintColor:[UIColor colorWithWhite:textcolor alpha:1]];
			}
		}
	}
}
%end

%hook MRUArtworkView
// (re)set artwork now that view is enlarged
-(void)setArtworkImage:(UIImage *)image {
	MRUNowPlayingViewController *controller = (MRUNowPlayingViewController *) [self _viewControllerForAncestor];
	if([controller respondsToSelector:@selector(context)] && controller.context == 2){
		MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information){
			if(information){
				NSDictionary* dict = (__bridge NSDictionary *)information;
				UIImage *highresImage = [UIImage imageWithData:[dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtworkData]];
				%orig(highresImage);
			}
		});
	}
	else{
		%orig;
	}
}

// positioning
-(void)setFrame:(CGRect)frame{
	MRUNowPlayingViewController *controller = (MRUNowPlayingViewController *)[self _viewControllerForAncestor];
	if([controller respondsToSelector:@selector(context)] && controller.context == 2){
		[self setTranslatesAutoresizingMaskIntoConstraints:NO];
		[self.widthAnchor constraintEqualToConstant:artworkSize].active = YES;
		[self.heightAnchor constraintEqualToConstant:artworkSize].active = YES;
		[self.leftAnchor constraintEqualToAnchor:self.superview.superview.leftAnchor constant:-8].active = YES;
		[self.centerYAnchor constraintEqualToAnchor:self.superview.centerYAnchor constant:(playerHeight-self.superview.frame.size.height)/2].active = YES;
	}
	else{
		%orig;
	}
}

// hide src icon
-(void)setIconImage:(UIImage *)arg1 {
	%orig;

	MRUNowPlayingViewController *controller = (MRUNowPlayingViewController *)[self _viewControllerForAncestor];
	if([controller respondsToSelector:@selector(context)] && controller.context == 2 && hideSrcIcon){
		%orig(nil);
	}
}
%end


%hook MRUNowPlayingLabelView
// positioning
-(void)setFrame:(CGRect)frame{
	MRUNowPlayingViewController *controller = (MRUNowPlayingViewController *)[self _viewControllerForAncestor];
	if([controller respondsToSelector:@selector(context)] && controller.context == 2){
		[self setTranslatesAutoresizingMaskIntoConstraints:NO];
		[self.widthAnchor constraintEqualToConstant:self.superview.frame.size.width-artworkSize-5].active = YES;
		[self.heightAnchor constraintEqualToConstant:frame.size.height+20].active = YES;
		[self.centerYAnchor constraintEqualToAnchor:self.superview.centerYAnchor constant:-5].active = YES;

		// RTL support
		if([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft){
			[self.leftAnchor constraintEqualToAnchor:self.superview.leftAnchor constant:artworkSize-5].active = YES;
		}
		else{
			[self.leftAnchor constraintEqualToAnchor:self.superview.leftAnchor constant:artworkSize+8.5].active = YES;
		}
	}
	else{
		%orig;
	}
}

// code below fixes the marquee functionality (Really Apple...really?!!)
-(void)layoutSubviews{
	%orig;

	MRUNowPlayingViewController *controller = (MRUNowPlayingViewController *)[self _viewControllerForAncestor];
	if([controller respondsToSelector:@selector(context)] && controller.context == 2){
		CGRect frame1 = self.titleLabel.frame;
		CGRect frame2 = self.subtitleLabel.frame;

		// prevent truncation
		if(frame1.size.width > self.frame.size.width-10){
			frame1.size.width = [self.titleLabel sizeThatFits:CGSizeMake(self.titleLabel.frame.size.height, CGFLOAT_MAX)].width;
			[self.titleLabel setFrame:frame1];
		}

		if(frame2.size.width > self.frame.size.width-10){
			frame2.size.width = [self.subtitleLabel sizeThatFits:CGSizeMake(self.subtitleLabel.frame.size.height, CGFLOAT_MAX)].width;
			[self.subtitleLabel setFrame:frame2];
		}
	}
}

-(void)updateVisualStyling{
	%orig;

	MRUNowPlayingViewController *controller = (MRUNowPlayingViewController *)[self _viewControllerForAncestor];
	if([controller respondsToSelector:@selector(context)] && controller.context == 2){
		// this restores the functionality, but, left as is, the label content will overlap itself
		if(self.titleMarqueeView.contentView.frame.size.width > self.frame.size.width-10){
			[self.titleMarqueeView setFadeEdgeInsets:UIEdgeInsetsMake(0.0, 6.0, 0.0, 7.0)]; // marquee
			[self.titleMarqueeView setMarqueeEnabled:YES];
		}
		else{
			[self.titleMarqueeView setFadeEdgeInsets:UIEdgeInsetsMake(0.0, 6.0, 0.0, 6.0)]; // default
			[self.titleMarqueeView setMarqueeEnabled:NO];
		}

		if(self.subtitleMarqueeView.contentView.frame.size.width > self.frame.size.width-10){
			[self.subtitleMarqueeView setFadeEdgeInsets:UIEdgeInsetsMake(0.0, 6.0, 0.0, 7.0)]; // marquee
			[self.subtitleMarqueeView setMarqueeEnabled:YES];
		}
		else{
			[self.subtitleMarqueeView setFadeEdgeInsets:UIEdgeInsetsMake(0.0, 6.0, 0.0, 6.0)]; // default
			[self.subtitleMarqueeView setMarqueeEnabled:NO];
		}

		// fix content overlap
		CGFloat diff1 = self.titleLabel.frame.size.width-self.titleMarqueeView.contentView.frame.size.width;
		[self.titleMarqueeView setContentGap:(diff1+35)];

		CGFloat diff2 = self.subtitleLabel.frame.size.width-self.subtitleMarqueeView.contentView.frame.size.width;
		[self.subtitleMarqueeView setContentGap:(diff2+35)];
	}
}
%end


%hook MPRouteLabel
// positioning
-(void)setFrame:(CGRect)frame{
	MRUNowPlayingViewController *controller = (MRUNowPlayingViewController *)[self _viewControllerForAncestor];
	if([controller respondsToSelector:@selector(context)] && controller.context == 2 && showConnectButton){
		[self setTranslatesAutoresizingMaskIntoConstraints:NO];
		[self.topAnchor constraintEqualToAnchor:self.superview.topAnchor].active = YES;

		// RTL support
		if([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft){
			[self.rightAnchor constraintEqualToAnchor:self.superview.rightAnchor].active = YES;
		}
		else{
			[self.leftAnchor constraintEqualToAnchor:self.superview.leftAnchor constant:11.5].active = YES;
		}
	}
	else{
		%orig;
	}
}
%end


%hook MRUNowPlayingRoutingButton
// positioning
-(void)setFrame:(CGRect)frame{
	MRUNowPlayingViewController *controller = (MRUNowPlayingViewController *)[self _viewControllerForAncestor];
	if([controller respondsToSelector:@selector(context)] && controller.context == 2 && showConnectButton){
		[self setTranslatesAutoresizingMaskIntoConstraints:NO];
		[self.topAnchor constraintEqualToAnchor:self.superview.topAnchor constant:(frame.size.height/4)-1.5].active = YES;

		// RTL support
		if([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft){
			MRUNowPlayingHeaderView *superview = (MRUNowPlayingHeaderView *)self.superview; // janky, I know
			[self.rightAnchor constraintEqualToAnchor:self.superview.rightAnchor constant:-superview.labelView.routeLabel.frame.size.width-1.5].active = YES;
		}
		else{
			[self.leftAnchor constraintEqualToAnchor:self.superview.leftAnchor constant:artworkSize-1.5].active = YES;
		}
	}
	else{
		%orig;
	}
}
%end


%hook MRUNowPlayingHeaderView
// coloring + small things
-(void)updateVisibility{
	%orig;

	MRUNowPlayingViewController *controller = (MRUNowPlayingViewController *)[self _viewControllerForAncestor];
	if([controller respondsToSelector:@selector(context)] && controller.context == 2){
		// 13 is default for player and 5 is default for artwork, so we need to cover the difference
		[self.artworkView.layer setCornerRadius:cornerRadius-8];
		[self.artworkView setClipsToBounds:YES];

		[self.routingButton.packageView setScale:.455];

		if(textcolor < 2){
			if(self.labelView.routeLabel.layer.filters.count) self.labelView.routeLabel.layer.filters = nil;
			if(self.labelView.routeLabel.titleLabel.layer.filters.count) self.labelView.routeLabel.titleLabel.layer.filters = nil;
			[self.labelView.routeLabel setTextColor:[UIColor colorWithWhite:textcolor alpha:0.9]];
			[self.labelView.routeLabel.titleLabel setTextColor:[UIColor colorWithWhite:textcolor alpha:0.9]];

			if(self.labelView.titleLabel.layer.filters.count) self.labelView.titleLabel.layer.filters = nil;
			[self.labelView.titleLabel setTextColor:[UIColor colorWithWhite:textcolor alpha:0.9]];

			if(self.labelView.subtitleLabel.layer.filters.count) self.labelView.subtitleLabel.layer.filters = nil;
			[self.labelView.subtitleLabel setTextColor:[UIColor colorWithWhite:textcolor alpha:0.9]];

			[self.routingButton setOverrideUserInterfaceStyle:(textcolor+1)];
		}
	}
}

// more hiding and styling stuff
-(void)setShowRoutingButton:(BOOL)arg1 {
	MRUNowPlayingViewController *controller = (MRUNowPlayingViewController *)[self _viewControllerForAncestor];
	if([controller respondsToSelector:@selector(context)] && controller.context == 2){
		%orig(showConnectButton);
	}
	else {
		%orig;
	}
}

-(void)setStylingProvider:(id)arg1 {
	%orig;

	MRUNowPlayingViewController *controller = (MRUNowPlayingViewController *)[self _viewControllerForAncestor];
	if([controller respondsToSelector:@selector(context)] && controller.context == 2){
		[self.labelView.routeLabel setForcesUppercaseText:!stndRouteLabel];
	}
}
%end

// end of iOS 14 group

%end

// PREFERENCES
void preferencesChanged(){
	NSDictionary *prefs = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"me.lightmann.vinylprefs"];
	isEnabled = (prefs && [prefs objectForKey:@"isEnabled"] ? [[prefs valueForKey:@"isEnabled"] boolValue] : YES );
	configuration = (prefs && [prefs objectForKey:@"configuration"] ? [[prefs valueForKey:@"configuration"] integerValue] : 0 );
	showConnectButton = (prefs && [prefs objectForKey:@"showConnectButton"] ? [[prefs valueForKey:@"showConnectButton"] boolValue] : NO );
	stndRouteLabel = (prefs && [prefs objectForKey:@"stndRouteLabel"] ? [[prefs valueForKey:@"stndRouteLabel"] boolValue] : NO );
	hideSrcIcon = (prefs && [prefs objectForKey:@"hideSrcIcon"] ? [[prefs valueForKey:@"hideSrcIcon"] boolValue] : NO );
	cornerRadius = (prefs && [prefs objectForKey:@"cornerRadius"] ? [[prefs valueForKey:@"cornerRadius"] floatValue] : 13 );
	controlSpacing = (prefs && [prefs objectForKey:@"controlSpacing"] ? [[prefs valueForKey:@"controlSpacing"] floatValue] : 0 );
	transparencyLevel = (prefs && [prefs objectForKey:@"transparencyLevel"] ? [[prefs valueForKey:@"transparencyLevel"] floatValue] : 100 );
	textcolor = (prefs && [prefs objectForKey:@"textcolor"] ? [[prefs valueForKey:@"textcolor"] integerValue] : 0 );
}

%ctor{
	preferencesChanged();

	if(isEnabled){
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)preferencesChanged, CFSTR("me.lightmann.vinylprefs-updated"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);

		if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"14.2")){
			%init(Tweak_14);
		}
		else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"13")) {
			%init(Tweak_13);
		}
		else if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"12")) {
			%init(Tweak_12);
		}
	}
}
