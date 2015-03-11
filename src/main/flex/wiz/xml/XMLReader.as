package wiz.xml {
	
	/**
	 * XML読み込み
	 */
	public interface XMLReader {
		
		/**
		 * XMLを読み込む
		 * 
		 * @param sourceXMLPath 読み込み対象XMLのパス。
		 * @return XMLのルートノード。
		 */
		function read(sourceXMLPath:String):XML;
		
	}
	
}
