import Foundation
import JavaScriptCore

struct SunCalcEngine {
    static var sharedInstance: SunCalcEngine = {
        let instance = SunCalcEngine()

        return instance
    }()

    var bundle: Bundle = Bundle.main

    private lazy var context: JSContext = {
        // Finding a good sun calculation library in Swift or Objective-C wasn't easy. I tried almost 5 different
        // libraries, none of them gave me the results we wanted. That's why I went for using the library used in
        // http://suncalc.net, this library is also used by the web version of Daylight. In our app, I'm embedding
        // a portion of the library as a JavaScript file that I'll use to calculate the times for an specific date
        // and coordinates.
        let sunCalcLibraryPath = self.bundle.path(forResource: "suncalc", ofType: "js")!
        let sunCalcLibrary = try! String(contentsOfFile: sunCalcLibraryPath)
        let context = JSContext()!
        context.evaluateScript(sunCalcLibrary)

        return context
    }()

    mutating func calculateTimes(withArguments arguments: [Any]) -> [String: Any] {
        let getTimesJavaScriptMethod = self.context.objectForKeyedSubscript("getTimes")!
        return getTimesJavaScriptMethod.call(withArguments: arguments)!.toObjectOf(NSDictionary.self)! as! [String: Any]
    }
}
