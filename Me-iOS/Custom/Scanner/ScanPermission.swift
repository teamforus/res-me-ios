//
//  ScanPermission.swift
//  HSScanCode
//
//  Created by Hanson on 2018/1/31.
//

import UIKit
import AssetsLibrary
import Photos

struct ScanPermission {
    
    static func authorizePhoto(comletion: @escaping (Bool) -> Void) {
        let grantedStatus = PHPhotoLibrary.authorizationStatus()
        switch grantedStatus {
        case .authorized:
            comletion(true)
        case .denied, .restricted:
            comletion(false)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) in
                DispatchQueue.main.async {
                    comletion(status == .authorized ? true : false)
                }
            })
        @unknown default:
            fatalError()
        }
    }
    
    static func authorizeCamera(comletion: @escaping (Bool) -> Void) {
        let grantedStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch grantedStatus {
        case .authorized:
            comletion(true)
        case .denied, .restricted:
            comletion(false)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (status) in
                DispatchQueue.main.async {
                    comletion(status)
                }
            })
        @unknown default:
            fatalError()
        }
    }
    
    static func goToSystemSetting() {
        if let appSetting = URL(string: UIApplication.openSettingsURLString) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(appSetting, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(appSetting)
            }
        }
    }
}
