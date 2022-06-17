//
//  DetailsViewController.h
//  Flixter
//
//  Created by Abena Ofosu on 6/17/22.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h" // fetching movie data?

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *postImageScrollView;
@property (weak, nonatomic) IBOutlet UILabel *postSynopsis;
@property (weak, nonatomic)IBOutlet NSDictionary *detailDict;
@end

NS_ASSUME_NONNULL_END
