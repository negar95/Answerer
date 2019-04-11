//
//  ConversationViewController.swift
//  Answerer
//
//  Created by Tara Tandel on 5/13/1397 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, getConversationsDelegate {
    let defaults = UserDefaults.standard
    let messageHelper = ChatHelper()

    @IBOutlet weak var noConversationView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var conversationTable: UITableView!
    var conversations = [ChatConversation()]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationItem.hidesBackButton = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "logOut", style: .plain, target: self, action: #selector(logout))
        // Do any additional setup after loading the view.
        conversationTable.delegate = self
        conversationTable.dataSource = self

        messageHelper.convDelegate = self

        indicator.startAnimating()

        conversationTable.isHidden = true
        conversationTable.layer.borderWidth = 4.0
        conversationTable.layer.borderColor = UIColor.white.cgColor

        noConversationView.layer.cornerRadius = 20
        noConversationView.layer.masksToBounds = true
        noConversationView.alpha = 0.7
        noConversationView.isHidden = true

    }

    override func viewWillAppear(_ animated: Bool) {
        self.checkNet()
    }
    func checkNet() {
        if Connectivity.isConnectedToInternet(){
            self.getConversations()
        }else{
            let alert = UIAlertController(title: "No connection!", message: "Please make sure that your phone is connected to internet.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok!", style: .default) {
                UIAlertAction in
                self.checkNet()
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.navigationController?.isNavigationBarHidden = false
    }

    @objc func logout() {
        UserDefaults.standard.removeObject(forKey: "TeacherData")
        let vc = SegueHelper.createViewController(storyboardName: "Main", viewControllerId: "welcomViewController")
        let nv = UINavigationController()
        nv.viewControllers = [vc]
        present(nv, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getConversations() {
        if (defaults.object(forKey: "TeacherData") != nil) {
            let decoder = try? JSONDecoder().decode(Teacher.self, from: defaults.object(forKey: "TeacherData") as! Data)
            if let tchrPhone = decoder?.phone {
                messageHelper.getConversations(teacherId: tchrPhone)
            }
        } else {
            ViewHelper.showToastMessage(message: "please login!")
        }

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "conversationCell", for: indexPath) as! ConversationTableViewCell
        let conversation = conversations[indexPath.row]
        cell.idOfSender.text = conversation.studentName
        cell.SomePartOfTheLastMessage.text = conversation.date
        cell.conversationId = conversation.conversationId
        cell.isEnd = conversation.isEnd
        cell.questionType = conversation.questionType
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ConversationTableViewCell
        let chatVC = SegueHelper.createViewController(storyboardName: "Chat", viewControllerId: "ChatViewController") as! ChatViewController
        chatVC.conversationID = cell.conversationId
        chatVC.conversationIsEnded = cell.isEnd
        SegueHelper.pushViewController(sourceViewController: self, destinationViewController: chatVC)
    }
    func getConversationSuccessfully(lstOfConversations: [ChatConversation]) {
        if lstOfConversations.count > 0{
            noConversationView.isHidden = true
            self.conversations = lstOfConversations
            conversationTable.reloadData()
            conversationTable.isHidden = false
        }else {
            noConversationView.isHidden = false
        }
        indicator.isHidden = true
        indicator.stopAnimating()

    }

    func failedTogetConv(isSucceded: Bool, error: String) {
        ViewHelper.showToastMessage(message: error)
    }

}
