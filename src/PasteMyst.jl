module PasteMyst

import JSON
import HTTP

include("pastestruct.jl")

function getRequester(URI::String)
	r = HTTP.get(URI)
	if r.status != 200
		return r.status
	end
	return JSON.parse(String(r.body))
end

function getRequester(URI::String, authkey::String)
	r = HTTP.get(URI, ["Authorization"=>authkey])
	if r.status != 200
		return r.status
	end
	return JSON.parse(String(r.body))
end

# /paste (GET)

function dictToPasty(pastyinfo::Dict)
	"""
	Converts a Dictionary to Pasty (struct).
	"""
	return pasty(
		pastyinfo["_id"],
		pastyinfo["language"],
		pastyinfo["title"],
		pastyinfo["code"]
	)
end

function listToPastiesList(pasties::Vector)
	"""
	Convert a List of Pasty (Dictionary) to a List of Pasty (struct).
	"""
	out::Vector{pasty} = []
	foreach(i -> out = append!(out, [dictToPasty(i)]), pasties)
	return out
end

function dictToEdit(editinfo::Dict)
	"""
	Converts a Dictionary to Pasty (struct).
	"""
	return edit(
		editinfo["_id"],
		editinfo["editId"],
		editinfo["editType"],
		editinfo["metadata"],
		editinfo["edit"],
		editinfo["editedAt"]
	)
end

function listToEditList(edits::Vector)
	"""
	Convert a List of Pasty (Dictionary) to a List of Pasty (struct).
	"""
	out::Vector{edit} = []
	foreach(i -> out = append!(out, [dictToEdit(i)]), edits)
	return out
end

function dictToPaste(pasteinfo::Dict)
	"""
	Converts a Dicitionary into a paste struct.
	"""
	return paste(
		pasteinfo["_id"],
		pasteinfo["ownerId"],
		pasteinfo["title"],
		pasteinfo["createdAt"],
		pasteinfo["expiresIn"],
		pasteinfo["deletesAt"],
		pasteinfo["stars"],
		pasteinfo["isPrivate"],
		pasteinfo["isPublic"],
		pasteinfo["encrypted"],
		pasteinfo["tags"],
		listToPastiesList(pasteinfo["pasties"]),
		listToEditList(pasteinfo["edits"]),
	)
end

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

function getActivePastes()
	""""""
	return getRequester("https://paste.myst.rs/api/v2/data/numPastes")["numPastes"]
end

# /time (GET)

function expiresInToEpoch(createdAt::UInt64, expiresIn::String)
	"""
	Get a Unix Timestamp (Unix Epoch) from the expiresIn value.
	"""
	return getRequester(string("https://paste.myst.rs/api/v2/time/expiresInToUnixTime?createdAt=", createdAt, "&expiresIn=", expiresIn))["result"]
end

# /user (GET)

function userExist(username::String)
	"""
	Check If a User exist.
	This method returns boolean. 
	Or an Error code If there was an Error sending a Request to PasteMyst.
	Note that the User must be marked as public.
	"""
	r = HTTP.request("GET", string("https://paste.myst.rs/api/v2/user/", username, "/exists"))
	if r.status == 200
		return true
	elseif r.status == 404
		return false
	else
		return r.status
	end
end

function getUserInfo(username::String)
	"""
	Get an Info about the User from Username.
	"""
	return getRequester(string("https://paste.myst.rs/api/v2/user/", username))
end

function getCurrentUserInfo(authkey::String)
	"""
	Get a User info from the Authorization key (API key) provided.
	"""
	r = HTTP.request("GET", "https://paste.myst.rs/api/v2/user/self", ["Authorization"=>authkey])
	if r.status != 200
		return r.status
	end
	return JSON.parse(String(r.body))
end

function getCurrentUserPastes(authkey::String)
	"""
	Get the List of all Pastes the user provided has created.
	Note that the User must provide as an API key.
	"""
	r = HTTP.request("GET", "https://paste.myst.rs/api/v2/user/self/pastes", ["Authorization"=>authkey])
	if r.status != 200
		return r.status
	end
	return JSON.parse(String(r.body))
end

# /paste (POST)

function pastyCreateInfoToDict(createInfo::PastyCreateInfo)
    """
    Convert a Single PastyCreateInfo into a Dictionary
    """
	return Dict(
		"title"=>createInfo.title,
		"language"=>createInfo.language,
		"code"=>createInfo.code
	)
