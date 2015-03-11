package wiz.xml {
	
	import flash.errors.IOError;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import flexunit.framework.Assert;
	
	
	
	/**
	 * XMLWriterUTF8のテスト
	 */
	public final class XMLWriterUTF8Test {
		
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
		 * write() のテスト
		 * 
		 * @type 正常系。
		 */
		[Test]
		public function testWrite_Normal():void {
			const sourceXML:XML =
			<root>
				<blank />
				<test>――テスト――</test>
			</root>;
			const destXMLName:String = "testWrite_Normal.xml";
			const destXMLFile:File = TEMP_DIR.resolvePath(destXMLName);
			const destXMLPath:String = destXMLFile.nativePath;
			
			try {
				const writer:XMLWriter = createXMLWriter();
				writer.write(sourceXML, destXMLPath);
				
				Assert.assertTrue(destXMLFile.exists);
				Assert.assertEquals(sourceXML, createXMLReader().read(destXMLPath));
			}
			finally {
				if (destXMLFile.exists) {
					destXMLFile.deleteFile();
				}
			}
		}
		
		/**
		 * write() のテスト
		 * 
		 * @type 正常系。
		 * @comment 空のXMLオブジェクト。
		 */
		[Test]
		public function testWrite_Normal_SourceXMLIsBlank():void {
			const sourceXML:XML = new XML();
			const destXMLName:String = "testWrite_Normal_SourceXMLIsBlank.xml";
			const destXMLFile:File = TEMP_DIR.resolvePath(destXMLName);
			const destXMLPath:String = destXMLFile.nativePath;
			
			try {
				const writer:XMLWriter = createXMLWriter();
				writer.write(sourceXML, destXMLPath);
				
				Assert.assertTrue(destXMLFile.exists);
				Assert.assertEquals(sourceXML, createXMLReader().read(destXMLPath));
			}
			finally {
				if (destXMLFile.exists) {
					destXMLFile.deleteFile();
				}
			}
		}
		
		/**
		 * write() のテスト
		 * 
		 * @type 正常系。
		 * @comment 出力パスの親ディレクトリが存在しない。
		 */
		[Test]
		public function testWrite_Normal_ParentDirectoryIsNotExist():void {
			const sourceXML:XML =
			<root>
				<blank />
				<test>――テスト――</test>
			</root>;
			const destXMLName:String = "testWrite_Normal_ParentDirectoryIsNotExist.xml";
			const destXMLFile:File = TEMP_DIR.resolvePath("存在しないディレクトリ").resolvePath(destXMLName);
			const destXMLPath:String = destXMLFile.nativePath;
			
			try {
				const writer:XMLWriter = createXMLWriter();
				writer.write(sourceXML, destXMLPath);
				
				Assert.assertTrue(destXMLFile.exists);
				Assert.assertEquals(sourceXML, createXMLReader().read(destXMLPath));
			}
			finally {
				if (destXMLFile.exists) {
					destXMLFile.deleteFile();
				}
			}
		}
		
		/**
		 * write() のテスト
		 * 
		 * @type 正常系。
		 * @comment 既存ファイルへの上書き。
		 */
		[Test]
		public function testWrite_Normal_FileAlreadyExist():void {
			const sourceXML:XML =
			<root>
				<blank />
				<test>――テスト――</test>
			</root>;
			const destXMLName:String = "testWrite_Normal_FileAlreadyExist.xml";
			const destXMLFile:File = TEMP_DIR.resolvePath(destXMLName);
			const destXMLPath:String = destXMLFile.nativePath;
			
			try {
				createBlankFile(destXMLPath);
				
				const writer:XMLWriter = createXMLWriter();
				writer.write(sourceXML, destXMLPath, true);  // 明示的に上書きフラグを指定
				
				Assert.assertTrue(destXMLFile.exists);
				Assert.assertEquals(sourceXML, createXMLReader().read(destXMLPath));
			}
			finally {
				if (destXMLFile.exists) {
					destXMLFile.deleteFile();
				}
			}
		}
		
		/**
		 * write() のテスト
		 * 
		 * @type 異常系。
		 * @comment XMLオブジェクトがnull。
		 */
		[Test]
		public function testWrite_Error_SourceXMLIsNull():void {
			const sourceXML:XML = null;
			const destXMLName:String = "testWrite_Error_SourceXMLIsNull.xml";
			const destXMLFile:File = TEMP_DIR.resolvePath(destXMLName);
			const destXMLPath:String = destXMLFile.nativePath;
			
			try {
				const writer:XMLWriter = createXMLWriter();
				try {
					writer.write(sourceXML, destXMLPath);
					Assert.fail("Except: ArgumentError");
				}
				catch (e:ArgumentError) {
					Assert.assertFalse(destXMLFile.exists);
				}
			}
			finally {
				if (destXMLFile.exists) {
					destXMLFile.deleteFile();
				}
			}
		}
		
		/**
		 * write() のテスト
		 * 
		 * @type 異常系。
		 * @comment 出力パスがnull。
		 */
		[Test]
		public function testWrite_Error_DestinationXMLPathIsNull():void {
			const sourceXML:XML =
			<root>
				<blank />
				<test>――テスト――</test>
			</root>;
			const destXMLPath:String = null;
			
			const writer:XMLWriter = createXMLWriter();
			try {
				writer.write(sourceXML, destXMLPath);
				Assert.fail("Except: ArgumentError");
			}
			catch (e:ArgumentError) {}
		}
		
		/**
		 * write() のテスト
		 * 
		 * @type 異常系。
		 * @comment 出力パスが空文字列。
		 */
		[Test]
		public function testWrite_Error_DestinationXMLPathIsEmpty():void {
			const sourceXML:XML =
			<root>
				<blank />
				<test>――テスト――</test>
			</root>;
			const destXMLPath:String = "";
			
			const writer:XMLWriter = createXMLWriter();
			try {
				writer.write(sourceXML, destXMLPath);
				Assert.fail("Except: ArgumentError");
			}
			catch (e:ArgumentError) {}
		}
		
		/**
		 * write() のテスト
		 * 
		 * @type 異常系。
		 * @comment 出力先にファイルが既存。(上書きフラグOFF)
		 */
		[Test]
		public function testWrite_Error_FileAlreadyExist():void {
			const sourceXML:XML =
			<root>
				<blank />
				<test>――テスト――</test>
			</root>;
			const destXMLName:String = "testWrite_Error_FileAlreadyExist.xml";
			const destXMLFile:File = TEMP_DIR.resolvePath(destXMLName);
			const destXMLPath:String = destXMLFile.nativePath;
			
			try {
				createBlankFile(destXMLPath);
				
				const writer:XMLWriter = createXMLWriter();
				try {
					writer.write(sourceXML, destXMLPath);
					Assert.fail("Except: IOError");
				}
				catch (e:IOError) {
					Assert.assertMatch(/.*testWrite_Error_FileAlreadyExist\.xml.*/, e.message);
				}
			}
			finally {
				if (destXMLFile.exists) {
					destXMLFile.deleteFile();
				}
			}
		}
		
		/**
		 * write() のテスト
		 * 
		 * @type 異常系。
		 * @comment 出力先にディレクトリが既存。
		 */
		[Test]
		public function testWrite_Error_DirectoryAlreadyExist():void {
			const sourceXML:XML =
			<root>
				<blank />
				<test>――テスト――</test>
			</root>;
			const destXMLName:String = "testWrite_Error_DirectoryAlreadyExist.xml";
			const destXMLFile:File = TEMP_DIR.resolvePath(destXMLName);
			const destXMLPath:String = destXMLFile.nativePath;
			
			try {
				destXMLFile.createDirectory();
				
				const writer:XMLWriter = createXMLWriter();
				try {
					writer.write(sourceXML, destXMLPath, true);  // 明示的に上書きフラグを指定
					Assert.fail("Except: IOError");
				}
				catch (e:IOError) {
					Assert.assertTrue(destXMLFile.isDirectory);
				}
			}
			finally {
				if (destXMLFile.exists) {
					destXMLFile.deleteDirectory();
				}
			}
		}
		
		/**
		 * write() のテスト
		 * 
		 * @type 異常系。
		 * @comment 上書き対象ファイルが開かれている。
		 */
		[Test]
		public function testWrite_Error_FileIsOpened():void {
			const sourceXML:XML =
			<root>
				<blank />
				<test>――テスト――</test>
			</root>;
			const destXMLName:String = "testWrite_Error_FileIsOpened.xml";
			const destXMLFile:File = TEMP_DIR.resolvePath(destXMLName);
			const destXMLPath:String = destXMLFile.nativePath;
			
			try {
				createBlankFile(destXMLPath);
				
				const stream:FileStream = new FileStream();
				try {
					stream.open(destXMLFile, FileMode.UPDATE);
					
					const writer:XMLWriter = createXMLWriter();
					try {
						writer.write(sourceXML, destXMLPath, true);  // 明示的に上書きフラグを指定
						Assert.fail("Except: IOError");
					}
					catch (e:IOError) {}
				}
				finally {
					stream.close();
				}
			}
			finally {
				if (destXMLFile.exists) {
					destXMLFile.deleteFile();
				}
			}
		}
		
		
		
		/**
		 * 空のファイルを作成
		 * 
		 * @param destFilePath 出力ファイルパス。
		 */
		private function createBlankFile(destFilePath:String):void {
			const stream:FileStream = new FileStream();
			try {
				const destFile:File = new File(destFilePath);
				stream.open(destFile, FileMode.WRITE);
			}
			finally {
				stream.close();
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
		 * XML書き込みオブジェクトを作成
		 * 
		 * @return XML書き込みオブジェクト。
		 */
		private function createXMLWriter():XMLWriter {
			return new XMLWriterUTF8();
		}
		
		
		
		/**
		 * テスト用ディレクトリ
		 */
		private static const TEMP_DIR:File = File.applicationStorageDirectory.resolvePath("temp");
		
	}
	
}
