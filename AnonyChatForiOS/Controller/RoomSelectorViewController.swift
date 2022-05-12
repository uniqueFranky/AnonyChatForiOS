//
//  RoomSelectorViewController.swift
//  AnonyChatForiOS
//
//  Created by 闫润邦 on 2022/5/10.
//

import Foundation
import UIKit
import Starscream

class RoomSelectorViewController: UIViewController {
    var selfName: String!
    var socket: WebSocket!
    let tableView = UITableView()
    var onlineUsers: [String]!
    var currentRoom: ChatRoomViewController?
    var msgs: [String: [Message]] = [:]
    func setup(usrname: String, socket: WebSocket, onlineUsers: [String]) {
        selfName = usrname
        self.socket = socket
        self.onlineUsers = onlineUsers
        socket.delegate = self
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        title = "选择聊天对象"
        configureTableView()
        configureConstraints()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "断开连接", style: .done, target: self, action: #selector(closeConnection))
    }
    
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(RoomSelectorTableViewCell.self, forCellReuseIdentifier: "RoomSelectorCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
    }
    
    func configureConstraints() {
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ]
        
        view.addConstraints(constraints)
    }
    
    @objc func closeConnection() {
        socket.disconnect()
        dismiss(animated: true)
    }
}


extension RoomSelectorViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let crvc = ChatRoomViewController()
        crvc.setup(selfName: selfName, oppoName: indexPath.item == 0 ? "All" : onlineUsers[indexPath.item - 1], root: self)
        currentRoom = crvc
        if crvc.oppoName == selfName {
            let alert = UIAlertController(title: "错误", message: "不能和自己聊天！", preferredStyle: .alert)
            let okBtn = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okBtn)
            present(alert, animated: true)
            return
        }
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: .plain, target: self, action: nil)
        navigationController?.pushViewController(crvc, animated: true)
    }
}

extension RoomSelectorViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return onlineUsers.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomSelectorCell", for: indexPath) as! RoomSelectorTableViewCell
        cell.configureContents(image: UIImage(
                systemName: indexPath.item == 0 ? "number.circle.fill" :  "number.circle")!,
                        name: indexPath.item == 0 ? "All" : onlineUsers[indexPath.item - 1])
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

extension RoomSelectorViewController: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .disconnected(let string, let uInt16):
            print("disconnected")
        case .text(let msgStr):
            let msg = MessageBuilder.stringToMsg(msgStr)
            if msg.getType() == "Normal" {
                if msg.getAttr("to") as! String == "All" {
                    appendOrCreate(name: "All", msg: msg)
                } else {
                    appendOrCreate(name: msg.getAttr("from") as! String, msg: msg)
                    appendOrCreate(name: msg.getAttr("to") as! String, msg: msg)
                }
                currentRoom?.msgDidArrive()
            }
            if msg.getType() == "ConnectionEstablished" || msg.getType() == "ConnectionCut" {
                onlineUsers = msg.getAttr("onlineUsers") as! [String]
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                guard let name = currentRoom?.oppoName else {
                    return
                }
                if (msg.getAttr("name") as! String) == name && msg.getType() == "ConnectionCut" {
                    currentRoom?.oppoDidDisconnect()
                }
            }
        default:
            print(event)
        }
    }
    
    func appendOrCreate(name: String, msg: Message) {
        if msgs[name] == nil {
            print("NIL")
            msgs[name] = []
        }
        msgs[name]!.append(msg)
    }

}
