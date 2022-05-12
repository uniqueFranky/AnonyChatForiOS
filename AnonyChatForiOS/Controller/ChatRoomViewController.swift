//
//  ChatRoomViewController.swift
//  AnonyChatForiOS
//
//  Created by 闫润邦 on 2022/5/11.
//

import UIKit
import Network

class ChatRoomViewController: UIViewController {
    var selfName = ""
    var oppoName = ""
    var msgs: [String: [Message]]!
    let tableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(goBack))
        title = oppoName
        view.backgroundColor = .white
        configureTableView()
        configureConstraints()
        // Do any additional setup after loading the view.
    }
    
    func setup(selfName: String, oppoName: String, root: UIViewController, msgs: [String: [Message]]) {
        self.selfName = selfName
        self.oppoName = oppoName
        self.msgs = msgs
    }
    
    func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: "MessageCell")
        view.addSubview(tableView)
    }
    
    func configureConstraints() {
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]
        view.addConstraints(constraints)
    }
    @objc func goBack() {
        dismiss(animated: true)
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
    
    func msgDidArrive(msgs: [String: [Message]]) {
        self.msgs = msgs
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension ChatRoomViewController: UITableViewDelegate {
    
}

extension ChatRoomViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let array = msgs[oppoName] else {
            print("ITs 0")
            return 0
        }
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageTableViewCell
        let msg = (msgs[oppoName]![indexPath.item])
        cell.setUp(logo: UIImage(systemName: "number.circle")!, text: msg.getAttr("msgContent") as! String, isSelf: msg.getAttr("from") as! String == selfName, name: msg.getAttr("from") as! String, date: msg.getAttr("date") as! String)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let str = (msgs[oppoName]![indexPath.item]).getAttr("msgContent") as! String
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
        return max(hei, 70) + 10
    }
}

