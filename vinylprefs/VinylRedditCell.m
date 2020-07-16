#import "VinylRedditCell.h" 
#import <Preferences/PSSpecifier.h>
#import <UIKit/UIImage+Private.h>
#import <Foundation/Foundation.h>

@interface VinylLinkCell ()

- (BOOL)shouldShowAvatar;

@end

@interface VinylRedditCell () {
	NSString *_user;
}

@end

@implementation VinylRedditCell

+ (NSString *)_urlForUsername:(NSString *)user {

	user = [user stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

	  if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"reddit://"]]) {
		return [@"reddit:///user/" stringByAppendingString:user];
	} else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"apollo://"]]) {
		return [@"apollo:///user/" stringByAppendingString:user];
	} else {
		return [@"https://reddit.com/u/" stringByAppendingString:user];
	}
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier 
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

	if (self) {
		UIImageView *imageView = (UIImageView *)self.accessoryView;
		imageView.image = nil;
		[imageView sizeToFit];

		_user = [specifier.properties[@"accountName"] copy];
		NSAssert(_user, @"User name not provided");

		specifier.properties[@"url"] = [self.class _urlForUsername:_user];

		self.detailTextLabel.text = [@"@" stringByAppendingString:_user];

		[self setCellEnabled:YES];

		[self loadAvatarIfNeeded];
	}

	return self;
}

- (void)setSelected:(BOOL)arg1 animated:(BOOL)arg2
{
	[super setSelected:arg1 animated:arg2];

	if (!arg1) return;
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self.class _urlForUsername:_user]] options:@{} completionHandler:nil];
}

#pragma mark - Avatar

- (BOOL)shouldShowAvatar {
	// HBLinkTableCell doesn’t want avatars by default, but we do. override its check method so that
	// if showAvatar is unset, we return YES
	return YES;
}

- (void)loadAvatarIfNeeded {
	if (!_user) {
		return;
	}

	if (self.avatarImage) {
		return;
	}
	self.avatarImage = [UIImage imageNamed:[NSString stringWithFormat:@"/Library/PreferenceBundles/VinylPrefs.bundle/%@.png", _user]];
}

@end