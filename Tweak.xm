#import "Headers.h"

//Lightmann
//Created during COVID-19
//Vinyl

#pragma mark iOS12

%group Tweak_12
//transparency, corner radius of media player, and new player height
%hook SBDashBoardAdjunctItemView
-(void)_updateSizeToMimic{
	%orig;

	PLPlatterView *platterView = (PLPlatterView*)MSHookIvar<UIView*>(self, "_platterView");
	for(UIView *view in platterView.subviews){
		if([view isMemberOfClass:%c(MTMaterialView)]){
			for(UIView *subview in view.subviews){
				[subview setAlpha:transparencyLevel/100];
				[subview.layer setCornerRadius:cornerRadius];
			}
		}
	}
			
	//Use constraints so it's dynamic and works with listview (parent container)
	[self.heightAnchor constraintEqualToConstant:132.5].active = true;
}
%end


//controls
%hook MediaControlsTransportStackView
//positioning											
-(void)setFrame:(CGRect)frame{						
	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if([controller.delegate isKindOfClass:%c(SBDashBoardMediaControlsViewController)]){
		CGRect reference = CGRectMake(120-(controlSpacing/2), 0, self.superview.frame.size.width-120+controlSpacing, frame.size.height-20); //make frame for remaining 2/3 of player (excluding artwork (120x120)) 
		%orig(CGRectMake(frame.origin.x, frame.origin.y, reference.size.width*1.25, reference.size.height));  //change size of controls
		[self setCenter:CGPointMake(CGRectGetMidX(reference), self.frame.size.height/2)]; //set the center of the controls in the reference rect 
		[self setClipsToBounds:YES]; 
	}
	else{
		%orig;
	}
}

//coloring 
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


//prevent control stack from clipping										
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


//progress bar
%hook MediaControlsTimeControl
//positioning 
-(void)setFrame:(CGRect)frame{
	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if([controller.delegate isKindOfClass:%c(SBDashBoardMediaControlsViewController)] && (configuration == 1 || configuration == 3)){
		%orig(CGRectMake(63, 25, (self.superview.frame.size.width-126), 54));
		//since it's centered and we're flipping it, nothing needs to be done for RTL
	}
	else{
		%orig;
	}
}

//hide knob and duration labels
-(void)_updateTimeControl{	
	%orig;

	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if([controller.delegate isKindOfClass:%c(SBDashBoardMediaControlsViewController)] && (configuration == 1 || configuration == 3)){
		[self.knobView setHidden:YES];
		[self.elapsedTimeLabel setHidden:YES];
		[self.remainingTimeLabel setHidden:YES];
	}
}

//coloring
-(void)_updateStyle{
	%orig;

	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if([controller.delegate isKindOfClass:%c(SBDashBoardMediaControlsViewController)] && (configuration == 1 || configuration == 3) && textcolor < 2){
		[self.elapsedTrack setBackgroundColor:[UIColor colorWithWhite:textcolor alpha:1]];      
	}
}

//hide and RTL support
-(void)setTimeControlOnScreen:(BOOL)arg1{
	%orig;

	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if([controller.delegate isKindOfClass:%c(SBDashBoardMediaControlsViewController)]){
		if(configuration == 0 || configuration == 2){
			[self setHidden:YES];
		}
		else{
			[self setHidden:NO];

			//RTL support 
			if([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft){
				//rotate 180 degrees about the origin (to make it start on the right side)
				self.transform = CGAffineTransformRotate(self.transform, M_PI);
			}
		}
	}
}
%end


//volume bar
%hook MediaControlsVolumeContainerView
//positioning
- (void)setFrame:(CGRect)frame{
	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if([controller.delegate isKindOfClass:%c(SBDashBoardMediaControlsViewController)]){
		%orig(CGRectMake(frame.origin.x+36, frame.origin.y-225, (self.superview.frame.size.width-(self.frame.origin.x*2)),frame.size.height));

		//RTL support 
		if([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft){
			%orig(CGRectMake(frame.origin.x+30, frame.origin.y-225, (self.superview.frame.size.width-(self.frame.origin.x*2)+6),frame.size.height));
		}
	}
	else{
		%orig;
	}
}

//hide stuff + coloring
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
			[self.volumeSlider.thumbView setHidden:YES];//knob

			if(textcolor < 2){
				[self.volumeSlider setMinimumTrackTintColor:[UIColor colorWithWhite:textcolor alpha:1]];
			}
		}
	}
}
%end


