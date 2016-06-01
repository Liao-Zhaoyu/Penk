//
//  ViewController.swift
//  Penk
//
//  Created by Yunhao on 16/5/28.
//  Copyright © 2016年 Yunhao. All rights reserved.
//

import UIKit
import JTMaterialTransition
import GoogleMaterialDesignIcons
import Material

class ContentController: UIViewController, PKMenuViewDelegate, PKStateButtonDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIViewControllerTransitioningDelegate {
    
    // MARK: - Properties -
    
    /// 按钮组容器
    var menuViewSets:[String: PKMenuView] = [:]
    
    /// 状态按钮同期
    var stateButtonSets:[String: PKStateButton] = [:]
    
    let topBar = PKTopBar()
    let bottomBar = PKBottomBar()
    
    /// 编辑区域
    var EV: [String: UIView] = [:]
    
    //动画
    private var photoPickerTransition = JTMaterialTransition()
    
    override func viewDidLoad() {
        prepareEV()
        prepareButtons()
        
    }
    
    // MARK - 初始化按钮组件 -
    func prepareButtons() {
        //顶部栏
        self.view.addSubview(topBar)
        MaterialLayout.alignFromTopLeft(self.view, child: topBar, top: 0, left: 0)
        MaterialLayout.size(self.view, child: topBar, width: self.view.frame.width, height: CGFloat(50))
        
        //底部栏
        self.view.addSubview(bottomBar)
        MaterialLayout.alignFromBottomLeft(self.view, child: bottomBar, bottom: 0, left: 0)
        MaterialLayout.size(self.view, child: bottomBar, width: self.view.frame.width, height: CGFloat(50))
        
        
        //顶部工具
        menuViewSets["pallet"] = PKPallet()
        menuViewSets["pencil"] = PKPencil()
        menuViewSets["markPen"] = PKMarkPen()
        menuViewSets["eraser"] = PKEraser()
        
        //图片选择器
        menuViewSets["photoPicker"] = PKPhotoPicker(diameter:CGFloat(54))
        photoPickerTransition = JTMaterialTransition(animatedView: menuViewSets["photoPicker"]!.buttons[1])
        photoPickerTransition = JTMaterialTransition(animatedView: menuViewSets["photoPicker"]!.buttons[2])
        for (_, set) in menuViewSets {
            set.menuViewDelegate = self
            view.addSubview(set)
        }
        
        MaterialLayout.alignFromTopRight(self.view, child: menuViewSets["pallet"]!, top: 7, right: 50)
        MaterialLayout.alignFromTopRight(self.view, child: menuViewSets["pencil"]!, top: 7, right: 100)
        MaterialLayout.alignFromTopRight(self.view, child: menuViewSets["markPen"]!, top: 7, right: 150)
        MaterialLayout.alignFromTopRight(self.view, child: menuViewSets["eraser"]!, top: 7, right: 200)
        MaterialLayout.alignFromBottomLeft(self.view, child: menuViewSets["photoPicker"]!, bottom: 80, left: (self.view.frame.width - menuViewSets["photoPicker"]!.dia)/2)
        
        //底部工具
        stateButtonSets["textEdit"] = PKTextEdit()
        stateButtonSets["moveHand"] = PKMoveHand()
        stateButtonSets["undo"] = PKUndoRedo(type: .Undo)
        stateButtonSets["redo"] = PKUndoRedo(type: .Redo)
        
        for set in stateButtonSets.values {
            set.stateButtonDelegate = self
            self.view.addSubview(set)
            MaterialLayout.size(self.view, child: set, width: set.diameter, height: set.diameter)
        }
        
        MaterialLayout.alignFromBottomRight(self.view, child: stateButtonSets["textEdit"]!, bottom: 7, right: 20)
        MaterialLayout.alignFromBottomRight(self.view, child: stateButtonSets["moveHand"]!, bottom: 7, right: 80)
        MaterialLayout.alignFromBottomLeft(self.view, child: stateButtonSets["undo"]!, bottom: 7, left: 20)
        MaterialLayout.alignFromBottomLeft(self.view, child: stateButtonSets["redo"]!, bottom: 7, left: 80)
    }
    
    // MARK - 初始化编辑组件 -
    func prepareEV() {
        EV["canvas"] = PKCanvas(frame: self.view.frame)
        (EV["canvas"] as! PKCanvas).editchange = true
        self.view.addSubview(EV["canvas"]!)
    }
    
    /// MARK: - Button touch handlers -
    
    /// Menu View 菜单点击事件
    func menuViewHandleMenu(menu: Menu) {
        
        if menu.opened {
            menu.close()
            (menu.views?.first as? MaterialButton)?.animate(MaterialAnimation.rotate(rotation: 0))
        } else {
            menu.open(duration: NSTimeInterval(0.05)) {
                (v: UIView) in (v as? MaterialButton)?.pulse()
            }
            (menu.views?.first as? MaterialButton)?.animate(MaterialAnimation.rotate(rotation: 0.125))
        }
        menuViewAutoCloseAll()
    }
    
