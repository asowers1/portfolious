import Quick
import Nimble
import ReactiveJSON
import ReactiveSwift
import Result

// TODO: Delete Me
struct GW2API: Singleton, ServiceHost {
    fileprivate(set) static var shared = Instance()
    typealias Instance = GW2API

    static var scheme: String { return "https" }
    static var host: String { return "api.guildwars2.com" }
    static var path: String? { return "v2" }
}

// https://github.com/operationstrategy/iOS_APITest
// APITest MUST be running locally for tests to pass against this service host
struct APITest: Singleton, ServiceHost {
	fileprivate(set) static var shared = Instance()
	typealias Instance = APITest
	
	static var scheme: String { return "http" }
	static var host: String { return "0.0.0.0:8080" }
	static var path: String? { return nil }
}


class JSONRequestTests: QuickSpec {
    override func spec() {
        describe("json request") {
            it("returns 'nil' with bad endpoint path") {
                let request: SignalProducer<Any, NetworkError> = GW2API.request(endpoint: "")
                var error: NetworkError? = nil
                request.startWithFailed {
                    error = $0
                }
                expect(error).toNotEventually(beNil(), timeout: 5)
            }

            it("handles request as 'dictionary'") {
                var colors: [String:AnyObject] = [:]
                GW2API.request(endpoint: "colors", parameters: ["id": 4 as AnyObject])
                    .startWithResult {
                        colors = $0.value!
                }
                expect(colors["name"] as? String).toEventually(equal("Gray"), timeout: 5)
            }

            it("handles request as 'int' collection") {
                var colors: [Int]? 
                GW2API.request(endpoint: "colors")
                    .startWithResult { (result: Result<[Int], NetworkError>) in
                        colors = result.value 
                }
                expect(colors?.count).toEventually(equal(513), timeout: 5)
            }
			
			it("handles 401 (unauthorized) requests") {
				var error: NetworkError?
				APITest.request(endpoint: "users")
					.startWithResult { (result: Result<[AnyObject], NetworkError>) in
						error = result.error
				}
				expect(error).toEventually(equal(NetworkError.unauthorized), timeout: 5)
			}
        }
    }
}
