//
//  ViewController.swift
//  MVVMBindings
//
//  Created by Sanghun Park on 20.09.22.
//

import UIKit

// Observable

class Observable<T> {
    var value: T? {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T?) {
        self.value = value
    }
    
    private var listener: ((T?) -> Void)?
    
    func bind(_ listener: @escaping (T?) -> Void) {
        listener(value)
        self.listener = listener
    }
}

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

