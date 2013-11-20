//
//  ApplyFunFiltersViewController.m
//  CoryGraham-Shutterstock
//
//  Created by Cory Graham on 11/19/13.
//  Copyright (c) 2013 JerremyMasicat. All rights reserved.
//

#import "ApplyFunFiltersViewController.h"

@interface ApplyFunFiltersViewController ()

{
    NSArray *arrSupportedFilters;
}

@end

@implementation ApplyFunFiltersViewController
@synthesize imgPickedImage, imgvImageToFilter, arrImgFilteredStack;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [_btnUndo setUserInteractionEnabled:false];
    
    //Set all the possible filters, support for all will not be available at this time.
    arrImgFilteredStack = [[NSMutableArray alloc] init];
    arrSupportedFilters = [CIFilter filterNamesInCategory:kCICategoryBuiltIn];
    [_tblAvailableFilters reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    //Set the chosen image.
    [self.navigationItem setTitle:@"!Filters!"];
    AppDelegate *del = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [imgvImageToFilter setImage:del.imgToMod];
    imgPickedImage = del.imgToMod;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Applies a certain filter if possible (aka it requires additional input or the like)
-(void)applyFilter: (CIFilter*) filter
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *outputImage = [filter outputImage];
    
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    if( cgimg != nil)
    {
        [imgvImageToFilter setImage:[UIImage imageWithCGImage:cgimg]];
        [arrImgFilteredStack addObject:[imgvImageToFilter image]];
        [_btnUndo setUserInteractionEnabled:true];
    }
    else
    {
        UIAlertView *unsupportedFilter = [[UIAlertView alloc] initWithTitle:@"Unsupported filter!" message:@"We do not suppor this filter currently, but soon that will change!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [unsupportedFilter show];
    }
}

//Create filter based on array of filter names, and call apply filter method
- (IBAction)btnApplyFilter:(id)sender
{
    if( _lblChosenFilter.tag != -1 )
    {
        @try
        {
            CIImage *beginImage = [CIImage imageWithData:UIImagePNGRepresentation([imgvImageToFilter image])];
            CIFilter *filter = [CIFilter filterWithName:[arrSupportedFilters objectAtIndex:_lblChosenFilter.tag] keysAndValues: kCIInputImageKey, beginImage, nil];
            [self applyFilter:filter];
        }
        @catch (NSException * e) {
            UIAlertView *unsupportedFilter = [[UIAlertView alloc] initWithTitle:@"Unsupported filter!" message:@"We do not suppor this filter currently, but soon that will change!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [unsupportedFilter show];
        }
    }
}

//Show or hide tableview to select filters
- (IBAction)btnShowFilterOptions:(UIButton *)sender
{
    int heightForTable;
    if( _btnShowFilterOptions.tag == 0)
    {
        _btnShowFilterOptions.tag = 1;
        heightForTable = 415;
    }
    else
    {
        _btnShowFilterOptions.tag = 0;
        heightForTable = 0;
    }
        
    [UIView animateWithDuration:.2 animations:^{
        [_tblAvailableFilters setFrame:CGRectMake(_tblAvailableFilters.frame.origin.x, _tblAvailableFilters.frame.origin.y, _tblAvailableFilters.frame.size.width, heightForTable)];
    } completion:^(BOOL finished) {
        //
    }];
}

////Table view portion to allow user to select a filter
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrSupportedFilters count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSString *filterName = [arrSupportedFilters objectAtIndex:indexPath.row];
    [cell.textLabel setText: [filterName substringFromIndex:2]];
    
    [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _lblChosenFilter.tag = indexPath.row;
    [_lblChosenFilter setText:[[arrSupportedFilters objectAtIndex:indexPath.row] substringFromIndex:2] ];
    [self btnShowFilterOptions:_btnShowFilterOptions];
}

//Undos the last applied filter
- (IBAction)btnUndo:(id)sender
{
    if( [arrImgFilteredStack count] >  1)
    {
        [imgvImageToFilter setImage:[arrImgFilteredStack objectAtIndex:[arrImgFilteredStack count]-1]];
        [arrImgFilteredStack removeLastObject];
    }
    else if( [arrImgFilteredStack count] == 1)
    {
        [imgvImageToFilter setImage:imgPickedImage];
        [arrImgFilteredStack removeLastObject];
         [_btnUndo setUserInteractionEnabled:false];
    }
}

//Allows user to save current image displayed to library, post on facebook, or reset back to original
- (IBAction)sgmtOptions:(id)sender
{
    if( _sgmtOptions.selectedSegmentIndex == 0)
    {
         // save image to library
        CIImage *saveMe = [CIImage imageWithData:UIImagePNGRepresentation([imgvImageToFilter image])];
        
        CIContext *softwareContext;
        if( ![[UIDevice currentDevice].model isEqualToString:@"iPhone Simulator"])
            softwareContext = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(YES)} ];
        else
            softwareContext = [CIContext contextWithOptions:nil];
            
        CGImageRef cgImg = [softwareContext createCGImage:saveMe
                                                 fromRect:[saveMe extent]];
        ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
        [library writeImageToSavedPhotosAlbum:cgImg
                                     metadata:[saveMe properties]
                              completionBlock:^(NSURL *assetURL, NSError *error) {
                                  // 5
                                  CGImageRelease(cgImg);
                              }];
        UIAlertView *saved = [[UIAlertView alloc] initWithTitle:@"Saved!" message:@"Your image has been saved to your photo library : )" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [saved show];
    }
    else if( _sgmtOptions.selectedSegmentIndex == 1)
    {
        //share on facebook
        SLComposeViewController *socialVc=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        NSData *data = UIImageJPEGRepresentation( [imgvImageToFilter image], 1.0);
        [socialVc addImage:[UIImage imageWithData:data]];
        [socialVc setInitialText:[NSString stringWithFormat:@"Got filters?"]];
        [self.navigationController presentViewController:socialVc animated:YES completion:nil];
        
        
        [socialVc setCompletionHandler:^(SLComposeViewControllerResult result) {
            NSString *output;
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    output = @"Action Cancelled, oh young caterpillar : (";
                    break;
                case SLComposeViewControllerResultDone:
                    output = @"Post Successfull, what a social butterfly you are : )";
                    break;
                default:
                    break;
            } //check if everythink worked properly. Give out a message on the state.
            UIAlertView *saved = [[UIAlertView alloc] initWithTitle:@"Shared!" message:output delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [saved show];
        }];
    }
    else if( _sgmtOptions.selectedSegmentIndex == 2)
    {
        //reset stack
        [arrImgFilteredStack removeAllObjects];
        [imgvImageToFilter setImage:imgPickedImage];
        [_btnUndo setUserInteractionEnabled:false];
        
        UIAlertView *saved = [[UIAlertView alloc] initWithTitle:@"Reseted!" message:@"Back to square numero uno : )" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [saved show];
    }
    
    [_sgmtOptions setSelectedSegmentIndex:UISegmentedControlNoSegment];
}
@end
