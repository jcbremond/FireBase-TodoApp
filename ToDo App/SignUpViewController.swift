//
//  SignUpViewController.swift
//  ToDo App
//
//  Created by Jcb.
//  Copyright © 2018 Pilgrim Software. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordConfirmField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    var gradient:CAGradientLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //addGradient()
        
        signUpButton.layer.cornerRadius = 10
        emailField.delegate = self
        passwordField.delegate = self
        passwordConfirmField.delegate = self
        
        emailField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordConfirmField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        signUpButton.isEnabled = false
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if (textField.text?.isEmpty)! {
            signUpButton.isEnabled = false
        }
        else {
            signUpButton.isEnabled = true
        }
    }
    
    @IBAction func didTapSignUp(_ sender: UIButton) {

        guard let login = emailField.text else {return}
        
        if !login.isValidEmail() {
            showAlert( "L'adresse email n'est pas valide")
            emailField.resignFirstResponder()
            return
        }
        
        if passwordField.text != passwordConfirmField.text{
            let alertController = UIAlertController(title: "Password Incorrect", message: "Please re-type password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
            passwordConfirmField.resignFirstResponder()
        }
        else{
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!){ (user, error) in
                if error == nil {
                    //self.performSegue(withIdentifier: "signupToHome", sender: self)
                    self.signIn()
                }
                else{
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func didTapBackToLogin(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {})
    }
    
    func showAlert(_ message: String) {
        let alertController = UIAlertController(title: "To Do App", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func signIn() {
        performSegue(withIdentifier: "SignInFromSignUp", sender: self)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
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
    
}
