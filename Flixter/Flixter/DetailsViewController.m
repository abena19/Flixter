//
//  DetailsViewController.m
//  Flixter
//
//  Created by Abena Ofosu on 6/17/22.
//

#import "DetailsViewController.h"

@implementation DetailsViewController

- (void)viewDidLoad {
    NSLog(@"%@", self.detailDict[@"title"]);
    // extracting the title
    self.detailTitle.text = _detailDict[@"title"];
    self.detailSynopsis.text = _detailDict[@"overview"];
    
    // getting urls of images
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = _detailDict[@"poster_path"];
        
    // appending the actual path identifier to the prefix url
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    //converting string to desired type
    NSURL *posterURL = [NSURL URLWithString: fullPosterURLString];
        
    // linking posterURL to our view
    [self.detailImage setImageWithURL:posterURL];
}

@end
