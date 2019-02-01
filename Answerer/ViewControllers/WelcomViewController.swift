//
//  WelcomViewController.swift
//  Answerer
//
//  Created by Tara Tandel on 7/30/1397 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import UIKit
import Foundation

class WelcomViewController: UIViewController , UserDelegate{

    let defaults = UserDefaults()
    let userHelper = UserHelper()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        userHelper.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        check()
    }

    func check() {
        if Connectivity.isConnectedToInternet(){
            if (defaults.object(forKey: "TeacherData") != nil) {
                let decoder = try? JSONDecoder().decode(Teacher.self, from: defaults.object(forKey: "TeacherData") as! Data)
                if let tchrPhone = decoder?.phone {
                    userHelper.setFCMToken(phone: tchrPhone)
                } else {
                    performSegue(withIdentifier: "ToLoginView", sender: self)
                }
            } else {
                performSegue(withIdentifier: "ToLoginView", sender: self)
            }
        }else{
            let alert = UIAlertController(title: "No connection!", message: "Please make sure that your phone is connected to internet.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok!", style: .default) {
                UIAlertAction in
                self.check()
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }

    func userLoggedIn() {

        let chatVC = SegueHelper.createViewController(storyboardName: "Chat", viewControllerId: "ChatConversationViewController")
        let nv = UINavigationController()
        nv.viewControllers = [chatVC]
        self.present(nv, animated: true, completion: nil)
    }
    func userCouldNotLoggedIn(error: String) {
        check()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
