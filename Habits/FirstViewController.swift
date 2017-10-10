//
//  FirstViewController.swift
//  Habits
//
//  Created by Angelo Ramos on 12/6/16.
//  Copyright © 2016 Palmsonntag, Inc. All rights reserved.
//

import UIKit
import ConfettiView

var habitsArray = [Habit]()
var savingsArray = [Saving]()

class FirstViewController: UIViewController, UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var goalField: UITextField!
    @IBOutlet weak var dailyButt: UIButton!
    @IBOutlet weak var weeklyButt: UIButton!
    @IBOutlet weak var monthlyButt: UIButton!
    @IBOutlet weak var yearlyButt: UIButton!
    @IBOutlet weak var freqLabel: UILabel!
    @IBOutlet weak var buildButt: UIButton!
    @IBOutlet weak var quitButt: UIButton!
    @IBOutlet weak var addViewCenter: NSLayoutConstraint!
    @IBOutlet weak var editButt: UIButton!
    @IBOutlet weak var nameHabLabel: UILabel!
    @IBOutlet weak var goalHabLabel: UILabel!
    @IBOutlet weak var connectView: UIView!
    @IBOutlet weak var wishPicker: UIPickerView!
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var sliderLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var connectBotMargin: NSLayoutConstraint!
    @IBOutlet weak var appleImg: UIImageView!
    @IBOutlet weak var lightImg: UIImageView!
    @IBOutlet weak var pencilImg: UIImageView!
    @IBOutlet weak var noHabsLabel: UILabel!
    @IBOutlet weak var savingsCollView: UICollectionView!
    @IBOutlet weak var dim: UIView!
    @IBOutlet weak var connectTextView: UITextView!
    @IBOutlet weak var congratsView: UIView!
    @IBOutlet weak var habitsCollView: UICollectionView!
    @IBOutlet weak var compWishesTextView: UITextView!
    @IBOutlet var confettiView: ConfettiView!
    @IBOutlet weak var congratsCenterConst: NSLayoutConstraint!
    
    @IBOutlet weak var helpButt: UIButton!
    
    var editMode: Bool = false
    var editHab: Bool = false
    var editIndex: Int = 0
    var currentDay: Int = 0
    var storedDay: Int = 0
    var currentMonth: Int = 0
    var storedMonth: Int = 0
    var currentYear: Int = 0
    var storedYear: Int = 0
    var currentWeek: Int = 0
    var storedWeek: Int = 0
    var completedWishes = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        addView.alpha = 0
        connectView.alpha = 0
        congratsView.alpha = 0
        
        self.savingsCollView.delegate = self
        self.savingsCollView.dataSource = self
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FirstViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        self.nameField.delegate = self
        self.goalField.delegate = self
        
        self.goalField.keyboardType = UIKeyboardType.numberPad
        
        //Double tap coll view
        let doubleTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapCollectionView(gesture:)))
        doubleTapGesture.numberOfTapsRequired = 2  // add double tap
        self.habitsCollView.addGestureRecognizer(doubleTapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(FirstViewController.doStuff), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        let secondVC = SecondViewController()
        secondVC.loadWishes()
        
        doStuff()
        
        self.connectTextView.text = ""
        
        if wishesArray.isEmpty == false {
            self.wishPicker.selectRow(0, inComponent: 0, animated: false)
            selectedWish = wishesArray[0].id
        }
        
        if habitsArray.count == 0 {
            appleImg.alpha = 1
            pencilImg.alpha = 1
            lightImg.alpha = 1
            noHabsLabel.alpha = 1
        }
        else {
            appleImg.alpha = 0
            pencilImg.alpha = 0
            lightImg.alpha = 0
            noHabsLabel.alpha = 0
        }
        
        helpButt.layer.borderWidth = 1
        helpButt.layer.borderColor = UIColor.white.cgColor
        helpButt.layer.cornerRadius = 10
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let secondVC = SecondViewController()
        secondVC.loadWishes()
        wishPicker.reloadAllComponents()
        
        if wishesArray.isEmpty == false {
            self.wishPicker.selectRow(0, inComponent: 0, animated: false)
            selectedWish = wishesArray[0].id
        }
        
    }
    
    func doStuff() {
        loadHabits()
        loadSavings()
        loadDates()
        setDates()
        saveDates()
        self.habitsCollView.reloadData()
        self.savingsCollView.reloadData()
        saveHabits()
    }
    
    func saveHabits() {
        let defaults = UserDefaults.standard
        let data = NSKeyedArchiver.archivedData(withRootObject: habitsArray)
        defaults.set(data, forKey: "savedHabits")
    }
    
    func loadHabits() {
        let defaults = UserDefaults.standard
        
        if let data = defaults.object(forKey: "savedHabits") as? NSData {
            habitsArray = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! [Habit]
        }
    }
    
    func saveSavings() {
        let defaults = UserDefaults.standard
        let data = NSKeyedArchiver.archivedData(withRootObject: savingsArray)
        defaults.set(data, forKey: "savedSavings")
    }
    
    func loadSavings() {
        let defaults = UserDefaults.standard
        
        if let data = defaults.object(forKey: "savedSavings") as? NSData {
            savingsArray = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! [Saving]
        }
    }
    
    func setDates() {
        let date = Date()
        let calendar = Calendar.current
        currentYear = calendar.component(.year, from: date)
        currentMonth = calendar.component(.month, from: date)
        currentDay = calendar.component(.day, from: date)
        currentWeek = calendar.component(.weekOfYear, from: date)
    }
    
    func saveDates() {
        let defaults = UserDefaults.standard
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let week = calendar.component(.weekOfYear, from: date)
        defaults.set(day, forKey: "day")
        defaults.set(month, forKey: "month")
        defaults.set(year, forKey: "year")
        defaults.set(week, forKey: "week")
    }
    
    func loadDates() {
        let defaults = UserDefaults.standard
        storedDay = defaults.integer(forKey: "day")
        storedMonth = defaults.integer(forKey: "month")
        storedYear = defaults.integer(forKey: "year")
        storedWeek = defaults.integer(forKey: "week")
    }
    
    func loadImageFromPath(path: String) -> UIImage? {
        
        let image = UIImage(contentsOfFile: path)
        
        if image == nil {
            
            print("missing image at: \(path)")
        }
        return image
        
    }
    
    @IBAction func connectTapped(_ sender: Any) {
        
        if wishesArray.count > 0 {
            connectBotMargin.constant = 0
            connectBotMargin.constant -= self.view.bounds.height
            connectView.alpha = 1
            self.view.layoutIfNeeded()
        
            UIView.animate(withDuration: 0.5, animations: {
            
                self.connectBotMargin.constant += self.view.bounds.height
                self.dimView.alpha = 0.6
                self.view.layoutIfNeeded()
            
            })
        }
        else {
            connectTextView.text = "It looks like you don't have any wishes to connect. Add a wish to get started!"
        }
        
    }
    
    var wishesDict: [String:Int] = [String:Int]()
    var sliderValue: Int = 0
    var selectedWish: String = ""
    
    @IBAction func saveConnectTapped(_ sender: Any) {
        wishesDict[selectedWish] = sliderValue
        hideConnectView()
        var newString: String = ""
        for (key,value) in wishesDict {
            let wishName: String = (wishesArray.first(where: {$0.id == key})?.name)!
            newString += "$\(value) towards \(wishName)\n"
        }
        self.connectTextView.text = newString
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        sliderValue = Int(sender.value)
        
        sliderLabel.text = "Amount: $\(sliderValue)"
        
    }
    
    //Pickerview
    
    // DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return wishesArray.count
    }
    
    // Delegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return wishesArray[row].name
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedWish = wishesArray[row].id
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let str = wishesArray[row].name
        return NSAttributedString(string: str, attributes: [NSForegroundColorAttributeName:UIColor.white])
    }
    
    
    @IBAction func editButtTapped(_ sender: Any) {
        if editMode == false {
            editMode = true
            self.habitsCollView.reloadData()
            self.editButt.setTitle("Done", for: UIControlState.normal)
        }
        else {
            editMode = false
            self.habitsCollView.reloadData()
            self.editButt.setTitle("Edit", for: UIControlState.normal)
        }
    }
    
    @IBAction func cancelConnectTapped(_ sender: Any) {
        hideConnectView()
    }
    
    func hideConnectView() {
        UIView.animate(withDuration: 0.5, animations: {
            
            self.connectBotMargin.constant -= self.view.bounds.height
            self.view.layoutIfNeeded()
            self.connectView.alpha = 0
            self.dimView.alpha = 0
            
        })
    }
    
    @IBAction func addButtTapped(_ sender: AnyObject) {
        
        addViewCenter.constant = 0
        addViewCenter.constant += view.bounds.height
        addView.alpha = 1
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.addViewCenter.constant -= self.view.bounds.height
            self.view.layoutIfNeeded()
            self.dim.alpha = 0.6
            
        })
        
    }
    
    func hideAddView() {
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.addViewCenter.constant += self.view.bounds.height
            self.view.layoutIfNeeded()
            self.addView.alpha = 0
            self.dim.alpha = 0
            
        })
        
    }
    
    func resetFreqColors() {
        dailyButt.backgroundColor = UIColor.clear
        weeklyButt.backgroundColor = UIColor.clear
        monthlyButt.backgroundColor = UIColor.clear
        yearlyButt.backgroundColor = UIColor.clear
    }
    
    var build: Bool = true
    var quit: Bool = false
    
    @IBAction func buildSelected(_ sender: AnyObject) {
        buildButt.backgroundColor = UIColor.lightGray
        quitButt.backgroundColor = UIColor.clear
        build = true
        quit = false
    }
    
    @IBAction func quitSelected(_ sender: AnyObject) {
        buildButt.backgroundColor = UIColor.clear
        quitButt.backgroundColor = UIColor.lightGray
        build = false
        quit = true
    }

    var freqTemp:Int = 0
    
    @IBAction func dailySelected(_ sender: AnyObject) {
        self.resetFreqColors()
        dailyButt.backgroundColor = UIColor.lightGray
        freqTemp = 0
        freqLabel.text = "times per day"
    }
    @IBAction func weeklySelected(_ sender: AnyObject) {
        self.resetFreqColors()
        weeklyButt.backgroundColor = UIColor.lightGray
        freqTemp = 1
        freqLabel.text = "times per week"
    }
    @IBAction func monthlySelected(_ sender: AnyObject) {
        self.resetFreqColors()
        monthlyButt.backgroundColor = UIColor.lightGray
        freqTemp = 2
        freqLabel.text = "times per month"
    }
    @IBAction func yearlySelected(_ sender: AnyObject) {
        self.resetFreqColors()
        yearlyButt.backgroundColor = UIColor.lightGray
        freqTemp = 3
        freqLabel.text = "times per year"
    }
 
    @IBAction func cancelTapped(_ sender: AnyObject) {
        self.hideAddView()
        self.clearAddView()
    }
    
    func clearAddView() {
        self.nameField.text = ""
        self.goalField.text = ""
        self.dailySelected(self)
        self.buildSelected(self)
        goalHabLabel.textColor = UIColor.white
        nameHabLabel.textColor = UIColor.white
        self.wishesDict = [:]
        self.connectTextView.text = ""
    }
    
    @IBAction func congratsFinished(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.congratsCenterConst.constant += self.view.bounds.height
            self.view.layoutIfNeeded()
            self.congratsView.alpha = 0
            self.confettiView.alpha = 0
            self.confettiView.stopAnimating()
            
        })
        
        completedWishes.removeAll()
    }
    
    
    func checkTextFields() -> Bool {
        if nameField.text == "" && goalField.text == "" {
            nameHabLabel.textColor = UIColor.red
            goalHabLabel.textColor = UIColor.red
            return false
        }
        else if goalField.text == "" {
            goalHabLabel.textColor = UIColor.red
            return false
        }
        else if nameField.text == "" {
            nameHabLabel.textColor = UIColor.red
            return false
        }
        
        return true
    }
    
    @IBAction func saveTapped(_ sender: AnyObject) {
        if editHab == false && checkTextFields() {
            habitsArray.insert(Habit(name: self.nameField.text!, goal: Int(self.goalField.text!)!, freq: freqTemp, build: self.build, quit: self.quit, wishes: wishesDict), at: 0)
        self.hideAddView()
        self.habitsCollView.reloadData()
        self.clearAddView()
        
        saveHabits()
            
        pencilImg.alpha = 0
        lightImg.alpha = 0
        appleImg.alpha = 0
        noHabsLabel.alpha = 0
        }
        else if editHab && checkTextFields() {
            let habit = habitsArray[editIndex]
            if habit.name != self.nameField.text! {
                habit.name = self.nameField.text!
            }
            if habit.goal != Int(self.goalField.text!) {
                habit.goal = Int(self.goalField.text!)!
            }
            if habit.freq != freqTemp {
                habit.freq = freqTemp
            }
            if habit.build != self.build {
                habit.build = self.build
            }
            if habit.quit != self.quit {
                habit.quit = self.quit
            }
            if habit.wishes != wishesDict {
                habit.wishes = wishesDict
            }
            self.hideAddView()
            self.clearAddView()
            self.habitsCollView.reloadData()
            self.saveHabits()
            editHab = false
        }
    }
    
    // MARK: - Textfield delegates
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == nameField {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= 10 // Bool
        }
        else if textField == goalField {
            guard let text = textField.text else { return true }
            let newLength = text.characters.count + string.characters.count - range.length
            return newLength <= 3 // Bool
        }
        
        return true
    }
        
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func deleteHabit(_sender: UIButton) {
        let index : Int = (_sender.layer.value(forKey: "index")) as! Int
        habitsArray.remove(at: index)
        self.habitsCollView.reloadData()
        self.saveHabits()
    }
    
    func editHabit(_sender: UIButton) {
        editHab = true
        editIndex = (_sender.layer.value(forKey: "index")) as! Int
        self.addButtTapped(self)
        let habit = habitsArray[editIndex]
        self.nameField.text = habit.name
        self.goalField.text = String(habit.goal)
        wishesDict = habit.wishes
        
        if habit.build == true {
            buildSelected(self)
        }
        else {
            quitSelected(self)
        }
        
        if habit.freq == 0 {
            dailySelected(self)
        }
        else if habit.freq == 1 {
            weeklySelected(self)
        }
        else if habit.freq == 2 {
            monthlySelected(self)
        }
        else {
            yearlySelected(self)
        }
        
    }
    
    
    // MARK: - COLLECTION VIEW DELEGATES
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == habitsCollView {
            return habitsArray.count
        }
        else {
            return savingsArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == habitsCollView {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "habitCell", for: indexPath) as! habitCell
        
        let habit = habitsArray[indexPath.row]
        
        cell.habitLabel.text = habit.name.uppercased()
        
        if habit.freq == 0 && currentDay != storedDay {
            if habit.counter < habit.goal {
                if habit.build {
                    habit.streak = 0
                }
                else {
                    habit.streak += 1
                    for (key,value) in habit.wishes {
                        wishesArray.first(where: {$0.id == key})?.count += value
                        savingsArray.insert(Saving(wish: wishesArray.first(where: {$0.id == key})!, habitName: habit.name, contribution: value), at: 0)
                    }
                    savingsCollView.reloadData()
                }
            }
            habit.counter = 0
        }
        else if habit.freq == 1 && currentWeek != storedWeek {
            if habit.counter < habit.goal {
                if habit.build {
                    habit.streak = 0
                }
                else {
                    habit.streak += 1
                    for (key,value) in habit.wishes {
                        wishesArray.first(where: {$0.id == key})?.count += value
                        savingsArray.insert(Saving(wish: wishesArray.first(where: {$0.id == key})!, habitName: habit.name, contribution: value), at: 0)
                    }
                    savingsCollView.reloadData()
                }
            }
            habit.counter = 0
        }
        else if habit.freq == 2 && currentMonth != storedMonth {
            if habit.counter < habit.goal {
                if habit.build {
                    habit.streak = 0
                }
                else {
                    habit.streak += 1
                    for (key,value) in habit.wishes {
                        wishesArray.first(where: {$0.id == key})?.count += value
                        savingsArray.insert(Saving(wish: wishesArray.first(where: {$0.id == key})!, habitName: habit.name, contribution: value), at: 0)
                    }
                    savingsCollView.reloadData()
                }
            }
            habit.counter = 0
        }
        else if habit.freq == 3 && currentYear != storedYear {
            if habit.counter < habit.goal {
                if habit.build {
                    habit.streak = 0
                }
                else {
                    habit.streak += 1
                    for (key,value) in habit.wishes {
                        wishesArray.first(where: {$0.id == key})?.count += value
                        savingsArray.insert(Saving(wish: wishesArray.first(where: {$0.id == key})!, habitName: habit.name, contribution: value), at: 0)
                    }
                    savingsCollView.reloadData()
                }
            }
            habit.counter = 0
        }
        
        if habit.freq == 0 {
            cell.trackLabel.text = "Today: " + String(habit.counter) + " of " + String(habit.goal)
        }
        else if habit.freq == 1 {
            cell.trackLabel.text = "This week: " + String(habit.counter) + " of " + String(habit.goal)
        }
        else if habit.freq == 2 {
            cell.trackLabel.text = "This month: " + String(habit.counter) + " of " + String(habit.goal)
        }
        else if habit.freq == 3 {
            cell.trackLabel.text = "This year: " + String(habit.counter) + " of " + String(habit.goal)
        }
        
        cell.streakLabel.text = String(habit.streak)
        
        let prog: Float = Float(habit.counter) / Float(habit.goal)
        
        cell.progressBar.setProgress(prog, animated: false)
        
        if editMode == false {
            cell.editButt.alpha = 0
            cell.deleteButt.alpha = 0
            cell.streakLabel.alpha = 1
        }
        else {
            cell.editButt.alpha = 1
            cell.deleteButt.alpha = 1
            cell.streakLabel.alpha = 0
        }
        
        cell.deleteButt.layer.setValue(indexPath.row, forKey: "index")
        cell.deleteButt.addTarget(self, action: #selector(deleteHabit(_sender:)), for: UIControlEvents.touchUpInside)
        
        cell.editButt.layer.setValue(indexPath.row, forKey: "index")
        cell.editButt.addTarget(self, action: #selector(editHabit(_sender:)), for: UIControlEvents.touchUpInside)
        
        saveHabits()
        
        return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "savingCell", for: indexPath) as! savingCell
            let saving = savingsArray[indexPath.row]
            cell.titleLabel.text = "+ $\(saving.contribution) for completing \(saving.habitName)"
            cell.progressBar.layer.cornerRadius = 10
            cell.progressBar.layer.masksToBounds = true
            cell.progressBar.clipsToBounds = true
            cell.progressBar.setProgress(Float(saving.wish.count) / Float(saving.wish.cost), animated: false)
            cell.progressLabel.text = "$\(saving.wish.count) of $\(saving.wish.cost)"
            cell.wishNameLabel.text = saving.wish.name
            cell.backImageView.image = self.loadImageFromPath(path: saving.wish.picPath)
            cell.dim.alpha = 0.5
            saveSavings()
            return cell
        }
    }
    
    func didDoubleTapCollectionView(gesture: UITapGestureRecognizer) {
        loadDates()
        let pointInCollectionView: CGPoint = gesture.location(in: self.habitsCollView)
        let selectedIndexPath: IndexPath = self.habitsCollView.indexPathForItem(at: pointInCollectionView)!
        let habit = habitsArray[selectedIndexPath.row]
        if habit.counter == habit.goal - 1 {
            habit.counter += 1
            if habit.build {
                habit.streak += 1
                for (key,value) in habit.wishes {
                    let wish = wishesArray.first(where: {$0.id == key})
                    if !(wish?.completed)! {
                    wish?.count += value
                        if (wish?.count)! >= (wish?.cost)! {
                            completedWishes.append((wish?.name)!)
                            wish?.completed = true
                            let secondVC = SecondViewController()
                            secondVC.saveWishes()
                        }
                    savingsArray.insert(Saving(wish: wishesArray.first(where: {$0.id == key})!, habitName: habit.name, contribution: value), at: 0)
                    }
                }
                if !completedWishes.isEmpty  {
                    
                    compWishesTextView.text = completedWishes.joined(separator: "\u{0085}")
                    confettiView.startAnimating()
                    congratsCenterConst.constant = 0
                    congratsCenterConst.constant += view.bounds.height
                    congratsView.alpha = 1
                    self.view.layoutIfNeeded()
                    
                    UIView.animate(withDuration: 0.5, animations: {
                        
                        self.congratsCenterConst.constant -= self.view.bounds.height
                        self.view.layoutIfNeeded()
                        self.confettiView.alpha = 0.6
                        
                    })
                }
                
                savingsCollView.reloadData()
            }
            else {
                habit.streak = 0
            }
            saveHabits()
            let secondVC = SecondViewController()
            secondVC.saveWishes()
            habitsCollView.reloadData()
        }
        else {
            habit.counter += 1
            saveHabits()
            habitsCollView.reloadData()
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == habitsCollView {
            return CGSize(width: view.frame.size.width, height: 100)
        }
        else {
            return CGSize(width: view.frame.size.width, height: 120)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

