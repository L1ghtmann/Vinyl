//By KritantaDev (https://github.com/kritantadev)
#import "VinylTableCell.h"

@interface VinylLinkCell : VinylTableCell
@property (nonatomic, readonly) BOOL isBig;
@property (nonatomic, retain, readonly) UIView *avatarView;
@property (nonatomic, retain, readonly) UIImageView *avatarImageView;
@property (nonatomic, retain) UIImage *avatarImage;
@end