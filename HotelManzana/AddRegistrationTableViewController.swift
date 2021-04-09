//
//  AddRegistrationTableViewController.swift
//  HotelManzana
//
//  Created by Iulia Anisoi on 07.04.2021.
//

import UIKit

class AddRegistrationTableViewController: UITableViewController, SelectRoomTypeTableViewControllerDelegate {
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet weak var checkInDateLabel: UILabel!
    @IBOutlet weak var checkInDatePicker: UIDatePicker!
    @IBOutlet weak var checkOutDateLabel: UILabel!
    @IBOutlet weak var checkOutDatePicker: UIDatePicker!
    
    @IBOutlet weak var numbeOfAdultsLabel: UILabel!
    @IBOutlet weak var numberOfAdultsStepper: UIStepper!
    @IBOutlet weak var numberOfChildrenLabel: UILabel!
    @IBOutlet weak var numberOfChildrenStepper: UIStepper!
    
    @IBOutlet weak var wifiSwitch: UISwitch!
    @IBOutlet weak var roomTypeLabel: UILabel!
    
    @IBOutlet weak var numberOfNightsLabel: UILabel!
    @IBOutlet weak var nightDatesLabel: UILabel!
    @IBOutlet weak var roomTotalChargesLabel: UILabel!
    @IBOutlet weak var roomTypeDetailsLabel: UILabel!
    @IBOutlet weak var wifiTotalChargesLabel: UILabel!
    @IBOutlet weak var wifiOptionLabel: UILabel!
    @IBOutlet weak var totalChargesLabel: UILabel!
    
