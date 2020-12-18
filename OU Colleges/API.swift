//
//  API.swift
//  OU Colleges
//
//  Created by Cyberheights Software Technologies Pvt Ltd on 29/09/20.
//  Copyright © 2020 Cyberheights Software Technologies Pvt Ltd. All rights reserved.
//

import Foundation
import RSLoadingView
import Loaf

let ipAdrs = "http://120.138.10.249/OUCOLLEGEAPP/"


let loginApi = "\(ipAdrs)api/Login?pin="

let regstrApi = "\(ipAdrs)api/EnterMobile?MOBILE="

let otpApi = "\(ipAdrs)api/EnterOTP?MOBILE="

let pinApi = "\(ipAdrs)api/EnterPIN?MOBILE="

let forgtApi = "\(ipAdrs)api/ForgotPIN?MOBILE="

let clgPrflAPI = "\(ipAdrs)api/CollegeProfile?Collcode="

let notfyApi = "\(ipAdrs)api/GetNotification"

let alrtCuntApi = "\(ipAdrs)api/CountAlert?COLLCODE="

let alrtApi = "\(ipAdrs)api/GetAlertList?Collcode="

let pgrmApi = "\(ipAdrs)api/GetProgramdetails?Collcode="

let fcltyApi = "\(ipAdrs)api/Getfacultydetails?COLLCODE="

let chngMblApi = "\(ipAdrs)api/ChangeMobile?MOBILE="

let chngPinApi = "\(ipAdrs)api/ChangePIN?MOBILE="

let stdntCuntApi =  "\(ipAdrs)api/ProgramTotalStudents?Collcode="

let stdntPgrmApi = "\(ipAdrs)api/ListCollegeCourses?Collcode="

let stdntSemApi =  "\(ipAdrs)api/ListCollegeRollDetails?Collcode="

let stdntDataApi = "\(ipAdrs)api/ListCollegeRollIDHTNO?COLLCODE="

let stdntInfoApi = "\(ipAdrs)api/GetStudentDetails?HTNo="

let clgUsrApi = "\(ipAdrs)api/CreateCollegeUser?MOBILE="

let clgAdmnApi = "\(ipAdrs)api/CreateCollegeAdmin?MOBILE="

let unvUsrApi = "\(ipAdrs)api/CreateOUUser?MOBILE="

let msgApi = "\(ipAdrs)api/AlertMessageType"

let toApi = "\(ipAdrs)api/AlertTo"

let prityApi = "\(ipAdrs)api/Grouppriority"

let clgApi  = "\(ipAdrs)api/CollegeList"

let postAlrtApi = "\(ipAdrs)api/PostAlter?MTID="

let cidApi = "\(ipAdrs)api/Collegeaddress?Collcode="

//Edit Address

let adrssApi = "\(ipAdrs)api/EditCollegeProfile?CLID="

let distApi = "\(ipAdrs)api/District"

let mandalApi = "\(ipAdrs)api/Mandal?DID="

let loadingView = RSLoadingView(effectType: RSLoadingView.Effect.twins)




