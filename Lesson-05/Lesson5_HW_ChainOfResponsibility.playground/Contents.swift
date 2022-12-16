import UIKit

func data(from file: String) -> Data {
    let path1 = Bundle.main.path(forResource: file, ofType: "json")!
    let url = URL(fileURLWithPath: path1)
    let data = try! Data(contentsOf: url)
    return data
}

let data1 = data(from: "1")
let data2 = data(from: "2")
let data3 = data(from: "3")


// MARK: - Решение

let decoder = JSONDecoder()

struct Person: Codable {
    var name: String
    var age: Int
    var isDeveloper: Bool
}

protocol PersonsHandler: AnyObject {
    var next: PersonsHandler? {get set}
    func handlePersons(data: Data) -> [Person]?
}

func append(handler: PersonsHandler, to chain: PersonsHandler) {
    guard let next = chain.next else {
        chain.next = handler
        return
    }
    append(handler: handler, to: next)
}

class PersonArrayHandler: PersonsHandler {
    var next: PersonsHandler?
    func handlePersons(data: Data) -> [Person]? {
        do {
            let result = try decoder.decode([Person].self, from: data)
            return result
        } catch {
            return next?.handlePersons(data: data)
        }
    }
}

class PersonDataHandler: PersonsHandler {
    var next: PersonsHandler?
    func handlePersons(data: Data) -> [Person]? {
        do {
            let result = try decoder.decode(structPerson.self, from: data)
            return result.data
        } catch {
            return next?.handlePersons(data: data)
        }
    }
    class StructPerson: Codable {
        var data: [Person]
    }
}

class PersonResultHandler: PersonsHandler {
    var next: PersonsHandler?
    func handlePersons(data: Data) -> [Person]? {
        do {
            let result = try decoder.decode(structPerson.self, from: data)
            return result.result
        } catch {
            return next?.handlePersons(data: data)
        }
    }
    class StructPerson: Codable {
        var result: [Person]
    }
}

var chainPersonHandler = PersonDataHandler()
append(handler: PersonArrayHandler(), to: chainPersonHandler)
append(handler: PersonResultHandler(), to: chainPersonHandler)

let result1 = chainPersonHandler.handlePersons(data: data1)
let result2 = chainPersonHandler.handlePersons(data: data2)
let result3 = chainPersonHandler.handlePersons(data: data3)

// MARK: - Решение через generic
class PersonGenericHandler<T: Codable>: PersonsHandler {
    var next: PersonsHandler?
    func handlePersons(data: Data) -> [Person]? {
        do {
            let result = try decoder.decode(T.self, from: data)
            return getPersons(result)
        } catch {
            return next?.handlePersons(data: data)
        }
    }
    func getPersons(_ parsedData: T) -> [Person]? {
        return nil
    }
}

struct DataPersonsVariation: Codable {
    var data: [Person]
}
struct ResultPersonsVariation: Codable {
    var result: [Person]
}

class PersonDataGenericHandler: PersonGenericHandler<DataPersonsVariation> {
    override func getPersons(_ parsedData: DataPersonsVariation) -> [Person]? {
        return parsedData.data
    }
}

class PersonResultGenericHandler: PersonGenericHandler<ResultPersonsVariation> {
    override func getPersons(_ parsedData: ResultPersonsVariation) -> [Person]? {
        return parsedData.result
    }
}

class PersonArrayGenericHandler: PersonGenericHandler<[Person]> {
    override func getPersons(_ parsedData: [Person]) -> [Person]? {
        return parsedData
    }
}


var testGenericHandler = PersonDataGenericHandler()
append(handler: PersonResultGenericHandler(), to: testGenericHandler)
append(handler: PersonArrayGenericHandler(), to: testGenericHandler)

let result4 = testGenericHandler.handlePersons(data: data1)
let result5 = testGenericHandler.handlePersons(data: data2)
let result6 = testGenericHandler.handlePersons(data: data3)
