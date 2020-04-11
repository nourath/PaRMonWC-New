//
//  PhysicianHomeViewController.swift
//  PaRMonWC
//
//  Author: Shoaa Alqarni 
//  Copyright © 2020 Noura. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class CellClass: UITableViewCell {
    
}

class PhysicianHomeViewController: UIViewController {

    @IBOutlet weak var getNameLabel: UILabel!
    
    
    @IBOutlet weak var btnSelectedPathent: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var items: [Patient] = []
    //let tableView = UITableView()
    let transparentView = UIView()
    var dataSource = [String]()
    var selectedButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readPhysiciansArray()
        readPatientsArray()
//        tableView.delegate = self
//        tableView.dataSource = self
        tableView.register(CellClass.self, forCellReuseIdentifier: "Cell")
        tableView.isHidden = true
    }
    
    func addTransparentView(frames: CGRect) {
        self.tableView.isHidden = false
        let window = UIApplication.shared.keyWindow
        transparentView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transparentView)
        
        tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        self.view.addSubview(tableView)
        tableView.layer.cornerRadius = 5
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        tableView.reloadData()
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapgesture)
        transparentView.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: CGFloat(self.dataSource.count * 50))
        }, completion: nil)
    }
    
    @objc func removeTransparentView() {
        let frames = selectedButton.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        }, completion: nil)
    }
    
    func readPhysiciansArray(){
          
            if let userId = Auth.auth().currentUser?.uid {
            
            let db = Firestore.firestore()
            db.collection("physicians").getDocuments { (snapshot, err) in
               if let err = err {
                       print("Error getting patient's name: \(err)")
                   } else {

                    if let currentUserDoc = snapshot?.documents.first(where: {($0["uid"] as? String) == userId }) {       let getName = currentUserDoc["lname"] as! String
                           self.getNameLabel.text = "Dr. \(getName)"
                        }
                    }
                }
            }

    }
    
    func readPatientsArray(){
          
           // if let userId = Auth.auth().currentUser?.uid {
            
            let db = Firestore.firestore()
            db.collection("patients").getDocuments { (snapshot, err) in
               if let err = err {
                       print("Error getting list of patients: \(err)")
                   } else {
                    
                    
                    var newItems: [Patient] = []
                    for item in snapshot!.documents {
                        let patient = Patient(snapshot: item)
                        newItems.append(patient)
                        self.dataSource.append(patient.uid)
                    }
                        self.items = newItems
                        self.tableView.reloadData()
                    }
                }
            //}

    }
    
    @IBAction func onClickSelectPathent(_ sender: Any)
    {
        selectedButton = btnSelectedPathent
        addTransparentView(frames: btnSelectedPathent.frame)
    }
    
    
    
    func transitionToHome(patient: Patient){
        let tabVC =  storyboard?.instantiateViewController(identifier:Constants.Storyboard.tabVC) as! PhysicianPatientsTabBarController
        tabVC.patient = patient
           
        let navigationController = UINavigationController(rootViewController: tabVC)
         self.present(navigationController, animated: true, completion: nil)

    }
}

extension PhysicianHomeViewController: UITableViewDelegate, UITableViewDataSource {
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return dataSource.count
       }

       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].fname + " " + items[indexPath.row].lname
           return cell
       }

       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 50
       }

       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//           performSegue(withIdentifier: "segueOfMed", sender: self)
            
        transitionToHome(patient: self.items[indexPath.row])
           removeTransparentView()
       }
   }