    /// Menu View 按钮点击事件
    func menuViewHandleButton(button: UIButton) {
        if let menu = menuViewSets["pallet"] where menu.contains(button) {
            let color = (menu as! PKPallet).palletColor(button)
            print(color)
        } else
            if let menu = menuViewSets["pencil"] where menu.contains(button) {
                let lineSize = (menu as! PKPencil).pencilLineSize(button)
                print(lineSize)
            } else
                if let menu = menuViewSets["markPen"] where menu.contains(button) {
                    let lineSize = (menu as! PKMarkPen).markPenLineSize(button)
                    print(lineSize)
                } else
                    if let menu = menuViewSets["eraser"] where menu.contains(button) {
                        let size = (menu as! PKEraser).eraserSize(button)
                        print(size)
                    } else
                        if let menu = menuViewSets["photoPicker"] where menu.contains(button) {
                            if (menu as! PKPhotoPicker).photoPickerBehavior(button) == PKPhotoPickerbehavior.PhotoLibrary {
                                let imagePicker  = UIImagePickerController()
                                imagePicker.modalPresentationStyle = .Custom
                                imagePicker.sourceType = .PhotoLibrary
                                imagePicker.transitioningDelegate = self
                                imagePicker.delegate = self
                                presentViewController(imagePicker, animated: true, completion: nil)
                            } else
                                if (menu as! PKPhotoPicker).photoPickerBehavior(button) == PKPhotoPickerbehavior.Camera {
                                    let imagePicker  = UIImagePickerController()
                                    imagePicker.modalPresentationStyle = .Custom
                                    imagePicker.sourceType = .Camera
                                    imagePicker.transitioningDelegate = self
                                    imagePicker.delegate = self
                                    presentViewController(imagePicker, animated: true, completion: nil)
                            }
                            
        }
    }
    
    /// Menu View 触摸越界检测
    func menuViewDidTapOutside(menuView: PKMenuView) {
        let menu = menuView.menu
        if menu.opened {
            menu.close()
            (menu.views?.first as? MaterialButton)?.animate(MaterialAnimation.rotate(rotation: 0))
        }
    }
    
    /// Menu View 自动关闭
    func menuViewAutoCloseAll() {
        for mv in menuViewSets.values {
            let menu = mv.menu
            if menu.opened {
                menu.close()
                (menu.views?.first as? MaterialButton)?.animate(MaterialAnimation.rotate(rotation: 0))
            }
        }
    }
    
    /// State Button 状态切换
    func stateButtonToggleTo(button: UIButton, state: Bool) {
        
        if let btn = stateButtonSets["textEdit"] where btn === button {
            print("textEdit \(state)")
            (button as! PKStateButton).turnStateButtonTo(state)
        } else
            if let btn = stateButtonSets["moveHand"] where btn === button {
                print("moveHand \(state)")
                (button as! PKStateButton).turnStateButtonTo(state)
            } else
                if let btn = stateButtonSets["undo"] where btn === button {
                    print("undo \(state)")
                    (button as! PKStateButton).turnStateButtonTo(state)
                } else
                    if let btn = stateButtonSets["redo"] where btn === button {
                        print("redo \(state)")
                        (button as! PKStateButton).turnStateButtonTo(state)
        }
    }
    
    // MARK: 按钮动画
    // 按钮点击后 controller 的跳转动画
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presented.view.backgroundColor = UIColor.whiteColor()
        photoPickerTransition.reverse = false
        return photoPickerTransition
    }
    
    // 按钮点击后 controller 的 跳转返回 动画
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        photoPickerTransition.reverse = true
        return photoPickerTransition
    }
    
    // 获取图片成功
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        //关闭photo pick按钮组
        
        dismissViewControllerAnimated(true, completion: nil)
        menuViewAutoCloseAll()
        let image: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        //二值化
        //图片管理器 （图片处理）
        let imageManager = PKImage()
        imageManager.setRawImage(image)
        imageManager.colorDivide(0xFF555555)
        //实例化imageView 并 等比缩放至屏宽60%
        let imageView = PKImageView(image: imageManager.imageResult!, superViewFrame: self.view.frame, scaleTo: CGFloat(0.6))
        imageView.userInteractionEnabled = true
        EV["canvas"]?.addSubview(imageView)
    }
    
    // 用户取消选取图片
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        //关闭photo pick按钮组
        menuViewSets["photoPicker"]!.menu.close()
        (menuViewSets["photoPicker"]!.menu.views?.first as? MaterialButton)?.animate(MaterialAnimation.rotate(rotation: 0))
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

