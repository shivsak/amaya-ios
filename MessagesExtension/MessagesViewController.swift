//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by Shiv Sakhuja on 6/14/17.
//  Copyright © 2017 Shiv Sakhuja. All rights reserved.
//

import UIKit
import Messages
import AVFoundation

enum AmayaError: Error {
    case invalidSender
}

extension UIColor {
    static var amayaCan: UIColor  { return UIColor(red: 0.4, green: 0.8, blue: 0.1, alpha: 1) }
    static var amayaBottle: UIColor  { return UIColor(red: 0.8, green: 0.2, blue: 0.4, alpha: 1) }
    static var amayaGlass: UIColor  { return UIColor(red: 0.33, green: 0.71, blue: 0.94, alpha: 1) }
    static var amayaBeer: UIColor  { return UIColor(red: 0.8, green: 1, blue: 0.1, alpha: 1) }
}

class MessagesViewController: MSMessagesAppViewController, AVAudioPlayerDelegate, UIGestureRecognizerDelegate {
    
    private var BUTTON_WIDTH:CGFloat = 50
    private var BUTTON_HEIGHT:CGFloat = 50
    private var HEADER_WIDTH:CGFloat = 250
    private var HEADER_HEIGHT:CGFloat = 30
    private var PROGRESS_BAR_HEIGHT:CGFloat = 30
    
    var updater : CADisplayLink! = nil
    var progressBar : UIProgressView! = nil
    var audioPlayer:AVAudioPlayer = AVAudioPlayer()
    
    var firstButton:UIButton = UIButton.init()
    var secondButton:UIButton = UIButton.init()
    var thirdButton:UIButton = UIButton.init()
    var fourthButton:UIButton = UIButton.init()
    var wildcardButton:UIButton = UIButton.init()
    var headerLabel:UILabel = UILabel.init()
    var subHeaderLabel:UILabel = UILabel.init()
    var footerLabel:UILabel = UILabel.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        do {
            let burp1Path:String? = Bundle.main.path(forResource: "burp1", ofType: "m4a")
            let burp1URL = NSURL(fileURLWithPath: burp1Path!) as URL
            try audioPlayer = AVAudioPlayer(contentsOf: burp1URL)
        }
        catch {
            alertUser(error: "Oops, an error occurred")
        }
        
        setupView()
    }
    
    func setupView() {
        //four buttons - yellow, yellow-orange, orange, red, white (wildcard)
        setupBackground()
        setupHeaderLabel()
        setupSubHeaderLabel()
        setupFooterLabel()
        setupfirstButton()
        setupsecondButton()
        setupthirdButton()
        setupfourthButton()
        setupWildcardButton()
        setupProgressBar()
    }
    
    func setupBackground() {
        view.backgroundColor = UIColor.black.withAlphaComponent(1)
    }
    
    func setupLongPressGestureRecognizer(givenView: UIView) {
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        gestureRecognizer.delegate = self
        givenView.addGestureRecognizer(gestureRecognizer)
    }
    
    func handleLongPress(gestureRecognizer: UIGestureRecognizer) {
        composeMessage(gestureRecognizer.view ?? view)
    }
    
    private func composeMessage(_ sender:AnyObject) {
        let conversation = activeConversation
        
        var url = urlForBurp(burp: 1)
        switch sender.tag! {
            case 1:
                url = urlForBurp(burp: 4)
            case 2:
                url = urlForBurp(burp: 2)
            case 3:
                url = urlForBurp(burp: 1)
            case 4:
                url = urlForBurp(burp: 3)
            case 99:
                let path:String? = generateRandomBurpPath()
                url = NSURL(fileURLWithPath: path!) as URL
            default:
                let path:String? = generateRandomBurpPath()
                url = NSURL(fileURLWithPath: path!) as URL
        }

        conversation?.insertAttachment(url, withAlternateFilename: nil, completionHandler: nil) ?? alertUser(error: "Oops! Couldn't insert your burp into the message. We'll be sure to fix this soon")
    }

    func setupHeaderLabel() {
        headerLabel = UILabel(frame: CGRect(
            x: 20,
            y: 20,
            width: HEADER_WIDTH,
            height: HEADER_HEIGHT
        ))
        headerLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 32)
        headerLabel.textColor = UIColor.white
        headerLabel.text = "Ya ya, I burp"
        view.addSubview(headerLabel)
    }
    
    func setupSubHeaderLabel() {
        subHeaderLabel = UILabel(frame: CGRect(
            x: 20,
            y: 20 + HEADER_HEIGHT + 5,
            width: HEADER_WIDTH,
            height: 30
        ))
        subHeaderLabel.font = UIFont(name: "HelveticaNeue", size: 14)
        subHeaderLabel.textColor = UIColor.white.withAlphaComponent(0.75)
        subHeaderLabel.text = "Tap to listen, hold to send as message"
        view.addSubview(subHeaderLabel)
    }
    
    func setupFooterLabel() {
        footerLabel = UILabel(frame: CGRect(
            x: 20,
            y: 2*HEADER_HEIGHT + 20 + BUTTON_HEIGHT + 50,
            width: HEADER_WIDTH,
            height: HEADER_HEIGHT
        ))
        footerLabel.font = UIFont(name: "HelveticaNeue-Light", size: 12)
        footerLabel.textColor = UIColor.white.withAlphaComponent(0.2)
        footerLabel.text = "Burps by Amaya. All rights reserved."
        view.addSubview(footerLabel)
    }
    
