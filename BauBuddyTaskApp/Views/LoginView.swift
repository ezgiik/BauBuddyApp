//
//  LoginView.swift
//  BauBuddyTaskApp
//
//  Created by EZGİ KARABAY on 8.01.2024.
//

import UIKit

class LoginView: UIViewController {

    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    let authService = AuthService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func performLogin() {
                guard let username = usernameText.text, !username.isEmpty,
                      let password = passwordText.text, !password.isEmpty
                else {
                    print("Username and/or password cannot be empty")
                    return
                }

                authService.login(username: username, password: password) { result in
                    switch result {
                    case .success(let auth):
                        
                        
                        print("Access Token: \(auth.accessToken)")

                        
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "toNext", sender: auth)
                        }
                    case .failure(let error):
                        
                        print("Login error: \(error)")
                    }
                }
            }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        performLogin()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "toNext" {
                if let auth = sender as? Auth,
                   let tabBarController = segue.destination as? UITabBarController,
                   let taskListView = tabBarController.viewControllers?[0] as? TaskListView {
                    taskListView.auth = auth
                }
            }
        }

    

}
