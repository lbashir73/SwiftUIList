//
//  CoreDataMVVMTests.swift
//  CoreDataMVVMTests
//
//  Created by Lisa on 7/30/21.
//

import XCTest
@testable import CoreDataMVVM

class CoreDataMVVMTests: XCTestCase {
    
    var itemListVM: ItemListViewModel!

    override func setUpWithError() throws {
        itemListVM = ItemListViewModel()
    }

    override func tearDownWithError() throws {
        itemListVM = nil
    }

    func testExample() throws {
        itemListVM.getAllItems()
        let len = itemListVM.items.count + 1
        itemListVM.name = "Test item"
        itemListVM.save()
        itemListVM.getAllItems()
        XCTAssertEqual( itemListVM.items.count, len )
    }

}
