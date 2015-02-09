//
//  Movies.m
//  RottenTomatoes
//
//  Created by Syed Naqvi on 2/7/15.
//  Copyright (c) 2015 Naqvi. All rights reserved.
//

#import "Movies.h"
#import "SVProgressHUD.h"
#import "UIImageView+AFNetworking.h"
#import "AFNetworking.h"
#import "MovieCell.h"
#import	"MovieDetailViewController.h"
#import "CollMovieCell.h"
#import "QuartzCore/QuartzCore.h"

static const NSString *SEARCH = @"/movies.json";


@interface Movies()
- (void)handleRefresh:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSMutableArray *movies;
@property (nonatomic, strong) UIView *warningView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSString *queryString;
-(void)onTap:(id)sender;
@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end


@implementation Movies

- (void)viewDidLoad {
	[super viewDidLoad];
	self.tableView.dataSource = self;
	self.tableView.delegate = self;
	self.searchBar.delegate = self;
	self.collectionView.dataSource = self;
	self.collectionView.delegate = self;
	
	
	[self handleRefresh:nil];
	[SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
	
	// Since we are using a MovieCell here, MovieCell is separate xib file. We need to specify that xib file as nib file here in the code. In order to moviecell loaded by UITablelView.
	[self.tableView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];
	
	[self.collectionView registerNib:[UINib nibWithNibName:@"CollMovieCell" bundle:nil] forCellWithReuseIdentifier:@"CollMovieCell"];
	
	self.tableView.rowHeight = 100;
	
	self.refreshControl = [[UIRefreshControl alloc] init];
	[self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
	
	// adding segment control in the navgation bar.
	[self.tableView addSubview:self.refreshControl];
	
	self.segmentControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"List", @"Grid", nil]];
	
	UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.segmentControl];
	self.navigationItem.rightBarButtonItem = segmentBarItem;

	// light purple color
	self.segmentControl.tintColor = [UIColor colorWithRed:205.0f/255.0f
										green:153.0f/255.0f
										 blue:255.0f/255.0f
										alpha:1.0f];

	// hooking onTap for segment Control.
	[self.segmentControl addTarget:self action:@selector(onTap:) forControlEvents: UIControlEventValueChanged];
	[self.segmentControl setSelectedSegmentIndex:0];
	[self.segmentControl sizeToFit];
	
	self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:205.0f/255.0f
																		green:153.0f/255.0f
																		 blue:255.0f/255.0f
																		alpha:1.0f];

	self.navigationController.navigationBar.backgroundColor = [UIColor blueColor];
}

-(void) sendNetworkRequest:(id)sender withUrl:(NSURL*) url{
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	
	// helper to cleanup the refresh state
	void (^cleanup_refresh_state)(Boolean success) = ^(Boolean success){
		[self createWarningView];
		self.warningView.hidden = success;
		[(UIRefreshControl *)sender endRefreshing];
		[self.tableView reloadData];
		[self.collectionView reloadData];
		[SVProgressHUD dismiss];
	};
	
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	operation.responseSerializer = [AFJSONResponseSerializer serializer];
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		
		if(responseObject == nil){
			cleanup_refresh_state(false);
			return;
		}
		
		// Convert the information received in an array of MovieInfo
		self.movies = [[NSMutableArray alloc] init];
		for (NSDictionary *movieDict in responseObject[@"movies"]){
			[self.movies addObject:movieDict];
		}
		
		cleanup_refresh_state(true);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		cleanup_refresh_state(false);
	}];
	
	// Start Operation
	[operation start];
}

- (void)handleRefresh:(id)sender{
	NSURL *nsUrl = [NSURL URLWithString:self.url];
	[self sendNetworkRequest:sender withUrl:nsUrl];
}

-(void) createWarningView{
	if(self.warningView != nil)
		return;
	
	self.warningView = [[UIView alloc] initWithFrame:CGRectMake(0,
																self.navigationController.navigationBar.frame.size.height+statusBarHeight(), self.view.frame.size.width, 40)];
	UILabel *warningLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/4, 0, self.view.frame.size.width/2, 40)];
	warningLabel.text = @"Network Error";
	
	self.warningView.backgroundColor = [UIColor grayColor];
	warningLabel.backgroundColor = [UIColor grayColor];
	[warningLabel setTextAlignment:NSTextAlignmentCenter];
	warningLabel.font = [UIFont systemFontOfSize:20];
	
	//Get pointer to application bundle
	NSBundle *applicationBundle = [NSBundle mainBundle];
	
	//Get path to a resource file in the bundle
	NSString *path = [applicationBundle pathForResource:@"warning_icon"
												 ofType:@"png"];	//Returns nil if not found
	
	UIImage *iconImage = [[UIImage alloc] initWithContentsOfFile:path];
	UIImageView *warningIcon = [[UIImageView alloc] initWithImage:iconImage];
	warningIcon.frame = CGRectMake(self.view.frame.size.width/4, 13, 15, 15); //set these variables as you want
	[warningIcon setBackgroundColor:[UIColor clearColor]];
	
	[self.warningView addSubview:warningLabel];
	[self.warningView addSubview:warningIcon];
	[self.view addSubview:self.warningView];
}


