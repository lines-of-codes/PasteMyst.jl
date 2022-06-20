# PasteMyst.jl
PasteMyst API Wrapper for Julia.

# Documentation

## /paste
### getPaste
This function is used to retrieve a paste from the PasteMyst website.

#### Arguments
- `pasteID::String`
The ID of the paste.
- `authkey::String` (Optional)
The API key used for Authentication for retrieving private pastes.

### pasteExist
Get a paste and check if it exists.

#### Arguments
- `pasteID::String`
The ID of the paste.
- `authkey::String` (Optional)
The API key used for Authentication for checking private pastes. (If not provided and is checking private pastes, It will return false.)

## /data

### getLanguageInfoByExtension
Fetch data about a programming language from the file extension.

#### Arguments
- `extension::String`
The programming language's file extension.

### getLanguageInfoByName
Fetch data about a programming language from the programming language name.

#### Arguments
- `name::String`
The name of the programming language.

## /user
### userExist
Fetches if a user exists. This method returns either a boolean or a HTTP status code if the website returned other status code than 200 or 404.

#### Arguments
- `username::String`
The username of the user.

### getUserInfo
Get an information about a user from their username.

#### Arguments
- `username::String`
The username of the user.

### getCurrentUserInfo
Get the user from the authorization key (API key).

#### Arguments
- `authkey::String`
The authorization key (API key) used to retrieve the user.

### getCurrentUserPastes
Get the list of the pastes the user have created.

#### Arguments
- `authkey::String`
The authorization key (API key) of the user.
