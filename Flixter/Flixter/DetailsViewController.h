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
@property (weak, nonatomic) IBOutlet UILabel *detailTitle;
@property (weak, nonatomic) IBOutlet UILabel *detailSynopsis;
@property (weak, nonatomic) IBOutlet UIImageView *detailImage;

@property (weak, nonatomic)IBOutlet NSDictionary *detailDict;
@end

NS_ASSUME_NONNULL_END