    var roomType: RoomType?
    
    
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        return dateFormatter
    }()
    
    let checkInDateLabelCellIndexPath = IndexPath(row: 0, section: 1)
    let checkOutDateLabelCellIndexPath = IndexPath(row: 2, section: 1)
    
    let checkInDatePickerCellIndexPath = IndexPath(row: 1, section: 1)
    let checkOutDatePickerCellIndexPath = IndexPath(row: 3, section: 1)
    
    var isCheckInDatePickerVisible: Bool = false {
        didSet {
            checkInDatePicker.isHidden = !isCheckInDatePickerVisible
        }
    }
    
    var isCheckOutDatePickerVisible: Bool = false {
        didSet {
            checkOutDatePicker.isHidden = !isCheckOutDatePickerVisible
        }
    }
    
    var registration: Registration? {
        guard let roomType = roomType else { return nil }
        
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let checkInDate = checkInDatePicker.date
        let checkOutDate = checkOutDatePicker.date
        let numberOfAdults = Int(numberOfAdultsStepper.value)
        let numberOfChildren = Int(numberOfChildrenStepper.value)
        let hasWifi = wifiSwitch.isOn
        
        return Registration(firstName: firstName,
                            lastName: lastName,
                            emailAddress: email,
                            checkInDate: checkInDate,
                            checkOutDate: checkOutDate,
                            numberOfAdults: numberOfAdults,
                            numberOfChildren: numberOfChildren,
                            wifi: hasWifi,
                            roomType: roomType)
    }
    
    var existingRegistration: Registration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "New Guest Registration"
        
        if let existingRegistration = existingRegistration {
            title = "View Guest Details"
            doneBarButton.isEnabled = false
            
            roomType = existingRegistration.roomType
            firstNameTextField.text = existingRegistration.firstName
            lastNameTextField.text = existingRegistration.lastName
            emailTextField.text = existingRegistration.emailAddress
            checkInDatePicker.date = existingRegistration.checkInDate
            checkOutDatePicker.date = existingRegistration.checkOutDate
            numberOfAdultsStepper.value = Double(existingRegistration.numberOfAdults)
            numberOfChildrenStepper.value = Double(existingRegistration.numberOfChildren)
            wifiSwitch.isOn = existingRegistration.wifi
        } else {
            let midnightToday = Calendar.current.startOfDay(for: Date())
            checkInDatePicker.minimumDate = midnightToday
            checkInDatePicker.date = midnightToday
        }
        
        if self.registration == nil {
            doneBarButton.isEnabled = false
        }
        
        updateDateViews()
        updateNumberOfGuests()
        updateRoomType()
        updateChargesSection()
    }
    
    func updateDateViews() {
        checkOutDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: checkInDatePicker.date)
        checkInDateLabel.text = dateFormatter.string(from: checkInDatePicker.date)
        checkOutDateLabel.text = dateFormatter.string(from: checkOutDatePicker.date)
    }
    
    func updateNumberOfGuests() {
        numbeOfAdultsLabel.text = "\(Int(numberOfAdultsStepper.value))"
        numberOfChildrenLabel.text = "\(Int(numberOfChildrenStepper.value))"
    }
    
    func updateDoneButtonState() {
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        if let roomType = roomType {
            doneBarButton.isEnabled = !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty && !roomType.name.isEmpty
        }
    }
    
    func updateRoomType() {
        if let roomType = roomType {
            roomTypeLabel.text = roomType.name
        } else {
            roomTypeLabel.text = "Not Set"
        }
    }
    
    func updateChargesSection() {
        let dateComponents = Calendar.current.dateComponents([.day], from: checkInDatePicker.date, to: checkOutDatePicker.date)
        let numberOfNighs = dateComponents.day ?? 0
        
        numberOfNightsLabel.text =  "\(numberOfNighs)"
        nightDatesLabel.text = " \(dateFormatter.string(from: checkInDatePicker.date)) - \(dateFormatter.string(from: checkOutDatePicker.date))"
        
        let roomPrice: Int
        if let roomType = roomType {
            roomPrice = roomType.price * numberOfNighs
            roomTotalChargesLabel.text = "$ \(roomPrice)"
            roomTypeDetailsLabel.text = "\(roomType.name) @ $ \(roomType.price)/night"
        } else {
            roomPrice = 0
            roomTotalChargesLabel.text = "--"
            roomTypeDetailsLabel.text = "--"
        }
        
        let wifiPrice: Int
        if wifiSwitch.isOn {
            wifiPrice = numberOfNighs * 10
        } else {
            wifiPrice = 0
        }
        wifiTotalChargesLabel.text = "$ \(wifiPrice)"
        wifiOptionLabel.text =  wifiSwitch.isOn ? "Yes" : "No"

       totalChargesLabel.text = "$ \(roomPrice + wifiPrice)"
        
    }

    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateDateViews()
        updateChargesSection()
    }
   
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        updateNumberOfGuests()
        updateChargesSection()
    }
    
    @IBAction func wifiSwitchChanged(_ sender: UISwitch) {
        updateChargesSection()
    }
    
    @IBAction func editingChangedTextField(_ sender: UITextField) {
        updateDoneButtonState()
        print("test")
    }
 
    @IBSegueAction func selectRoomType(_ coder: NSCoder) -> SelectRoomTypeTableViewController? {
        let selectRoomTypeController = SelectRoomTypeTableViewController(coder: coder)
        selectRoomTypeController?.delegate = self
        selectRoomTypeController?.roomType = roomType
        return selectRoomTypeController
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case checkInDatePickerCellIndexPath where isCheckInDatePickerVisible == false:
            return 0
        case checkOutDatePickerCellIndexPath where isCheckOutDatePickerVisible == false:
            return 0
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath == checkInDateLabelCellIndexPath && isCheckOutDatePickerVisible == false {
            // check-in label selected, check-out picker is not visible, toggle check-in picker
            isCheckInDatePickerVisible.toggle()
        } else if indexPath == checkOutDateLabelCellIndexPath && isCheckInDatePickerVisible == false {
            // check-out label selected, check-in picker is not visible, toggle check-out picker
            isCheckOutDatePickerVisible.toggle()
        } else if indexPath == checkInDateLabelCellIndexPath || indexPath == checkOutDateLabelCellIndexPath {
            // either label was selected, previous conditions failed meaning at least one picker is visible, toggle both
            isCheckInDatePickerVisible.toggle()
            isCheckOutDatePickerVisible.toggle()
        } else {
            return
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
  
    func selectRoomTypeTableViewController(_ controller: SelectRoomTypeTableViewController, didSelect roomType: RoomType) {
        self.roomType = roomType
        updateRoomType()
        updateDoneButtonState()
        updateChargesSection()
    }
    
}
