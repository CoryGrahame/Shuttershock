//
//  ApplyFunFiltersViewController.h
//  CoryGraham-Shutterstock
//
//  Created by Cory Graham on 11/19/13.
//  Copyright (c) 2013 JerremyMasicat. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Social/Social.h>

@interface ApplyFunFiltersViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

//Original image and a filter stack array for applied changes
@property (strong, nonatomic) UIImage *imgPickedImage;
@property(strong, nonatomic) NSMutableArray *arrImgFilteredStack;

//Apply/show/undo buttons along with label of current filter
- (IBAction)btnApplyFilter:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblChosenFilter;
@property (weak, nonatomic) IBOutlet UITableView *tblAvailableFilters;
- (IBAction)btnShowFilterOptions:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnShowFilterOptions;
- (IBAction)btnUndo:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnUndo;

//Imageview where the fun is displayed
@property (weak, nonatomic) IBOutlet UIImageView *imgvImageToFilter;

//Segment to Save/Share/Reset
@property (weak, nonatomic) IBOutlet UISegmentedControl *sgmtOptions;
- (IBAction)sgmtOptions:(id)sender;

@end
