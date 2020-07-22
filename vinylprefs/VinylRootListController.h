//Header image code from (Alexa) Litten (https://github.com/Litteeen) -- W appropriately attached MIT license
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSControlTableCell.h>

@interface VinylRootListController : PSListController{
    UITableView * _table;
}
@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, retain) UIImageView *headerImageView;
@end
