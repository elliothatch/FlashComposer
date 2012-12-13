package  {
	
	import flash.display.MovieClip;
	import org.si.sion.*;
	import org.si.sion.utils.SiONPresetVoice;
	import flash.sampler.StackFrame;
	import flashx.textLayout.formats.Float;
	
	public class MusicGenerator extends MovieClip {
		
		public var soundDriver:SiONDriver = new SiONDriver();
		var voicePresets:SiONPresetVoice = new SiONPresetVoice();
		var notesString:Array = new Array(); //String
		var notesData:Array = new Array(); //SiONData //= soundDriver.compile("abc");
		var initialKey:int = 0;
		var initialKeyType:int = 0;
		var currentKey:int = 0;
		var currentKeyType:int = 0;
		
		var keys:Array = new Array();
		var keyIntervalProbability:Array = new Array();
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
			var tracks:Array = new Array()
			notesString[3] += "o6"
			for(var i = 0; i<=2; i++)
			{
				tracks.push(i);
			}
			for(var j = 0; j<29; j++)
			{
				var curKey = MAJOR;
				if(j>=14)
					curKey = MINOR;
				notesString[3] += getKey(getWeightedKeyInterval(curKey)); //add random note in key of C
				if(j%4 == 0)
					generateChord(0,curKey,1,3,6,tracks);
				/*if(j<8)
					generateChord(7,MAJOR,4,3,6,tracks);
				else if(j<16)
					generateChord(14,MAJOR,4,3,6,tracks);
				else if(j<20)
					generateChord(12,MINOR,4,3,5,tracks);
				else 
					generateChord(7,MAJOR,4,3,6,tracks);
					*/
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
			
			//keyIntervalProbability.push(new Array()); //major
			var probSum = 0;
			var majorProb:Array = new Array();
			majorProb.push(10.0); //c
			majorProb.push(1.0); //c+
			majorProb.push(6.0); //d
			majorProb.push(1.0); //d+
			majorProb.push(9.0); //e
			majorProb.push(6.0); //f
			majorProb.push(1.0); //f+
			majorProb.push(9.0); //g
			majorProb.push(1.0); //g+
			majorProb.push(6.0); //a
			majorProb.push(1.0); //a+
			majorProb.push(4.0); //b
			for(var i = 0; i<11; i++)
			{
				probSum += majorProb[i];
			}
			for(i = 0; i<11; i++)
			{
				majorProb[i] /= probSum;
			}
			keyIntervalProbability.push(majorProb);
			
			probSum = 0;
			var minorProb:Array = new Array();
			minorProb.push(10.0); //c
			minorProb.push(1.0); //c+
			minorProb.push(6.0); //d
			minorProb.push(9.0); //d+
			minorProb.push(1.0); //e
			minorProb.push(6.0); //f
			minorProb.push(1.0); //f+
			minorProb.push(9.0); //g
			minorProb.push(6.0); //g+
			minorProb.push(1.0); //a
			minorProb.push(3.0); //a+
			minorProb.push(5.0); //b
			for(i = 0; i<11; i++)
			{
				probSum += minorProb[i];
			}
			for(i = 0; i<11; i++)
			{
				minorProb[i] /= probSum;
			}
			keyIntervalProbability.push(minorProb);
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
				notesString[tracks[i]] += "o"+(minOctave+Math.floor(notes[i]/chordIntervals.length)) + 
					getKey(note) + duration.toString();
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
		function getWeightedKeyInterval(keyType:int):int
		{
			var randomNum = Math.random();
			var curTotal:Number = 0.0;
			var retVal = 0;
			for(var i = 0; i<11; i++)
			{
				if(keyIntervalProbability[keyType][i]+curTotal > randomNum)
				{
					retVal = i;
					break;
				}
				curTotal += keyIntervalProbability[keyType][i];
			}
			return retVal;
		}
	}
	
}
