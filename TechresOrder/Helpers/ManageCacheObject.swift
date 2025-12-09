//
//  ManageCacheObject.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 12/01/2023.
//


import UIKit
import ObjectMapper

public class ManageCacheObject {
    
    // MARK: - setConfig
    static func setConfig(_ config: Config){
        UserDefaults.standard.set(Mapper<Config>().toJSON(config), forKey:Constants.KEY_DEFAULT_STORAGE.KEY_CONFIG)
    }
    
    static func getConfig() -> Config {
        guard let configObject = UserDefaults.standard.object(forKey: Constants.KEY_DEFAULT_STORAGE.KEY_CONFIG),
              let config = Mapper<Config>().map(JSONObject: configObject) else {
            return Config() // safe fallback
        }
        return config
    }
    
    // MARK: - setSetting
    static func setSetting(_ setting: Setting){
        UserDefaults.standard.set(Mapper<Setting>().toJSON(setting), forKey:Constants.KEY_DEFAULT_STORAGE.KEY_SETTING)
    }
    
    static func getSetting() -> Setting {
        guard let settingObject = UserDefaults.standard.object(forKey: Constants.KEY_DEFAULT_STORAGE.KEY_SETTING),
              let setting = Mapper<Setting>().map(JSONObject: settingObject) else {
            return Setting()
        }
        return setting
    }

    
    
    //Mark - check setting biometris
    static func setBiometric(_ biometric:String){
        UserDefaults.standard.set(biometric, forKey: Constants.KEY_DEFAULT_STORAGE.KEY_BIOMETRIC)
    }
    
    static func getBiometric()->String{
         if let biometric  = UserDefaults.standard.object(forKey: Constants.KEY_DEFAULT_STORAGE.KEY_BIOMETRIC){
           
            return String(biometric as! String)
         }else{
            return ""
         }
 
    }
    
    
    static func saveCurrentUser(_ user: Account) {
        UserDefaults.standard.set(Mapper<Account>().toJSON(user), forKey:Constants.KEY_DEFAULT_STORAGE.KEY_ACCOUNT)
        UserDefaults.standard.synchronize()
    }
    
    static func getCurrentUser() -> Account {
        guard let user = UserDefaults.standard.object(forKey: Constants.KEY_DEFAULT_STORAGE.KEY_ACCOUNT) else {
            return Account()
        }
        
        if let mappedUser = Mapper<Account>().map(JSONObject: user) {
            return mappedUser
        } else {
            return Account()
        }
    }

    
    // MARK: - ACCESS_TOKEN
    static func setAccessToken(_ access_token:String){
        UserDefaults.standard.set(access_token, forKey: Constants.KEY_DEFAULT_STORAGE.KEY_TOKEN)
    }
    
    static func getAccessToken()->String{
        if let access_token : String = UserDefaults.standard.object(forKey: Constants.KEY_DEFAULT_STORAGE.KEY_TOKEN) as? String{
            return access_token
        }else{
            return ""
        }
    }
    
    
    
    // MARK: - Username
    static func setEnvironment(_ environment:EnvironmentMode){
        UserDefaults.standard.set(environment.value, forKey: Constants.KEY_DEFAULT_STORAGE.KEY_ENVIRONMENT_MODE)
    }

    static func getEnvironment() -> EnvironmentMode{
        if let environmentValue = UserDefaults.standard.object(forKey: Constants.KEY_DEFAULT_STORAGE.KEY_ENVIRONMENT_MODE){
            

            return EnvironmentMode(value: environmentValue as? Int ?? ONLINE)
            
        }else{
            
            return EnvironmentMode.online
            
        }
    }
    
    
    // MARK: - Username
    static func setSavedLoginInfo(_ infor:SavedLoginInfor){
        
        UserDefaults.standard.set(Mapper<SavedLoginInfor>().toJSON(infor), forKey:Constants.KEY_DEFAULT_STORAGE.KEY_SAVED_LOGIN_INFOR)
        
    }

