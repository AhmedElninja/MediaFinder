//
//  MediaVC.swift
//  Media Finder2
//
//  Created by Ahmed Alaa on 25/05/2023.
//

import AVKit
import UIKit
import SDWebImage

class MediaVC: UIViewController {
    
    //Mark: - Outlets.
    @IBOutlet weak var mediaTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentController: UISegmentedControl!
    
    
    //Mark: - Propreties.
    var trackInfo: [TrackInfo] = []
    private var loogedInUser: String? {
        return UserDefaults.standard.string(forKey: UserDefultKeys.emailToken)
    }
    
    //Mark: - LifeCycleMethod.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let def = UserDefaults.standard
        def.setValue(true, forKey: UserDefultKeys.isUserloggedIn)
        
        self.navigationItem.title = "Media"
        setupSearchBar()
        setupTableView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(buttonTapped))
        
        loadData()
        
    }
    
    
    //Mark: - Actions.
    @IBAction func segmentControlValueChanged(_ sender: UISegmentedControl) {
        
        performSearch()
    }
    
    
    @objc func buttonTapped() {
        goToProfileVC()
    }
    // Mark: - Private Methods
    private func setupTableView() {
        mediaTableView.dataSource = self
        mediaTableView.delegate = self
        mediaTableView.register(UINib(nibName: "MediaTableViewCell", bundle: nil), forCellReuseIdentifier: "MediaTableViewCell")
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        
    }
    
    
    private func performSearch() {
        guard let term = searchBar.text, !term.isEmpty else {
            return
        }
        var contentType = "all"
        switch segmentController.selectedSegmentIndex {
        case 0:
            contentType = "tvShow"
        case 1:
            contentType = "music"
        case 2:
            contentType = "movie"
        default:
            break
        }
        APIManager.searchTrack(contentType: contentType, term: term) { [weak self] trackInfo, error in
            guard let self = self else { return }
            if let error = error {
                print("API Error:", error)
                return
            }
            if let trackInfo = trackInfo {
                self.trackInfo = trackInfo
                
                saveData()
                
                DispatchQueue.main.async {
                    self.mediaTableView.reloadData()
                }
                
                print("Received Track Info:")
                for track in trackInfo {
                    print("Artwork URL:", track.artworkUrl100)
                    print("Artist Name:", track.artistName)
                    print("Long Description:", track.longDescription)
                    print("---------------------")
                }
            }
        }
    }
    
    private func goToProfileVC() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: Storyboards.main, bundle: nil)
        let profileVC: ProfileVC = mainStoryboard.instantiateViewController(withIdentifier: Views.profileVC) as! ProfileVC
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    private func saveData() {
        let encoder = JSONEncoder()
        do {
            let segmentData = try encoder.encode(trackInfo)
            let segmentIndex = segmentController.selectedSegmentIndex
            
            if let userEmail = loogedInUser {
                print("User email exists:", userEmail)
                DataBaseManger.shared.saveSegmentData(segmentIndex: segmentIndex, data: segmentData, forUserEmail: userEmail)
                print("Data saved successfully.")
            } else {
                print("User email does not exist.")
            }
        } catch {
            print("Error encoding trackInfo:", error)
        }
    }
    
    private func loadData() {
        if let userEmail = loogedInUser {
            print("User email exists:", userEmail)
        
          if let segmentData = DataBaseManger.shared.loadSegmentData(forUserEmail: userEmail) {
            let segmentIndex = segmentData.segmentIndex
            let decoder = JSONDecoder()
            do {
                let trackInfo = try decoder.decode([TrackInfo].self, from: segmentData.data)
                self.trackInfo = trackInfo
                mediaTableView.reloadData()
                print("Data loaded successfully.")
            } catch {
                print("Error decoding trackInfo:", error)
            }
            segmentController.selectedSegmentIndex = segmentIndex
        } else {
            let defaultSegmentIndex = 0
            segmentController.selectedSegmentIndex = defaultSegmentIndex
            
            if let userEmail = loogedInUser {
                DataBaseManger.shared.saveSegmentData(segmentIndex: defaultSegmentIndex, data: Data(), forUserEmail: userEmail)
            }
        }
        
        if trackInfo.isEmpty {
            performSearch()
        } else {
            mediaTableView.reloadData()
        }
        } else {
                print("User email does not exist.")
            }
    }
    
    @objc func artworkImageTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedImageView = sender.view as? UIImageView else {
            return
        }
        
        tappedImageView.bounceAnimation()
    }
}
        
    


// Mark : - UITableViewDataSource.
extension MediaVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mediaTableView.dequeueReusableCell(withIdentifier: "MediaTableViewCell", for: indexPath) as? MediaTableViewCell else {
            return UITableViewCell()
        }
        let item = trackInfo[indexPath.row]
        cell.artWorkImage.image = nil
        if let artworkURL = URL(string: item.artworkUrl100) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: artworkURL) {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.artWorkImage.image = image
                    }
                }
            }
        }
        if segmentController.selectedSegmentIndex == 1 {
            cell.artStreamLabel.text = item.artistName
            cell.longDescriptionLabel.text = item.trackName
        } else {
            cell.artStreamLabel.text = item.artistName
            cell.longDescriptionLabel.text = item.longDescription
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(artworkImageTapped(_:)))
                cell.artWorkImage.addGestureRecognizer(tapGesture)
        
        return cell
    }
}

//Mark: - UITableViewDelegate.
extension MediaVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = trackInfo[indexPath.row]
        
        if let previewURL = URL(string: item.previewUrl ?? "") {
            let player = AVPlayer(url: previewURL)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            present(playerViewController, animated: true) {
                playerViewController.player?.play()
            }
        }
    }
}
    
//Mark: - UISearchBarDelegate
extension MediaVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        performSearch()
    }
}
//Mark: - BounceAnimation
extension UIImageView {
    func bounceAnimation() {
        self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.transform = .identity
        }, completion: nil)
    }
}