func setupfirstButton() {
    let button = UIButton(type: .custom)
    button.frame = CGRect(
        x:20,
        y:100,
        width:BUTTON_WIDTH,
        height:BUTTON_HEIGHT
    )
    button.backgroundColor = UIColor.init(colorLiteralRed: 1, green: 1, blue: 1, alpha: 0)
    button.layer.cornerRadius = button.frame.size.height/2
    let image = UIImage.init(named: "glass")
    button.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
    button.imageView?.tintColor = UIColor.amayaGlass
    button.alpha = 0.5
    button.tag = 1
    button.addTarget(self, action: #selector(play(_:)), for: .touchUpInside)
    setupLongPressGestureRecognizer(givenView: button)
    firstButton = button
    view.addSubview(firstButton)
}
    
    func setupsecondButton() {
        let button = UIButton(type: .custom)
        button.frame = CGRect(
            x:20 + BUTTON_WIDTH + 10,
            y:100,
            width:BUTTON_WIDTH,
            height:BUTTON_HEIGHT
        )
        button.backgroundColor = UIColor.init(colorLiteralRed: 1, green: 1, blue: 1, alpha: 0)
        button.layer.cornerRadius = button.frame.size.height/2
        let image = UIImage.init(named: "can")
        button.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = UIColor.amayaCan
        button.alpha = 0.5
        button.tag = 2
        button.addTarget(self, action: #selector(play(_:)), for: .touchUpInside)
        setupLongPressGestureRecognizer(givenView: button)
        secondButton = button
        view.addSubview(secondButton)
    }
    
    func setupthirdButton() {
        let button = UIButton(type: .custom)
        button.frame = CGRect(
            x:20 + 2*(BUTTON_WIDTH + 10),
            y:100,
            width:BUTTON_WIDTH,
            height:BUTTON_HEIGHT
        )
        button.backgroundColor = UIColor.init(colorLiteralRed: 1, green: 1, blue: 1, alpha: 0)
        button.layer.cornerRadius = button.frame.size.height/2
        let image = UIImage.init(named: "bottle")
        button.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = UIColor.amayaBottle
        button.alpha = 0.5
        button.tag = 3
        button.addTarget(self, action: #selector(play(_:)), for: .touchUpInside)
        setupLongPressGestureRecognizer(givenView: button)
        thirdButton = button
        view.addSubview(thirdButton)
    }
    
    func setupfourthButton() {
        let button = UIButton(type: .custom)
        button.frame = CGRect(
            x:20 + 3*(BUTTON_WIDTH + 10),
            y:100,
            width:BUTTON_WIDTH,
            height:BUTTON_HEIGHT
        )
        button.backgroundColor = UIColor.init(colorLiteralRed: 1, green: 1, blue: 1, alpha: 0)
        button.layer.cornerRadius = button.frame.size.height/2
        let image = UIImage.init(named: "beer")
        button.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = UIColor.amayaBeer
        button.alpha = 0.5
        button.tag = 4
        button.addTarget(self, action: #selector(play(_:)), for: .touchUpInside)
        setupLongPressGestureRecognizer(givenView: button)
        fourthButton = button
        view.addSubview(fourthButton)
    }
    
    func setupWildcardButton() {
        let button = UIButton(type: .custom)
        button.frame = CGRect(
            x: view.frame.size.width - CGFloat(BUTTON_WIDTH) - 20,
            y:100,
            width:BUTTON_WIDTH,
            height:BUTTON_HEIGHT
        )
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = button.frame.size.height/2
        button.setTitle("*", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        button.titleLabel?.font = UIFont(name:"HelveticaNeue-CondensedBold", size:36)
        button.titleLabel?.numberOfLines = 1;
        button.titleLabel?.adjustsFontSizeToFitWidth = true;
        button.titleLabel?.lineBreakMode = .byClipping
        button.tag = 99
        button.addTarget(self, action: #selector(play(_:)), for: .touchUpInside)
        wildcardButton = button
        view.addSubview(wildcardButton)
    }
    
    func setupProgressBar() {
        progressBar = UIProgressView(frame: CGRect(
            x: 0,
            y: 20+HEADER_HEIGHT+20+HEADER_HEIGHT+BUTTON_HEIGHT+50,
            width: view.frame.size.width,
            height: PROGRESS_BAR_HEIGHT
        ))
        progressBar.transform = progressBar.transform.scaledBy(x: 1, y: PROGRESS_BAR_HEIGHT)
        progressBar.progressTintColor = UIColor.white
        progressBar.trackTintColor = UIColor.clear
        view.addSubview(progressBar)
    }
    
    
    func play(_ sender:AnyObject) {
        do {
            switch sender.tag! {
                case 1:
                    try audioPlayer = AVAudioPlayer(contentsOf: urlForBurp(burp: 4))
                case 2:
                    try audioPlayer = AVAudioPlayer(contentsOf: urlForBurp(burp: 2))
                case 3:
                    try audioPlayer = AVAudioPlayer(contentsOf: urlForBurp(burp: 1))
                case 4:
                    try audioPlayer = AVAudioPlayer(contentsOf: urlForBurp(burp: 3))
                case 99:
                    let path:String? = generateRandomBurpPath()
                    let url = NSURL(fileURLWithPath: path!) as URL
                    try audioPlayer = AVAudioPlayer(contentsOf: url)
                default:
                    throw AmayaError.invalidSender
                
            }

            audioPlayer.prepareToPlay()
            updater = CADisplayLink(target: self, selector: Selector("trackAudio"))
            updater.frameInterval = 1
            updater.add(to:RunLoop.current, forMode: .commonModes)
            audioPlayer.delegate = self
            audioPlayer.play()
        }
        catch {
            alertUser(error: "Sorry, an error occurred but I'll fix this as soon as possible!")
        }
    }
    
    func urlForBurp(burp:Int) -> URL {
        let path = Bundle.main.path(forResource: "burp\(burp)", ofType: "m4a")
        return NSURL(fileURLWithPath: path!) as URL
    }
    
    func playAnimation() {
        
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        updater.invalidate()
        progressBar.progress = 0
        audioPlayer.currentTime = 0
        
    }
    
    func trackAudio() {
        // normalized from 0 to 1
        let normalizedTime = Float(audioPlayer.currentTime / audioPlayer.duration)
        progressBar.progress = normalizedTime
    }
    
    
    func generateRandomBurpPath() -> String? {
        let pathString = "burp\((arc4random() % 4) + 1)"
        return Bundle.main.path(forResource: pathString, ofType: "m4a")
    }
    
    func pause(_ sender:AnyObject) {
        audioPlayer.pause()
    }
    
    func replay(_ sender:AnyObject) {
        audioPlayer.currentTime = 0
    }
    
    func alertUser(error:String) {
        print("oops \(error)")

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        
        // Use this method to configure the extension and restore previously stored state.
    }
    
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
    }
   
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        
        // Use this method to trigger UI updates in response to the message.
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
    
        // Use this to clean up state related to the deleted message.
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
    
        // Use this method to prepare for the change in presentation style.
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
    
        // Use this method to finalize any behaviors associated with the change in presentation style.
    }

}
