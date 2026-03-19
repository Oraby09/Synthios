import Foundation
import Testing
@testable import Synthios

@Suite(.serialized) struct NodeServiceManagerTests {
    @Test func `builds node service commands with current CLI shape`() throws {
        let tmp = try makeTempDirForTests()
        CommandResolver.setProjectRoot(tmp.path)

        let synthiosPath = tmp.appendingPathComponent("node_modules/.bin/synthios")
        try makeExecutableForTests(at: synthiosPath)

        let start = NodeServiceManager._testServiceCommand(["start"])
        #expect(start == [synthiosPath.path, "node", "start", "--json"])

        let stop = NodeServiceManager._testServiceCommand(["stop"])
        #expect(stop == [synthiosPath.path, "node", "stop", "--json"])
    }
}