    static func getSavedLoginInfo() -> SavedLoginInfor{
        if let infor  = UserDefaults.standard.object(forKey: Constants.KEY_DEFAULT_STORAGE.KEY_SAVED_LOGIN_INFOR){

            return Mapper<SavedLoginInfor>().map(JSONObject: infor) ?? SavedLoginInfor()
            
        }else{
            
           return SavedLoginInfor()
            
        }

    }
    
    
//    // MARK: - Username
//    static func setUsername(_ username:String){
//       UserDefaults.standard.set(username, forKey: Constants.KEY_DEFAULT_STORAGE.KEY_PHONE)
//    }
//
//    static func getUsername()->String{
//        if let username  = UserDefaults.standard.object(forKey: Constants.KEY_DEFAULT_STORAGE.KEY_PHONE){
//           
//           return String(username as! String)
//        }else{
//           return ""
//        }
//
//    }
    
    // MARK: - Password
    static func setPassword(_ password:String){
        UserDefaults.standard.set(password, forKey:Constants.KEY_DEFAULT_STORAGE.KEY_PASSWORD)
    }

    static func getPassword()->String{
        if let password  = UserDefaults.standard.object(forKey: Constants.KEY_DEFAULT_STORAGE.KEY_PASSWORD){
           return String(password as! String)
        }else{return ""}
    }
    
//    // MARK: - Set chef-bar Config
//    static func setChefBarConfigs(_ chefBarConfigs: [Printer], cache_key:String){
//        UserDefaults.standard.set(Mapper<Printer>().toJSONArray(chefBarConfigs), forKey:cache_key)
//    }
//    // MARK: -  Get Printer Config
//    static func getChefBarConfigs(cache_key:String) -> [Printer]{
//        if let chefBarConfigs  = UserDefaults.standard.object(forKey: cache_key){
//            return Mapper<Printer>().mapArray(JSONArray: chefBarConfigs as! [[String : Any]])
//        }else{
//            return [Printer]()
//        }
//    }

    // MARK: - Set chef-bar Config
    static func setPrinters(_ printers: [Printer], cache_key:String){
        UserDefaults.standard.set(Mapper<Printer>().toJSONArray(printers), forKey:cache_key)
    }
    // MARK: -  Get Printer Config
    static func getPrinters(cache_key:String) -> [Printer]{
        if let printers  = UserDefaults.standard.object(forKey: cache_key){
            return Mapper<Printer>().mapArray(JSONArray: printers as! [[String : Any]])
        }else{
            return []
        }
    }
    

    
    
    // MARK: - PUSH_TOKEN
    static func setPushToken(_ push_token:String){
        UserDefaults.standard.set(push_token, forKey: Constants.KEY_DEFAULT_STORAGE.KEY_PUSH_TOKEN)
    }
    
    static func getPushToken()->String{
        if let push_token : String = UserDefaults.standard.object(forKey: Constants.KEY_DEFAULT_STORAGE.KEY_PUSH_TOKEN) as? String{
            return push_token
        }else{
            return ""
        }
    }
    
    
    static func saveCurrentPoint(_ currentPoint : NextPoint) {
        UserDefaults.standard.set(Mapper<NextPoint>().toJSON(currentPoint), forKey:Constants.KEY_DEFAULT_STORAGE.KEY_CURRENT_POINT)
        
    }
    
    static func getCurrentPoint() -> NextPoint {
        if let currentPoint  = UserDefaults.standard.object(forKey: Constants.KEY_DEFAULT_STORAGE.KEY_CURRENT_POINT){
            return Mapper<NextPoint>().map(JSONObject: currentPoint)!
        }else{
            return NextPoint.init()!
        }
    }
    
    
    
    public static func isLogin()->Bool{
        let account = ManageCacheObject.getCurrentUser()
        if(account.id == 0){
            return false
        }
        return true
    }
    
    
    static func saveCurrentBranch(_ branch : Branch) {
        UserDefaults.standard.set(Mapper<Branch>().toJSON(branch), forKey:Constants.KEY_DEFAULT_STORAGE.KEY_BRANCH)
    }
    
    static func getCurrentBranch() -> Branch {
        if let branch  = UserDefaults.standard.object(forKey: Constants.KEY_DEFAULT_STORAGE.KEY_BRANCH){
            return Mapper<Branch>().map(JSONObject: branch)!
        }else{
            return Branch.init()
        }
    }
        
    static func saveCurrentBrand(_ brand : Brand) {
        UserDefaults.standard.set(Mapper<Brand>().toJSON(brand), forKey:Constants.KEY_DEFAULT_STORAGE.KEY_BRAND)
        
    }
    
