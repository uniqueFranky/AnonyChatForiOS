//
//  MessageTableViewCell.swift
//  AnonyChatForiOS
//
//  Created by 闫润邦 on 2022/5/11.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    var logoView = UIImageView()
    var textView = UILabel()
    var nameView = UILabel()
    var con: [NSLayoutConstraint] = []
    var isSelf = false
    override func layoutSubviews() {
        configureLogoView()
        configureTextView()
        configureNameView()
        configureConstraints()
    }
    
    func setUp(logo: UIImage, text: String, isSelf: Bool, name: String, date: String) {
        logoView.image = logo
        textView.text = text
        nameView.text = name + " " + date
        self.isSelf = isSelf
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        super.setSelected(false, animated: animated)
        // Configure the view for the selected state
    }

    
    func configureLogoView() {
        logoView.contentMode = .scaleAspectFit
        logoView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(logoView)
    }
    
    func configureTextView() {
        textView.textColor = .black
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.numberOfLines = 0
        textView.lineBreakMode = .byWordWrapping
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 10
        textView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        addSubview(textView)
    }
    func configureNameView() {
        nameView.textColor = .darkGray
        nameView.translatesAutoresizingMaskIntoConstraints = false
        nameView.numberOfLines = 1
        addSubview(nameView)
    }
    
    func configureConstraints() {
        removeConstraints(con)
        if isSelf == false {
            nameView.textAlignment = .left
            con = [
                
                logoView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
                logoView.topAnchor.constraint(equalTo: topAnchor),
                logoView.heightAnchor.constraint(equalToConstant: 50),
                logoView.widthAnchor.constraint(equalTo: logoView.heightAnchor),
                
                nameView.topAnchor.constraint(equalTo: logoView.topAnchor),
                nameView.heightAnchor.constraint(equalToConstant: 12),
                nameView.leadingAnchor.constraint(equalTo: logoView.trailingAnchor, constant: 10),
                nameView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
                
                textView.leadingAnchor.constraint(equalTo: logoView.trailingAnchor, constant: 10),
                textView.topAnchor.constraint(equalTo: nameView.bottomAnchor, constant: 5),
                textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            ]
        } else {
            print("ELSE")
            nameView.textAlignment = .right
            con = [
                logoView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
                logoView.topAnchor.constraint(equalTo: topAnchor),
                logoView.heightAnchor.constraint(equalToConstant: 50),
                logoView.widthAnchor.constraint(equalTo: logoView.heightAnchor),
                
                nameView.trailingAnchor.constraint(equalTo: logoView.leadingAnchor, constant: -10),
                nameView.topAnchor.constraint(equalTo: logoView.topAnchor),
                nameView.heightAnchor.constraint(equalToConstant: 12),
                nameView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),

                textView.trailingAnchor.constraint(equalTo: logoView.leadingAnchor, constant: -10),
                textView.topAnchor.constraint(equalTo: nameView.bottomAnchor, constant: 5),
                textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            ]
        }
        addConstraints(con)

    }
}
