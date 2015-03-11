package wiz.test {
	
	import wiz.xml.XMLReaderUTF8Test;
	import wiz.xml.XMLWriterUTF8Test;
	
	
	
	/**
	 * テストスイート
	 */
	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public final class XMLParserTestSuite {
		public var xmlReaderUTF8Test:wiz.xml.XMLReaderUTF8Test;
		public var xmlWriterUTF8Test:wiz.xml.XMLWriterUTF8Test;
	}
	
}
