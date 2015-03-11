package wiz.xml　{
	
	/**
	 * XML書き込み
	 */
	public interface XMLWriter {
		
		/**
		 * XMLを書き込む
		 * 
		 * @param sourceXML XMLのルートノード。
		 * @param destXMLPath 書き込み対象XMLのパス。
		 * @param overwrite 既存ファイルに対して上書きするか。
		 */
		function write(sourceXML:XML, destXMLPath:String, overwrite:Boolean = false):void;
		
	}
	
}
