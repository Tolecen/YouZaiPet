//
//  ClothPetInfoViewController.h
//  TalkingPet
//
//  Created by Tolecen on 15/6/2.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "BaseViewController.h"
#import "WebContentViewController.h"
#import "PetCategoryParser.h"
#import "SVProgressHUD.h"
@interface ClothPetInfoViewController : BaseViewController<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic,strong) UIScrollView * bgScrollV;
@property (nonatomic,strong) UIView * firstPartV;
@property (nonatomic,strong) UIView * secondPartV;
@property (nonatomic,strong) UIView * thirdPartV;
@property (nonatomic,strong) UITextField * chestTF;
@property (nonatomic,strong) UITextField * neckTF;
@property (nonatomic,strong) UITextField * bodyTF;
@property (nonatomic,strong) UITextField * breedTF;
@property (nonatomic,strong) UITextField * genderTF;
@property (nonatomic,strong) UITextField * weightTF;
@property (nonatomic,strong) UITextField * currentTF;
@property (nonatomic,strong) UIButton * breedBtn;
@property (nonatomic,strong) UIButton * genderBtn;
@property (nonatomic, strong) UIPickerView * pickerView;
@property (nonatomic, strong) UIView * pickerBGView;
@property (nonatomic,assign)int pickerViewType;
@property (nonatomic, strong) PetCategoryParser * petCategory;
@property (nonatomic, strong) NSArray * petCategoryArray;
@property (nonatomic, strong) NSArray * petBreedArray;
@property (nonatomic ,strong) NSArray* genderArray;
@property (nonatomic,strong) NSString * genderCode;
@property (nonatomic,strong) NSString * breedCode;
@property (nonatomic,strong)NSMutableDictionary * infoDict;
@property (nonatomic,strong)NSString * fitful;
@property (nonatomic,strong)NSString * fitfulCode;
@end
