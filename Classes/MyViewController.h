

#import <UIKit/UIKit.h>


@interface MyViewController : UIViewController {
    UILabel *pageNumberLabel;
    int pageNumber;
	BOOL pop_;
}

@property (nonatomic, retain) IBOutlet UILabel *pageNumberLabel;

- (id)initWithPageNumber:(int)page pop:(BOOL)pop;

- (IBAction)pop:(id)sender;

@end
