//
//  LoginViewController.swift
//  BackgroundLoginSignUp
//
//  Created by TALHA AYAR on 26.10.2018.
//  Copyright © 2018 TALHA AYAR. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import SkyFloatingLabelTextField
import Firebase
import FirebaseAuth
import FirebaseCore
import GoogleSignIn


class ViewController: UIViewController, GIDSignInUIDelegate {
    
    
    
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var signUpLabel: UILabel!
    
    var player = AVPlayer()
    let videoURL = URL(string: "https://video.twimg.com/tweet_video/DqP1dUTW4AIxTdA.mp4")
    
    
    override func viewDidLoad() {
        
        player = AVPlayer(url: videoURL!)
        videoBackround()
        signUp()
     
    }
    
    @IBAction func loginButton(_ sender: Any) {
          if emailTextField.text != "" && passwordTextField.text != "" {
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                let alert = UIAlertController(title: "ERROR", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "Done", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            } else {
                UserDefaults.standard.set(user?.user.email, forKey: "user")
                UserDefaults.standard.synchronize()
                self.performSegue(withIdentifier: "successLogin", sender: nil)
                UserDefaults.standard.set(user?.user.email, forKey: "user")
                UserDefaults.standard.synchronize()
                
                
            }
            
            
             }
        }
        
    }
    @IBAction func continueWithFBButton(_ sender: Any) {
       
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "successLogin" {
            player.pause()
        }
    }
    
    
    func signUp() {
        signUpLabel.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.goToSignUp))
        signUpLabel.addGestureRecognizer(gestureRecognizer)
    }
    @objc func goToSignUp() {
        performSegue(withIdentifier: "toSignUp", sender: nil)
    }
    func videoBackround() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
            self.player.seek(to: CMTime.zero)
            self.player.play()
            self.player.volume = 0
        }
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        
        self.videoView.layer.addSublayer(playerLayer)
        player.play()
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
    }
    
  
    
   
    @IBAction func googleButton(_ sender: Any) {
       
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        
        if error != nil {
            let alert = UIAlertController(title: "ERROR", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "Done", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        } else {
           
            self.performSegue(withIdentifier: "successLogin", sender: nil)
           
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
       Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
           print("success")
                
            }
        }
    }
    

