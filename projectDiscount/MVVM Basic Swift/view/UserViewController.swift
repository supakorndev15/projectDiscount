//
//  UserViewController.swift
//  projectDiscount
//
//  Created by MacDetail on 17/7/2568 BE.
//

import UIKit

class UserViewController: UIViewController {
    
    public var viewModel: UserViewModel?
//    private var viewModel: UserViewModel?
    
    @IBOutlet weak var nameLabel: UILabel!
    //    private let nameLabel: UILabel = {
//        let label = UILabel()
//        label.textAlignment = .center
//        label.font = UIFont.systemFont(ofSize: 24)
//        return label
//    }()
    
    private let changeNameButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Change Name", for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            return button
        }()
    
    // ต้องมี init รับ ViewModel เข้ามา
    init(viewModel: UserViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    required init?(coder: NSCoder) {
            super.init(coder: coder)
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.backgroundColor = .white
        
        // ตั้งค่า Label
//        view.addSubview(nameLabel)
//        nameLabel.frame = view.bounds
        
        // แสดงข้อความจาก ViewModel
        nameLabel.text = viewModel?.displayName
        layoutUI()
    }
    
    private func layoutUI() {
        
        view.backgroundColor = .white
               
        nameLabel.text = viewModel?.displayName
        changeNameButton.addTarget(self, action: #selector(changeNameTapped), for: .touchUpInside)
               
               view.addSubview(nameLabel)
               view.addSubview(changeNameButton)
        //
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        changeNameButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            
            changeNameButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            changeNameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func changeNameTapped() {
        viewModel?.changeName(to: "Dale ❤️")
        nameLabel.text = viewModel?.displayName
    }
}
