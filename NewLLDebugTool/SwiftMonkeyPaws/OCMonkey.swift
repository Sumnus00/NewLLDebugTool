//
//  OCMonkey.swift
//  Demo6
//
//  Created by haleli on 2019/3/20.
//  Copyright © 2019 haleli. All rights reserved.
//

import UIKit

var paws: MonkeyPaws?

class OCMonkey:NSObject{
    
    @objc func test() -> () {
        print("我是 swift的实例方法")
    }
    @objc class func testClass() ->(){
        print("我是 swift的类方法")
    }
    
    

    @objc func showMonkeyPawsINUITest ( window: UIWindow ) -> () {
        paws = MonkeyPaws(view: window)
    }

    @objc class func test() -> () {
        print("test")
    }
}
