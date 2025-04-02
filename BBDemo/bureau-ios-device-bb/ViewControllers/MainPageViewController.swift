//
//  MainPageViewController.swift
//  bureau-ios-device-bb
//
//  Created by apple on 27/03/25.
//

import UIKit
import SideMenu

class MainPageViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinnerView: UIActivityIndicatorView!

    let pageData: [(title: String, icon: String, description: String)] = [
        ("Sign-in", "HandPointing", "Profile a user’s sign-in action through key actions, touches, taps, sensor movement, device hardware parameters, and network parameters to identify the authenticity of the person signing in."),
        ("Checkout", "hand-card", "Track the user’s checkout behavior by analyzing touch patterns, payment actions, device parameters, and network signals to validate the authenticity of the transaction."),
        ("Account Sign-up", "add-user", "Monitor the account creation process by profiling typing speed, field interactions, device parameters, and behavioral patterns to prevent fraudulent sign-ups.")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()  // Ensure data is reloaded
    }
    
    @IBAction func menuAct(_ sender: Any) {
        let menu = SideMenuNavigationController(rootViewController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SideMenuViewController") as! SideMenuViewController)
        menu.leftSide = true
        menu.setNavigationBarHidden(true, animated: true)
        menu.presentationStyle = .menuSlideInCustom
        menu.menuWidth = view.frame.width * 0.70
        menu.statusBarEndAlpha = 0
        present(menu, animated: true, completion: nil)
    }

}

extension MainPageViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pageData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PageTypeCell") as? PageTypeCell
        cell?.cellBorderView.layer.borderColor = UIColor(red: 212/255, green: 223/255, blue: 247/255, alpha: 1).cgColor
        cell?.pageTypetitle.text = pageData[indexPath.row].title
        cell?.pageTypeDisc.text = pageData[indexPath.row].description
        cell?.pageTypeIco.image = UIImage(named: pageData[indexPath.row].icon)
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        switch indexPath.row{
        case 0:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let VC = storyboard.instantiateViewController(withIdentifier: "SigninVC") as! SigninVC
            VC.isBBEnable = true
            self.navigationController?.pushViewController(VC, animated: true)
            
        case 1:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let VC = storyboard.instantiateViewController(withIdentifier: "CheckoutViewController") as! CheckoutViewController
            VC.isBBEnable = false
            self.navigationController?.pushViewController(VC, animated: true)
        default:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let VC = storyboard.instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
            VC.isBBEnable = false
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
}

class PageTypeCell:UITableViewCell{
    @IBOutlet weak var cellBorderView: UIView!
    @IBOutlet weak var pageTypeIco: UIImageView!
    @IBOutlet weak var pageTypetitle: UILabel!
    @IBOutlet weak var pageTypeDisc: UILabel!
}
