package  {
	
	import flash.display.MovieClip;
	import flash.utils.ByteArray;
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
	
	public class DynamicSoundGenerator extends MovieClip 
	{
		var finalSound:Sound;
		var soundBytes:ByteArray;
		var soundChannel:SoundChannel;
		
		public function DynamicSoundGenerator() {
			// constructor code
			soundChannel = new SoundChannel();
			finalSound = new Sound();
			soundBytes = CreateTone(8, 10, 0.5);
			OnPlay();
		}
		
		function OnPlay():void
		{
			finalSound.addEventListener(SampleDataEvent.SAMPLE_DATA, addSoundBytesToSound);

			finalSound.play();
			//soundChannel = finalSound.play();
		}
		
		function CreateTone(pitch:Number, length:Number, amplitude:Number):ByteArray
		{
			var returnBytes:ByteArray = new ByteArray();
			for ( var i:int = 0; i < length * 2400; i++ ) 
			{
				var value:Number = Math.sin(i / pitch) * amplitude;
				returnBytes.writeFloat(value);
				returnBytes.writeFloat(value);
			}
			returnBytes.position = 0;
			return returnBytes;
		}
		
		function addSoundBytesToSound(event:SampleDataEvent):void
		{
			var bytes:ByteArray = new ByteArray();
			soundBytes.readBytes(bytes, 0, Math.min(soundBytes.bytesAvailable, 8*8192));
			event.data.writeBytes(bytes, 0, bytes.length);
		}
		
	}
}