#pragma mark - Table methods

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return self.movies.count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	//	UITableViewCell *cell = [[UITableViewCell alloc] init]; // never do it...
	
	MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
	NSDictionary *movie = self.movies[indexPath.row];
	
	cell.titleLabel.text = movie[@"title"];
	cell.synopsisLabel.text = movie[@"synopsis"];
	NSString *url = [movie valueForKeyPath:@"posters.thumbnail"];
	[cell.posterView setImageWithURL:[NSURL URLWithString:url]];
	
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	MovieDetailViewController *vc = [[MovieDetailViewController alloc] init];
	vc.movie = self.movies[indexPath.row];
	self.tabBarController.tabBar.hidden = TRUE;
	[self.navigationController pushViewController:vc animated:YES];
}

CGFloat statusBarHeight()
{
	CGSize statusBarSize = [[UIApplication sharedApplication] statusBarFrame].size;
	return MIN(statusBarSize.width, statusBarSize.height);
}

#pragma searh

//search button was tapped
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[self handleSearch:searchBar];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
	if ([searchText length] == 0) {
		[self performSelector:@selector(hideKeyboardWithSearchBar:) withObject:searchBar afterDelay:0];
		[self handleRefresh:nil];
	}
}

- (void)hideKeyboardWithSearchBar:(UISearchBar *)searchBar{
	[searchBar resignFirstResponder];
}

//do our search
- (void)handleSearch:(UISearchBar *)searchBar {
	
	[SVProgressHUD showWithStatus:@"Searching..." maskType:SVProgressHUDMaskTypeBlack];
	//check what was passed as the query String and get rid of the keyboard
	NSLog(@"User searched for %@", searchBar.text);
	self.queryString = searchBar.text;
	[searchBar resignFirstResponder];
	
	NSString *url = [NSString stringWithFormat:@"%@%@?apikey=%@&limit=30&country=us&q=%@", BASE_URL, SEARCH, API_KEY, searchBar.text];
	
	[self sendNetworkRequest:nil withUrl:[NSURL URLWithString:url]]; // passing NSURL
}

//user tapped on the cancel button
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
	NSLog(@"User canceled search");
	[searchBar resignFirstResponder];
}

- (void)onTap:(id)sender {
	[self.view endEditing:YES]; // cancels the keyboard.
	NSInteger option = [self.segmentControl selectedSegmentIndex];
	if(option == 0){
		self.tableView.hidden = false;
		self.collectionView.hidden = true;
	} else if (option == 1){
		self.tableView.hidden = true;
		self.collectionView.hidden = false;
	}
}

#pragma CollectionView

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
	return self.movies.count;
}

-(UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
	//MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
	
	CollMovieCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollMovieCell" forIndexPath:indexPath];
	NSDictionary *movie = self.movies[indexPath.row];
	
	cell.titleLabel.text = movie[@"title"];
	//cell.synopsisLabel.text = movie[@"synopsis"];
	NSString *url = [movie valueForKeyPath:@"posters.thumbnail"];
	[cell.posterView setImageWithURL:[NSURL URLWithString:url]];
	
	
	cell.layer.borderWidth = 0.5f;
	cell.layer.borderColor = [UIColor colorWithRed:205.0f/255.0f
											 green:153.0f/255.0f
											  blue:255.0f/255.0f
											 alpha:1.0f].CGColor; // light purple
	
	return cell;
}

-(void)collectionView:(UICollectionView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//	[self.collectionView deselectRowAtIndexPath:indexPath animated:YES];
//	MovieDetailViewController *vc = [[MovieDetailViewController alloc] init];
//	vc.movie = self.movies[indexPath.row];
//	self.tabBarController.tabBar.hidden = TRUE;
//	[self.navigationController pushViewController:vc animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	// If you need to use the touched cell, you can retrieve it like so
	//UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
	//[self.collectionView deselectRowAtIndexPath:indexPath animated:YES];
	MovieDetailViewController *vc = [[MovieDetailViewController alloc] init];
	vc.movie = self.movies[indexPath.row];
	self.tabBarController.tabBar.hidden = TRUE;
	[self.navigationController pushViewController:vc animated:YES];
}

@end
