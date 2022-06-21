# /paste (GET)

function getPaste(pasteID::String)
	"""
	Get a Paste from the ID specified. (without authorization header)
	"""
	return dictToPaste(getRequester(string("https://paste.myst.rs/api/v2/paste/", pasteID)))
end

function getPaste(pasteID::String, authkey::String)
	"""
	Get a Paste from the ID specified. (with authorization header)
	"""
	return dictToPaste(getRequester(string("https://paste.myst.rs/api/v2/paste/", pasteID), authkey))
end

function pasteExist(pasteID::String)
	"""
	Get a paste then check If it exist. (without authorization header)
	"""
	r = HTTP.get(string("https://paste.myst.rs/api/v2/paste/", pasteID))
	if r.status != 200
		return false
	end
	return true
end

function pasteExist(pasteID::String, authkey::String)
	"""
	Get a paste then check If it exist. (with authorization header)
	"""
	r = HTTP.get(string("https://paste.myst.rs/api/v2/paste/", pasteID), ["Authorization"=>authkey])
	if r.status != 200
		return false
	end
	return true
end

# /paste (POST)

function createPaste(createInfo::PasteCreateInfo)
	"""
	This method create a Paste on PasteMyst website without a Authorization key (API key).
	Returns:
		The paste object If the Paste is successfully created.
		Else return false
	"""
	if (createInfo.Tags != "")
		return false
	end

	r = HTTP.request("POST", "https://paste.myst.rs/api/v2/paste/", 
		["content-type"=>"application/json"], string(JSON.json(createInfoToDict(PasteCreateInfo)))
	)
	if r.status != 200
		return false
	end
	return dictToPaste(JSON.parse(String(r.body)))
end


function createPaste(createInfo::PasteCreateInfo, authkey::String)
	"""
	This method create a Paste on PasteMyst website with an Authorization key (API key).
	Returns:
		The paste object If the Paste is successfully created.
		Else return false
	"""
	r = HTTP.request("POST", "https://paste.myst.rs/api/v2/paste/",
		["Authorization"=>authkey, "content-type"=>"application/json"],
		string(JSON.json(createInfoToDict(createInfo)))
	)
	if r.status != 200
		return false
	end
	return dictToPaste(JSON.parse(String(r.body)))
end

# /paste (DELETE)

function deletePaste(authkey::String, pasteID::String)
	"""
	This function delete a Paste on PasteMyst.
	This method requires the Authorization key (API key) to work.
	"""
	r = HTTP.request("DELETE", string("https://paste.myst.rs/api/v2/paste/", pasteID), ["Authorization"=>authkey])
	if r.status != 200
		return r.status
	end
end

# /paste (PATCH)

function editPaste(authkey::String, pasteID::String, pasteinfo::pasteEditInfo)
	"""
	This function edit a Paste on Pastemyst.
	An Authorization key (API key) is required.
	Returns:
		Return the Returned JSON body as Paste struct.
		Else the HTTP error code.
	"""
	r = HTTP.request(
		"PATCH", 
		string("https://paste.myst.rs/api/v2/paste/", pasteID), 
		["Authorization"=>authkey, "content-type"=>"application/json"], 
		string(JSON.json(pasteEditInfoToDict(pasteinfo)))
	)
	if r.status != 200
		return r.status
	end
	return dictToPaste(JSON.parse(String(r.body)))
end

function editPaste(authkey::String, pasteID::String, pasteinfo::paste)
	"""
	This is an Overload method for the above method for passing in the paste object directly into the function.
	"""
	return editPaste(authkey, pasteID, String(pasteToPasteEditInfo(pasteinfo)))
end
