//
//  NewUserViewController.h
//  TalkingPet
//
//  Created by wangxr on 14-7-16.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "BaseViewController.h"
#import "PetCategoryParser.h"
#import "TTImageHelper.h"
#import "SVProgressHUD.h"
@class NewUserViewController;
@class Pet;
@class EGOImageButton;
@protocol NewUserViewControllerDelegate <NSObject>
- (NSString *)titleWithNewUserViewController:(NewUserViewController*)controller;
- (UIButton *)finishButtonWithWithNewUserViewController:(NewUserViewController*)controller;
@optional
- (Pet*)petWithWithNewUserViewController:(NewUserViewController*)controller;
@end
typedef enum
{
    PickerViewTypeGender = 0,
    PickerViewTypeBirthday,
    PickerViewTypeBreed,
    PickerViewTypeRegion
} PickerViewType;
@interface NewUserViewController : BaseViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic ,assign)id<NewUserViewControllerDelegate>delegate;

@property (nonatomic ,strong) UITableView* infoTableV;
@property (nonatomic ,strong) NSArray* titleArray;
@property (nonatomic ,strong) NSArray* genderArray;
@property (nonatomic ,strong) NSArray* birthdayYearArray;
@property (nonatomic ,strong) NSArray* birthdayMonthArray;
@property (nonatomic, strong) UIScrollView * bgV;
@property (nonatomic, strong) UITextField * nameTF;
@property (nonatomic, strong) UIPickerView * pickerView;
@property (nonatomic, strong) UIDatePicker * datePicker;
@property (nonatomic, strong) UIView * pickerBGView;
@property (nonatomic, assign) PickerViewType pickerViewType;
@property (nonatomic, strong) UILabel * genderTL;
@property (nonatomic, strong) UILabel * birthTL;
@property (nonatomic, strong) UILabel * breedTL;
@property (nonatomic, strong) UILabel * regionTL;
@property (nonatomic, strong) PetCategoryParser * petCategory;
@property (nonatomic, strong) NSArray * petCategoryArray;
@property (nonatomic, strong) NSArray * petBreedArray;
@property (nonatomic, strong) NSArray * provinceArray;
@property (nonatomic, strong) NSArray * cityArray;
@property (nonatomic, strong) EGOImageButton * headBtn;
@property (nonatomic, strong) NSString * username;
@property (nonatomic, strong) NSString * nickname;
@property (nonatomic, strong) NSString * password;
@property (nonatomic, strong) NSString * genderCode;
@property (nonatomic, strong) NSString * breedCode;
@property (nonatomic, strong) UIImage * headIMG;
@property (nonatomic, strong) NSString * avatarUrl;
@property (nonatomic, strong) NSString * userPlatform;
@property (nonatomic, assign) double selectedBirthday;
@property (nonatomic, assign) BOOL fromUserCenter;
- (void)back;
-(void)showAlertWithMessage:(NSString *)message;
@end
