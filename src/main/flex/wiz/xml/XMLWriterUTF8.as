package wiz.xml {
	
	import flash.errors.IOError;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	
	
	/**
	 * UTF-8形式によるXML書き込み
	 */
	public class XMLWriterUTF8 implements XMLWriter {
		
		/**
		 * コンストラクタ
		 */
		public function XMLWriterUTF8() {
		}
		
		/**
		 * XMLを書き込む
		 */
		public function write(sourceXML:XML, destXMLPath:String, overwrite:Boolean = false):void {
			if (!sourceXML) {
				throw new ArgumentError("Source XML node data is null.");
			}
			if (!destXMLPath) {
				throw new ArgumentError("Destination XML file path is empty.");
			}
			
			const destXML:File = new File(destXMLPath);
			if (!overwrite) {
				if (destXML.exists) {
					throw new IOError("File already exist : " + destXMLPath);
				}
			}
			
			const stream:FileStream = new FileStream();
			try {
				stream.open(destXML, FileMode.WRITE);
				stream.writeUTFBytes(sourceXML);
				stream.writeUTFBytes("\n");
			}
			finally {
				stream.close();
			}
		}
		
	}
	
}
