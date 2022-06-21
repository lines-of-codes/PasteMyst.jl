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
