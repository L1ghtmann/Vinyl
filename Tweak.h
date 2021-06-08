#import <UIKit/UIKit.h>
#import <MediaRemote/MediaRemote.h>

// https://stackoverflow.com/a/5337804
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface UIView (Private)
-(UIViewController *)_viewControllerForAncestor;
-(void)setOverrideUserInterfaceStyle:(NSInteger)style;
@end

@interface MTMaterialView : UIView
@end

@interface PLPlatterView : UIView
@property (nonatomic,readonly) MTMaterialView * backgroundMaterialView; // iOS 12
@property (nonatomic,readonly) MTMaterialView * mainOverlayView; // iOS 12

@property (nonatomic,retain) MTMaterialView * backgroundView;
@end

@interface SBDashBoardAdjunctItemView : UIView{ // player iOS 12
	UIView* _platterView;
}
@end

@interface CSAdjunctItemView : UIView{ // player iOS 13 & 14
	UIView* _platterView;
}
@end

@interface SBDashBoardMediaControlsViewController : UIViewController // iOS 12
@end

@interface CSMediaControlsViewController : UIViewController // iOS 13
@end

@interface MediaControlsTimeControl : UIView // iOS 12 & 13
@property (nonatomic,retain) UILabel * elapsedTimeLabel;
@property (nonatomic,retain) UILabel * remainingTimeLabel;
@property (nonatomic,retain) UIView * elapsedTrack;
@property (nonatomic,retain) UIView * knobView;
@property (nonatomic,retain) UIView * remainingTrack;
@end

@interface MRUNowPlayingTimeControlsView : UIView // iOS 14
@property (nonatomic,retain) UILabel * elapsedTimeLabel;
@property (nonatomic,retain) UILabel * remainingTimeLabel;
@property (nonatomic,retain) UIView * elapsedTrack;
@property (nonatomic,retain) UIView * knobView;
@property (nonatomic,retain) UIView * remainingTrack;
@end

@interface MPVolumeSlider : UISlider
@property (nonatomic,readonly) UIView * thumbView;
@end

@interface MediaControlsVolumeSlider : MPVolumeSlider // iOS 12 & 13
-(void)setVisualStylingProvider:(id)arg1;
@end

@interface MRUNowPlayingVolumeSlider : MPVolumeSlider // iOS 14
-(void)setVisualStylingProvider:(id)arg1;
@property (nonatomic,readonly) UIView * growingThumbView;
@end

@interface MediaControlsVolumeContainerView : UIView // iOS 12 & 13
@property (nonatomic,retain) MediaControlsVolumeSlider * volumeSlider;
@end

@interface MRUNowPlayingVolumeControlsView : UIView // iOS 14
@property (nonatomic,retain) MRUNowPlayingVolumeSlider * slider;
@end

@interface MediaControlsTransportButton : UIButton // iOS 12 & 13
@property (nonatomic,retain) UIImageView *imageView;
@end

@interface MRUTransportButton : UIButton // iOS 14
@property (nonatomic,retain) UIImageView *imageView;
-(void)setStylingProvider:(id)arg1;
@end

@interface MediaControlsTransportStackView : UIView // iOS 12 & 13
@property (nonatomic,retain) MediaControlsTransportButton * tvRemoteButton;
@property (nonatomic,retain) MediaControlsTransportButton * leftButton;
@property (nonatomic,retain) MediaControlsTransportButton * middleButton;
@property (nonatomic,retain) MediaControlsTransportButton * rightButton;
@property (nonatomic,retain) MediaControlsTransportButton * languageOptionsButton;
@end

@interface MRUNowPlayingTransportControlsView : UIView // iOS 14
@property (nonatomic,retain) MRUTransportButton * tvRemoteButton;
@property (nonatomic,retain) MRUTransportButton * leftButton;
@property (nonatomic,retain) MRUTransportButton * middleButton;
@property (nonatomic,retain) MRUTransportButton * rightButton;
@property (nonatomic,retain) MRUTransportButton * languageOptionsButton;
@end

@interface MediaControlsParentContainerView : UIView
@end

@interface CCUICAPackageView : UIView
@property (assign,nonatomic) double scale; // only avaialble on iOS 13
@end

@interface MediaControlsRoutingButtonView : UIButton // iOS 12 & 13
@property (nonatomic,retain) CCUICAPackageView * packageView;
@end

@interface MRUNowPlayingRoutingButton : UIButton // iOS 14
@property (nonatomic,retain) CCUICAPackageView * packageView;
@end

