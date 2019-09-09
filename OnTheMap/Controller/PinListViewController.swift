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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        OnTheMapAPIClient.getStudentLocations(completion: handleStudentLocationResponse(success:results:error:))
    }
    
    //MARK: API Response Functions
    func handleStudentLocationResponse(success: Bool, results: [StudentLocationDetails]?, error: Error?) {
        startActivityIndicator(activityIndicator, true)
        studentLocationResults.removeAll()
        tableView.reloadData()
        
        if success {
            if let studentLocationArray = results {
                studentLocationResults = studentLocationArray
                tableView.reloadData()
                startActivityIndicator(activityIndicator, false)
            }
        } else {
            if let error = error {
                displayUIAlert(titled: "Error getting student locations", withMessage: error.localizedDescription)
            } else {
                print("Generic error getting student locations")
            }
            startActivityIndicator(activityIndicator, false)
        }
    }
}

//MARK: Table view functions
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
