//
//  ViewController.swift
//  AnonyChat-iOS
//
//  Created by 闫润邦 on 2022/5/10.
//

import UIKit
import Starscream
//"ws://120.24.213.224:8080/chat/ios"
class LoginViewController: UIViewController {
    var socket: WebSocket!
    let loginBtn = UIButton()
    let input = UITextField()
    let titleLabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureTitleLabel()
        configureLoginBtn()
        configureInput()
        configureConstraints()
    }
    
    func configureTitleLabel() {
        titleLabel.text = "AnonymousChat"
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.adjustsFontSizeToFitWidth = true
    }
    
    func configureLoginBtn() {
        loginBtn.setTitle("连接服务器", for: .normal)
        loginBtn.setTitleColor(.white, for: .normal)
        loginBtn.backgroundColor = .systemBlue
        loginBtn.layer.cornerRadius = 15
        loginBtn.addTarget(self, action: #selector(self.getConnection), for: .touchUpInside)
        view.addSubview(loginBtn)
        loginBtn.translatesAutoresizingMaskIntoConstraints = false
    }
    func configureInput() {
        input.placeholder = "输入匿名名称"
        input.textAlignment = .center
        input.delegate = self
        input.returnKeyType = .go
        view.addSubview(input)
        let tapOutSide = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        tapOutSide.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapOutSide)
        input.translatesAutoresizingMaskIntoConstraints = false
    }

    func configureConstraints() {
        let constraints = [
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            titleLabel.heightAnchor.constraint(equalToConstant: 50),
            
            input.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            input.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            input.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            input.heightAnchor.constraint(equalToConstant: 100),
            
            loginBtn.topAnchor.constraint(equalTo: input.bottomAnchor, constant: 20),
            loginBtn.leadingAnchor.constraint(equalTo: input.leadingAnchor),
            loginBtn.trailingAnchor.constraint(equalTo: input.trailingAnchor),
            loginBtn.heightAnchor.constraint(equalToConstant: 50),
        ]
        view.addConstraints(constraints)
    }
    @objc func getConnection() {
        print("Begin to Connect")
        guard let usrname = input.text else {
            print("No Name")
            return
        }
        guard usrname != "All" && usrname != "" else {
            let alert = UIAlertController(title: "用户名不合法", message: "非法的用户名：" + usrname + " ，请重新输入", preferredStyle: .alert)
            let okBtn = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okBtn)
            present(alert, animated: true)
            return
        }
        socket = WebSocket(request: URLRequest(url: URL(string: ("ws://120.24.213.224:8080/chat/" + usrname).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!))
        socket.delegate = self
        socket.connect()
    }
    
    @objc func closeKeyboard() {
        if input.isEditing {
            input.endEditing(true)
        }
    }
}

extension LoginViewController: WebSocketDelegate {
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
            case .connected(let dic):
                print("Connected")
            case .text(let msgString):
                let msg = MessageBuilder.stringToMsg(msgString)
            if msg.getType() == "ConnectionEstablished" && msg.getAttr("name") as! String == input.text {
                    print("ConnectionEstablished")
                    let rsvc = RoomSelectorViewController()
                    rsvc.setup(usrname: input.text!, socket: client, onlineUsers: msg.getAttr("onlineUsers") as! [String])
                    let navi = UINavigationController(rootViewController: rsvc)
                    navi.modalPresentationStyle = .fullScreen
                    present(navi, animated: true)
            } else {
                client.disconnect()
                if msg.getType() == "ConnectionRejected" {
                    let alert = UIAlertController(title: "连接失败", message: "连接失败， 原因为：\n" + (msg.getAttr("reason") as! String), preferredStyle: .alert)
                    let okBtn = UIAlertAction(title: "OK", style: .default)
                    alert.addAction(okBtn)
                    present(alert, animated: true)
                }
            }
            default:
            print(event)
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        getConnection()
        return true
    }
}
