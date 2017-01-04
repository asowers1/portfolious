import ReactiveJSON
import ReactiveSwift

/// - parameter empty: This empty string can prevent requests from
///   generating invalid file fixture paths.
public let empty = ""

public struct Fixture: Singleton {
    public typealias Instance = Fixture.File
    public fileprivate(set) static var shared = Instance()

    public struct File: ServiceHost {
        public static var scheme: String = "file"
        public static var host: String = ""
        public static var path: String? = nil
    }
}

public enum FixtureError: Error, CustomStringConvertible {
    case fileNotFound(String)

    /// - parameter description: The error's description.
    public var description: String {
        switch self {
        case .fileNotFound(let name):
            if name.hasSuffix(".json") {
                return "Please omit the file extension '.json' when referencing fixtures."
            }
            return "Unable to locate JSON fixture named: \(name)"
        }
    }
}

extension Fixture {
    public static func set(file name: String) throws {
        guard let url = Bundle.testOrMainBundle().url(forResource: name, withExtension: "json")
            , let components = NSURLComponents(url: url, resolvingAgainstBaseURL: false)
            , let scheme = components.scheme, scheme == "file"
            , let path = components.path else {
                throw FixtureError.fileNotFound(name)
        }
        File.host = path
    }

    public static func request<T>(fixture name: String, failed: ((NetworkError) -> Void)? = nil, completed: (() -> Void)? = nil, interrupted: (() -> Void)? = nil, next: ((T) -> Void)? = nil) throws {
        try set(file: name)

        let request: SignalProducer<T, NetworkError> = Fixture.request(endpoint: empty)
        let observer = Observer<T, NetworkError> (
            value: next,
            failed: failed,
            completed: { File.host = ""; completed?() },
            interrupted: interrupted
        )

        request.start(observer)
    }
}

// MARK: - EndpointResource -
//------------------------------------------------------------------------------
public protocol EndpointResourceable: Collection, ExpressibleByArrayLiteral {
    init<S: Sequence>(_ s: S) where S.Iterator.Element == [String:AnyObject]
}

public struct EndpointResource<R: Resource>: EndpointResourceable where R.Attributes == JSONResource {
    //--------------------------------------------------------------------------
    public typealias Index = Int
    public typealias Element = R
    //--------------------------------------------------------------------------
    fileprivate let data: [Element]
    //--------------------------------------------------------------------------
    public var startIndex: Index { return data.startIndex }
    public var endIndex: Index { return data.endIndex }
    
    public func index(after i: Int) -> Int {
        return data.index(after: i)
    }
    
    public subscript (position: Index) -> Element {
        return data[position]
    }
    //--------------------------------------------------------------------------
    public init<S : Sequence>(_ s: S) where S.Iterator.Element == [String : AnyObject] {
        data = s.map(R.init).flatMap { $0 }
    }
    public init(arrayLiteral elements: Element...) {
        data = elements
    }
    //--------------------------------------------------------------------------
}

// MARK: -
// MARK: Extension, NSBundle
// MARK: -
extension Bundle {
    fileprivate final class _DummyClass { }

    /**
     Produces `testBundle` when called from unit tests. Produces `mainBundle`
     when called from an application target.
     
     - returns: `Test` or `Main` bundle.
     */
    fileprivate class func testOrMainBundle() -> Bundle {
        let bundles = Bundle
            .allBundles
            .filter {
                return ($0.bundlePath as NSString).pathExtension == "xctest"
        }
        return bundles.first ?? .main
    }
}

