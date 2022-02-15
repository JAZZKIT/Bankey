//
//  AppDelegate.swift
//  Bankey
//
//  Created by Denny on 28.01.2022.
//

import UIKit

let appColor: UIColor = .systemTeal

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let loginVC = LoginVC()
    let onboardingContainerVC = OnboardingContainerVC()
    let mainVC = MainVC()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground

        loginVC.delegate = self
        onboardingContainerVC.delegate = self

        registerForNotification()

        displayLogin()

        return true
    }
    private func displayLogin() {
        setRootVC(loginVC)
    }

    private func displayNextScreen() {
        if LocalState.hasOnboarded {
            prepMainView()
            setRootVC(mainVC)
        } else {
            setRootVC(onboardingContainerVC)
        }
    }

    private func registerForNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(didLogout), name: .Logout, object: nil)
    }

    private func prepMainView() {
        mainVC.setStatusBar()
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().backgroundColor = appColor
    }
}

// MARK: - LoginVCDelegate
extension AppDelegate: LoginVCDelegate {
    func didLogin() {
        displayNextScreen()
    }
}

// MARK: - OnboardingContainerVCDelegate
extension AppDelegate: OnboardingContainerVCDelegate {
    func didFinishOnboarding() {
        LocalState.hasOnboarded = true
        prepMainView()
        setRootVC(mainVC)
    }
}

// MARK: - LogoutDelegate
extension AppDelegate: LogoutDelegate {
    @objc func didLogout() {
        setRootVC(loginVC)
    }
}

extension AppDelegate {
    func setRootVC(_ vc: UIViewController, animated: Bool = true) {
        guard animated, let window = self.window else {
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
            return
        }

        window.rootViewController = vc
        window.makeKeyAndVisible()
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }
}
