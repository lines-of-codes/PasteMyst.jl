# PasteMyst.jl
PasteMyst API Wrapper for Julia.

# Installation
Type `]` into the Julia REPL. 
Then type, `add PasteMyst`, then just press enter and you're ready to go!

# Documentation

## /paste
### getPaste
This function is used to retrieve a paste from the PasteMyst website.

#### Arguments
- `pasteID::String` - 
The ID of the paste.
- `authkey::String` (Optional) - 
The API key used for Authentication for retrieving private pastes.

#### Returns
A `paste` struct.

### pasteExist
Get a paste and check if it exists.

#### Arguments
- `pasteID::String` - 
The ID of the paste.
- `authkey::String` (Optional) - 
The API key used for Authentication for checking private pastes. (If not provided and is checking private pastes, It will return false.)

#### Returns
A boolean.

### createPaste
Create a paste.

#### Arguments
- `createInfo::PasteCreateInfo` - 
The information of the paste you're going to create.
- `authkey::String` (Optional) - 
The authentication key (API key) used for creating a paste on an account.

#### Returns
The `paste` struct of the created paste.

### deletePaste
Deletes a paste.

#### Arguments
- `authkey::String` - 
The authentication key (API key) used for deleting a paste the account owning this key owned.
- `pasteID::String` - 
The ID of the paste you wanted to delete.

#### Returns
None, Or a HTTP response code in case the website didn't return 200 as the HTTP status code.

### editPaste
Edits a paste.

#### Arguments
- `authkey::String` - 
The authentication key (API key) used for editing a paste the account owning this key owned.
- `pasteID::String` -
The ID of the paste you wanted to edit.
- `pasteinfo::pasteEditInfo` or `paste` - 
The information of the edit. So that it's easy to use, I've made an overload of this function where you can directly pass the edited paste object into the function instead of doing the conversion from `paste` to `pasteEditInfo` manually.

#### Returns
A `paste` struct, or a HTTP code if the request didn't return a 200 as the status.

## /data

### getLanguageInfoByExtension
Fetch data about a programming language from the file extension.

#### Arguments
- `extension::String`
The programming language's file extension.

#### Returns
<table>
    <thead>
        <tr>
            <td>Field</td>
            <td>Type</td>
            <td>Description</td>
            <td>Nullable</td>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>name</td>
            <td>String</td>
            <td>The name of the language.</td>
            <td>No</td>
        </tr>
        <tr>
            <td>mode</td>
            <td>String</td>
            <td>The language mode to be used in the editor.</td>
            <td>No</td>
        </tr>
        <tr>
            <td>mimes</td>
            <td>Vector{String}</td>
            <td>List of mimes used by the language.</td>
            <td>No</td>
        </tr>
        <tr>
            <td>ext</td>
            <td>Vector{String}</td>
            <td>List of file extensions used by the language.</td>
            <td>Yes</td>
        </tr>
        <tr>
            <td>color</td>
            <td>String</td>
            <td>The color representing the language.</td>
            <td>Yes</td>
        </tr>
    </tbody>
</table>

### getLanguageInfoByName
Fetch data about a programming language from the programming language name.

#### Arguments
- `name::String`
The name of the programming language.

#### Returns
<table>
    <thead>
        <tr>
            <td>Field</td>
            <td>Type</td>
            <td>Description</td>
            <td>Nullable</td>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>name</td>
            <td>String</td>
            <td>The name of the language.</td>
            <td>No</td>
        </tr>
        <tr>
            <td>mode</td>
            <td>String</td>
            <td>The language mode to be used in the editor.</td>
            <td>No</td>
        </tr>
        <tr>
            <td>mimes</td>
            <td>Vector{String}</td>
            <td>List of mimes used by the language.</td>
            <td>No</td>
        </tr>
        <tr>
            <td>ext</td>
            <td>Vector{String}</td>
            <td>List of file extensions used by the language.</td>
            <td>Yes</td>
        </tr>
        <tr>
            <td>color</td>
            <td>String</td>
            <td>The color representing the language.</td>
            <td>Yes</td>
        </tr>
    </tbody>
</table>

### getActivePastesNumber
Get the number of active pastes on PasteMyst.

#### Arguments
None

#### Returns
An Int64 of the active pastes.

## /user
### userExist
Fetches if a user exists.

#### Arguments
- `username::String`
The username of the user.

#### Returns
A boolean or a HTTP status code if the website returned other status code than 200 or 404.

### getUserInfo
Get an information about a user from their username.

#### Arguments
- `username::String`
The username of the user.

#### Returns
<table>
    <thead>
        <tr>
            <td>Field</td>
            <td>Type</td>
            <td>Description</td>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>_id</td>
            <td>String</td>
            <td>The ID of the user.</td>
        </tr>
        <tr>
            <td>username</td>
            <td>String</td>
            <td>The username of the user.</td>
        </tr>
        <tr>
            <td>avatarUrl</td>
            <td>String</td>
            <td>The URL of their avatar image.</td>
        </tr>
        <tr>
            <td>defaultLang</td>
            <td>String</td>
            <td>The default language.</td>
        </tr>
        <tr>
            <td>publicProfile</td>
            <td>Bool</td>
            <td>If they had a public profile or not.</td>
        </tr>
        <tr>
            <td>supporterLength</td>
            <td>UInt32</td>
            <td>How long has the user been a supporter for, 0 if not a supporter.</td>
        </tr>
        <tr>
            <td>contributor</td>
            <td>Bool</td>
            <td>If a user is a contributor of PasteMyst.</td>
        </tr>
    </tbody>
