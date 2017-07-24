//
//  ViewController.swift
//  PokemonTouch
//
//  Created by Kevin Remigio on 10/31/16.
//  Copyright © 2016 Kevin Remigio. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

class ViewController: UIViewController, UIScrollViewDelegate {
//
    var a:UIImageView = UIImageView()
    var pokemonFileNamesURL:[URL] = [URL]()
    var pokemonImageString:String = String()
    
    var switched:Bool = false
    
    var numPokemonsOnScreen:Int = 0
    var countLabel:UILabel? = nil
    
    var scrollView: UIScrollView!
    
    var verticalScrollView:UIScrollView!
    var pokemonView:UIView? = nil
    var pokemonVerticalView:UIView? = nil
    
    let randomSlur:[String] = ["Yo", "Dude", "", "","", "Wiggity Wiggity Wack", "Son!", "Wiggity Wiggity Wiggity Wiggity Wiggity Wiggity Wiggity Wiggity What"]
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return pokemonView
    }
    
//    func setZoomScale() {
//        let imageViewSize = pokemonView!.bounds.size
//        let scrollViewSize = scrollView.bounds.size
//        let widthScale = scrollViewSize.width / imageViewSize.width
//        let heightScale = scrollViewSize.height / imageViewSize.height
//        
//        scrollView.minimumZoomScale = min(widthScale, heightScale)
//        scrollView.zoomScale = 1.0
//    }
    
//    override func viewWillLayoutSubviews() {
//        setZoomScale()
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemonView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        pokemonView?.backgroundColor = UIColor.clear
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        scrollView.backgroundColor = UIColor.clear
        scrollView.contentSize = CGSize(width: 1000, height: 2500)
        scrollView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
        
        pokemonVerticalView = UIView(frame: CGRect(x: 0, y: view.frame.maxY-90, width: view.frame.width, height: 90))
        pokemonVerticalView!.backgroundColor = UIColor.clear
        
        verticalScrollView = UIScrollView(frame: CGRect(x: 0, y: view.frame.maxY-90, width: view.frame.width, height: 90))
        verticalScrollView.backgroundColor = UIColor.blue
        verticalScrollView.contentSize = CGSize(width: view.frame.width + 1000, height: 90)
        verticalScrollView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        verticalScrollView.contentOffset = CGPoint(x: view.frame.width, y: view.frame.height)
        
        pokemonView!.tag = 25
        scrollView.addSubview(pokemonView!)
        view.addSubview(scrollView)

//        verticalScrollView.addSubview(pokemonVerticalView!)
//        view.addSubview(verticalScrollView)
        
        countLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 90))
        countLabel!.center = view.center
        countLabel?.font = UIFont(name: "Helvetica", size: 60.0)
        countLabel?.text = "\(numPokemonsOnScreen)"
        countLabel?.textColor = UIColor.black
        countLabel?.textAlignment = .center
        countLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        let centerX = NSLayoutConstraint(item: countLabel!, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0.0)
        let centerY = NSLayoutConstraint(item: countLabel!, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: 0.0)
        
        view.addSubview(countLabel!)
        
        view.addConstraints([centerX, centerY])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.addPokemonAndSayName(_:)))
        scrollView!.addGestureRecognizer(tap)
//        verticalScrollView!.addGestureRecognizer(tap)
        
        let threeTap = UITapGestureRecognizer(target: self, action: #selector(ViewController.clearTap(_:)))
        threeTap.numberOfTouchesRequired = 3
        view.addGestureRecognizer(threeTap)
        
        let fiveTap = UITapGestureRecognizer(target: self, action: #selector(ViewController.switchGens(_:)))
        fiveTap.numberOfTouchesRequired = 2
        view.addGestureRecognizer(fiveTap)
        
        // Get the document directory url
        let documentsUrl = Bundle.main.bundleURL
        
        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory( at: documentsUrl, includingPropertiesForKeys: nil, options: [])
            
            // if you want to filter the directory contents you can do like this:
            pokemonFileNamesURL = directoryContents.filter{ $0.pathExtension == "ico" }
            print("pokemon:\n",pokemonFileNamesURL)
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }

        scrollView.delegate = self
        
//        setZoomScale()
//        scrollView.minimumZoomScale = 1.0
//        scrollView.maximumZoomScale = 4.0
//        scrollView.zoomScale = 1.0
//        
    }
    func getRandomIndexAndSize() -> (index:Int, size:Int) {
        let size = [4,5,6]
        let random:Int = Int(arc4random()) % pokemonFileNamesURL.count
        let randomSize = random % size.count
        let imageSize = 10 * size[randomSize]
        
        return (random, imageSize)
    }
    func addPokemonAndSayName(_ sender: UITapGestureRecognizer) {
        
        let point:CGPoint = sender.location(in: sender.view)
        print(point)
        var random = getRandomIndexAndSize()
        
        if switched {
            random.index = random.index % 151
        }

        a = UIImageView(frame: CGRect(origin: point, size: CGSize(width: random.size, height: random.size)))
        a.contentMode = .scaleAspectFit
        a.center = point
        
        //convert url to string then parse to be prettier
        pokemonImageString = pokemonFileNamesURL[random.index].absoluteString
        pokemonImageString = pokemonImageString.replacingOccurrences(of: "file://", with: "")
        pokemonImageString = pokemonImageString.replacingOccurrences(of: "%20", with: " ")
        
        //add image then add to view
        a.image = UIImage(contentsOfFile: pokemonImageString)
        pokemonView!.addSubview(a)
        print(pokemonImageString)
//        a.image = UIImage(named: "\(pokemonImageString)")
//        a.tag = 1
        
//        if sender.view!.tag == 25 {
//            pokemonView!.addSubview(a)
//        } else {
//            pokemonVerticalView!.addSubview(a)
//        }
//        
        
        //trim to last path and remove numbers
        let audibleName = pokemonFileNamesURL[random.index].deletingPathExtension().lastPathComponent.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789."))

        let synthesizer = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: "\(audibleName)")
        utterance.rate = 0.5
        utterance.pitchMultiplier = 0.8
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
        
        numPokemonsOnScreen += 1
        countLabel?.text = "\(numPokemonsOnScreen)"
        
    }
    func switchGens(_ sender: UITapGestureRecognizer) {

        let phrase:String
        if switched == true {
            switched = false
            phrase = "current"
        } else {
            switched = true
            phrase = "first"
        }
        let synthesizer = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: "Switched to \(phrase) generation ,\(randomSlur[Int(arc4random()) % randomSlur.count])")
        utterance.rate = 0.4
        utterance.pitchMultiplier = 0.1
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.pauseSpeaking(at: .word)
        synthesizer.speak(utterance)
        
    }
    
    func clearTap(_ sender: UITapGestureRecognizer) {
        let synthesizer = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: "Clear Clear")
        utterance.rate = 0.4
        utterance.pitchMultiplier = 0.1
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.pauseSpeaking(at: .word)
        
        synthesizer.speak(utterance)
        for each in pokemonView!.subviews {
            each.removeFromSuperview()
        }
        
//        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        AudioServicesPlayAlertSoundWithCompletion(kSystemSoundID_Vibrate, nil)
//        AudioServicesPlaySystemSound(1521)
        
        numPokemonsOnScreen = 0
        countLabel?.text = "\(numPokemonsOnScreen)"
    }

}

