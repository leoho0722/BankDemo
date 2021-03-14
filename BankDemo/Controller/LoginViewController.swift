import UIKit
import IQKeyboardManagerSwift
import RealmSwift

class LoginViewController: UIViewController {

    @IBOutlet weak var bannerLabel:UILabel!
    @IBOutlet weak var accountTextField:UITextField!
    @IBOutlet weak var personIDTextField:UITextField!
    @IBOutlet weak var passwordTextField:UITextField!
    @IBOutlet weak var userNameTextField:UITextField!
    @IBOutlet weak var userCategory:UISegmentedControl!
    @IBOutlet weak var userNameInputErrorLabel:UILabel!
    @IBOutlet weak var personIDInputErrorLabel:UILabel!
    @IBOutlet weak var accountInputErrorLabel:UILabel!
    @IBOutlet weak var passwordInputErrorLabel:UILabel!
    @IBOutlet weak var loginButton:UIButton!
    @IBOutlet weak var cancelLoginButton:UIButton!
    
    var segmentIndex: Int = 0
    var userName:String!
    var personID:String!
    var account:String!
    var password:String!
    var tempUserName:String!
    var tmpSignIn:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerLabel.text = "請輸入網路/行動銀行 會員帳號與密碼"
        userNameInputErrorLabel.isHidden = true
        personIDInputErrorLabel.isHidden = true
        accountInputErrorLabel.isHidden = true
        passwordInputErrorLabel.isHidden = true
        
        loginButton.layer.cornerRadius = 15
        cancelLoginButton.layer.cornerRadius = 15
    }
    
    //點選空白處關閉鍵盤
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - 寫入 Realm 資料庫
    
    func NetworkBankMemberLogin() {
        userName = userNameTextField.text
        personID = personIDTextField.text
        account = accountTextField.text
        password = passwordTextField.text
        let realm = try! Realm()
        let networkBankMember = NetworkBankMember()
        networkBankMember.username = userName
        networkBankMember.personID = personID
        networkBankMember.account = account
        networkBankMember.password = password
        networkBankMember.loginTime = self.getSystemTime()
        networkBankMember.isLogined = true
        self.tmpSignIn = true
        try! realm.write {
            realm.add(networkBankMember)
        }
        print(realm.configuration.fileURL!)
    }
    
    func CreditCardMemberLogin() {
        userName = userNameTextField.text
        personID = personIDTextField.text
        account = accountTextField.text
        password = passwordTextField.text
        let realm = try! Realm()
        let creditCardMember = CreditCardMember()
        creditCardMember.username = userName
        creditCardMember.personID = personID
        creditCardMember.account = account
        creditCardMember.password = password
        creditCardMember.loginTime = self.getSystemTime()
        creditCardMember.isLogined = true
        self.tmpSignIn = true
        try! realm.write {
            realm.add(creditCardMember)
        }
        print(realm.configuration.fileURL!)
    }
    
    // MARK: - 登入欄位正規表示法
    
    func checkInputFormat() {
        if (isValidUserName(username: userNameTextField.text!)) {
        } else {
            userNameInputErrorLabel.isHidden = false
        }
        if (isValidAccount(account: accountTextField.text!)) {
        } else {
            accountInputErrorLabel.isHidden = false
        }
        if (isValidPassword(password: passwordTextField.text!)) {
        } else {
            passwordInputErrorLabel.isHidden = false
        }
        if (isValidPersonID(id: personIDTextField.text!)) {
        } else {
            personIDInputErrorLabel.isHidden = false
        }
    }
    func isValidUserName(username:String) -> Bool {
        let usernameRegex = "^[a-zA-Z0-9]{4,10}$"
        let usernamePredicate = NSPredicate(format:"SELF MATCHES %@",usernameRegex)
        return usernamePredicate.evaluate(with: username)
    }
    func isValidAccount(account:String) -> Bool{
        let accountRegex = "^[a-zA-Z0-9]{4,10}$"
        let accPredicate = NSPredicate(format:"SELF MATCHES %@",accountRegex)
        return accPredicate.evaluate(with: account)
    }
    func isValidPassword(password:String) -> Bool{
        let passwordRegex = "^[A-Z][a-zA-Z0-9]{5,9}$"
        let pwdPredicate = NSPredicate(format:"SELF MATCHES %@",passwordRegex)
        return pwdPredicate.evaluate(with: password)
    }
    func isValidPersonID(id:String) -> Bool{
        let idRegex = "[A-Z]{1}[12]{1}[0-9]{8}$"
        let idPredicate = NSPredicate(format:"SELF MATCHES %@",idRegex)
        return idPredicate.evaluate(with: id)
    }
    
    // MARK: - Other Function
    
    //取得目前時間
    func getSystemTime() -> String {
        let currectDate = Date()
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY/MM/dd HH:mm:ss"
        dateFormatter.locale = Locale.ReferenceType.system
        dateFormatter.timeZone = TimeZone.ReferenceType.system
        return dateFormatter.string(from: currectDate)
    }
    
    func cleanData() {
        userNameTextField.text = ""
        personIDTextField.text = ""
        accountTextField.text = ""
        passwordTextField.text = ""
        self.userNameInputErrorLabel.isHidden = true
        self.personIDInputErrorLabel.isHidden = true
        self.accountInputErrorLabel.isHidden = true
        self.passwordInputErrorLabel.isHidden = true
    }
    
    // MARK: - IBAction Function
    
    @IBAction func memberCategory(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0) {
            bannerLabel.text = "請輸入網路/行動銀行 會員帳號與密碼"
            cleanData()
        } else if (sender.selectedSegmentIndex == 1) {
            bannerLabel.text = "請輸入信用卡會員 會員帳號與密碼"
            cleanData()
        }
        segmentIndex = sender.selectedSegmentIndex
    }
    
    @IBAction func loginBtn(_ sender: UIButton) {
        self.checkInputFormat()
        if (self.userNameInputErrorLabel.isHidden == false || self.personIDInputErrorLabel.isHidden == false ||
            self.accountInputErrorLabel.isHidden == false || self.passwordInputErrorLabel.isHidden == false) {
            let alertController = UIAlertController(title: "", message: "登入資料錯誤！", preferredStyle: .alert)
            let closeAction = UIAlertAction(title: "關閉", style: .cancel, handler: nil)
            alertController.addAction(closeAction)
            self.present(alertController,animated: true)
        } else {
            DispatchQueue.main.async {
                if (self.segmentIndex == 0) {
                    self.NetworkBankMemberLogin()
                } else {
                    self.CreditCardMemberLogin()
                }
            } 
            self.userNameInputErrorLabel.isHidden = true
            self.personIDInputErrorLabel.isHidden = true
            self.accountInputErrorLabel.isHidden = true
            self.passwordInputErrorLabel.isHidden = true
        }
    }
}
