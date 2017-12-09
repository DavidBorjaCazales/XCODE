//
//  FacebookViewController.swift
//  Santander Twist
//
//  Created by Giovanni Aranda on 07/12/17.
//  Copyright © 2017 Hyperiondg. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class FacebookViewController: UIViewController,FBSDKLoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = FBSDKLoginButton()
        loginButton.delegate = self
        loginButton.center = view.center
        //read_custom_friendlists,user_about_me,user_birthday,user_education_history,user_friends,user_hometown,user_location,user_relationship_details,user_relationships,user_religion_politics,user_work_history
        loginButton.readPermissions = ["public_profile", "email", "user_friends","user_likes","read_custom_friendlists","user_about_me","user_birthday","user_education_history","user_friends","user_hometown","user_location","user_relationship_details","user_relationships","user_religion_politics","user_work_history"]
        view.addSubview(loginButton as! UIView)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if ((error) != nil)
        {
            // Process error
        }else if result.isCancelled{
        }else{
            
            if result.grantedPermissions.contains("email"){
                returnUserData()
            }
            
        }
    }
    
    func returnUserData(){
        let graphRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"name,id,link,gender,locale,first_name,last_name,middle_name,likes,picture,timezone,updated_time,verified,age_range,education,friends,hometown,location,interested_in,work"] )
        graphRequest.start { (connection, result, error) in
            if ((error) != nil)
            {
                print("Error: \(error)")
            }
            else
            {
                do{
                    let data:[String: AnyObject] = result as! [String: AnyObject]
                    self.cargarLogin(dato: data)
                }catch{
                    print(error)
                }
            }
        }
    }
    
    func cargarLogin(dato: [String: AnyObject]){
        
        let url = NSURL(string: "http://panel.santandertwist.com.mx/user/post_login_fb")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "POST"
        let body = "data=\(dato)"
        request.httpBody = body.data(using: String.Encoding.utf8)
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, reponse, error) in
            if error == nil{
                
                DispatchQueue.main.async(execute: {
                    
                       // print(dato)
                    
                    
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "principal") as! ViewController
                        vc.faceLog = true
                        vc.nameface = dato["name"] as! String
                        vc.idface = dato["id"] as! String
                        self.present(vc, animated: false, completion: nil)
                    
                })
                
            }else{
                
                print("ErrorShared: \(error)")
            }
        }).resume()
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
