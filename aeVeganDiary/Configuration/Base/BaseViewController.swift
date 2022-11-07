//
//  BaseViewController.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/05/28.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .clear
            appearance.shadowColor = .mainGreen
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        
        view.backgroundColor = .mainGreen
        navigationController?.navigationBar.isTranslucent = false
        
        //navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //navigationController?.navigationBar.shadowImage = UIImage()
        //navigationController?.navigationBar.layoutIfNeeded()
    }
    
    
    // navigationBar title 설정하는 함수
    func setNavigationTitle(title: String) {
        let titleview = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        titleLabel.text = title
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleview.addSubview(titleLabel)
        self.navigationItem.titleView = titleview
    }
    
    // 한 단계 위에 있는 뷰로 pop 하는 함수, 뒤로가기 버튼에서 쓰임
    @objc func popToVC() {
        navigationController?.popViewController(animated: true)
    }
    
    // 홈화면 뒤로가기 버튼 설정
    func setDismissButton() {
        let backButton: UIButton = UIButton()
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        backButton.frame = CGRect(x: 18, y: 0, width: 44, height: 44)
        let addBackButton = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.setLeftBarButton(addBackButton, animated: false)
    }
    
    func setBackButton() {
        let backButton: UIButton = UIButton()
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.addTarget(self, action: #selector(popToVC), for: .touchUpInside)
        backButton.frame = CGRect(x: 18, y: 0, width: 44, height: 44)
        let addBackButton = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.setLeftBarButton(addBackButton, animated: false)
    }
    
    @objc func dismissVC() {
        self.dismiss(animated: true)
    }
    
    enum VersionError: Error {
        case invalidResponse, invalidBundleInfo
    }
    
    func isUpdateAvailable(completion: @escaping (Bool?, Error?) -> Void) throws -> URLSessionDataTask {
        guard let info = Bundle.main.infoDictionary,
            let currentVersion = info["CFBundleShortVersionString"] as? String,
            let identifier = info["CFBundleIdentifier"] as? String,
            let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(identifier)") else {
                throw VersionError.invalidBundleInfo
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let error = error { throw error }
                guard let data = data else { throw VersionError.invalidResponse }
                let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any]
                guard let result = (json?["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String else {
                    throw VersionError.invalidResponse
                }
                completion(version != currentVersion, nil)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
        return task
    }

    func presentUpdateAlertVC() {
        let alertVC = UIAlertController(title: "업데이트", message: "업데이트가 필요합니다.", preferredStyle: .alert)
        let alertAtion = UIAlertAction(title: "업데이트", style: .default) { _ in
            // ✅ App store connet 앱의 일반 정보의 Apple ID 입력.
            let appleID = "1643485964"
            // ✅ URL Scheme 방식을 이용해서 앱스토어를 연결.
            guard let url = URL(string: "itms-apps://itunes.apple.com/app/\(appleID)") else { return }
            // ✅ canOpenURL(_:) - 앱이 URL Scheme 처리할 수 있는지 여부를 나타내는 Boolean 값을 리턴한다.
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
        alertVC.addAction(alertAtion)

        DispatchQueue.main.sync {
            present(alertVC, animated: true)
        }
    }
    
}