end

function pastiesCreateInfoToDict(createInfo::Vector{PastyCreateInfo})
	"""
	Convert all PastyCreateInfo into a Dictionary.
	"""
	pasties::Vector{Dict} = []
	foreach(i -> pasties = append!(pasties, [pastyCreateInfoToDict(i)]), createInfo)
	return pasties
end

function createInfoToDict(createInfo::PasteCreateInfo)
	"""
	Converts the PasteCreateInfo struct info a Dictionary
	"""
	return Dict(
		"title"=>createInfo.title, 
		"expiresIn"=>createInfo.expiresIn, 
		"isPrivate"=>createInfo.isPrivate,
		"isPublic"=>createInfo.isPublic,
		"tags"=>createInfo.tags,
		"pasties"=>pastiesCreateInfoToDict(createInfo.pasties)
	)
end

function createPaste(createInfo::PastyCreateInfo)
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
		[], string(JSON.json(createInfoToDict(PasteCreateInfo)))
	)
	if r.status != 200
		return false
	end
	return JSON.parse(String(r.body))
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

# /paste/ (DELETE)

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

# /paste/ (PATCH)

function pastyInfoToDict(pastyinfo::pasty)
	"""
	Converts a Pasty struct into a dictionary.
	"""
	return Dict(
		"_id"=>pastyinfo._id,
		"title"=>pastyinfo.title,
		"language"=>pastyinfo.language,
		"code"=>pastyinfo.code
	)
end

function pastiesInfoToDict(pasties::Vector{pasty})
	"""
	Converts a List of Pasty info a List of Pasties Dictionary.
	"""
	out::Vector{Dict} = []
	foreach(i -> out = append!(out, [pastyInfoToDict(i)]), pasties)
	return out
end

function pasteToDict(pasteinfo::paste)
	"""
	Converts a paste struct into a Dictionary.
	"""
	return Dict(
		"_id"=>pasteinfo._id,
		"ownerId"=>pasteinfo.ownerId,
		"title"=>pasteinfo.title,
		"createdAt"=>pasteinfo.createdAt,
		"expiresIn"=>pasteinfo.expiresIn,
		"deletesAt"=>pasteinfo.deletesAt,
		"stars"=>pasteinfo.stars,
		"isPrivate"=>pasteinfo.isPrivate,
		"isPublic"=>pasteinfo.isPublic,
		"encrypted"=>pasteinfo.encrypted,
		"tags"=>pasteinfo.tags,
		"pasties"=>pastiesInfoToDict(pasteinfo.pasties),
		"edits"=>pasteinfo.edits
	)
end

function pasteEditInfoToDict(pasteinfo::pasteEditInfo)
	"""
	This function converts pasteEditInfo into a Dictionary.
	"""
	return Dict(
		"title"=>pasteinfo.title,
		"isPrivate"=>pasteinfo.isPrivate,
		"isPublic"=>pasteinfo.isPublic,
		"tags"=>pasteinfo.tags,
		"pasties"=>pastiesInfoToDict(pasteinfo.pasties)
	)
end

function pasteToPasteEditInfo(pasteinfo::paste)
	"""
	This function converts paste into pasteEditInfo.
	"""
	return pasteEditInfo(
		pasteinfo.title,
		pasteinfo.isPrivate,
		pasteinfo.isPublic,
		pasteinfo.tags,
		pasteinfo.pasties
	)
end

function editPaste(authkey::String, pasteid::String, pasteinfo::pasteEditInfo)
	"""
	This function edit a Paste on Pastemyst.
	An Authorization key (API key) is required.
	Returns:
		Return the Returned JSON body as Paste struct.
		Else the HTTP error code.
	"""
	r = HTTP.request(
		"PATCH", 
		string("https://paste.myst.rs/api/v2/paste/", pasteid), 
		["Authorization"=>authkey, "content-type"=>"application/json"], 
		string(JSON.json(pasteEditInfoToDict(pasteinfo)))
	)
	if r.status != 200
		return r.status
	end
	return dictToPaste(JSON.parse(String(r.body)))
end

function editPaste(authkey::String, pasteid::String, pasteinfo::paste)
	"""
	This is an Overload method for the above method for passing in the paste object directly into the function.
	"""
	return editPaste(authkey, pasteid, String(pasteToPasteEditInfo(pasteinfo)))
end

end
