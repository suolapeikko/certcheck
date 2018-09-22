//
//  main.swift
//  certcheck
//
//  Created by Antti Tulisalo on 22/09/2018.
//  Copyright © 2018 Antti Tulisalo. All rights reserved.
//

import Foundation

let args = CommandLine.arguments
let argCount = CommandLine.arguments.count
var errorFlag = false

// Check if there is an incompatible number of arguments
if(argCount != 2) {
    errorFlag = true
}

if(errorFlag) {
    print("certcheck: macOS command line utility that checks certificate signing info from files\n");
    print("         Usage:");
    print("         certcheck <path_to_file>        Path to the file to be checked for signing info");
    exit(EXIT_FAILURE)
}

let checker = CodesignChecker()

var certificates:[SecCertificate] = []
var str : CFString?

do {
    try certificates = checker.getCertificates(forURL: URL.init(fileURLWithPath: args[1]))
    
    if(certificates.count > 0) {
        print(SecCertificateCopySubjectSummary(certificates[0])!)
    }
}
catch let error as CodesignCheckerError {
    // If the file does not have signing, validation in CodesignChecker fails
    print("No signature found from file: \(args[1])")
}

exit(0)
