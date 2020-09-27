//Lightmann
//Created during COVID-19
//Vinyl

#import "Headers.h"
#import "VinylManager.h"
#define kHeight [UIScreen mainScreen].bounds.size.height 

//Transparency and corner radius of media player and sets player height
%hook CSAdjunctItemView
-(void)_updateSizeToMimic{
	%orig;

	if(isEnabled){
		PLPlatterView *platterView = (PLPlatterView*)MSHookIvar<UIView*>(self, "_platterView");
		platterView.backgroundView.alpha = transparencyLevel/100;
		platterView.backgroundView.layer.cornerRadius = cornerRadius;
			
		//Use constraints so it's dynamic and works with listview (parent container)
		if(!nxtUpInstalled){//Default 
			[self.heightAnchor constraintEqualToConstant:132.5].active = true;
		}
		if(nxtUpInstalled){//NextUp2 Support (Slimmed mode (LS) HAS TO BE ENABLED!!)
			[self.heightAnchor constraintEqualToConstant:265].active = true;
		}
	}
	else{
		%orig;
	}
}
%end


//controls
%hook MediaControlsTransportStackView
//covers inital coloring 
-(void)_updateStyle{
	%orig;

	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if(isEnabled && [controller.delegate isKindOfClass:%c(CSMediaControlsViewController)]){
		if(textcolor == 1){
			if(self.tvRemoteButton.imageView.layer.filters.count) self.tvRemoteButton.imageView.layer.filters = nil; 
			self.tvRemoteButton.imageView.tintColor = [UIColor whiteColor];

			if(self.leftButton.imageView.layer.filters.count) self.leftButton.imageView.layer.filters = nil;
			self.leftButton.imageView.tintColor = [UIColor whiteColor];

			if(self.middleButton.imageView.layer.filters.count) self.middleButton.imageView.layer.filters = nil;
			self.middleButton.imageView.tintColor = [UIColor whiteColor];

			if(self.rightButton.imageView.layer.filters.count) self.rightButton.imageView.layer.filters = nil;
			self.rightButton.imageView.tintColor = [UIColor whiteColor];

			if(self.languageOptionsButton.imageView.layer.filters.count) self.languageOptionsButton.imageView.layer.filters = nil;
			self.languageOptionsButton.imageView.tintColor = [UIColor whiteColor];
		}

		if(textcolor == 2){
			if(self.tvRemoteButton.imageView.layer.filters.count) self.tvRemoteButton.imageView.layer.filters = nil; 
			self.tvRemoteButton.imageView.tintColor = [UIColor blackColor];

			if(self.leftButton.imageView.layer.filters.count) self.leftButton.imageView.layer.filters = nil;
			self.leftButton.imageView.tintColor = [UIColor blackColor];

			if(self.middleButton.imageView.layer.filters.count) self.middleButton.imageView.layer.filters = nil;
			self.middleButton.imageView.tintColor = [UIColor blackColor];

			if(self.rightButton.imageView.layer.filters.count) self.rightButton.imageView.layer.filters = nil;
			self.rightButton.imageView.tintColor = [UIColor blackColor];

			if(self.languageOptionsButton.imageView.layer.filters.count) self.languageOptionsButton.imageView.layer.filters = nil;
			self.languageOptionsButton.imageView.tintColor = [UIColor blackColor];
		}
		
		if(textcolor == 0){//default
			if([self.visualStylingProvider.coreMaterialVisualStylingProvider.visualStyleSetName isEqualToString:@"platterStrokeDark"]){
				self.tvRemoteButton.imageView.tintColor = [UIColor whiteColor];

				self.leftButton.imageView.tintColor = [UIColor whiteColor];

				self.middleButton.imageView.tintColor = [UIColor whiteColor];

				self.rightButton.imageView.tintColor = [UIColor whiteColor];

				self.languageOptionsButton.imageView.tintColor = [UIColor whiteColor];
			}
			else{
				self.tvRemoteButton.imageView.tintColor = [UIColor blackColor];

				self.leftButton.imageView.tintColor = [UIColor blackColor];

				self.middleButton.imageView.tintColor = [UIColor blackColor];

				self.rightButton.imageView.tintColor = [UIColor blackColor];

				self.languageOptionsButton.imageView.tintColor = [UIColor blackColor];
			}
		}		
	}

	else{
		%orig;
	}
}

