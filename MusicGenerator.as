package  {
	
	import flash.display.MovieClip;
	import org.si.sion.*;
	import org.si.sion.utils.SiONPresetVoice;
	import flash.sampler.StackFrame;
	
	public class MusicGenerator extends MovieClip {
		
		public var soundDriver:SiONDriver = new SiONDriver();
		var voicePresets:SiONPresetVoice = new SiONPresetVoice();
		var notesString:Array = new Array(); //String
		var notesData:Array = new Array(); //SiONData //= soundDriver.compile("abc");
		var currentKey:int = 0;
		var currentKeyType:int = 0;
		
		var keys:Array = new Array();
		var MAJOR = 0;
		var MINOR = 1;
		var DIMINISHED = 2;
		
		public function MusicGenerator() {
			// constructor code
			initializeKeys();
			notesString.push(new String());
			notesString.push(new String());
			notesString.push(new String());
			notesString.push(new String());
			notesString.push(new String());
			for(var j = 0; j<50; j++)
			{
				var tracks:Array = new Array()
				for(var i = 0; i<=randomIntDistribution(0,4); i++)
				{
					tracks.push(i);
				}
				if(j<8)
					generateChord(7,MAJOR,4,3,6,tracks);
				else if(j<16)
					generateChord(14,MAJOR,4,0,2,tracks);
				//else if(j<20)
					//generateChord(12,MINOR,4,0,2,tracks);
				//else 
					//generateChord(7,MAJOR,4,3,6,tracks);
			}
			//notesString.push(generateAccompaniment());
			for(i = 0; i< notesString.length; i++)
			{
				notesData.push(soundDriver.compile(notesString[i]));
				trace(notesString[i]);
			}
			soundDriver.play("l1 r");
			for(i = 0; i< notesData.length; i++)
			{
				soundDriver.sequenceOn(notesData[i],null,0,0,1,i+1);
			}
			//soundDriver.sequenceOn(notes1,null,0,0,1,1);
			//soundDriver.sequenceOn(notes2,null,0,0,1,2);
		}
		
		function initializeKeys()
		{
			keys.push(new String("c"));
			keys.push(new String("c+"));
			keys.push(new String("d"));
			keys.push(new String("d+"));
			keys.push(new String("e"));
			keys.push(new String("f"));
			keys.push(new String("f+"));
			keys.push(new String("g"));
			keys.push(new String("g+"));
			keys.push(new String("a"));
			keys.push(new String("a+"));
			keys.push(new String("b"));
		}
		
		function getKey(key:int):String
		{
			return keys[key%keys.length];
		}
		
		function generateChord(key:int, keyType:int, duration:int, minOctave:int, maxOctave:int, tracks:Array)
		{
			//major
			var notes:Array = new Array();
			var chordIntervals = getKeyChordIntervals(key, keyType);
			for(var i = 0; i< tracks.length; i++)
			{
				var note:int = randomIntDistribution(0,(maxOctave-minOctave+1)*chordIntervals.length);
				if(notes.indexOf(note) < 0)
					notes.push(note);
				else
				{
					i--;
				}
				
			}
			notes.sort(Array.NUMERIC);
			for(i = 0; i<notes.length; i++)
			{
				note = chordIntervals[notes[i]%chordIntervals.length];
				notesString[tracks[i]] += "o"+(minOctave+Math.floor(notes[i]/chordIntervals.length)) + getKey(note);
			}
		}
		
		function generateAccompaniment():String
		{
			var notes:String = new String();
			notes = "l4 ";
			/*
			for(var i = 0; i<keys.length; i++)
			{
				notes += keys[i]
				notes += "8";
			}
			*/
			notes += getKey(0); //c
			notes += getKey(4); //e
			notes += getKey(7); //g
			notes += "o6";
			notes += getKey(12); //c
			return notes;
		}
		
		function decorateAccompaniment(notes:String):String
		{
			return notes;
		}
		
		function randomIntDistribution(min:int, max:int):int
		{
			return min + Math.floor(Math.random()*(max-min));
		}
		function getKeyChordIntervals(key:int, keyType:int):Array
		{
			var retArray:Array = new Array();
			switch(keyType)
			{
				case MAJOR:
					retArray.push(0,4,7);
					break;
				case MINOR:
					retArray.push(0,3,7);
					break;
				case DIMINISHED:
					retArray.push(0,3,6,9);
			}
			for(var i = 0; i<retArray.length; i++)
			{
				retArray[i] = (retArray[i] + key) % keys.length;
			}
			return retArray;
		}
	}
	
}
