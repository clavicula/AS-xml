package wiz.xml　{
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	
	
	/**
	 * UTF-8形式によるXML読み込み
	 */
	public class XMLReaderUTF8 implements XMLReader {
		
		/**
		 * コンストラクタ
		 */
		public function XMLReaderUTF8() {
		}
		
		
		
		/**
		 * XMLを読み込む
		 */
		public　function read(sourceXMLPath:String):XML {
			if (!sourceXMLPath) {
				throw new ArgumentError("Source XML file path is empty.");
			}
			
			const sourceXML:File = new File(sourceXMLPath);
			const stream:FileStream = new FileStream();
			try {
				stream.open(sourceXML, FileMode.READ);
				const data:XML = new XML(stream.readUTFBytes(sourceXML.size));
			}
			finally {
				stream.close();
			}
			return data;
		}
		
	}
	
}
