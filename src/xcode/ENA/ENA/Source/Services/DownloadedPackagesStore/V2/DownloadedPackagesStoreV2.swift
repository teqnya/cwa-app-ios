// Corona-Warn-App
//
// SAP SE and all other contributors
// copyright owners license this file to you under the Apache
// License, Version 2.0 (the "License"); you may not use this
// file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import Foundation
import FMDB

protocol DownloadedPackagesStoreV2: AnyObject {

	func open()
	func close()

	func set(country: Country.ID, hour: Int, day: String, etag: String?, package: SAPDownloadedPackage)
	func set(country: Country.ID, day: String, etag: String?, package: SAPDownloadedPackage, completion: ((SQLiteErrorCode?) -> Void)?)

	/// Fetch key packages with a given ETag
	/// - Parameter ETag: The ETag to match
	/// - Returns: A list of matching key packages or `nil` if no matching packages were found
	func packages(with ETag: String) -> [SAPDownloadedPackage]?
	func package(for day: String, country: Country.ID) -> SAPDownloadedPackage?
	func hourlyPackages(for day: String, country: Country.ID) -> [SAPDownloadedPackage]
	func allDays(country: Country.ID) -> [String] // 2020-05-30
	func hours(for day: String, country: Country.ID) -> [Int]

	func reset()
	func deleteOutdatedDays(now: String) throws

	/// Deletes a given `SAPDownloadedPackage`.
	/// - Parameter package: The package to remove from the store
	/// - Throws: An error of type `SQLiteStoreError`
//	func delete(package: SAPDownloadedPackage) throws


	#if !RELEASE
	var keyValueStore: Store? { get set }
	#endif
}
