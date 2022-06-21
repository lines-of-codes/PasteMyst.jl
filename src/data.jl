# /data (GET)

function getLanguageInfoByExtension(extension::String)
	"""
	Get a Data about the Language from Extension.
	"""
	return getRequester(string("https://paste.myst.rs/api/v2/data/languageExt?extension=", extension))
end

function getLanguageInfoByName(name::String)
	"""
	Get a Data about the Language by Name.
	Note that the Name must be Percent encoded.
	"""
	return getRequester(string("https://paste.myst.rs/api/v2/data/language?name=", name))
end

function getActivePastesNumber()
	"""
	Get the number of active pastes on PasteMyst.
	"""
	return getRequester("https://paste.myst.rs/api/v2/data/numPastes")["numPastes"]
end
