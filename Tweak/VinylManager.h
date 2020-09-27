#import <UIKit/UIKit.h>
#import "Headers.h"

@interface VinylManager : NSObject
+ (instancetype)sharedManager;
@property (nonatomic, retain) MPUNowPlayingController *MPUNowPlaying;
@end 
