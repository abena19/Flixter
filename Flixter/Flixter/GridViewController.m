//
//  GridViewController.m
//  Flixter
//
//  Created by Abena Ofosu on 6/17/22.
//

#import "GridViewController.h"
#import "MovieCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface GridViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (weak, nonatomic) IBOutlet UICollectionView *CollectionView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityindicator;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSArray *moviesArray;
@end

@implementation GridViewController

NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.CollectionView.dataSource = self;
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    
    //call helper getMovies
    [self getMovies];
    
    // initialising refreshctrl var
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    [self.refreshControl addTarget:self action:@selector(getMovies) forControlEvents:UIControlEventValueChanged];
    
    [self.CollectionView insertSubview:self.refreshControl atIndex:0];
    

    
    // Start the activity indicator
    [self.activityindicator startAnimating];
    // Stop the activity indicator
    // Hides automatically if "Hides When Stopped" is enabled
    [self.activityindicator stopAnimating];
    // Uncomment the following line to preserve selection between presentations
    //self.clearsSelectionOnViewWillAppear = NO;
    
    
    // Register cell classes
   // [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    // Do any additional setup after loading the view.
}


- (void)viewDidLayoutSubviews {
   [super viewDidLayoutSubviews];

    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.flowLayout.minimumLineSpacing = 0;
    self.flowLayout.minimumInteritemSpacing = 0;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 10);
}

// MARK: UICollectionViewDelegateFlowLayout methods
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    int totalwidth = self.CollectionView.bounds.size.width;
    int numberOfCellsPerRow = 3;
    int oddEven = indexPath.row / numberOfCellsPerRow % 2;
    int dimensions = (CGFloat)(totalwidth / numberOfCellsPerRow);
    if (oddEven == 0) {
        return CGSizeMake(dimensions, dimensions);
    } else {
        return CGSizeMake(dimensions, dimensions / 2);
    }
}


- (void) getMovies {
    // Do any additional setup after loading the view.
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a1d3d2eefaea1d8d58d42451f5c7c299"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
               UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Get Movies" message:@"Internet connection seems to be offline" preferredStyle:UIAlertControllerStyleAlert];

               UIAlertAction *tryAgain = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                       //button click event
                                   }];
               UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
               [alert addAction:cancel];
               [alert addAction:tryAgain];
               [self presentViewController:alert animated:YES completion:nil];
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               // Get the array of movies
               NSLog(@"%@", dataDictionary);
               //  Store the movies in a property to use elsewhere
               self.moviesArray = dataDictionary[@"results"];
               // Reload table view data
               [self.CollectionView reloadData];
           }
        [self.refreshControl endRefreshing];
       }];
    [task resume];
}

/*
#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    return self.moviesArray.count;
//}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.moviesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MovieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
        // this is of a dictionary type
        NSDictionary *movieContents = self.moviesArray[indexPath.row];
        
        // getting urls of images
        NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
        NSString *posterURLString = movieContents[@"poster_path"];
        
        // appending the actual path identifier to the prefix url
        NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
        //converting string to desired type
        NSURL *posterURL = [NSURL URLWithString: fullPosterURLString];
        
        // linking posterURL to our view
        [cell.collectionViewImage setImageWithURL:posterURL]; //movieContents[posterURL];
        NSLog(@"%@", movieContents);
        return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
