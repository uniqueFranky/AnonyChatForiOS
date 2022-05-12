//
//  ChatRoomViewController.swift
//  AnonyChatForiOS
//
//  Created by 闫润邦 on 2022/5/11.
//

import UIKit
import Network
import Starscream

class ChatRoomViewController: UIViewController {
    var selfName = ""
    var oppoName = ""
    var isLaying = false
    var root: RoomSelectorViewController!
    let tableView = UITableView()
    let inputTextView = UITextField()
    var tableBottomAnchor: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = oppoName
        view.backgroundColor = .white
        configureTableView()
        configureInputView()
        configureConstraints()
        let tapOutSide = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        tapOutSide.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapOutSide)
        
        let anyGesture = UIGestureRecognizer(target: self, action: #selector(closeKeyboard))
        anyGesture.isEnabled = true
        view.addGestureRecognizer(anyGesture)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(note:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    @objc func closeKeyboard() {
        inputTextView.resignFirstResponder()
        print("tapped")
    }
    @objc func keyboardWillHide(note: NSNotification) {
        inputTextView.transform = CGAffineTransform.identity
//        tableView.transform = CGAffineTransform.identity
        tableBottomAnchor.isActive = false
        tableBottomAnchor = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70)
        tableBottomAnchor.isActive = true
        scrollTableViewToBottom()
        view.layoutIfNeeded()
    }
    @objc func keyBoardWillShow(note: NSNotification) {

        inputTextView.transform = .identity
        tableView.transform = .identity
        //1
        let userInfo  = note.userInfo! as NSDictionary
        //2
        let  keyBoardBounds = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        //3
        //4
        let deltaY = keyBoardBounds.size.height
        print(deltaY)
        //5
        
        self.inputTextView.transform = CGAffineTransform(translationX: 0,y: -deltaY)
//        self.tableView.transform = CGAffineTransform(translationX: 0, y: -deltaY)
        tableBottomAnchor.isActive = false
        tableBottomAnchor = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -deltaY - 70)
        tableBottomAnchor.isActive = true
        view.layoutIfNeeded()
        scrollTableViewToBottom()
            
    }
    
    func setup(selfName: String, oppoName: String, root: RoomSelectorViewController) {
        self.selfName = selfName
        self.oppoName = oppoName
        self.root = root
        
    
    }
    func configureInputView() {
        inputTextView.textColor = .black
        inputTextView.delegate = self
        inputTextView.layer.borderWidth = 0.5
        inputTextView.layer.cornerRadius = 5
        inputTextView.returnKeyType = .send
        inputTextView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(inputTextView)
    }
    func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
//        tableView.backgroundColor = .brown
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: "MessageCell")
        view.addSubview(tableView)
    }
    
    func configureConstraints() {
        tableBottomAnchor = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70)
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tableBottomAnchor!,
            
            inputTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            inputTextView.heightAnchor.constraint(equalToConstant: 30),
            inputTextView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            inputTextView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
        ]
        view.addConstraints(constraints)
    }
    @objc func goBack() {
        dismiss(animated: true)
    }
    
    func scrollTableViewToBottom() {
        isLaying = true
        if tableView.numberOfRows(inSection: 0) > 0 {
            DispatchQueue.main.async {
                self.tableView.scrollToRow(at: IndexPath(item: self.tableView.numberOfRows(inSection: 0) - 1, section: 0), at: .top, animated: true)
            }
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isLaying = false
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func oppoDidDisconnect() {
        let alert = UIAlertController(title: "对方已下线", message: "对方已下线！", preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okBtn)
        present(alert, animated: true)
    }
    
    func msgDidArrive() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.scrollTableViewToBottom()
        }
    }
}

extension ChatRoomViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isLaying {
            return
        }
        inputTextView.resignFirstResponder()
    }
}

extension ChatRoomViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let array = root.msgs[oppoName] else {
            return 0
        }
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageTableViewCell
        let msg = (root.msgs[oppoName]![indexPath.item])
        cell.setUp(logo: UIImage(systemName: "number.circle")!, text: msg.getAttr("msgContent") as! String, isSelf: msg.getAttr("from") as! String == selfName, name: msg.getAttr("from") as! String, date: msg.getAttr("date") as! String)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let str = (root.msgs[oppoName]![indexPath.item]).getAttr("msgContent") as! String
        let label = UILabel()
        label.text = str + "\n"
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        let constraints = [
            label.topAnchor.constraint(equalTo: view.topAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10)
        ]
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(constraints)
        view.layoutIfNeeded()
        let hei = label.bounds.size.height
        label.removeFromSuperview()
        return max(hei + 20, 70) + 10
    }
}

extension ChatRoomViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let msgContent = textField.text else {
            return false
        }
        let msg = Message(from: selfName, to: oppoName, normalContent: msgContent)
        root.socket.write(string: MessageBuilder.msgToString(msg))
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        textField.text = ""
        textField.resignFirstResponder()
        scrollTableViewToBottom()
        return true
    }
}