//Get highres artwork -- taken from Litten's Lobelias (https://github.com/Litteeen/Lobelias/)
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


//add higher res artwork image to now-enlarged imageview
%hook MRPlatterViewController
-(void)_updateOnScreenForStyle:(long long)arg1{
	%orig;

	if([self.label isEqualToString:@"MRPlatter-CoverSheet"] && highresImage) {
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
			[self.nowPlayingHeaderView.artworkView setImage:highresImage];
		});
	} 
}
%end


%hook MediaControlsHeaderView
//positioning 
-(void)setFrame:(CGRect)frame{
	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if(![controller respondsToSelector:@selector(delegate)]){
		%orig;
	}
	else{
		if([controller.delegate isKindOfClass:%c(SBDashBoardMediaControlsViewController)]){
			%orig(CGRectMake(frame.origin.x+(self.artworkView.frame.size.width/2.5), frame.origin.y-10, frame.size.width, frame.size.height));  

				//RTL support 
				if([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft){
					%orig(CGRectMake((self.artworkView.frame.size.width/2)-frame.origin.x, frame.origin.y-10, frame.size.width, frame.size.height));  
				}
		}
		else{
			%orig;
		}
	}
}

//artwork positioning stuff 
-(void)layoutSubviews{
	%orig;

	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if(![controller respondsToSelector:@selector(delegate)]){
		%orig;
	}
	else{
		if([controller.delegate isKindOfClass:%c(SBDashBoardMediaControlsViewController)]){	
			[self.artworkView setFrame:CGRectMake(self.artworkView.frame.origin.x-64, self.artworkView.frame.origin.y-8, 120, 120)]; 

			[self.artworkBackground setFrame:self.artworkView.frame]; 

			[self.placeholderArtworkView setFrame:CGRectMake(self.placeholderArtworkView.frame.origin.x, self.placeholderArtworkView.frame.origin.y, 60, 60)];
			[self.placeholderArtworkView setCenter:self.artworkBackground.center]; 
	
			[self.shadow setFrame:self.placeholderArtworkView.frame]; 
			
			[self.launchNowPlayingAppButton setFrame:self.artworkView.frame];

			if(showConnectButton){
				//RTL support 
				if([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft){
					[self.routingButton setFrame:CGRectMake(self.routeLabel.frame.size.width-2, self.routeLabel.frame.origin.y-12.5, self.routingButton.frame.size.width, self.routingButton.frame.size.height)];
				}
				else{
					//couldn't get constraints to stick on either the routing button or label, so rects it is . . .
					CGRect frame = self.routingButton.frame; 
					[self.routingButton setFrame:CGRectMake((self.routeLabel.frame.origin.x-13.5), (self.routeLabel.frame.origin.y-12), frame.size.width, frame.size.height)];

					CGRect frame2 = self.routeLabel.frame;
					[self.routeLabel setFrame:CGRectMake(frame2.origin.x+13.5, frame2.origin.y, frame2.size.width, frame2.size.height)];
				}
			}

			//RTL support 
			if([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft){
				[self.artworkView setFrame:CGRectMake((-self.superview.frame.size.width)+self.artworkView.frame.origin.x+68, self.artworkView.frame.origin.y, 120, 120)];
				[self.artworkBackground setFrame:self.artworkView.frame];
				[self.placeholderArtworkView setFrame:CGRectMake(self.placeholderArtworkView.frame.origin.x, self.placeholderArtworkView.frame.origin.y, 60, 60)];
				[self.placeholderArtworkView setCenter:self.artworkBackground.center];
				[self.shadow setFrame:self.placeholderArtworkView.frame];
				[self.launchNowPlayingAppButton setFrame:self.artworkView.frame];
			}
		}
	}
}

//coloring + other small things
-(void)_updateStyle{
	%orig;

	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if(![controller respondsToSelector:@selector(delegate)]){
		%orig;
	}
	else{
		if([controller.delegate isKindOfClass:%c(SBDashBoardMediaControlsViewController)]){
			//13 is default for player and 5 is default for artwork, so we need to cover the difference
			[self.artworkView.layer setCornerRadius:cornerRadius-8];
			[self.artworkBackground.layer setCornerRadius:cornerRadius-8];
			[self.placeholderArtworkView.layer setCornerRadius:cornerRadius-8];

			//No scale property, so have to manually transform the CALayer 
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

			if(showConnectButton){
				[self.routingButton setHidden:NO];
			}
			else{
				[self.routingButton setHidden:YES];
			}

			if(stndRouteLabel){
				[self.routeLabel setForcesUppercaseText:NO];
			}
			else{
				[self.routeLabel setForcesUppercaseText:YES];
			}
		}
	}
}
%end

//end of iOS 12 group

%end

#pragma mark iOS13

%group Tweak_13
//transparency, corner radius of media player, and new player height
%hook CSAdjunctItemView
-(void)_updateSizeToMimic{
	%orig;

	PLPlatterView *platterView = (PLPlatterView*)MSHookIvar<UIView*>(self, "_platterView");
	[platterView.backgroundView setAlpha:transparencyLevel/100];
	[platterView.backgroundView.layer setCornerRadius:cornerRadius];
			
	//Use constraints so it's dynamic and works with listview (parent container)
	[self.heightAnchor constraintEqualToConstant:132.5].active = true;
}
%end


//controls
%hook MediaControlsTransportStackView
//positioning											
-(void)setFrame:(CGRect)frame{
	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if([controller.delegate isKindOfClass:%c(CSMediaControlsViewController)]){
		CGRect reference = CGRectMake(120-(controlSpacing/2), 0, self.superview.frame.size.width-120+controlSpacing, frame.size.height-20); //make frame for remaining 2/3 of player (excluding artwork (120x120)) 
		%orig(CGRectMake(frame.origin.x, frame.origin.y, reference.size.width*1.25, reference.size.height));  //change size of controls
		[self setCenter:CGPointMake(CGRectGetMidX(reference), self.frame.size.height/2)]; //set the center of the controls in the reference rect 
		[self setClipsToBounds:YES]; 
	}
	else{
		%orig;
	}
}

//coloring 
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


//prevent control stack from clipping										
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


//progress bar
%hook MediaControlsTimeControl
//positioning
-(void)setFrame:(CGRect)frame{
	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if([controller.delegate isKindOfClass:%c(CSMediaControlsViewController)] && (configuration == 1 || configuration == 3)){
		%orig(CGRectMake(63, 25, (self.superview.frame.size.width-126), 54));
		//since it's centered and we're flipping it, nothing needs to be done for RTL
	}
	else{
		%orig;
	}
}

//hide knob and duration labels
-(void)updateSliderConstraint{	
	%orig;

	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if([controller.delegate isKindOfClass:%c(CSMediaControlsViewController)] && (configuration == 1 || configuration == 3)){
		[self.knobView setHidden:YES];
		[self.elapsedTimeLabel setHidden:YES];
		[self.remainingTimeLabel setHidden:YES];
	}
}

//coloring
-(void)_updateStyle{
	%orig;

	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if([controller.delegate isKindOfClass:%c(CSMediaControlsViewController)] && (configuration == 1 || configuration == 3) && textcolor < 2){
		[self.elapsedTrack setBackgroundColor:[UIColor colorWithWhite:textcolor alpha:1]];      
	}
}

//hide and RTL support
-(void)setTimeControlOnScreen:(BOOL)arg1{
	%orig;

	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if([controller.delegate isKindOfClass:%c(CSMediaControlsViewController)]){
		if(configuration == 0 || configuration == 2){
			[self setHidden:YES];
		}
		else{
			[self setHidden:NO];

			//RTL support 
			if([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft){
				//rotate 180 degrees about the origin (to make it start on the right side)
				self.transform = CGAffineTransformRotate(self.transform, M_PI);
			}
		}
	}
}
%end


//volume bar
%hook MediaControlsVolumeContainerView
//all the things -- positioning + hide stuff + coloring
-(void)_updateVolumeCapabilities{
	%orig;

	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if([controller.delegate isKindOfClass:%c(CSMediaControlsViewController)]){
		if(configuration == 0 || configuration == 1){
			[self setHidden:YES];
		}
		else{
			[self setHidden:NO];

			[self.heightAnchor constraintEqualToConstant:64].active = true;
			[self.widthAnchor constraintEqualToConstant:(self.superview.frame.size.width-104)].active = true;
			[self.topAnchor constraintEqualToAnchor:self.superview.topAnchor constant:-(self.frame.origin.x/2)-5.5].active = true; 	
			[self.leftAnchor constraintEqualToAnchor:self.superview.leftAnchor constant:52].active = true; 
			[self setTranslatesAutoresizingMaskIntoConstraints:NO];

			self.volumeSlider.minimumValueImage = nil;
			self.volumeSlider.maximumValueImage = nil;
			[self.volumeSlider.thumbView setHidden:YES];//knob

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


//add higher res artwork image to now-enlarged imageview
%hook MRPlatterViewController
-(void)_updateOnScreenForStyle:(long long)arg1{
	%orig;

	if([self.label isEqualToString:@"MRPlatter-CoverSheet"] && highresImage) {
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
			[self.nowPlayingHeaderView.artworkView setImage:highresImage];
		});
	} 
}
%end


%hook MediaControlsHeaderView
//positioning 
-(void)setFrame:(CGRect)frame{
	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if(![controller respondsToSelector:@selector(delegate)]){
		%orig;
	}
	else{
		if([controller.delegate isKindOfClass:%c(CSMediaControlsViewController)]){
			%orig(CGRectMake(frame.origin.x+(self.artworkView.frame.size.width/2.5), frame.origin.y-10, frame.size.width, frame.size.height));  

				//RTL support 
				if([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft){
					%orig(CGRectMake((self.artworkView.frame.size.width/2)-frame.origin.x, frame.origin.y-10, frame.size.width, frame.size.height));  
				}
		}
		else{
			%orig;
		}
	}
}

//artwork positioning stuff 
-(void)layoutSubviews{
	%orig;

	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if(![controller respondsToSelector:@selector(delegate)]){
		%orig;
	}
	else{
		if([controller.delegate isKindOfClass:%c(CSMediaControlsViewController)]){	
			//for some reason using constraints here instead of rects works on iOS 13.4+, but not on versions <13.4. Rects it is then . . . 
			[self.artworkView setFrame:CGRectMake(self.artworkView.frame.origin.x-64, self.artworkView.frame.origin.y-8, 120, 120)]; 

			[self.artworkBackground setFrame:self.artworkView.frame]; 

			[self.placeholderArtworkView setFrame:CGRectMake(self.placeholderArtworkView.frame.origin.x, self.placeholderArtworkView.frame.origin.y, 60, 60)];
			[self.placeholderArtworkView setCenter:self.artworkBackground.center]; 
	
			[self.shadow setFrame:self.placeholderArtworkView.frame]; 
			
			[self.launchNowPlayingAppButton setFrame:self.artworkView.frame];

			if(showConnectButton){
				//RTL support 
				if([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft){
					[self.routingButton setFrame:CGRectMake(self.routeLabel.frame.size.width-2, self.routeLabel.frame.origin.y-12.5, self.routingButton.frame.size.width, self.routingButton.frame.size.height)];
				}
				else{
					//couldn't get constraints to stick on either the routing button or label, so rects it is . . .
					CGRect frame = self.routingButton.frame; 
					[self.routingButton setFrame:CGRectMake((self.routeLabel.frame.origin.x-13.5), (self.routeLabel.frame.origin.y-12), frame.size.width, frame.size.height)];

					CGRect frame2 = self.routeLabel.frame;
					[self.routeLabel setFrame:CGRectMake(frame2.origin.x+13.5, frame2.origin.y, frame2.size.width, frame2.size.height)];
				}
			}

			//RTL support 
			if([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft){
				[self.artworkView setFrame:CGRectMake(-(self.superview.frame.size.width), self.artworkView.frame.origin.y, 120, 120)];
				[self.artworkBackground setFrame:self.artworkView.frame];
				[self.placeholderArtworkView setFrame:CGRectMake(self.placeholderArtworkView.frame.origin.x, self.placeholderArtworkView.frame.origin.y, 60, 60)];
				[self.placeholderArtworkView setCenter:self.artworkBackground.center];
				[self.shadow setFrame:self.placeholderArtworkView.frame];
			}
		}
	}
}

//coloring + other small things
-(void)_updateStyle{
	%orig;

	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if(![controller respondsToSelector:@selector(delegate)]){
		%orig;
	}
	else{
		if([controller.delegate isKindOfClass:%c(CSMediaControlsViewController)]){
			//13 is default for player and 5 is default for artwork, so we need to cover the difference
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

			if(showConnectButton){
				[self.routingButton setHidden:NO];
			}
			else{
				[self.routingButton setHidden:YES];
			}

			if(stndRouteLabel){
				[self.routeLabel setForcesUppercaseText:NO];
			}
			else{
				[self.routeLabel setForcesUppercaseText:YES];
			}
		}
	}
}
%end

//end of iOS 13 group

%end

#pragma mark iOS14

%group Tweak_14
//transparency, corner radius of media player, and new player height
%hook CSAdjunctItemView
-(void)_updateSizeToMimic{
	%orig;

	PLPlatterView *platterView = (PLPlatterView*)MSHookIvar<UIView*>(self, "_platterView");
	[platterView.backgroundView setAlpha:transparencyLevel/100];
	[platterView.backgroundView.layer setCornerRadius:cornerRadius];
			
	//Use constraints so it's dynamic and works with listview (parent container)
	[self.heightAnchor constraintEqualToConstant:132.5].active = true;
}
%end


//controls
%hook MRUNowPlayingTransportControlsView
//positioning											
-(void)setFrame:(CGRect)frame{
	MRUNowPlayingViewController *controller = (MRUNowPlayingViewController *)[self _viewControllerForAncestor];
	if(controller.context == 2){ 
		if(configuration == 0 || configuration == 1){ //normal
			CGRect reference = CGRectMake(120-(controlSpacing/2), 0, self.superview.frame.size.width-120+controlSpacing, frame.size.height-20); //make frame for remaining 2/3 of player (excluding artwork (120x120)) 
			%orig(CGRectMake(frame.origin.x, frame.origin.y, reference.size.width*1.25, reference.size.height));  //change size of controls
			[self setCenter:CGPointMake(CGRectGetMidX(reference), frame.size.height*2)]; //set the center of the controls in the reference rect 
			[self setClipsToBounds:YES];
		}
		else{ //if volume bar is present (meaning controlsview has moved)
			CGRect reference = CGRectMake(120-(controlSpacing/2), 0, self.superview.frame.size.width-120+controlSpacing, frame.size.height-20);  
			%orig(CGRectMake(frame.origin.x, frame.origin.y, reference.size.width*1.25, reference.size.height));  
			[self setCenter:CGPointMake(CGRectGetMidX(reference), (frame.size.height*2)+16)]; //adjust for controlsview movement (Y: -16)
			[self setClipsToBounds:YES];
		} 
	}
	else{
		%orig;
	}
}

//coloring 
-(void)didMoveToWindow{	
	%orig;

	MRUNowPlayingViewController *controller = (MRUNowPlayingViewController *)[self _viewControllerForAncestor];
	if(controller.context == 2 && textcolor < 2){
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


//progress bar
%hook MRUNowPlayingTimeControlsView
//positioning 
-(void)setFrame:(CGRect)frame{
	MRUNowPlayingViewController *controller = (MRUNowPlayingViewController *)[self _viewControllerForAncestor];
	if(controller.context == 2){
		if(configuration == 1){ //normal
			%orig(CGRectMake(frame.origin.x+45,104.5,frame.size.width-(self.frame.origin.x*2),frame.size.height/2)); 
		}
		else if(configuration == 3){ //if volume bar is present (meaning controlsview has moved)
			%orig(CGRectMake(frame.origin.x+45,120.5,frame.size.width-(self.frame.origin.x*2),frame.size.height/2)); //adjust for controlsview movement (Y: -16)
		}
	}
	else{									
		%orig;
	}
}

//coloring + hide knob and duration labels
-(void)updateVisibility{
	%orig;

	MRUNowPlayingViewController *controller = (MRUNowPlayingViewController *)[self _viewControllerForAncestor];
	if(controller.context == 2 && (configuration == 1 || configuration == 3)){
		[self.knobView setHidden:YES];
		[self.elapsedTimeLabel setHidden:YES];
		[self.remainingTimeLabel setHidden:YES];

		if(textcolor < 2){
			[self.elapsedTrack setBackgroundColor:[UIColor colorWithWhite:textcolor alpha:1]];      
		}
	}
}

//hide and RTL support
-(void)setOnScreen:(BOOL)arg1{
	%orig;

	MRUNowPlayingViewController *controller = (MRUNowPlayingViewController *)[self _viewControllerForAncestor];
	if(controller.context == 2){ 
		if(configuration == 0 || configuration == 2){
			[self setHidden:YES];
		}
		else{
			[self setHidden:NO];

			//RTL support 
			if([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft){
				//rotate 180 degrees about the origin (to make it start on the right side)
				self.transform = CGAffineTransformRotate(self.transform, M_PI);
			}
		}
	}
}
%end


//this view acts as a touch reciever for all controls 
//we need to adjust its frame to include the volume bar so its input(s) are registered
//this is an absolute pain because there is no middle-man view, meaning we have to move all elements individually instead of moving just a container view   				
%hook MRUNowPlayingControlsView 
-(void)setFrame:(CGRect)frame{
	MRUNowPlayingViewController *controller = (MRUNowPlayingViewController *)[self _viewControllerForAncestor];
	if(controller.context == 2 && (configuration == 2 || configuration == 3)){
		%orig(CGRectMake(frame.origin.x, frame.origin.y-16, frame.size.width, frame.size.height));
	}
	else{
		%orig;
	}
}
%end


//volume bar
%hook MRUNowPlayingVolumeControlsView
//hide stuff + coloring
-(void)updateVolumeCapabilities{
	%orig;

	MRUNowPlayingViewController *controller = (MRUNowPlayingViewController *)[self _viewControllerForAncestor];
	if(controller.context == 2){
		if(configuration == 0 || configuration == 1){
			[self setHidden:YES];
		}
		else{
			[self setHidden:NO];

			self.slider.minimumValueImage = nil;
			self.slider.maximumValueImage = nil;
			[self.slider.thumbView setHidden:YES];//knob
			[self.slider.growingThumbView setHidden:YES];//knob

			if(textcolor < 2){
				[self.slider setMinimumTrackTintColor:[UIColor colorWithWhite:textcolor alpha:1]];
			}
		}
	}
}

//positioning 
-(void)setFrame:(CGRect)frame{
	MRUNowPlayingViewController *controller = (MRUNowPlayingViewController *)[self _viewControllerForAncestor];
	if(controller.context == 2 && (configuration == 2 || configuration == 3)){
		// %orig(CGRectMake(frame.origin.x+45,-(self.frame.origin.x/1.5)+4,frame.size.width-(self.frame.origin.x*2),frame.size.height/2)); //normal 
		%orig(CGRectMake(frame.origin.x+45,-(self.frame.origin.x/1.5)+20,frame.size.width-(self.frame.origin.x*2),frame.size.height/2)); //adjust for controlsview movement (Y: -16)
	}
	else{
		%orig;
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


//add higher res artwork image to now-enlarged imageview
%hook MRUNowPlayingViewController
-(void)updateLayout{
	%orig;

	if(self.context == 2 && highresImage) {
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
			[self.viewIfLoaded.controlsView.headerView.artworkView setArtworkImage:highresImage];
		});
	} 
}
%end


%hook MRUNowPlayingHeaderView
//positioning 
-(void)setFrame:(CGRect)frame{
	MRUNowPlayingViewController *controller = (MRUNowPlayingViewController *)[self _viewControllerForAncestor];
	if(![controller respondsToSelector:@selector(context)]){
		%orig;
	}
	else if(controller.context == 2){
		if(configuration == 0 || configuration == 1){ //normal
			%orig(CGRectMake(frame.origin.x+17, frame.origin.y-10, frame.size.width, frame.size.height));  

				//RTL support 
				if([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft){
					%orig(CGRectMake((self.artworkView.frame.size.width/1.5), frame.origin.y-10, frame.size.width, frame.size.height));  
				}
		}
		else{ //if volume bar is present (meaning controlsview has moved)
			%orig(CGRectMake(frame.origin.x+17, frame.origin.y+6, frame.size.width, frame.size.height)); //adjust for controlsview movement (Y: -16)

				//RTL support 
				if([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft){
					%orig(CGRectMake((self.artworkView.frame.size.width/1.5), frame.origin.y+6, frame.size.width, frame.size.height));  
				}
		}
	}
	else{
		%orig;
	}
}

//artwork positioning stuff 
-(void)layoutSubviews{
	%orig;

	MRUNowPlayingViewController *controller = (MRUNowPlayingViewController *)[self _viewControllerForAncestor];
	if(![controller respondsToSelector:@selector(context)]){
		%orig;
	}
	else if(controller.context == 2){
		[self.artworkView setFrame:CGRectMake(self.artworkView.frame.origin.x-23, self.artworkView.frame.origin.y, 120, 120)]; 
	
		[self.transportButton setFrame:self.artworkView.frame];
	
		[self.labelView setFrame:CGRectMake(self.labelView.frame.origin.x,self.labelView.frame.origin.y,self.labelView.frame.size.width+20,self.labelView.frame.size.height)];

		if(showConnectButton){
			//RTL support 
			if([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft){
				[self.routingButton setFrame:CGRectMake(self.labelView.routeLabel.frame.origin.x+(self.routingButton.frame.size.width/2)-10, self.labelView.routeLabel.frame.origin.y+10.5, self.routingButton.frame.size.width, self.routingButton.frame.size.height)];
			}
			else{
				//couldn't get constraints to stick on either the routing button or label, so rects it is . . .
				CGRect frame = self.routingButton.frame; 
				[self.routingButton setFrame:CGRectMake((self.labelView.routeLabel.frame.size.width*2.5), self.labelView.routeLabel.frame.origin.y+10.5, frame.size.width, frame.size.height)];

				CGRect frame2 = self.labelView.routeLabel.frame;
				[self.labelView.routeLabel.titleLabel setFrame:CGRectMake(frame2.origin.x+13.5, frame2.origin.y, frame2.size.width, frame2.size.height)];
			}
		}

		//RTL support 
		if([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft){
			[self.artworkView setFrame:CGRectMake(-87.5, self.artworkView.frame.origin.y, 120, 120)];
			[self.transportButton setFrame:self.artworkView.frame];  
		}
	}
}

//coloring + other small things
-(void)updateVisibility{
	%orig;

	MRUNowPlayingViewController *controller = (MRUNowPlayingViewController *)[self _viewControllerForAncestor];
	if(![controller respondsToSelector:@selector(context)]){
		%orig;
	}
	else if(controller.context == 2){
		//13 is default for player and 5 is default for artwork, so we need to cover the difference
		[self.artworkView.layer setCornerRadius:cornerRadius-8];
		[self.artworkView setClipsToBounds:YES];
		
		[self.routingButton.packageView setScale:.325];

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

		if(showConnectButton){
			[self.routingButton setHidden:NO];
		}
		else{
			[self.routingButton setHidden:YES];
		}

		if(stndRouteLabel){
			[self.labelView.routeLabel setForcesUppercaseText:NO];
		}
		else{
			[self.labelView.routeLabel setForcesUppercaseText:YES];
		}
	}
}
%end

//end of iOS 14 group

%end

//	PREFERENCES 
void preferencesChanged(){
	NSDictionary *prefs = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"me.lightmann.vinylprefs"];
	if(prefs){
		isEnabled = ([prefs objectForKey:@"isEnabled"] ? [[prefs valueForKey:@"isEnabled"] boolValue] : YES );
		configuration = ([prefs objectForKey:@"configuration"] ? [[prefs valueForKey:@"configuration"] integerValue] : 0 );
		showConnectButton = ([prefs objectForKey:@"showConnectButton"] ? [[prefs valueForKey:@"showConnectButton"] boolValue] : NO );
		stndRouteLabel = ([prefs objectForKey:@"stndRouteLabel"] ? [[prefs valueForKey:@"stndRouteLabel"] boolValue] : NO );
		cornerRadius = ([prefs objectForKey:@"cornerRadius"] ? [[prefs valueForKey:@"cornerRadius"] floatValue] : 13 );
		controlSpacing = ([prefs objectForKey:@"controlSpacing"] ? [[prefs valueForKey:@"controlSpacing"] floatValue] : 0 );
		transparencyLevel = ([prefs objectForKey:@"transparencyLevel"] ? [[prefs valueForKey:@"transparencyLevel"] floatValue] : 100 );
		textcolor = ([prefs objectForKey:@"textcolor"] ? [[prefs valueForKey:@"textcolor"] integerValue] : 0 );
	}
}

%ctor{
	preferencesChanged();

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)preferencesChanged, CFSTR("me.lightmann.vinylprefs-updated"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);

	if(isEnabled){
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
