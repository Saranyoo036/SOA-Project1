function reqTranslateListener( event )
	if (event.phase == "ended") then
		audio.play(audio.loadSound(event.response.filename,system.DocumentsDirectory))
	end
end

function reqTranslate( text, lang )
	network.download(
	 	"http://translate.google.com/translate_tts?ie=UTF-8&q=" .. text .. "&tl=" .. lang .."&client=tw-ob",
	 	"GET",
	 	reqTranslateListener,
	 	{},
	 	math.random(150000) .. ".mp3",
	 	system.DocumentsDirectory
		)
end