</table>

### getCurrentUserInfo
Get the user from the authorization key (API key).

#### Arguments
- `authkey::String`
The authorization key (API key) used to retrieve the user.

#### Returns
<table>
    <thead>
        <tr>
            <td>Field</td>
            <td>Type</td>
            <td>Description</td>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>_id</td>
            <td>String</td>
            <td>The ID of the user.</td>
        </tr>
        <tr>
            <td>username</td>
            <td>String</td>
            <td>The username of the user.</td>
        </tr>
        <tr>
            <td>avatarUrl</td>
            <td>String</td>
            <td>The URL of their avatar image.</td>
        </tr>
        <tr>
            <td>defaultLang</td>
            <td>String</td>
            <td>The default language.</td>
        </tr>
        <tr>
            <td>publicProfile</td>
            <td>Bool</td>
            <td>If they had a public profile or not.</td>
        </tr>
        <tr>
            <td>supporterLength</td>
            <td>UInt32</td>
            <td>How long has the user been a supporter for, 0 if not a supporter.</td>
        </tr>
        <tr>
            <td>contributor</td>
            <td>Bool</td>
            <td>If a user is a contributor of PasteMyst.</td>
        </tr>
        <tr>
            <td>stars</td>
            <td>Vector{String}</td>
            <td>List of paste IDs of the paste user has starred.</td>
        </tr>
        <tr>
            <td>serviceIds</td>
            <td>Dict</td>
            <td>User IDs of the service the user used to create an account.</td>
        </tr>
    </tbody>
</table>

### getCurrentUserPastes
Get the list of the pastes the user have created.

#### Arguments
- `authkey::String`
The authorization key (API key) of the user.

#### Returns
A list of paste IDs. (Type of `Vector{String}`)

## Structs
### `pasty`
A Pasty.

This struct is mutable.

#### Fields
- `_id::String` - ID of the pasty.
- `language::String` - Language of the pasty.
- `title::String` - Title of the pasty.
- `code::String` - Contents of the pasty.

### `edit`
An information about an edit in a paste.

This struct is **not** mutable.

#### Fields
- `_id::String` - A unique ID of the edit.
- `editId::String` - ID of the edit, Multiple edits can share the same ID representing that multiple fields were changed at the same time.
- `editType::Number` - Type of the edit. Possible values are 0 (Title), 1 (Pasty title), 2 (Pasty language), 3 (Pasty content), 4 (Pasty added), 5 (Pasty removed)
- `metadata::Vector{String}` - Various metadata used internally by PasteMyst.
- `edit::String` - Stores the old data before the edit.
- `editedAt::Number` - The time when the edit was made in Unix timestamp.

### `pasteEditInfo`
A struct used for sending edit requests.

This struct is mutable.

#### Fields
- `title::String` - The paste title.
- `isPrivate::Bool` - A boolean value indicating if a paste is private.
- `isPublic::Bool` - A boolean value indicating if a paste is public.
- `tags::Vector{String}` - The list of tags.
- `pasties::Vector{pasty}` - The list of pasty in the paste, This cannot be empty.

### `paste`
A struct representing a paste.

This struct is mutable.

#### Fields
- `_id::String` - The ID of the paste.
- `ownerId::String` - The ID of the owner. If it doesn't have an owner, The value will be "".
- `title::String` - The paste title.
- `createdAt::UInt64` - A unix timestamp of when the paste is created.
- `expiresIn::String` - When the paste will expire, possible values are `never`, `1h`, `2h`, `10h`, `1d`, `2d`, `1w`, `1m`, `1y`.
- `deletesAt::UInt64` - When the paste will be deleted, if it has no expiry time it's set to 0.
- `stars::UInt64` - The number of stars the paste received.
- `isPrivate::Bool` - A boolean value indicating if a paste is private.
- `isPublic::Bool` - A boolean value indicating if a paste is public.
- `tags::Vector{String}` - The list of tags.
- `pasties::Vector{pasty}` - The list of pasty in the paste, This cannot be empty.
- `edits::Vector{edit}` - Edit history.

### `PastyCreateInfo`
The required information to create a pasty.

This struct is **not** mutable.

#### Fields
- `title::String` - The title of the pasty.
- `language::String` - The programming language of the content of the pasty.
- `code::String` - Contents of the pasty.

### `PasteCreateInfo`
The required information to create a paste.

This struct is **not** mutable.

#### Fields
- `title::String` - The title of the paste.
- `expiresIn::String` - When the paste will expire, possible values are `never`, `1h`, `2h`, `10h`, `1d`, `2d`, `1w`, `1m`, `1y`.
- `isPrivate::Bool` - A boolean value indicating if a paste is private.
- `isPublic::Bool` - A boolean value indicating if a paste is public.
- `tags::Vector{String}` - The list of tags.
- `pasties::Vector{pasty}` - The list of pasty in the paste, This cannot be empty.
