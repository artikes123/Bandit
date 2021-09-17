//
//  BanditCameraViewController.swift
//  Bandit - IOS Academy
//
//  Created by Artun Erol on 9.08.2021.
//

import UIKit
import AVFoundation

class BanditCameraViewController: UIViewController {
    
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
    
    private var mainPostURL: URL?
    
    public var capturedVideoImageThumbnail : CGImage?
    
    private let model : PostModel
    
    private let recordButton = RecordButton()
    
    private let cameraView:UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .black
        
        return view
    }()
    
    private let mainPostVideo: UIView = {
       let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .blue
        return view
    }()

//MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        
        view.addSubview(cameraView)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = true
        
        setUpMainVideo()
        setUpButtons()
        
        captureSession.startRunning()
        
        if previewLayer != nil {
            previewLayer?.removeFromSuperlayer()
            previewLayer = nil
        }
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    init(with model: PostModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cameraView.frame = view.bounds
        
        let size: CGFloat = 80
        recordButton.frame = CGRect(x: (view.width - size)/2, y: view.height - view.safeAreaInsets.bottom - size - 5, width: size, height: size)
        
    }
    
    //MARK: - SetUp Funcs
    
    func setUpButtons() {
        view.addSubview(recordButton)
        
        recordButton.addTarget(self, action: #selector(didTapRecord), for: .touchUpInside)
    }
    
    func setupCamera() {
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
        
        //Output
        captureSession.sessionPreset = .high
        
        if captureSession.canAddOutput(captureOutput) {
            captureSession.addOutput(captureOutput)
        }
        
        //Çektiğimiz video'nun preview'ı
        
        capturePreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        capturePreviewLayer?.videoGravity = .resizeAspectFill
        capturePreviewLayer?.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
        
        guard let capturePreviewLayer = capturePreviewLayer else { return }
        
        cameraView.layer.addSublayer(capturePreviewLayer)
        
    }
    
    private func setUpMainVideo() {
        
        //Setting player for main post Video
        let player = AVPlayer(url: model.postURL)
        player.actionAtItemEnd = .none
        player.volume = 0
        
        print("model.postURL \(model.postURL)")
        
        let mainPlayerLayer = AVPlayerLayer(player: player)
        mainPlayerLayer.videoGravity = .resizeAspectFill
        mainPlayerLayer.frame = CGRect(x: 40, y: 10, width: 200, height: 200)
        mainPlayerLayer.cornerRadius = 10
        mainPlayerLayer.backgroundColor = .init(red: 1, green: 1, blue: 1, alpha: 1)
        
        
    
        cameraView.layer.addSublayer(mainPlayerLayer)
        
    }
    //MARK: - Merge Videos
    
    private func mergeVideos(with currentURL: URL) {
        let firstAsset = AVAsset(url: model.postURL)
        let secondAsset = AVAsset(url: currentURL)
    }
    
    //MARK: - OBJC funcs
    
    @objc func didTapRecord() {
        if captureOutput.isRecording {
            recordButton.toggle(for: .notRecording)
            captureOutput.stopRecording()
        }
        else {
           
            guard var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            
            url.appendPathComponent("banditVideo.mov")

            try? FileManager.default.removeItem(at: url)
            recordButton.toggle(for: .recording)
            captureOutput.startRecording(to: url, recordingDelegate: self)
            
        }
    }
    
    @objc func videoDidFinish(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: .zero, completionHandler: nil)
        }
    }

}

extension BanditCameraViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
        capturedVideoURL = outputFileURL
        
    }

}

extension BanditCameraViewController {
    
}
