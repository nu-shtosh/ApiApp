//
//  MainViewController.swift
//  ApiApp
//
//  Created by Илья Дубенский on 05.11.2022.
//

import UIKit

enum Link: String {
    case randomCocktailURL = "https://www.thecocktaildb.com/api/json/v1/1/random.php"
}

enum UserAction: String, CaseIterable {
    case randomCocktail = "Get Random Cocktail"
}

enum Alert {
    case success
    case failed

    var title: String {
        switch self {
        case .success:
            return "Success"
        case .failed:
            return "Failed"
        }
    }

    var message: String {
        switch self {
        case .success:
            return "You can see the results in the Debug area"
        case .failed:
            return "You can see error in the Debug area"
        }
    }
}

class MainViewController: UICollectionViewController {

    private let userActions = UserAction.allCases

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        userActions.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "userAction",
            for: indexPath
        )
        guard let cell = cell as? UserActionCell else { return UICollectionViewCell() }
        cell.userActionLabel.text = userActions[indexPath.item].rawValue
        return cell
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userAction = userActions[indexPath.item]
        switch userAction {
        case .randomCocktail: fetchRandomCocktail()
        }
    }

    private func showAlert(withStatus status: Alert) {
        let alert = UIAlertController(title: status.title, message: status.message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        DispatchQueue.main.async { [unowned self] in
            present(alert, animated: true)
        }
    }

    private func fetchRandomCocktail() {
        guard let url = URL(string: Link.randomCocktailURL.rawValue) else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description!")
                return
            }
            let decoder = JSONDecoder()
            do {
                let randomCocktail = try decoder.decode(randomCocktail.self, from: data)
                self?.showAlert(withStatus: .success)
                print(randomCocktail)
            } catch let error {
                self?.showAlert(withStatus: .failed)
                print(error.localizedDescription)
            }
        }.resume()
    }
}

