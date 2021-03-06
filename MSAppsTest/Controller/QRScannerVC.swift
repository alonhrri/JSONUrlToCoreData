//
//  QRScannerVC.swift
//  MSAppsTest
//
//  Created by Alon Harari on 14/03/2019.
//  Copyright © 2019 Alon Harari. All rights reserved.
//
//MARK: - Frameworks
import UIKit
import AVFoundation
import CoreData
//MARK: - Class
class QRScannerVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate{

//MARK: - IBOutlet

    @IBOutlet weak var square: UIImageView!
//MARK: - Properties of class

    var video = AVCaptureVideoPreviewLayer()
    let session = AVCaptureSession()
//MARK: - ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {return}
        do {
            
            let input = try AVCaptureDeviceInput(device: captureDevice)
            session.addInput(input)
        }
        catch{
            print("Error")
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)
        self.view.bringSubviewToFront(square)
        
        session.startRunning()
    }
    
    // MARK: - Private methods

    private func createMovieEntityFrom(dictionary: [String: AnyObject]) -> NSManagedObject? {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        if let movieEntity = NSEntityDescription.insertNewObject(forEntityName: "Movie", into: context) as? Movie {
            movieEntity.title = dictionary["title"] as? String
            movieEntity.image = dictionary["image"] as? String
            movieEntity.releaseYear = dictionary["releaseYear"] as? Int16 ?? 2019
            movieEntity.rating = dictionary["rating"] as! Double
            movieEntity.genre = dictionary["genre"] as? [String]
            return movieEntity
        }
        return nil
    }
    private func saveInCoreDataWith(array: [[String: AnyObject]]) {
        _ = array.map{self.createMovieEntityFrom(dictionary: $0)}
        do {
            try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()

        } catch let error {
            print(error)
        }
    }
    func showAlertWith(title: String, message: String, style: UIAlertController.Style = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: title, style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if  metadataObjects.count != 0
        {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject
            {
                if object.type == AVMetadataObject.ObjectType.qr
                {
                    let alert = UIAlertController(title: "QR Code", message: object.stringValue, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Retake", style: .default, handler: {(nil)  in
                        self.navigationController?.popViewController(animated: true)

                        
                    }))
                    alert.addAction(UIAlertAction(title: "Copy", style: .default, handler: {(nil) in
                        UIPasteboard.general.string = object.stringValue
                        if let qrUrl = object.stringValue {
                            
                            let service = APIService()
                            service.getDataWithQR(qrUrl: qrUrl) { (result) in
                                switch result {
                                case .Success(let data):
                                    DispatchQueue.main.async {
                                    self.saveInCoreDataWith(array: data)
                                    }
                                case .Error(let message):
                                    DispatchQueue.main.async {
                                        self.showAlertWith(title: "Error", message: message)
                                    }
                                }
                            }
                        }

                        self.navigationController?.popViewController(animated: true)

                    }))
                   present(alert, animated: true, completion: nil)
                    self.session.stopRunning()

                }
            }
        }
    }
}
