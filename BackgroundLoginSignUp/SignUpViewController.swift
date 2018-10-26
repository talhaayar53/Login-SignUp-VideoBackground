//
//  SignUpViewController.swift
//  BackgroundLoginSignUp
//
//  Created by TALHA AYAR on 26.10.2018.
//  Copyright © 2018 TALHA AYAR. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Firebase
import FirebaseAuth
import AVKit
import AVFoundation

class SignUpViewController: UIViewController {
    @IBOutlet weak var toLogin: UILabel!
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var nameSurnameTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextFieldWithIcon!
    var player = AVPlayer()
    let videoURL = URL(string: "https://video.twimg.com/tweet_video/Dl9N4aRXoAEgF-4.mp4")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        player = AVPlayer(url: videoURL!)
        videoBackround()
        login()
        
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "successLogin" {
            player.pause()
        }
    }
    
    func login() {
        toLogin.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.goToLogin))
        toLogin.addGestureRecognizer(gestureRecognizer)
    }
    @objc func goToLogin() {
        performSegue(withIdentifier: "toLogin", sender: nil)
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        
        if emailTextField.text != "" && passwordTextField.text != "" && nameSurnameTextField.text != "" {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if error != nil {
                    let alert = UIAlertController(title: "ERROR", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "Done", style: UIAlertAction.Style.cancel, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    print("success")
                    UserDefaults.standard.set(user?.user.email, forKey: "user")
                    UserDefaults.standard.synchronize()
                   
                    
                    self.performSegue(withIdentifier: "successSignUp", sender: nil)
                }
                
            }
            
        } else {
            let alert = UIAlertController(title: "ERROR", message: "Boş bir alan bıraktınız.", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "Done", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
            
        }
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
}
