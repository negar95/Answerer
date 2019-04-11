//
//  ResetPasswordVC.swift
//  Answerer
//
//  Created by negar on 97/Farvardin/21 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import UIKit

class ResetPasswordVC: UIViewController, UserDelegate, UITextFieldDelegate {

    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    var userHelper = UserHelper()

    @IBOutlet weak var indic: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.indic.isHidden = true
        userHelper.delegate = self

        passwordTF.delegate = self
        phoneTF.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func resetPressed(_ sender: Any) {
        if validationCheck(){
            if Connectivity.isConnectedToInternet(){
                self.indic.isHidden = false
                userHelper.rsetPass(phone: phoneTF.text!, password: passwordTF.text!)
            }else{
                let alert = UIAlertController(title: "No connection!", message: "Please make sure that your phone is connected to internet.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok!", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    func validationCheck() -> Bool {
        var valid = true
        if phoneTF.text == nil || passwordTF.text == nil{
            ViewHelper.showToastMessage(message: "All fields are required")
            valid = false
        }else{
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
        ViewHelper.showToastMessage(message: "Reset successfully")
        self.navigationController?.popViewController(animated: true)
        // indicator segue
    }
    func userCouldNotLoggedIn(error: String) {
        self.indic.isHidden = true

        self.indic.stopAnimating()
        ViewHelper.showToastMessage(message: error)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == phoneTF {
            passwordTF.becomeFirstResponder()
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
