//
//  ChooseLanguageController.swift
//  WeatherApplication
//
//  Created by Rachana  on 28/05/23.
//

import UIKit
import SwiftUI

class ChooseLanguageController: UIViewController {
    
    @IBOutlet weak var swiftuiButton: UIButton!
    @IBOutlet weak var uikitButton: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    func prepareUI() {
        for button in [swiftuiButton, uikitButton] {
            button?.layer.cornerRadius = 8
            button?.layer.masksToBounds = true
            button?.layer.borderColor = UIColor.white.cgColor
            button?.layer.borderWidth = 1
        }
        
    }
    
    @IBAction func swiftuiButtonAction(_ sender: UIButton) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let contentView = ContentView().environment(\.managedObjectContext, context)
        let weatherController = UIHostingController(rootView: contentView)
        navigationController?.pushViewController(weatherController, animated: true)
    }
    
    @IBAction func uikitButtonAction(_ sender: UIButton) {
        let weatherController = UIStoryboard.main.instantiate() as WeatherViewController
        navigationController?.pushViewController(weatherController, animated: true)
    }
    
}
