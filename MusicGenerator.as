package  {
	
	import flash.display.MovieClip;
	import org.si.sion.*;
	import org.si.sion.utils.SiONPresetVoice;
	import flash.sampler.StackFrame;
	import flashx.textLayout.formats.Float;
	import org.si.sound.patterns.Sequencer;
	import org.si.sound.SoundObject;
	
	public class MusicGenerator extends MovieClip {
		
		static public var soundDriver:SiONDriver = new SiONDriver();
		static var voicePresets:SiONPresetVoice = new SiONPresetVoice();
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
			//notesString[3] += "o6"
			for(var i = 0; i<=2; i++)
			{
				tracks.push(i);
			}
			currentKey = randomIntDistribution(0,11);
			for(var j = 0; j<29; j++)
			{
				var curKey = MAJOR;
				var curKeyNote = 0+currentKey;
				
				if(j<8)
					curKeyNote = 7+currentKey;
				else if(j<16)
					curKeyNote = 14+currentKey;
				else if(j<20)
				{
					curKeyNote = 12+currentKey;
					curKey = MINOR;
				}
				else
				{
					curKeyNote = 7+currentKey;
					curKey = MAJOR
				}
				
				//notesString[3] += getKey(getWeightedKeyInterval(curKey)+curKeyNote); //add random melody note
				//notesString[3] += "4";
				if(j%4 == 0)
				{
					generateChord(curKeyNote,curKey,1,3,6,tracks);
				}
				if(j%4 == 0)
				{
					var melodyLine:NotePhrase = generateMelodyPhrase(curKeyNote,curKey,4,1,6,6,5);
					notesString[3] += melodyLine.getNotes();
				}
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
				if(i<3)
					soundDriver.sequenceOn(notesData[i],voicePresets["midi.organ1"],0,0,1,i+1);
				else
					soundDriver.sequenceOn(notesData[i],voicePresets["valsound.wind1"],0,0,1,i+1);
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
			majorProb.push(0.0); //c+
			majorProb.push(6.0); //d
			majorProb.push(0.0); //d+
			majorProb.push(9.0); //e
			majorProb.push(6.0); //f
			majorProb.push(0.0); //f+
			majorProb.push(9.0); //g
			majorProb.push(0.0); //g+
			majorProb.push(6.0); //a
			majorProb.push(0.0); //a+
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
			minorProb.push(0.0); //c+
			minorProb.push(6.0); //d
			minorProb.push(9.0); //d+
			minorProb.push(0.0); //e
			minorProb.push(6.0); //f
			minorProb.push(0.0); //f+
			minorProb.push(9.0); //g
			minorProb.push(6.0); //g+
			minorProb.push(0.0); //a
			minorProb.push(6.0); //a+
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
		
		function generateMelodyPhrase(key:int, keyType:int, measureLength:int, measureCount:int,
									  minOctave:int, maxOctave:int, speed:int):NotePhrase
		{
			//speed defines how energetic the phrase is
			var melodyNotes:String = "";
			var melodyRhythms:Array = new Array();
			//iterate through measures, create rhythms
			for(var i = 0; i<measureCount; i++)
			{
				recursiveSplitBeat(melodyRhythms, measureLength/4);//assuming 4/4 time signature
			}
			for(i = 0; i<melodyRhythms.length; i++)
			{
				melodyNotes += "o";
				melodyNotes += minOctave.toString();
				melodyNotes += getKey(getWeightedKeyInterval(keyType)+key); //add random melody note
				melodyNotes += melodyRhythms[i].toString();
			}
			var melodyPhrase:NotePhrase = new NotePhrase(melodyNotes);
			return melodyPhrase;
		}
		function recursiveSplitBeat(beats:Array, beatLength:int):void
		{
			if(Math.random() < 0.75 - beatLength*0.1)//split
			{
				var dupleProbability = 0.8;
				if(beatLength % 3 == 0) //if divisible by three - increase probability of 3s
				{
					dupleProbability = 0.5;
				}
				else
				{
					dupleProbability = 0.95;
				}
				if(Math.random() < dupleProbability)
				{
					recursiveSplitBeat(beats,beatLength*2);
					recursiveSplitBeat(beats,beatLength*2);
				}
				else
				{
					recursiveSplitBeat(beats,beatLength*3);
					recursiveSplitBeat(beats,beatLength*3);
					recursiveSplitBeat(beats,beatLength*3);
				}
			}
			else //end the branch
			{
				beats.push(beatLength);
			}
		}
	}	
}
