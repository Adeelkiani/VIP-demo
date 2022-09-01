//
//  HomeViewController.swift
//  itunes-vip
//
//  Created by Adeel kiani on 31/08/2022.
//

import UIKit

protocol HomeViewDelegate {
    func setMediaTypes(mediaTypes: [String])
    func setSelectedMediaTypes(mediaTypes: [String])
    func setEmptyMediaView()
}

class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    
    let cellName = "SelectedMedia"
    
    var coordinator: HomeCoordinatorDelegate!
    var interactor: HomeInteractorDelegate?
    
    var mediaTypes: [String] = []
    var selectedMediaTypes: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        interactor?.loadMediaTypes()
        
    }
    
    private func setupView() {
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: cellName, bundle: nil), forCellWithReuseIdentifier: cellName)
    }
    
    private func validateField() -> Bool {
        if searchField.hasText {
           return true
        }
        return false
    }

    @IBAction func onAddMediaTypeTapped(_ sender: UITapGestureRecognizer) {
        
        self.coordinator.navigateToSelectMediaTypes(mediaTypes: mediaTypes, selectedMediaTypes: selectedMediaTypes) { [weak self] mediaTypes in
            
            self?.interactor?.setSelectedMediaTypes(mediaTypes: mediaTypes)
        }
    }
    
    @IBAction func onSubmitTapped(_ sender: Any) {
        if validateField() {
            
        } else {
            self.showAlert(message: "Search field cannot be empty")
        }
    }
}
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.collectionView.frame.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return selectedMediaTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath) as? SelectedMedia {
            
            cell.data = selectedMediaTypes[indexPath.row]
            
            return cell
            
        }
        return UICollectionViewCell()
    }
}
extension HomeViewController: HomeViewDelegate {
   
    func setMediaTypes(mediaTypes: [String]) {
        self.mediaTypes = mediaTypes
    }
    
    func setSelectedMediaTypes(mediaTypes: [String]) {
        self.selectedMediaTypes = mediaTypes
        if mediaTypes.isEmpty {
            collectionView.backgroundColor = .white
            messageLabel.isHidden = true
        }
        self.collectionView.reloadData()
    }
    
    func setEmptyMediaView() {
        collectionView.backgroundColor = UIColor(named: Colors.EmptyCollectionView.rawValue)
        messageLabel.isHidden = false
    }
}
