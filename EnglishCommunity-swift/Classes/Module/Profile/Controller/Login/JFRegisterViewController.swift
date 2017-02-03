//
//  JFRegisterViewController.swift
//  BaoKanIOS
//
//  Created by zhoujianfeng on 16/5/13.
//  Copyright © 2016年 六阿哥. All rights reserved.
//

import UIKit

protocol JFRegisterViewControllerDelegate: NSObjectProtocol {
    func registerSuccess(_ username: String, password: String)
}

class JFRegisterViewController: UIViewController {
    
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordView1: UIView!
    @IBOutlet weak var passwordField1: UITextField!
    @IBOutlet weak var passwordView2: UIView!
    @IBOutlet weak var passwordField2: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    let buttonColorNormal = UIColor.colorWithHexString("00ac59")
    let buttonColorDisabled = UIColor.colorWithHexString("a2e256")
    
    weak var delegate: JFRegisterViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameField.attributedPlaceholder = NSAttributedString(string: "用户名", attributes: [NSForegroundColorAttributeName : UIColor.white])
        passwordField1.attributedPlaceholder = NSAttributedString(string: "密码", attributes: [NSForegroundColorAttributeName : UIColor.white])
        passwordField2.attributedPlaceholder = NSAttributedString(string: "再次输入密码", attributes: [NSForegroundColorAttributeName : UIColor.white])
        usernameView.layer.borderColor = UIColor.white.cgColor
        usernameView.layer.borderWidth = 0.5
        passwordView1.layer.borderColor = UIColor.white.cgColor
        passwordView1.layer.borderWidth = 0.5
        passwordView2.layer.borderColor = UIColor.white.cgColor
        passwordView2.layer.borderWidth = 0.5
        didChangeTextField(usernameField)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    /**
     键盘即将显示
     */
    @objc fileprivate func keyboardWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo!
        
        let beginHeight = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.size.height
        let endHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size.height
        
        if beginHeight > 0 && endHeight > 0 {
            UIView.animate(withDuration: 0.25, animations: {
                self.view.transform = CGAffineTransform(translationX: 0, y: -endHeight + (SCREEN_HEIGHT - self.registerButton.frame.maxY) - 10)
            }) 
        }
    }
    
    /**
     键盘即将隐藏
     */
    @objc fileprivate func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform.identity
        }) 
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func didChangeTextField(_ sender: UITextField) {
        if usernameField.text?.characters.count ?? 0 >= 5 && passwordField1.text?.characters.count ?? 0 > 5 && passwordField2.text?.characters.count ?? 0 > 5 {
            registerButton.isEnabled = true
            registerButton.backgroundColor = buttonColorNormal
        } else {
            registerButton.isEnabled = false
            registerButton.backgroundColor = buttonColorDisabled
        }
    }
    
    @IBAction func didTappedBackButton() {
        view.endEditing(true)
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTappedLoginButton(_ sender: UIButton) {
        
        view.endEditing(true)
        
        if passwordField1.text != passwordField2.text {
            JFProgressHUD.showInfoWithStatus("两次输入的密码不一致")
            return
        }
        
        JFProgressHUD.showWithStatus("正在注册")
        JFAccountModel.normalAccountRegister("username", username: usernameField.text!, password: passwordField1.text!) { (success, tip) in
            if (success) {
                JFProgressHUD.dismiss()
                self.didTappedBackButton()
                self.delegate?.registerSuccess(self.usernameField.text!, password: self.passwordField1.text!)
            } else {
                JFProgressHUD.showInfoWithStatus(tip)
            }
        }
        
    }
    
}
