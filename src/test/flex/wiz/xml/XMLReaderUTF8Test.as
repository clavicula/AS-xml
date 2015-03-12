package wiz.xml {
	
	import flash.errors.IOError;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import flexunit.framework.Assert;
	
	
	
	/**
	 * XMLReaderUTF8のテスト
	 */
	public final class XMLReaderUTF8Test {
		
		/**
		 * テスト開始時の処理
		 */
		[BeforeClass]
		public static function setUpBeforeClass():void {
			TEMP_DIR.createDirectory();
		}
		
		/**
		 * テスト終了時の処理
		 */
		[AfterClass]
		public static function tearDownAfterClass():void {
			if (TEMP_DIR.exists) {
				TEMP_DIR.deleteDirectory(true);
			}
		}
		
		
		
		/**
		 * read() のテスト
		 * 
		 * @type 正常系。
		 */
		[Test]
		public function testRead_Normal():void {
			const sourceData:String = [ "<root>", "  <blank />", "  <test>――テスト――</test>", "</root>" ].join("\n");
			const sourceXMLName:String = "testRead_Normal.xml";
			const sourceXMLFile:File = TEMP_DIR.resolvePath(sourceXMLName);
			const sourceXMLPath:String = sourceXMLFile.nativePath;
			
			try {
				writeText(sourceData, sourceXMLPath);
				
				const reader:XMLReader = createXMLReader();
				const resultXML:XML = reader.read(sourceXMLPath);
				Assert.assertEquals("――テスト――", resultXML.test);
			}
			finally {
				if (sourceXMLFile.exists) {
					sourceXMLFile.deleteFile();
				}
			}
		}
		
		/**
		 * read() のテスト
		 * 
		 * @type 正常系。
		 * @comment 読み込みモードでファイルが開かれている。
		 */
		[Test]
		public function testRead_Normal_FileIsOpenedAsReadOnly():void {
			const sourceData:String = [ "<root>", "  <blank />", "  <test>――テスト――</test>", "</root>" ].join("\n");
			const sourceXMLName:String = "testRead_Normal_FileIsOpenedAsReadOnly.xml";
			const sourceXMLFile:File = TEMP_DIR.resolvePath(sourceXMLName);
			const sourceXMLPath:String = sourceXMLFile.nativePath;
			
			try {
				writeText(sourceData, sourceXMLPath);
				const stream:FileStream = new FileStream();
				try {
					stream.open(sourceXMLFile, FileMode.READ);
					
					const reader:XMLReader = createXMLReader();
					const resultXML:XML = reader.read(sourceXMLPath);
					Assert.assertEquals("――テスト――", resultXML.test);
				}
				finally {
					stream.close();
				}
			}
			finally {
				if (sourceXMLFile.exists) {
					sourceXMLFile.deleteFile();
				}
			}
		}
		
		/**
		 * read() のテスト
		 * 
		 * @type 異常系。
		 * @comment XMLパスがnull。
		 */
		[Test]
		public function testRead_Error_SourceXMLPathIsNull():void {
			const sourceXMLPath:String = null;
			
			const reader:XMLReader = createXMLReader();
			try {
				reader.read(sourceXMLPath);
				Assert.fail("Expect: ArgumentError");
			}
			catch (e:ArgumentError) {}
		}
		
		/**
		 * read() のテスト
		 * 
		 * @type 異常系。
		 * @comment XMLパスが空文字列。
		 */
		[Test]
		public function testRead_Error_SourceXMLPathIsEmpty():void {
			const sourceXMLPath:String = "";
			
			const reader:XMLReader = createXMLReader();
			try {
				reader.read(sourceXMLPath);
				Assert.fail("Expect: ArgumentError");
			}
			catch (e:ArgumentError) {}
		}
		
		/**
		 * read() のテスト
		 * 
		 * @type 異常系。
		 * @comment ファイルが存在しない。
		 */
		[Test]
		public function testRead_Error_FileNotFound():void {
			const sourceXMLName:String = "testRead_Error_FileNotFound.xml";
			const sourceXMLFile:File = TEMP_DIR.resolvePath(sourceXMLName);
			const sourceXMLPath:String = sourceXMLFile.nativePath;
			
			const reader:XMLReader = createXMLReader();
			try {
				reader.read(sourceXMLPath);
				Assert.fail("Expect: IOError");
			}
			catch (e:IOError) {}
		}
		
		/**
		 * read() のテスト
		 * 
		 * @type 異常系。
		 * @comment 空のファイル。
		 */
		[Test]
		public function testRead_Error_FileIsBlank():void {
			const sourceXMLName:String = "testRead_Error_FileIsBlank.xml";
			const sourceXMLFile:File = TEMP_DIR.resolvePath(sourceXMLName);
			const sourceXMLPath:String = sourceXMLFile.nativePath;
			
			try {
				writeText("", sourceXMLPath);
				
				const reader:XMLReader = createXMLReader();
				const resultXML:XML = reader.read(sourceXMLPath);
				Assert.assertNotNull(resultXML);
			}
			finally {
				if (sourceXMLFile.exists) {
					sourceXMLFile.deleteFile();
				}
			}
		}
		
		/**
		 * read() のテスト
		 * 
		 * @type 異常系。
		 * @comment ディレクトリパスを指定。
		 */
		[Test]
		public function testRead_Error_FileIsDirectory():void {
			const sourceXMLName:String = "testRead_Error_FileIsDirectory.xml";
			const sourceXMLFile:File = TEMP_DIR.resolvePath(sourceXMLName);
			const sourceXMLPath:String = sourceXMLFile.nativePath;
			
			try {
				sourceXMLFile.createDirectory();
				
				const reader:XMLReader = createXMLReader();
				try {
					reader.read(sourceXMLPath);
					Assert.fail("Expect: IOError");
				}
				catch (e:IOError) {}
			}
			finally {
				if (sourceXMLFile.exists) {
					sourceXMLFile.deleteDirectory();
				}
			}
		}
		
		/**
		 * read() のテスト
		 * 
		 * @type 異常系。
		 * @comment XMLファイルではない。
		 */
		[Test]
		public function testRead_Error_FileIsNotXML():void {
			const sourceData:String = [ "XMLではない", "――テスト――" ].join("\n");
			const sourceXMLName:String = "testRead_Error_FileIsNotXML.xml";
			const sourceXMLFile:File = TEMP_DIR.resolvePath(sourceXMLName);
			const sourceXMLPath:String = sourceXMLFile.nativePath;
			
			try {
				writeText(sourceData, sourceXMLPath);
				
				const reader:XMLReader = createXMLReader();
				const resultXML:XML = reader.read(sourceXMLPath);
				
				// 例外を送出せず、結果を保証しない
				// クラスとして「XMLとして読み込む」という仕様
				Assert.assertNotNull(resultXML["XMLではない"]);
				Assert.assertNotNull(resultXML["――テスト――"]);
			}
			finally {
				if (sourceXMLFile.exists) {
					sourceXMLFile.deleteFile();
				}
			}
		}
		
		/**
		 * read() のテスト
		 * 
		 * @type 異常系。
		 * @comment ファイルがUTF-8エンコードで記述されていない。
		 */
		[Test]
		public function testRead_Error_FileIsNotUTF8():void {
			const sourceData:String = [ "UTF8ではない", "――テスト――" ].join("\n");
			const sourceXMLName:String = "testRead_Error_FileIsNotUTF8.xml";
			const sourceXMLFile:File = TEMP_DIR.resolvePath(sourceXMLName);
			const sourceXMLPath:String = sourceXMLFile.nativePath;
			
			try {
				writeText(sourceData, sourceXMLPath, "Shift_JIS");
				
				const reader:XMLReader = createXMLReader();
				const resultXML:XML = reader.read(sourceXMLPath);
				
				// 例外を送出せず、結果を保証しない
				// クラスとして「UTF-8エンコードで読み込む」という仕様
				Assert.assertNoMatch(/――テスト――/, resultXML.test);
			}
			finally {
				if (sourceXMLFile.exists) {
					sourceXMLFile.deleteFile();
				}
			}
		}
		
		/**
		 * read() のテスト
		 * 
		 * @type 異常系。
		 * @comment 不正なXML。
		 */
		[Test]
		public function testRead_Error_InvalidXML():void {
			// ルート要素が複数存在するXML
			const sourceData:String = [ "<root>", "  <blank />", "  <test>――テスト――</test>", "</root>", "<root2 />" ].join("\n");
			const sourceXMLName:String = "testRead_Error_InvalidXML.xml";
			const sourceXMLFile:File = TEMP_DIR.resolvePath(sourceXMLName);
			const sourceXMLPath:String = sourceXMLFile.nativePath;
			
			try {
				writeText(sourceData, sourceXMLPath);
				
				const reader:XMLReader = createXMLReader();
				try {
					reader.read(sourceXMLPath);
					Assert.fail("Expect: TypeError");
				}
				catch (e:TypeError) {}
			}
			finally {
				if (sourceXMLFile.exists) {
					sourceXMLFile.deleteFile();
				}
			}
		}
		
		/**
		 * read() のテスト
		 * 
		 * @type 異常系。
		 * @comment ファイルが読み書きモードで開かれている。
		 */
		[Test]
		public function testRead_Error_FileIsOpenedAsReadWrite():void {
			const sourceData:String = [ "<root>", "  <blank />", "  <test>――テスト――</test>", "</root>" ].join("\n");
			const sourceXMLName:String = "testRead_Error_FileIsOpenedAsReadWrite.xml";
			const sourceXMLFile:File = TEMP_DIR.resolvePath(sourceXMLName);
			const sourceXMLPath:String = sourceXMLFile.nativePath;
			
			try {
				writeText(sourceData, sourceXMLPath);
				const stream:FileStream = new FileStream();
				try {
					stream.open(sourceXMLFile, FileMode.UPDATE);
					
					const reader:XMLReader = createXMLReader();
					try {
						reader.read(sourceXMLPath);
						Assert.fail("Expect: IOError");
					}
					catch (e:IOError) {}
				}
				finally {
					stream.close();
				}
			}
			finally {
				if (sourceXMLFile.exists) {
					sourceXMLFile.deleteFile();
				}
			}
		}
		
		
		
		/**
		 * XML読み込みオブジェクトを作成
		 * 
		 * @return XML読み込みオブジェクト。
		 */
		private function createXMLReader():XMLReader {
			return new XMLReaderUTF8();
		}
		
		/**
		 * 文字列をファイル出力
		 * 
		 * @param sourceText 出力対象文字列。
		 * @param destFilePath 出力ファイルパス。
		 * @param charset 文字コード。
		 */
		private function writeText(sourceText:String, destFilePath:String, charset:String = "UTF-8"):void {
			const stream:FileStream = new FileStream();
			try {
				const destFile:File = new File(destFilePath);
				stream.open(destFile, FileMode.WRITE);
				stream.writeMultiByte(sourceText, charset);
			}
			finally {
				stream.close();
			}
		}
		
		
		
		/**
		 * テスト用ディレクトリ
		 */
		private static const TEMP_DIR:File = File.applicationStorageDirectory.resolvePath("temp");
		
	}
	
}
