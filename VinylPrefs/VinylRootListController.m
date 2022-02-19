#include "VinylRootListController.h"
#import <spawn.h>

@implementation VinylRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

- (void)viewWillAppear:(BOOL)animated {
	[[UISwitch appearanceWhenContainedInInstancesOfClasses:@[self.class]] setOnTintColor:[UIColor colorWithRed:0.0 green:0.680 blue:0.999 alpha:1.0]];
	[super viewWillAppear:animated];
}

- (void)respring:(id)sender {
	pid_t pid;
	const char *args[] = {"sbreload", NULL, NULL, NULL};
	posix_spawn(&pid, "/usr/bin/sbreload", NULL, NULL, (char *const *)args, NULL);
}

@end
