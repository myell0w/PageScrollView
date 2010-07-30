

#import <UIKit/UIKit.h>


@interface MyViewController : UIViewController {
    UILabel *pageNumberLabel;
    int pageNumber;
}

@property (nonatomic, retain) IBOutlet UILabel *pageNumberLabel;

- (id)initWithPageNumber:(int)page;

- (IBAction)pop:(id)sender;

@end
