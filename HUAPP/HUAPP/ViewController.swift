//
//  ViewController.swift
//  HUAPP
//
//  Created by Eduardo Gaona on 8/17/18.
//  Copyright © 2018 codewitheddie. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class ViewController: UIViewController {
    
    var ref: DatabaseReference!
    
    
    @IBOutlet weak var signInSelector: UISegmentedControl!
    @IBOutlet weak var signInLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var fullNameTextField: UITextField!
    
    
    var isSignIn:Bool = true
    
    
    //Throw user into the database
    
    override func viewDidLoad() {
        ref = Database.database().reference(withPath: "Users")
        fullNameTextField.isHidden = true
        fullNameLabel.isHidden = true
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signInSelectorChanged(_ sender: UISegmentedControl) {
        //Flip the boolean for the segment button
        isSignIn = !isSignIn
        
        if isSignIn {
            signInLabel.text = "Sign In"
            signInButton.setTitle("Sign In", for: .normal)
            fullNameLabel.isHidden = true
            fullNameTextField.isHidden = true
        }
        
        else {
            signInLabel.text = "Register"
            signInButton.setTitle("Register", for: .normal)
            fullNameLabel.isHidden = false
            fullNameTextField.isHidden = false
        }
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        // TODO: Do some form validation on the email and password
        
        if let email = emailTextField.text, let pass = passwordTextField.text {
            //Check if it is signed in or register
            if isSignIn {
                //Sign in the user
                Auth.auth().signIn(withEmail: email, password: pass, completion: { (user, error) in
                    //Check that user isn't nill
                    
                    if let u = user {
                        //User is found go to home screen
                        self.performSegue(withIdentifier: "goToHome", sender: self)
                    }
                    
                    else {
                        //Error, check error and show message
                        print("Please register for an account")
                    }
                })
            }
                
            else {
                //Register the user with Firebase
                
                
                Auth.auth().createUser(withEmail: email, password: pass, completion: { (user, error) in
                    //check that user is not nill
                    
                    if let u = user {
                        self.performSegue(withIdentifier: "goToHome", sender: self)
                    }
                        
                    
                    else {
                        //Error: Show error and display message
                        print("Please Register for an account")
                    }
                    
                    let userEmail: String = self.emailTextField.text!
                    let userPassword: String = self.passwordTextField.text!
                    let fullName: String = self.fullNameTextField.text!
                    self.ref.child("users").child(fullName).setValue(["Email": userEmail, "Password": userPassword])

                })
                
            }
            
            
        }
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Dismiss the keyboard when the view is tapped on
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
}

