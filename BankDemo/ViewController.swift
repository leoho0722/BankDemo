import UIKit
import RealmSwift

class ViewController: UIViewController {

    @IBOutlet weak var nowLoginButton:UIButton!
    @IBOutlet weak var welcomeLoginLabel:UILabel!
    
    var isSignIn:Bool = false
    var tmpSegmentIndex:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //一登出就從 Realm 資料庫裡刪掉帳號
    func signOutToAllAccount() {
        let realm = try! Realm()
        let networkMember = NetworkBankMember()
        let creditCardMember = CreditCardMember()
        if (self.tmpSegmentIndex == 0) {
            let networkMember = realm.objects(NetworkBankMember.self)
            try! realm.write {
                realm.delete(networkMember)
            }
        } else if (self.tmpSegmentIndex == 1) {
            let creditCardMember = realm.objects(CreditCardMember.self)
            try! realm.write {
                realm.delete(creditCardMember)
            }
        }
        print(realm.configuration.fileURL!)
    }
    
    @IBAction func nowLoginBtn(_ sender: UIButton) {
        DispatchQueue.main.async {
            if (self.isSignIn) {
                self.nowLoginButton.setTitle("登出帳號", for: .normal)
                self.nowLoginButton.backgroundColor = UIColor.blue
                print("是否要登出帳號")
                let alertController = UIAlertController(
                    title: "帳號登出", message: "是否要登出帳號？", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "取消", style: .cancel)
                let okAction = UIAlertAction(title:"登出",style:.default){
                    (action) in
                    self.isSignIn = false
                    self.signOutToAllAccount()
                    let alertController = UIAlertController(title: "帳號登出", message: "帳號已登出！", preferredStyle: .alert)
                    let closeAction = UIAlertAction(title: "關閉", style: .default){
                        (action) in
                        self.nowLoginButton.setTitle("立即登入", for: .normal)
                        self.nowLoginButton.backgroundColor = UIColor.red
                        self.welcomeLoginLabel.text = "歡迎使用者登入！"
                    }
                    alertController.addAction(closeAction)
                    self.present(alertController,animated: true)
                }
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true)
            } else {
                if let controller = self.storyboard?.instantiateViewController(identifier: "LoginPage") { self.show(controller,sender: self) }
            }
        }
    }
    
    @IBAction func notificationBtn(_ sender: UIButton) {
        if let controller = storyboard?.instantiateViewController(identifier: "NotificationPage") {
            self.show(controller,sender: self)
        }
    }
    
    // MARK: - 透過 UnWind Segue 從 LoginViewController 取值
    
    @IBAction func unwindToMainFromLogin(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source as? LoginViewController
        self.welcomeLoginLabel.text = "歡迎" + (sourceViewController?.userNameTextField.text ?? "123") + "登入！"
        self.isSignIn = ((sourceViewController?.tmpSignIn) != nil)
        self.tmpSegmentIndex = sourceViewController?.segmentIndex as! Int
        self.nowLoginButton.setTitle("登出帳號", for: .normal)
        self.nowLoginButton.backgroundColor = UIColor.blue
    }
}
