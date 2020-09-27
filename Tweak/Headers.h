#import <UIKit/UIKit.h>

@interface MTCoreMaterialVisualStylingProvider : NSObject
@property (nonatomic,copy,readonly) NSString * visualStyleSetName; 
@end

@interface MTVisualStylingProvider : NSObject
@property (getter=_coreMaterialVisualStylingProvider,nonatomic,retain) MTCoreMaterialVisualStylingProvider * coreMaterialVisualStylingProvider;   
@end

@interface UIView (Private)
-(void)setOverrideUserInterfaceStyle:(NSInteger)style;
- (UIViewController *)_viewControllerForAncestor;                                                                                                                               
@property (nonatomic,retain) MTVisualStylingProvider * visualStylingProvider; 
@end

@interface MTMaterialView : UIView
@end

@interface PLPlatterView : UIView
@property (nonatomic,retain) UIView * backgroundView; 
@end

@interface CSMediaControlsViewController : UIViewController
@end

@interface CSAdjunctItemView : UIView{
	UIView* _platterView;
}
@end

@interface MediaControlsTransportButton : UIButton
@property (nonatomic,retain) UIImageView *imageView;
@end

@interface MediaControlsTransportStackView : UIView
@property (nonatomic,retain) MediaControlsTransportButton * tvRemoteButton;       
@property (nonatomic,retain) MediaControlsTransportButton * leftButton;           
@property (nonatomic,retain) MediaControlsTransportButton * middleButton;         
@property (nonatomic,retain) MediaControlsTransportButton * rightButton;          
@property (nonatomic,retain) MediaControlsTransportButton * languageOptionsButton;   
@end

@interface MediaControlsParentContainerView : UIView
@property (nonatomic,retain) MediaControlsTransportStackView * transportStackView; 
@end

@interface MPUMarqueeView : UIView
@end

@interface MPRouteLabel : UILabel
@property (nonatomic,retain) UILabel * titleLabel;
@property (assign,nonatomic) BOOL forcesUppercaseText;   
@end

@interface CCUICAPackageView : UIView
@property (assign,nonatomic) double scale; 
@end

@interface MediaControlsRoutingButtonView : UIButton
@property (nonatomic,retain) CCUICAPackageView * packageView; 
@property (nonatomic,retain) CAShapeLayer * clear; //NextUp "x" (NUSkipButton)
@end

@interface MediaControlsHeaderView : UIView{
	UILabel* _secondaryLabel;
}
@property (nonatomic,retain) UIImageView * artworkView; 
@property (nonatomic,retain) UIImageView * placeholderArtworkView; 
@property (nonatomic,retain) UIView * shadow;  
@property (nonatomic,retain) MTMaterialView * artworkBackground;  
-(void)updateArtworkStyle;
@property (nonatomic,retain) UILabel * primaryLabel;                           
@property (nonatomic,retain) UILabel * secondaryLabel;            
@property (nonatomic,retain) MPUMarqueeView * primaryMarqueeView; 
-(void)setPrimaryMarqueeView:(MPUMarqueeView *)arg1;
@property (nonatomic,retain) MPUMarqueeView * secondaryMarqueeView;              
-(void)setSecondaryMarqueeView:(MPUMarqueeView *)arg1;
@property (nonatomic,retain) MPRouteLabel * routeLabel; 
-(void)setRouteLabel:(MPRouteLabel *)arg1 ;
@property (nonatomic,retain) MediaControlsRoutingButtonView * routingButton;
@property (nonatomic,retain) UIButton * launchNowPlayingAppButton;                    
@end

@interface MediaControlsTimeControl : UIView
@property (nonatomic,retain) UILabel * elapsedTimeLabel;   
@property (nonatomic,retain) UILabel * remainingTimeLabel; 
@property (nonatomic,retain) UIView * elapsedTrack;      
@property (nonatomic,retain) UIView * knobView;          
@property (nonatomic,retain) UIView * remainingTrack;    
@end

@interface MPVolumeSlider : UISlider
@property (nonatomic,readonly) UIView * thumbView; 
@end

@interface MediaControlsVolumeSlider : MPVolumeSlider
@property (nonatomic,retain) MTVisualStylingProvider * visualStylingProvider; 
@end

@interface MediaControlsVolumeContainerView : UIView
@property (nonatomic,retain) MediaControlsVolumeSlider * volumeSlider; 
@end

@interface MPUNowPlayingController : NSObject 
-(id)init;
+(id)_current_MPUNowPlayingController;
+(id)currentArtwork;
-(UIImage *)currentNowPlayingArtwork;
-(void)startUpdating;
@end

@interface MRPlatterViewController : UIViewController
@property (assign,nonatomic) id delegate; 
@property (nonatomic,retain) MediaControlsParentContainerView * parentContainerView; 
@property (nonatomic,copy) NSString * label;         
@property (nonatomic,retain) MediaControlsHeaderView * nowPlayingHeaderView;  
@end


//prefs
static BOOL isEnabled;

static int configuration;
static BOOL showConnectButton = NO;
static BOOL stndRouteLabel = NO;
static CGFloat cornerRadius;

static CGFloat transparencyLevel;

static int textcolor;


// NextUp compatibility 
@interface NextUpMediaHeaderView : MediaControlsHeaderView
@end

@interface CSMediaControlsView : UIView
@end

@interface BoundsChangeAwareView : UIView
@end

static BOOL nxtUpInstalled = NO;
