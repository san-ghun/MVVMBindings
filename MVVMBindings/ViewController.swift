//
//  ViewController.swift
//  MVVMBindings
//
//  Created by Sanghun Park on 20.09.22.
//

import UIKit

// Obserable

// Model

// ViewModels

// Controller

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func fetch() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }
    }

}

