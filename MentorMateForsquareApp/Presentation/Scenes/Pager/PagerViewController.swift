//
//  PagerViewController.swift
//  MentorMateForsquareApp
//
//  Created by Tornike Gomareli on 17.11.21.
//

import Foundation
import UIKit

class PagerViewController: SwipeController {
    static let identifier: String = "PagerViewController"
    @IBOutlet weak var segmentedControl: CustomSegmentedControl!
    
    override func setupView() {
        datasource = self
    }
    
    override func viewDidLoad() {
        setupSegmentedControl()
    }
    
    
    
    private func setupSegmentedControl() {
        segmentedControl.items = ["Venues", "About us"]
        segmentedControl.borderColor = .clear
        segmentedControl.selectedLabelColor = .white
        segmentedControl.unselectedLabelColor = .red
        segmentedControl.backgroundColor = .lightGray
        segmentedControl.thumbColor = .black
        segmentedControl.selectedIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentValueChanged(_:)), for: .valueChanged)
        segmentedControl.frame = self.view.frame
        self.view.addSubview(segmentedControl)
    }
}

extension PagerViewController: SwipeControllerDataSource {
    func viewControllerData() -> [UIViewController] {
        let mainScene = UIStoryboard.init(name: "MainScene", bundle: nil).instantiateViewController(withIdentifier: MainSceneViewController.identifier)
        
        let aboutUs = UIStoryboard.init(name: "AboutUs", bundle: nil).instantiateViewController(withIdentifier: AboutUsViewController.identifier)
        
        return [mainScene, aboutUs]
    }
    
    @objc func segmentValueChanged(_ sender: CustomSegmentedControl) {
        moveToPage(sender.selectedIndex, animated: true)
    }
}
