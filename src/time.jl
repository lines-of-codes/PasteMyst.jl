# /time (GET)

function expiresInToEpoch(createdAt::UInt64, expiresIn::String)
	"""
	Get a Unix Timestamp (Unix Epoch) from the expiresIn value.
	"""
	return getRequester(string("https://paste.myst.rs/api/v2/time/expiresInToUnixTime?createdAt=", createdAt, "&expiresIn=", expiresIn))["result"]
end