//covers coloring after inital presentation
-(void)_updateButtonVisualStyling:(id)arg1 {
	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if(isEnabled && [controller.delegate isKindOfClass:%c(CSMediaControlsViewController)]){
		if(textcolor == 1){
			if(self.tvRemoteButton.imageView.layer.filters.count) self.tvRemoteButton.imageView.layer.filters = nil; 
			self.tvRemoteButton.imageView.tintColor = [UIColor whiteColor];

			if(self.leftButton.imageView.layer.filters.count) self.leftButton.imageView.layer.filters = nil;
			self.leftButton.imageView.tintColor = [UIColor whiteColor];

			if(self.middleButton.imageView.layer.filters.count) self.middleButton.imageView.layer.filters = nil;
			self.middleButton.imageView.tintColor = [UIColor whiteColor];

			if(self.rightButton.imageView.layer.filters.count) self.rightButton.imageView.layer.filters = nil;
			self.rightButton.imageView.tintColor = [UIColor whiteColor];

			if(self.languageOptionsButton.imageView.layer.filters.count) self.languageOptionsButton.imageView.layer.filters = nil;
			self.languageOptionsButton.imageView.tintColor = [UIColor whiteColor];
		}

		if(textcolor == 2){
			if(self.tvRemoteButton.imageView.layer.filters.count) self.tvRemoteButton.imageView.layer.filters = nil; 
			self.tvRemoteButton.imageView.tintColor = [UIColor blackColor];

			if(self.leftButton.imageView.layer.filters.count) self.leftButton.imageView.layer.filters = nil;
			self.leftButton.imageView.tintColor = [UIColor blackColor];

			if(self.middleButton.imageView.layer.filters.count) self.middleButton.imageView.layer.filters = nil;
			self.middleButton.imageView.tintColor = [UIColor blackColor];

			if(self.rightButton.imageView.layer.filters.count) self.rightButton.imageView.layer.filters = nil;
			self.rightButton.imageView.tintColor = [UIColor blackColor];

			if(self.languageOptionsButton.imageView.layer.filters.count) self.languageOptionsButton.imageView.layer.filters = nil;
			self.languageOptionsButton.imageView.tintColor = [UIColor blackColor];
		}
		
		if(textcolor == 0){//default
			if([self.visualStylingProvider.coreMaterialVisualStylingProvider.visualStyleSetName isEqualToString:@"platterStrokeDark"]){
				self.tvRemoteButton.imageView.tintColor = [UIColor whiteColor];

				self.leftButton.imageView.tintColor = [UIColor whiteColor];

				self.middleButton.imageView.tintColor = [UIColor whiteColor];

				self.rightButton.imageView.tintColor = [UIColor whiteColor];

				self.languageOptionsButton.imageView.tintColor = [UIColor whiteColor];
			}
			else{
				self.tvRemoteButton.imageView.tintColor = [UIColor blackColor];

				self.leftButton.imageView.tintColor = [UIColor blackColor];

				self.middleButton.imageView.tintColor = [UIColor blackColor];

				self.rightButton.imageView.tintColor = [UIColor blackColor];

				self.languageOptionsButton.imageView.tintColor = [UIColor blackColor];
			}
		}		
	}

	else{
		%orig;
	}
}

