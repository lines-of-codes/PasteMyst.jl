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
