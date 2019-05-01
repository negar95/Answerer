//
//  RegisterVC.swift
//  Answerer
//
//  Created by negar on 97/Farvardin/21 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController, UserDelegate, UITextFieldDelegate {

    @IBOutlet weak var password2TF: UITextField!
    @IBOutlet weak var password1TF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!

    @IBOutlet weak var indic: UIActivityIndicatorView!

    var userHelper = UserHelper()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.indic.isHidden = true
        userHelper.delegate = self

        usernameTF.delegate = self
        emailTF.delegate = self
        phoneTF.delegate = self
        password1TF.delegate = self
        password2TF.delegate = self

        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func registerPressed(_ sender: Any) {
        if validationCheck(){
            if Connectivity.isConnectedToInternet(){
                    userHelper.signup(userName: usernameTF.text!, password: password1TF.text!, phone: phoneTF.text!, email: emailTF.text!)
            }else{
                let alert = UIAlertController(title: "No connection!", message: "Please make sure that your phone is connected to internet.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok!", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }

    }

    func validationCheck() -> Bool {
        var valid = true

        if phoneTF.text == nil || emailTF.text == nil || usernameTF.text == nil || password1TF.text == nil || password1TF.text == nil {
            ViewHelper.showToastMessage(message: "All fields are required")
            valid = false
        }else{
            if password1TF.text != password2TF.text {
                ViewHelper.showToastMessage(message: "Passwords should match")
                valid = false
            }
            if !ValidationHelper.validateName(name: usernameTF.text!){
                ViewHelper.showToastMessage(message: "Please enter a valid name")
                valid = false
            }
            if !ValidationHelper.validateEmail(email: emailTF.text!){
                ViewHelper.showToastMessage(message: "Please enter a valid email")
                valid = false
            }
            if !ValidationHelper.validateCellPhone(phone: phoneTF.text!){
                ViewHelper.showToastMessage(message: "Please enter a valid phone")
                valid = false
            }
        }
        return valid
    }

    func userLoggedIn() {
        self.indic.isHidden = true
        self.indic.stopAnimating()
        ViewHelper.showToastMessage(message: "Signed UP Succesfully")
        let teacher = Teacher()
        teacher.email = emailTF.text ?? ""
        teacher.password = password1TF.text ?? ""
        teacher.phone = phoneTF.text ?? ""
        teacher.userName = usernameTF.text ?? ""
        let encoder = JSONEncoder()
        if let teacherData = try? encoder.encode(teacher) {
            UserDefaults.standard.set(teacherData, forKey: "TeacherData")
        }
        let chatVC = SegueHelper.createViewController(storyboardName: "Chat", viewControllerId: "ChatConversationViewController")
        let nv = UINavigationController()
        nv.viewControllers = [chatVC]
        present(nv, animated: true, completion: nil)

    }

    func userCouldNotLoggedIn(error: String) {
        self.indic.isHidden = true
        self.indic.stopAnimating()
        ViewHelper.showToastMessage(message: error)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTF {
            emailTF.becomeFirstResponder()
        } else if textField == emailTF {
            phoneTF.becomeFirstResponder()
        } else if textField == phoneTF {
            password1TF.becomeFirstResponder()
        } else if textField == password1TF {
            password2TF.becomeFirstResponder()
        } else {
            dismissKeyboard()
        }
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
