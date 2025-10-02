//
//  ViewController.swift
//  Shortly
//
//  Created by Zain Ali on 2/27/22.
//

import UIKit
import IQKeyboardManager
import SwiftAutoLayout
import RxSwift
import RxCocoa

class MainViewController: UIViewController, UITextFieldDelegate
{
    var emptyListView: UIView!
    var listView: UIView!
    var collectionView: UICollectionView!
    var activityView: UIActivityIndicatorView!
    var txtField:UITextField!
    let disposeBag = DisposeBag()
    var urlsArray = [[String: Any]]()
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = appBackgroundColor
        
        let savedURLs = self.userDefaults.array(forKey: "SavedUrlList")
        if savedURLs != nil && savedURLs!.count > 0
        {
            self.urlsArray = savedURLs as! [[String: Any]]
        }
        viewLayout()
    }
    
    func viewLayout()
    {
        emptyListView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        emptyListView.backgroundColor = .clear
        emptyListView.constrain(to: self.view).leading().trailing().top().bottom()
        
        let logo = UIImageView(frame: .zero)
        logo.image = UIImage(named: "app-logo")
        logo.constrain(to: emptyListView).top(.equal, constant: statusBarHeight + 18.0, multiplier: 1, priority: .defaultHigh, activate: true).centerX()
        
        let mainImgView = UIImageView(frame: .zero)
        mainImgView.image = UIImage(named: "main-image")
        mainImgView.constrain(to: emptyListView).top(.equal, constant: 78.0, multiplier: 1, priority: .defaultHigh, activate: true)
        mainImgView.constrain(to: emptyListView).leading().trailing()
        
        let lblNote = UILabel(frame: .zero)
        lblNote.text = "Let’s get started!"
        lblNote.textAlignment = .center
        lblNote.font = UIFont(name: "Poppins-Bold", size: 20.0)
        lblNote.textColor = appTextColor
        lblNote.constrain(to: emptyListView).top(.equal, constant: 400, multiplier: 1, priority: .defaultHigh, activate: true)
        lblNote.constrain(to: emptyListView).leading().trailing()
        
        let lblNote1 = UILabel(frame: .zero)
        lblNote1.text = "Paste your first link into the field to shorten it"
        lblNote1.numberOfLines = 2
        lblNote1.textAlignment = .center
        lblNote1.font = UIFont(name: "Poppins-Medium", size: 17)
        lblNote1.textColor = appTextColor
        lblNote1.constrain(to: emptyListView).top(.equal, constant: 440, multiplier: 1, priority: .defaultHigh, activate: true)
        lblNote1.constrain(to: emptyListView).leading(constant: 80)
        lblNote1.constrain(to: emptyListView).trailing(constant: 80)
        
        let bottomView = UIImageView(frame: CGRect(x: 0, y: screenSize.height - 204, width: screenSize.width, height: 204))
        bottomView.backgroundColor = UIColor(red: 0.231, green: 0.188, blue: 0.329, alpha: 1)
        
        txtField = UITextField(frame: CGRect(x: (screenSize.width/2) - 139.5, y: bottomView.frame.origin.y + 46, width: 279, height: 49))
        txtField.backgroundColor = .white
        txtField.placeholder = "Shorten a link here..."
        txtField.textAlignment = .center
        txtField.font = UIFont(name: "Poppins-Regular", size: 17.0)
        txtField.textColor = appTextColor
        txtField.layer.cornerRadius = 4.0
        txtField.delegate = self
        txtField.autocapitalizationType = .none
        
        let submitBtn = UIButton(frame: CGRect(x: (screenSize.width/2) - 139.5, y: bottomView.frame.origin.y + 105, width: 279, height: 49))
        submitBtn.backgroundColor = buttonColor
        submitBtn.setTitle("SHORTEN IT!", for: .normal)
        submitBtn.titleLabel?.font = UIFont(name: "Poppins-Bold", size: 20.0)
        submitBtn.layer.cornerRadius = 4.0
        submitBtn.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
        
        emptyListView.addSubview(logo)
        emptyListView.addSubview(mainImgView)
        emptyListView.addSubview(lblNote)
        emptyListView.addSubview(lblNote1)
        
        listView = UIView(frame: .zero)
        listView.backgroundColor = .clear
        listView.constrain(to: self.view).leading().trailing().top().bottom()
        
        let lblTitle = UILabel(frame: CGRect(x: 0, y: statusBarHeight + 20, width: screenSize.width, height: 20.0))
        lblTitle.text = "Your Link History"
        lblTitle.textAlignment = .center
        lblTitle.font = UIFont(name: "Poppins-Regular", size: 17.0)
        lblTitle.textColor = appTextColor
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: CGRect(x: 16, y: lblTitle.frame.origin.y + lblTitle.frame.height + 20, width: screenSize.width - 32, height: screenSize.height - bottomView.frame.height - statusBarHeight - 60.0),  collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ListCell.self, forCellWithReuseIdentifier: "ListCell")
        collectionView.backgroundColor = UIColor.clear
        collectionView.reloadData()
        collectionView.showsVerticalScrollIndicator = false
        
        listView.addSubview(lblTitle)
        listView.addSubview(collectionView)
        if urlsArray.count > 0
        {
            collectionView.reloadData()
            listView.isHidden = false
            emptyListView.isHidden = true
        }
        else
        {
            listView.isHidden = true
            emptyListView.isHidden = false
        }
        
        self.view.addSubview(emptyListView)
        self.view.addSubview(listView)
        self.view.addSubview(bottomView)
        self.view.addSubview(txtField)
        self.view.addSubview(submitBtn)
        
        activityView = UIActivityIndicatorView()
        activityView.center = self.view.center
        activityView.isHidden = true
        activityView.hidesWhenStopped = true
        if #available(iOS 13.0, *) {
            activityView.style = .large
        } else {
            // Fallback on earlier versions
        }
        self.view.addSubview(activityView)
    }
    
    @objc func submitAction()
    {
        if txtField.text == nil || txtField.text!.isEmpty
        {
            let errorColor = UIColor(red: 244.0/255.0, green: 98.0/255.0, blue: 98.0/255.0, alpha: 1)
            txtField.layer.borderColor = errorColor.cgColor
            txtField.layer.borderWidth = 1.0
            txtField.attributedPlaceholder = NSAttributedString(
                string: "Please add a link here",
                attributes: [NSAttributedString.Key.foregroundColor: errorColor]
            )
        }
        else
        {
            txtField.layer.borderWidth = 0
            txtField.attributedPlaceholder = NSAttributedString(
                string: "Please add a link here",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
            )
            txtField.resignFirstResponder()
            activityView.isHidden = false
            activityView.startAnimating()
            let client = APIClient.shared
            do
            {
                try client.getShortURL(url: txtField.text!).subscribe(
                onNext: { result in
                    DispatchQueue.main.async {
                        self.activityView.stopAnimating()
                        self.txtField.text = ""
                    }
                    let urlObj = result.getResult()
                    let dict:[String: Any] = ["Code" : urlObj.getCode(), "OriginalLink" : urlObj.getoriginalLink(), "ShortLink" : urlObj.getShortLink()]
                    
                    var savedURLs = self.userDefaults.array(forKey: "SavedUrlList")
                    if savedURLs != nil && savedURLs!.count > 0
                    {
                        savedURLs!.append(dict)
                        self.urlsArray = savedURLs as! [[String: Any]]
                    }
                    else
                    {
                        self.urlsArray.append(dict)
                        DispatchQueue.main.async
                        {
                            self.emptyListView.isHidden = true
                            self.listView.isHidden = false
                        }
                    }
                    self.userDefaults.set(self.urlsArray, forKey: "SavedUrlList")
                    
                    DispatchQueue.main.async
                    {
                        self.collectionView.reloadData()
                    }
                },
                onError: { error in
                    DispatchQueue.main.async {
                        self.activityView.stopAnimating()
                    }
                   print(error.localizedDescription)
                },
                onCompleted: {
                   print("Completed event.")
                }).disposed(by: disposeBag)
            }
            catch{
            }
        }
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 175.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urlsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCell", for: indexPath) as! ListCell
        
        let urlDict: [String: Any] = urlsArray[indexPath.row]
        
        cell.lblMainURL.text = urlDict["OriginalLink"] as? String
        cell.lblShortURL.text = urlDict["ShortLink"] as? String
        
        cell.delAction = {() in
            var savedURLs = self.userDefaults.array(forKey: "SavedUrlList")
            if savedURLs != nil && savedURLs!.count > 0
            {
                savedURLs!.remove(at: indexPath.row)
                self.urlsArray = savedURLs as! [[String: Any]]
                self.userDefaults.set(self.urlsArray, forKey: "SavedUrlList")
                if self.urlsArray.count == 0
                {
                    self.emptyListView.isHidden = false
                    self.listView.isHidden = true
                }
                collectionView.reloadData()
            }
        }
        
        cell.copyAction = {() in
            UIPasteboard.general.string = urlDict["ShortLink"] as? String
            cell.copyBtn.setTitle("COPIED!", for: .normal)
            cell.copyBtn.backgroundColor = UIColor(red: 0.231, green: 0.188, blue: 0.329, alpha: 1)
        }
        
        return cell
    }
}


