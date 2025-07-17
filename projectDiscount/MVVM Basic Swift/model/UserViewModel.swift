//
//  UserViewModel.swift
//  projectDiscount
//
//  Created by MacDetail on 17/7/2568 BE.
//

import Foundation

// 2. ViewModel (จัดการข้อมูลและโลจิก)
class UserViewModel {
//    private let user: User
    public var user: User
    
    var displayName:String {
        return "Hello,\(user.name)"
    }
    
    // init บังคับ
    init(user: User) {
        self.user = user
    }
    
    // เพิ่ม func
    func changeName(to newName: String) {
        user.name = newName
    }
}
