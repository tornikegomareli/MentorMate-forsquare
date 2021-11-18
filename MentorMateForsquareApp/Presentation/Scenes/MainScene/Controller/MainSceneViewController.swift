//
//  ViewController.swift
//  MentorMateForsquareApp
//
//  Created by Tornike Gomareli on 11.11.21.
//

import UIKit
import MapKit

class MainSceneViewController: UIViewController {
    static let identifier: String = "MainSceneViewController"
    
    @IBOutlet weak var venuesTableView: UITableView!
    
    let getLocation = GetLocation()
    var viewModel: MainSceneViewModel {
        return DefaultMainSceneViewModel()
    }
    
    var venuesEvent: VenuesEvent?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showActivityIndicator()
        setup()
      
        
        fetchCachedIfNeeded()
    }
    
    private func fetchCachedIfNeeded() {
        if !NetworkConnectionManager.isConnectedToNetwork() {
            self.viewModel.requestCachedData()
        }else {
            getLocation.run {
                if let location = $0 {
                    print("location = \(location.coordinate.latitude) \(location.coordinate.longitude)")
                    self.viewModel.requestFetch(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                } else {
                    print("Get Location failed \(self.getLocation.didFailWithError)")
                }
            }
        }
    }
    
    private func bindViewModel(){
        _ = EventBus.onMainThread(self, name: "fetchVenues") { result in
            self.hideActivityIndicator()
            if let event = result!.object as? VenuesEvent {
                self.venuesEvent = event
                if event.venues.count != 0 {
                    self.reload()
                } else if let message = event.errorMessage {
                    self.showAlert(alertText: "Error", alertMessage: message)
                }
            }
        }
    }
    
    private func setup() {
        bindViewModel()
        registerNib()
    }
    
    private func registerNib() {
        venuesTableView.register(UINib(nibName: "VenueCell", bundle: nil), forCellReuseIdentifier: VenueCell.reuseIdentifier)
    }
    
    private func reload() {
        venuesTableView.delegate = self
        venuesTableView.dataSource = self
        venuesTableView.reloadData()
    }
}

extension MainSceneViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VenueCell.reuseIdentifier, for: indexPath)
        as! VenueCell
        
        let currentElement = venuesEvent?.venues[indexPath.row]
        guard let safeElement = currentElement else {
            fatalError("venue is nil and cant draw it in tableview")
        }
        cell.configure(model: safeElement)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venuesEvent?.venues.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}

extension MainSceneViewController: UITableViewDelegate {}
