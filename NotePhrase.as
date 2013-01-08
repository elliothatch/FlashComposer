package  {
	
	import flash.display.MovieClip;
	
	
	public class NotePhrase extends MovieClip {
		
		private var phraseNotes:String;
		private var numBeats:Number;
		
		public function NotePhrase(notes:String = "") {
			//constructor code
			resetNotes(notes);
		}
		
		public function resetNotes(notes:String = ""):void
		{
			phraseNotes = notes;
			//process number of beats
			var noteBeats:Array = notes.slice().match(/(?<!o)\d+/g);
			numBeats = 0;
			for(var i = 0; i<noteBeats.length; i++)
			{
				var noteString:String = noteBeats[i];
				if(noteString.length)
				{
					numBeats += 1/int(noteString.toString());
				}
			}
			
		}
		
		public function getNotes():String
		{
			return phraseNotes;
		}
		
		public function getNumBeats():Number
		{
			return numBeats;
		}
		public function embellishPhrase()
		{
			
		}
	}
	
}