@interface MPRouteLabel : UILabel
@property (nonatomic,retain) UILabel * titleLabel;
@property (assign,nonatomic) BOOL forcesUppercaseText;
@end

@interface MPUMarqueeView : UIView
@property (nonatomic,readonly) UIView * contentView;
-(void)setMarqueeEnabled:(BOOL)arg1;
@property (assign,nonatomic) double contentGap;
-(void)setContentGap:(double)contentGap;
@property (assign,nonatomic) UIEdgeInsets fadeEdgeInsets;
-(void)setFadeEdgeInsets:(UIEdgeInsets)fadeEdgeInsets;
@end

@interface MRUNowPlayingLabelView : UIView
@property (nonatomic,retain) UILabel * titleLabel;
@property (nonatomic,retain) UILabel * subtitleLabel;
@property (nonatomic,retain) MPUMarqueeView * titleMarqueeView;
@property (nonatomic,retain) MPUMarqueeView * subtitleMarqueeView;
@property (nonatomic,retain) MPRouteLabel * routeLabel;
@end

@interface MRUArtworkView : UIView
@property (nonatomic, retain) UIImage *iconImage;
@property (nonatomic,retain) UIImageView * iconView; // src icon
@property (nonatomic, retain) UIView *iconShadowView;
@property (nonatomic, retain) UIImage *placeholderImage;
@property (nonatomic,retain) UIImageView * placeholderImageView;
@property (nonatomic, retain) UIView *placeholderBackground;
@property (nonatomic, retain) UIImage *artworkImage;
@property (nonatomic, retain) UIImageView *artworkImageView;
@property (nonatomic, retain) UIView *artworkShadowView;
@end

@interface MediaControlsHeaderView : UIView{ // iOS 12 & 13
	UILabel* _secondaryLabel;
}
@property (nonatomic,retain) UIImageView * artworkView;
@property (nonatomic,retain) UIImageView * placeholderArtworkView;
@property (nonatomic,retain) UIView * shadow;
@property (nonatomic,retain) MTMaterialView * artworkBackground;
@property (nonatomic,retain) UILabel * primaryLabel;
@property (nonatomic,retain) UILabel * secondaryLabel;
@property (nonatomic,retain) MPUMarqueeView * primaryMarqueeView;
@property (nonatomic,retain) MPUMarqueeView * secondaryMarqueeView;
@property (nonatomic,retain) MPRouteLabel * routeLabel;
@property (nonatomic,retain) MediaControlsRoutingButtonView * routingButton;
@property (nonatomic,retain) UIButton * launchNowPlayingAppButton;
@end

@interface MRUNowPlayingHeaderView : UIView // iOS 14
@property (nonatomic,retain) MRUArtworkView * artworkView;
@property (nonatomic,retain) MRUNowPlayingLabelView * labelView;
@property (nonatomic,retain) MRUNowPlayingRoutingButton * routingButton;
@property (nonatomic,retain) MRUTransportButton * transportButton;
@end

@interface MRUNowPlayingControlsView : UIView
@property (nonatomic, retain) MRUNowPlayingHeaderView *headerView;
@property (nonatomic, retain) MRUNowPlayingTimeControlsView *timeControlsView;
@property (nonatomic, retain) MRUNowPlayingTransportControlsView *transportControlsView;
@property (nonatomic, retain) MRUNowPlayingVolumeControlsView *volumeControlsView;
@end

@interface MRUNowPlayingView : UIView
@property (nonatomic, retain) MRUNowPlayingControlsView *controlsView;
@end

@interface MRPlatterViewController : UIViewController // iOS 12 & 13
@property (assign,nonatomic) id delegate;
@property (nonatomic,retain) MediaControlsParentContainerView * parentContainerView;
@property (nonatomic,copy) NSString * label;
@property (nonatomic,retain) MediaControlsHeaderView * nowPlayingHeaderView;
@end

@interface MRUNowPlayingViewController : UIViewController // iOS 14
@property (assign,nonatomic) id delegate;  // LS has no delegate, but CC does
@property (nonatomic,readonly) int context; // 2 on LS || 1 on CC
@property (nonatomic, retain) MRUNowPlayingView *viewIfLoaded; // middle-man view
@end

UIImage *highresImage; // iOS 12 & 13

// prefs
static BOOL isEnabled;

static int configuration;
static BOOL showConnectButton;
static BOOL stndRouteLabel;
static BOOL hideSrcIcon;

static CGFloat cornerRadius;

static CGFloat controlSpacing;

static CGFloat transparencyLevel;

static int textcolor;
