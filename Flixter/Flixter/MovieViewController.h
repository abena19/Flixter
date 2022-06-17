//
//  ViewController.h
//  Flixter
//
//  Created by Abena Ofosu on 6/15/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MovieViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityindicator;



@end

NS_ASSUME_NONNULL_END

