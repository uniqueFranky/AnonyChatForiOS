//
//  RoomSelectorTableViewCell.swift
//  AnonyChatForiOS
//
//  Created by 闫润邦 on 2022/5/10.
//

import UIKit

class RoomSelectorTableViewCell: UITableViewCell {

    let roomNameView = UILabel()
    let logoView = UIImageView()
    let notiView = UIImageView()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        backgroundColor = .clear
        configureRoomNameView()
        configureLogoView()
        configureNotiView()
        configureConstraints()
    }
    
    private func configureRoomNameView() {
        addSubview(roomNameView)
        roomNameView.translatesAutoresizingMaskIntoConstraints = false
        roomNameView.clipsToBounds = true
//        roomNameView.textAlignment = .center
    }
    private func configureNotiView() {
        addSubview(notiView)
        notiView.contentMode = .scaleAspectFit
//        notiView.image = UIImage(systemName: "flame.fill")
        notiView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //
    private func configureLogoView() {
        addSubview(logoView)
        logoView.translatesAutoresizingMaskIntoConstraints = false
        logoView.contentMode = .scaleAspectFit
        logoView.clipsToBounds = true
    }
    
    private func configureConstraints() {
        let constraints = [
            logoView.centerYAnchor.constraint(equalTo: centerYAnchor),
            logoView.heightAnchor.constraint(equalToConstant: 30),
            logoView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            logoView.widthAnchor.constraint(equalTo: logoView.heightAnchor),
            
            
            roomNameView.topAnchor.constraint(equalTo: logoView.topAnchor),
            roomNameView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            roomNameView.bottomAnchor.constraint(equalTo: logoView.bottomAnchor),
            
            notiView.centerYAnchor.constraint(equalTo: centerYAnchor),
            notiView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            notiView.widthAnchor.constraint(equalToConstant: 30),
            notiView.heightAnchor.constraint(equalTo: notiView.widthAnchor),
            
            roomNameView.trailingAnchor.constraint(equalTo: notiView.leadingAnchor, constant: -10),
        ]
        addConstraints(constraints)
    }
    func configureContents(image: UIImage, name: String) {
        logoView.image = image
        roomNameView.text = name
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: true)
        super.setSelected(false, animated: true)
        // Configure the view for the selected state
    }

}
