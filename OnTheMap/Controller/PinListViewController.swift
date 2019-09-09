//
//  PinListViewController.swift
//  OnTheMap
//
//  Created by Charlie Scheer on 8/28/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import UIKit

class PinListViewController: MapAndPinViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var userLocation: StudentLocationResults?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleStudentLocationsRespone()
        print("Pin List View")
    }
    
    func handleStudentLocationsRespone() {
        startActivityIndicator(activityIndicator, true)
        studentLocationResults.removeAll()
        tableView.reloadData()
        OnTheMapAPIClient.getStudentLocations { (success, results, error) in
            if success {
                if let studentLocationArray = results {
                    self.studentLocationResults = studentLocationArray
                    self.tableView.reloadData()
                    self.startActivityIndicator(self.activityIndicator, false)
                    print("activity indicator finished")
                }
            } else {
                print(error!.localizedDescription)
            }
        }
        
        print(studentLocationResults.count)
    }
    
    
}

extension PinListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: constants.cellIdentifier, for: indexPath) as! PinListCell
        let student = studentLocationResults[indexPath.row]
        cell.studentNameLabel.text = student.firstName + " " + student.lastName
        cell.studentLocationLabel.text = student.mediaURL
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocationResults.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = studentLocationResults[indexPath.row]
        
        guard let url = URL(string: student.mediaURL) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            displayUIAlert(titled: "URL Not Valid", withMessage: "Can not open URL for selected student")
        }
        
    }
}

extension PinListViewController {
    enum constants {
        static let cellIdentifier = "studentCell"
    }
}
