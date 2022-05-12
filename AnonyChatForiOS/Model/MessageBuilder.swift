//
//  MessageHandler.swift
//  AnonyChatForiOS
//
//  Created by 闫润邦 on 2022/5/10.
//

import Foundation

class MessageBuilder {
    
    public static func msgToString(_ msg: Message) -> String {
        let data = try! JSONSerialization.data(withJSONObject: msg.getMap(), options: [])
        let jsonStr = String(data: data, encoding: String.Encoding.utf8)!
        return jsonStr
    }
    
    public static func stringToMsg(_ msgString: String) -> Message {
        
        let jsonData = msgString.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        let json = try! JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        
        let dic = json as! [String: Any]
        
        if(dic["msgType"] as! String == "Normal") {
            return Message(from: dic["from"] as! String, to: dic["to"] as! String, normalContent: dic["msgContent"] as! String)
        }
        if(dic["msgType"] as! String == "ConnectionEstablished") {
            return Message(onlineName: dic["name"] as! String, tim: dic["date"] as! String, onlineUsers: dic["onlineUsers"] as! [String])
        }
        if(dic["msgType"] as! String == "ConnectionCut") {
            return Message(offlineName: dic["name"] as! String, tim: dic["date"] as! String, onlineUsers: dic["onlineUsers"] as! [String])
        }
        if(dic["msgType"] as! String == "ConnectionRejected") {
            return Message(to: dic["to"] as! String, rejectReason: dic["reason"] as! String)
        }
        
        return Message()
    }
    
    
}
