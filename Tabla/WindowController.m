#import "WindowController.h"

@implementation WindowController

enum	// popup tag choices
{
	kImageView = 0,
	kTableView,
	kVideoView,
	kCameraView
};

NSString *const kViewTitle		= @"CustomImageView";

// -------------------------------------------------------------------------------
//	initWithPath:newPath
// -------------------------------------------------------------------------------
- initWithPath:(NSString *)newPath
{
    return [super initWithWindowNibName:@"Tabla"];
}

@end