    static func getCurrentBrand() -> Brand {
        if let brand  = UserDefaults.standard.object(forKey: Constants.KEY_DEFAULT_STORAGE.KEY_BRAND){
            return Mapper<Brand>().map(JSONObject: brand)!
        }else{
            return Brand.init()
        }
    }
    
    
    
    static func setPaymentMethod(_ paymentMethod: PaymentMethod) {
        UserDefaults.standard.set(Mapper<PaymentMethod>().toJSON(paymentMethod), forKey:Constants.KEY_DEFAULT_STORAGE.KEY_PAYMENT_METHOD)
    }
    
    static func getPaymentMethod() -> PaymentMethod {
        if let method  = UserDefaults.standard.object(forKey: Constants.KEY_DEFAULT_STORAGE.KEY_PAYMENT_METHOD){
            return Mapper<PaymentMethod>().map(JSONObject: method)!
        }else{
            return PaymentMethod.init()
        }
    }
    
    
    static func setOrderMethod(_ orderMethod: OrderMethod) {
        UserDefaults.standard.set(Mapper<OrderMethod>().toJSON(orderMethod), forKey:Constants.KEY_DEFAULT_STORAGE.KEY_ORDER_METHOD)
    }
    
    static func getOrderMethod() -> OrderMethod {
        if let method  = UserDefaults.standard.object(forKey: Constants.KEY_DEFAULT_STORAGE.KEY_ORDER_METHOD){
            return Mapper<OrderMethod>().map(JSONObject: method)!
        }else{
            return OrderMethod.init()
        }
    }
    
    
    static func setIdleTimerStatus(_ status: Bool) {
        UserDefaults.standard.set(status, forKey:Constants.KEY_DEFAULT_STORAGE.KEY_IDLE_TIMER)
    }
    
    static func getIdleTimerStatus() -> Bool {
        if let status  = UserDefaults.standard.object(forKey: Constants.KEY_DEFAULT_STORAGE.KEY_IDLE_TIMER){
            return status as! Bool
        }else{
            return false
        }
    }
    
//    static func setConfirmOrderWhenHavingDriver(_ confirm: Bool) {
//        UserDefaults.standard.set(confirm, forKey:Constants.KEY_DEFAULT_STORAGE.KEY_CONFIRM_ORDER_WHEN_HAVING_DRIVER)
//    }
//    
//    static func confirmAppFoodOrderWhenHavingDriver() -> Bool {
//        if let status  = UserDefaults.standard.object(forKey: Constants.KEY_DEFAULT_STORAGE.KEY_CONFIRM_ORDER_WHEN_HAVING_DRIVER){
//            return status as! Bool
//        }else{
//            return false
//        }
//    }
//    

    static func setIsDevMode(_ isDevMode: Bool){
        UserDefaults.standard.set(isDevMode, forKey: Constants.KEY_DEFAULT_STORAGE.KEY_DEV_MODE)
    }
    
    static func isDevMode()->Bool{
        let isDevMode : Bool = UserDefaults.standard.bool(forKey: Constants.KEY_DEFAULT_STORAGE.KEY_DEV_MODE)
        return isDevMode
    }
    
    static func setBankAccount(_ bankAccount : BankAccount) {
        UserDefaults.standard.set(Mapper<BankAccount>().toJSON(bankAccount), forKey:Constants.KEY_DEFAULT_STORAGE.KEY_BANK_ACCOUNT)
    }
    
    static func getBankAccount() -> BankAccount {
        if let bankAccount  = UserDefaults.standard.object(forKey: Constants.KEY_DEFAULT_STORAGE.KEY_BANK_ACCOUNT){
            return Mapper<BankAccount>().map(JSONObject: bankAccount)!
        }else{
            return BankAccount()
        }
    }
    
    // MARK: - Setting Notification
    static func setSettingNotify(_ notifySetting: NotificationSetting){
        UserDefaults.standard.set(Mapper<NotificationSetting>().toJSON(notifySetting), forKey:Constants.KEY_DEFAULT_STORAGE.KEY_SETTING_NOTIFY)
    }
    
    static func getSettingNotify() -> NotificationSetting{
        if let notifySetting  = UserDefaults.standard.object(forKey: Constants.KEY_DEFAULT_STORAGE.KEY_SETTING_NOTIFY){
            return Mapper<NotificationSetting>().map(JSONObject: notifySetting)!
        }else{
            return NotificationSetting.init()!
        }
    }
    
}
