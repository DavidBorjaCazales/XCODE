//
//  ViewController.swift
//  Santander Twist
//
//  Created by Giovanni Aranda on 06/12/17.
//  Copyright © 2017 Hyperiondg. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIWebViewDelegate,UIScrollViewDelegate,NSURLConnectionDelegate {

    @IBOutlet weak var webView: UIWebView!
    var faceLog:Bool = false
    var face:String?
    var idface:String?
    var nameface:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let preferences = WKPreferences()
        
        webView.delegate = self
        webView.scrollView.delegate = self
        webView.scrollView.bounces = false
        // Do any additional setup after loading the view, typically from a nib.
        
        if faceLog{
            let URL = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "assets")
            let request = NSURLRequest(url: URL!)
            webView.loadRequest(request as URLRequest)
        }else{
            let URL = Bundle.main.url(forResource: "login", withExtension: "html", subdirectory: "assets")
            let request = NSURLRequest(url: URL!)
            webView.loadRequest(request as URLRequest)
        }
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height){
            scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: scrollView.contentSize.height - scrollView.frame.size.height), animated: false)
        }
        
        
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        let _req : String = request.url?.absoluteString ?? " "
        
        let primer_separacion = _req.components(separatedBy: "//")
        let variables = primer_separacion[1].components(separatedBy: "&");
        
        if(_req.contains("loginfacebook")){
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "face") as! FacebookViewController
            self.present(vc, animated: false, completion: nil)
            
        }
        
        return true;
    }
    
    func  connection(_ connection: NSURLConnection, canAuthenticateAgainstProtectionSpace protectionSpace: URLProtectionSpace) -> Bool {
        return true
    }
    
    func connection(_ connection: NSURLConnection, didReceive challenge: URLAuthenticationChallenge) {
        challenge.sender?.use(URLCredential(trust: (challenge.protectionSpace.serverTrust)!), for: challenge)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
extension String
{
    func encodeUrl() -> String
    {
        return self.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    func decodeUrl() -> String
    {
        return self.removingPercentEncoding!
    }
    
}

