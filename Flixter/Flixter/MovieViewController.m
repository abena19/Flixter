//
//  ViewController.m
//  Flixter
//
//  Created by Abena Ofosu on 6/15/22.
//

#import "MovieViewController.h"
#import "DetailsViewController.h"
#import "myTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface MovieViewController();
//myarray = movies info

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *myArray;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    
    
    // auto layout resizing
//    self.tableView.estimatedRowHeight = 100;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    //call helper getMovies
    [self getMovies];
    
    // initialising refreshctrl var
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getMovies) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    

    
    // Start the activity indicator
    [self.activityindicator startAnimating];

    // Stop the activity indicator
    // Hides automatically if "Hides When Stopped" is enabled
    [self.activityindicator stopAnimating];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *myIndexPath = [self.tableView indexPathForCell:sender];
    NSDictionary *dataToPass = self.myArray[myIndexPath.row];
    DetailsViewController *detailVC = [segue destinationViewController];
    detailVC.detailDict = dataToPass;
    NSLog(@"%@", dataToPass);
}


- (void) getMovies {
    // Do any additional setup after loading the view.
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a1d3d2eefaea1d8d58d42451f5c7c299"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
           }
           else {
               
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

               // Get the array of movies
               NSLog(@"%@", dataDictionary);
               //  Store the movies in a property to use elsewhere
               self.myArray = dataDictionary[@"results"];
               // Reload table view data
               [self.tableView reloadData];
           }
        
        [self.refreshControl endRefreshing];
       }];
    [task resume];
}


// rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.myArray.count;
}

// cellForRow
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    myTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myTableViewCell"];
    
//    this is of a dictionary type
    NSDictionary *movieContents = self.myArray[indexPath.row];
    
    // extracting the title
    cell.titleLabel.text = movieContents[@"title"];
    cell.synopsisLabel.text = movieContents[@"overview"];
    
//    getting urls of images
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movieContents[@"poster_path"];
    
    // appending the actual path identifier to the prefix url
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    //converting string to desired type
    NSURL *posterURL = [NSURL URLWithString: fullPosterURLString];
    
    // linking posterURL to our view
    [cell.posterImage setImageWithURL:posterURL]; //movieContents[posterURL];
    NSLog(@"%@", movieContents);
    return cell;
}


@end
