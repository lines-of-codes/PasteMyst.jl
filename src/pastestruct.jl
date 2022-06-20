mutable struct pasty
	_id::String
	language::String
	title::String
	code::String
end

struct edit
	_id::String
	editId::Number
	editType::Number
	metadata::Vector{String}
	edit::String
	editedAt::Number
end

mutable struct pasteEditInfo
	title::String
	isPrivate::Bool
	isPublic::Bool
	tags::Vector{String}
	pasties::Vector{pasty}
end

mutable struct paste
	_id::String
	ownerId::String
	title::String
	createdAt::UInt64
	expiresIn::String
	deletesAt::UInt64
	stars::UInt64
	isPrivate::Bool
	isPublic::Bool
	encrypted::Bool
	tags::Vector{String}
	pasties::Vector{pasty}
	edits::Vector{edit}
end

struct PastyCreateInfo
	title::String
	language::String
	code::String
end

struct PasteCreateInfo
	title::String # Optional
	expiresIn::String # Optional
	isPrivate::Bool # Optional
	isPublic::Bool # Optional
	tags::Vector{String} # Tags
	pasties::Vector{PastyCreateInfo} # Mandatory
end
