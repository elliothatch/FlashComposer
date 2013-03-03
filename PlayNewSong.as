package  {
	
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class PlayNewSong extends SimpleButton {
		private var musicGenerator:MusicGenerator;
		
		public function PlayNewSong() {
			// constructor code
			this.addEventListener(MouseEvent.CLICK, playSong);
		}
		
		public function playSong(e:Event)
		{
			musicGenerator = new MusicGenerator();
		}
	}
	
}
