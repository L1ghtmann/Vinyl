#import "VinylLinkCell.h"
#import <Preferences/PSSpecifier.h>
#import <UIKit/UIColor+Private.h>
#import <UIKit/UIImage+Private.h>
#import <version.h>

@implementation VinylLinkCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier 
{
	self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier specifier:specifier];

	if (self) {

		_isBig = YES;

		self.selectionStyle = UITableViewCellSelectionStyleBlue;
		self.accessoryView = [[UIImageView alloc] initWithFrame:CGRectMake( 0, 0, 38, 38)];

		self.detailTextLabel.numberOfLines = _isBig ? 0 : 1;
		self.detailTextLabel.text = specifier.properties[@"subtitle"] ?: @"";
		self.detailTextLabel.textColor = (kCFCoreFoundationVersionNumber < 1600) ? [UIColor grayColor] : [UIColor grayColor];

		self.textLabel.textColor = (kCFCoreFoundationVersionNumber < 1600) ? [UIColor blackColor] : [UIColor blackColor];
		if (@available(iOS 13, *)) 
		{
			self.tintColor = [UIColor labelColor];
		} 
		else 
		{
			self.tintColor = [UIColor blackColor];
		}

		if (self.shouldShowAvatar) 
		{
			CGFloat size = _isBig ? 38.f : 29.f;

			UIGraphicsBeginImageContextWithOptions(CGSizeMake(size, size), NO, [UIScreen mainScreen].scale);
			specifier.properties[@"iconImage"] = UIGraphicsGetImageFromCurrentImageContext();
			UIGraphicsEndImageContext();

			_avatarView = [[UIView alloc] initWithFrame:self.imageView.bounds];
			_avatarView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
			_avatarView.userInteractionEnabled = NO;
			_avatarView.clipsToBounds = YES;
			_avatarView.layer.cornerRadius = IS_IOS_OR_NEWER(iOS_7_0) ? size / 2 : 4.f;
			
			[self.imageView addSubview:_avatarView];

			if (specifier.properties[@"initials"]) 
			{
				_avatarView.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1];

				UILabel *label = [[UILabel alloc] initWithFrame:_avatarView.bounds];
				label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
				label.font = [UIFont systemFontOfSize:13.f];
				label.textAlignment = NSTextAlignmentCenter;
				label.textColor = [UIColor whiteColor];
				label.text = specifier.properties[@"initials"];
				[_avatarView addSubview:label];
			} 
			else 
			{
				_avatarImageView = [[UIImageView alloc] initWithFrame:_avatarView.bounds];
				_avatarImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
				_avatarImageView.alpha = 0;
				_avatarImageView.userInteractionEnabled = NO;
				_avatarImageView.layer.minificationFilter = kCAFilterTrilinear;
				[_avatarView addSubview:_avatarImageView];

				[self loadAvatarIfNeeded];
			}
		}
	}

	return self;
}

#pragma mark - Avatar

- (UIImage *)avatarImage 
{
	return _avatarImageView.image;
}

- (void)setAvatarImage:(UIImage *)avatarImage 
{
	_avatarImageView.image = avatarImage;

	if (_avatarImageView.alpha == 0) 
	{
		[UIView animateWithDuration:0.15 
			animations:^{
				_avatarImageView.alpha = 1;
			}
		];
	}
}
- (void)setSelected:(BOOL)arg1 animated:(BOOL)arg2
{
	[super setSelected:arg1 animated:arg2];

	if (!arg1) return;
}

- (BOOL)shouldShowAvatar 
{
	return (self.specifier.properties[@"showAvatar"] && ((NSNumber *)self.specifier.properties[@"showAvatar"]).boolValue) ||
		self.specifier.properties[@"initials"];
}

- (void)loadAvatarIfNeeded 
{
	// stub for subclasses
}

@end