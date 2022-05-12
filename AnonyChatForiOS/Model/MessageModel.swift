//
//  Message.swift
//  AnonyChat-iOS
//
//  Created by 闫润邦 on 2022/5/10.
//

import Foundation
class Message {
    
    //
    private var map: [String: Any]
    
    //
    public func addAttr(_ key: String, _ value: Any) {
        map[key] = value
    }
    public func removeAttr(_ key: String) {
        map.removeValue(forKey: key)
    }
    public func getAttr(_ key: String) -> Any {
        return map[key]!
    }
    
    //
    init() {
        map = [:]
    }
    
    //Normal
    init(from: String, to: String, normalContent: String) {
        map = [:]
        addAttr("msgType", "Normal")
        addAttr("from", from)
        addAttr("to", to)
        addAttr("msgContent", normalContent)
        addAttr("date", getDatetimeAsString())
    }
    
    //Online
    init(onlineName: String, tim: String, onlineUsers: [String]) {
        map = [:]
        addAttr("msgType", "ConnectionEstablished")
        addAttr("name", onlineName)
        addAttr("date", tim)
        addAttr("onlineUsers", onlineUsers)
    }
    
    //Offline
    init(offlineName: String, tim: String, onlineUsers: [String]) {
        map = [:]
        addAttr("msgType", "ConnectionCut")
        addAttr("name", offlineName)
        addAttr("date", tim)
        addAttr("onlineUsers", onlineUsers)
    }
    
    //Reject
    init(to: String, rejectReason: String) {
        map = [:]
        addAttr("msgType", "ConnectionRejected")
        addAttr("to", to)
        addAttr("reason", rejectReason)
    }
    
    func getDatetimeAsString() -> String {
            let date = Date()
            let calendar = Calendar.current
            let year = calendar.component(.year, from: date)
            let month = calendar.component(.month, from: date)
            let day = calendar.component(.day, from: date)
            let hour = calendar.component(.hour, from: date)
            let minute = calendar.component(.minute, from: date)
            let second = calendar.component(.second, from: date)
            return String(year) + "/" + String(month) + "/" + String(day) + " " + String(hour) + ":" + String(minute) + ":" + String(second)
    }
    
    func getType() -> String {
        return map["msgType"]! as! String
    }
    
    func getMap() -> [String: Any] {
        return map
    }
}
