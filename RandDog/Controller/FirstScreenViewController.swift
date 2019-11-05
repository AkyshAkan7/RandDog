//
//  FirstScreenViewController.swift
//  RandDog
//
//  Created by Akan Akysh on 8/26/19.
//  Copyright © 2019 Akysh Akan. All rights reserved.
//

import UIKit
import MBProgressHUD

class FirstScreenViewController: UIViewController {
    
    let stackView = UIStackView()
    let pickerView = UIPickerView()
    let imageView = UIImageView()
    
    var breeds: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupStackView()
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        DogAPI.requestBreedsList(completionHandler: handleBreedsListResponse(breeds:error:))
    }
    
    //MARK: View setup functions
    
    func setupStackView() {
        view.addSubview(stackView)
        setStackViewConstraints()
        setupStackViewComponents()
    }
    
    func setStackViewConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        
    }
    
    func setupStackViewComponents() {
        stackView.addArrangedSubview(pickerView)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
    }
    
    
    //MARK: Completion handlers
    
    func handleBreedsListResponse(breeds: [String], error: Error?) {
        self.breeds = breeds
        self.pickerView.reloadAllComponents()
    }
    
    func handleRandomImageResponse(imageData: DogImage?, error: Error?) {
        
        guard let imageURL = URL(string: imageData?.message ?? "") else { return }
        
        DogAPI.requestImageFile(url: imageURL, completionHandler: self.handleImageFileResponse(image:error:))
    }
    
    func handleImageFileResponse(image: UIImage?, error: Error?) {
        DispatchQueue.main.async {
            self.imageView.image = image
            self.hideLoadingHUD()
        }
    }
    
    // MARK: Activity controller(MBProgressHUD) helper functions
    
    func showLoadingHUD() {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.label.text = "Loading..."
    }
    
    func hideLoadingHUD() {
        MBProgressHUD.hide(for: view, animated: true)
    }

}



extension FirstScreenViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return breeds.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return breeds[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        showLoadingHUD()
        DogAPI.requestRandomImage(breed: breeds[row], completionHandler: handleRandomImageResponse(imageData:error:))
    }
    
}
