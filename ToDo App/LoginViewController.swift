//
//  LoginViewController.swift
//  ToDo App
//
//  Created by echessa on 8/11/16.
//  Copyright © 2016 Echessa. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    var gradient:CAGradientLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //addGradient()
        
        signInButton.layer.cornerRadius = 10
        emailField.delegate = self
        passwordField.delegate = self
        
        emailField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
    }
    
    func addGradient() {
        gradient = CAGradientLayer()
        let startColor = UIColor(red: 3/255, green: 196/255, blue: 190/255, alpha: 1)
        let endColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        gradient?.colors = [startColor.cgColor,endColor.cgColor]
        gradient?.startPoint = CGPoint(x: 0, y: 0)
        gradient?.endPoint = CGPoint(x: 0, y:1)
        gradient?.frame = view.frame
        self.view.layer.insertSublayer(gradient!, at: 0)
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if (emailField.text?.isEmpty)! {
            signInButton.isEnabled = false
            signInButton.alpha = 0.5
        }
        else {
            if (passwordField.text?.isEmpty)! {
               signInButton.isEnabled = false
            signInButton.alpha = 0.5
            } else {
                signInButton.isEnabled = true
                signInButton.alpha = 1
            }
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        signInButton.isEnabled = false
        signInButton.alpha = 0.5
        
        if let token = Auth.auth().currentUser {
            self.signIn()
        }
    }

    @IBAction func didTapSignIn(_ sender: UIButton) {
        
        guard let login = emailField.text
            else {
                showAlert("L'adresse mail ne peut être pas vide...")
                emailField.resignFirstResponder()
                return
                
        }
        guard let password = passwordField.text
            else {
                showAlert( "Le mot de passe ne peut pas être vide...")
                passwordField.resignFirstResponder()
                return
        }
        
        Auth.auth().signIn(withEmail: login, password: password) { (user, error) in
            if error == nil{
               self.signIn()   //self.performSegue(withIdentifier: "loginToHome", sender: self)
            }
            else{
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                //TODO:Gerer les focus en fonction des codes erreurs...
                self.passwordField.text = ""
                self.passwordField.resignFirstResponder()
            }
        }
            
    }

    @IBAction func didRequestPasswordReset(_ sender: UIButton) {
        
//        let prompt = UIAlertController(title: "To Do App", message: "Email:", preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
//            let userInput = prompt.textFields![0].text
//            if (userInput!.isEmpty) {
//                return
//            }
//            Auth.auth().sendPasswordReset(withEmail: userInput!, completion: { (error) in
//                if let error = error {
////                    if let errCode = AuthErrorCode(rawValue: error._code) {
////                        switch errCode {
////                        case .errorCodeUserNotFound:
////                            DispatchQueue.main.async {
////                                self.showAlert("User account not found. Try registering")
////                            }
////                        default:
////                            DispatchQueue.main.async {
////                                self.showAlert("Error: \(error.localizedDescription)")
////                            }
////                        }
////                    }
//                    return
//                } else {
//                    DispatchQueue.main.async {
//                        self.showAlert("You'll receive an email shortly to reset your password.")
//                    }
//                }
//            })
//        }
//        prompt.addTextField(configurationHandler: nil)
//        prompt.addAction(okAction)
//        present(prompt, animated: true, completion: nil)
        
        let forgotPasswordAlert = UIAlertController(title: "Forgot password?", message: "Enter email address", preferredStyle: .alert)
        forgotPasswordAlert.addTextField { (textField) in
            textField.placeholder = "Enter email address"
        }
        forgotPasswordAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        forgotPasswordAlert.addAction(UIAlertAction(title: "Reset Password", style: .default, handler: { (action) in
            let resetEmail = forgotPasswordAlert.textFields?.first?.text
            Auth.auth().sendPasswordReset(withEmail: resetEmail!, completion: { (error) in
                //Make sure you execute the following code on the main queue
                DispatchQueue.main.async {
                    if error != nil{
                        let resetFailedAlert = UIAlertController(title: "Reset Failed", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                        resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(resetFailedAlert, animated: true, completion: nil)
                    }else {
                        let resetEmailSentAlert = UIAlertController(title: "Reset email sent successfully", message: "Check your email", preferredStyle: .alert)
                        resetEmailSentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(resetEmailSentAlert, animated: true, completion: nil)
                    }
                }
                
            })
        }))
        //PRESENT ALERT
        self.present(forgotPasswordAlert, animated: true, completion: nil)
        
    }

    func showAlert(_ message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "To Do App", message: message, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }

    func signIn() {
        performSegue(withIdentifier: "SignInFromLogin", sender: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }

}
