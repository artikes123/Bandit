//
//  CameraViewController.swift
//  Bandit - IOS Academy
//
//  Created by Artun Erol on 8.06.2021.
//

import ProgressHUD
import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    //Capture session
    var captureSession = AVCaptureSession()
    
    //capture Device
    var captureDevice : AVCaptureDevice?
    
    //Capture output
    var captureOutput = AVCaptureMovieFileOutput()
    
    //Kamera kayıt yaparken kayıtın gözükmesi preview
    private var capturePreviewLayer: AVCaptureVideoPreviewLayer?
    
    //Kayıt bittikten sonra kayıdın oynatılması için gerekli olan previewLayer
    private var previewLayer : AVPlayerLayer?
    
    private var capturedVideoURL: URL?
    
    public var capturedVideoImageThumbnail : CGImage?
    
    
    
    
    //View
    private let cameraView:UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .black
        return view
    }()
    
    private let recordButton = RecordButton()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        view.addSubview(cameraView)

        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.isHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        
        view.addSubview(recordButton)
        recordButton.addTarget(self, action: #selector(didTapRecordButton), for: .touchUpInside)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cameraView.frame = view.bounds
        let size : CGFloat = 80
        recordButton.frame = CGRect(x: (view.width - size)/2, y: view.height - view.safeAreaInsets.bottom - size - 5, width: size, height: size)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = true
        ProgressHUD.dismiss()
        captureSession.startRunning()
        if previewLayer != nil {
            previewLayer?.removeFromSuperlayer()
            previewLayer = nil
        }
    }
    
    //MARK: - OBJ Funcs
    @objc func didTapClose() {
        navigationItem.rightBarButtonItem = nil
        recordButton.isHidden = false
        
        if previewLayer != nil {
            previewLayer?.removeFromSuperlayer()
            previewLayer = nil
        }
        
        else {
            captureSession.stopRunning()
            tabBarController?.tabBar.isHidden = false
            tabBarController?.selectedIndex = 0
        }

     
    }
    
    @objc func didTapRecordButton() {
        
        if captureOutput.isRecording {
            recordButton.toggle(for: .notRecording)
            captureOutput.stopRecording()

        }
        else {
            
            guard var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
            
            }
            url.appendPathComponent("video.mov")
            
            try? FileManager.default.removeItem(at: url)
            recordButton.toggle(for: .recording)
            captureOutput.startRecording(to: url, recordingDelegate: self)
            
        }
    }
    
    @objc func videoDidFinish(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
        }
    }
    
    //MARK: -Camera Set up
    func setupCamera() {
        /// Önce inputlar session'a ekleniyor, sonra session'a outputlar ekleniyor. Session capturePreviewLayer'a ekleniyor
        
        // Add devices(Inputs)
        if let audioDevice = AVCaptureDevice.default(for: .audio) {
            let audioInput = try? AVCaptureDeviceInput(device: audioDevice)
            
            if let audioInput = audioInput {
                if captureSession.canAddInput(audioInput) {
                    captureSession.addInput(audioInput)
                }
            }
            
        }
        
        if let videoDevice = AVCaptureDevice.default(for: .video) {
            let videoInput = try? AVCaptureDeviceInput(device: videoDevice)
            
            if let videoInput = videoInput {
                if captureSession.canAddInput(videoInput) {
                    captureSession.addInput(videoInput)
                }
            }
        }
        
        //update session(output)
        captureSession.sessionPreset = .hd1920x1080
        if captureSession.canAddOutput(captureOutput) {
            captureSession.addOutput(captureOutput)
        }
        
        //configure capture layer preview
        capturePreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        capturePreviewLayer?.videoGravity = .resizeAspectFill
        capturePreviewLayer?.frame = view.bounds
        
        if let layer = capturePreviewLayer {
            cameraView.layer.addSublayer(layer)
        }
        
        //enable camera start(running session)
        captureSession.startRunning()
        
    }
}

extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    
    //Recording bittiği zaman ne olacağını belirliyoruz.
        
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
        guard error == nil else {
            let alert = UIAlertController(title: "Whoops", message: "Something went wrong while recording. Try Again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dİssmis", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }
        
        capturedVideoURL = outputFileURL
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(didTapNext))
        
        print(outputFileURL.absoluteString)

        
        
        let player = AVPlayer(url: outputFileURL)
        player.actionAtItemEnd = .none
        
        //Looping the preview Video
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidFinish), name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        
        
        //Preview layer'ı yaratıyoruz
        previewLayer = AVPlayerLayer(player: player)
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.frame = cameraView.bounds
        
        guard let previewLayer = previewLayer else {
            print("preview layer is nil amk")
            return
        }
    
        cameraView.layer.addSublayer(previewLayer)
        previewLayer.player?.play()
        
        recordButton.isHidden = true

    }

    @objc func didTapNext() {
        previewLayer?.player?.pause()
        guard let url = capturedVideoURL else {
            return
        }
        let vc = CaptionViewController(with: url)
        navigationController?.pushViewController(vc, animated: true)
        
        let asset = AVAsset(url: url)
        let generator = AVAssetImageGenerator(asset: asset)
        
        do {
            let cgImage = try generator.copyCGImage(at: .zero, actualTime: nil)
            let uiImage = UIImage(cgImage: cgImage)
            
            UIImage().saveImage(image: uiImage, to: "thumbnailImage")
            
        }
        catch {
            print("url asset of captured video has failed")
        }
            
    }
    
}