class ListCell: UICollectionViewCell
{
    var lblMainURL: UILabel!
    var lblShortURL: UILabel!
    var copyBtn: UIButton!
    var delBtn: UIButton!
    
    var delAction:(() -> ())?
    var copyAction:(() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.layer.cornerRadius = 8.0
        self.contentView.layer.masksToBounds = true
        self.contentView.backgroundColor = UIColor.white
        
        lblMainURL = UILabel(frame: CGRect(x: 16, y: 12, width: self.contentView.frame.width - 38, height: 22))
        lblMainURL.font = UIFont(name: "Poppins-Regular", size: 17.0)
        lblMainURL.textColor = appTextColor
        
        delBtn = UIButton(frame: CGRect(x: self.contentView.frame.width - 28, y: 12, width: 14, height: 18))
        delBtn.setImage(UIImage(named: "del-icon"), for: .normal)
        delBtn.addTarget(self, action: #selector(delBtnAction), for: .touchUpInside)
        
        let lineView = UIView(frame: CGRect(x: 0, y: 46, width: self.contentView.frame.width, height: 1.0))
        lineView.backgroundColor = UIColor(red: 191.0/255.0, green: 191.0/255.0, blue: 191.0/255.0, alpha: 1.0)
        lineView.alpha = 0.5
        
        lblShortURL = UILabel(frame: CGRect(x: 16, y: 58, width: self.contentView.frame.width - 32, height: 20))
        lblShortURL.font = UIFont(name: "Poppins-Normal", size: 17.0)
        lblShortURL.textColor = buttonColor
        
        copyBtn = UIButton(frame: CGRect(x: 16 , y: 110, width: self.contentView.frame.width - 32, height: 39))
        copyBtn.backgroundColor = buttonColor
        copyBtn.setTitle("Copy!", for: .normal)
        copyBtn.titleLabel?.font = UIFont(name: "Poppins-Bold", size: 17.0)
        copyBtn.layer.cornerRadius = 4.0
        copyBtn.addTarget(self, action: #selector(copyBtnAction), for: .touchUpInside)
        
        self.contentView.addSubview(lblMainURL)
        self.contentView.addSubview(delBtn)
        self.contentView.addSubview(lineView)
        self.contentView.addSubview(lblShortURL)
        self.contentView.addSubview(copyBtn)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func delBtnAction()
    {
        delAction?()
    }
    
    @IBAction func copyBtnAction()
    {
        copyAction?()
    }
}
