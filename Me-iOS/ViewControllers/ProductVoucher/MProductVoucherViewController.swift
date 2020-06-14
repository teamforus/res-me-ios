//
//  MProductVoucherViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit
import MapKit
import SafariServices
import MessageUI

class MProductVoucherViewController: UIViewController {
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var organizationNameLabel: UILabel!
    @IBOutlet weak var qrCodeImage: UIImageView!
    @IBOutlet weak var organizationProductName: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var organizationIcon: CornerImageView!
    
    @IBOutlet var labeles: [SkeletonView]!
    @IBOutlet var images: [SkeletonUIImageView]!
    var address: String!
    var latitude: Double!
    var longitude: Double!
    var voucher: Voucher!
    lazy var productViewModel: ProductVoucherViewModel = {
        return ProductVoucherViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startLoading()
        setupView()
        fetchVoucher()
    }
    
    func startLoading() {
        labeles.forEach { (view) in
            view.startAnimating()
        }
        
        images.forEach { (view) in
            view.startAnimating()
        }
    }
    
    func setupView() {
        productViewModel.complete = { [weak self] (voucher) in
            
            DispatchQueue.main.async {
                
                
                self?.productNameLabel.text = voucher.product?.name ?? ""
                self?.organizationNameLabel.text = voucher.fund?.organization?.name ?? ""
                self?.organizationProductName.text = voucher.product?.organization?.name ?? ""
                self?.addressLabel.text = voucher.offices?.first?.address ?? ""
                self?.phoneNumberLabel.text = voucher.offices?.first?.phone ?? ""
                self?.emailButton.setTitle(voucher.offices?.first?.organization?.email, for: .normal)
                self?.organizationIcon.loadImageUsingUrlString(urlString: voucher.product?.organization?.logo?.sizes?.thumbnail ?? "", placeHolder: #imageLiteral(resourceName: "Resting"))
                self?.qrCodeImage.generateQRCode(from: "{\"type\": \"voucher\",\"value\": \"\(voucher.address ?? "")\" }")
                self?.voucher = voucher
                
                //organizationLabel gesture
                self?.emailButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self?.Tap)))
                self?.emailButton.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self?.Long)))
                
                
                if let latitudeValue = voucher.offices?.first?.lat, let lat = Double(latitudeValue) {
                    self?.latitude = lat
                }
                
                if let longitudeValue = voucher.offices?.first?.lon, let lon = Double(longitudeValue) {
                    self?.longitude = lon
                }
                
                self?.mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self?.goToMap)))
                let viewRegion = MKCoordinateRegion( center: CLLocationCoordinate2D(latitude: self?.latitude ?? 0.0 , longitude: self?.longitude ?? 0.0), latitudinalMeters: 10000, longitudinalMeters: 10000)
                self?.mapView.setRegion(viewRegion, animated: false)
                self?.mapView.region = viewRegion
                
                voucher.offices?.forEach({ (office) in
                    
                    self?.mapView.addAnnotation((self?.setAnnotation(lattitude: self?.latitude ?? 0.0, longitude: self?.longitude ?? 0.0))!)
                })
                
                self?.labeles.forEach { (view) in
                    view.stopAnimating()
                }
                self?.images.forEach { (view) in
                    view.stopAnimating()
                }
            }
        }
    }
    
    func fetchVoucher() {
        if isReachable() {
            productViewModel.vc = self
            productViewModel.initFetchById(address: address)
            
        }else {
            
            showInternetUnable()
            
        }
    }
    
    @IBAction func opendQR(_ sender: UIButton) {
        let popOverVC = PullUpQRViewController(nib: R.nib.pullUpQRViewController)
        popOverVC.voucher = voucher
        popOverVC.qrType = .Voucher
        showPopUPWithAnimation(vc: popOverVC)
    }
    
    @IBAction func sendByEmail(_ sender: Any) {
        
        productViewModel.completeSendEmail = { [weak self] (statusCode) in
            
            DispatchQueue.main.async {
                
                self?.showPopUPWithAnimation(vc: SuccessSendingViewController(nib: R.nib.successSendingViewController))
                
            }
        }
        
        showSimpleAlertWithAction(title: Localize.eMailToMe(),
                                  message: Localize.sendAnEMailToTheProvider(),
                                  okAction: UIAlertAction(title: Localize.confirm(), style: .default, handler: { (action) in
                                    
                                    self.productViewModel.sendEmail(address: self.voucher.address ?? "")
                                    
                                  }),
                                  cancelAction: UIAlertAction(title: Localize.cancel(), style: .cancel, handler: nil))
    }
    
    @IBAction func info(_ sender: Any) {
        if voucher.fund?.url_webshop != nil {
            if let url = URL(string: "\(voucher.fund?.url_webshop ?? "")product/\(voucher.product?.id ?? 0)") {
                let safariVC = SFSafariViewController(url: url)
                self.present(safariVC, animated: true, completion: nil)
            }
        }else {
            if let url = URL(string: "https://kerstpakket.forus.io") {
                let safariVC = SFSafariViewController(url: url)
                self.present(safariVC, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func callPhone(_ sender: Any) {
        if let phone = voucher.offices?.first?.phone {
            guard let number = URL(string: "tel://" + (phone)) else { return }
            UIApplication.shared.open(number)
        }
    }
    
}

extension MProductVoucherViewController {
    
    @objc func Tap() {
        
        
        showSimpleAlertWithAction(title:  Localize.sendAnEMailToTheProvider(),
                                  message: Localize.confirmToGoToYourEmailAppToSendAMessageToTheProvider(),
                                  okAction: UIAlertAction(title: Localize.confirm(), style: .default, handler: { (action) in
                                    
                                    if MFMailComposeViewController.canSendMail() {
                                        let composeVC = MFMailComposeViewController()
                                        composeVC.mailComposeDelegate = self
                                        composeVC.setToRecipients([(self.voucher.offices?.first?.organization?.email)!])
                                        composeVC.setSubject(Localize.questionFromMeUser())
                                        composeVC.setMessageBody("", isHTML: false)
                                        self.present(composeVC, animated: true, completion: nil)
                                    }else{
                                        self.showSimpleAlert(title: Localize.warning(), message: Localize.mailServicesAreNotAvailable())
                                    }
                                    
                                  }),
                                  cancelAction: UIAlertAction(title: Localize.cancel(), style: .cancel, handler: nil))
        
    }
    
    @objc func Long() {
        UIPasteboard.general.string = self.voucher.offices?.first?.organization?.email
        self.showSimpleToast(message: Localize.copiedToClipboard())
    }
    
    @objc func goToMap(){
        let actionSheet = UIAlertController.init(title: Localize.address(), message: nil, preferredStyle: .actionSheet)
        
        //open apple maps
        actionSheet.addAction(UIAlertAction.init(title: "Open in Apple Maps", style: UIAlertAction.Style.default, handler: { (action) in
            
            self.openMapForPlace(lattitude: self.latitude ?? 0.0, longitude: self.longitude ?? 0.0)
        }))
        
        //open google maps
        actionSheet.addAction(UIAlertAction.init(title: "Open in Google Maps", style: UIAlertAction.Style.default, handler: { (action) in
            if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!))
            {
                UIApplication.shared.open(URL(string:
                    "comgooglemaps://?q=\(self.latitude ?? 0.0),\(self.longitude ?? 0.0)")!, options: [:], completionHandler: { (succes) in
                })
            } else if (UIApplication.shared.canOpenURL(URL(string:"https://maps.google.com")!))
            {
                UIApplication.shared.open(URL(string:
                    "https://maps.google.com/?q=\(self.latitude ?? 0.0),\(self.longitude ?? 0.0)")!, options: [:], completionHandler: { (succes) in
                })
            }
        }))
        
        //copy to clipboard
        actionSheet.addAction(UIAlertAction.init(title: Localize.copyAddress(), style: UIAlertAction.Style.default, handler: { (action) in
            UIPasteboard.general.string = self.voucher.offices?.first?.address
            self.showSimpleToast(message: Localize.copiedToClipboard())
        }))
        actionSheet.addAction(UIAlertAction.init(title: Localize.cancel(), style: UIAlertAction.Style.cancel, handler: { (action) in
        }))
        //Present the controller
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func setAnnotation(lattitude: Double, longitude: Double) -> CustomPointAnnotation{
        let annotation = CustomPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(lattitude, longitude)
        annotation.imageName = "carLocation"
        return annotation
    }
    
    func openMapForPlace(lattitude: Double, longitude: Double) {
        
        let latitude: CLLocationDegrees = lattitude
        let longitude: CLLocationDegrees = longitude
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Address Name"
        mapItem.openInMaps(launchOptions: options)
    }
    
}

extension MProductVoucherViewController: MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension MProductVoucherViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        let reuseId = "annotation"
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView?.canShowCallout = true
        }
        else {
            anView?.annotation = annotation
        }
        let cpa = annotation as! CustomPointAnnotation
        anView?.image = UIImage(named:cpa.imageName)
        
        return anView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circle = MKCircleRenderer(overlay: overlay)
        circle.strokeColor = #colorLiteral(red: 0.3073092699, green: 0.4766488671, blue: 0.9586974978, alpha: 1)
        circle.fillColor = #colorLiteral(red: 0.746714294, green: 0.8004079461, blue: 0.9871394038, alpha: 0.7)
        circle.lineWidth = 1
        return circle
    }
}


class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
}
