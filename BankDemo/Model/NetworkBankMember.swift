import Foundation
import RealmSwift

class NetworkBankMember: Object {
    @objc dynamic var memberID = UUID().uuidString
    @objc dynamic var username:String = ""
    @objc dynamic var personID:String = ""
    @objc dynamic var account:String = ""
    @objc dynamic var password:String = ""
    @objc dynamic var loginTime:String = ""
    @objc dynamic var isLogined:Bool = false
    
    override static func primaryKey() -> String {
        return "memberID"
    }
}
