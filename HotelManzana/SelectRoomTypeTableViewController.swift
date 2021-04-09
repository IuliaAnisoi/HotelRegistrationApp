//
//  SelectRoomTypeTableViewController.swift
//  HotelManzana
//
//  Created by Iulia Anisoi on 08.04.2021.
//

import UIKit

protocol SelectRoomTypeTableViewControllerDelegate: class {
    func selectRoomTypeTableViewController(_ controller :SelectRoomTypeTableViewController, didSelect roomType: RoomType)
}

class SelectRoomTypeTableViewController: UITableViewController {
    
    var roomType: RoomType?
    weak var delegate: SelectRoomTypeTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RoomType.all.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomTypeCell", for: indexPath)
        let room = RoomType.all[indexPath.row]
        
        if room == self.roomType {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        // Configure the cell...
        cell.textLabel?.text = room.name
        cell.detailTextLabel?.text = "$ \(room.price)"

        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let safeRoomType = RoomType.all[indexPath.row]
        
        roomType = safeRoomType
        tableView.reloadData()
        
        delegate?.selectRoomTypeTableViewController(self, didSelect: safeRoomType)
        
    }

}

