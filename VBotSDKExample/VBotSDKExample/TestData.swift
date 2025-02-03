//
//  TestData.swift
//  VBotPhoneSDK_Example
//
//  Created by DAT NGUYEN QUOC on 02/02/2025.
//

import Foundation

enum TypeDevice {
    case ios
    case android
}

enum TypeTest {
    case vbot
    case xanhsm
}

class SDKMember: NSObject {
    var type: TypeDevice
    var typeTest: TypeTest
    var name: String
    var ext: String
    var code: String
    var token: String
    
    init(type: TypeDevice, typeTest: TypeTest, name: String, ext: String, code: String, token: String) {
        self.type = type
        self.typeTest = typeTest
        self.name = name
        self.ext = ext
        self.code = code
        self.token = token
    }
}

var TestAccount = [
    // XanhSM
    SDKMember(type: .ios, typeTest: .xanhsm, name: "XanhSM iOS 01", ext: "121", code: "ios21", token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJWYWx1ZSI6IjEtMjQtMjEtMjEifQ.OM124gQFEOdr2RQ6l29ggI4BlHBkKWhQ3VBBY3MjuEo"),
    SDKMember(type: .ios, typeTest: .xanhsm, name: "XanhSM iOS 02", ext: "122", code: "ios22", token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJWYWx1ZSI6IjEtMjUtMjItMjIifQ.858VPG1KMSiOXzpCObWx3hWsF4ST2ljEtz5kK1HF5Jc"),
    SDKMember(type: .ios, typeTest: .xanhsm, name: "XanhSM iOS 03", ext: "123", code: "ios23", token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJWYWx1ZSI6IjEtMjYtMjMtMjMifQ.Uv76GrJ_oW2JgOVVyEBxWy0Idix5xTQaQSuVg1G-ZNg"),
    SDKMember(type: .ios, typeTest: .xanhsm, name: "XanhSM iOS 04", ext: "124", code: "ios24", token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJWYWx1ZSI6IjEtMjctMjQtMjQifQ.UpAVAA19UFklYNNIxeKj4zN2YpuFcye71XtL7sX4hlg"),
    SDKMember(type: .ios, typeTest: .xanhsm, name: "XanhSM iOS 05", ext: "125", code: "ios25", token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJWYWx1ZSI6IjEtMjgtMjUtMjUifQ.63NANwXJKQmXKg4cmyxou9l8YDycKa_0M8FDrsKFafM"),
    SDKMember(type: .android, typeTest: .xanhsm, name: "XanhSM Android 01", ext: "126", code: "android26", token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJWYWx1ZSI6IjEtMjktMjYtMjYifQ.qwR3qhuMR0e1F6YnAa50b-vG4hlA1zXxacCy5_NNSsA"),
    SDKMember(type: .android, typeTest: .xanhsm, name: "XanhSM Android 02", ext: "127", code: "android27", token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJWYWx1ZSI6IjEtMzAtMjctMjcifQ.2j-hqLYb54q8lXhU36TlD6XQ_jVvbmZnbQIt4FC2tSw"),
    SDKMember(type: .android, typeTest: .xanhsm, name: "XanhSM Android 03", ext: "128", code: "android28", token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJWYWx1ZSI6IjEtMzEtMjgtMjgifQ.N7HCOCV_8yuAZ8A1nkgDk9_DZHLWe4satajhVM8kU4g"),
    SDKMember(type: .android, typeTest: .xanhsm, name: "XanhSM Android 04", ext: "129", code: "android29", token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJWYWx1ZSI6IjEtMzItMjktMjkifQ.ojM1rv7gcBmQ077IsiM-jQMrk6DLxLhAFdS6r0NWotI"),
    SDKMember(type: .android, typeTest: .xanhsm, name: "XanhSM Android 05", ext: "130", code: "android30", token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJWYWx1ZSI6IjEtMzMtMzAtMzAifQ.DVKgK2Tj09sRi8owK3UJZJGPV-LW7_qZSaPiNikca9M"),
    
    // VBot
    SDKMember(type: .ios, typeTest: .vbot, name: "VBot iOS 01", ext: "101", code: "ios01", token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJWYWx1ZSI6IjEtMS0xLTEifQ.-w3Jxig8RPplSrNtnAZDpGQc9BURFKE5dnj1NgnrylA"),
    SDKMember(type: .ios, typeTest: .vbot, name: "VBot iOS 02", ext: "102", code: "ios02", token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJWYWx1ZSI6IjEtMi0yLTIifQ.yH9TOT7hwsH3Z8w7pv7J60NzECY4vfK9sqg8HBehTQw"),
    SDKMember(type: .ios, typeTest: .vbot, name: "VBot iOS 03", ext: "103", code: "ios03", token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJWYWx1ZSI6IjEtMy0zLTMifQ.Y04o0Ln2rSf6KhU7TlUjf2pj6BthILiaYtrw5BNpcMY"),
    SDKMember(type: .ios, typeTest: .vbot, name: "VBot iOS 04", ext: "104", code: "ios04", token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJWYWx1ZSI6IjEtNC00LTQifQ.zx3lywp2NKp-iz3OYX6yZGv_MYlULqZT-BeBYI_aNG0"),
    SDKMember(type: .ios, typeTest: .vbot, name: "VBot iOS 05", ext: "105", code: "ios05", token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJWYWx1ZSI6IjEtNS01LTUifQ.nhOVoy91DQudVsyT6G1MKscr4yoiopQJqaJoSIv_YJs"),
    SDKMember(type: .ios, typeTest: .vbot, name: "VBot iOS 11", ext: "111", code: "ios11", token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJWYWx1ZSI6IjEtMTQtMTEtMTEifQ.EWmIx1RVrBguttvFK2MdkzlmO15z1zfYixbB_NlS88A"),
    SDKMember(type: .ios, typeTest: .vbot, name: "VBot iOS 12", ext: "112", code: "ios12", token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJWYWx1ZSI6IjEtMTUtMTItMTIifQ.vtxrCI7oZrmwK1iNVWJ_3mCCnACSDuuDxPXurIX74bA"),
    SDKMember(type: .ios, typeTest: .vbot, name: "VBot iOS 13", ext: "113", code: "ios13", token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJWYWx1ZSI6IjEtMTYtMTMtMTMifQ.NcknYj5d_9KbA7x1YC4iyEcqmmbzok2wRHO5OL7-0Pw"),
    SDKMember(type: .ios, typeTest: .vbot, name: "VBot iOS 14", ext: "114", code: "ios14", token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJWYWx1ZSI6IjEtMTctMTQtMTQifQ.-EnPAR32JAIoGKvi1WZuqCtJCR2hk-UI0wrMiSl1ssE"),
    SDKMember(type: .ios, typeTest: .vbot, name: "VBot iOS 15", ext: "115", code: "ios15", token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJWYWx1ZSI6IjEtMTgtMTUtMTUifQ.OOpsRJT162qzC6-LR97H1Q9UUQjwGeB6X4vnmCZ-BXE"),
    SDKMember(type: .android, typeTest: .vbot, name: "VBot Android 06", ext: "106", code: "android06", token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJWYWx1ZSI6IjEtNi02LTYifQ.9_Bz5T57VghN5w4l48w8UuiqGUePXEFtHGV44O1RhLM"),
    SDKMember(type: .android, typeTest: .vbot, name: "VBot Android 07", ext: "107", code: "android07", token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJWYWx1ZSI6IjEtNy03LTcifQ.4Os-MW5PVTa4_-uwakPFyV85PbjQzJjQuMkAMRFZujA"),
    SDKMember(type: .android, typeTest: .vbot, name: "VBot Android 08", ext: "108", code: "android08", token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJWYWx1ZSI6IjEtOC04LTgifQ.itMbSxGxdUlaeT9Fpgb4kFIFYAh2moNEt8CETb4qPTU"),
    SDKMember(type: .android, typeTest: .vbot, name: "VBot Android 09", ext: "109", code: "android09", token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJWYWx1ZSI6IjEtOS05LTkifQ.pJ21Gg1r72meetfwl8V2ava24ZLL0chgVB15xCROrWI"),
    SDKMember(type: .android, typeTest: .vbot, name: "VBot Android 10", ext: "110", code: "android10", token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJWYWx1ZSI6IjEtMTAtMTAtMTAifQ.ZNB9lvkqtj9vTRF9buJUHK1ly5dZB6b3sXAWV10Cbrk"),
    SDKMember(type: .android, typeTest: .vbot, name: "VBot Android 16", ext: "116", code: "android16", token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJWYWx1ZSI6IjEtMTktMTYtMTYifQ.UvZ8-YqNUw8R5XD-RsCOuOFGoSS3yY6kTgE7xRbZRWA"),
    SDKMember(type: .android, typeTest: .vbot, name: "VBot Android 17", ext: "117", code: "android17", token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJWYWx1ZSI6IjEtMjAtMTctMTcifQ.lrKEqFsBoxivSiPCdVgP0hfKOQzhU0z47RfWw_euThk"),
    SDKMember(type: .android, typeTest: .vbot, name: "VBot Android 18", ext: "118", code: "android18", token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJWYWx1ZSI6IjEtMjEtMTgtMTgifQ.cgQVLfEJCHYzAbfCIdkn-kI5f8PTF_n5-tarDTXsTeI"),
    SDKMember(type: .android, typeTest: .vbot, name: "VBot Android 19", ext: "119", code: "android19", token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJWYWx1ZSI6IjEtMjItMTktMTkifQ.uSspalVOoOGncsscooej8IDXWrYkCYZtDO7xsU14M1k"),
    SDKMember(type: .android, typeTest: .vbot, name: "VBot Android 20", ext: "120", code: "android20", token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJWYWx1ZSI6IjEtMjMtMjAtMjAifQ.47Z0n3IwKCvFrIJYWJfL4ZgPAyTQ3NOcLwav4Xiju6w"),
    
]
