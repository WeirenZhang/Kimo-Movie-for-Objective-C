//
//  MovieFavoritesViewController.m
//  movie
//
//  Created by Ian1 on 2014/7/11.
//  Copyright (c) 2014年 eznewlife. All rights reserved.
//

#import "MovieFavoritesViewController.h"

@interface MovieFavoritesViewController ()

@end

@implementation MovieFavoritesViewController

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
    // Do any additional setup after loading the view from its nib.
    appDelegate = (AppDelegate*)
    [[UIApplication sharedApplication]delegate];
    
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Movie_favorites" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetch setEntity:entity];
    self.allUsers = [appDelegate.managedObjectContext executeFetchRequest:fetch error:nil];
    
    if (![self.allUsers count] == 0) {
        self.list = [[NSMutableArray alloc] init];
        self.allUsers = [appDelegate.managedObjectContext executeFetchRequest:fetch error:nil];
        if (![self.allUsers count] == 0) {
            for (Movie_favorites *p in self.allUsers) {
                NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
                [parameters setObject:p.movie_id forKey:@"id"];
                [parameters setObject:p.movie_chinese_name forKey:@"chinese_name"];
                if (p.movie_english_name != nil) {
                    [parameters setObject:p.movie_english_name forKey:@"english_name"];
                } else {
                    [parameters setObject:@"" forKey:@"english_name"];
                }
                [parameters setObject:p.movie_image_url forKey:@"image"];
                [parameters setObject:p.movie_release_date forKey:@"release_date"];
                [self.list addObject:parameters];
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    MovieFavoritesCell *cell;
    
    NSDictionary* dict = [_list objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        cell = [[MovieFavoritesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setImageWithURL:[dict objectForKey:@"image"]];
    cell.chinese_name.text = [dict objectForKey:@"chinese_name"];
    cell.english_name.text = [dict objectForKey:@"english_name"];
    cell.release_date.text = [dict objectForKey:@"release_date"];
    
    [cell.delete_movie addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    [cell.delete_movie setTag:indexPath.row];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath  *)indexPath
{
    return 120;
}

- (void)delete:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"是否要刪除此電影？"
                                                   delegate:self
                                          cancelButtonTitle:@"確定"
                                          otherButtonTitles:@"取消",nil];
    [alert setTag:[sender tag]];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {     // and they clicked OK.
        // do stuff
        NSDictionary* dict = [_list objectAtIndex:[alertView tag]];
        NSLog(@"%@", [dict objectForKey:@"id"]);
        [appDelegate.managedObjectContext save:nil];
        
        NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Movie_favorites" inManagedObjectContext:appDelegate.managedObjectContext];
        [fetch setEntity:entity];
        
        // 設定查詢條件: 客戶編號為A01的客戶
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"movie_id == %@", [dict objectForKey:@"id"]];
        [fetch setPredicate:predicate];
        
        NSArray *allUsers = [appDelegate.managedObjectContext executeFetchRequest:fetch error:nil];
        for (Movie_favorites *p in allUsers) {
            // 從"UserData"中刪除客戶編號為A01的資料
            [appDelegate.managedObjectContext deleteObject:p];
        }
        // 儲存結果到"UserData
        NSError* error = nil;
        if (![[appDelegate managedObjectContext] save:&error]) {
            NSLog(@"物件刪除失敗");
        } else {
            NSLog(@"物件刪除成功");
            [_list removeObjectAtIndex:[alertView tag]];  //删除数组里的数据
            [self.tableview reloadData];  //删除对应数据的cell
        }
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dict = [_list objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"openMovie" object:dict];
}

@end