//positioning											*THIS COULD USE SOME WORK*
- (void)setFrame:(CGRect)frame{
	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if(isEnabled && [controller.delegate isKindOfClass:%c(CSMediaControlsViewController)]){
		%orig(CGRectMake(100, 25, frame.size.width-74, frame.size.height-20));

		//non-rtl apple tv control support (couldn't test myself, so not sure that it looks that good)
		if((self.tvRemoteButton.hidden == NO) && (self.languageOptionsButton.hidden == NO) && (kHeight != 568) && ([UIApplication sharedApplication].userInterfaceLayoutDirection != UIUserInterfaceLayoutDirectionRightToLeft)){
			%orig(CGRectMake(frame.origin.x, frame.origin.y, frame.size.width-82, frame.size.height-20)); 
		}

		//RTL support 
		if([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft){
			%orig(CGRectMake(-26.5, 25, frame.size.width-74, frame.size.height-20)); 
				
			//apple tv control support (couldn't test myself, so not sure that it looks that good)
			if((self.tvRemoteButton.hidden == NO) && (self.languageOptionsButton.hidden == NO)){
				%orig(CGRectMake(frame.origin.x, frame.origin.y, frame.size.width-82, frame.size.height-20)); 
			}
		}

		//Small form factor device support 
		if(kHeight == 568){
			%orig(CGRectMake(90, 25, frame.size.width-80, frame.size.height-20));

			//apple tv control support (couldn't test myself, so not sure that it looks that good)
			if((self.tvRemoteButton.hidden == NO) && (self.languageOptionsButton.hidden == NO)){
				%orig(CGRectMake(frame.origin.x, frame.origin.y, frame.size.width-88, frame.size.height-20)); 
			}
		}
	}
	else{
		%orig;
	}
}
%end


//progress bar
%hook MediaControlsTimeControl
//hidden settings and rtl support
-(void)setTimeControlOnScreen:(BOOL)arg1 {
	%orig;

	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if(isEnabled && [controller.delegate isKindOfClass:%c(CSMediaControlsViewController)]){
		if((configuration == 0) || (configuration == 2)){
			[self setHidden:YES];
		}
		if((configuration == 1) || (configuration == 3)){
			[self setHidden:NO];

			//RTL support 
			if([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft){
				//rotate 180 degrees about the origin (to have it start on the right side)
				self.transform = CGAffineTransformRotate(self.transform, M_PI);
			}
		}
	}
	else{
		%orig;
	}
}

// coloring
-(void)_updateStyle{
	%orig;

	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if(isEnabled && [controller.delegate isKindOfClass:%c(CSMediaControlsViewController)] && ((configuration == 1) || (configuration == 3))){
		if(textcolor == 1){
			self.elapsedTrack.backgroundColor = [UIColor whiteColor];      
		}
		if(textcolor == 2){
			self.elapsedTrack.backgroundColor = [UIColor blackColor];
		}
		if(textcolor == 0){
			if([self.visualStylingProvider.coreMaterialVisualStylingProvider.visualStyleSetName isEqualToString:@"platterStrokeDark"]){
				self.elapsedTrack.backgroundColor = [UIColor whiteColor];
			}
			else{
				self.elapsedTrack.backgroundColor = [UIColor blackColor];
			}
		}
	}
	else{
		%orig;
	}
}

//position 
-(void)_updateSliderPosition{
	%orig;

	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if(isEnabled && [controller.delegate isKindOfClass:%c(CSMediaControlsViewController)] && ((configuration == 1) || (configuration == 3))){
		self.frame = CGRectMake(63, 50.5, (self.superview.frame.size.width-(self.frame.origin.x*2)), 54);

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
	if(isEnabled && [controller.delegate isKindOfClass:%c(CSMediaControlsViewController)] && ((configuration == 1) || (configuration == 3))){
		[self.knobView setHidden:YES];
		[self.elapsedTimeLabel setHidden:YES];
		[self.remainingTimeLabel setHidden:YES];
	}
	else{
		%orig;
	}
}
%end


//volume slider 
%hook MediaControlsVolumeContainerView
//hide stuff
-(void)_updateVolumeCapabilities{
	%orig;

	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if(isEnabled && [controller.delegate isKindOfClass:%c(CSMediaControlsViewController)]){
		if((configuration == 0) || (configuration == 1)){
			[self setHidden:YES];
		}
		if((configuration == 2) || (configuration == 3)){
			[self setHidden:NO];

			self.volumeSlider.minimumValueImage = nil;
			self.volumeSlider.maximumValueImage = nil;
			[self.volumeSlider.thumbView setHidden:YES];//knob
		}
	}
	else{
		%orig;
	}
}

//coloring
-(void)_updateVolumeStyle{
	%orig;

	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if(isEnabled && [controller.delegate isKindOfClass:%c(CSMediaControlsViewController)] && ((configuration == 2) || (configuration == 3))){
		if(textcolor == 1){
			self.volumeSlider.visualStylingProvider = nil;
			[self.volumeSlider setOverrideUserInterfaceStyle:2];
		}
		if(textcolor == 2){
			self.volumeSlider.visualStylingProvider = nil;
			[self.volumeSlider setOverrideUserInterfaceStyle:1];
		}
		if(textcolor == 0){
			%orig;
			[self.volumeSlider setOverrideUserInterfaceStyle:0];
		}
	}
	else{
		%orig;
	}
}	

//positioning
- (void)setFrame:(CGRect)frame{
	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if(isEnabled && [controller.delegate isKindOfClass:%c(CSMediaControlsViewController)]){
		%orig(CGRectMake(frame.origin.x+36, frame.origin.y-225, (self.superview.frame.size.width-(self.frame.origin.x*2)),frame.size.height));

		//RTL support (centering is off otherwise, but Y was fine)
		if([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft){
			%orig(CGRectMake(frame.origin.x+30, frame.origin.y-225, (self.superview.frame.size.width-(self.frame.origin.x*2)+6),frame.size.height));
		}
	}
	else{
		%orig;
	}
}
%end


//Get high-res artwork -- taken from Krit's Garden (https://github.com/KritantaDev/Garden) 
%hook MPUNowPlayingController
- (MPUNowPlayingController*)init{
    id orig = %orig();

    if (orig) {
        [VinylManager sharedManager].MPUNowPlaying = orig;
    }
    return orig;
}

%new
+ (id)_current_MPUNowPlayingController{
    return [VinylManager sharedManager].MPUNowPlaying;
}

%new
+ (id)currentArtwork{
    if (![VinylManager sharedManager].MPUNowPlaying){

        MPUNowPlayingController *nowPlayingController = [[%c(MPUNowPlayingController) alloc] init];
        [nowPlayingController startUpdating];
        return [nowPlayingController currentNowPlayingArtwork];
    }

    return [[VinylManager sharedManager].MPUNowPlaying currentNowPlayingArtwork];
}
%end 


//set higher res artwork image to enlarged imageview (120x120)
%hook MRPlatterViewController
-(void)_updateOnScreenForStyle:(long long)arg1 {//method called only once per visual change to player (aka new song info)
	%orig;

	if(isEnabled && [self.label isEqualToString:@"MRPlatter-CoverSheet"])  {
		double delayInSeconds = 0.1;	
    	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
			[self.nowPlayingHeaderView.artworkView setImage:[%c(MPUNowPlayingController) currentArtwork]];
		});
	} 
}
%end


%hook MediaControlsHeaderView
//fix size to fit the now moved routing button 
- (void)setFrame:(CGRect)frame{
	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if(![controller respondsToSelector:@selector(delegate)]) {
		%orig;
	}
	else{
		if(isEnabled && [controller.delegate isKindOfClass:%c(CSMediaControlsViewController)] && showConnectButton) {
			%orig(CGRectMake(frame.origin.x, 10.5, frame.size.width, frame.size.height));
		}
		else{
			%orig(CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height));  
		}
	}
}


//aligment + changes size of album art
-(void)layoutSubviews{
	%orig;

	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if(![controller respondsToSelector:@selector(delegate)]) {
		%orig;
	}
	else{
		if(isEnabled && [controller.delegate isKindOfClass:%c(CSMediaControlsViewController)]){
			self.routeLabel.frame = CGRectMake(self.routeLabel.frame.origin.x*1.525604167, self.routeLabel.frame.origin.y-10, self.routeLabel.frame.size.width, self.routeLabel.frame.size.height);
			[self.primaryMarqueeView.leftAnchor constraintEqualToAnchor:self.routeLabel.leftAnchor].active = true;
			[self.secondaryMarqueeView.leftAnchor constraintEqualToAnchor:self.routeLabel.leftAnchor].active = true;
			self.primaryMarqueeView.frame = CGRectMake(self.primaryMarqueeView.frame.origin.x+49.5, self.primaryMarqueeView.frame.origin.y-13.5, self.primaryMarqueeView.frame.size.width+3, self.primaryMarqueeView.frame.size.height);
			self.secondaryMarqueeView.frame = CGRectMake(self.secondaryMarqueeView.frame.origin.x+49.5, self.secondaryMarqueeView.frame.origin.y-13.5, self.secondaryMarqueeView.frame.size.width+3, self.secondaryMarqueeView.frame.size.height);

			self.routingButton.frame = CGRectMake((self.routeLabel.frame.origin.x-13.5), self.routeLabel.frame.origin.y+1, self.routingButton.frame.size.width, self.routingButton.frame.size.height);

			[self.artworkView setFrame:(CGRectMake(self.artworkView.frame.origin.x-16, self.artworkView.frame.origin.y-18, 120, 120))];
			[self.artworkBackground setFrame:self.artworkView.frame];
			[self.placeholderArtworkView setFrame:(CGRectMake(0, 0, (self.artworkBackground.frame.size.width*.48), (self.artworkBackground.frame.size.height*.48)))]; 
			[self.placeholderArtworkView setCenter:self.artworkBackground.center];
			[self.shadow setFrame:self.placeholderArtworkView.frame];

			self.artworkView.layer.cornerRadius = cornerRadius-8;//13 is default for player and 5 is default for artwork, so I cover the difference
			self.artworkBackground.layer.cornerRadius = cornerRadius-8;
			self.placeholderArtworkView.layer.cornerRadius = cornerRadius-8;

			//RTL support 
			if([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft){
				self.routeLabel.frame = CGRectMake(self.routeLabel.frame.origin.x-89, self.routeLabel.frame.origin.y+5, self.routeLabel.frame.size.width, self.routeLabel.frame.size.height);
				[self.primaryMarqueeView.leftAnchor constraintEqualToAnchor:self.routeLabel.leftAnchor].active = true;
				[self.secondaryMarqueeView.leftAnchor constraintEqualToAnchor:self.routeLabel.leftAnchor].active = true;
				self.primaryMarqueeView.frame = CGRectMake(self.primaryMarqueeView.frame.origin.x-106, self.primaryMarqueeView.frame.origin.y+2.5, self.primaryMarqueeView.frame.size.width+3, self.primaryMarqueeView.frame.size.height);
				self.secondaryMarqueeView.frame = CGRectMake(self.secondaryMarqueeView.frame.origin.x-106, self.secondaryMarqueeView.frame.origin.y+2.5, self.secondaryMarqueeView.frame.size.width+3, self.secondaryMarqueeView.frame.size.height);

				self.routingButton.frame = CGRectMake((self.routeLabel.frame.origin.x+self.routeLabel.frame.size.width-25), self.routeLabel.frame.origin.y+2, self.routingButton.frame.size.width, self.routingButton.frame.size.height);

				[self.artworkView setFrame:(CGRectMake(self.artworkView.frame.origin.x-28, self.artworkView.frame.origin.y, 120, 120))];
				[self.artworkBackground setFrame:self.artworkView.frame];
				[self.placeholderArtworkView setFrame:(CGRectMake(self.placeholderArtworkView.frame.origin.x-28, self.placeholderArtworkView.frame.origin.y, self.placeholderArtworkView.frame.size.width, self.placeholderArtworkView.frame.size.height))];
				[self.shadow setFrame:self.placeholderArtworkView.frame];
			}

			//Small form factor device support 
			if(kHeight == 568){
				self.routeLabel.frame = CGRectMake(self.routeLabel.frame.origin.x-13, self.routeLabel.frame.origin.y+2, self.routeLabel.frame.size.width, self.routeLabel.frame.size.height);
				[self.primaryMarqueeView.leftAnchor constraintEqualToAnchor:self.routeLabel.leftAnchor].active = true;
				[self.secondaryMarqueeView.leftAnchor constraintEqualToAnchor:self.routeLabel.leftAnchor].active = true;
				self.primaryMarqueeView.frame = CGRectMake(self.primaryMarqueeView.frame.origin.x-13, self.primaryMarqueeView.frame.origin.y, self.primaryMarqueeView.frame.size.width, self.primaryMarqueeView.frame.size.height);
				self.secondaryMarqueeView.frame = CGRectMake(self.secondaryMarqueeView.frame.origin.x-13, self.secondaryMarqueeView.frame.origin.y, self.secondaryMarqueeView.frame.size.width, self.secondaryMarqueeView.frame.size.height);

				self.routingButton.frame = CGRectMake(self.routingButton.frame.origin.x-15, self.routeLabel.frame.origin.y+1, self.routingButton.frame.size.width, self.routingButton.frame.size.height);

				[self.artworkView setFrame:(CGRectMake(self.artworkView.frame.origin.x, self.artworkView.frame.origin.y+10, 100, 100))];	
				[self.artworkBackground setFrame:self.artworkView.frame];
				[self.placeholderArtworkView setFrame:(CGRectMake(0, 0, (self.artworkBackground.frame.size.width*.48), (self.artworkBackground.frame.size.height*.48)))]; 
				[self.placeholderArtworkView setCenter:self.artworkBackground.center];
				[self.shadow setCenter:self.placeholderArtworkView.center];
			}

				//correction for header Y movement and rountingbutton presence
				if(showConnectButton){
					self.routeLabel.frame = CGRectMake(self.routeLabel.frame.origin.x+13, self.routeLabel.frame.origin.y+13.5, self.routeLabel.frame.size.width, self.routeLabel.frame.size.height);
					self.primaryMarqueeView.frame = CGRectMake(self.primaryMarqueeView.frame.origin.x, self.primaryMarqueeView.frame.origin.y+13.5, self.primaryMarqueeView.frame.size.width, self.primaryMarqueeView.frame.size.height);
					self.secondaryMarqueeView.frame = CGRectMake(self.secondaryMarqueeView.frame.origin.x, self.secondaryMarqueeView.frame.origin.y+13.5, self.secondaryMarqueeView.frame.size.width, self.secondaryMarqueeView.frame.size.height);

					//needs further correction because of ^
					if([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft){
						self.routeLabel.frame = CGRectMake(self.routeLabel.frame.origin.x-26, self.routeLabel.frame.origin.y, self.routeLabel.frame.size.width, self.routeLabel.frame.size.height);
					}

					[self.artworkView setFrame:(CGRectMake(self.artworkView.frame.origin.x, self.artworkView.frame.origin.y+13.5, self.artworkView.frame.size.width, self.artworkView.frame.size.height))];
					[self.artworkBackground setFrame:self.artworkView.frame];
					[self.placeholderArtworkView setFrame:(CGRectMake(self.placeholderArtworkView.frame.origin.x, self.placeholderArtworkView.frame.origin.y+13.5, self.placeholderArtworkView.frame.size.width, self.placeholderArtworkView.frame.size.height))];
					[self.shadow setCenter:self.placeholderArtworkView.center];
				}	
		}
		else{
			%orig;
		}
	}
}

//coloring + hide or show routingButton
-(void)_updateStyle{
	%orig;

	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if(![controller respondsToSelector:@selector(delegate)]) {
		%orig;
	}
	else{
		if(isEnabled && [controller.delegate isKindOfClass:%c(CSMediaControlsViewController)]){
			self.routingButton.packageView.scale = .325;
			if(textcolor == 1){
				if(self.routeLabel.layer.filters.count) self.routeLabel.layer.filters = nil;
				if(self.routeLabel.titleLabel.layer.filters.count) self.routeLabel.titleLabel.layer.filters = nil;
				self.routeLabel.textColor = [UIColor colorWithWhite:1 alpha:0.9];
				self.routeLabel.titleLabel.textColor = [UIColor colorWithWhite:1 alpha:0.9];

				if(MSHookIvar<UILabel*>(self, "_secondaryLabel").layer.filters.count) MSHookIvar<UILabel*>(self, "_secondaryLabel").layer.filters = nil;
				MSHookIvar<UILabel*>(self, "_secondaryLabel").textColor = [UIColor colorWithWhite:1 alpha:0.9];

				self.primaryLabel.textColor = [UIColor colorWithWhite:1 alpha:0.9];

				[self.routingButton setOverrideUserInterfaceStyle:2];
			}
			if(textcolor == 2){
				if(self.routeLabel.layer.filters.count) self.routeLabel.layer.filters = nil;
				if(self.routeLabel.titleLabel.layer.filters.count) self.routeLabel.titleLabel.layer.filters = nil;
				self.routeLabel.textColor = [UIColor colorWithWhite:0 alpha:0.9];
				self.routeLabel.titleLabel.textColor = [UIColor colorWithWhite:0 alpha:0.9];

				if(MSHookIvar<UILabel*>(self, "_secondaryLabel").layer.filters.count) MSHookIvar<UILabel*>(self, "_secondaryLabel").layer.filters = nil;
				MSHookIvar<UILabel*>(self, "_secondaryLabel").textColor = [UIColor colorWithWhite:0 alpha:0.9];

				self.primaryLabel.textColor = [UIColor colorWithWhite:0 alpha:0.9];

				[self.routingButton setOverrideUserInterfaceStyle:1];
			}
			if(textcolor == 0){//default	
				//second label's OG color is consistent for some reason, so base off that
				self.primaryLabel.textColor = self.secondaryLabel.textColor;
				self.routeLabel.textColor = self.secondaryLabel.textColor;
				self.routeLabel.titleLabel.textColor = self.secondaryLabel.textColor;

				[self.routingButton setOverrideUserInterfaceStyle:0];
			}
			if(showConnectButton){
				[self.launchNowPlayingAppButton setHidden:YES];//otherwise covers routing button
				[self.routingButton setHidden:NO];
			}
			if(!showConnectButton){
				[self.routingButton setHidden:YES];
			}
			if(stndRouteLabel){
				self.routeLabel.forcesUppercaseText = NO;
			}
		}
		else{
			%orig;
		}
	}
}
%end


//moves media controls up (past constraints)										
%hook MediaControlsParentContainerView 
- (void)setFrame:(CGRect)frame{
	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if(isEnabled && [controller.delegate isKindOfClass:%c(CSMediaControlsViewController)]){
		%orig(CGRectMake(frame.origin.x, frame.origin.y-29.5, frame.size.width, frame.size.height));
	}
	else{
		%orig;
	}
}
%end


//NextUp2 compatibility (MAKE SURE "Slimmed Mode (LS") is ON)

//brings nextup view up
%hook CSMediaControlsView 
-(void)setFrame:(CGRect)frame{
	if(isEnabled && nxtUpInstalled){
		%orig(CGRectMake(frame.origin.x,-102.5,frame.size.width,frame.size.height));
	}
	else{
		%orig;
	}
}
%end


//pushes down music player (compensates for ^)
%hook BoundsChangeAwareView 
-(void)setFrame:(CGRect)frame{
	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if(isEnabled && nxtUpInstalled && [controller.delegate isKindOfClass:%c(CSMediaControlsViewController)]){
		%orig(CGRectMake(frame.origin.x,frame.origin.y+102.5,frame.size.width,frame.size.height));
	}
	else{
		%orig;
	}
}
%end


%hook NextUpMediaHeaderView
//sets up artworkView
-(void)updateArtworkStyle{
	%orig;

	if(isEnabled && nxtUpInstalled && [self.superview.superview.superview isMemberOfClass:%c(CSMediaControlsView)]){
		double delayInSeconds = 0.1;	
    	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
			[self.artworkView setImage:[%c(MPUNowPlayingController) currentArtwork]];
		});
		[self.artworkView setFrame:CGRectMake(-16,-9,120,120)];
		[self.placeholderArtworkView setFrame:self.artworkView.frame];
		[self.artworkBackground setFrame:self.artworkView.frame];
		self.artworkView.layer.cornerRadius = cornerRadius-8;//13 is default for player and 5 is default for artwork, so I cover the difference
		self.placeholderArtworkView.layer.cornerRadius = cornerRadius-8;
		self.artworkBackground.layer.cornerRadius = cornerRadius-8;
		[self.shadow setHidden:YES];

		//RTL Support
		if([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft){
			[self.artworkView setFrame:CGRectMake(-44,-9.5,120,120)];
			[self.placeholderArtworkView setFrame:self.artworkView.frame];
			[self.artworkBackground setFrame:self.artworkView.frame];
		}

		//Small form factor device support 
		if(kHeight == 568){
			[self.artworkView setFrame:CGRectMake(-16,0,100,100)];
			[self.placeholderArtworkView setFrame:self.artworkView.frame];
			[self.artworkBackground setFrame:self.artworkView.frame];
		}
	}
	else{
		%orig;
	}
}

//set label frames
-(void)layoutSubviews{
	%orig;

	if(isEnabled && nxtUpInstalled && [self.superview.superview.superview isMemberOfClass:%c(CSMediaControlsView)]){
		CGRect nextup2 = self.primaryMarqueeView.frame;
		CGRect nextup3 = self.secondaryMarqueeView.frame;
		[self.primaryMarqueeView setFrame:CGRectMake(nextup2.origin.x+49,nextup2.origin.y,nextup2.size.width,nextup2.size.height)];
		[self.secondaryMarqueeView setFrame:CGRectMake(nextup3.origin.x+49,nextup3.origin.y,nextup3.size.width,nextup3.size.height)];

			//RTL Support
			if([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft){
				[self.primaryMarqueeView setFrame:CGRectMake((nextup2.origin.x-self.artworkView.frame.size.width-nextup2.size.width),nextup2.origin.y,nextup2.size.width,nextup2.size.height)];
				[self.secondaryMarqueeView setFrame:CGRectMake((nextup3.origin.x-self.artworkView.frame.size.width-nextup3.size.width),nextup3.origin.y,nextup3.size.width,nextup3.size.height)];
			}
			
			//Small form factor device support 
			if(kHeight == 568){
				[self.primaryMarqueeView setFrame:CGRectMake(nextup2.origin.x+34.5,nextup2.origin.y,nextup2.size.width,nextup2.size.height)];
				[self.secondaryMarqueeView setFrame:CGRectMake(nextup3.origin.x+34.5,nextup3.origin.y,nextup3.size.width,nextup3.size.height)];
			}
	}
	else{
		%orig;
	}
}

//colors and orients elements 
-(void)_updateStyle{
	%orig;

	if(isEnabled && nxtUpInstalled && [self.superview.superview.superview isMemberOfClass:%c(CSMediaControlsView)]){
		if(textcolor == 1){
			if(MSHookIvar<UILabel*>(self, "_secondaryLabel").layer.filters.count) MSHookIvar<UILabel*>(self, "_secondaryLabel").layer.filters = nil;
			MSHookIvar<UILabel*>(self, "_secondaryLabel").textColor = [UIColor colorWithWhite:1 alpha:0.9];
			self.primaryLabel.textColor = [UIColor colorWithWhite:1 alpha:0.9];

			self.routingButton.clear.strokeColor = [UIColor colorWithWhite:1 alpha:0.9].CGColor;//"x"
		}

		if(textcolor == 2){
			if(MSHookIvar<UILabel*>(self, "_secondaryLabel").layer.filters.count) MSHookIvar<UILabel*>(self, "_secondaryLabel").layer.filters = nil;
			MSHookIvar<UILabel*>(self, "_secondaryLabel").textColor = [UIColor colorWithWhite:0 alpha:0.9];
			self.primaryLabel.textColor = [UIColor colorWithWhite:0 alpha:0.9];

			self.routingButton.clear.strokeColor = [UIColor colorWithWhite:0 alpha:0.9].CGColor;//"x"
		}

		if(textcolor == 0){//default	
			%orig;
			self.primaryLabel.textColor = self.secondaryLabel.textColor;//second label's OG color is consistent for some reason, so base off that
		}
	}
	else{
		%orig;
	}
}
%end



//	PREFERENCES 
static void loadPrefs() {
  NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/me.lightmann.vinylprefs.plist"];

  if(prefs){
    isEnabled = ( [prefs objectForKey:@"isEnabled"] ? [[prefs objectForKey:@"isEnabled"] boolValue] : YES );
	configuration = ( [prefs valueForKey:@"configuration"] ? [[prefs valueForKey:@"configuration"] integerValue] : 0 );
	showConnectButton = ( [prefs objectForKey:@"showConnectButton"] ? [[prefs objectForKey:@"showConnectButton"] boolValue] : NO );
	stndRouteLabel = ( [prefs objectForKey:@"stndRouteLabel"] ? [[prefs objectForKey:@"stndRouteLabel"] boolValue] : NO );
	cornerRadius = ( [prefs valueForKey:@"cornerRadius"] ? [[prefs valueForKey:@"cornerRadius"] floatValue] : 13 );
	transparencyLevel = ( [prefs valueForKey:@"transparencyLevel"] ? [[prefs valueForKey:@"transparencyLevel"] floatValue] : 100 );
	textcolor = ( [prefs valueForKey:@"textcolor"] ? [[prefs valueForKey:@"textcolor"] integerValue] : 0 );
  }
}

static void initPrefs() {
  // Copy the default preferences file when the actual preference file doesn't exist
  NSString *path = @"/User/Library/Preferences/me.lightmann.vinylprefs.plist";
  NSString *pathDefault = @"/Library/PreferenceBundles/VinylPrefs.bundle/defaults.plist";
  NSFileManager *fileManager = [NSFileManager defaultManager];
  if(![fileManager fileExistsAtPath:path]) {
    [fileManager copyItemAtPath:pathDefault toPath:path error:nil];
  }
}

%ctor {
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("me.lightmann.vinylprefs-updated"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	initPrefs();
	loadPrefs();

	//Check if nextup2 is installed
	nxtUpInstalled = [[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/se.nosskirneh.nextup2.list"];
}
