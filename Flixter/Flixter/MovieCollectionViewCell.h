//
//  MovieCollectionViewCell.h
//  Flixter
//
//  Created by Abena Ofosu on 6/17/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MovieCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *collectionCell;
@property (weak, nonatomic) IBOutlet UIImageView *collectionViewImage;

@end

NS_ASSUME_NONNULL_END
